Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CD5E15484
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 22:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yHBnccEt"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-50573e85ee0so1847098e87.3
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 15:42:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696545764; x=1697150564; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J55C2DECva8x20ZCPV5VaEapm9sYZn6cEu2d8qLrjfw=;
        b=yHBnccEt8WWf8ZuF1fxXa4wPPAJ18WtzieZSALXY04sk8oNFzpGqhiPWXXGGoH/0S/
         hdAYZhmbfUQcMZnyGyXJTATzexUJ1njzfQ2BFqVsMlIjyUfuHOd+o2X1etqtzuoWAdCF
         QDXjhCar/UBfnZ5s9tO1heQZawhcfFskHojTMlFhQwfxwZqdAvMdBbX3eKfXT+iciSmK
         aOb/HlxZZ4He0pxFhlL4Uh/O/c+G71GNoy5B63SfisnDKbtkkCxE/WsCWH+nYg9e97gJ
         uP2mwNJWNitJsFidI/N34or2n880Z/Unl8NwAoQs0pNL9daANPrE9yjzo+ppSAA+dFfh
         a0pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696545764; x=1697150564;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=J55C2DECva8x20ZCPV5VaEapm9sYZn6cEu2d8qLrjfw=;
        b=KxHhHd13pwUTWCK1cY5mgkAZsjFx988DLN6ml9fG+Kg+CcrHhCE4TrfH0psFNlPeZZ
         CGceyksPXKktzMDgM++9kGNmkST3RGdam8Xq4KkC1d4vV9+sNQt85GLTjx4TlioxYjtF
         L9eu94ZKL6iE6JhVVf84G1wZcvDFxcKmDJn1p4Dx2eSjfj89ZcP5eDrr7NxSqBsvm78A
         /LdmMXeqJOICvneo1/rgz1ZNa5jL5LMm0cnWN0l+30N9mEmmoWEC5KCj50XIIGXnZ/WS
         64tHsY6yD/3Vi5quxb2/xpXvyWS/FUY4qg/Wil8CeMJh/n9s7XwDbVMvI0cYFqAyTttI
         9CnQ==
X-Gm-Message-State: AOJu0YzS41vz1kYPYMHpUOh1Av+Dl7zYuEaMOp1v5iFHgPnEa7G0eTjA
	Mk+h4TKc4N8WJ87Xk+TtQJJWDw==
X-Google-Smtp-Source: AGHT+IGEkk1/dB0O8kz/B/IOyEVgYrzdTBNr3I5VSfV7uBhvhWf6AWTlOwegLw3Kr7Ps7P1/Hd7iEA==
X-Received: by 2002:a05:6512:2512:b0:4fb:740a:81ae with SMTP id be18-20020a056512251200b004fb740a81aemr6924452lfb.16.1696545764617;
        Thu, 05 Oct 2023 15:42:44 -0700 (PDT)
Received: from ?IPV6:2001:14ba:a0db:1f00::8a5? (dzdqv0yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a0db:1f00::8a5])
        by smtp.gmail.com with ESMTPSA id d24-20020ac25458000000b005009b979e3dsm31121lfn.303.2023.10.05.15.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 15:42:44 -0700 (PDT)
Message-ID: <77b410f5-93a2-48be-a0d4-2053f280bc8b@linaro.org>
Date: Fri, 6 Oct 2023 01:42:43 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] drm/msm/dp: Remove error message when downstream port
 not connected
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230906181226.2198441-1-swboyd@chromium.org>
 <20230906181226.2198441-3-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230906181226.2198441-3-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/09/2023 21:12, Stephen Boyd wrote:
> Plugging in an Apple dongle without the HDMI cable attached prints out
> an error message in the kernel logs when nothing is actually wrong.
> 
>     no downstream ports connected
> 
> This is because the downstream port for the HDMI connector is not
> connected, so the Apple dongle reports that as a zero sink count device.
> 
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/gpu/drm/msm/dp/dp_panel.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/msm/dp/dp_panel.c b/drivers/gpu/drm/msm/dp/dp_panel.c
> index 97ba41593820..ae778e1a6fd0 100644
> --- a/drivers/gpu/drm/msm/dp/dp_panel.c
> +++ b/drivers/gpu/drm/msm/dp/dp_panel.c
> @@ -156,7 +156,6 @@ int dp_panel_read_sink_caps(struct dp_panel *dp_panel,
>   	if (drm_dp_is_branch(dp_panel->dpcd)) {
>   		count = drm_dp_read_sink_count(panel->aux);
>   		if (!count) {
> -			DRM_ERROR("no downstream ports connected\n");

Maybe this can be converted to drm_dbg_dp?

>   			panel->link->sink_count = 0;
>   			return -ENOTCONN;
>   		}

-- 
With best wishes
Dmitry

