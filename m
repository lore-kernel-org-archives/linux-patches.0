Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA71D2E0
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 05:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=joelfernandes.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=joelfernandes.org header.i=@joelfernandes.org header.b="Wg7k7o7s"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-79f95cd15dfso250189939f.0
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 22:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google; t=1697000705; x=1697605505; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WxTb+tzaW80rCd53UmA2HdlmPdirZzFTdr3/d2GhRv0=;
        b=Wg7k7o7sj+Lv4pzhua6H++G93Z1dQJiK0sCf2ITD/w67a6zMAVa/przph/i6ymvTCa
         WIMSaHtkCpJhu+E21HQ2IdXEgjirUfKnFP0TBzrTeb/Qx7zel0IKmaf/vIoFsW4owIIy
         o9nuOeiO70o3EtpZaBHcGHku06XVk8MFO3iww=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697000705; x=1697605505;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WxTb+tzaW80rCd53UmA2HdlmPdirZzFTdr3/d2GhRv0=;
        b=YZAUHL0rDi6Brps6LzKvHa6zmk7Yd9Xkj/akBlzf52sWCaDH9O47o+jNw4RmV04L+l
         VI6uNLH0ziSSWPfipTgfu+m1pJKRcRcZd/OoFxjp3hp3VG6vc7WkrN1D0aVIn6BcQ2V4
         qD5ef68quYRmjkesiiirqJ65/P1w0PWpG78qL3Jd1PyaZd9sVQymXH20Jti2b8pr2Ju2
         DXS33YVDTrlt2cydMfBVT3cMUVlTC9AdbwqsQw4mhS6Tf5MLckYuawsZAijY6eB4kMIt
         vF6SPn2hGGtjFpksUC6fQHr3T5T8C+f6gQMmft4YW/h/fzagxKC52QJlZopasZgCdkr1
         3ukQ==
X-Gm-Message-State: AOJu0YycezpUy2qEkkyTq2HCEoA1u9kqCDWEeutnCyt6zwZWQw2ysZWD
	NTv+HeGnN21+W7I2LAPrBEA94A==
X-Google-Smtp-Source: AGHT+IFy03G2cJuFBIp6FGEixKXoqXrVTKJalXLWgyRWJ4CG+YpsKoYUI6z524T5aX5M2yqvkC+r0w==
X-Received: by 2002:a5d:9954:0:b0:786:f4a0:d37e with SMTP id v20-20020a5d9954000000b00786f4a0d37emr19775042ios.4.1697000705583;
        Tue, 10 Oct 2023 22:05:05 -0700 (PDT)
Received: from localhost (161.74.123.34.bc.googleusercontent.com. [34.123.74.161])
        by smtp.gmail.com with ESMTPSA id m11-20020a02c88b000000b0042b35e163besm3195221jao.88.2023.10.10.22.05.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 22:05:05 -0700 (PDT)
Date: Wed, 11 Oct 2023 05:05:04 +0000
From: Joel Fernandes <joel@joelfernandes.org>
To: "Paul E. McKenney" <paulmck@kernel.org>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Naresh Kamboju <naresh.kamboju@linaro.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, Chengming Zhou <zhouchengming@bytedance.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ovidiu Panait <ovidiu.panait@windriver.com>,
	Ingo Molnar <mingo@kernel.org>, rcu <rcu@vger.kernel.org>
Subject: Re: [PATCH 5.15 000/183] 5.15.134-rc1 review
Message-ID: <20231011050504.GA201855@google.com>
References: <20231004175203.943277832@linuxfoundation.org>
 <CA+G9fYunnEUT2evdabX1KOTiryP1heNHWDH4LWZCt2SVRmnKOA@mail.gmail.com>
 <20231006162038.d3q7sl34b4ouvjxf@revolver>
 <57c1ff4d-f138-4f89-8add-c96fb3ba6701@paulmck-laptop>
 <20231006175714.begtgj6wrs46ukmo@revolver>
 <7652477c-a37c-4509-9dc9-7f9d1dc08291@paulmck-laptop>
 <CAEXW_YS16NxPxg52T=3FcyZ2qocj36zKyhPnEQL3nBTbD-qJ-A@mail.gmail.com>
 <9470dab6-dee5-4505-95a2-f6782b648726@paulmck-laptop>
 <433f5823-059c-4b51-8d18-8b356a5a507f@paulmck-laptop>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <433f5823-059c-4b51-8d18-8b356a5a507f@paulmck-laptop>

On Tue, Oct 10, 2023 at 06:34:35PM -0700, Paul E. McKenney wrote:
[...]
> > > > > > > It's also worth noting that the bug this fixes wasn't exposed until the
> > > > > > > maple tree (added in v6.1) was used for the IRQ descriptors (added in
> > > > > > > v6.5).
> > > > > >
> > > > > > Lots of latent bugs, to be sure, even with rcutorture.  :-/
> > > > >
> > > > > The Right Thing is to fix the bug all the way back to the introduction,
> > > > > but what fallout makes the backport less desirable than living with the
> > > > > unexposed bug?
> > > >
> > > > You are quite right that it is possible for the risk of a backport to
> > > > exceed the risk of the original bug.
> > > >
> > > > I defer to Joel (CCed) on how best to resolve this in -stable.
> > > 
> > > Maybe I am missing something but this issue should also be happening
> > > in mainline right?
> > > 
> > > Even though mainline has 897ba84dc5aa ("rcu-tasks: Handle idle tasks
> > > for recently offlined CPUs") , the warning should still be happening
> > > due to Liam's "kernel/sched: Modify initial boot task idle setup"
> > > because the warning is just rearranged a bit but essentially the same.
> > > 
> > > IMHO, the right thing to do then is to drop Liam's patch from 5.15 and
> > > fix it in mainline (using the ideas described in this thread), then
> > > backport both that new fix and Liam's patch to 5.15.
> > > 
> > > Or is there a reason this warning does not show up on the mainline?
> 
> There is not a whole lot of commonality between the v5.15.134 version of
> RCU Tasks Trace and that of mainline.  In theory, in mainline, CPU hotplug
> is supposed to be disabled across all calls to trc_inspect_reader(),
> which means that there would not be any CPU coming or going.
> 
> But there could potentially be some time between when a CPU was
> marked as online and its idle task was marked PF_IDLE.  And in
> fact x86 start_secondary() invokes set_cpu_online() before it calls
> cpu_startup_entry(), and it is the latter than sets PF_IDLE.
> 
> The same is true of alpha, arc, arm, arm64, csky, ia64, loongarch, mips,
> openrisc, parisc, powerpc, riscv, s390, sh, sparc32, sparc64, x86 xen,
> and xtensa, which is everybody.
> 
> One reason why my testing did not reproduce this is because I was running
> against v6.6-rc1, and cff9b2332ab7 ("kernel/sched: Modify initial boot
> task idle setup") went into v6.6-rc3.  An initial run merging in current
> mainline also failed to reproduce this, but I am running overnight.
> If that doesn't reproduce, I will try inserting delays between the
> set_cpu_online() and the cpu_startup_entry().

I thought the warning happens before set_cpu_online() is even called, because
under such situation, ofl == true and the task is not set to PF_IDLE yet:

                  WARN_ON_ONCE(ofl && task_curr(t) && !is_idle_task(t));

> If this problem is real, fixes include:
> 
> o	Revert Liam's patch and make Tiny RCU's call_rcu() deal with
> 	the problem.  This is overhead and non-tinyness, but to Joel's
> 	point, it might be best.
> 
> o	Go back to something more like Liam's original patch, which
> 	cleared PF_IDLE only for the boot CPU.
> 
> o	Set PF_IDLE before calling set_cpu_online().  This would work,
> 	but it would also be rather ugly, reaching into each and every
> 	architecture.
> 
> o	Move the call to set_cpu_online() into cpu_startup_entry().
> 	This would require some serious inspection to prove that it is
> 	safe, assuming that it is in fact safe.
> 
> o	Drop the WARN_ON_ONCE() from trc_inspect_reader().  Not all
> 	that excited by losing this diagnostic, but then again it
> 	has been awhile since it has caught anything.
> 
> o	Make the WARN_ON_ONCE() condition in trc_inspect_reader() instead
> 	to a "return false" to retry later.  Ditto, also not liking the
> 	possibility of indefinite deferral with no warning.

Just for completeness, 

 o      Since it just a warning, checking for task_struct::pid == 0 instead of is_idle_task()?
        Though PF_IDLE is also set in play_idle_precise().

 o	Change warning to:
                  WARN_ON_ONCE(ofl && task_curr(t) && (!is_idle_task(t) && t->pid != 0));

thanks,

 - Joel

