Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4DA02F3C35
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 11:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752664473; cv=none; b=VNq69gZyOv0cHQRRBIAtIUGB9Ibyy1P2mSu1dY4+nzh1MHjoMy5BwnyhpDnRueBvwVRwvzdCAlmXIkDa+1NMXh9Eo9nEkBQ8FBEy7LSfyphFMW04ryQUZnx3ZJ3NBu/ENPL3mTcZD2tbUvVhVwf9jq/chgK2hkNVIKxyVOB68go=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752664473; c=relaxed/simple;
	bh=+kWRZdHA5sveSqTRHT7T+wiUa880suE/NcbD2Dsy5A8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aJOy68qXtNdIMn73JShy9vt+C+RTjU+GqmDZLkdk3/I2TjW3u9lbom7I24y29eN+E4bMnIzkMiCK4B4zUtj6FUaiyuMlhZr7j/R3fHOHDWuInjva/xzFuF/dSjG7vdphScB5clZnaBAqr4SacoZaFSU59TBgm4m4zjHHbyiE07U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=2N7YFRME; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="2N7YFRME"
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
	by cmsmtp with ESMTPS
	id bkUfuvL75VkcRc05huFV1D; Wed, 16 Jul 2025 11:14:25 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id c05huwjC3s7Glc05hu6Xx7; Wed, 16 Jul 2025 11:14:25 +0000
X-Authority-Analysis: v=2.4 cv=QehgvNbv c=1 sm=1 tr=0 ts=68778991
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Fyo-qtgZ5HMtR4iIztsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Skt+g1XkyWKSJri4D/2V18Sv2BLs34XHvPDFqMQPu5Q=; b=2N7YFRMEWTjDEKxmUlZMTYpZKs
	lcMdo7no0FRTaXF5bH7zoV0nXuRYfA1E309VMLGjc2XxotTqBP4w2fpJofB2NSTyJ4uHvsPO6k1Rd
	00hXJb/bymCT6FibiZPWgKhAPmxAubv3/Z5GMohgMrJSfIAYEGpG8hJhY1gDVJ/j4RckLlA01vj+K
	6/B/S+9kvjOrMFAPbyf3qnxMORoHXP8a7fgwdpIggly/8Am7WkGtM784rMdEf0vrYLAebixpiEWVF
	b/XqvQzKFkPzjIGi/pW8mKa0Bcj6ltLkt5ko8gDpgAXzcH8GLz8WnJhZXp8NTok9L3zmivo02wBVr
	VCLqG3tQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:43336 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uc05g-00000002aaj-09oN;
	Wed, 16 Jul 2025 05:14:24 -0600
Message-ID: <adc7c120-b80f-4317-8f0b-216e27f6c36d@w6rz.net>
Date: Wed, 16 Jul 2025 04:14:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/89] 6.1.146-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250715163541.635746149@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250715163541.635746149@linuxfoundation.org>
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
X-Exim-ID: 1uc05g-00000002aaj-09oN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:43336
X-Source-Auth: re@w6rz.net
X-Email-Count: 40
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCQZz9FIKnsOnmQ8iQyQH2sCjQW6OfTdX2aQJRJ4BfTa94wUkir+1azx1LxR/0gtXY8JTm57vx6QMOFKKBnrFiznH6gqIEq8FVlqIskP6qbkm8Jx+lyD
 cY19LpNfZpIvsrSVfxfproh6CohEjtZg74Nu3PHTHrVvGCGWHuV+Hbr/0hDPm35l486vTE3g/AvbZA==

On 7/15/25 09:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.146 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 16:35:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.146-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

