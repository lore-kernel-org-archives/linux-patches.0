Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8877D29A
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 22:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="0OqWRKLd"
Received: from eig-obgw-5002a.ext.cloudfilter.net ([10.0.29.215])
	by cmsmtp with ESMTPS
	id xtRaqoCwOjtZ3xxaMqo5tm; Tue, 31 Oct 2023 22:51:46 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xxaKqP8dQF1O4xxaKqdvSJ; Tue, 31 Oct 2023 22:51:44 +0000
X-Authority-Analysis: v=2.4 cv=CcwbWZnl c=1 sm=1 tr=0 ts=65418500
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=bhdUkHdE2iEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=BZ6ONlOXkBpYPFFA8NQA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3rpYGiaoo5zucxoVeBYC5Mx0GLDamigQVQRPlkiYVm4=; b=0OqWRKLdl6mnZF4UELRZD3jP9o
	qOZdsc9eSG5Er/L5Wj6v5FGKIE+TC4k+83GVyPcpiq3ByHSWHRpkHgCY/HK22PpWWtuOvNkHrpER5
	3xntmi68gK+29WFgBXouQSfQ7oSj7gvE7k5AhdB9FIJ7BE+pF292Vx66SLti5kF4Fu5I8WW6CcApG
	vZggJ7HWL4/j38sXue1kMukGkwgKBjwInojgCk2bG3y5HMgWTIRm7kbw0UHIfFqEHebSxAvSLnP/y
	Eopq6aHjQ/17mICTjQ4oimZ+VU3peJQ/jHUZsynl0op1l3fC0jBQDznWkvV8128ivmFno77KAwfE2
	7zlPf5xg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:53446 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1qxxaH-0040s9-3A;
	Tue, 31 Oct 2023 16:51:42 -0600
Subject: Re: [PATCH 6.5 000/112] 6.5.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231031165901.318222981@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20231031165901.318222981@linuxfoundation.org>
Message-ID: <38fbd463-1160-0212-b9d2-6efeaaa6548e@w6rz.net>
Date: Tue, 31 Oct 2023 15:51:39 -0700
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
X-Exim-ID: 1qxxaH-0040s9-3A
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:53446
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIC+WChdnCbZqU8p2wjCBec4khQnXIf95wG2Kj3A1DiQ5u3gBCE6dV60dQQ+KNSybUpH3q0RuoTGMKnBHvPFKNzGfjZoP6u1lmgNXpxFtZjynZ5A6y1g
 MaLGdWqT6oFQoamlnGKeBjCkmEQ+X8Qi56RCHbfL5XA+3Os0845C0HhXJWyxO0Hhqmh8VEGG1vOK4g==

On 10/31/23 10:00 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Nov 2023 16:58:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The build fails on RISC-V.

arch/riscv/mm/hugetlbpage.c: In function ‘set_huge_pte_at’:
arch/riscv/mm/hugetlbpage.c:188:13: error: ‘sz’ undeclared (first use in 
this function); did you mean ‘s8’?
   188 |         if (sz >= PGDIR_SIZE)
       |             ^~
       |             s8
arch/riscv/mm/hugetlbpage.c:188:13: note: each undeclared identifier is 
reported only once for each function it appears in

Caused by commit 16b6f77970f7a690c61de142511c9ac488d83e04

riscv: fix set_huge_pte_at() for NAPOT mappings when a swap entry is set

This patch requires mainline commit 62ba41d2761206664a1fdc998051324457da2dd6

mm: riscv: fix an unsafe pte read in huge_pte_alloc()


