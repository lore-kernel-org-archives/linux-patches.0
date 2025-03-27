Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5F42576
	for <patches@lists.linux.dev>; Thu, 27 Mar 2025 00:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743035310; cv=none; b=Gzcy/nKSnEq5a6GLdeLmfehO4svpFRrpy8889qe+behHN6AT+5aB19iDMw3TuqEyy+MgwTdCvjZyPQcreSof0bXttZacJdrcx1DSSZeWJDsBJRf9Fs5HM4FBZB+XR+HQ8Y1cjQevI9KV9lfZdvkv193Vy1McUHhqhSaWd4PCOKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743035310; c=relaxed/simple;
	bh=FEo9uNCOISvLzSWcfNhXKZwqkTDWiC51P+5nYFqDl/8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k5x5sb7J1wQaAWD3wJTLIs69Y5lCz5eeOE+XonfW/3O7PC/iP1UhEm0NqIWQnkwG7EYSmOVwykw8TCCWBDEc/8Adl7O2CKBFpbTcdPbfY73x3I/CbZm0UM71DdkLTdJ8lP7Kz7tPlj2DYvyIhEW9tYHsN4X9r5tIpGIJVQFkfBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=ga6AEzF0; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="ga6AEzF0"
Received: from eig-obgw-6001a.ext.cloudfilter.net ([10.0.30.140])
	by cmsmtp with ESMTPS
	id xYSltmYTtWuHKxb6ht5GPI; Thu, 27 Mar 2025 00:28:27 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xb6gttjiwgFaXxb6ht8LqH; Thu, 27 Mar 2025 00:28:27 +0000
X-Authority-Analysis: v=2.4 cv=DbzcqetW c=1 sm=1 tr=0 ts=67e49bab
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Vs1iUdzkB0EA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DsNoo6ZTJa67tcyd3ErtPwNez84rUD/blpngmSY8kjo=; b=ga6AEzF0d5vBSGez0CYHwg6+1Z
	pr7c/PC7Hr61rEexi/U4CqgAm6OEgak2Py8yNnwVoyKkmp3Y+xEHPxr8h2V9hQJo3wdkmRuQOsyad
	6wmyE7DrflfJc7LnrwJKu181zkr5buxpl99xv34jyKDzUy7Tfv1PUYHQhznbJFIembjWDouV9fVNP
	bTC1a71XQ9QNXq1XSD5MVZkiDQIlrzP5+V2DZTNTZYH9bHb14UY9NMRGnxP5CWhRQ5dIS9y7spC8p
	d3TVgN64DI7UD8QjO9zbBWGJY+3/7O2d20mAjnDg/OcoReYEhwtRj28r24YrgQe0pYGawsf33VJp2
	R6w7Ik/w==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:39466 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1txb6f-000000013mc-095p;
	Wed, 26 Mar 2025 18:28:25 -0600
Message-ID: <0ede30b8-68a0-4e8f-af42-c402e90399bf@w6rz.net>
Date: Wed, 26 Mar 2025 17:28:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/115] 6.12.21-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250326154546.724728617@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250326154546.724728617@linuxfoundation.org>
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
X-Exim-ID: 1txb6f-000000013mc-095p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:39466
X-Source-Auth: re@w6rz.net
X-Email-Count: 37
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGItlHh0/i7RKMnZkQIf919PtbLjv3eelXg0sGh8PrbXZ9DgVgjOJQZCWw8RCV5S9uzOjtpAv9ZrGefOKIQH89qvkZl4zwGZf6ZLm37K/9dFF1gl63jx
 5H2D23zI10V+uV587KhjD1yh25eDSTm6dY0fDKu5W4DOJuTZQbaLHtjxCII2AAw6v2nAF6KUYxaKBA==

On 3/26/25 08:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.21 release.
> There are 115 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 28 Mar 2025 15:45:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.21-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

