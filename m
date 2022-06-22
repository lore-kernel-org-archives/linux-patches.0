Received: from mail-lj1-f171.google.com (mail-lj1-f171.google.com [209.85.208.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 649971869
	for <patches@lists.linux.dev>; Wed, 22 Jun 2022 17:58:24 +0000 (UTC)
Received: by mail-lj1-f171.google.com with SMTP id d19so20307209lji.10
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 10:58:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=RijPorxrzLa0urbw6f5tLG+MBIywxSnLbJeg+24hYzA=;
        b=H0VPSCsehGXRYxTHzMXRWxGfbmO+IP0LFhFmRmwcDgdae3jk2wjq7FiRgKRv1gUPQM
         7mR0hRGMvUOpdgF3Z4XpJoVP9nrtlr+QfMN3sLbcE8uKbscpuY+aTwN/u3FB0RmNDa3J
         U3el3BPUyFaeOvneYMa/UOcnN4lalmBdXVyyLtnsR6vwkdsuwuO2/AZ1btm/Kwg/G0hW
         I7KmOaggNgtnvDPNQKsh9kgOYs2u57711q3X9A5MJeK+aS1aiSPvDzTOtkXDKgtzfWfu
         XxT2/WGyoT/94NmWdS0LaUsUWNuG0UzfNiYVn5obq8o8yTnClnT1iYT91S2JZsfyRihQ
         fDiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RijPorxrzLa0urbw6f5tLG+MBIywxSnLbJeg+24hYzA=;
        b=p+yqo7QAgRt+MVypy5/40i4sfCh3BOHDQuJYRnU5BxvymcgSUtBdvnRh8DP7+bbYGp
         1uCrn+ecgd+PnWxxQyLIaUMB7qeL8qZKX3GzLEjx1iA9Njhehx2nu9ute7e1liUhbZ6X
         ZSV6XzR2ai6t1sYHcVS/3aGcGhQAo1wZ2ka75leUcIPTtvubrBpmTAcA6RrDarBEyVGn
         gta31zHJmZlOizagiqGnh1e1rOkMhA96E4uXO3a+B+hMzFtuksaW5bhLic4BUzlrsN6e
         TDYToAvgEVKjZ1lHC4Wb1pESob/m6fztxH4sManCMehEZST7Q47fLP9LEU5OGy96Fuz4
         W/mg==
X-Gm-Message-State: AJIora9M3eRXDGlEiIyOyQ5htifoKTL+eTnvV/2qChVgEuoiu3P0ypF2
	cZqgakv+GfGH9yj4ZEtbnTKdJA==
X-Google-Smtp-Source: AGRyM1sDD/L+lVpsF7kORweCZVDNiYMB+PqxH/Cw0lFPdDBWV98bhtSFtWCX+n4AQJXc48Ve+fm6TA==
X-Received: by 2002:a05:651c:54c:b0:25a:621e:5cf2 with SMTP id q12-20020a05651c054c00b0025a621e5cf2mr2560846ljp.87.1655920702407;
        Wed, 22 Jun 2022 10:58:22 -0700 (PDT)
Received: from [192.168.1.212] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id v11-20020a05651203ab00b0047f9fa2925csm99202lfp.234.2022.06.22.10.58.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 10:58:21 -0700 (PDT)
Message-ID: <6cc5767f-7961-3410-8693-40dde2348c12@linaro.org>
Date: Wed, 22 Jun 2022 20:58:21 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/3] drm/msm/dp: Remove pixel_rate from struct dp_ctrl
Content-Language: en-GB
To: Kuogee Hsieh <quic_khsieh@quicinc.com>, Stephen Boyd
 <swboyd@chromium.org>, Abhinav Kumar <quic_abhinavk@quicinc.com>,
 Rob Clark <robdclark@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org
References: <20220617204750.2347797-1-swboyd@chromium.org>
 <20220617204750.2347797-3-swboyd@chromium.org>
 <bb98ca29-8752-6864-ddbd-19547fb6f73b@linaro.org>
 <CAE-0n51_zysbkktVEfhvXtGqpADTWcaPBAX7A7rD1FV+vcK3Uw@mail.gmail.com>
 <48d83380-edb1-ad61-3878-5fa3ac3e5169@linaro.org>
 <d77d2989-7270-d1ec-fda6-7001ea337f5b@quicinc.com>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <d77d2989-7270-d1ec-fda6-7001ea337f5b@quicinc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 22/06/2022 18:22, Kuogee Hsieh wrote:
> 
> On 6/22/2022 12:24 AM, Dmitry Baryshkov wrote:
>> On 22/06/2022 05:59, Stephen Boyd wrote:
>>> Quoting Dmitry Baryshkov (2022-06-17 16:07:58)
>>>> On 17/06/2022 23:47, Stephen Boyd wrote:
>>>>> This struct member is stored to in the function that calls the 
>>>>> function
>>>>> which uses it. That's possible with a function argument instead of
>>>>> storing to a struct member. Pass the pixel_rate as an argument instead
>>>>> to simplify the code. Note that dp_ctrl_link_maintenance() was storing
>>>>> the pixel_rate but never using it so we just remove the assignment 
>>>>> from
>>>>> there.
>>>>>
>>>>> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
>>>>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>>>>> ---
>>>>>    drivers/gpu/drm/msm/dp/dp_ctrl.c | 57 
>>>>> ++++++++++++++++----------------
>>>>>    drivers/gpu/drm/msm/dp/dp_ctrl.h |  1 -
>>>>>    2 files changed, 28 insertions(+), 30 deletions(-)
>>>>>
>>>>> diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c 
>>>>> b/drivers/gpu/drm/msm/dp/dp_ctrl.c
>>>>> index bd445e683cfc..e114521af2e9 100644
>>>>> --- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
>>>>> +++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
>>>>> @@ -1336,7 +1336,7 @@ static void dp_ctrl_set_clock_rate(struct 
>>>>> dp_ctrl_private *ctrl,
>>>>>                                name, rate);
>>>>>    }
>>>>>
>>>>> -static int dp_ctrl_enable_mainlink_clocks(struct dp_ctrl_private 
>>>>> *ctrl)
>>>>> +static int dp_ctrl_enable_mainlink_clocks(struct dp_ctrl_private 
>>>>> *ctrl, unsigned long pixel_rate)
>>>>
>>>>
>>>> I think we can read pixel_rate here rather than getting it as an
>>>> argument. We'd need to move handling (DP_TEST_LINK_PHY_TEST_PATTERN &&
>>>> !ctrl->panel->dp_mode.drm_mode.clock) case here from dp_ctrl_on_link().
>>>
>>> This is also called from dp_ctrl_on_stream() and
>>> dp_ctrl_reinitialize_mainlink(). In the dp_ctrl_on_stream() case we may
>>> divide the pixel_rate by 2 with widebus. We could move the
>>> dp_ctrl_on_link() code here, but then we also need to move widebus, and
>>> then I'm not sure which pixel rate to use.
>>>
>>> It looks like the test code doesn't care about widebus? And similarly,
>>> we may run the pixel clk faster until we get a modeset and then divide
>>> it for widebus.
>>
>> Good question. I'll let Kuogee or somebody else from Qualcomm to 
>> comment on test code vs widebus vs pixel rate, as I don't know these 
>> details.
>>
>> I'm not sure if we should halve the pixel clock in 
>> dp_ctrl_on_stream_phy_test_report() or not if the widebus is supported.
>> From the current code I'd assume that we have to do this. Let's raise 
>> this question in the corresponding patch discussion.
>>
> yes, phy test does not care pixel clock rate.

So, is it 'does not care' or 'set to mode clock'?

In other words, can we unify both functions by always accounting for the 
wide_bus_en value?


-- 
With best wishes
Dmitry
