Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E0D6106
	for <patches@lists.linux.dev>; Tue, 30 Aug 2022 20:42:26 +0000 (UTC)
Received: by mail-lf1-f51.google.com with SMTP id q7so17138813lfu.5
        for <patches@lists.linux.dev>; Tue, 30 Aug 2022 13:42:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=cYIt8T5qTTPMHnPLf3xQ+OALuVf5JTfc65U2LdgUBRw=;
        b=u12h2y5bEzDK0Z7f56rEwzaTFo5dMxORpwCNdjTOvecDv5/T3+4AThU1ci+IcjwQQJ
         Zng+Ii9ZUZglYG8VQN4ZrxV8w7ZtWUy/Yz+KQqHEm/B63vwtNGPaR+AYLFZFbDjLXJNe
         kRkkFAeg8VgZKFONW7AYee4/1rlLY7a7bu7psGDgB/o7yYRC3P/WB36OpOatqYvHdl/U
         E1GCJ2q7/rHqZiQEeaDWR3h/Jw0zmaO3RtEZ8C3taZ/LBRSmqUTYZfrUxD51mrnSgSyp
         YwUQ3lUTUvUGJ2ZXPALH4QAnwbjKoBx0THf0GAgAsbDQVvgX33vVDsdu1cSoJbEblAWR
         u+rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=cYIt8T5qTTPMHnPLf3xQ+OALuVf5JTfc65U2LdgUBRw=;
        b=B4YLPDBUJbMnL/J2IpV7uZ4Bz34TCzs1OQwYd1BlVe5q5De9Vo2H/yd6yQ8iZ5JijY
         j4Ps8AqpLrlxVqYANPIavEdtQYiI88+heQ3Lj+aewIHIaZEl2K5lg8mAAjFgzwNJdf0R
         7chN8kvd+czx9Sw0T+TQsTqankKGh+pUPRKWNsisE2PpI+H3kIP8/o4z0dozVHDHzkcp
         qSmYs11Ru9Qj9Z59TEre1itJIzkJ7cm9akHL2PSLhLKrMJB3WUw5FJl7GIdNdP7SrtnJ
         oqpACiXUsOf+zWOP5/zibJRrCE2xSftFbeAxPd1HC3PeVjlMIyzj9Jb4VkdiKkJSpTYb
         7U4A==
X-Gm-Message-State: ACgBeo3kNSetGERUxKDLxSRB2Hg63h1+ugFUXerdn4YuJ0cP5oHJjBW7
	KA+0i6wjforpg1rfxYI2WIGwfA==
X-Google-Smtp-Source: AA6agR5kINkZTpU9ZCvAgVHkM73uJ9XuvJxMdXlcD3IzA7JJZGJdFWJiTcv47RB/1xYcEd6sZkrb9Q==
X-Received: by 2002:a05:6512:1510:b0:492:df5b:ff76 with SMTP id bq16-20020a056512151000b00492df5bff76mr7958543lfb.178.1661892144495;
        Tue, 30 Aug 2022 13:42:24 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id c25-20020a056512075900b00492dc1bb346sm1712622lfs.260.2022.08.30.13.42.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Aug 2022 13:42:23 -0700 (PDT)
Message-ID: <d43b3936-dbc0-dbca-96de-449cec1fc024@linaro.org>
Date: Tue, 30 Aug 2022 23:42:22 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH] drm/msm/dsi: Remove use of device_node in
 dsi_host_parse_dt()
Content-Language: en-GB
To: Nathan Chancellor <nathan@kernel.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Sean Paul <sean@poorly.run>, Nick Desaulniers <ndesaulniers@google.com>,
 Tom Rix <trix@redhat.com>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20220829165450.217628-1-nathan@kernel.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220829165450.217628-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/08/2022 19:54, Nathan Chancellor wrote:
> Clang warns:
> 
>    drivers/gpu/drm/msm/dsi/dsi_host.c:1903:14: error: variable 'device_node' is uninitialized when used here [-Werror,-Wuninitialized]
>            of_node_put(device_node);
>                        ^~~~~~~~~~~
>    drivers/gpu/drm/msm/dsi/dsi_host.c:1870:44: note: initialize the variable 'device_node' to silence this warning
>            struct device_node *endpoint, *device_node;
>                                                      ^
>                                                      = NULL
>    1 error generated.
> 
> device_node's assignment was removed but not all of its uses. Remove the
> call to of_node_put() and the variable declaration to clean up the
> warning.
> 
> Fixes: 5f8cdece42ff ("drm/msm/dsi: switch to DRM_PANEL_BRIDGE")
> Link: https://github.com/ClangBuiltLinux/linux/issues/1700
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

