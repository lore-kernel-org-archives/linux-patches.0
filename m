Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E993414EC7E
	for <patches@lists.linux.dev>; Mon,  5 Aug 2024 08:56:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722848165; cv=none; b=qcx7UlTd6djhIvytWqWB+VZ94BCgLAT+IPD3/Gkct+iZ2jbzIgGdlSdKWzJbsXxMcx3GQUtoCmE1IhqTOpW+MkY7TGR3OQJHn4+b/zgbiM6tTRQMC4yftaG4eE55HgQ04InQWalnzJHs4HGa089QUM3S3tryxHrXbmXW7pCMeFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722848165; c=relaxed/simple;
	bh=s1n91oB+uxsmRXvCFdhDBqrbPSA/dUPO6Se1kMtbbH8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=K1UscGnIMhBO8G/5mAXEWaUPobjga6QGMMiMYWqc6x1OcrHJ0m9Ia0PiqLf5P1TxgZ3eNJjH83rhSlY2wTOtiolsFpMN0wTi4HYyMEjxGkH9rOyh+vJGAP4Eam+OIFxo52RvPiJ2QESdaln4qV1xzwLtDB0kU0cl9nAF7J/Avpo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=Lv8666Vr; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=2/hJLDsq; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="Lv8666Vr";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="2/hJLDsq"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722848162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYRnHbF7uXJvUBwRmwiJny8X7HtTaLwwFTRZxyG9X6Y=;
	b=Lv8666Vr1mOH5nc/u/LKNi4o9/k6Y2bC6/+MdC4cNgMJjg0l5iNRJXQbpOpeKFfthhWV/I
	YdYlVRVk2m3nB2BRXeU1qhtSBL6vpgssRJ7rOm2QVCKKNQhFgQnIpzrf7yAwac0BRRSlpw
	aEwtMeuIEbPsHjKYdb92FgdaHEGzyeweDR9I9TTpSAwfA4+GmmxR9VMol/iahJ1SO/W29h
	4KDy3nrSce/RUSsUGYmlFf/1KpyoeHwUQRzbYeaTFWXDRsjk6Ozi5XoxdNZxcAhnW92EUg
	JxycSfDqoMV2Jn8v/HnFVIj4ml0FFdZryfWgY7Dp3xYOSWodLHCmKQBuHcVByA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722848162;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aYRnHbF7uXJvUBwRmwiJny8X7HtTaLwwFTRZxyG9X6Y=;
	b=2/hJLDsqaWg3/AO8GEqw9fyyCk/zVcpC2TK5cUg+kac9wg4hviG8UorLCpwyOFgjBCxXE8
	WcIpeKpGpwcgExBQ==
To: Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org,
 pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, "Rafael J.
 Wysocki" <rafael.j.wysocki@intel.com>, Helge Deller <deller@gmx.de>,
 Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
In-Reply-To: <a8a81b3d-b005-4b6f-991b-c31cdb5513e5@roeck-us.net>
References: <20240731095022.970699670@linuxfoundation.org>
 <718b8afe-222f-4b3a-96d3-93af0e4ceff1@roeck-us.net>
 <a8a81b3d-b005-4b6f-991b-c31cdb5513e5@roeck-us.net>
Date: Mon, 05 Aug 2024 10:56:01 +0200
Message-ID: <87ikwf5owu.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 04 2024 at 20:28, Guenter Roeck wrote:
> On 8/4/24 11:36, Guenter Roeck wrote:
>>> Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>>> =C2=A0=C2=A0=C2=A0=C2=A0 genirq: Set IRQF_COND_ONESHOT in request_irq()
>>>
>>=20
>> With this patch in v6.10.3, all my parisc64 qemu tests get stuck with re=
peated error messages
>>=20
>> [=C2=A0=C2=A0=C2=A0 0.000000] =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> [=C2=A0=C2=A0=C2=A0 0.000000] BUG kmem_cache_node (Not tainted): objects=
 21 > max 16
>> [=C2=A0=C2=A0=C2=A0 0.000000] ------------------------------------------=
-----------------------------------

Do you have a full boot log? It's unclear to me at which point of the boot
process this happens. Is this before or after the secondary CPUs have
been brought up?

>> This never stops until the emulation aborts.

Do you have a recipe how to reproduce?

>> Reverting this patch fixes the problem for me.
>>=20
>> I noticed a similar problem in the mainline kernel but it is either spur=
ious there
>> or the problem has been fixed.
>>=20
>
> As a follow-up, the patch below (on top of v6.10.3) "fixes" the problem f=
or me.
> I guess that suggests some kind of race condition.
>
>
> @@ -2156,6 +2157,8 @@ int request_threaded_irq(unsigned int irq, irq_hand=
ler_t handler,
>          struct irq_desc *desc;
>          int retval;
>
> +       udelay(1);
> +
>          if (irq =3D=3D IRQ_NOTCONNECTED)
>                  return -ENOTCONN;

That all makes absolutely no sense to me.

IRQF_COND_ONESHOT has only an effect on shared interrupts, when the
interrupt was already requested with IRQF_ONESHOT.

If this is really a race then the following must be true:

1) no delay

   CPU0                                 CPU1
   request_irq(IRQF_ONESHOT)
                                        request_irq(IRQF_COND_ONESHOT)

2) delay

   CPU0                                 CPU1
                                        request_irq(IRQF_COND_ONESHOT)
   request_irq(IRQF_ONESHOT)

   In this case the request on CPU 0 fails with -EBUSY ...

Confused

        tglx


