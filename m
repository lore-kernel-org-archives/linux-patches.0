Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 743BE17C6D
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 05:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712034076; cv=none; b=LO6270ZftcEcsmp9ybO9Kp1Z6tRCXEjQsOyjq682uDPqO1wP1Vo10uWtyYCT5eTsqAsV5zb4DH8JEkBETQnRCBJMwb38iwGXdXt/96kHNltt316cYnurmG/TtsrbAgx8pRwQ6l21qO8f4XcljEA70aVLfEUO8d2f2A0ZZ/rdo8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712034076; c=relaxed/simple;
	bh=vxMfyryBymNd51hdP9pp3Co4EevWHdFF4z4pYAFAPU4=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=UFZckxNCcEd2c5y2b4jyS+7kS9/RuiHlhT2Gpt/nSzWcK3h0evFS/XH6pmllwwJVLGmB3B+PwMpUJuDrOjH46rtMLQg84Xfhf3The64EaMxsIHbZeSuKgx6hsNMekHvotQdIOq6QzUXnH+nteySojpaiHBe1ZPE19E9/Z2Mffp8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=lwmvRiPr; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="lwmvRiPr"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id rJuerMA98DI6frWGirzNHI; Tue, 02 Apr 2024 05:01:08 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id rWGhrufz8d4oerWGhrf8sy; Tue, 02 Apr 2024 05:01:07 +0000
X-Authority-Analysis: v=2.4 cv=aYKqngot c=1 sm=1 tr=0 ts=660b9113
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=raytVjVEu-sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5oy+DDncNRRfUO3SI1ew6LFJx9MNBFIdpIU5chQzpbU=; b=lwmvRiPrOgg0KyQh1uYZOnyjlT
	KOFhEhHWi15KgOPIU5CZzlNY3T/KLZVPio23IJSmnxtsS68yacUS5Okz8NjmBKAltIBgSC46d8jsw
	Km9ZEACpNmufI/a+N3w4GeVNRzyenpBDgUAOgf9YOu8567cJ7c765PBD7tnXQNCNZNPffd3f1L/Zp
	1V0zoYsbS7McraPaAthuPjgTpFBabcuZkvUHdbLc7iF0TqB0YYVBgdczJWIhMsgYSrQiZBiLU6XVS
	0i7Nbg/xQXHnhqXIoFz4oF/PNGxLkY/9r48I8LudymixthHAwgTpe1fvEJSc2FQU1gKmu5sAs3Q94
	wO9H3Fkw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:55178 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rrWGe-001nmT-2T;
	Mon, 01 Apr 2024 23:01:04 -0600
Subject: Re: [PATCH 6.8 000/399] 6.8.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240401152549.131030308@linuxfoundation.org>
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <5400491d-e467-8a12-d7fb-6581efe86e1b@w6rz.net>
Date: Mon, 1 Apr 2024 22:01:02 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1rrWGe-001nmT-2T
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:55178
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNKXMKfZvmSr0NEtLh2ouZQgR5/Cnk1BeQKHblYG7Ebx4faFjj0jp5FdmZXmsrcx2HMN5byj7PKqJ3D4sFaZ5kBuLwaECXyW7MtbKwsTpqzljZK2Rjux
 kMviecwe5OgSoms7Yt8r+Adre/BwXIlVincVgtT2LT6KXf86liYVGE/711tgio1AiKbw2kCWmRb19w==

On 4/1/24 8:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.3 release.
> There are 399 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

