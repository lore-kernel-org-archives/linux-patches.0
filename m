Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E9977F
	for <patches@lists.linux.dev>; Fri, 17 Jun 2022 00:21:53 +0000 (UTC)
Received: by mail-lj1-f176.google.com with SMTP id d19so3112724lji.10
        for <patches@lists.linux.dev>; Thu, 16 Jun 2022 17:21:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=zELuLJDtp+1xwhB/xB/ct9I01uRFw28EJaVsfAJ8WPo=;
        b=w3npb2ddMCloZzfe9sbgDyA/TDkG1rxKALOo84wqy8EiYmc4xxsYxWi7HsB4s1iqQO
         SyXXO27gO0kOqMXkXFYf/i98b0mMoQh9ke3JdGUuK9Rt8oHWfmW5DJpLyePmUGZMzcjG
         8IxqXXkqEirYVX82Lqte5nnieFudBD7+WxL6F9ZgSBJN1nme7n3MdrTEmdI/Os/pUFf0
         EHJF94Q7khggNh59tYRPb3kBdsf9ltL57f32QKTMSuofMAwDBTi5APHIk0strKGdXcaY
         cQCB01ybj+/uxFJ7TOP4dYRirH2QYKXoyM353xeFZ1vC9hHbcj2GAzW4X1SFjzMexUvE
         y+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=zELuLJDtp+1xwhB/xB/ct9I01uRFw28EJaVsfAJ8WPo=;
        b=MkjMSmSjsP3bdnx88S8GtZVuafJwlFag8D+6pgBwnZwpkCKjSsNJ2iw+bQ54CqWa5R
         Hyz564bkXzTzfZ3y4yeCIyVvdpa8Kh+dbe5YLn5T6i0p8GwAoMMcAMDSywx4eN3dAuyj
         0AdqrP+NwU90BsDDc/5m+Xf6Z4Hk6RkL6E8SWbdCDGbVeS0t7jctjuT8oE8qzCIe8KG3
         wWsqTuPjCFnBNeT6FRablsKd5zp1xlOMS6sZRqr4NRPsVEHu2NIejhrGYdycfk2pLr4p
         6JnLMOoBsmmg4LwRgJknW4GCJTPXz29xGqWFF4otxgi+/mZIumAT4C/FO9b7GeyAxnRp
         yLYg==
X-Gm-Message-State: AJIora98Ov1hajPMle2Vte7lwYtxDVWwO5qR8lghaVpUC7mDampX1YP6
	NXLmqUwy2BMXBxE62s6mAqkKRg==
X-Google-Smtp-Source: AGRyM1to/gZ2Nf9OeKNJvqpJN5WGk4UVL31SFCT/xQZrevC+O/VwFUffzbhsFUTqvT9KDZYImYY5dw==
X-Received: by 2002:a2e:3315:0:b0:258:dfff:e252 with SMTP id d21-20020a2e3315000000b00258dfffe252mr3823905ljc.141.1655425311542;
        Thu, 16 Jun 2022 17:21:51 -0700 (PDT)
Received: from [192.168.1.102] (88-112-131-206.elisa-laajakaista.fi. [88.112.131.206])
        by smtp.gmail.com with ESMTPSA id r12-20020a2e80cc000000b0024f3d1dae84sm380589ljg.12.2022.06.16.17.21.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jun 2022 17:21:51 -0700 (PDT)
Message-ID: <ce6106e5-3dfd-c2e7-07b9-91be9aef2cf4@linaro.org>
Date: Fri, 17 Jun 2022 03:21:38 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] cpufreq: qcom-hw: Don't do lmh things without a throttle
 interrupt
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>, Viresh Kumar <viresh.kumar@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 "Rafael J. Wysocki" <rafael@kernel.org>, Rob Clark <robdclark@chromium.org>,
 Bjorn Andersson <bjorn.andersson@linaro.org>,
 Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
References: <20220616224531.3139080-1-swboyd@chromium.org>
From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
In-Reply-To: <20220616224531.3139080-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/22 01:45, Stephen Boyd wrote:
> Offlining cpu6 and cpu7 and then onlining cpu6 hangs on
> sc7180-trogdor-lazor because the throttle interrupt doesn't exist.
> Similarly, things go sideways when suspend/resume runs. That's because
> the qcom_cpufreq_hw_cpu_online() and qcom_cpufreq_hw_lmh_exit()
> functions are calling genirq APIs with an interrupt value of '-6', i.e.
> -ENXIO, and that isn't good.
> 
> Check the value of the throttle interrupt like we already do in other
> functions in this file and bail out early from lmh code to fix the hang.
> 
> Reported-by: Rob Clark <robdclark@chromium.org>
> Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Fixes: a1eb080a0447 ("cpufreq: qcom-hw: provide online/offline operations")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>   drivers/cpufreq/qcom-cpufreq-hw.c | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
> index 0253731d6d25..36c79580fba2 100644
> --- a/drivers/cpufreq/qcom-cpufreq-hw.c
> +++ b/drivers/cpufreq/qcom-cpufreq-hw.c
> @@ -442,6 +442,9 @@ static int qcom_cpufreq_hw_cpu_online(struct cpufreq_policy *policy)
>   	struct platform_device *pdev = cpufreq_get_driver_data();
>   	int ret;
>   
> +	if (data->throttle_irq <= 0)
> +		return 0;
> +
>   	ret = irq_set_affinity_hint(data->throttle_irq, policy->cpus);
>   	if (ret)
>   		dev_err(&pdev->dev, "Failed to set CPU affinity of %s[%d]\n",
> @@ -469,6 +472,9 @@ static int qcom_cpufreq_hw_cpu_offline(struct cpufreq_policy *policy)
>   
>   static void qcom_cpufreq_hw_lmh_exit(struct qcom_cpufreq_data *data)
>   {
> +	if (data->throttle_irq <= 0)
> +		return;
> +
>   	free_irq(data->throttle_irq, data);
>   }
>   
> 
Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

--
Best wishes,
Vladimir
