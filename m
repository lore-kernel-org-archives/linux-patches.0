Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25042192FA
	for <patches@lists.linux.dev>; Sat, 16 May 2026 00:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778892485; cv=none; b=njI86CVQTuby3/5kgkanP+Xhbj17H4RQ07dj0FnT4FPg+wMdOyfOidDi4GYZkZ+DNd5mvjQzeHexvGkq06dxconHUUKwNXJWeXl27OJMrqirRX8Xo0rQxBxpPegjks3101DTcLOZD2IsIpR/gg3I4XEhWnzEKg8CrhJ3DlaHDxc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778892485; c=relaxed/simple;
	bh=drDHN4Zg9cOOxdmNA9Mtsco7sGaHjsurCt5kmpxDGDI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LBvuKnv8da1AmUFsN09J5lLXCimzPd3JNfWpN0MF5Jd9r13D2wfxLjFj6vGwGlw1CJajbEhRFvfSHd144aiPonZaL+fmFOSxTygTNJghO49LyhpeabTY5O/5j03FZQTeElLhDHvn+80gaRO/vc00r5ev8MLWQIT9+d9Yub22ISo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=k8Kvdv1N; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="k8Kvdv1N"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-488a8ca4aadso3133145e9.3
        for <patches@lists.linux.dev>; Fri, 15 May 2026 17:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1778892481; x=1779497281; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ktNPJUhtUmCwD/xKtU4wmNTOqF7Ec1I7RC8ZgMrOzLU=;
        b=k8Kvdv1NFKH+IVrH5xcgm2engdzlVnFqJlwXXzeY81GlSnuEbnPjwMD3Z7TB9XGlb8
         bzOgVhWss2xl81RneebJ9j6109933F0DoGqli47Jg7KZOm9vzDg+lc9x48cO2yJjJsOD
         dw5W8FMk8byT7G5WSlIrEWgUnRZ3602J4Jl1ht5UL2JQ8XwlYRh96Jg6waeKLUnY8tGr
         85dWNBf/Vrq8U+yg/+YK9FbCZgJdBddR5aYkg+e+M+bWQgX3WWh+XoppGSJLGdtFtv8F
         e+HrxZcLg5rZwwPs0ICO/4wwtp1aJiRHyP8S1OQT6lmM5VfMiJ6jKDzIVKWNjx63abjd
         tylw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778892481; x=1779497281;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ktNPJUhtUmCwD/xKtU4wmNTOqF7Ec1I7RC8ZgMrOzLU=;
        b=Ec4giFAz80MlcQh3EWxqSVeVTrd8wiT2XB1Zci/gnLMgPQzGClMj7VdgzaUDKQfoZ5
         gusWOszEuUZnnyOrl/jxwlCiJU/SlI9ehOCLSKdRe0z2WeskcVS0nfAGxK4lO2+gqAqG
         wS1JgKlazeIjZI8iul7pw1+tKRswZVc9pBcjPpYIFOisrxjdO086REkd7pCydYr0H7in
         LlrdlldnT/2FyVCtX9hUYoEnsP9BKbjg0g/C0zOVgJ1nYMNweh9hvdUBEl27/fyHyzLv
         gkzs9ST+dkgLYkmYEQ6o3vABJAlvdH8gWDRt1OSvhInjLpWd82AJiE73456xRWOxm6Hd
         XRdA==
X-Gm-Message-State: AOJu0YyrTxQ4kkjhmvic2iXgUhMn6RUNYRDVoZM6naixpevG8d2uf3GY
	JfeYWt124jMNmk3zWHfZcuE0Pk5IAcaOUzkKVwyhlF2db0cWvlICKY4=
X-Gm-Gg: Acq92OFj2RBrumx/5Hm1xInCwX3W3hpJbN/9P0qP8xxKuygbKWiOUCgLTv4qRbIty6B
	xdShV65lDV7EZN4cjHUWj2RevSapeaQyHC1o8bof8P7m+neNrrx1ManmjVftBPu7Ko6KrGEIDGW
	cXuGs4LS0Ska1claSeHTC7pTOf3ZvhLJl5uBoFOo1qtczoICFHHEmUEHi+8WScqb42WQSio6PS1
	ZQYKs+gIxNH67qqxq7dvwqB6tunFF4JGh3D9CPmT0v/+uGUaXJHUsNpZkESPA5LEC3IjxoQiOHK
	55elkk4fySUQsUnweYoBtCwBfG/ZgB5XT0gYc2Z8u+myaj6ZX86Kr1bog+xxv2j7OvfGxT61lEq
	C1Ls0Kr+YQIN7qGmUAENhJluDBttSiS9THc6qQOosQ/CbIXkr3IQehj0WmnWYxb+Axpp+n6fVn+
	xdbq9b7yONzYU2uCLUS29MG48DOdlxiJdx3KYd+Hp3TmhJxFdfbhc3fFep7l4XWLlREr+r/5YX3
	s0=
X-Received: by 2002:a05:6000:2288:b0:45d:4532:5d98 with SMTP id ffacd0b85a97d-45e5c57d2f2mr8066451f8f.8.1778892481036;
        Fri, 15 May 2026 17:48:01 -0700 (PDT)
Received: from [192.168.1.3] (p5b057eb2.dip0.t-ipconnect.de. [91.5.126.178])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45d9ec39ff1sm19280360f8f.10.2026.05.15.17.48.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 17:48:00 -0700 (PDT)
Message-ID: <508bf3b7-56c7-4290-b663-7daf8ed4e80d@googlemail.com>
Date: Sat, 16 May 2026 02:48:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 143/188] sched_ext: Use HK_TYPE_DOMAIN_BOOT to detect
 isolcpus= domain isolation
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Andrea Righi <arighi@nvidia.com>,
 Tejun Heo <tj@kernel.org>, Frederic Weisbecker <frederic@kernel.org>
References: <20260515154657.309489048@linuxfoundation.org>
 <20260515154700.426346174@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260515154700.426346174@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 15.05.2026 um 17:49 schrieb Greg Kroah-Hartman:
> 6.18-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Andrea Righi <arighi@nvidia.com>
> 
> commit 6ae315d37924435516d697ea7dde0b799a5928e0 upstream.
> 
> scx_enable() refuses to attach a BPF scheduler when isolcpus=domain is
> in effect by comparing housekeeping_cpumask(HK_TYPE_DOMAIN) against
> cpu_possible_mask.
> 
> Since commit 27c3a5967f05 ("sched/isolation: Convert housekeeping
> cpumasks to rcu pointers"), HK_TYPE_DOMAIN's cpumask is RCU protected
> and dereferencing it requires either RCU read lock, the cpu_hotplug
> write lock, or the cpuset lock; scx_enable() holds none of these, so
> booting with isolcpus=domain and attaching any BPF scheduler triggers
> the following lockdep splat:
> 
>    =============================
>    WARNING: suspicious RCU usage
>    -----------------------------
>    kernel/sched/isolation.c:60 suspicious rcu_dereference_check() usage!
> 
>    1 lock held by scx_flash/281:
>     #0: ffffffff8379fce0 (update_mutex){+.+.}-{4:4}, at:
>         bpf_struct_ops_link_create+0x134/0x1c0
> 
>    Call Trace:
>     dump_stack_lvl+0x6f/0xb0
>     lockdep_rcu_suspicious.cold+0x37/0x70
>     housekeeping_cpumask+0xcd/0xe0
>     scx_enable.isra.0+0x17/0x120
>     bpf_scx_reg+0x5e/0x80
>     bpf_struct_ops_link_create+0x151/0x1c0
>     __sys_bpf+0x1e4b/0x33c0
>     __x64_sys_bpf+0x21/0x30
>     do_syscall_64+0x117/0xf80
>     entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> In addition, commit 03ff73510169 ("cpuset: Update HK_TYPE_DOMAIN cpumask
> from cpuset") made HK_TYPE_DOMAIN include cpuset isolated partitions as
> well, which means the current check also rejects BPF schedulers when a
> cpuset partition is active. That contradicts the original intent of
> commit 9f391f94a173 ("sched_ext: Disallow loading BPF scheduler if
> isolcpus= domain isolation is in effect"), which explicitly noted that
> cpuset partitions are honored through per-task cpumasks and should not
> be rejected.
> 
> Switch to housekeeping_enabled(HK_TYPE_DOMAIN_BOOT), which reads only
> the housekeeping flag bit (no RCU dereference) and reflects exactly the
> boot-time isolcpus= configuration that the error message refers to.
> 
> Fixes: 27c3a5967f05 ("sched/isolation: Convert housekeeping cpumasks to rcu pointers")
> Cc: stable@vger.kernel.org # v7.0+
> Signed-off-by: Andrea Righi <arighi@nvidia.com>
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Acked-by: Frederic Weisbecker <frederic@kernel.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   kernel/sched/ext.c |    3 +--
>   1 file changed, 1 insertion(+), 2 deletions(-)
> 
> --- a/kernel/sched/ext.c
> +++ b/kernel/sched/ext.c
> @@ -4906,8 +4906,7 @@ static int scx_enable(struct sched_ext_o
>   	static DEFINE_MUTEX(helper_mutex);
>   	struct scx_enable_cmd cmd;
>   
> -	if (!cpumask_equal(housekeeping_cpumask(HK_TYPE_DOMAIN),
> -			   cpu_possible_mask)) {
> +	if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
>   		pr_err("sched_ext: Not compatible with \"isolcpus=\" domain isolation\n");
>   		return -EINVAL;
>   	}
> 
> 


This patch causes a build failure for me:

   CC      kernel/sched/build_policy.o
In file included from kernel/sched/build_policy.c:62:
kernel/sched/ext.c: In function ‘scx_enable’:
kernel/sched/ext.c:4924:34: error: ‘HK_TYPE_DOMAIN_BOOT’ undeclared (first use in this function); did you mean 
‘HK_TYPE_DOMAIN’?
  4924 |         if (housekeeping_enabled(HK_TYPE_DOMAIN_BOOT)) {
       |                                  ^~~~~~~~~~~~~~~~~~~
       |                                  HK_TYPE_DOMAIN
kernel/sched/ext.c:4924:34: note: each undeclared identifier is reported only once for each function it appears in
make[4]: *** [scripts/Makefile.build:287: kernel/sched/build_policy.o] Fehler 1
make[3]: *** [scripts/Makefile.build:544: kernel/sched] Fehler 2
make[2]: *** [scripts/Makefile.build:544: kernel] Fehler 2
make[1]: *** [/usr/src/linux-stable-rc/Makefile:2024: .] Fehler 2
make: *** [Makefile:248: __sub-make] Fehler 2
root@linus:/usr/src/linux-stable-rc#

If I revert this patch, the build succeeds, and the kernel boots and seems to work fine without any observable regressions.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
