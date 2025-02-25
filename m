Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D21A257443
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 06:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740464620; cv=none; b=sp1l6PvQBFfMmGhCatP1bj1a5ZqYai3Z5pY9+eoGTzYcNX58r/FHmE5n0vNAuC7WtcMUWJBslWUVq9A5VKsByDkJE6ak2HoDqFlT/pQItWuKNzqNmHROyGOZoxPxPCqpQotnC5xs7OgHxdUjy7N1GioizMJa19ibkKtupfxqoUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740464620; c=relaxed/simple;
	bh=InjPphvXvck7XZQVAEzYp3L5qLZyOZNGayaXBVX5opQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=p2mD5l1ZGi6HW6lStM0zZ+m/1489BvTSLaPOsVJRSBp+aiT4i4/HKLicjGLzxkjFNg6XUsLlZMaxw0UmIuAo1mhu2N/kyx5deAW0XK0ecAbvKUoBg4TNhduMIsPdp71DXw6eG77kdFE8DhUYq05uHCmLAtvBMkJCFaN+SeB8zuA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=O4G4xvSh; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="O4G4xvSh"
Received: from eig-obgw-6010a.ext.cloudfilter.net ([10.0.30.248])
	by cmsmtp with ESMTPS
	id mbdNtDifEXshwmoLqteoRd; Tue, 25 Feb 2025 06:23:30 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id moLpttnk66LcjmoLqttJS8; Tue, 25 Feb 2025 06:23:30 +0000
X-Authority-Analysis: v=2.4 cv=UfxXSrSN c=1 sm=1 tr=0 ts=67bd61e2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=B77GYMjoi4kFFzLnU8gYlsi6rIvhF1nmTqb6FN5GZvs=; b=O4G4xvShRUp+ijSWsMOnKFSH3c
	7zfEJ820lKzdKts+t8+x1xhnWpi5nIRQ9xGYqGGTJZ3PpNOR73KU28hUVDI8ECQ4J9foScuReNO4b
	ZhRyFfQUstNw37O3s1+6yfdBi7GiYeuCKeP99UR+Ohdd6b80b5IiB1iGULMP1FestiigZmGG7tmqy
	Yx/MRGBvV4TbN3RUz/0WPZWK3mtWWyJyZWzP/D52IJMH2/93d45VknZBUi7cAwEldSPTSDFUdXBdo
	jCQ2TIyOhdBy7xkhnf21Ar/Kh4rnQMhmftzfjLqMwPjckE5fWcveVrumwwkITeU834aprIm4/F6vM
	NHhRR8qA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:56256 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tmoLn-0048lH-2a;
	Mon, 24 Feb 2025 23:23:27 -0700
Message-ID: <30b018a0-0468-43a0-844b-82a00e2ae677@w6rz.net>
Date: Mon, 24 Feb 2025 22:23:24 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/154] 6.12.17-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250224142607.058226288@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
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
X-Exim-ID: 1tmoLn-0048lH-2a
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:56256
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCviMItvyW0zewc/7UJyRZgFtk2Nx8XUh32v7oXEPpdXHOKhUAbTEf7W4J1Dm37ipBYNn+UTriByLrIF/5EI3sMZapdNWQBZ+vtktphRAaVs8fYqC2p5
 QwSa0Kpy20xe1g8t3oAJk2inAuUCt14Y7pp2+K/nQ0fDLsjm/siuXEJkxukY3bcXOyJgDsRorI54hQ==

On 2/24/25 06:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Feb 2025 14:25:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

