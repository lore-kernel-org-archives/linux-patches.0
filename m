Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8DAA12E1D9
	for <patches@lists.linux.dev>; Thu,  1 Aug 2024 08:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722499512; cv=none; b=DF6es2PwwJhdtvjCqXmksXoy1jDFrDX2+b1TlyFrBNcglLSqO6UWgFYp+I9BKyp5KLqhZpezw0VU9di1HZyaMomDIZFm44IbWJmhjCkLxV2EATCgbSuF9zru+9yopWiRSl2oUbWfXnnC0V4e8iYbk/g8eng47DApZE6g7oXs1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722499512; c=relaxed/simple;
	bh=7zfcPWvAnMZtQ0hKzCtL3oX3MOgy/pixFvoxh7mLZo4=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=CLF/vtOWBiG7zJqEnGKRMk1U0sGr1b3jKO9TJIR5QeMTwoTTdkV6TuTJBM78mEc79WfQOadQEHj0cQ9ltaQt4ksc2wrTi1zFwW4EeQD8QviQfGU7wmVgDAyJCOCSuAnzN18LY1yzsTHsqBs0adCOZSr0JgCZQTa+1n1qwhlK/G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ZBkk28MY; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ZBkk28MY"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id ZJEgsDIiR1zuHZQo4sVTXm; Thu, 01 Aug 2024 08:05:04 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ZQo2sGZfJbFeFZQo3sY4sp; Thu, 01 Aug 2024 08:05:03 +0000
X-Authority-Analysis: v=2.4 cv=dJKgmvZb c=1 sm=1 tr=0 ts=66ab41af
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=o4oUe0vuTkceCX_PDYEA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=bIxp1EyNdg7hPOJ4wr2j1sNmxSWc3ZBlMiYwBiSO3jQ=; b=ZBkk28MYYfbfMuTURR6pmZVWCo
	4EQ1ew3zpxYpCbLj6cZGc3lB59zdiKwwOQ3h0Oa7ymY81Dq0saYXcjpS+W8z25hkiskV6DxLgRy//
	4vIn5L0ONtJYm7vjXH+mn9uGAfjtDy99KBU1H3QEsXKnMYk3Hp9oqOA+eJ3RQONeP9MGdADPlo1AJ
	g63okaZFT1g8W3krxV1+Jhstc52HAtF4rhINXxw7bw31GGBKqccnk2Q/V2PG0gHatRNso58reMf38
	HITWWguivPobSINrC7erAoWGCmDfzc15mjlLOx2MedLhmNF1/3icxrIMmPqXjzz/3hrEL0d/mfPBI
	GJmdS2VQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:60454 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sZQny-000Mhs-1I;
	Thu, 01 Aug 2024 02:04:58 -0600
Subject: Re: [PATCH 6.1 000/440] 6.1.103-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240731100057.990016666@linuxfoundation.org>
In-Reply-To: <20240731100057.990016666@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <6ee4cb6b-e4a0-3196-d651-d9a05f7f9dde@w6rz.net>
Date: Thu, 1 Aug 2024 01:04:51 -0700
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
X-Exim-ID: 1sZQny-000Mhs-1I
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:60454
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEDWO9YPh2xnvhhm1HRwCrBBjUtpWV9HsjoQecI4U/xmn48aa9MYbuBNoI1Hn+LhiMeKro1Y62FjzaIjNztrtnVfe0OCQleMsMBtjQK0kAQuXLRJ4s9N
 EyQPxD5YmH0g3O3X+cRldFFA+f1eXJVqPuFohb4iAahrnkzAv4FfGji8PrDXrI91Nn+/5sy+DoUphg==

On 7/31/24 3:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.103 release.
> There are 440 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 02 Aug 2024 09:59:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.103-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

