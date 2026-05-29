Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB9BA373C1D
	for <patches@lists.linux.dev>; Fri, 29 May 2026 05:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780033163; cv=none; b=iRT2N3JtF2HdJg/Q9eR65do4GMMg4YoSsDGbSjUwkKI6pH2bzptMAwXf5zVBmaJPf/57t0tfI0+toOfTTY/SeBlPeXFPAA/Z4bQJALuE4gKT/bPvHs5oiMjIdp0Ji952tuEjxD5ZY0/UYCNOyTcVOGA0efpQ06D36bnKQsdNP40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780033163; c=relaxed/simple;
	bh=dRzUygQQ8AuctiH5MC367LooOIjYX9am+VfGLUf2Lhk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ix175kLOdtGAsgyH+Ft3kieSXED6Cn2V+d54fdPetiVu8hSpOvIWrzI3ho9NYYDWIR+9kKGRvkkhbLV6kFKB/qARP1+u7j/iLAexHil5K7//6ucUDif2o2FgkrHTCyfW7I80O6BTPwg/nLEVMXuGZzJAEix03KA0jlsOOHPudoA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=L4ftievM; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="L4ftievM"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id ShpiwhiiKPpWVSpwIwmBSc; Fri, 29 May 2026 05:39:22 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id SpwHwHbgO9e09SpwIwAjtp; Fri, 29 May 2026 05:39:22 +0000
X-Authority-Analysis: v=2.4 cv=SY/3duRu c=1 sm=1 tr=0 ts=6a19268a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1h1FYvp6bzo1KW3IwfSIl4F2Qbv8BcLk1wnz1nEaG2k=; b=L4ftievMLbowEC3TUbr1uLzZ6P
	EsmB8PcUMpuiHmDNgP9oUAhd1ckm1Bb4Bpmwu2pXOj9UmocLVc9Sq0idtqkuK/d2wdvTOjJ1ZKKZw
	F9mW4NFvCd4vW2pjtaeD9hgdxCHWEAOSUnSuGm+rpKA98e0l3XuogjspuyUq0n4oEbz0cDfZHWHpH
	JjiwQF2LoylHHFH/hRiro+FfUoca0JbN2ictZtCgg6gEeeY9tdcer0HvuzgI5mbbfa1Lhzn3ByKir
	ktm2QUdZEj+yevs6sZqKNMTpBPLivF6c76vdqDcQsIB6swMSNm7maujxUsBG1FnvGXv3EmUeb9AUy
	Fk/PrRDg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:53104 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wSpwH-00000003vyi-0CSl;
	Thu, 28 May 2026 23:39:21 -0600
Message-ID: <91e39b27-cdd1-4d8e-9ad2-cc7476713623@w6rz.net>
Date: Thu, 28 May 2026 22:39:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/272] 6.12.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260528194629.379955525@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260528194629.379955525@linuxfoundation.org>
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
X-Exim-ID: 1wSpwH-00000003vyi-0CSl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:53104
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFJoodA+kXmLu98FYA4Kf2TWPYhx8pJTs58iorvSQDlhraefaGO0euabfxoPKktlNCgOSEuCqHaXph17xeSDVRrnbIBHbFsoSoJ+mKIr4g+A9E67J/oh
 Nsy38IZ3hFhWXjzrOQjuqgjV/AXyPh+3u+7i2Ts14Y5cys7V5nMrjTwDBC61i37qflGH1B7T6JMsew==

On 5/28/26 12:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.92 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 30 May 2026 19:45:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

