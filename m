Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE64813D255
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 08:59:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721984389; cv=none; b=MAE8tvfVQ0ePkuqhyUZxan0N/xq0RmVY3Rd33LtYbGfnIgaSvGES2Ebh6SFJuGXmFOV6VnqNypoApmq3yXh+tQzvB4grGdVuhcUqmQKWYqZ1IRwjHUThtd/13ogspEUUDt7+CXIEa4/ZzrCVwGzN+yesIKJtn3H+OZlFEe3e+9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721984389; c=relaxed/simple;
	bh=OvDZzrWii8BqOJzep1QZbE/B7yd0X88IeZ+QKHYPDwU=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=KkjvTKyA1Y3nwnnbWl2nkkMJH2aXhubx1tLQ/YjioOCGzHyaPtyQVR6i1VeIxEQ0kolF2gYJkSLSmjL0nDuBcwZK86/z2/QCH8BS9Qev6t5ODmN88bfJfd/b2kofPvl8Duc1X55F7YaJSIJet5PbtN0Xb98QkxdqrS0DTap+G50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=DGKXPuWl; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="DGKXPuWl"
Received: from eig-obgw-5009a.ext.cloudfilter.net ([10.0.29.176])
	by cmsmtp with ESMTPS
	id XFlvsci7tiA19XGnisIJ66; Fri, 26 Jul 2024 08:59:46 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id XGnhsaj8NWW9nXGnis8Gq3; Fri, 26 Jul 2024 08:59:46 +0000
X-Authority-Analysis: v=2.4 cv=U6yUD/ru c=1 sm=1 tr=0 ts=66a36582
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=hP_FQLMrEgTDVdh0MfgA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=58LeIBzsaBlakXQzzdgAQcWkxAPcI5DfFUItk0TWIg4=; b=DGKXPuWl38/tHKN8N7ZPbmyTwB
	W0LeOiTkCbST5CqAX8feMrR0NdrF4D1Fx0O5/qndv9brIDOVoRT2c4OLjxv/Ky/s+TQ7myXL66ScZ
	JlC0v6O/ELxsK2rRArB64ul6J6jXUChyki869oF9Cve1ThNpgr2bLQFGhqHddZYIPkQiQt0S1jHtB
	AVbclb8SX4NuvLeIvU9KdCB79v+HOh7c3jJrDRJLTMzhK1a3nrsNJgC7iGMtO7jXck8DdRoRVSAsM
	WcCfl1XE1woRI9lEzjZJysfrFbG8VB0FIi56A2ZjKi/fVcN98tqT78b0XzRK6mYtmgRQyZIZNE8LI
	x2XdK4EQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59276 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sXGnd-004FL1-0Y;
	Fri, 26 Jul 2024 02:59:41 -0600
Subject: Re: [PATCH 6.6 00/16] 6.6.43-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240725142728.905379352@linuxfoundation.org>
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <76c0854b-5b0e-cd93-994b-081ccc4bdfe5@w6rz.net>
Date: Fri, 26 Jul 2024 01:59:35 -0700
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
X-Exim-ID: 1sXGnd-004FL1-0Y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:59276
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJJFpT183L5XawIrWTzfhwpLNNtNveKbsdV4wKxJQ4C1sgL8eliHYppmg2up7V5euqxoZoZsXGRrsLrQXaLaToES2KBOrZpdeeTbZC4gPBPn+akNhiUB
 +R5ceaF3z1tK1DlEYQ026jQJmJ+b3tU8cu5nVCoWV+ksRNUwDEVF3QzHaeCDYxO1QZuGuu9nRvG5Ag==

On 7/25/24 7:37 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.43 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.43-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

