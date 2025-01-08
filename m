Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 018307E765
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 02:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.125.188.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736303751; cv=none; b=budD1/KRdF5/04OiVgkQdA3nB0oORsnVi6g7kytGVXiJskGnRdPH0BKDfkOfLJ7iQFxyTwp5437dzmcP9wVczOb2zp29bCD53/HLgQ4FXl7QG30NXYh+D+tAM8ElRN7eHDh9rzqVbdmDYg/k10tlIwfHNmvX+MhNyNjfDhzjn+o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736303751; c=relaxed/simple;
	bh=19BoFY4Ykcn3CbZwasWdm3XUROKOK9y6YZCDs0xSyFs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uuZVmsHjWxGiBIfFsvFLq4BzW+tcu7b3DQB/U5vI0ZToRNMT8kSFrmyEc11kIbnihxnR/cwc8QgAQtwphVj1LWMZZMa+jwzwKA9kodCgQhaJlSjzwCeYOEqBLxFc604o8UTzqaqqub1E4X+zgHToU6pP+VkeJJmEET/zopFOhWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com; spf=pass smtp.mailfrom=canonical.com; dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b=u6ITMbyz; arc=none smtp.client-ip=185.125.188.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=canonical.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=canonical.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=canonical.com header.i=@canonical.com header.b="u6ITMbyz"
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id D08DD402EF
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 02:35:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20210705; t=1736303746;
	bh=RbmUowatO9+cLZYxGrSEkG1AWRSfwl5x6G2gnDgilpU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:In-Reply-To;
	b=u6ITMbyzMgtp4NIF1k4Bg9+UOKKB7zW9G1C8inWr7L/pXnMcmpBrtDZP77jgcIS61
	 GWR7ApizvtFjMGTE+AEXs80vFVavhY0Y8IXY25zkM+XUtVkxIPzaRHg8sZNIZT6U+Q
	 eYSv0wTZJHJ4om1VtxPoT6j76tq7AYiU7pWGCYNjr58ZyQIeuBuRw1M2fD7/m6cyWF
	 hpf/tVK8oISJHmsAWkEDu2H6nuTfACGRuEGhwbrQf7gtLyTmrfusC56QQUKPLzHgIb
	 aw/6+pCvosxb3LJwFShE9LAo9k0IHzjvfjRsUXYLk2WlJ769DaRc2V+zhdpTniIkKN
	 xSgFJSj92v1Lg==
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2ef9e4c5343so37493800a91.0
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 18:35:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736303745; x=1736908545;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RbmUowatO9+cLZYxGrSEkG1AWRSfwl5x6G2gnDgilpU=;
        b=ZbKb0CaVeUsAvlZqwLp2kOZtPxDXoq7OakcJpEgUGvNXJjj4YfCm/axYoNX37igdjb
         fI3egS9XQ21QU76AIpOe5RCyJuMrEfdcvBD4am3Jta8hNBBH9dw5Lk9d71FHuFU5iHvr
         k5PhfhImyPzZZsc2wDiRJ4w0bakhcV0Aq+qj46n8bZhcMq6g2aZGipcHBnodCoUh34bf
         h6HJ2HkRWKiDBjLjlqhR0fhC4wFPIz7wFq41AP+u+enn/9gAoJq6MIfSujF/mDWwPybc
         ka3NyUvLryKDo2ZaIpxp0zf9SP43fSPms9c3U44tvUC7DaUp5SkNNtPrOSd8R0X4qhEI
         32pQ==
X-Forwarded-Encrypted: i=1; AJvYcCUdyOtUs91DSCIO08UlCK1SEj5rI0HvlTSG1BlR6kLszbPextzq8JDzmYjHUKpfPu8IsDZDZEaN@lists.linux.dev
X-Gm-Message-State: AOJu0YxInzFffdYD35ppV8cY9+7p6ERi+VfMjJWFLzrCPoIhgvfWpmaL
	zsW9tqy7Dn2IvIzOQNpHQiAo4Hqe5FKEmc0ZhUvToN2P9L8UvG48HZcM7ZidNbEZcdKREi3ivEg
	uEkKL2LEWzAX3zFN+/vr/FO/+fNoOFP6bM/wSzxwSOBJMDgqYLuFK9idaBmNXlhtuzqoHeLw=
X-Gm-Gg: ASbGnctjIGvkAm9lxfsTaQzF9Ttk3dLufLVRd2SmW1vPWswc5adQi9lOFxTd1XD/HyC
	0odvRM6dihzeHE7o1mltePu38rPw73YzLcl+tU+DoYXaz6/4Jw3rhFL5yaUxVxYiu+LUPYCgWEp
	cU74pZ3Mec5ksqrIIsVWEljmHSTP6jggJo+b//9OKCbykVxwoZyuLwzgcCDglYidzLWGm7suLWS
	BDbwsLIKmuV9b2p8Db5HiRoAmpUnKJpc0E2WPr6JkFY/f+RCvYELvKP4WQ=
X-Received: by 2002:a05:6a00:3926:b0:72a:9ab2:4d90 with SMTP id d2e1a72fcca58-72d22047eb6mr2055556b3a.26.1736303745165;
        Tue, 07 Jan 2025 18:35:45 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEjevUC6hP6J8/kRABInAz1+u7nYWirERIs6ClVzrvB7VXfopr3bDYWfruhf8HuHL6NteMSGA==
X-Received: by 2002:a05:6a00:3926:b0:72a:9ab2:4d90 with SMTP id d2e1a72fcca58-72d22047eb6mr2055529b3a.26.1736303744751;
        Tue, 07 Jan 2025 18:35:44 -0800 (PST)
Received: from localhost ([240f:74:7be:1:4e52:6214:fe82:b2d3])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad90b2dcsm34131354b3a.171.2025.01.07.18.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 18:35:44 -0800 (PST)
Date: Wed, 8 Jan 2025 11:35:42 +0900
From: Koichiro Den <koichiro.den@canonical.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, mhiramat@kernel.org, 
	mark.rutland@arm.com, mathieu.desnoyers@efficios.com, 
	Zheng Yejian <zhengyejian1@huawei.com>, Hagar Hemdan <hagarhem@amazon.com>
Subject: Re: [PATCH 5.4 50/66] ftrace: Fix possible use-after-free issue in
 ftrace_location()
Message-ID: <5zpnqad2hfdoqkewr3esirjxaac2bnxvyjiabg7ttgmsi4dglf@si4cq3wuesih>
References: <20241115063722.834793938@linuxfoundation.org>
 <20241115063724.648039829@linuxfoundation.org>
 <74gjhwxupvozwop7ndhrh7t5qeckomt7yqvkkbm5j2tlx6dkfk@rgv7sijvry2k>
 <20250107111451.70c905d0@gandalf.local.home>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250107111451.70c905d0@gandalf.local.home>

On Tue, Jan 07, 2025 at 11:14:51AM -0500, Steven Rostedt wrote:
> On Tue, 7 Jan 2025 17:51:36 +0900
> Koichiro Den <koichiro.den@canonical.com> wrote:
> 
> > I observed that since this backport, on linux-5.4.y x86-64, a simple 'echo
> > function > current_tracer' without any filter can easily result in double
> > fault (int3) and system becomes unresponsible. linux-5.4.y x86 code has not
> > yet been converted to use text_poke(), so IIUC the issue appears to be that
> > the old ftrace_int3_handler()->ftrace_location() path now includes
> > rcu_read_lock() with this backport patch, which has mcount location inside,
> > that leads to the double fault.
> 
> Yep, I can easily reproduce this. Hmm, this should have been caught by
> running the ftrace selftests. I guess nobody is doing that on stable releases :-/
> 
> > 
> > I verified on an x86-64 qemu env that applying the following 11 additional
> > backports resolves the issue. The main purpose is to backport #7. All the
> > commits can be cleanly applied to the latest linux-5.4.y (v5.4.288).
> > 
> >   #11. fd3dc56253ac ftrace/x86: Add back ftrace_expected for ftrace bug reports
> >   #10. ac6c1b2ca77e ftrace/x86: Add back ftrace_expected assignment
> >    #9. 59566b0b622e x86/ftrace: Have ftrace trampolines turn read-only at the end of system boot up
> >    #8. 38ebd8d11924 x86/ftrace: Mark ftrace_modify_code_direct() __ref
> >    #7. 768ae4406a5c x86/ftrace: Use text_poke()
> >    #6. 63f62addb88e x86/alternatives: Add and use text_gen_insn() helper
> >    #5. 18cbc8bed0c7 x86/alternatives, jump_label: Provide better text_poke() batching interface
> >    #4. 8f4a4160c618 x86/alternatives: Update int3_emulate_push() comment
> >    #3. 72ebb5ff806f x86/alternative: Update text_poke_bp() kernel-doc comment
> >    #2. 3a1255396b5a x86/alternatives: add missing insn.h include
> >    #1. c3d6324f841b x86/alternatives: Teach text_poke_bp() to emulate instructions
> > 
> >   Note: #8-11 are follow-up fixes for #7
> >         #2-3 are follow-up fixes for #1
> 
> That's a lot to backport. Perhaps there's a simpler solution?
> 
> > 
> > According to [1], no regressions were observed on x86_64, which included
> > running kselftest-ftrace. So I'm a bit confused.
> 
> Yeah, that's a big failure!
> 
> Maybe they only tested a min config with no ftrace enabled?

It makes sense.

> 
> > 
> > Could someone take a look and shed light on this? (ftrace on linux-5.4.y x86)
> 
> I would like to know too!
> 
> > 
> > Thanks.
> > 
> > [1] https://lore.kernel.org/stable/CA+G9fYtdzDCDP_RxjPKS5wvQH=NsjT+bDRbukFqoX6cN+EHa7Q@mail.gmail.com/
> 
> Anyway, this appears to fix it (for 5.4 and earlier):
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 380032a27f98..2eb1a8ec5755 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1554,7 +1554,7 @@ unsigned long ftrace_location_range(unsigned long start, unsigned long end)
>  	struct dyn_ftrace key;
>  	unsigned long ip = 0;
>  
> -	rcu_read_lock();
> +	preempt_disable_notrace();
>  	key.ip = start;
>  	key.flags = end;	/* overload flags, as it is unsigned long */
>  
> @@ -1572,7 +1572,7 @@ unsigned long ftrace_location_range(unsigned long start, unsigned long end)
>  			break;
>  		}
>  	}
> -	rcu_read_unlock();
> +	preempt_enable_notrace();
>  	return ip;
>  }
>  
> 
> If someone would like to apply that, feel free. As preempt_disable() will
> give RCU protection as well.
> 
> Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>

Thanks a lot. I agree that too many backports could be risky, and your
suggestion looks good. I want it to appear on linux-5.4.y so I'll submit it
with your Signed-off-by tag.

Thanks again.

-Koichiro Den

> 
> -- Steve
