Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E30D336EC9
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 07:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770710019; cv=none; b=aio9ZF08pp/kzffuiUow++aRKNGH5nmSoKcDyLOxyBSWbJYBjNZNW+3KfYiJJYfUbpv9yJZwk/dKSpA9m+BT5BPI404DfXML0sbn6bEeO8v52c7MQ1hw6GPJLCerR2PUSyNirlj6Zu1Xw2u+xaHkxHvh8DR1rNUSgFEpHsofoRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770710019; c=relaxed/simple;
	bh=fZ8/GjoFS0wQUkcMKMVVUWPHkBgAAR/6HIWc/6N2VY0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hIuzklYVMVwhF+exKE9nnKjtnH2E8duOQPh9vEyvszYWsayTAvZAkBFPIMUomO1Fh48No0t2HNNYly9ciVJePdlTDpiaDNzWz1/QyHJP1gHIDTohWaaLWc9ckWLqkPoBm/AO4sPygc2iFYJVQAD7Blf4pcMETsDaC/iIvtiupZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=zqIUAZrV; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="zqIUAZrV"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id pbAhvrssNVCBNpiYuvjq71; Tue, 10 Feb 2026 07:53:32 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id piYtvukzJjAxupiYuvCdXh; Tue, 10 Feb 2026 07:53:32 +0000
X-Authority-Analysis: v=2.4 cv=EoDSrTcA c=1 sm=1 tr=0 ts=698ae3fc
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=aGZOya1N0A+0bSTjR5Nb8qe2Neseo8MgJvie0MK9zQY=; b=zqIUAZrV6dphYZ2TPC7jMQYelv
	hA7iaZHRr4146a84u/laguvEK7rrtaA/riRI/eGFnTK5is8dOyqLS9y/9NlmMxLGerxY3pmm3miaJ
	5EcIKUNpE2A/c1HPXM58qtmiwGeZV+jfjndnTfufCLpic+Zf2jkQBKx+AIZklTAoWDS1Ok0WkO+SO
	NpoyYRsGJtUhfc22rxbyDLfjGfmsHws9fKFaKKHtLITCU9PbzsI0SrQkJfmU/e+zhrfj73tX1TMPJ
	k0XJzCqiPR/fTBrGzWzSZWpGohyNJ6GCLtIGHMXIqi9neY0I1zfB0HpR0M0sUizIFbj5ITcsOzWNi
	ZnAmMcgA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:49372 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vpiYt-00000004J0r-0pqg;
	Tue, 10 Feb 2026 00:53:31 -0700
Message-ID: <fa1e2012-4d33-4846-9334-abadc25a2184@w6rz.net>
Date: Mon, 9 Feb 2026 23:53:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/113] 6.12.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142310.204833231@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260209142310.204833231@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vpiYt-00000004J0r-0pqg
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:49372
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEdq9CPEGTvUEs76D1urmcoXMZmsilRwE9lYfa/ZTANktW8bKtiHT40XB/Fg9DCJvea8tj5w2ywjWnu0lJaK/Ote8/k3iHBJjAZ394ksXuCTDsOVmVPC
 g8LLNcKmeohvItUdsQX82uzrKUeeynU6Fjspo2sCqqtF+2W+ehKM3lPZVfbEA4U0Db48t9fM99RQ3Q==

On 2/9/26 06:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.70 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.70-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

