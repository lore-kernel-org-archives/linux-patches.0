Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3878D9445
	for <patches@lists.linux.dev>; Sun,  3 Sep 2023 22:39:17 +0000 (UTC)
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-52a49a42353so1220763a12.2
        for <patches@lists.linux.dev>; Sun, 03 Sep 2023 15:39:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693780756; x=1694385556; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rJDVZGRXNPlbG+uW3nJBHU09g5j3lMYwRuZyrmz3c3s=;
        b=nBdYIESUUTm3Uyl6xzYnfHiD69GeS2iEIJROnhOJbB6hsfdP4dKenc3rNCT0HD5Nff
         /0hwW4v3caGbxhJVbj1slAIoIKj4iVf4njdUWbwwiIjs7MCT8Asph8zBWOoUh6tc0Bv0
         Mki9O+1NANpU1o7Y3+L0Nvv06hlAhdnV7yFIDQ1ft2IRRbzkfI5WaQZrRP/U5EXqu/UG
         6XQDlQea0IP5NDb0++bDiSQa3Wh+ZiJsMZ2M1vAWljr5XYnWeNQOPxsHdB7YM5ttcQMH
         UMtTWKedW+ajwUqTXeorXAx9qcjqGAZF+6QvpJUq2Vczv4LkdinD0BkRv8BieTpAst9u
         pcNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693780756; x=1694385556;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rJDVZGRXNPlbG+uW3nJBHU09g5j3lMYwRuZyrmz3c3s=;
        b=guYy2Sxuv6yMqq7UzJt3IRsPY5iu4olFPWp+KmwWeTtedpIQpwar5DaM8CdoAsp0RD
         6jOHkk06MBp2UHJciZtud9jN1iu2PCceXjZbhntcy3HOyGVSpYnnmI/3aD86DNAExwN/
         GYHcdPDVp4XFuxHkDSCz4UQVXS0rPkbkndIymAFb5wpfk1nn+vBl0+QcR0JPvaZM/U6L
         Pd2dr7M8v9xSCL+6Cd92Z8VtvugCKIWp25TJdoXEHbEOkEny3kXY++9MmXRMzskFgls2
         GJVkcOtX0z8Y80Jia9j2+oXg1FZNiWaF62pZIzq2vBzXbSNVfJ5TouuUoESdDg3X6Y8d
         z0kA==
X-Gm-Message-State: AOJu0YxiWpywn+E7r3pCNQKxLVmFPqEEAM76piK31GOumopVRyVcnYvp
	VZmvmdL7mtUa76NxFAaOr/Dz3A==
X-Google-Smtp-Source: AGHT+IE8rdKKfRtiKAW4qUZx2CR6ApBgBWNohpTtDZ86s5LagIbmW/Z33cweCIm3MWR7p4a6suEfqA==
X-Received: by 2002:a50:ef1a:0:b0:523:6c47:56f8 with SMTP id m26-20020a50ef1a000000b005236c4756f8mr7429079eds.18.1693780756071;
        Sun, 03 Sep 2023 15:39:16 -0700 (PDT)
Received: from [10.10.15.130] ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id bo9-20020a0564020b2900b0052889d090bfsm4972604edb.79.2023.09.03.15.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Sep 2023 15:39:15 -0700 (PDT)
Message-ID: <74f45f3a-d075-4911-8173-2ddf4ba74b02@linaro.org>
Date: Mon, 4 Sep 2023 01:39:15 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/7] drm/msm/dp: Remove aux_cfg_update_done and related
 code
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230829184735.2841739-1-swboyd@chromium.org>
 <20230829184735.2841739-5-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230829184735.2841739-5-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/08/2023 21:47, Stephen Boyd wrote:
> The member 'aux_cfg_update_done' is always false. This is dead code that
> never runs. Remove it.
> 
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/gpu/drm/msm/dp/dp_panel.c | 15 ---------------
>   1 file changed, 15 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

