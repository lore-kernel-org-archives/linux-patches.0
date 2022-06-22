Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B249110A
	for <patches@lists.linux.dev>; Wed, 22 Jun 2022 07:24:57 +0000 (UTC)
Received: by mail-lj1-f170.google.com with SMTP id n15so6628177ljg.8
        for <patches@lists.linux.dev>; Wed, 22 Jun 2022 00:24:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=YoxQ8bxKC0+9JiwXWf9XJ6/TU9qeci3gtMH9RdtmUOM=;
        b=FVZppPq+HgRatwdw9mBhIyBcCuKYUO7KIg3b6WyzTtn+ieiK8qj+2cBHNMpm800a2U
         SEw7Klt8bH3yx2pmX/BSp14akymYv4+pjfBJfk95Lojo3KD/vLL1QpRJ7bawo/okeOuc
         HmVl6T87jKVCEdIyvTNTGl4wqdEgJsco7NxmDtpihocUGddJ1z9Z/HwJQLsrMYKqX1Ge
         saeBBv6O30zdfGt+Dd+YXYjsJrvT4/7fbtSFwGFrcPWGc9LVhjc8Zm4EtGcetyMdJ4Ge
         VOGV00WKkCRLVUExu3eXS4B257gR1+LxMorxZWsse67I3eByQH1lMR+j3WU4vf/jhpma
         mDjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=YoxQ8bxKC0+9JiwXWf9XJ6/TU9qeci3gtMH9RdtmUOM=;
        b=Rj+8bXJAlIYHmMXu1KgNrDOZEL6DZAojYEyipM4MslF6L6fUION9J1aVsiBqw+dRhL
         q38dDHVTRO2sX/a2CPqoeN5L3n0vNF0xVSuGjRI4mxBavnlLSt6hVqcexLfJrhfeWocd
         jExoRZ7wYrCpqXuKxUdKslpsPSpEByFvVMd3eHJS4aGWTo7nKbbz46mM70bHk9ZcQbkn
         cr179krc1XxUjz2Q8dguu1Tn8VhP9azfEsV3qwzSPe2yb4ErdTh8kzEw8tFxANuT+OJO
         CHdpQD3gRkEZJcXm6VVVe0unlfv24QOv5BRXs5OwRiR/5NP7a1UtZDp9cLh7svYwspi4
         OM0Q==
X-Gm-Message-State: AJIora+y/sZXDw7EcNIr1nwbBHxJDNGVkfc2NmvXSMJHso6+OPW2U81n
	QZw0S3Hyi4NJSTJhqqZqxrghvg==
X-Google-Smtp-Source: AGRyM1tJbMHkXYq5UeLE2gCpcSsVO14ibqDJLnV2+fNPbMOaQD6RYhO/nsbxzZgK41uH0WPuqTjCBg==
X-Received: by 2002:a2e:8e94:0:b0:25a:83fd:eeec with SMTP id z20-20020a2e8e94000000b0025a83fdeeecmr1087524ljk.493.1655882695577;
        Wed, 22 Jun 2022 00:24:55 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id u9-20020a199209000000b0047da6e495b1sm2449615lfd.4.2022.06.22.00.24.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jun 2022 00:24:55 -0700 (PDT)
Message-ID: <48d83380-edb1-ad61-3878-5fa3ac3e5169@linaro.org>
Date: Wed, 22 Jun 2022 10:24:54 +0300
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
To: Stephen Boyd <swboyd@chromium.org>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>, Rob Clark <robdclark@gmail.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20220617204750.2347797-1-swboyd@chromium.org>
 <20220617204750.2347797-3-swboyd@chromium.org>
 <bb98ca29-8752-6864-ddbd-19547fb6f73b@linaro.org>
 <CAE-0n51_zysbkktVEfhvXtGqpADTWcaPBAX7A7rD1FV+vcK3Uw@mail.gmail.com>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <CAE-0n51_zysbkktVEfhvXtGqpADTWcaPBAX7A7rD1FV+vcK3Uw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/06/2022 05:59, Stephen Boyd wrote:
> Quoting Dmitry Baryshkov (2022-06-17 16:07:58)
>> On 17/06/2022 23:47, Stephen Boyd wrote:
>>> This struct member is stored to in the function that calls the function
>>> which uses it. That's possible with a function argument instead of
>>> storing to a struct member. Pass the pixel_rate as an argument instead
>>> to simplify the code. Note that dp_ctrl_link_maintenance() was storing
>>> the pixel_rate but never using it so we just remove the assignment from
>>> there.
>>>
>>> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
>>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>>> ---
>>>    drivers/gpu/drm/msm/dp/dp_ctrl.c | 57 ++++++++++++++++----------------
>>>    drivers/gpu/drm/msm/dp/dp_ctrl.h |  1 -
>>>    2 files changed, 28 insertions(+), 30 deletions(-)
>>>
>>> diff --git a/drivers/gpu/drm/msm/dp/dp_ctrl.c b/drivers/gpu/drm/msm/dp/dp_ctrl.c
>>> index bd445e683cfc..e114521af2e9 100644
>>> --- a/drivers/gpu/drm/msm/dp/dp_ctrl.c
>>> +++ b/drivers/gpu/drm/msm/dp/dp_ctrl.c
>>> @@ -1336,7 +1336,7 @@ static void dp_ctrl_set_clock_rate(struct dp_ctrl_private *ctrl,
>>>                                name, rate);
>>>    }
>>>
>>> -static int dp_ctrl_enable_mainlink_clocks(struct dp_ctrl_private *ctrl)
>>> +static int dp_ctrl_enable_mainlink_clocks(struct dp_ctrl_private *ctrl, unsigned long pixel_rate)
>>
>>
>> I think we can read pixel_rate here rather than getting it as an
>> argument. We'd need to move handling (DP_TEST_LINK_PHY_TEST_PATTERN &&
>> !ctrl->panel->dp_mode.drm_mode.clock) case here from dp_ctrl_on_link().
> 
> This is also called from dp_ctrl_on_stream() and
> dp_ctrl_reinitialize_mainlink(). In the dp_ctrl_on_stream() case we may
> divide the pixel_rate by 2 with widebus. We could move the
> dp_ctrl_on_link() code here, but then we also need to move widebus, and
> then I'm not sure which pixel rate to use.
> 
> It looks like the test code doesn't care about widebus? And similarly,
> we may run the pixel clk faster until we get a modeset and then divide
> it for widebus.

Good question. I'll let Kuogee or somebody else from Qualcomm to comment 
on test code vs widebus vs pixel rate, as I don't know these details.

I'm not sure if we should halve the pixel clock in 
dp_ctrl_on_stream_phy_test_report() or not if the widebus is supported.
 From the current code I'd assume that we have to do this. Let's raise 
this question in the corresponding patch discussion.

> Is that why you're suggesting to check
> !ctrl->panel->dp_mode.drm_mode.clock? I hesitate because it isn't a
> direct conversion, instead it checks some other stashed struct member.
> 
> I'll also note that dp_ctrl_enable_mainlink_clocks() doesn't really use
> this argument except to print the value in drm_dbg_dp(). Maybe we should
> simply remove it from here instead?

Yes, do it please.

> 
>>> @@ -1588,12 +1586,12 @@ static int dp_ctrl_on_stream_phy_test_report(struct dp_ctrl *dp_ctrl)
>>>    {
>>>        int ret;
>>>        struct dp_ctrl_private *ctrl;
>>> +     unsigned long pixel_rate;
>>>
>>>        ctrl = container_of(dp_ctrl, struct dp_ctrl_private, dp_ctrl);
>>>
>>> -     ctrl->dp_ctrl.pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
>>> -
>>> -     ret = dp_ctrl_enable_stream_clocks(ctrl);
>>> +     pixel_rate = ctrl->panel->dp_mode.drm_mode.clock;
>>> +     ret = dp_ctrl_enable_stream_clocks(ctrl, pixel_rate);
>>
>> I think we can take another step forward here. Read the
>> ctrl->panel->dp_mode.drm_mode.clock from within the
>> dp_ctrl_enable_stream_clocks() function. This removes the need to pass
>> pixel_rate as an argument here.
> 
> This is also affected by widebus and if the function is called from
> dp_ctrl_on_stream() or dp_ctrl_on_stream_phy_test_report(). Maybe it
> would be better to inline dp_ctrl_enable_stream_clocks() to the
> callsites? That would probably simplify things because the function is
> mostly a wrapper around a couple functions.

Yes, this sounds good. Then we can drop the drm_dbg_dp from it (as it 
nearly duplicates the data that was just printed.


-- 
With best wishes
Dmitry
