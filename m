Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 040EF37F729
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 08:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774339934; cv=none; b=f1l1/XWX+B5aIsxxsmTprPJet56Cxc0xwIRbITm7/VJjy0fb04tBTdBGwsbgn7voOhRS39Sjqr+1Qhx9Fr2YYVMtUE1jYU8NUhQBf5s+oMiRkuunHf7wdU+NO+ceu6NvYO87bSc49Hwf4wDfRyADJ+CQsLVKFJdsjv6EJSFB40k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774339934; c=relaxed/simple;
	bh=v79BJySb/oOrt5+M2Q/sXgzIQ6lfE6cfuL+cHihsT1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DnYsN6DsCVUtwBwPUnkct1YnL48qLTFLXwxESRAT9/3kDjrdEzoKDDh5qpMQt4p1jGOE1AdPp+h01OvsegIxVEPmPSWi5vjdSsxC5j4lCmIf4/w/RAulDRqliDGMZT+cR8I86DFSbYGthL8HK7Y7wFjVkGPqNvJ+MYMh7RNZ47s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Gfy8XjnH; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Gfy8XjnH"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id 4hhGwv7HFJ9SZ4wrnwRboD; Tue, 24 Mar 2026 08:11:59 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 4wrmweUFkOs9R4wrnwUmRD; Tue, 24 Mar 2026 08:11:59 +0000
X-Authority-Analysis: v=2.4 cv=HPPDFptv c=1 sm=1 tr=0 ts=69c2474f
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
	bh=TjZUGD0nmoxUc5CrKI3btfThLWBLvasDikyS/EcQh44=; b=Gfy8XjnH/djz70WMI+4QPAq/4g
	A74xGqLy8kYNB1C9WN24ES1h/8kT7VbEeJP02G0MKyXt/efKpYZz+I0RzSiJU3eCe0UgDT8yRXSl4
	p9P5Q6ffToU9qhXo61iISRge3VF3yXXIJfsCuGCRuDA0g4Cu5ovpOXYJhT6ItA2ZWlNTFbHGF9WPj
	18xdTtw1ZgELT6MNQHF46/PBPlD92OdMFokc+kaFWhLaLx6v2sGhQonxAeMm7FT4bV7ZOgeACc9bp
	PBd+Pzao/4DmGpJWVN2A3+Ul660xAbjSGq3BrHFNtghI+5iqBh45Kg8r1lw1fOaAoQYN2f3hu1P8g
	fNDdGHCQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:59810 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w4wrm-000000018EY-0pNZ;
	Tue, 24 Mar 2026 02:11:58 -0600
Message-ID: <cd69cabe-3863-4312-bcc8-8d9add27d0d9@w6rz.net>
Date: Tue, 24 Mar 2026 01:11:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134504.575022936@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
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
X-Exim-ID: 1w4wrm-000000018EY-0pNZ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:59810
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNVlaFXG5pbxQ9bO/5MDlnpeMi/mPo63LTchw7jADOt48ZhxCUAc2DujdBMzjItfXNIA5Ewwv+gKv5+0Xu/VHfe0WRu23T9dM069gFP5nirzgPykdiRj
 msuat3NodjAvTQfJfbJEuM4T/kSUdW5ciLZAX/abNhrmHUTSymgYPch1RAPAYFTPOJyIfAYw4zSmlA==

On 3/23/26 06:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

