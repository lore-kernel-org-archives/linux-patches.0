Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A057C6DB
	for <patches@lists.linux.dev>; Mon,  4 Mar 2024 23:31:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595069; cv=none; b=P+joYsXSL13KKfMf7KBpAJ150Oybim4FVUmS2uoWNrv8qZkkg54SlJJPY40PT0LOwpT2ZeNZweapk1Rxc85eygx+QIPKWnE8yp7lZWzxM5H1zu9KcbIcep2MFyzLJUicdr1r+dUhwaVsORTvGduqN0wFgOe7OOdjSC7lTP521PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595069; c=relaxed/simple;
	bh=nHa8DwC8bpEcB5DaG4EAgwujyIfuWHXzqJpn/5Qkqrg=;
	h=Subject:To:Cc:References:From:In-Reply-To:Message-ID:Date:
	 MIME-Version:Content-Type; b=h9WWG9zfyJTkeUYYIaaGVeAg6xahx4ZAYwra6Kw/hdf/QE5l8pJ8vAGNbsihMzdEXpIgNT2ggixvD4AEWRDO9qZU1rnyUGHNOobK8HntSJ3e7zkYuXjr5R7SzhuzEl96PoU1OqdY1lr5XnNldElTeWEyv/s54X3uHdLwfnVPmGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=1C1h287R; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="1C1h287R"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id h5fErZ2ynHXmAhHlyr9fF6; Mon, 04 Mar 2024 23:31:06 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id hHlxrmr6sdRd1hHlxrwMh4; Mon, 04 Mar 2024 23:31:05 +0000
X-Authority-Analysis: v=2.4 cv=KuxL23WN c=1 sm=1 tr=0 ts=65e659b9
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=K6JAEmCyrfEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=1GQxe75yrw9fIeUcjpcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=kkKXkaHiVwHFeTtq12t1/Zf9Z0FrNBJx40HZVh0CcXg=; b=1C1h287RIj9G1MTNAvlWvHaDG2
	LTLJJGchb1J6Nln1UdFrU9WEr06HiZsdZaigQ6RZeSYSGu1EDxG6P/yAYb58sNvpmNrYRNwV1N5C0
	l+wXpHwEM6gnXsxYOlKz+8pHMl/gpj9GYMgUx8PGF+eBNEV14QGTj0mvkoBmPk/m392JVX50U77x8
	OkNbE2v27wNZ44R98sa02hcCvH+NJyJJPjSKt2hNMxKH0P5ezPce5X190hJxHOMxtVRKoOPVajxHr
	837E2jHsh20RyvKOQxrRTlcc9stT5wdKgD4kQNokyX/RJd1I2iTSY8DQqeS5pyAvoblvyyN2goOgq
	Dcb280Pw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:49056 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rhHlu-000CFb-2Z;
	Mon, 04 Mar 2024 16:31:02 -0700
Subject: Re: [PATCH 6.7 000/162] 6.7.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240304211551.833500257@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
Message-ID: <dcc13107-8e7e-12c9-e9f0-d0fa96ea9c39@w6rz.net>
Date: Mon, 4 Mar 2024 15:31:00 -0800
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
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
X-Exim-ID: 1rhHlu-000CFb-2Z
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:49056
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKxZx4T6fel/ONBJ3R/ugmJhujAJZXe/n92oY/80+VmC3zpqItJQVRYxNN0zu7yw4h+M7G454M8bGcBED0G9FMBaAy2wMcYyGvZPzvpZbITFK4PP2z9Q
 bLwc6kbr0pjs2sDABaJV5t/+hi5tZub+B8FSFOf2ECf4GD447o743jSPiVEJIyH+4BLBYERCASRrKg==

On 3/4/24 1:21 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.9 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.7.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The build fails on RISC-V RV64 with:

arch/riscv/kernel/suspend.c: In function ‘suspend_save_csrs’:
arch/riscv/kernel/suspend.c:14:66: error: ‘RISCV_ISA_EXT_XLINUXENVCFG’ 
undeclared (first use in this function); did you mean 
‘RISCV_ISA_EXT_ZIFENCEI’?
    14 |         if 
(riscv_cpu_has_extension_unlikely(smp_processor_id(), 
RISCV_ISA_EXT_XLINUXENVCFG))
| ^~~~~~~~~~~~~~~~~~~~~~~~~~
| RISCV_ISA_EXT_ZIFENCEI
arch/riscv/kernel/suspend.c:14:66: note: each undeclared identifier is 
reported only once for each function it appears in
arch/riscv/kernel/suspend.c: In function ‘suspend_restore_csrs’:
arch/riscv/kernel/suspend.c:37:66: error: ‘RISCV_ISA_EXT_XLINUXENVCFG’ 
undeclared (first use in this function); did you mean 
‘RISCV_ISA_EXT_ZIFENCEI’?
    37 |         if 
(riscv_cpu_has_extension_unlikely(smp_processor_id(), 
RISCV_ISA_EXT_XLINUXENVCFG))
| ^~~~~~~~~~~~~~~~~~~~~~~~~~
| RISCV_ISA_EXT_ZIFENCEI
make[4]: *** [scripts/Makefile.build:243: arch/riscv/kernel/suspend.o] 
Error 1
make[3]: *** [scripts/Makefile.build:480: arch/riscv/kernel] Error 2
make[2]: *** [scripts/Makefile.build:480: arch/riscv] Error 2

The patch "riscv: Save/restore envcfg CSR during CPU suspend" (commit 
64e54f78d9f2dc30ac399a632922bb1fe036778a) requires patch "riscv: Add a 
custom ISA extension for the [ms]envcfg CSR" (upstream commit 
4774848fef6041716a4883217eb75f6b10eb183b).

