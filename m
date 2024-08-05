Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88A3149001
	for <patches@lists.linux.dev>; Mon,  5 Aug 2024 21:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722894546; cv=none; b=NJFot+e2gJMGlqmzb6okAuk3pA48oTB9ZAJid0iCvKaQlKTAphhT8X1kTtxY6kYOZ+EtGPNvJpcU3JIAxvKskrq5z8CtO2cckpHyw0kjXYrvaY4cVH3MujqhAhmfP7A8I/dtZEhx+AnTj+fCfRDJOun8g7Lo5vVyHh+nrcJRs6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722894546; c=relaxed/simple;
	bh=xcxzwdGW5hWsS/t+y+73kl2SCdcllt90pNWtXcSNnws=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=BRMNiQnbe4Pi8GbTyj57t8TW98NlHsZiP/LVmuMO+9W+L18zlsVwjEppN/ho2r4VoQ/bQV4PpYz3zD/GsSuykbDjPo7ejKKnIu5gkMj/J3PqfLheyz2W7hICpiGl7Ks0SjtDueT3XA8LkGP4ZSrRhQFDT3wobFjQhjHOjPk7E7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=nFyuptt4; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=8y7PwI4i; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="nFyuptt4";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="8y7PwI4i"
From: Thomas Gleixner <tglx@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1722894542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4nUCiNvZjsfrPJmP/M2fcdGMiwDctJMbZkujjzDAnT8=;
	b=nFyuptt44fmvmIprTFimEB1edQCV0ozC4gp9n6q/NtcFw5SbjHB8JGGF0GQlwMseMAX1gQ
	8bhkXGeqRSuUCHIQP8XJEdd2UW5MwA7LS/tukt+1dv+UM3QtRGAQDX/l0q/XIoWKqgPAui
	oazH1nSPLIOarxTAuNx4I0eOeCpj4axXlYVDEhdvjW2QSZHRr9K82MtTn8VQAOZKP/3f3q
	exqY30MRNJKiHHikr8qvvuKXrPQNvVZ4Sqf1wORLcMsZSDWNs6VNQov6GUdgCECefMOAnb
	L/QhuXAnuS6Ll0ksKTwddoSnG2He/SIQissibdnsE2aX486tQsWP+Bp1MphxXw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1722894542;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4nUCiNvZjsfrPJmP/M2fcdGMiwDctJMbZkujjzDAnT8=;
	b=8y7PwI4iiZJM4fshA/HMLPzK+dlDs1poQ6jHY64n3TWBdsMX8ouSyZ0fmzNCjhZZzZU4oC
	rO8C5sonUchWZsAQ==
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
In-Reply-To: <8326f852-87fa-435a-9ca7-712bce534472@roeck-us.net>
References: <20240731095022.970699670@linuxfoundation.org>
 <718b8afe-222f-4b3a-96d3-93af0e4ceff1@roeck-us.net>
 <a8a81b3d-b005-4b6f-991b-c31cdb5513e5@roeck-us.net> <87ikwf5owu.ffs@tglx>
 <87frrj5e0o.ffs@tglx> <8326f852-87fa-435a-9ca7-712bce534472@roeck-us.net>
Date: Mon, 05 Aug 2024 23:49:02 +0200
Message-ID: <87y15a4p4h.ffs@tglx>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Mon, Aug 05 2024 at 08:02, Guenter Roeck wrote:
> On 8/5/24 05:51, Thomas Gleixner wrote:
>> IRQF_COND_ONESHOT has only an effect when
>> 
>>      1) Interrupt is shared
>>      2) First interrupt request has IRQF_ONESHOT set
>> 
>> Neither #1 nor #2 are true, but maybe your current config enables some moar
>> devices than the one on your website.
>> 
>
> No, it is pretty much the same, except for a more recent C compiler, and it
> requires qemu v9.0. See http://server.roeck-us.net/qemu/parisc64-6.10.3/.
>
> Debugging shows pretty much the same for me, and any log message added
> to request_irq() makes the problem go away (or be different), and if the problem
> is seen it doesn't even get to the third interrupt request. I copied a more complete
> log to bad.log.gz in above page.

At the point where the problem happens is way before the first interrupt
is requested, so that definitely excludes any side effect of
COND_ONESHOT.

It happens right after

[    0.000000] Memory: 991812K/1048576K available (16752K kernel code, 5220K rwdata, 3044K rodata, 760K init, 1424K bss, 56764K reserved, 0K cma-reserved)
               SNIP
[    0.000000] ** This system shows unhashed kernel memory addresses   **
               SNIP

I.e. the big fat warning about unhashed kernel addresses)

In the good case the first interrupt is requested here:

[    0.000000] Memory: 992804K/1048576K available (16532K kernel code, 5096K rwdata, 2984K rodata, 744K init, 1412K bss, 55772K reserved, 0K cma-reserved)
               SNIP
[    0.000000] ** This system shows unhashed kernel memory addresses   **
               SNIP
[    0.000000] SLUB: HWalign=16, Order=0-3, MinObjects=0, CPUs=4, Nodes=1
[    0.000000] ODEBUG: selftest passed
[    0.000000] rcu: Hierarchical RCU implementation.
[    0.000000] rcu:     RCU event tracing is enabled.
[    0.000000] rcu:     RCU callback double-/use-after-free debug is enabled.
[    0.000000] rcu:     RCU debug extended QS entry/exit.
[    0.000000] rcu: RCU calculated value of scheduler-enlistment delay is 25 jiffies.

[    0.000000] NR_IRQS: 128              <- This is where the interrupt
                                            subsystem is initialized
[    0.000000] genirq: 64: 00215600      <- This is probably the timer interrupt

Looking at the backtrace the fail happens from within start_kernel(),
i.e. mm_core_init():

       slab_err+0x13c/0x190
       check_slab+0xf4/0x140
       alloc_debug_processing+0x58/0x248
       ___slab_alloc+0x22c/0xa38
       __slab_alloc.isra.0+0x60/0x88
       kmem_cache_alloc_node_noprof+0x148/0x3c0
       __kmem_cache_create+0x5d4/0x680
       create_boot_cache+0xc4/0x128
       new_kmalloc_cache+0x1ac/0x1d8
       create_kmalloc_caches+0xac/0x108
       kmem_cache_init+0x1cc/0x340
       mm_core_init+0x458/0x560
       start_kernel+0x9ac/0x11e0
       start_parisc+0x188/0x1b0

The interrupt subsystem is initialized way later and request_irq() only
works after that point.

I'm 100% sure by now that this commit has absolutely nothing to do with
the underlying problem. All it does is changing the code size and
placement of text, data and ....

So I finally managed to reproduce with gcc-13.3.0 from the k.org cross
tools (the debian 12.2.2 does not).

If I add:

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1513,6 +1513,8 @@ static int
 	unsigned long flags, thread_mask = 0;
 	int ret, nested, shared = 0;
 
+	pr_info("%u: %08x\n", irq, new->flags);
+
 	if (!desc)
 		return -EINVAL;
 
it still reproduces. If I change that to:

--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -1513,6 +1513,8 @@ static int
 	unsigned long flags, thread_mask = 0;
 	int ret, nested, shared = 0;
 
+	new->flags &= ~IRQF_COND_ONESHOT;
+
 	if (!desc)
 		return -EINVAL;
 
that does neither cure it (unsurprisingly).

Reverting the "offending" commit cures it. 

So I tried your

     +       pr_info_once("####### First timer interrupt\n");

which cures it too.

So now where is the difference between the printk() in __setup_irq(),
the new->flag mangling, the revert and the printk() in timer interrupt?

There is ZERO functional change. There is no race either because at that
point everything is single threaded and interrupts are disabled.

The only thing which changes is the code and data layout as I can
observe when looking at System.map of the builds. I stared at the diffs
for a bit, but nothing stood out.

Maybe the PARISC people can shed some light on it.

This reminds me of the x86 32-bit disaster we debugged a few days ago...

Thanks,

        tglx
