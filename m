Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A827F
	for <patches@lists.linux.dev>; Fri, 17 Jun 2022 06:44:25 +0000 (UTC)
Received: by mail-pg1-f176.google.com with SMTP id f65so3287546pgc.7
        for <patches@lists.linux.dev>; Thu, 16 Jun 2022 23:44:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=t5wVSTLROhkU8HXqMP/abdw9XRrdz4zSxZcZ0lfDfuM=;
        b=NZf6IJedrYbVqQt0JF0bEjSf1suhLv4Jknt7JX739ATYEU+n8RKZoMUgYH13SnYHBS
         93mmyPmsBXZppn/Uoz58gqhKrwlrjdOZy7lOWMJ6x06mc67pc+W9ZVdztz4f+F4tQ3Gz
         78f7TY2Zu4DS6ZbRbqwyKQb29pzJM4x/6PVOUqYVdoA5sOgL0L+106tP1lizZ7fth9Dm
         5QigGOEVEUvf3F5gEHhNyFQrwhxmhfPI4VAhfR45UeUY+cVV4JfNZQyYkWuH3Tu/ChTG
         DkJmAMzMN8KYEhFajeEXyjgkhFmIZIXds703WBqLln8kY9XXOC98HigIlyo/ntR3f2MX
         fwBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=t5wVSTLROhkU8HXqMP/abdw9XRrdz4zSxZcZ0lfDfuM=;
        b=d91mUSJuaA14JDDkZZFmsuoF8YsHtJxkQjhKAE0J3xVMK3fK0uNHzaGh+KUJ9ftO+7
         G5UdJTeXM6VcneezaTwYZJ/B8QyhCHdbU6SkDkh3DuLryn5ytuuCyzRHRKjuy7+8GnZL
         Fmn1W6O2xDG6xrg9IR04X7eZdvR9dzyoHSgoNKdfS6X50KTQcypnWU5dMG6But7dY1If
         snJuQ9bQCkLxs0gWKCTYdNnxkmJl+oFpucJWEKRd005tFJvr+eL/iBpeaqgrjNt1T6Dy
         bFkcBrSwUdXLLUQumTkZT4Wu5yRN2hL9013IZn+giLUH1vYO8TVpmVDcklz0u4+c3zKu
         m1yw==
X-Gm-Message-State: AJIora9imunQb4oh/SNLjGHv+E3xPi65GUrlgZb1PxJruKvxaW9eK/gC
	yKk7ervrUdlrLRrpOYJBpvcnKg==
X-Google-Smtp-Source: AGRyM1uq7S8kSg3oBvAaFiWizu03A5KLnSeV8ZxglZ5bHWEz7/GQ2rVJY2pLIuK25adJBoYozYwnQA==
X-Received: by 2002:a63:b105:0:b0:3fd:a875:d16 with SMTP id r5-20020a63b105000000b003fda8750d16mr7824743pgf.209.1655448264630;
        Thu, 16 Jun 2022 23:44:24 -0700 (PDT)
Received: from localhost ([122.162.234.2])
        by smtp.gmail.com with ESMTPSA id p15-20020a1709027ecf00b00165103c9903sm2731643plb.113.2022.06.16.23.44.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jun 2022 23:44:24 -0700 (PDT)
Date: Fri, 17 Jun 2022 12:14:21 +0530
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Cc: Stephen Boyd <swboyd@chromium.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, linux-pm@vger.kernel.org,
	linux-arm-msm@vger.kernel.org,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Rob Clark <robdclark@chromium.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Subject: Re: [PATCH] cpufreq: qcom-hw: Don't do lmh things without a throttle
 interrupt
Message-ID: <20220617064421.l4vshytmqtittzee@vireshk-i7>
References: <20220616224531.3139080-1-swboyd@chromium.org>
 <ce6106e5-3dfd-c2e7-07b9-91be9aef2cf4@linaro.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ce6106e5-3dfd-c2e7-07b9-91be9aef2cf4@linaro.org>

On 17-06-22, 03:21, Vladimir Zapolskiy wrote:
> On 6/17/22 01:45, Stephen Boyd wrote:
> > Offlining cpu6 and cpu7 and then onlining cpu6 hangs on
> > sc7180-trogdor-lazor because the throttle interrupt doesn't exist.
> > Similarly, things go sideways when suspend/resume runs. That's because
> > the qcom_cpufreq_hw_cpu_online() and qcom_cpufreq_hw_lmh_exit()
> > functions are calling genirq APIs with an interrupt value of '-6', i.e.
> > -ENXIO, and that isn't good.
> > 
> > Check the value of the throttle interrupt like we already do in other
> > functions in this file and bail out early from lmh code to fix the hang.
> > 
> > Reported-by: Rob Clark <robdclark@chromium.org>
> > Cc: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
> > Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> > Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > Fixes: a1eb080a0447 ("cpufreq: qcom-hw: provide online/offline operations")
> > Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> > ---
> >   drivers/cpufreq/qcom-cpufreq-hw.c | 6 ++++++
> >   1 file changed, 6 insertions(+)
> > 
> > diff --git a/drivers/cpufreq/qcom-cpufreq-hw.c b/drivers/cpufreq/qcom-cpufreq-hw.c
> > index 0253731d6d25..36c79580fba2 100644
> > --- a/drivers/cpufreq/qcom-cpufreq-hw.c
> > +++ b/drivers/cpufreq/qcom-cpufreq-hw.c
> > @@ -442,6 +442,9 @@ static int qcom_cpufreq_hw_cpu_online(struct cpufreq_policy *policy)
> >   	struct platform_device *pdev = cpufreq_get_driver_data();
> >   	int ret;
> > +	if (data->throttle_irq <= 0)
> > +		return 0;
> > +
> >   	ret = irq_set_affinity_hint(data->throttle_irq, policy->cpus);
> >   	if (ret)
> >   		dev_err(&pdev->dev, "Failed to set CPU affinity of %s[%d]\n",
> > @@ -469,6 +472,9 @@ static int qcom_cpufreq_hw_cpu_offline(struct cpufreq_policy *policy)
> >   static void qcom_cpufreq_hw_lmh_exit(struct qcom_cpufreq_data *data)
> >   {
> > +	if (data->throttle_irq <= 0)
> > +		return;
> > +
> >   	free_irq(data->throttle_irq, data);
> >   }
> > 
> Reviewed-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

Applied. Thanks.

-- 
viresh
