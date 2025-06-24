Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C312525228F
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 08:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750753377; cv=none; b=YahjlkAjlNebEKuwmsvgH8S9vi9BSgyLRCddDOffv30RyhDuvbrokilieFbmoC6dihlwQ7ySYcM/B+g9nSID4thKXxO6gzAm6/t2mY1az+MvSq831Wc/aUvsFvzobKFmVb/nxGbXpJ6r8YsaccrnnuOCgKih2SMFU1uCY8uW7yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750753377; c=relaxed/simple;
	bh=gsGfpqXNBOFQjO7aQm6wp9ReQC8lFVfAO7bBesxeXo8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=us7ijwkEoaPDuHt2IA0dKSB662Qilc0IkJ1WZa+Fr1QPod2+LTuggd3VBjulHA38/QjY3+QwT6a0IEzyO1nmGSv+Tbi8Q/vKNjdArli1cSM8f72kWpyMv+Dk3ZUTGx8y0AruOTdxtGJ8H7gS5wDPJAV/EAAYELa3ZgZnczsslmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=dkthkFLE; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="dkthkFLE"
Received: from eig-obgw-6008a.ext.cloudfilter.net ([10.0.30.227])
	by cmsmtp with ESMTPS
	id TZUzuuKRhXshwTyu6uVpdq; Tue, 24 Jun 2025 08:21:18 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Tyu5uVNN3nvPiTyu6ugY5g; Tue, 24 Jun 2025 08:21:18 +0000
X-Authority-Analysis: v=2.4 cv=YISZywGx c=1 sm=1 tr=0 ts=685a5ffe
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DpAgQTyGaMxhVpyjbg8VpXO/7DZXxVpMMzkTGRiXc+4=; b=dkthkFLERmt5ivr1emUcHhGzE6
	PM86WmXLAnIpdi4WAQigSrK9QkAXVjJbTGaGu4ifsh4PC30j/2YQ43kLoJIrXTRuawYleMA661B4Q
	os1yEAHJFZ72dYsQP6PvhIczhC+x7ADZG4FVrFSSUqORcYGSbAkhSEqjGP/AImZVFyl5/jjjTxlKl
	Kw7DiO8g1caXCiT1+1mO/vpY6NkhYZju9x9XlRdMliWXsUaQsldwoTZG4RpSRbQuAiQfuKIGgyxgc
	Tm7toRvWAgwt/RhyKozP7yQtxykaPNsA8ab9Q3C8fuydtYvPuXgOQjIfqYP4U0eQ8sqUjBRFUmw5Q
	GYiko1dA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:57792 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uTyu3-00000002J7x-0GE5;
	Tue, 24 Jun 2025 02:21:15 -0600
Message-ID: <0cb49e01-0901-4ceb-b352-71230982bb8f@w6rz.net>
Date: Tue, 24 Jun 2025 01:21:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/290] 6.6.95-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250623130626.910356556@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
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
X-Exim-ID: 1uTyu3-00000002J7x-0GE5
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:57792
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCAe69uGun/L+M9yrV6Ap8id6EnI1koBRrKDV+NNdvyFTny6m4yNNhSttbS4mpr4MqR+7w+wNLLO5Zy5uJnLS5+HP/K/h2OPKC7VDR445qXt5T0GL4Ox
 b5m0VnrHAOy8vNEW9PmXlJ64qDlll8DhMo3oO6NW7p0e8vKXhFGNgXOdqEchsbuR9cTniD24Yx4J/A==

On 6/23/25 06:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 290 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jun 2025 13:05:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.95-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

