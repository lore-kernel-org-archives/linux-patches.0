Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131DE1869
	for <patches@lists.linux.dev>; Wed, 22 Jun 2022 17:42:01 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id w20so28962899lfa.11
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 10:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Md1LFFMVf3qzgQl06XYv2bG2aVcmSQ0Imz09zcqF9fE=;
        b=BKHdplf9Z9UYjFpu0usV1HiUVRkZrmz6azNJU7EC0MviAcfmO/rMhk1qqtXUmZJ5IL
         hdjnrvu84pvYn8IVuFvN1f4Br15iQ7froaX8gqPoFdJDxRn39/uc+pt0KXQRc8y1FrBg
         7EYrgyuwW8eOEro4h+ZrqssVv+yMUnSl+U3TCAOvcTUWCU6PSfwFGIYzyi7iTHrPtu6t
         qrjTm1Tsh/UsLuBTseWzt9aDUuks/Uc0JnM87Dyj8KP4mtTPfMSI6m5c4AV94mb0BAJt
         xCeq/L2uxpIE785DkcbrummXJZ/HiWvDS0uc47Bs/8zviuoh9zGldNWQclHF1KwDInbN
         6MyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Md1LFFMVf3qzgQl06XYv2bG2aVcmSQ0Imz09zcqF9fE=;
        b=WxgD/cQfaqTGAbnQrIFXU6ukR2sSkeuDKUZmwRmwcTUijFUHL4ZsDo1NgCfGh7jLjt
         rvxftd/Ld8n+aU0/niWIoPXlse7sMFGLB0+P5K5N7uIaLdFqlTNQxJ/KFgiOwSCjmTTd
         cC68CtF5S1oUcih0wrNfUfynwliN8nTz5VSPbWXVKI9bc59zUHCtwBL8HbISf6l1yPiy
         5IZnvDLdczJICG7P5t/Cz8DGYWSnUnPTJfdRmvea2/WDiyopRqijW9yN5sJNkqrFzbLR
         XFJKqUAquzQ3H5998BCzH1L8DMNSu2kuFinxVkagDM1TqsK/N4WEUhQMllH4w1b1yPlj
         ppww==
X-Gm-Message-State: AJIora+pWXRIvIMiDuqABUfsBXH+PX04YiGYt9rLJGsD/XrQKPl/XPCu
	T5J6Ht1ZYlWumoGKnQitHt0sXw==
X-Google-Smtp-Source: AGRyM1t7MP6/Z+Yz4nicI0Mu0cth9yPiwZA7MruELCF+kKK//sFOF/JfUauGdWLSIkbgxgAVQEmhvw==
X-Received: by 2002:ac2:5cc6:0:b0:47f:7a4b:9db8 with SMTP id f6-20020ac25cc6000000b0047f7a4b9db8mr2803564lfq.592.1655919719106;
        Wed, 22 Jun 2022 10:41:59 -0700 (PDT)
Received: from [192.168.1.212] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id l3-20020a2e99c3000000b0025574e803fasm2511387ljj.18.2022.06.22.10.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 10:41:58 -0700 (PDT)
Message-ID: <8394943c-8d51-df67-1603-6f37ac26a730@linaro.org>
Date: Wed, 22 Jun 2022 20:41:57 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/msm/dpu: Increment vsync_cnt before waking up
 userspace
Content-Language: en-GB
To: Rob Clark <robdclark@gmail.com>, Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: Stephen Boyd <swboyd@chromium.org>,
 Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
 patches@lists.linux.dev, Sean Paul <sean@poorly.run>,
 dri-devel <dri-devel@lists.freedesktop.org>,
 freedreno <freedreno@lists.freedesktop.org>,
 Mark Yacoub <markyacoub@chromium.org>,
 Jessica Zhang <quic_jesszhan@quicinc.com>
References: <20220622023855.2970913-1-swboyd@chromium.org>
 <b133b67f-0d99-af6b-94a5-d5ff4b5752f1@quicinc.com>
 <CAF6AEGuL0+3162jGb2YLsYoW-fmNsARuKcvE-+d5hRkCiicp4g@mail.gmail.com>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <CAF6AEGuL0+3162jGb2YLsYoW-fmNsARuKcvE-+d5hRkCiicp4g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/06/2022 20:33, Rob Clark wrote:
> On Wed, Jun 22, 2022 at 10:24 AM Abhinav Kumar
> <quic_abhinavk@quicinc.com> wrote:
>>
>>
>>
>> On 6/21/2022 7:38 PM, Stephen Boyd wrote:
>>> The 'vsync_cnt' is used to count the number of frames for a crtc.
>>> Unfortunately, we increment the count after waking up userspace via
>>> dpu_crtc_vblank_callback() calling drm_crtc_handle_vblank().
>>> drm_crtc_handle_vblank() wakes up userspace processes that have called
>>> drm_wait_vblank_ioctl(), and if that ioctl is expecting the count to
>>> increase it won't.
>>>
>>> Increment the count before calling into the drm APIs so that we don't
>>> have to worry about ordering the increment with anything else in drm.
>>> This fixes a software video decode test that fails to see frame counts
>>> increase on Trogdor boards.
>>>
>>> Cc: Mark Yacoub <markyacoub@chromium.org>
>>> Cc: Jessica Zhang <quic_jesszhan@quicinc.com>
>>> Fixes: 885455d6bf82 ("drm/msm: Change dpu_crtc_get_vblank_counter to use vsync count.")
>>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>>
>> This is right, we should increment before drm_crtc_handle_vblank() as
>> that will query the vblank counter. This also matches what we do
>> downstream, hence
>>
>> Reviewed-by: Abhinav Kumar <quic_abhinavk@quicinc.com>
>>
>> One small nit though, shouldnt the fixes tag be
>>
>> 25fdd5933e4c ("drm/msm: Add SDM845 DPU support")
> 
> *Kinda*.. but the sw vblank counter wasn't used for reporting frame nr
> to userspace until 885455d6bf82.  You could possibly list both,
> perhaps, but 885455d6bf82 is the important one for folks backporting
> to stable kernels to be aware of

I'd agree, the original Fixes tag seems good to me.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>


-- 
With best wishes
Dmitry
