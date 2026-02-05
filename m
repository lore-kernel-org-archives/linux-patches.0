Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0254831B836
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 07:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770277597; cv=none; b=ksf1iL774XtHOaOlRLLReazqr2mYbTi4H1ZNTXuFd3pawxaXcQN0UzFUa//ZQXC9ocjGAYIPE2W7dTOmFbEBXDLjNikiUfxNzFlE4ZXbl61MVzmPjY9qoQcDmYmgpODPNGsftXK6zDFi+Cz/vL596QF6J3uoGQGs4bsu/qoJCkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770277597; c=relaxed/simple;
	bh=ZTPQFhC+EwKrScEYiI6jMjwqoLkd1bzkZTvsk9XuqOg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=atEVLh7lyQlo1dRYAJdkePL4YsKEX6Hg0VyEVnivSiEUUvg3PFwzEmwAui2/OYtnjG+CQpaMuJYyvucH6m1kSHDIhGIGmj6AoxpNNO4GXsVTV1Ak8SZx82Ks3iMZ/40Aek7DbUFx78lCZ54TKkzXlsniXKdu5X2ZTXXU+7f8nQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=DV1Wd93J; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="DV1Wd93J"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id nqXcvSJmaCxrGnu4SvXWDl; Thu, 05 Feb 2026 07:46:36 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id nu4RvZoNAV6WMnu4Sv8B17; Thu, 05 Feb 2026 07:46:36 +0000
X-Authority-Analysis: v=2.4 cv=E//Npbdl c=1 sm=1 tr=0 ts=69844adc
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
	bh=a87caE9UFfYee4lj29ruoHWDxGwkHqt1ueDfadiLoDw=; b=DV1Wd93JBZ3s2Qqylkq+5u58Yn
	pYAwJodEfSOyuPDEOARcUgmkNJfmZe4CazGziphr8ogu/fID1mTe2nzJKGSYz+ejBOlR+s9DAfKCP
	eWxNekDVC/x0BDzlVGF5gRnxeaO4zqypOCZxSzBADLmVmKRScbJy/Gjr4x6+JGC6eexUHuY+CT+A/
	FKNFPuGHpzksg/BRxvkaMnJ02J4QT7phDIj1Txmf7WStgCebUwdfDmOkRAbDYL99NEUdy/fpPRGWQ
	ImIHD4yyksyMe6yyzqYqDpnxjrZHe6BAWgTAO2bUKPymF0YOkL1oK5FO8R/ndYrSkb3+gJS0iazPM
	yBeRxp4g==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:52358 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vnu4R-00000004KJp-1bOl;
	Thu, 05 Feb 2026 00:46:35 -0700
Message-ID: <8314bf65-b51f-4490-9588-1435febad7ec@w6rz.net>
Date: Wed, 4 Feb 2026 23:46:33 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/72] 6.6.123-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260204143845.603454952@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260204143845.603454952@linuxfoundation.org>
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
X-Exim-ID: 1vnu4R-00000004KJp-1bOl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:52358
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMU7eQGCshPnN+YYh99fy5oXxW8vrPGr25j2lxwkaP8ZtYo2mAenRtAZISEWzakS1AxhJtcerqLB5N6gohjWGNAgIJyVOAVTTfQZ+CNHRoHI1tm1q1Tr
 yUpJS8jd0cj438+cBzKGM0E8V7l9I/4ZFhMuke/Z+z6wKHcnoPDOpsvw/I6OWgZ+qDrFZIKoo6w8rw==

On 2/4/26 06:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.123 release.
> There are 72 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

