Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCF736B913
	for <patches@lists.linux.dev>; Mon, 19 Oct 2026 06:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792392409; cv=none; b=t1dBFabhRMVHRnmvf8X3suKzGoVeLCsjBRWaWqLtaQIwPrx6bol+a3swTyjN+qs542RtgcTGF9OO0X91+e0FCIhgyxxtuU7riw+DjyzmdBfSbUB4yrcHJJrexTI3dV6I1CdfC+6cfZl3G8z/8PvQekKma9stAGYHt42wXz5nEBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792392409; c=relaxed/simple;
	bh=0C9SP0ohFyGNCKHoZw2SamqT2VYHYNFT9u4Va9p0crw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uMnwNOeEb92L6FTL3txShyZHVWJYeTWzaXI58cvje/XAsbY+rYGOkEXCEiHEiYvdO7R0zGBZwFCkoWODqqMPTms0TYYLoMw/FK5R+54neEVfTNKLNhqrdpQM0t49tmWX0JDgTh0mE2WUKaV/It0e8EFLgpuf5ji4qCmOUUq8SQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=KTYMWcxc; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="KTYMWcxc"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id I9dTxabUPc3XsIh8xxWY9J; Mon, 19 Oct 2026 06:46:47 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Ih8wxkHaZirxPIh8xxZLsK; Mon, 19 Oct 2026 06:46:47 +0000
X-Authority-Analysis: v=2.4 cv=FqoF/3rq c=1 sm=1 tr=0 ts=6ad5bcd7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=nLW_NVcbZVm1FM1xQrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=MHrB1VjfpG99ZXJaNS3tWtZEFLZKQti4Mmv086kFvok=; b=KTYMWcxcns8o3IGGool+KDe8RX
	qSr0aK/5hmdABmRtfLY5L7i6OQnI6M6Xx6WBjFN5jKUpnQJRQY4Qhf2MkbMPlv9l7aXAicggvH116
	giYKQ+kcdbginyJtQexVn9MyxOa8E+LjC8rpaMa98Km7VZ0aaEwVG8lNRlyIpXbX2zZImYgPPtTay
	o3b+ciUtvVY3Me9NrL8kJ9HyQVnNBHlF+26sjWnmh96+CiSAKM8NYDcXBjHlsDn4Hga5HNcQZ6kE/
	LXnkheYn78LUACvqeWzGbCKlMZBZUV8KTRF7svtFzOeRvmeFuJGGa7ZneWI/e0QGdyYf07z4ZZQTv
	QXdsaiVw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37446 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100.1)
	(envelope-from <re@w6rz.net>)
	id 1xIh8v-000000036E1-49G0;
	Mon, 19 Oct 2026 00:46:46 -0600
Message-ID: <d004d2cc-54a5-4013-bc6b-a5fd44da95b3@w6rz.net>
Date: Sun, 18 Oct 2026 23:46:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 0000/1674] 6.6.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261017160431.119607952@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
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
X-Exim-ID: 1xIh8v-000000036E1-49G0
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37446
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfC4uGMwKxnnOcgqmvfojH7kqRl1dKjKrRfhcMRUF8zoHxYjx4URNlscUkqx32V6IyMuYnkA6/RyO3VjxKGRdLaHkF71MYD4m0JpCI1erWMXC7d/3ZabB
 tGG5hp07lG78g0XhnOK+ZuuKDDhBjkggpHClLqKryqB5uJprxR5OJYp9gGEjPGLyxTzwhQ/QIFkPOA==

On 10/17/26 08:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1674 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 19 Oct 2026 16:02:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.160-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

