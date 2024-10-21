Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2601B1E3797;
	Mon, 21 Oct 2024 09:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729503946; cv=none; b=RDG29/eQz3TzRiOgyguS5n0sWKCDCZTpxooNqTVN6/+i18m8AHutElDYDfDzizjuZuCI4IOQldbKuQ4X6/1LOLoXtid0KUIyaNAvDc0cDo4zJWlbifHqQvmztdly/rJIjnUAxybKmE4xQ5VWG4XEpoC8n0U4B1FHTxDYnlAU0F4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729503946; c=relaxed/simple;
	bh=Wq1GtCpKHY24n6PQrD1goQDyBau/rUUfQGqUAsF0MSM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BVmzk24XkZcHcABJezIVHtnS3VsBPcKSyFQrObfuIZDhJzRf23eiBJ0wU9xc4GkODjxT0q58RDf4vVUFGLs5zichALfLEWQa3fZgLVGV+l8Zl681TnXiCzWWL/m69z5lnpv8yB1Amo8MITIG/xjEx0H8xjqJ0rEjYfMSVvOTcOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y8aAYzei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y8aAYzei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25119C4CEC3;
	Mon, 21 Oct 2024 09:45:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1729503945;
	bh=Wq1GtCpKHY24n6PQrD1goQDyBau/rUUfQGqUAsF0MSM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Y8aAYzeidxehCDxE2WeescsT2OP4QorWEhj93TKulbsKFwD3NoG9xOL73KwPdQizP
	 4XHwkoD8F9TZjbeip5dQZlAe2hLNTkMxDxrJOSgArM95CHYjF0FJL1sR1dZZTW8saI
	 ljOciMjPZ0f5SrMhZv15AfDltHYNhkZHf2hH5ODc=
Date: Mon, 21 Oct 2024 11:45:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	Christophe Leroy <christophe.leroy@csgroup.eu>
Subject: Re: [PATCH 5.15 000/691] 5.15.168-rc1 review
Message-ID: <2024102136-excretion-pantyhose-f8b6@gregkh>
References: <20241015112440.309539031@linuxfoundation.org>
 <f46542ec-bb43-4a30-900b-d3c9d1763753@roeck-us.net>
 <87v7xmnetk.fsf@mail.lhotse>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87v7xmnetk.fsf@mail.lhotse>

On Mon, Oct 21, 2024 at 05:35:35PM +1100, Michael Ellerman wrote:
> Guenter Roeck <linux@roeck-us.net> writes:
> > Hi,
> 
> Hi Guenter,
> 
> Thanks for the report.
> 
> > On 10/15/24 04:19, Greg Kroah-Hartman wrote:
> >> This is the start of the stable review cycle for the 5.15.168 release.
> >> There are 691 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >> 
> >> Responses should be made by Thu, 17 Oct 2024 11:22:41 +0000.
> >> Anything received after that time might be too late.
> >> 
> > ...
> >> Christophe Leroy <christophe.leroy@csgroup.eu>
> >>      powerpc/mm: Fix boot warning with hugepages and CONFIG_DEBUG_VIRTUAL
> >> 
> >
> > This patch triggers a crash when trying to boot various powerpc images.
> >
> > ------------[ cut here ]------------
> > kernel BUG at include/linux/scatterlist.h:143!
> > Oops: Exception in kernel mode, sig: 5 [#1]
> > BE PAGE_SIZE=4K MMU=Hash PREEMPT SMP NR_CPUS=32 NUMA PowerMac
> > Modules linked in:
> > CPU: 0 PID: 25 Comm: cryptomgr_test Not tainted 5.15.167-00018-g00ef1de6d646 #1
> > NIP:  c00000000082c6c0 LR: c00000000082f460 CTR: 0000000000000000
> > REGS: c00000000962b540 TRAP: 0700   Not tainted  (5.15.167-00018-g00ef1de6d646)
> > MSR:  8000000000028032 <SF,EE,IR,DR,RI>  CR: 84000440  XER: 20000000
> > IRQMASK: 0
> > GPR00: c00000000082f44c c00000000962b7e0 c000000001ef6c00 c00000000962b9e8
> > GPR04: c0000000096e2000 0000000000000008 c00000000962ba48 0000000000000200
> > GPR08: 000000003e2a5000 c000000000000000 0000000000000000 0000000000000001
> > GPR12: 0000000024000440 c000000002b62000 c00000000011e6b0 c0000000096c8e40
> > GPR16: 0000000000000000 c00000000148c300 c00000000148c2f0 0000000000000008
> > GPR20: 0000000000000040 c00000000147ddf8 0000000000000040 c00000000956f4a8
> > GPR24: c000000002a23c98 c000000001417d18 c0000000096e2000 0000000000000001
> > GPR28: 0000000000000008 c00000000962b9e8 00000000000096e2 c0000000096e2000
> > NIP [c00000000082c6c0] .sg_set_buf+0x50/0x350
> > LR [c00000000082f460] .test_akcipher_one+0x280/0x860
> > Call Trace:
> > [c00000000962b7e0] [c00000000956f4f3] 0xc00000000956f4f3 (unreliable)
> > [c00000000962b890] [c00000000082f44c] .test_akcipher_one+0x26c/0x860
> > [c00000000962bad0] [c00000000082fb14] .alg_test_akcipher+0xd4/0x150
> > [c00000000962bb70] [c00000000082bcac] .alg_test+0x15c/0x640
> > [c00000000962bcd0] [c000000000829850] .cryptomgr_test+0x40/0x70
> > [c00000000962bd50] [c00000000011e880] .kthread+0x1d0/0x1e0
> > [c00000000962be10] [c00000000000cc60] .ret_from_kernel_thread+0x58/0x60
> > Instruction dump:
> > fbe1fff8 6129ffff fb61ffd8 7c244840 7c9f2378 91810008 7c7d1b78 f821ff51
> > 7cbc2b78 789ea402 41810078 3b600001 <0b1b0000> 3d220007 7bde3664 39492f20
> > ---[ end trace fdddc57d958f029f ]---
> >
> > The problem affects v5.15.168 and v5.10.227. Reverting the offending patch
> > fixes the problem in both branches.
> >
> > My test images do not have hugepages or CONFIG_DEBUG_VIRTUAL enabled.
> >
> > Bisect log is attached. I copied the author and Michael for comments.
> 
> I don't see that exact oops, but some others, which all track back to
> the same source.
> 
> The offending commit includes:
> 
>     high_memory is set in mem_init() using max_low_pfn, but max_low_pfn
>     is available long before, it is set in mem_topology_setup(). 
> 
> But that's only been true since commit:
> 
>   7b31f7dadd70 ("powerpc/mm: Always update max/min_low_pfn in mem_topology_setup()")
> 
> which went into v6.1.
> 
> Backporting that commit to v5.15 (and v5.10) fixes the oops for me, and
> otherwise looks safe to backport.
> 
> Greg can you pick that commit (7b31f7dadd70) up for v5.15 and v5.10 please?

Now picked up, thanks!

greg k-h
