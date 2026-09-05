Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 568AA5478D
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 18:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788634040; cv=none; b=gPM+3knnSPZTStbudOSba/mTI8O2+c5zQ6j0wi+8DnoCX3eK21f9tKBaYxwxtkMSlsI40TNHAO9mApo8jiwBRBClkHukaOxRftRmYf7bu4dpCp7txOXbOXWnBbfzKNzhHz+tPHBBhy2ZAw0GKaTCRFerwWgQ4GPGJvF302Qh1cA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788634040; c=relaxed/simple;
	bh=VRk6A+H/YTnYz9SG2xBYyr6COKAP3kF4D1entXahM0o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rDwwyAwNG+gOuCK/D0Wim8tJVcnxDfjotmsdhEilmOfK0WvTu6D6eqZ8g0pFNC8ECTJeOMXrbaeHQD0pcGemC4hzG8Np4TjIMwZYtBXbC8id3sMRj3/oWrUX52q7DDqUI2aQ6hfRMU0l/weQ0alMf1aLlMonwB1cTn9ZeeidZXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=3JNX43T7; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="3JNX43T7"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id 2Z8txgwfGLvgb2vQ0x8Uyn; Sat, 05 Sep 2026 18:47:12 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 2vPzx9M9VF2DA2vPzxaS9k; Sat, 05 Sep 2026 18:47:11 +0000
X-Authority-Analysis: v=2.4 cv=FaM3xI+6 c=1 sm=1 tr=0 ts=6a9c63af
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=R25wJDua8JL5D/hP/FoueD5gH7uOrN14uzEfeiqYA+U=; b=3JNX43T732K0IBwy+V2Mcy35ro
	4hwrZCHs865GJbnHyM92fR4FQdPgdU28pv8pMOVQ8N8r8bUxi0ocv0f6d6Sknbl6eDoJPRaX9turN
	vJsVWgD3+qfxCYryeayjnNL7iu6ns8jXZl3dz1UbvKj+VbITerCmBp9GrSwWdvKJLN7x7GZLvAwB6
	r4mM6bHukleX6vQJnfhijib4DxJdQCqWk5zLZatsnxJCPIlzPSWocwf5xKJB+dIxkf/FcZGwrXPrH
	FPHzVc8f9lEkSpmwNnNQTXGT7/sWi7+i36DqxogoLbKw4Bu8eDoCH/TixNuOfcpBdym/eFd3FzaT5
	1Kz7/z2A==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:49992 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1x2vPy-0000000098m-27e1;
	Sat, 05 Sep 2026 12:47:10 -0600
Message-ID: <6d25a2d5-b7b3-4f9f-b9f7-d79c45ffff41@w6rz.net>
Date: Sat, 5 Sep 2026 11:47:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/400] 6.12.109-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260905115627.670276262@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260905115627.670276262@linuxfoundation.org>
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
X-Exim-ID: 1x2vPy-0000000098m-27e1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:49992
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJ7MWW7ou9C5vAIgB6Tsx6lnR6n7BrzEAiwgP+8HxAwxj4FdbFKuqbe9sPy30/fBEqnoyRdpK10K1DdSEsOsRYTqGXcqm691XVJ0qxF1ZR63wGnFz2OW
 1CcSYl8Fh5Jy6BeDOB+/pMdFA/DXY2ze4A6/76x2vAqYpTvH5jnoa1gfvB/IplaVPHc2lxTnL9mx6A==

On 9/5/26 04:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.109 release.
> There are 400 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 07 Sep 2026 11:55:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.109-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

