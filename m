Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 623B124469B
	for <patches@lists.linux.dev>; Tue, 13 May 2025 09:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747129854; cv=none; b=uNhPNM+PEdpRS5Yxi/RNzH3Mi8ZSqOQiDr3iC3wmOWo7881+oeIPB7tYAMP8dJ1STaalU/8NzNidJlssq0GWiq7THeZuDm11vYyb5Qhtvce4wSt7k63gM4l5Bks4l11nrpvqKhpyPVwNuRfGyVoWsAG0YW4zUFBitfZ9JEfhdK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747129854; c=relaxed/simple;
	bh=xhz5BzF3Pu3H9WbN4J0UYcTsgR51XWVznDUx32kPP98=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KPk2v3MGTvsTLllbB6iinOSRTQRayevfiN/EyDuHuEqCDSzdYZvnXzu3g+pp+JH0fkrF2cZW2CmJFsysxtJQykwBiCvIetsxvUmHblBR5mbEH1Gm//Cf9WIqScbeNIunBTuo7xplMCXFZWdVJ27bKr62FENGqxXLqACBpEZ0iPY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=2/p3OhWt; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="2/p3OhWt"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id EkIpu9jZlf1UXEmHeuOv46; Tue, 13 May 2025 09:50:46 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id EmHdu1usTRrTvEmHduGyG5; Tue, 13 May 2025 09:50:45 +0000
X-Authority-Analysis: v=2.4 cv=P708hDAu c=1 sm=1 tr=0 ts=682315f5
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2sK+jMQgNSt/N+/Hq6dPCdUDGhjbYwgu+z26tNnWh3A=; b=2/p3OhWtQlNIphwRRYB8Zbb/iS
	Wmnymp//C/dhnE4v07ofrpZ1CSZz4cZ5JawlUD6cXCsdnIOVN1DzCewFMcws6peI9/1uYTgg+XmGY
	hLwCrvGaXSD3Ztxbsvm9mvwaoXZIn7m7vmNqE5QuA8tTeIghwTAzuAepDk5QfHA46p9kJNhADu5a3
	mtolnQel/PLIvm+/6vtaBOkuK54EDksuTGZqGbTmDxdVZUcTXidbzUbZyA5i6Oo96z03P9IeeK5r2
	x5PQ2x78bIeUH6b/HaiETa85TGSdoq5/GCz/TP9pGwa2I/xFROzU0jKZZqlSSExV7WPiNstvS4j9W
	yUMKl8+Q==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:60484 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uEmHc-00000003JaK-1iVE;
	Tue, 13 May 2025 03:50:44 -0600
Message-ID: <ff0fb2be-a3f3-45d7-8370-b9925c688659@w6rz.net>
Date: Tue, 13 May 2025 02:50:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172041.624042835@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
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
X-Exim-ID: 1uEmHc-00000003JaK-1iVE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:60484
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfK/CwDNB4catGyRLX1I3rRpmpjc1pnOH7fykShhiqot8LGbij9cXtZ/CxEXAPfwA/xvaEbp/KQkCbHizV9uMTdFPONzFrJyodZPFxR25q8eRDDWR1Rh0
 B69wnqZ7kSHyU1ttA9QQfqIHO7pU7L/kQ7i24680TX9tLCG6IbPFY8do3BH6aPSrsrxZkG7ipG1Kag==

On 5/12/25 10:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.29-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

