Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5AABBA37
	for <patches@lists.linux.dev>; Sun,  3 Sep 2023 22:39:59 +0000 (UTC)
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-2bd3f629c76so13873041fa.0
        for <patches@lists.linux.dev>; Sun, 03 Sep 2023 15:39:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693780798; x=1694385598; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3njyN7L52ply28cLSWvghKHcDvpsiniGrJ+Mxrq7efI=;
        b=Q7Qdz247vT+n/h/vMUmk9keVNnF139bz9SmCOnRr/5SREtkeIJjyA0V4H5ECEhvA4c
         1vt5usJ8JH45qAeH2oH8YQDGI8oAKVG7OO/eJYM7ZOJDGuART/j9YpPhkXMBEVBty0L0
         QnIuiFSSIice7bfNl358KpnqgYCvXMrZ8gtCT2fGXvcHa2Ifksq/QxXYY+CiK6pvyoqM
         fmNW9vetNqqq9PeBdMwPbsy0ILA+IoTjcSOHxj3f5CsJuDKhAWfJT+GO/UVfOgvOA2S5
         Wg2zbpJPLIyiog6KuhqBnK3iWzq5JnuTjsTcwPxr3qB3urhrPfTb07WiGQewYALTcuc8
         H7JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693780798; x=1694385598;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3njyN7L52ply28cLSWvghKHcDvpsiniGrJ+Mxrq7efI=;
        b=EERU3wnlgrJ8AIvnKVun6HULNuZ35rvPswEGSzNIc9dA3XQkS89g4hnFC/9bXcYxIh
         5yHinwJHfthtCGeZ96qzh7CUgF+hZ62Bc5xHKkaaRm/mdswF2MPkjal5AXtkfyeuc2/J
         qOIfXSDB4CpVqlCs6lc99QvVJfH+heSo2tRK/kfzZOoaYxUWVjR4Ft1eLQ0lN56e3meR
         u2iU/rXNxivl3MTC07EJfAwxxEVoPQ5ldhz3Sdn9oxiTK2qygohy/6MOdFd8DWH60UQD
         IfpBOGmO13WFpgp8C+RBLc+3iKWXaQzGtz0zmPXSqmxqWFf0aBqmyNRfZOBSJSKjodRZ
         jNeg==
X-Gm-Message-State: AOJu0YzbN/mFBJA3pjldYJlFYd/5rqTV5cql0Or6ac9c61Ko3GqtvOff
	NAv/7/4eJsZEufcH2ejg0smPVw==
X-Google-Smtp-Source: AGHT+IHqA5bKFtbDh+6zSj7AEktpbIX5QdrDfqbVTVJTxtGdex58MNMVKlZ2+5ZRABDSdhyKeGSD5A==
X-Received: by 2002:a05:6512:3701:b0:500:7e64:cff1 with SMTP id z1-20020a056512370100b005007e64cff1mr4786349lfr.14.1693780797803;
        Sun, 03 Sep 2023 15:39:57 -0700 (PDT)
Received: from [10.10.15.130] ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id bo9-20020a0564020b2900b0052889d090bfsm4972604edb.79.2023.09.03.15.39.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Sep 2023 15:39:57 -0700 (PDT)
Message-ID: <79297172-7be5-4eb1-9288-83334f8302b6@linaro.org>
Date: Mon, 4 Sep 2023 01:39:56 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6/7] drm/msm/dp: Inline dp_link_parse_sink_count()
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230829184735.2841739-1-swboyd@chromium.org>
 <20230829184735.2841739-7-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230829184735.2841739-7-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/08/2023 21:47, Stephen Boyd wrote:
> The function dp_link_parse_sink_count() is really just
> drm_dp_read_sink_count(). It debug prints out the bit for content
> protection (DP_SINK_CP_READY), but that is not useful beyond debug
> because 'link->dp_link.sink_count' is overwritten to only contain the
> sink_count in this same function. Just use drm_dp_read_sink_count() in
> the one place this function is called to simplify.
> 
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/gpu/drm/msm/dp/dp_link.c | 38 +++-----------------------------
>   1 file changed, 3 insertions(+), 35 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

