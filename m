Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FD39445
	for <patches@lists.linux.dev>; Sun,  3 Sep 2023 22:37:18 +0000 (UTC)
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-52a0856b4fdso1070793a12.1
        for <patches@lists.linux.dev>; Sun, 03 Sep 2023 15:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693780636; x=1694385436; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JTU8KrO8RUU8FiWRZw+rl4K+4j0rOVVykAlc2x+Gur8=;
        b=HJT8sq+ykBvt2ODK8Pz6tdP0Cd9GawLC129iBsJ74LkYodDeh0hf3TNwJFdGv3RKhk
         kwkqquEyQTwPPiP84GKGUFxaeHhVwP5bC+hzr5JtOAeag3KA64ZTtkCYJtfLlz5zhcY7
         eLL1l0DvRLfnhX23V5eumBWuyOjrAbB6P4KNUVi2GMWnVOgPhGsGggn6e3Lmo4lA9GG3
         Y5ztAVedcdRa5OAJDcZmNvBHpKNPl4hPG0Em2I2a1uE4Pt6h0EUPAeGO57lnhCou/KnU
         nMrLvQWpQn3PZ0jKdVvNVbXlkmEcC11uHLUddg2HLfd62WkUjAus+XxK+0ffLEDPNp7u
         WAyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693780637; x=1694385437;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JTU8KrO8RUU8FiWRZw+rl4K+4j0rOVVykAlc2x+Gur8=;
        b=WXryu6uW+lqND13aSeMQzMvGFs4ymPh1/z9xHLQftNOdYkLjoEkjLInk8j2ovmr2an
         BcGBnrN//olrl8RZGWmcTgeoxrbhIsfP/uAT5niAnMwk+EFAZ30r3ZGfd8R6Q9xVqTEQ
         +c4Ql9FA8sZWFOZQ4Xipj3CnNCJ6RaeX0mLr9bnCg/KZCT3+9SUwGbJJmt3YcaZ6m0eP
         ROllrD1THvkgIJz7mE4wGxa7ZoqP1j9JHcs6pkoSuPunVQlRXfhxnPCWQ3TWRyZJmh4D
         heVZM6iQWiU4anG6PcqgyRl0/U2+h/w+D4jE5jpfJ0RhGNq4M/i5YCD/QqsuV71Xy/65
         cmSw==
X-Gm-Message-State: AOJu0YyWP5AfdBVxNRYX2GcFljTtec1+GA7anFKprv20k6KmaXmFDCu2
	SVomnABGCZIP5PPPEo9R+FCRrw==
X-Google-Smtp-Source: AGHT+IH887EsApjxxqgeKDwZfphqZJP+92AGGLQhQH1W/cbewlBiwmTzV6SErfuj2s5lfRAgmYmXeg==
X-Received: by 2002:a50:ec90:0:b0:523:3e90:68b0 with SMTP id e16-20020a50ec90000000b005233e9068b0mr5378864edr.21.1693780636732;
        Sun, 03 Sep 2023 15:37:16 -0700 (PDT)
Received: from [10.10.15.130] ([192.130.178.91])
        by smtp.gmail.com with ESMTPSA id bo9-20020a0564020b2900b0052889d090bfsm4972604edb.79.2023.09.03.15.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Sep 2023 15:37:16 -0700 (PDT)
Message-ID: <1c7b1397-de05-49f7-8e26-3244fbd1573f@linaro.org>
Date: Mon, 4 Sep 2023 01:37:15 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/7] drm/msm/dp: Replace open-coded
 drm_dp_read_dpcd_caps()
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230829184735.2841739-1-swboyd@chromium.org>
 <20230829184735.2841739-2-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230829184735.2841739-2-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29/08/2023 21:47, Stephen Boyd wrote:
> This function duplicates the common function drm_dp_read_dpcd_caps().
> The array of DPCD registers filled in is one size larger than the
> function takes, but from what I can tell that extra byte was never used.
> Resize the array and use the common function to reduce the code here.
> 
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/gpu/drm/msm/dp/dp_panel.c | 42 ++++---------------------------
>   drivers/gpu/drm/msm/dp/dp_panel.h |  4 +--
>   2 files changed, 6 insertions(+), 40 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

-- 
With best wishes
Dmitry

