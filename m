Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCF7291E
	for <patches@lists.linux.dev>; Sat,  4 May 2024 05:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714802400; cv=none; b=eJetP9yCUHQWGTbpDyV5Jq/kxJ5BOy7hRb621rGmnCwT/z7BBGRlSIAT3JAMerbakhTx6VmN8w+KD+1UPj0cnwl+wDY7idzxZ+DFzhT8FFIUOYNN6TcPG7UGgkUB0V0cc0TBxFSy/3+OdinG5febC77O/pC1k0e5wCIhlFAFaz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714802400; c=relaxed/simple;
	bh=SbdFdjFhFvN8AoQXproeaoaxltpuBUXf+3bSRn6+OTw=;
	h=MIME-Version:In-Reply-To:References:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a/I+vSJ7jjHMRI4kyMB8hkUmL7lqeqYMHwEswL41V7//mbXaAQ6gIBpZjBmPfVjASd5gcxetcBsYWSewpjeaLpVziIEMNLJ1aO9vQ9Zo7+2tgqKyxIkCLsy/ZfjQOk1RkpTBEmMShl7g1R5553czJ1L+433uF4wWRlh4bkMKlNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=XK67sUif; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="XK67sUif"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-69b782287f9so1985166d6.0
        for <patches@lists.linux.dev>; Fri, 03 May 2024 22:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1714802398; x=1715407198; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pYUKHOIz20Zaag+mB5ITJHJPax3IqS8+eKF7gGGn3i0=;
        b=XK67sUifq5oGv9j/J0pFVFj+7dWm3P1JTa9/YQH2NH9cAv4od39a9RmYNUw4UUGQr3
         GpOp1e4qZKX4oVz+TS0JMt9uETdPnmuj5VEffRTbYx3oFXBJ0/oS7Xa8A397UvA1gXXl
         r0AgUJtURiU/HORnIcZpoYHvvg25Mzshu70Hk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714802398; x=1715407198;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pYUKHOIz20Zaag+mB5ITJHJPax3IqS8+eKF7gGGn3i0=;
        b=lGMJbNYNCz710aJPtsmu8QbeChCTmNQkgUInbyigk0Sbuci34Wb/Q7O3fnCyDOoLyv
         OeOTmpUVZFr/Fm/X0YG7u1FoTmkFgBlJzn3A9jAIt/q8Gz+p5F+U5B3US8YN67VkwH0F
         f/tPB71JW6EdUJa3SOg5qBCrkkNWpacVThj4RA2YZbr6bq53SGKafYZ4VOVUTbUjGCPu
         WOMbh7h05t5wXIuIVNknkYnSvR2XWRMx9Ct+y8/jKFw6t8VfBDsyb9Jnc2lVjxoFQbrV
         cjT7eCvPCtM5exQpl+u6GosvUaFFzzlCB91C4CKQkMoV7DIT4VpRWa2/CaJzoWgLkT9i
         e1rQ==
X-Forwarded-Encrypted: i=1; AJvYcCVw30rCtP463FKLb9XwOlIOIMDUKsFVik3ES6tTUf+r7wqNTbM2xkzTJPU+xAyvwiKKffu3aV314uImonspCwPNH/OxBatKWA==
X-Gm-Message-State: AOJu0YzhMd+krr/KN2YWNpR0WxfCyR7+M0o+5valrXsw+wd9KT8dbJGc
	67WWPDLIwAjK52/Ut0ELrwGpZXhZIOgV0iZAsPm59//vpK7yiVoB/KVGQUPd6HMwoXKwqQ57iys
	dlzE4w/cIqEuQDJdY0LyOZguiSRQaXi78OnbP
X-Google-Smtp-Source: AGHT+IFEvJdEhqjcviHSeTAGad+OdbhyV42PVCQRaUqM/rrkNHW2Qc3Zb94UjVibUGq+t/PlmzgKTqG5arIN0OFcXT4=
X-Received: by 2002:a05:6214:b6c:b0:6a0:5baa:1103 with SMTP id
 ey12-20020a0562140b6c00b006a05baa1103mr5520659qvb.39.1714802398361; Fri, 03
 May 2024 22:59:58 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 3 May 2024 22:59:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <267391c1-948c-9f75-69e6-b5b49d34a7fe@quicinc.com>
References: <20240502233017.419365-1-swboyd@chromium.org> <267391c1-948c-9f75-69e6-b5b49d34a7fe@quicinc.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Fri, 3 May 2024 22:59:57 -0700
Message-ID: <CAE-0n50Wy0ZEmPfxyacBnwUMNvFgiZ5RXdR-fy+JEjFkNg8=Rg@mail.gmail.com>
Subject: Re: [PATCH] clocksource/drivers/arm_arch_timer: Mark
 validate_timer_rate() init
To: Daniel Lezcano <daniel.lezcano@linaro.org>, Mukesh Ojha <quic_mojha@quicinc.com>, 
	Thomas Gleixner <tglx@linutronix.de>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, Jisheng Zhang <jszhang@kernel.org>, 
	Ionela Voinescu <ionela.voinescu@arm.com>, Marc Zyngier <maz@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>
Content-Type: text/plain; charset="UTF-8"

Quoting Mukesh Ojha (2024-05-03 04:27:52)
>
>
> On 5/3/2024 5:00 AM, Stephen Boyd wrote:
> > Add the __init marking to validate_timer_rate() so that it gets
> > discarded after init.
> >
> >    $ ./scripts/bloat-o-meter vmlinux.before vmlinux.after
> >    add/remove: 0/0 grow/shrink: 0/1 up/down: 0/-8 (-8)
> >    Function                                     old     new   delta
> >    arch_timer_register                         1724    1716      -8
>
> Have not used this tool bloat-o-meter
> Just a question, why is it showing arch_timer_register is shrunk ?

Hmm good question. There shouldn't be any difference if it gets inlined.

It's an allmodconfig build. It looks like that causes noise in the build so it
isn't stable. :( I diffed the objdump and the function is missing this ror and
nop instruction. But then I built it again, and it became more different. If I
build an allnoconfig it has zero difference.

Before:

  ffff800083021ed4:       974ba12d        bl      ffff80008030a388
<free_percpu_irq>
  ffff800083021ed8:       93d3f273        ror     x19, x19, #60
  ffff800083021edc:       d503201f        nop
  ffff800083021ee0:       d29858e0        mov     x0, #0xc2c7
           // #49863
  ffff800083021ee4:       910102b6        add     x22, x21, #0x40
  ffff800083021ee8:       f2aeea20        movk    x0, #0x7751, lsl #16
  ffff800083021eec:       f2ce7680        movk    x0, #0x73b4, lsl #32
  ffff800083021ef0:       f2f09e20        movk    x0, #0x84f1, lsl #48
  ffff800083021ef4:       ca000273        eor     x19, x19, x0
  ffff800083021ef8:       97527f02        bl      ffff8000804c1b00
<__sanitizer_cov_trace_pc>

After:

  ffff800083021ed4:       974ba12d        bl      ffff80008030a388
<free_percpu_irq>
  ffff800083021ed8:       d29f9f00        mov     x0, #0xfcf8
           // #64760
  ffff800083021edc:       910102b6        add     x22, x21, #0x40
  ffff800083021ee0:       f2b03940        movk    x0, #0x81ca, lsl #16
  ffff800083021ee4:       f2d5e700        movk    x0, #0xaf38, lsl #32
  ffff800083021ee8:       f2ee1340        movk    x0, #0x709a, lsl #48
  ffff800083021eec:       ca000273        eor     x19, x19, x0
  ffff800083021ef0:       97527f04        bl      ffff8000804c1b00
<__sanitizer_cov_trace_pc>

Maybe kcov is making things different?
