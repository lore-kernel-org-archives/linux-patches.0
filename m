Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892387F
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 07:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="nUYjCouw"
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
	by cmsmtp with ESMTP
	id oBmdqul9JytxcoIiTqVTDT; Thu, 05 Oct 2023 07:24:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id oIiSqhQDXSxswoIiSqLWBP; Thu, 05 Oct 2023 07:24:12 +0000
X-Authority-Analysis: v=2.4 cv=ONA0YAWB c=1 sm=1 tr=0 ts=651e649d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=bhdUkHdE2iEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=1GQxe75yrw9fIeUcjpcA:9 a=QEXdDO2ut3YA:10 a=YPl7agAxxgJ-DdPUcAh3:22
 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:MIME-Version:
	Date:Message-ID:From:References:Cc:To:Subject:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=czEfrh1lhCrzi1gN8GkPRtmuOYdx76Mpuc2PouPnKgU=; b=nUYjCouwft4ffYz1VzDWSMPBTJ
	pnccYa90acu/5IaEgWVrZ9DV5UXxyqKH+rZq3y5wr3q2l9NMJpP1zXSifByHYxiQC8ihLcpqtezA2
	GY80uRzAdkvH1pmLXwtd9CzKoHpQWtaguyE7B8XsUfLS7R9Z9fz1nwX3Xi6whCMiPdrppS16q2Jeh
	YqWSbiam5kIpndSMQL6YUuUBFuSGAnY71yoUGnaj996OsFwYVxmYM0HvKaoUHuw8psNh4V9lSRqpC
	NdjgAV9y9y4pb51oAj53obnglbqiuRkcBCIgSIcHWlPExajH1x6aPdwbt+1ewmM0t4197oi3UEYP+
	tfPS1Qdg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:49224 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.1)
	(envelope-from <re@w6rz.net>)
	id 1qoIiQ-000GpA-0x;
	Thu, 05 Oct 2023 01:24:10 -0600
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231004175229.211487444@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <be48ca60-57dd-9bbb-d695-0d9d39e98dae@w6rz.net>
Date: Thu, 5 Oct 2023 00:24:07 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
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
X-Exim-ID: 1qoIiQ-000GpA-0x
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:49224
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGTQtKDiS0mm/DDyzCFLsAa0jwaJZ400W9VniLlfowFB50E8sT99X3ad90q2RXAx/5fRGm7oxgkT6aJZQIfm+W+4zDlBc9dasYfhkzh8YOpbxnpmlSY/
 89eNIOsiGExInzdOCkRxP/IeVmY0Kjl5fEtYsWkzSOaeBz7EZ6x8tBn1ETEz0MQHqKFjkZduzfYH+Q==

On 10/4/23 10:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.6 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
On RISC-V RV64. Bisecting now.

[   13.215905] ------------[ cut here ]------------
[   13.220246] bpf_mem_cache[0]: unexpected object size 128, expect 96
[   13.226554] WARNING: CPU: 0 PID: 1 at kernel/bpf/memalloc.c:384 
bpf_mem_alloc_init+0x2f0/0x2f8
[   13.226581] Modules linked in:
[   13.226590] CPU: 0 PID: 1 Comm: swapper/0 Not tainted 6.5.6-rc1 #2
[   13.226597] Hardware name: SiFive HiFive Unmatched A00 (DT)
[   13.226600] epc : bpf_mem_alloc_init+0x2f0/0x2f8
[   13.226607]  ra : bpf_mem_alloc_init+0x2f0/0x2f8
[   13.226614] epc : ffffffff801d6f68 ra : ffffffff801d6f68 sp : 
ffffffd88023fd50
[   13.226619]  gp : ffffffff81c48f90 tp : ffffffd880218000 t0 : 
ffffffff80c58e60
[   13.226623]  t1 : 0000000000000000 t2 : 635f6d656d5f6670 s0 : 
ffffffd88023fdd0
[   13.226628]  s1 : ffffffff81223bda a0 : 0000000000000000 a1 : 
0000000000000000
[   13.226632]  a2 : 0000000000000000 a3 : 0000000000000000 a4 : 
0000000000000000
[   13.226636]  a5 : 0000000000000000 a6 : 0000000000000000 a7 : 
0000000000000000
[   13.226640]  s2 : 0000000000000000 s3 : 0000000000000000 s4 : 
0000000000000000
[   13.226643]  s5 : 000000000000000b s6 : ffffffff81cb5110 s7 : 
ffffffff81c4c238
[   13.226648]  s8 : ffffffff81cb8028 s9 : fffffffb82320370 s10: 
00000000ffffffff
[   13.226652]  s11: ffffffd7fff82370 t3 : 0000000000000000 t4 : 
ffffffd880155f00
[   13.226656]  t5 : ffffffd880155000 t6 : ffffffd88023fb48
[   13.226660] status: 0000000200000120 badaddr: ffffffd7fff82370 cause: 
0000000000000003
[   13.226665] [<ffffffff801d6f68>] bpf_mem_alloc_init+0x2f0/0x2f8
[   13.226675] [<ffffffff80e16256>] bpf_global_ma_init+0x24/0x40
[   13.226689] [<ffffffff800029e6>] do_one_initcall+0x5e/0x208
[   13.226698] [<ffffffff80e016fa>] kernel_init_freeable+0x26c/0x2e6
[   13.226715] [<ffffffff80c6992c>] kernel_init+0x34/0x180
[   13.226721] [<ffffffff80003e86>] ret_from_fork+0xe/0x20
[   13.226729] ---[ end trace 0000000000000000 ]---

