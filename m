Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2300C1E495
	for <patches@lists.linux.dev>; Mon,  5 Aug 2024 12:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722862283; cv=none; b=OYwlrV2UjKcegBhy2eR3pZ59I0qFhDIgEZk0XPhIkWxx9YJnPzWmSs7XCtuvwDsFMpcyyHK33Mhb1VywdIhbJOZkzCA2cWikhei68JUsYmBt13DxXh16I/kQJurUdQjJNxok38ADxJYVJnG0n0WTR0JhUNnaYuQimCJoYbzLtvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722862283; c=relaxed/simple;
	bh=z4BX1QzEnxJRLmvdrew9bP42NWdLaykq40FAW0BPEKo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dHIsWBzsYJUItbzPxqP8ZlNDNyS/qOdA64QWZ18iwTSQgEkIfskz2+gUA4EmlQV+FkufoAYDps5EK2Cs5W1crIjM0lmJ3wsyUqJtJu3NtIDUW0t8L1nflsTczv88F/JQnWbpZZij9t7wO3wzTh0ZD4YgM8xhCLJztZNb6rIjZAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=M0h6Z+Bq; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=5SdBuif6; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="M0h6Z+Bq";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="5SdBuif6"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722862280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q/YW4TAEbkHNdMQJNf3vKU+tlrN+ni5Dt6BVMdGfvoo=;
	b=M0h6Z+Bq+6AgJdy8GQuenLJY+khUm5gt12Hhqgm3zZgFGrDtsmfVeYn7T/1U4Xm0lMsmyN
	SMbudsZgzpnY4VdHffbLqc/AGcYMyIz5kt+OWeg5qe0DwtelTIUucYaxOtHW6Wx0pymNvv
	GYIFLZq2/jVoqDdKWs3++KgCpxvhG6x+Yp+g4DjYIhFRyR4ek6uP1N6XVc8N2k+qKcTWve
	S6UahzXTSAjvsh1cz+aeeGYUsMwOZkXVNUqDebs0PSSglw4QcIIVSsFCGWVc8nLMtgQPK8
	x2/hLs1xifwuqAVaj7oZuGHPhcpMcspFsY6xuKyUCPU7PTUnYvazNwDvpBuTNA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722862280;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=q/YW4TAEbkHNdMQJNf3vKU+tlrN+ni5Dt6BVMdGfvoo=;
	b=5SdBuif6C17pv8uXJaNIJH411I/2GLdbNOdzVeQS/uIp5y5s+sxer9XiGjIQ36Lr+fDBcw
	8zyhpY58qbKD2VAA==
To: Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org,
 pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "Rafael J.
 Wysocki" <rafael.j.wysocki@intel.com>, Helge Deller <deller@gmx.de>, Parisc
 List <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
In-Reply-To: <87ikwf5owu.ffs@tglx>
References: <20240731095022.970699670@linuxfoundation.org>
 <718b8afe-222f-4b3a-96d3-93af0e4ceff1@roeck-us.net>
 <a8a81b3d-b005-4b6f-991b-c31cdb5513e5@roeck-us.net> <87ikwf5owu.ffs@tglx>
Date: Mon, 05 Aug 2024 14:51:19 +0200
Message-ID: <87frrj5e0o.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Aug 05 2024 at 10:56, Thomas Gleixner wrote:
> If this is really a race then the following must be true:
>
> 1) no delay
>
>    CPU0                                 CPU1
>    request_irq(IRQF_ONESHOT)
>                                         request_irq(IRQF_COND_ONESHOT)
>
> 2) delay
>
>    CPU0                                 CPU1
>                                         request_irq(IRQF_COND_ONESHOT)
>    request_irq(IRQF_ONESHOT)
>
>    In this case the request on CPU 0 fails with -EBUSY ...
>
> Confused

More confusing:

Adding a printk() in setup_irq() - using the config, rootfs and the run.sh
script from:

  http://server.roeck-us.net/qemu/parisc64-6.1.5/

results in:

[    0.000000] genirq: 64 flags: 00215600
[    0.000000] genirq: 65 flags: 00200400
[    8.110946] genirq: 66 flags: 00200080

IRQF_ONESHOT is 0x2000 which is not set by any of the interrupt
requests.

IRQF_COND_ONESHOT has only an effect when

    1) Interrupt is shared
    2) First interrupt request has IRQF_ONESHOT set

Neither #1 nor #2 are true, but maybe your current config enables some moar
devices than the one on your website.

Thanks,

        tglx
