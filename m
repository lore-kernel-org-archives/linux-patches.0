Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F5279445
	for <patches@lists.linux.dev>; Sun,  3 Sep 2023 22:37:43 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-31c4d5bd69cso755332f8f.3
        for <patches@lists.linux.dev>; Sun, 03 Sep 2023 15:37:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693780661; x=1694385461; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iuInZybgE5C4HgdNIAED9cdqS6tn29myqOzFJ+qiKTc=;
        b=z3f1bApmOzsJM09VYbzW0vppSa6w2ys/MGtMaHPikPKHIy7qFRamt5bk4VfHpAMGMY
         zBbdVkDLixJVRS+FEG9NfCHk2zpmUW9QjaxJ7yaHgIpQqKxXF8UWh/KF7c3tY6EEUN7O
         ZbPaZ/6e70pHVrVmoiOdPzmAl6euUeo975kTUzX5sgrKhE8gdhrxzQa5k3HOiGVfgENe
         aFopHq0Kthk9SRiovf9xzb+t/LYOxfLT22YG8A82nykIpeqfi0ZzRSCkt2zu7Q4SS/Sd
         ye4+X1t6M3pzdwj6NriLuP5Bu23X0cxzZ0nr16oiHUfH0CL5qK72XJSA3aIElOAsh+9N
         kZ8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693780661; x=1694385461;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iuInZybgE5C4HgdNIAED9cdqS6tn29myqOzFJ+qiKTc=;
        b=OpKmossCNnilqbJjWF6vnTp9KSfcFljW4AviwxBCq9Pi6dmdFwnDPEXT5RRgpzIp34
         st5b2KBft/lgBfqnY4GM9yN2EipXkHSyRJUrTcV+WO+qAHWurG2V6fKiQDLYRdyDlFte
         5J0u589xpM+/jGEiWXuYDwHyLNJDUueRNEh39VD3ej801gyP6XhXWp0d2zPT86pZ/Pvp
         XevmbRKBiaNVPQBRUgWWZ6xxBmkwI9fOyhrHsyHCVFd2Qb7Zs83dk+dMxbwjzpfzYu93
         S/JD5HV3rFs79GVKgCK6ukWzW+TWDGGzpYY08kBrTZRLpsnfhfh7YlXPlxiLknp0nF1G
         NXLw==
X-Gm-Message-State: AOJu0Yzyg2zHKD9UT0U5gZPUB649oBb8k9t4FDSMi30CYcGOJhNNK9x0
	bbz9gtNs1nl1jip89BdkxPcHsw==
X-Google-Smtp-Source: AGHT+IEE16n0PDj07eAurnl3CVbsLgtJrkqgHUlTveydUibtGonutI7dAHGUS2oR1eZ0UqelpiUnPg==
X-Received: by 2002:a5d:424b:0:b0:317:3dff:7189 with SMTP id s11-20020a5d424b000000b003173dff7189mr6066598wrr.66.1693780661484;
        Sun, 03 Sep 2023 15:37:41 -0700 (PDT)
Received: from [10.10.15.130] ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id bo9-20020a0564020b2900b0052889d090bfsm4972604edb.79.2023.09.03.15.37.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Sep 2023 15:37:41 -0700 (PDT)
Message-ID: <642a5b5b-0979-4d9b-a5e3-9432afe062d4@linaro.org>
Date: Mon, 4 Sep 2023 01:37:40 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/7] drm/msm/dp: Use drm_dp_read_sink_count() helper
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230829184735.2841739-1-swboyd@chromium.org>
 <20230829184735.2841739-3-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230829184735.2841739-3-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/08/2023 21:47, Stephen Boyd wrote:
> Use the common function drm_dp_read_sink_count() instead of open-coding
> it. This shrinks the kernel text a tiny bit.
> 
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/gpu/drm/msm/dp/dp_panel.c | 19 +++++++------------
>   1 file changed, 7 insertions(+), 12 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

