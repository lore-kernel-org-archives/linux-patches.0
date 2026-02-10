Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF64346E46
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 10:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770718052; cv=none; b=L9xq3BQTI2q7XXrel+swY+5lJ6ORUqF6Q7R6ieq44CUZ3SfwCPXaQRdGNrlcdgiQVMv6/5LGvb/Zyo+g1KvDzGzcEZLWK59OtoDqBPp7TAUeyXkSoWH2ja42RzibjHNh3GCzGNRmvSKcWQA0tOqeKkSxCmCx3TJjq9UXiskc8Ew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770718052; c=relaxed/simple;
	bh=swbo/Sf54WOt1r7kLvsMt0x+7Lm9qiFagtDXc2yxkOw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LZsJBoeTdzkLfos5l4rMhvhAjL1+gfslmJormfspOkVvVQrELrWDnlxq3k3AmAkJrPl7oWEPiHlHRzmlByXqOXnce/D28k/y7KygYM2ktSpdLOjUIPQMYWQAoELdRspX5sVYlr0/RggFQ8BEKxoqYr/AbxQDOd/+9KjOLa8/z2A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=CprmzF1S; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="CprmzF1S"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id pkXQv7fNdipkCpkeYvXpgk; Tue, 10 Feb 2026 10:07:30 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id pkeYvaq24qfpWpkeYvcgDx; Tue, 10 Feb 2026 10:07:30 +0000
X-Authority-Analysis: v=2.4 cv=A55sP7WG c=1 sm=1 tr=0 ts=698b0362
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=-Qcm0AZxhyoZnww38z8A:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=SRJEKlgf1cU8u7kDgnrAbTXG2Eipl6g3LX3Q0whDiAk=; b=CprmzF1SlTN2TWExz1yYUvPO1B
	WbCSBnXc0LfK6FXzgvMatFDecj+4Ku2yhp9WNP3+IliSxAyWmZ5bjLMWmWPB38tm+8ujNFt30buCn
	aG8CgUD/N8bCpuxGhCdwNAzhP6c/RYAxyONpn/qMc6EOQi8DLiMyhYb2FP2LR2C1qhA8SxP5fioRY
	qxOf/zuhhB68US/2klfhX515+x6v5Z+UzXSoX0wd2BvI6L1VOox/IFbI0idHMWuk4+Cqf/HrnR+YC
	AwHqWLTw1kKMIXvelUjCoM3+UeOzUUwv2CVOHF4s/FgMtBf5+vk7bq/s/sbft4NAoyatRDlahCOK6
	/eQTqaEQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:52582 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vpkeX-00000000pLb-2Zfh;
	Tue, 10 Feb 2026 03:07:29 -0700
Message-ID: <0fefff6f-127a-4be8-a479-fc52b6e1d590@w6rz.net>
Date: Tue, 10 Feb 2026 02:07:27 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/75] 5.15.200-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260209142301.830618238@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260209142301.830618238@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1vpkeX-00000000pLb-2Zfh
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:52582
X-Source-Auth: re@w6rz.net
X-Email-Count: 23
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGPO81KgHBUs6Bqk9GmsYMFTZ/XWcEgaOcMK6k/168xZ848VObyDWB7zd3XAr8hPH/h+IR1RloFywJgCenORCoK8OPla3hdtv9XSw5rNIwQskGLI143p
 Ac3DlCAx8sFubX4gux1pu77rFHTmKa46brDqRoLhQ2w6gTJppioYPqV0iY9IcsocZLWxMpJLqdVR+g==

On 2/9/26 06:23, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.200 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Feb 2026 14:22:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.200-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

There's a build warning on RISC-V.

arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
arch/riscv/kernel/probes/uprobes.c:164:23: warning: unused variable 'start' [-Wunused-variable]
   164 |         unsigned long start = (unsigned long)dst;
       |                       ^~~~~

I've sent a fixup patch.

https://lore.kernel.org/lkml/20260210100148.3674334-1-re@w6rz.net/T/#u

