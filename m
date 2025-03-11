Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0CA42065
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 10:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687569; cv=none; b=eazhttRR5ZzZCpNW3mD/epRBarluTVUaEgXuKYXonqq2Z7U1BT6d6zikYBOxS/pohuRCuatr8WQr4EcFEuD7LKnGHsr9dB+acYaK35hD/v7WCsNs+ypnYoz2aDvSLClwOXByZ7YneXqt08hO5g7lS84P9U7UP+trSxbfRGb4Vv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687569; c=relaxed/simple;
	bh=rjkpyxd6RWcA9w9OKfTstC4hp2OuOWUSlwYw8CdoWwI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Un7SKy82+xRWG20nMtBKSLgDO55houFRBde+YTIWh7SRmPIod3NEl/2BDiq32bDxk0Md69B+XzlfgGLbTOYG2fWSK0LRagUQUr+Q0gGzddNZ3J+rFABVgMzp0m1kqWhTPAB6Fqi6ELLphQasg2Gqrdq7LUPUTiIxn/zimOIMEqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=EAy//yhi; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="EAy//yhi"
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
	by cmsmtp with ESMTPS
	id rgx3tnxjoVkcRrwUvtEMml; Tue, 11 Mar 2025 10:06:05 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id rwUutEbuxvt5YrwUvth4Ug; Tue, 11 Mar 2025 10:06:05 +0000
X-Authority-Analysis: v=2.4 cv=c9JgQg9l c=1 sm=1 tr=0 ts=67d00b0d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=VGeZqF52+y3Rppa+8xZLTmlKkc+wJljUH1xmwaROc6Y=; b=EAy//yhiPgty5l4xUtFNo0yZ4q
	poel9alzEyUTFCmHPWCPk181FHWPZ6NY+mJBafdWLRebXoJX/BzT0oxDOlYHAKlZfp+Si9nKN4NSA
	Z4rtW1J59GaMi/iEzecJD8mna4dEjm88QNQqj9jMZ8uIC6m6vRmGwlpt+m3u35gY/zCxyJBW8dR1N
	ym/Dre2nxIlrRe3JK2muDfYv6YO2qf2EtZplHk7pLxsn56ivUOLZVVXKdLV2LMHdmarNlMaAD25No
	hPRXd6d2qTxDKjSev0AYCkVQjrBMNzEngysAJPtxJtf3KnmXF3a5HMCYho8LMJNOxdbihkfzc1B5q
	hwbkSfWg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:57318 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1trwUs-00000001SwB-3ANY;
	Tue, 11 Mar 2025 04:06:02 -0600
Message-ID: <4bad0d2f-e359-438d-9160-b70b610f7ae8@w6rz.net>
Date: Tue, 11 Mar 2025 03:05:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/269] 6.12.19-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250310170457.700086763@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
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
X-Exim-ID: 1trwUs-00000001SwB-3ANY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:57318
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfILsJh/w8hHTIOl6STP0SSIkHHWZhXoATF/uhGGwHP5w9h1GkgDcJ833u9yVqxcf89pKS2afA1VltBUksyuwk4OYEVWogXdLvUAuUCS1QsnloWQzmA5F
 yHeHAAG/J2nhNjSTCukaWGmVhTU6H8BlLP5ke9Bwmbho3wmXUOG2oc4KYCQLE3VRrKKNEgo0UtDh7w==

On 3/10/25 10:02, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.19 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.19-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

