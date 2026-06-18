Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 242F62DEA6B
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781769939; cv=none; b=TrW2bfyRYrgpNfKDkwNL61PipT6qdRCuRDN7T4yLstKGyl5rnT4HF21f17G2hJk/hnOR3QW2I8k3KnML2D4kHY4NHk/QHAAR9Pu9YPnUh8vmzh9JIyFUJiFlsmuoBTtyXSeZK3xDkHswX9A1UTb1EK3kvn00/r7Xoj+r/B7XNys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781769939; c=relaxed/simple;
	bh=TvFE4tGHf2RZ6ILic0wX5yx04G98MgXtRv2R8lhd14Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ikVdu/cV5PCyFvAZ/XRIgRzawx4E6fCak/oajAH7AR7+pE4vVvEl4aWbwTfEFjufwAsjLaNgm7VI3ikpvR1ptFA2Fqr9RHs0wi2tgTniFr+6L7MvV+8ssJdJn+EopW1qNpqS3xjQ8DlhbxHPo8Iv7tI0N9h7euPNeSt8IThVGYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=0XbmN58u; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="0XbmN58u"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id a794wAZAoKSRRa7knw4Kyb; Thu, 18 Jun 2026 08:05:37 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id a7hkwZH8V5zk0a7i0wmQ4c; Thu, 18 Jun 2026 08:02:55 +0000
X-Authority-Analysis: v=2.4 cv=GPEIEvNK c=1 sm=1 tr=0 ts=6a33a634
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=9GQXaQUDpQhx98mIA28A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xMNwgo/lkKMJCS8Mt489WM0G0veblTtY9Wz5haT6LLs=; b=0XbmN58uYyG/+k888i8TudVon0
	9QrGzOlskpKLF3pd8kOZ8KJKMbAGVqp1CJXt/IbQdwowhLgrZRB14dAek4aBssS4XV1oE47/iOl6z
	u1URdIScXHGmbUU/8z2FCc8stuZe7NKKQQakRIo+RzZBbNfbYRlquDpuTUqyC4SwRWZn+MU/fPFd+
	uW0bE/xZTkjGvIqslirVESVphUXQhXeYiS9hftLxm/18E7iaLCNDHhrS7yVk02b6KRae2UBUzLXG4
	WnDSbwkqBZTCBnV5kjgre6ECeJ0U4hbbaEQ3clKrijjjhy8Nm5FG7yD2xhikLT1Flnh41D3P1yF04
	RQ1R1h2w==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:46348 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wa7hk-00000002PRd-1QTl;
	Thu, 18 Jun 2026 02:02:28 -0600
Message-ID: <afe43ba2-1fd4-4a77-a589-5a4886615dda@w6rz.net>
Date: Thu, 18 Jun 2026 01:02:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/325] 6.18.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145057.827196531@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
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
X-Exim-ID: 1wa7hk-00000002PRd-1QTl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:46348
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCSqhLzj/VbZwZvi8lZAqa99ypDFO5S3vlwtQiVhSrsfKfhzFLhXk4GLfgyCmPubOTl3JUQxntQdegu+lLrNi1GUdaD9HmdGn3vWxHuecWSXSVuHJ3Kc
 dhPm0pMk6xcNkMIGBj8IHmLNqVs+tgooxvmjKc0tmz++3ZKuUmQ8fB4uxw4BabubMOq4YUIOT+bYew==

On 6/16/26 07:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.36 release.
> There are 325 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

