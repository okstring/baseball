package com.eNoLJ.baseball.service;

import com.eNoLJ.baseball.authorization.GitHubOAuth;
import com.eNoLJ.baseball.authorization.OAuth;
import com.eNoLJ.baseball.domain.user.User;
import com.eNoLJ.baseball.domain.user.UserRepository;
import com.eNoLJ.baseball.exception.EntityNotFoundException;
import com.eNoLJ.baseball.exception.ErrorMessage;
import com.eNoLJ.baseball.web.dto.EmailDTO;
import com.eNoLJ.baseball.web.dto.TokenDTO;
import com.eNoLJ.baseball.web.dto.UserInfoDTO;
import com.eNoLJ.baseball.web.dto.UserResponseDTO;
import org.springframework.stereotype.Service;

@Service
public class UserService {

    private final UserRepository userRepository;
    private final OAuth gitHubOAuth;

    public UserService(UserRepository userRepository, GitHubOAuth gitHubOAuth) {
        this.userRepository = userRepository;
        this.gitHubOAuth = gitHubOAuth;
    }

    public UserResponseDTO login(String code) {
        TokenDTO tokenDTO = tokenRequestApi(code);
        UserInfoDTO userInfoDTO = userInfoRequestApi(tokenDTO.getAccess_token());
        EmailDTO emailDTO = emailRequestApi(tokenDTO.getAccess_token());

        if (verifyUser(emailDTO)) {
            User user = findByEmail(emailDTO);
            user.update(userInfoDTO, emailDTO, tokenDTO);
            return new UserResponseDTO(userRepository.save(user));
        }
        User user = new User(userInfoDTO, emailDTO, tokenDTO);
        return new UserResponseDTO(userRepository.save(user));
    }

    public void logout(String token) {
        User user = findByToken(token);
        user.removeToken();
        userRepository.save(user);
    }

    private TokenDTO tokenRequestApi(String code) {
        return gitHubOAuth.getTokenAPI(code);
    }

    private UserInfoDTO userInfoRequestApi(String token) {
        return gitHubOAuth.getUserInfoAPI(token);
    }

    private EmailDTO emailRequestApi(String token) {
       return gitHubOAuth.getEmailAPI(token);
    }

    private boolean verifyUser(EmailDTO emailDTO) {
        return userRepository.findByEmail(emailDTO.getEmail()).isPresent();
    }

    private User findByEmail(EmailDTO emailDTO) {
        return userRepository.findByEmail(emailDTO.getEmail()).orElseThrow(
                () -> new EntityNotFoundException(ErrorMessage.ENTITY_NOT_FOUND)
        );
    }

    private User findByToken(String token) {
        return userRepository.findByToken(token).orElseThrow(
                () -> new EntityNotFoundException(ErrorMessage.ENTITY_NOT_FOUND)
        );
    }
}
