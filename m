Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0A41DB362
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 06:56:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736233012; cv=none; b=Ca7xK5Hi1GXCah66XyjgRGDLsJCw2Z6rBEpQOBzrlYdZ/aWe+1cDa14RCF8nhIJXxhD3/0HoKP2Nn3D3b8UIGoSbTTSVlOHXirrLnPyeKWQa+Bbi0wQsTCNcZaLkHQ4hp4jM/hS9NplMTuJ/muaY1tSX4cnzexAAOlkX1+SVzNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736233012; c=relaxed/simple;
	bh=i0Ff2s9LMWtpzvyhnnSSI4aGUU0Tx5Wthlsfj0Zew/Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uxG9ul2yqBXygHXKyx3+3NI1kPiGsiCkdx2QC+Retoxi7nSEy3c84Mg1k+r/NnSQ9822yfBSXcDbOIZ0dKN8cfr39JOU9LSREG8GFMcoTOEaKzvJdRvjgNbVOqvVvHwyWIg3z6Ed3bckQ8GuGi3otk0YRGuW2EkNXIuM0k9zpg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Dqw978Lx; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Dqw978Lx"
Received: from eig-obgw-6010a.ext.cloudfilter.net ([10.0.30.248])
	by cmsmtp with ESMTPS
	id Ulb6tCYv9xoE1V3WBtj4sf; Tue, 07 Jan 2025 06:56:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id V3W9tGTGUhs2qV3WAt7Tkh; Tue, 07 Jan 2025 06:56:46 +0000
X-Authority-Analysis: v=2.4 cv=NeDg1XD4 c=1 sm=1 tr=0 ts=677cd02e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdSt8ZQiCzkA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EaQfPr9QHXkIQesc3ShGIyErbz0DQliOfilva1ccqyM=; b=Dqw978Lxaw9qTmlCLYbzGjLvk0
	jvz5hwb+VfaKgC+Sw7Xy+FR2NapEqmoXq7o5Auv1xckuhWo/w3o1qdE4hVZeLAwGxESuz9Vy8DPd9
	BVBxm+Xkwt89RipdKYJ14uMl3IDEGEpAJpSx9FV6EBvNiocHyWYiRFdKYCBpITSOzjOUnpagfLVt3
	AGN2tZF76cS1GXXwPRUS0h62jwZZLKB6OOGJx7oJOKdKusiNrCjc/RXJjITtF6kh13UbgfAZBAL/x
	Ki3cLxO8Qk9tQ7axp5X2c99YBRs32t4LBtSzAhO0Iipc+MNZtKq4yCM02Br4DL3bN1Ye88F0R9847
	hpsgloBw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:48566 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tV3W8-002fAA-1u;
	Mon, 06 Jan 2025 23:56:44 -0700
Message-ID: <65bb39aa-4b39-4adb-9fb7-49323634214c@w6rz.net>
Date: Mon, 6 Jan 2025 22:56:42 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/156] 6.12.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151141.738050441@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1tV3W8-002fAA-1u
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:48566
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfD6UbWEPm7oobUYiweHaO7w32Yr8YWZUHZbZR3CiC6V43joqrqDZ73PTmnY7JUba1igH/KPhKFKWw+tS4xUNjVLG3daWwNboWMVS9sRU4IP5qHAOZ4qY
 pHuAqvtwlgPcsb/MPJgZ6ww0Jz8hJoSmgJJGfQ8Ylf4XQJ5TB3UjpdnG361SR8HlAYbJwvGE+pizPA==

On 1/6/25 07:14, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

