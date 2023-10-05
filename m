Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB82154AB
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 22:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ViRhmHm8"
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5044dd5b561so1885858e87.1
        for <patches@lists.linux.dev>; Thu, 05 Oct 2023 15:42:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696545718; x=1697150518; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qxe0ak/46bJpsp3A6ERBsLYtpfqO5S6jfq8NjVc/4Bc=;
        b=ViRhmHm8yXuBYS4xMBEm5lI2zhsYJLrmmVc4hnq69X2KtU/IuNekqTHePSeOb+QyiE
         99hQxq2waDnWwLjQMoxhEhP/KZb3tj9Djb1Xvddio2UGETy6NWdD9AtDu4MnWfh1QxDX
         n3/+7MHMbSASlWpe41IXiE8czXLzHUihFuROEu4ImKsn3xfS81wlEo+jPbWPdcH7SfoI
         vfJybIw9cukCFEjjytN4rzrFwhdU8H1ZnUJobJGgs482hUTJu9eJqbK8Ikz2C1WdcEuv
         7CfGbVqu/xKvLw58im/IN9YY2BBxOHSKH6TTXupYDbFJYh7XGWHqFZw9MaXrvC7k6v2q
         q59A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696545718; x=1697150518;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qxe0ak/46bJpsp3A6ERBsLYtpfqO5S6jfq8NjVc/4Bc=;
        b=fHD+RK0SJgezmjy69VyEtaHuzNhQPDLAYYly2xkuVclR9sphv2GGf6yjENGew3jwo0
         xl0waS9ije87yGyskwpgyr4WaZx0cEIkIoIv4Kx1xwBLw0EqZAjw6iOfVK8AslKCVL7N
         w1A4ERGm3wji1cRbof9a0trFHdZvwkcoBckx0MOf+2eHGxUTeUMeg8VRJz1OJvnhzKiX
         gytYfUfT96BruUsxqJS9qHxIlVNnmuVcocJLx9ccdTv85mZAcKcImMZL9o6o+61h/ClB
         FZBNesYYXetNchZDOIilFRIBh/0Mecoiz03xxxdwqaBsrnBJVoC83LM74FN5MnLw+R9l
         UllA==
X-Gm-Message-State: AOJu0Yw5z/q9cpwzgP5DRNvmLaFNsbMV4KCJfotttompiGbuaoE8MAEM
	vm77l8D5tJAj9UHXJQYVgO/TNw==
X-Google-Smtp-Source: AGHT+IExNB53+dKAaQteMJJ3tL4g6Y2tu2/fzVZjUxh9Ut9cNeMdab+Ao7SyFlG70dLxdVCGxvodhA==
X-Received: by 2002:a05:6512:61c:b0:503:38c1:c848 with SMTP id b28-20020a056512061c00b0050338c1c848mr4902498lfe.50.1696545718603;
        Thu, 05 Oct 2023 15:41:58 -0700 (PDT)
Received: from ?IPV6:2001:14ba:a0db:1f00::8a5? (dzdqv0yyyyyyyyyyybcwt-3.rev.dnainternet.fi. [2001:14ba:a0db:1f00::8a5])
        by smtp.gmail.com with ESMTPSA id d24-20020ac25458000000b005009b979e3dsm31121lfn.303.2023.10.05.15.41.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Oct 2023 15:41:58 -0700 (PDT)
Message-ID: <1ad8c0f9-33cb-4d50-acce-b71c5a06cb71@linaro.org>
Date: Fri, 6 Oct 2023 01:41:57 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] drm/msm/dp: Inline dp_display_is_sink_count_zero()
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Vinod Polimera <quic_vpolimer@quicinc.com>,
 Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20230906181226.2198441-1-swboyd@chromium.org>
 <20230906181226.2198441-2-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20230906181226.2198441-2-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 06/09/2023 21:12, Stephen Boyd wrote:
> This function is basically a one-liner when you ignore the debug
> logging. Just inline the function and drop the log to simplify the code.
> 
> Suggested-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Vinod Polimera <quic_vpolimer@quicinc.com>
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/gpu/drm/msm/dp/dp_display.c | 10 +---------
>   1 file changed, 1 insertion(+), 9 deletions(-)

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
-- 
With best wishes
Dmitry

