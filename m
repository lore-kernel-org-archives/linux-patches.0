Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 527667FD
	for <patches@lists.linux.dev>; Thu,  1 Sep 2022 08:42:26 +0000 (UTC)
Received: by mail-lf1-f43.google.com with SMTP id j14so13042063lfu.4
        for <patches@lists.linux.dev>; Thu, 01 Sep 2022 01:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=RvfIkWc0bW8B7wnGaAcM/Ac2S5bgNnC3+MvXeeZ8fuk=;
        b=eRLDtnk9qCQJEwuChBabwNsXau6eGMaipUQ3wrr1P5QJyAo8ubW3G8T/7Eg1I7JCKg
         6BB9O/e6efJTNIr3w4O4xEcNnSTIQChDAXVannRrAX6lhl6/Pti++etEz5rDUMR9GkxQ
         2ATUNY4AmrdsgN8abNyz4E0ecc+koIWTb1top4tFJPoc9BiOOwhKDpdNvwHe84vTdoV7
         Oofn8CwOKXVEfP45iB7dZ0hkyzodUaOnwGpt5Y0ms6BXqj+WsHQWunY7sb8Kg+yro58t
         acqvNAoM1/QfXNaNrmniEjQkPj+N2KmqH8/A7OBN8WlvH9i9IC1N8FYr/f/YZuYaCuhY
         WCgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=RvfIkWc0bW8B7wnGaAcM/Ac2S5bgNnC3+MvXeeZ8fuk=;
        b=C05DcoUp1DXJai8j7tyEBGKZ8SBk5NJLAqROHgJq3qqlgfbMFlK7u7WjSZRQCWV/QC
         OwiizoAcxNrUPe3xQAbWzwTzZlWTPa78aKlvffnZ8l39wplyhI+v/y6uJEZu4oEOXCrr
         9iVqxfakNPfa9SaDjQmY7JisOBw66ZHZW8OY4nOSkKO0paXA4CTVDZZ9E8rbkPnV1S96
         yqV1kgsOBBK/E87iwjFqvf3spTef6O5w3DHjSTYygSv6xugqHf6+TF3S1jvh/qc74zg8
         KuxHqfOXdyibO5shwQvxH1k7n0laaYEFNyswZmhBq0A8tV9OVgBXpdeW3uV5JxwGG18T
         s9fQ==
X-Gm-Message-State: ACgBeo3yWZS+2klIh57VhZoMOr7UXXzFsKeSdzS1lU00EKn/h2zmY401
	UdTgkH4nNpIq7q4Szl24FRbj+g==
X-Google-Smtp-Source: AA6agR7hAot1/XTvtAntt8TEbAoNfzNE+fTLSxY8/82G5LZY2RV30hpblCF1wuPvOUz0eoWcoxq2Ng==
X-Received: by 2002:a05:6512:12c5:b0:48c:df54:a41a with SMTP id p5-20020a05651212c500b0048cdf54a41amr9799353lfg.464.1662021744393;
        Thu, 01 Sep 2022 01:42:24 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id i3-20020a2ea223000000b00262fa7bae79sm1992830ljm.81.2022.09.01.01.42.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Sep 2022 01:42:22 -0700 (PDT)
Message-ID: <23615048-dae5-d972-9b10-ff1356c0a02f@linaro.org>
Date: Thu, 1 Sep 2022 11:42:22 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] drm/msm/dsi: Set panel orientation when directly
 connected
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Hsin-Yi Wang <hsinyi@chromium.org>,
 Douglas Anderson <dianders@chromium.org>
References: <20220706191442.1150634-1-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220706191442.1150634-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/07/2022 22:14, Stephen Boyd wrote:
> Set the panel orientation in drm when the panel is directly connected,
> i.e. we're not using an external bridge. The external bridge case is
> already handled by the panel bridge code, so we only update the path we
> take when the panel is directly connected/internal. This silences a
> warning splat coming from __drm_mode_object_add() on Wormdingler boards.
> 
> Cc: Hsin-Yi Wang <hsinyi@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
> 
> This relies on commit 5e41b01a7808 ("drm/panel: Add an API to allow drm
> to set orientation from panel") which is in drm-misc

With the msm/dsi being switched to DRM_PANEL_BRIDGE this is no longer 
relevant. Dropping this from the queue.

-- 
With best wishes
Dmitry

