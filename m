Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DFA116C87B
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 07:57:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722499065; cv=none; b=mlWkCHLLrEvTcB8kxJ0sAdasDtr5leJ1k6OJWeehP4YjfOkVthZL0E/J8XqjKPrNTbw1jb7rkAZT4KaCgkROsJGHz9jzIi8OpowrnKm9AfRrOretBnIPBQRmBHAtBz3TTh80Ev7gORTwGIvsssFDWYIdKbJBQdNdlAI1qhWdyRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722499065; c=relaxed/simple;
	bh=7E9ZA2Dof+8oK5hEk0/I19LSZIO02MAJVi8TTwhomIs=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=gMA4+Y3MWHbtF2keGRfoQwmNzaO2uHcwdmGi09VOC6cOfyHvEqD/fg3mP+DZtWK2Jr1Xh6C0DqIp7uYoOyj5ABWE2tNGPn34Ixd8LTO/MSWFLu84qIFTRUZ9/+LLf0kAPPlB8Y53oF98hzRqhonCrTy5VTWnu50hON4mkHBdrvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=wkWcxefX; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="wkWcxefX"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id YrfUsHJ97jnP5ZQgrsd3Yt; Thu, 01 Aug 2024 07:57:37 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ZQgqskcFSIKFrZQgqsloP5; Thu, 01 Aug 2024 07:57:36 +0000
X-Authority-Analysis: v=2.4 cv=VcTxPkp9 c=1 sm=1 tr=0 ts=66ab3ff1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=Rfy8vk5LW4CTstU3NUIA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=cGnJeYAm1TgGAnA4H938EbdG0bTZ2YHwg5QDMkIFI4g=; b=wkWcxefXvjeXY6DAP0P26Q+h63
	nFRC2GUPftev/in0kxUPYWl/cv1dy2Fw60iAP9t9vApanVpXKh3hKs4uxQ26mezsaiMZSkvJmnVb5
	CeoDGMEpVKcFBSyaNNnFZovoMbuj+62uSD4Q8YdAHQpdlkvBdwGCSypJiQYzdHbC4u43c9O8TwJdD
	I02J6VPGmZSVjvLI4829y5pTe+dU+Up94wTlZfVvu7Se4Rw1iT1elGCwS3P4hSneDrYybgrjnFUBI
	YoAUHsbO7QRzC2aXfbU/NeZOrcm5uG2XkRm2rQe+f/U1ulsGeF2x7NB6C2cqiuBBs0fxFk3urLrb0
	UfRzoJ4A==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:60442 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sZQgm-000JId-0F;
	Thu, 01 Aug 2024 01:57:32 -0600
Subject: Re: [PATCH 6.6 000/568] 6.6.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240730151639.792277039@linuxfoundation.org>
In-Reply-To: <20240730151639.792277039@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <118d3d10-3d84-2fcc-4e67-f8750d755e6a@w6rz.net>
Date: Thu, 1 Aug 2024 00:57:26 -0700
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
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1sZQgm-000JId-0F
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:60442
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDVOUvXtG88sZMLYjaVT08DPl/E6kU96LC7nYQXfFP7K1x6ZYbctANVI3VQhzdZ+V1n6rLbmB5sqswgS3Yjid8y80dxe83W2u+QY2eMCC1fkkdOAVhSb
 zfg/0knUApaargPJDdrW2SUy7OA0bYPOkaxthmmD2sumzpKKkvtjfecbm7/HhnGAryJmpZYBWYRzTA==

On 7/30/24 8:41 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.44 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 Aug 2024 15:14:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.44-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

