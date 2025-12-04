Received: from omta033.useast.a.cloudfilter.net (omta033.useast.a.cloudfilter.net [44.202.169.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F14B134029E
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 13:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764856292; cv=none; b=ABYRFBukuBGKJQ5sniZmn2LmRqzSgj7EoNTSKIW6WZagvVjFyxMU64NNBjJB8ncqx6Ck2CyEaXzwvBFOf0LOZYafwooE3IWFL8TK62jtGyCAnFiwCMmtQ0cdLYT5XHuAp8wWkEjOQCrnWhRQ9KpUC7/Z0efKlN7BMTNfC/Pu9zU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764856292; c=relaxed/simple;
	bh=bupgnj4eix4x94suWheCvcMabbqLLNHSRCzXm3iZpPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ePn+gILYujQ+ogsP5GYUo6BElMh5WZPGTgGJPAZJuNnBUduLZKaBduWQWjybiqeYzCcVdla8uApXqX3yw1af6+ipbypHxGwyn/u07akAHQ13AYkdvUkl/NccFSuiA/1QiV7Hk7c9QgSmWCPP8DLZWjkwGWhH0rTWVOe6az2tmpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=A13cCdci; arc=none smtp.client-ip=44.202.169.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="A13cCdci"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id QxsEvlRgJqgL9R9jtvTm2b; Thu, 04 Dec 2025 13:51:21 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id R9jsvadJ8vXvHR9jsvgyCK; Thu, 04 Dec 2025 13:51:21 +0000
X-Authority-Analysis: v=2.4 cv=e4IGSbp/ c=1 sm=1 tr=0 ts=693191d9
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=qNABUOcEAAAA:8
 a=b0U1OSKS18AjNlxaXoUA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=Ytm653ucTKQjCvbzLygB:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zsTMf+3paPYKZ3qzmg3aD8jj3/6WtZjggw+ud/4Gbzo=; b=A13cCdciE9MAOZtl0L9S4BoJmq
	oFt/NyB7gcKb7cFFfJUkmLpOtnp0oN3yco9mRBWXqqSeVvnU9RIjbDrLctNP7TWvTLoIWeBzZcSFL
	QqfYczWkjWdDKh+44ZFQKrOI1Dn8A3f2GmW+SdTr0s5RLbiVivNquD5IvgzCXEA4P7x4FvhYfpUIn
	LEs6av9SVlunjC7yusfI2YMaBkc7CTMYStBmJQtRLHZ6bjYs7NkjGsD4ejy4ngAjFuDa7QOy/Ji7s
	cCAlzgnclV/sHsGhuGglYDPoBKYwZ086WESq8jc20ZwOy/XpVjYzKZbfOs9EMyxnqJLIVtLQVA8B/
	lOUoZbJA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:47320 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vR9js-00000002pKn-1DiJ;
	Thu, 04 Dec 2025 06:51:20 -0700
Message-ID: <481f5985-da16-4b06-912d-dbc831504068@w6rz.net>
Date: Thu, 4 Dec 2025 05:51:18 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
To: Mark Brown <broonie@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, achill@achill.org,
 sr@sladewatkins.com, Kiryl Shutsemau <kas@kernel.org>
References: <20251203152440.645416925@linuxfoundation.org>
 <bae0cb4e-9498-4ceb-945c-55a00725d10e@sirena.org.uk>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <bae0cb4e-9498-4ceb-945c-55a00725d10e@sirena.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vR9js-00000002pKn-1DiJ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:47320
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCOIlXJ5qtAXrnoEaroNrOgeMCvYTnXDNKSc+ISERSw69RXUzt+wUg+sQRf4/UIxll13zcbNrm1D8uGF0wKSYJ44zbPEZuir7U7RWDwzD2WJiq2lO8b8
 0bx5gjOnc9sYSaq/1D6ye8MRcjzI24eAGaE8863Hc277lHF4hs/Y0N1bbol6T40pGZE2NAdOG8iSYg==

On 12/4/25 04:06, Mark Brown wrote:
> On Wed, Dec 03, 2025 at 04:20:02PM +0100, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 6.1.159 release.
>> There are 568 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
> I'm seeing a bunch of systems start failing with this release, they
> start OOMing when previously they ran OK.  Most of them aren't exactly
> overburned with memory.  These failures bisect to 61717acddadf66
> (mm/memory: do not populate page table entries beyond i_size), sample
> bisect from one of the systems including links to test jobs (the bisects
> for other systems/test sets look very similar):
>
> # bad: [abd89c70c9382759c14c5e7e0b383c2a19594c5c] Linux 6.1.159-rc1
> # good: [f6e38ae624cf7eb96fb444a8ca2d07caa8d9c8fe] Linux 6.1.158
> git bisect start 'abd89c70c9382759c14c5e7e0b383c2a19594c5c' 'f6e38ae624cf7eb96fb444a8ca2d07caa8d9c8fe'
> # test job: [abd89c70c9382759c14c5e7e0b383c2a19594c5c] https://lava.sirena.org.uk/scheduler/job/2168338
> # bad: [abd89c70c9382759c14c5e7e0b383c2a19594c5c] Linux 6.1.159-rc1
> git bisect bad abd89c70c9382759c14c5e7e0b383c2a19594c5c
> # test job: [43c650106e8558fa7cfec5a2e9c8de29233b6552] https://lava.sirena.org.uk/scheduler/job/2168373
> # good: [43c650106e8558fa7cfec5a2e9c8de29233b6552] rtc: pcf2127: clear minute/second interrupt
> git bisect good 43c650106e8558fa7cfec5a2e9c8de29233b6552
> # test job: [b56fbe428919e8c1a548f331d20b8c4608008845] https://lava.sirena.org.uk/scheduler/job/2168393
> # good: [b56fbe428919e8c1a548f331d20b8c4608008845] net/mlx5e: Preserve shared buffer capacity during headroom updates
> git bisect good b56fbe428919e8c1a548f331d20b8c4608008845
> # test job: [445097729a995f87ff7c80d5a161c7e1b5456628] https://lava.sirena.org.uk/scheduler/job/2169640
> # bad: [445097729a995f87ff7c80d5a161c7e1b5456628] platform/x86: intel: punit_ipc: fix memory corruption
> git bisect bad 445097729a995f87ff7c80d5a161c7e1b5456628
> # test job: [ad3b2ce45cce79ddaff01c977d0867d079fa8349] https://lava.sirena.org.uk/scheduler/job/2169710
> # good: [ad3b2ce45cce79ddaff01c977d0867d079fa8349] kernel.h: Move ARRAY_SIZE() to a separate header
> git bisect good ad3b2ce45cce79ddaff01c977d0867d079fa8349
> # test job: [de07228674e9cee27f679ebcf8562f7e3b2cda21] https://lava.sirena.org.uk/scheduler/job/2169731
> # good: [de07228674e9cee27f679ebcf8562f7e3b2cda21] mptcp: decouple mptcp fastclose from tcp close
> git bisect good de07228674e9cee27f679ebcf8562f7e3b2cda21
> # test job: [dca2a95e4ed753ed33da11d7bb78157441d69bad] https://lava.sirena.org.uk/scheduler/job/2169741
> # good: [dca2a95e4ed753ed33da11d7bb78157441d69bad] pmdomain: samsung: plug potential memleak during probe
> git bisect good dca2a95e4ed753ed33da11d7bb78157441d69bad
> # test job: [61717acddadf660fa6969027bfa0d6fd38f8e3e2] https://lava.sirena.org.uk/scheduler/job/2170912
> # bad: [61717acddadf660fa6969027bfa0d6fd38f8e3e2] mm/memory: do not populate page table entries beyond i_size
> git bisect bad 61717acddadf660fa6969027bfa0d6fd38f8e3e2
> # test job: [0de5c14c8e753a547d158530c37efb245f7b40ec] https://lava.sirena.org.uk/scheduler/job/2171171
> # good: [0de5c14c8e753a547d158530c37efb245f7b40ec] pmdomain: imx: Fix reference count leak in imx_gpc_remove
> git bisect good 0de5c14c8e753a547d158530c37efb245f7b40ec
> # test job: [1457e122dd70574a0ca895eea6d6c12ba91312bf] https://lava.sirena.org.uk/scheduler/job/2171268
> # good: [1457e122dd70574a0ca895eea6d6c12ba91312bf] filemap: cap PTE range to be created to allowed zero fill in folio_map_range()
> git bisect good 1457e122dd70574a0ca895eea6d6c12ba91312bf
> # first bad commit: [61717acddadf660fa6969027bfa0d6fd38f8e3e2] mm/memory: do not populate page table entries beyond i_size

This patch "mm/memory: do not populate page table entries beyond i_size" 
also causes an Oops on RISC-V.

[    5.940397] Unable to handle kernel paging request at virtual address 
ffffffc6fe000028
[    5.947616] Oops [#1]
[    5.949814] Modules linked in:
[    5.952857] CPU: 0 PID: 147 Comm: exe Not tainted 6.1.158 #2
[    5.958500] Hardware name: SiFive HiFive Unmatched A00 (DT)
[    5.964060] epc : _raw_spin_lock+0x12/0x84
[    5.968141]  ra : filemap_map_pages+0x23e/0x524
[    5.972658] epc : ffffffff80b4d500 ra : ffffffff801e3d60 sp : 
ffffffd88c923c80
[    5.979870]  gp : ffffffff81a3f228 tp : ffffffd88c8c1a80 t0 : 
0000000000000000
[    5.987078]  t1 : 0000000000000000 t2 : 0000000000000000 s0 : 
ffffffd88c923c90
[    5.994287]  s1 : 0000000000000000 a0 : ffffffc6fe000028 a1 : 
ffffffc800000000
[    6.001497]  a2 : 0000000100000000 a3 : 0000000000080000 a4 : 
0000000000000ff8
[    6.008706]  a5 : 0000000000010000 a6 : ffffffff813d5858 a7 : 
0000000000000000
[    6.015915]  s2 : 0000003f807ff000 s3 : ffffffd88c923d98 s4 : 
0000000000000000
[    6.023125]  s5 : ffffffd77fe00ff8 s6 : 0000000000000000 s7 : 
0000000000000000
[    6.030333]  s8 : 0000003f80829008 s9 : fffffffffffffffe s10: 
ffffffd880f866f8
[    6.037543]  s11: ffffffc7020b67c0 t3 : ffffffffffffffff t4 : 
0000003f807ff000
[    6.044752]  t5 : 0000000000000000 t6 : 0000000000000000
[    6.050047] status: 0000000200000120 badaddr: ffffffc6fe000028 cause: 
000000000000000f
[    6.057957] [<ffffffff80b4d500>] _raw_spin_lock+0x12/0x84
[    6.063338] [<ffffffff801e3d60>] filemap_map_pages+0x23e/0x524
[    6.069157] [<ffffffff80229ffc>] __handle_mm_fault+0xd44/0x1818
[    6.075064] [<ffffffff8022ab84>] handle_mm_fault+0xb4/0x1b8
[    6.080622] [<ffffffff8000cd54>] do_page_fault+0x142/0x462
[    6.086095] [<ffffffff80003f20>] ret_from_exception+0x0/0x16
[    6.091798] ---[ end trace 0000000000000000 ]---

