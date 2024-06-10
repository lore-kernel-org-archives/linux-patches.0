Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62F89168C7
	for <patches@lists.linux.dev>; Mon, 10 Jun 2024 06:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718000624; cv=none; b=JYQC7qiPplBgX3lasgKba77UEa7Gq3EUQQbRWl3QPTcDrbSlCX3oVedYqyutSgvplOYGTWEbVdAShrRwzk0O/4XZ8KVCKGBVoCqKxaLbtm/z4KSaQpchbAemtLCzc0Hi1NAiZ9aD/IkLYR+6YOF/ArRYamUUp63yRZDLhglyy1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718000624; c=relaxed/simple;
	bh=Sd+jpsXblCMWsEnT2TX9KHW6JYOLO3g8AfDLow37J2M=;
	h=Subject:To:Cc:References:From:In-Reply-To:Message-ID:Date:
	 MIME-Version:Content-Type; b=A/TSt1i5e7SLs4VxXQUr4dWjrE/c0F/YWzMVXFrny8lp/s6i0KylLKoVT2ZDL/w0BJWMfM9ASBVRXg23KlzgP1FEckjS39lwm2FhgkPpq21uFoyYTRAY+hbulrDnv5ovB7umOuKzXOptBS8TRxKtvczj05tfWS6FH8amNfFXKL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Wsscs9Pi; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Wsscs9Pi"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id GMzRsRXSCkQe8GYPussa0p; Mon, 10 Jun 2024 06:22:06 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id GYPtsltVLbZOgGYPusdIgF; Mon, 10 Jun 2024 06:22:06 +0000
X-Authority-Analysis: v=2.4 cv=Ffkxxo+6 c=1 sm=1 tr=0 ts=66669b8e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=N659UExz7-8A:10 a=T1WGqf2p2xoA:10 a=-Ou01B_BuAIA:10 a=p0WdMEafAAAA:8
 a=pFyQfRViAAAA:8 a=mXlUVCVxYxfRKeMwRAQA:9 a=3ZKOabzyN94A:10 a=pILNOxqGKmIA:10
 a=oJz5jJLG1JtSoe7EL652:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=iqbjLat+ztyTz4aTRhzLzYjJrZgWcXS/Xu9bkns3xKc=; b=Wsscs9PixE2NvHCYxvy/kHFtE7
	plX7nLGtE9qGDFATaUaiuTy8IednGhnNJJHaG9UKR/jLLiWReLkZX4EUyf/UwBfMw1qRZ5vG4aUks
	/sHzSW2Ji7xdhYK6W8LlS96MhO34rHXUX6hORndfKbYvm99NdJKhkHfScXwdmw1Sh9IMuD7JFHXQc
	nHffzThv+we8cpWVHGLdsYbZ8qkUgGtIimzoynIZf+zgEzMElpS1h4EI21Msfa8c37JES5enADHv4
	RF/Kv2HWk7d8PYJkG8RgKTvKPMGjzt82MnwhtZlATEjbdvaBrOVJwE2Fr21OYqvdT1PSamZqWmb9i
	FP71OsjA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:42662 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sGYPo-003BCq-2S;
	Mon, 10 Jun 2024 00:22:00 -0600
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
To: Pavel Machek <pavel@denx.de>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240609113903.732882729@linuxfoundation.org>
 <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
From: Ron Economos <re@w6rz.net>
In-Reply-To: <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
Message-ID: <ad13afda-6d20-fa88-ae7f-c1a69b1f5a40@w6rz.net>
Date: Sun, 9 Jun 2024 23:21:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1sGYPo-003BCq-2S
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:42662
X-Source-Auth: re@w6rz.net
X-Email-Count: 4
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAEhKmgDAfOctK82OveCZEEBIBxIB71hEm/oljC+8X10J9Itep7tt6N7Aa8Jm90I0AqqkgGFoiL3f6HsOirUbslPocRG/QShEfpUnXAp0K4aNb//DBy+
 aO9HBYPlAVcFprx3UoL1pf1LjIPIAt0ii5G2W+Vxnr/adTbVye4cHc+ftRoO6oFbMDg+Ziw2eb6iBQ==

On 6/9/24 12:34 PM, Pavel Machek wrote:
> Hi!
>
>> This is the start of the stable review cycle for the 6.6.33 release.
>> There are 741 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> 6.6 seems to have build problem on risc-v:
>
>    CC      kernel/locking/qrwlock.o
> 690
>    CC      lib/bug.o
> 691
>    CC      block/blk-rq-qos.o
> 692
> arch/riscv/kernel/suspend.c: In function 'suspend_save_csrs':
> 693
> arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG' undeclared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFENCEI'?
> 694
>     14 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_XLINUXENVCFG))
> 695
>        |                                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~
> 696
>        |                                                                  RISCV_ISA_EXT_ZIFENCEI
> 697
> arch/riscv/kernel/suspend.c:14:66: note: each undeclared identifier is reported only once for each function it appears in
> 698
>    CC      io_uring/io-wq.o
> 699
> arch/riscv/kernel/suspend.c: In function 'suspend_restore_csrs':
> 700
> arch/riscv/kernel/suspend.c:37:66: error: 'RISCV_ISA_EXT_XLINUXENVCFG' undeclared (first use in this function); did you mean 'RISCV_ISA_EXT_ZIFENCEI'?
> 701
>     37 |         if (riscv_cpu_has_extension_unlikely(smp_processor_id(), RISCV_ISA_EXT_XLINUXENVCFG))
> 702
>        |                                                                  ^~~~~~~~~~~~~~~~~~~~~~~~~~
> 703
>        |                                                                  RISCV_ISA_EXT_ZIFENCEI
> 704
> make[4]: *** [scripts/Makefile.build:243: arch/riscv/kernel/suspend.o] Error 1
> 705
> make[3]: *** [scripts/Makefile.build:480: arch/riscv/kernel] Error 2
> 706
> make[2]: *** [scripts/Makefile.build:480: arch/riscv] Error 2
> 707
> make[2]: *** Waiting for unfinished jobs....
> 708
>    CC      lib/buildid.o
> 709
>
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/jobs/7053222239
> https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/pipelines/1324369118
>
> No problems detected on 6.8-stable and 6.1-stable.
>
> Best regards,
> 								Pavel

I'm seeing the same thing here. Somehow some extra patches got slipped 
in between rc1 and rc2. The new patches for RISC-V are:

Samuel Holland <samuel.holland@sifive.com>
     riscv: Save/restore envcfg CSR during CPU suspend

commit 88b55a586b87994a33e0285c9e8881485e9b77ea

Samuel Holland <samuel.holland@sifive.com>
     riscv: Fix enabling cbo.zero when running in M-mode

commit 8c6e096cf527d65e693bfbf00aa6791149c58552

The first patch "riscv: Save/restore envcfg CSR during CPU suspend" 
causes the build failure.

