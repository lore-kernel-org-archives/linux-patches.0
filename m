Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6244C24218
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 11:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FzGo8IYs"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7b5f28da928so369453241.0
        for <patches@lists.linux.dev>; Thu, 12 Oct 2023 04:53:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697111615; x=1697716415; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uv9vHkm6rlhqB3eHJ86eScSsXZykNgvtMNnhRbSwb6o=;
        b=FzGo8IYsQhzayAq4xY5gx12nNcGh4XkIENMIyxCIhxU5GTLVwRnDCPmZAHTHJPhfKD
         7t7hCn/1ArqKmZ0pxjVNAfjHAL4TCLJtMuLIYe+z7fZj/p6EQnxOKPKXZh/TPZUBgmJm
         KbOCCYB6Ubf2GMk7LN3XqFnVkIBz9eul0gcWPaOXErByftOEoPpSdq7430JYHYWRa8Px
         5tCXxq2DiSSO6mIBWiZutvWcZuwHOYh2ZxeNQTADOlOQw3lhjhyf6oRyFS7y0oFBXAMp
         h1JdRJeTA8zLpFE1O+pFIAYbmoQGUvSkYc4WESyDeXrFQeHSoPBGYJbJ5aX1GceALZCh
         HrSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697111615; x=1697716415;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uv9vHkm6rlhqB3eHJ86eScSsXZykNgvtMNnhRbSwb6o=;
        b=JM+XnN/ypw1wdxZVL68Htdl3PaPVrRV94YW1vVAGcw1dRQ+H0zsU3/VY1lGN6DvfQA
         bNyGoAeOLoc/Qszv6ZrjUeBv5ZfO6AHzx2Aw67XgM1lkQXsrMPkW0PMVKXL9/KHdc3VV
         kwDyfnUnuCRVtL49pj6kTiD0drRALxSnEM27V51FBJrPqkn36DeedzZ3f6m1qrNgrm49
         xUIj+rQqdinMsTfOAHQDukTWNsTfxdagUhxJmlUaLhNyI1lVsvGLlV3Z9nRphUVfPcsq
         U9CIrlQv7cjdHYh+77q7FmUfzxkGjHY6HxxDkXr/Qfeo+kbSIbRhs6332Oz/0rBidr2Z
         VA+Q==
X-Gm-Message-State: AOJu0YzKa8MxABA3jhD07JO6ARUd/JaSUNmJF8n0iHQR4wl38iTBitsV
	G+7YelSEiY/24hqtg+iQOBm+6U4xjcceS2yolCtOUA==
X-Google-Smtp-Source: AGHT+IE4+mLf1JSjcXv5Ud8DXgBA8a5MsJy7HXzQtqp53gl0Z3tCSOjgWaBGlr7tOrGVn8mXv33WJyYCoTo2fOmevZw=
X-Received: by 2002:a05:6102:534:b0:44e:a18a:2507 with SMTP id
 m20-20020a056102053400b0044ea18a2507mr18640066vsa.0.1697111614902; Thu, 12
 Oct 2023 04:53:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230424131121.155649464@linuxfoundation.org> <CA+G9fYstB_fROK9LHYuQ8dc2ArieGGAW_x69eEX-eAi5xMeE3Q@mail.gmail.com>
 <20230426170945.0ec0f1ef@gandalf.local.home> <20230426181415.17c893f5@gandalf.local.home>
 <CA+G9fYtd=dJEM=+xOHA9Egs88r+gEfrnW_gFnTFm4of5uTQ7mA@mail.gmail.com>
 <CA+G9fYt518bg10DVo=ag=iGB8dj_NQZEmEty1CdkU3Cj+gtW0w@mail.gmail.com>
 <2023101132-playable-flagstick-1abf@gregkh> <2023101125-subpanel-enviably-28cd@gregkh>
 <20231011104529.75f53d4b@gandalf.local.home>
In-Reply-To: <20231011104529.75f53d4b@gandalf.local.home>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 12 Oct 2023 17:23:23 +0530
Message-ID: <CA+G9fYuvtzQxL=RQ=zQB_Bn+-dcGwvXVnfHPqMaQHA-L5ydj4w@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/29] 4.19.282-rc1 review
To: Steven Rostedt <rostedt@goodmis.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masami Hiramatsu <mhiramat@kernel.org>, stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, Mark Rutland <mark.rutland@arm.com>, 
	"Paul E. McKenney" <paulmck@kernel.org>, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 11 Oct 2023 at 20:14, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> On Wed, 11 Oct 2023 11:05:48 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> > > Ok, I'll queue it up now, I didn't realize it needed to be there, sorry.
> >
> > Nope, I can't, it doesn't apply there, so I need a backported, and
> > TESTED version, for 5.4.y and 4.19.y if anyone wants to see it there.
>
> This is a quick backport for 4.19 as the conflict seemed to be due to added
> code that is unrelated to this change. I built and booted it, but it should
> have more testing.
>
> Naresh, if you want this in 4.19, please run it through your tests and give
> your tested by.
>
> Greg, please do not take it until Naresh has tested it.

Below patch applied and tested on top of stable rc branches
 - v4.19.296
 - v5.4.258

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>

> diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> index 2d182dc1b49e..01bde6dec13a 100644
> --- a/drivers/cpuidle/cpuidle.c
> +++ b/drivers/cpuidle/cpuidle.c
> @@ -140,13 +140,14 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
>          * executing it contains RCU usage regarded as invalid in the idle
>          * context, so tell RCU about that.
>          */
> -       RCU_NONIDLE(tick_freeze());
> +       tick_freeze();
>         /*
>          * The state used here cannot be a "coupled" one, because the "coupled"
>          * cpuidle mechanism enables interrupts and doing that with timekeeping
>          * suspended is generally unsafe.
>          */
>         stop_critical_timings();
> +       rcu_idle_enter();
>         drv->states[index].enter_s2idle(dev, drv, index);
>         if (WARN_ON_ONCE(!irqs_disabled()))
>                 local_irq_disable();
> @@ -155,7 +156,8 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
>          * first CPU executing it calls functions containing RCU read-side
>          * critical sections, so tell RCU about that.
>          */
> -       RCU_NONIDLE(tick_unfreeze());
> +       rcu_idle_exit();
> +       tick_unfreeze();
>         start_critical_timings();
>
>         time_end = ns_to_ktime(local_clock());
> @@ -224,16 +226,18 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
>         /* Take note of the planned idle state. */
>         sched_idle_set_state(target_state);
>
> -       trace_cpu_idle_rcuidle(index, dev->cpu);
> +       trace_cpu_idle(index, dev->cpu);
>         time_start = ns_to_ktime(local_clock());
>
>         stop_critical_timings();
> +       rcu_idle_enter();
>         entered_state = target_state->enter(dev, drv, index);
> +       rcu_idle_exit();
>         start_critical_timings();
>
>         sched_clock_idle_wakeup_event();
>         time_end = ns_to_ktime(local_clock());
> -       trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
> +       trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
>
>         /* The cpu is no longer idle or about to enter idle. */
>         sched_idle_set_state(NULL);
> diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> index 44a17366c8ec..4e3d149d64ad 100644
> --- a/kernel/sched/idle.c
> +++ b/kernel/sched/idle.c
> @@ -53,17 +53,18 @@ __setup("hlt", cpu_idle_nopoll_setup);
>
>  static noinline int __cpuidle cpu_idle_poll(void)
>  {
> +       trace_cpu_idle(0, smp_processor_id());
> +       stop_critical_timings();
>         rcu_idle_enter();
> -       trace_cpu_idle_rcuidle(0, smp_processor_id());
>         local_irq_enable();
> -       stop_critical_timings();
>
>         while (!tif_need_resched() &&
> -               (cpu_idle_force_poll || tick_check_broadcast_expired()))
> +              (cpu_idle_force_poll || tick_check_broadcast_expired()))
>                 cpu_relax();
> -       start_critical_timings();
> -       trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
> +
>         rcu_idle_exit();
> +       start_critical_timings();
> +       trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
>
>         return 1;
>  }
> @@ -90,7 +91,9 @@ void __cpuidle default_idle_call(void)
>                 local_irq_enable();
>         } else {
>                 stop_critical_timings();
> +               rcu_idle_enter();
>                 arch_cpu_idle();
> +               rcu_idle_exit();
>                 start_critical_timings();
>         }
>  }
> @@ -148,7 +151,6 @@ static void cpuidle_idle_call(void)
>
>         if (cpuidle_not_available(drv, dev)) {
>                 tick_nohz_idle_stop_tick();
> -               rcu_idle_enter();
>
>                 default_idle_call();
>                 goto exit_idle;
> @@ -166,19 +168,15 @@ static void cpuidle_idle_call(void)
>
>         if (idle_should_enter_s2idle() || dev->use_deepest_state) {
>                 if (idle_should_enter_s2idle()) {
> -                       rcu_idle_enter();
>
>                         entered_state = cpuidle_enter_s2idle(drv, dev);
>                         if (entered_state > 0) {
>                                 local_irq_enable();
>                                 goto exit_idle;
>                         }
> -
> -                       rcu_idle_exit();
>                 }
>
>                 tick_nohz_idle_stop_tick();
> -               rcu_idle_enter();
>
>                 next_state = cpuidle_find_deepest_state(drv, dev);
>                 call_cpuidle(drv, dev, next_state);
> @@ -195,8 +193,6 @@ static void cpuidle_idle_call(void)
>                 else
>                         tick_nohz_idle_retain_tick();
>
> -               rcu_idle_enter();
> -
>                 entered_state = call_cpuidle(drv, dev, next_state);
>                 /*
>                  * Give the governor an opportunity to reflect on the outcome
> @@ -212,8 +208,6 @@ static void cpuidle_idle_call(void)
>          */
>         if (WARN_ON_ONCE(irqs_disabled()))
>                 local_irq_enable();
> -
> -       rcu_idle_exit();
>  }
>
>  /*
