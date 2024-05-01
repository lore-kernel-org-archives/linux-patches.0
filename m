Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE4A1DFDE
	for <patches@lists.linux.dev>; Wed,  1 May 2024 08:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714553556; cv=none; b=a/D0SLz43ydiSGcnPGXCj0Ku+LkqEkklOfC2ji3FvMA2jC1Vu4gjnUoKNoQEHZcAFdbuovN00Np2o9eDCWUw0Ftpu1U+haGpgRHYETh+f8kHCBNm4Ok64WhSKb8GkGBe7NTaamzuZcC7/+06fIY1XEWOzMQ6wJKugnpovsJ2Px8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714553556; c=relaxed/simple;
	bh=xSONRq9g4OYTjTuc+2eLAuM62cuxPT/3F7dDxiTdNRQ=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=sMWgyciHmmeHYOfjcJ2i5KLOfkW5Mc4o2X0jzK6N1bHJFwVSjBtaJCnyLot2pCzmQO5aFUQWTmjBCnOdg/wr7l/FfMj87g7nNExjg19/K6lADn/C4HgHJNLpct/rUxXI1KdaaIDkS7q3Q4UJF5HlkNbwq+w6jIImR/wIY3UaKxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=dYpHlC9h; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="dYpHlC9h"
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTPS
	id 1TK6sWkLoFfFD25hZstkjY; Wed, 01 May 2024 08:52:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 25hYs8GM4q9rZ25hZseKrW; Wed, 01 May 2024 08:52:33 +0000
X-Authority-Analysis: v=2.4 cv=b6q04MGx c=1 sm=1 tr=0 ts=663202d1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=TpHVaj0NuXgA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=w3vtCogE_fj71Z-Hq2MA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0M2snCI0GzxfG0V4nHydpheudf+iRzZ3VlHJ6RoVps4=; b=dYpHlC9hr3VV3nGg4s6+LQyPY6
	fSvXoF4y02dffTw7/lyUS4CAeS8nFQgn+KV++YlXtzYAmm0M+3erWRtpZsJJxaLBDibe0P/M8GHCh
	zyovCCzzS6h0VM+T0YUPXQ7E8YsFe+aK9JS2Bwy/xib3R/dd98mYd9CE9mQo2+q+BZcBtT++4s2so
	a+TLmF0ocnDdgGEoH/X10/Yg9oUYe+cYkvU7KADSYBQ0UPYct+fIfzknTooFZBmsJ7ST7RSTZQhkx
	z86TZHbAH25EfAEnITKBnYQVhxoaqY84rpBvXzAbC6KC2RgUtEs3NgWBsH8wj6FCTs/4d/SnAwXrb
	OE3+x7fA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:60606 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1s25hW-00191I-0R;
	Wed, 01 May 2024 02:52:30 -0600
Subject: Re: [PATCH 5.15 00/80] 5.15.158-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240430103043.397234724@linuxfoundation.org>
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <d3b04bca-c22d-7929-403a-d1b12f5dd688@w6rz.net>
Date: Wed, 1 May 2024 01:52:26 -0700
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
X-Exim-ID: 1s25hW-00191I-0R
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:60606
X-Source-Auth: re@w6rz.net
X-Email-Count: 60
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCCHLAmKj8NE5ssHt9NLYaGgTa9e/kGVcocVi0/KY2Lmln31bX5MhPEHng8YWRYPoYBou/QYiG/tk5z+nSAB+1icPbB4r/+/dhlz0GfFRQxU5ydy/8Ts
 oBdVlmaS3Hvb1vXI32fM1/pmWvlETvJOBQVLC+oCCrYjcm815vfViWa1M195a+JLLQesmwp//Kbnbw==

On 4/30/24 3:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.158 release.
> There are 80 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.158-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

