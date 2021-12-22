function playVideo(video)

% Simple function to just play a video

    for i = 1:size(video,4)
        image = flipdim(video(:, :, :, i),2);

        if length(video(1,1,:,1)) == 1
            image = imadjust(image);
        end

        imshow(image)
        % play at 30fps
        pause(1/30)
    end

end

