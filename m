Received: from mail.ozlabs.org (gandalf.ozlabs.org [150.107.74.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E83AC194A49
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 06:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=150.107.74.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729492545; cv=none; b=scyvNupek7xGgUQghUEjlp9BAPjd+164Q2pVfPIG43H/Q/6YFjKw8HB1xwmBG71ehBJ60kTmtTt9Mo8X64wXuSpP1PHlMHsK3jLwjZ/w2+aj70ZEzmoJ6z24dbKrvL7HzIJ719cqWN70xTMQmKQshJRpcdz45I+n/y/e51BIqnc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729492545; c=relaxed/simple;
	bh=HkPP90BDj7ShExGhPzqpARw7tFTrBfKn41sehDhvjvc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=RvrGX9T4mh5sE3DoG+lRahC352eRy75Q1bALyr1yV0MJmp8VbfQ9GTRCcJoPAXNfk95/IC6ZDodWYWgfDcSab3iYO1VB8ikAiHh1sRalIqSc4NDYSGRbq+NaNJ6OAUVXtfCjnLPbIRq2KPiX8SSY/6wWtqykAm1G5gOJHsLNl5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au; spf=pass smtp.mailfrom=ellerman.id.au; dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b=g4FnnzmQ; arc=none smtp.client-ip=150.107.74.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ellerman.id.au
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ellerman.id.au header.i=@ellerman.id.au header.b="g4FnnzmQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ellerman.id.au;
	s=201909; t=1729492539;
	bh=oPJqw9jTjI4cbhYyi3s6loOXtJo7OvCmEdYx8OT7dBw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=g4FnnzmQUrwJaqKpLg3QjvRCiJVBUruDTmf2mcpEV4pyPnzRi109DSd3iJAZ3L0WE
	 K65hxX+NEPSLnZ9mi8cUVMgl9+a2J0gaO2kwG0UoSe8r+vFtdncaEbEgnCJAJ5CLq8
	 QsAjU1asRFnSRv87vNoTZthnFKzsmWT2402VkKo+RuRVNrn1lDnqodvMhww9Ct1ULm
	 PBWqLr9dhhrVn7mnG2TLkZhJDQzOgaXLwSh0NfeTvgCNL0Vd1dNba4Hh6qH87QAgqr
	 dR4c5ctck9u9nZnYVfVq8Xc6BQtBPrY138WMncKSs75BqrkbVm31kh0JneqXEmM+DV
	 u/DcX/SUq4kmg==
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(Client did not present a certificate)
	by mail.ozlabs.org (Postfix) with ESMTPSA id 4XX5Ct4dLgz4w2R;
	Mon, 21 Oct 2024 17:35:38 +1100 (AEDT)
From: Michael Ellerman <mpe@ellerman.id.au>
To: Guenter Roeck <linux@roeck-us.net>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org,
 pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org, Christophe
 Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
In-Reply-To: <f46542ec-bb43-4a30-900b-d3c9d1763753@roeck-us.net>
References: <20241015112440.309539031@linuxfoundation.org>
 <f46542ec-bb43-4a30-900b-d3c9d1763753@roeck-us.net>
Date: Mon, 21 Oct 2024 17:35:35 +1100
Message-ID: <87v7xmnetk.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Guenter Roeck <linux@roeck-us.net> writes:
> Hi,

Hi Guenter,

Thanks for the report.

> On 10/15/24 04:19, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.15.168 release.
>> There are 691 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>> 
>> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
>> Anything received after that time might be too late.
>> 
> ...
>> Christophe Leroy <christophe.leroy@csgroup.eu>
>>      powerpc/mm: Fix boot warning with hugepages and CONFIG_DEBUG_VIRTUAL
>> 
>
> This patch triggers a crash when trying to boot various powerpc images.
>
> ------------[ cut here ]------------
> kernel BUG at include/linux/scatterlist.h:143!
> Oops: Exception in kernel mode, sig: 5 [#1]
> BE PAGE_SIZE=4K MMU=Hash PREEMPT SMP NR_CPUS=32 NUMA PowerMac
> Modules linked in:
> CPU: 0 PID: 25 Comm: cryptomgr_test Not tainted 5.15.167-00018-g00ef1de6d646 #1
> NIP:  c00000000082c6c0 LR: c00000000082f460 CTR: 0000000000000000
> REGS: c00000000962b540 TRAP: 0700   Not tainted  (5.15.167-00018-g00ef1de6d646)
> MSR:  8000000000028032 <SF,EE,IR,DR,RI>  CR: 84000440  XER: 20000000
> IRQMASK: 0
> GPR00: c00000000082f44c c00000000962b7e0 c000000001ef6c00 c00000000962b9e8
> GPR04: c0000000096e2000 0000000000000008 c00000000962ba48 0000000000000200
> GPR08: 000000003e2a5000 c000000000000000 0000000000000000 0000000000000001
> GPR12: 0000000024000440 c000000002b62000 c00000000011e6b0 c0000000096c8e40
> GPR16: 0000000000000000 c00000000148c300 c00000000148c2f0 0000000000000008
> GPR20: 0000000000000040 c00000000147ddf8 0000000000000040 c00000000956f4a8
> GPR24: c000000002a23c98 c000000001417d18 c0000000096e2000 0000000000000001
> GPR28: 0000000000000008 c00000000962b9e8 00000000000096e2 c0000000096e2000
> NIP [c00000000082c6c0] .sg_set_buf+0x50/0x350
> LR [c00000000082f460] .test_akcipher_one+0x280/0x860
> Call Trace:
> [c00000000962b7e0] [c00000000956f4f3] 0xc00000000956f4f3 (unreliable)
> [c00000000962b890] [c00000000082f44c] .test_akcipher_one+0x26c/0x860
> [c00000000962bad0] [c00000000082fb14] .alg_test_akcipher+0xd4/0x150
> [c00000000962bb70] [c00000000082bcac] .alg_test+0x15c/0x640
> [c00000000962bcd0] [c000000000829850] .cryptomgr_test+0x40/0x70
> [c00000000962bd50] [c00000000011e880] .kthread+0x1d0/0x1e0
> [c00000000962be10] [c00000000000cc60] .ret_from_kernel_thread+0x58/0x60
> Instruction dump:
> fbe1fff8 6129ffff fb61ffd8 7c244840 7c9f2378 91810008 7c7d1b78 f821ff51
> 7cbc2b78 789ea402 41810078 3b600001 <0b1b0000> 3d220007 7bde3664 39492f20
> ---[ end trace fdddc57d958f029f ]---
>
> The problem affects v5.15.168 and v5.10.227. Reverting the offending patch
> fixes the problem in both branches.
>
> My test images do not have hugepages or CONFIG_DEBUG_VIRTUAL enabled.
>
> Bisect log is attached. I copied the author and Michael for comments.

I don't see that exact oops, but some others, which all track back to
the same source.

The offending commit includes:

    high_memory is set in mem_init() using max_low_pfn, but max_low_pfn
    is available long before, it is set in mem_topology_setup(). 

But that's only been true since commit:

  7b31f7dadd70 ("powerpc/mm: Always update max/min_low_pfn in mem_topology_setup()")

which went into v6.1.

Backporting that commit to v5.15 (and v5.10) fixes the oops for me, and
otherwise looks safe to backport.

Greg can you pick that commit (7b31f7dadd70) up for v5.15 and v5.10 please?

cheers
