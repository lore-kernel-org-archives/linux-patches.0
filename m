Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CCC47A73
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 02:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731032589; cv=none; b=jW4Kd7pcfgrJCYA0pEpCEoiio+Im4hHXx0lFp888QM+c6bZusJIM2jm/xADtFR+7bR3EkEVFmJ4gxBVV5mP9cW+CO0vpQwdD8g3hS8qcJ1gSbMX8fa50xsHZCM+KO1sI4vaeZJRBCeKDn1dtmeztq4KWvH0U1XOlUjmkaqWyNH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731032589; c=relaxed/simple;
	bh=TlLG0E+Gk7Ud4oTUhU5ZNtTpISP7K6CVavS1Q3Jdaek=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=I7iA7LlGOT+dcGhlreb68RgibVB5wYtkGx1FIwhibUssdrKPh8vYINZiDmv17hVjX8xe1wF/3A//v0h/kUiKvHnlcuUGkqicX4G/1W82pCYGPrZO8GrBxn4n/OkfehczpHltTrT6RTiDPiKmRbe/lskxC7lkIBqZzXii0mYBrMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=cwADBkU5; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="cwADBkU5"
Received: from eig-obgw-6001a.ext.cloudfilter.net ([10.0.30.140])
	by cmsmtp with ESMTPS
	id 8YPqtD1xug2lz9EctthY7g; Fri, 08 Nov 2024 02:21:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 9EcstdtrB2Zy09EcstpFZf; Fri, 08 Nov 2024 02:21:30 +0000
X-Authority-Analysis: v=2.4 cv=Q4EZ4J2a c=1 sm=1 tr=0 ts=672d75aa
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VlfZXiiP6vEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=J9EI1liLPhN1/o0apZDZs7AMnukcex+KigNNu2Vnf9Y=; b=cwADBkU5LP4JXuH20/bSW/Zepl
	hsn3IGMWUSGKp928xtGZMNnw+nAPgwgIebREBZsSr1EGia9TkwK+tFLevkJ9cIuPX+lgebuXYJv6B
	Q490YfryqjFU2cqJH5skLCMTzGKMzsNSKWHJiUH6ZEBqXc0UCecDYHJCFeA4FNnF9ugHubntYXDWQ
	qK7b78wx3OCAM6ApGHvh3S/i/FAE7Rudss1P0GrKGK443G2CWD40fneJA9BBoe8mchmnk66APcVoP
	yFL82R5DDxHeUu8w1jt5TUUpV2zsDbFU0UC+3se5BKPwFMhUOSqdNuDcLDQ5kS5QgHWs8iQN2J5f/
	VoMOinIw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:35498 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1t9Ecq-001Uht-1Y;
	Thu, 07 Nov 2024 19:21:28 -0700
Subject: Re: [PATCH 6.1 000/126] 6.1.116-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, broonie@kernel.org
References: <20241106120306.038154857@linuxfoundation.org>
In-Reply-To: <20241106120306.038154857@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <353f828e-0ed4-44f0-7285-8320ee7396a6@w6rz.net>
Date: Thu, 7 Nov 2024 18:21:24 -0800
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
X-Exim-ID: 1t9Ecq-001Uht-1Y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:35498
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIGgHwdzyIToysA2KPTNASElUTM9z1dzYSatN8JMmQRzaASfACdEJ1DDlmIUHtapWfm5PRAm4dA3fpoicgwnJU5A900TwmdiNJCgcBHNiCW0wTas55f3
 sTRtBulRMANjdISkdK4tvVCRG59szufCf9z4ZtwlDPAQzAHVyvDseKPucF5mrbcp6wCBptp6N/FmjA==

On 11/6/24 4:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.116 release.
> There are 126 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 08 Nov 2024 12:02:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.116-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

