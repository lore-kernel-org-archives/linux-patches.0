Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 013591FB0
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 01:29:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MEwcfy7+"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-45290cda80aso2262131137.1
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696987798; x=1697592598; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lWuFBKKqDhyH9ygjY+VwyypVN7up/CrH54/6kzMnugU=;
        b=MEwcfy7+hocXpoEmnLdGp7yCI1/LyCFkZIFDQp5y/1gDQb5tJFdAPFWCy/TumOVEnt
         4kzaP+VOM3r9oLjEczfwjG1n8jI/JASmJGriwH9Cbcta0z/jFFQLQvXWTfJnK88DL7Ou
         OwnUDEwpczMqyH29gXR+ErBOZB2vbeRF6QoGYXszhQpEBzhuj+Tf80akP+jVKGazQGJH
         pVfHmKgT15Gs4brx9z893wYKS1/djvnQkIzH7FgLznOFmYTRxfUh6aH8VXoyBiLy1OiR
         +Fct3nZoilSz/RYRajzvUMOrHbNgaX5eyrW46TR0K4iBq4JgnW1T3QX7XcSDCxcOihgx
         cb/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696987798; x=1697592598;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lWuFBKKqDhyH9ygjY+VwyypVN7up/CrH54/6kzMnugU=;
        b=DMizNJs9+a3NyK5E1Cpxy4H7ZqLX7dQY8v6kDggtHGEm/kZrJuF0S7KigQ+bZiuN2o
         VqT4rPDNGkwU++ypmUWjr3r20Eoq84WhZfJyL1TQhzatIZFEGo0RCyilfidvr/3ef9n3
         GWSBWLBTnLnlJy4hNm6QdPWpE4dHcdYjX74JvBF6hP6hZeLVFQx8RM8EIpz/cuXDNqd2
         6p36225SlaYvN/2VwRuvgQQIu0INk4Yn+C7J0XcpiTZDYysMc6raCrXRAfTsWSRqfZj/
         dDNh5zPZ79FtqFlAjhb5IsjLfw7whtrnmsDMUrG1lPRl2m61JlbSuhQGCmtpdrajgS3t
         mhaA==
X-Gm-Message-State: AOJu0YyBLqJsN1Z3pcnPV4erYp4KeRXk2DtQpqu/LqPAD1Y4QDUp0/21
	8LeAKKwvqNN3ZQYyA5PBHUrhJeqhg2c++Qk12btNcA==
X-Google-Smtp-Source: AGHT+IFCWB/Ae+449zxX31uUmJSvyG4meqJ8N8WMX+ukDDkIGR2Aqp6p5NLpGxM5oQfeDcPRNUQwmc+p7LFJrZQySUM=
X-Received: by 2002:a67:f5c8:0:b0:44e:93f4:3c85 with SMTP id
 t8-20020a67f5c8000000b0044e93f43c85mr14894882vso.12.1696987797618; Tue, 10
 Oct 2023 18:29:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230424131121.155649464@linuxfoundation.org> <CA+G9fYstB_fROK9LHYuQ8dc2ArieGGAW_x69eEX-eAi5xMeE3Q@mail.gmail.com>
 <20230426170945.0ec0f1ef@gandalf.local.home> <20230426181415.17c893f5@gandalf.local.home>
 <CA+G9fYtd=dJEM=+xOHA9Egs88r+gEfrnW_gFnTFm4of5uTQ7mA@mail.gmail.com>
In-Reply-To: <CA+G9fYtd=dJEM=+xOHA9Egs88r+gEfrnW_gFnTFm4of5uTQ7mA@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 11 Oct 2023 06:59:46 +0530
Message-ID: <CA+G9fYt518bg10DVo=ag=iGB8dj_NQZEmEty1CdkU3Cj+gtW0w@mail.gmail.com>
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

Hi Steven and Greg,

On Thu, 27 Apr 2023 at 15:19, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Hi Steven,
>
> On Wed, 26 Apr 2023 at 23:14, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > On Wed, 26 Apr 2023 17:09:45 -0400
> > Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > > Now the question is, why is this triggering on 4.19 but not in latest
> > > mainline?
> >
> > I found it, I backported this patch and the warning goes away (at least for
> > me). Can you add this and see if it makes the warning go away for you too?
>
> I have applied this patch on stable-rc 4.19 branch and tested on
> - arm64: Juno-r2
>  - x86_64 device
>
> and the reported problem has been resolved.
>
> Thanks for finding a quick fix patch.
>
> >
> > -- Steve
> >
> > From: Peter Zijlstra <peterz@infradead.org>
> > Date: Fri, 7 Aug 2020 20:50:19 +0200
> > Subject: [PATCH] sched,idle,rcu: Push rcu_idle deeper into the idle path
> >
> > commit 1098582a0f6c4e8fd28da0a6305f9233d02c9c1d upstream.

Can we expect this patch to be merged into 4.19 ?
The reason for the question is, the reported problem is still seen on
stable-rc 4.19.

> >
> > Lots of things take locks, due to a wee bug, rcu_lockdep didn't notice
> > that the locking tracepoints were using RCU.
> >
> > Push rcu_idle_{enter,exit}() as deep as possible into the idle paths,
> > this also resolves a lot of _rcuidle()/RCU_NONIDLE() usage.
> >
> > Specifically, sched_clock_idle_wakeup_event() will use ktime which
> > will use seqlocks which will tickle lockdep, and
> > stop_critical_timings() uses lock.
> >
> > Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
> > Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
> > Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > Tested-by: Marco Elver <elver@google.com>
> > Link: https://lkml.kernel.org/r/20200821085348.310943801@infradead.org
>
>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Tested-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>
> test log:
>   - https://lkft.validation.linaro.org/scheduler/job/6380295#L1418
>   - https://lkft.validation.linaro.org/scheduler/job/6380303#L1443
>
> > ---
> >  drivers/cpuidle/cpuidle.c | 12 ++++++++----
> >  kernel/sched/idle.c       | 22 ++++++++--------------
> >  2 files changed, 16 insertions(+), 18 deletions(-)
> >
> > diff --git a/drivers/cpuidle/cpuidle.c b/drivers/cpuidle/cpuidle.c
> > index 2d182dc1b49e..01bde6dec13a 100644
> > --- a/drivers/cpuidle/cpuidle.c
> > +++ b/drivers/cpuidle/cpuidle.c
> > @@ -140,13 +140,14 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
> >          * executing it contains RCU usage regarded as invalid in the idle
> >          * context, so tell RCU about that.
> >          */
> > -       RCU_NONIDLE(tick_freeze());
> > +       tick_freeze();
> >         /*
> >          * The state used here cannot be a "coupled" one, because the "coupled"
> >          * cpuidle mechanism enables interrupts and doing that with timekeeping
> >          * suspended is generally unsafe.
> >          */
> >         stop_critical_timings();
> > +       rcu_idle_enter();
> >         drv->states[index].enter_s2idle(dev, drv, index);
> >         if (WARN_ON_ONCE(!irqs_disabled()))
> >                 local_irq_disable();
> > @@ -155,7 +156,8 @@ static void enter_s2idle_proper(struct cpuidle_driver *drv,
> >          * first CPU executing it calls functions containing RCU read-side
> >          * critical sections, so tell RCU about that.
> >          */
> > -       RCU_NONIDLE(tick_unfreeze());
> > +       rcu_idle_exit();
> > +       tick_unfreeze();
> >         start_critical_timings();
> >
> >         time_end = ns_to_ktime(local_clock());
> > @@ -224,16 +226,18 @@ int cpuidle_enter_state(struct cpuidle_device *dev, struct cpuidle_driver *drv,
> >         /* Take note of the planned idle state. */
> >         sched_idle_set_state(target_state);
> >
> > -       trace_cpu_idle_rcuidle(index, dev->cpu);
> > +       trace_cpu_idle(index, dev->cpu);
> >         time_start = ns_to_ktime(local_clock());
> >
> >         stop_critical_timings();
> > +       rcu_idle_enter();
> >         entered_state = target_state->enter(dev, drv, index);
> > +       rcu_idle_exit();
> >         start_critical_timings();
> >
> >         sched_clock_idle_wakeup_event();
> >         time_end = ns_to_ktime(local_clock());
> > -       trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, dev->cpu);
> > +       trace_cpu_idle(PWR_EVENT_EXIT, dev->cpu);
> >
> >         /* The cpu is no longer idle or about to enter idle. */
> >         sched_idle_set_state(NULL);
> > diff --git a/kernel/sched/idle.c b/kernel/sched/idle.c
> > index 44a17366c8ec..4e3d149d64ad 100644
> > --- a/kernel/sched/idle.c
> > +++ b/kernel/sched/idle.c
> > @@ -53,17 +53,18 @@ __setup("hlt", cpu_idle_nopoll_setup);
> >
> >  static noinline int __cpuidle cpu_idle_poll(void)
> >  {
> > +       trace_cpu_idle(0, smp_processor_id());
> > +       stop_critical_timings();
> >         rcu_idle_enter();
> > -       trace_cpu_idle_rcuidle(0, smp_processor_id());
> >         local_irq_enable();
> > -       stop_critical_timings();
> >
> >         while (!tif_need_resched() &&
> > -               (cpu_idle_force_poll || tick_check_broadcast_expired()))
> > +              (cpu_idle_force_poll || tick_check_broadcast_expired()))
> >                 cpu_relax();
> > -       start_critical_timings();
> > -       trace_cpu_idle_rcuidle(PWR_EVENT_EXIT, smp_processor_id());
> > +
> >         rcu_idle_exit();
> > +       start_critical_timings();
> > +       trace_cpu_idle(PWR_EVENT_EXIT, smp_processor_id());
> >
> >         return 1;
> >  }
> > @@ -90,7 +91,9 @@ void __cpuidle default_idle_call(void)
> >                 local_irq_enable();
> >         } else {
> >                 stop_critical_timings();
> > +               rcu_idle_enter();
> >                 arch_cpu_idle();
> > +               rcu_idle_exit();
> >                 start_critical_timings();
> >         }
> >  }
> > @@ -148,7 +151,6 @@ static void cpuidle_idle_call(void)
> >
> >         if (cpuidle_not_available(drv, dev)) {
> >                 tick_nohz_idle_stop_tick();
> > -               rcu_idle_enter();
> >
> >                 default_idle_call();
> >                 goto exit_idle;
> > @@ -166,19 +168,15 @@ static void cpuidle_idle_call(void)
> >
> >         if (idle_should_enter_s2idle() || dev->use_deepest_state) {
> >                 if (idle_should_enter_s2idle()) {
> > -                       rcu_idle_enter();
> >
> >                         entered_state = cpuidle_enter_s2idle(drv, dev);
> >                         if (entered_state > 0) {
> >                                 local_irq_enable();
> >                                 goto exit_idle;
> >                         }
> > -
> > -                       rcu_idle_exit();
> >                 }
> >
> >                 tick_nohz_idle_stop_tick();
> > -               rcu_idle_enter();
> >
> >                 next_state = cpuidle_find_deepest_state(drv, dev);
> >                 call_cpuidle(drv, dev, next_state);
> > @@ -195,8 +193,6 @@ static void cpuidle_idle_call(void)
> >                 else
> >                         tick_nohz_idle_retain_tick();
> >
> > -               rcu_idle_enter();
> > -
> >                 entered_state = call_cpuidle(drv, dev, next_state);
> >                 /*
> >                  * Give the governor an opportunity to reflect on the outcome
> > @@ -212,8 +208,6 @@ static void cpuidle_idle_call(void)
> >          */
> >         if (WARN_ON_ONCE(irqs_disabled()))
> >                 local_irq_enable();
> > -
> > -       rcu_idle_exit();
> >  }
> >
> >  /*
> > --
> > 2.39.2
>
> - Naresh
>
>
> --
> Linaro LKFT
> https://lkft.linaro.org
