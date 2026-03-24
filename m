Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD4C37A48B
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 08:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774341150; cv=none; b=d7egKIGiWTm7zx6w2H6vEz1eRo95GRI9DGTPDQWeP8CuwjdhNy4keQRoz1xL5iRDh2z/CwPzIro5c9tfbyCm7qOm5SdnrPfNId3DjjP3xdcn20hJpeRj5L+t549Z/nDh0xzZM93A8O/nnwhjaGs8oQ3ulhGHLSZZRs2DgaTKA7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774341150; c=relaxed/simple;
	bh=BnfmGkehp6Y4hMIEDXdD+oeJtuAif0KNc8KNaJ2TYMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i9agiX29XYy2DAH3EkAQqj4C2+OcyNYuYGPXYI97UQtgk1U2sTATwq7cFVVuenapxZMwYetliA6tfdBy0FmItHBHUG41uD9o9okSWJsaEvVZP7GgfeN5v6LryvAAq+9d3U6DqLjcycpqDqRZcOeoww+8jOFpyqRmtY8FSfGO5JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ohYiun+G; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ohYiun+G"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id 4oFfwwmUOJ9SZ4xBWwRi7y; Tue, 24 Mar 2026 08:32:22 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 4xBUw8sHZN3K14xBVwhPBc; Tue, 24 Mar 2026 08:32:21 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=69c24c15
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IfgrbYl3VS+JQBQuu86U65m12dzod87HKqHwlByX7eE=; b=ohYiun+G5NPUtmjkDErx6DX1m1
	S6q2Cw3B6v6u/1wQN9T7QUcFDSFCstcFrraicZcIdl/yW67ffiULRsbk8VS97WvbOHDHVV520atJb
	TlyO2QaxsKUpV+wneURsK/jnNRbHneNWYY97wixqFCfdXi7R/r272L8DVp9JpTTKXU7/ZlqgaGoGG
	A7PbOOc1dDgo4Hi1MsqWNvh9sxMwZwTeLz87QsuVJmbQJ7rQbdo8ynNf2j9MigdYxJUb8HIiqapF+
	rmHNqLX9SPhkMKYyULnk7LN2ZmCxihnpXdk/hhFvcAD62w+nnYm3Fs6RYMT0BiemYlJUlwCVkz6+c
	UBZeLGZA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:58522 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w4xBU-00000001G3Q-0jgh;
	Tue, 24 Mar 2026 02:32:20 -0600
Message-ID: <194c9c90-daf0-41c2-8362-e726a5223830@w6rz.net>
Date: Tue, 24 Mar 2026 01:32:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/567] 6.6.130-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134533.749096647@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
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
X-Exim-ID: 1w4xBU-00000001G3Q-0jgh
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:58522
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCWzU2c04Uu7UMrtTNCyjabvgxNoRTVqUcBMSx+NkKZuyy9/qZIBbbi7CWw9+CZebhylUIhUHkR2tUHfDG60l95GWODyc+BjxB48WyrPEwCa1iTQba84
 8ejJa1ryNsrSoIXPWHeziJBRx4MhVWPhFtgjqp7+REYirbifBjoxs9dJNzhHUynZ5CpMqZijPyRnbA==

On 3/23/26 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.130 release.
> There are 567 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.130-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

