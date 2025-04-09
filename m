Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1C6B1E9906
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 06:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744181650; cv=none; b=G1s5hd8wepvGFMXlh2VPu5bQDGfIU276rBDWpxUSB1wm5s0eAI7ixX3D3JhOKXeX8MnRbgd6BU6Noho/QtwoQpUCItBrLwnfHaUj9WNevjO5PXzZHyLc4UM8BRTz2ySEIkKIlUtGspcb7XmpjjunFwQqsvWowjjsvZfWHK6Fykk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744181650; c=relaxed/simple;
	bh=QxH7+kfZFLAY/mCoHU6UiyvxMVtNvxZ8f21UE3uays4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DzGRKvKZdixWwLdqeLlCSTfyz+lArzB5GTb70kOBgichCGQfdRZ02XNsjo3W20etCmPopiH4PvDPLtHC3McBPBARqeRMlQK4Q3DZDcs0nnJERdNYNYfb1sAqALm8MEx/d6EJl1AUkOadGU8AZAjRcplkBmQUztSe1p44pwVytxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=0PBHCeMv; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="0PBHCeMv"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id 2NFQuJm3DzZPa2PK3u8aZv; Wed, 09 Apr 2025 06:54:07 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 2PK2udHpRrsgD2PK3uTyt8; Wed, 09 Apr 2025 06:54:07 +0000
X-Authority-Analysis: v=2.4 cv=TNGOSEla c=1 sm=1 tr=0 ts=67f6198f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ZxG2Mo1bweZcTQo1GVtvFkI4JIEh0Goa3Ucsj6YyNSw=; b=0PBHCeMv6O/RBN6/GF0+eWX2gb
	suGT2uLHrDI3YNKGHNojcmYhQFcbSUMx3YKktcBTt6oQWiATlxauB+1tE0gv9E+sw+c4ItnUP+Ji8
	klx2kLWdhQILV6hIKkmM5XoBhS1iE9gQ5SE9Q4XD4CXj45YeCAt+FyOdIW1FEYkfI1eaR8aKjoKe1
	KKPIBRBOZWAd7HIBC4SeeW72c0xWer4tYz82Iwm9tjoKPvXIJ6ZEiErdYk5Oq21vwmW3hUMB98WzD
	hSvgcr58YTxbknIuJxMw6a05200v5pno3ilQStDYGnl7kSWRQXrIjzKYwJJqCTV47qdT9vwT5VQMy
	jCcbgOnA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:37958 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1u2PK1-00000000PfF-0Evq;
	Wed, 09 Apr 2025 00:54:05 -0600
Message-ID: <5f399993-4d74-4665-b64b-1d83cc7f8b25@w6rz.net>
Date: Tue, 8 Apr 2025 23:54:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/204] 6.1.134-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408104820.266892317@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
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
X-Exim-ID: 1u2PK1-00000000PfF-0Evq
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:37958
X-Source-Auth: re@w6rz.net
X-Email-Count: 93
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPkvpZI9u92ev/vH1rH4aJYgVAzlfTLcI0tZkECxzRG82Tc8d9HQ03yzGwGKheg7pUFbq7qSjKf7/z5RNg8l6Id9yU79lUWBy4zKgxl83zpxILgafYwy
 bv91jA6KyufEEyS9aJVtjXg7DZVByG0+I1xQjKZuiTHiNh1E9cZIrPbbH8xo29wL98gsBbV8tbhDdQ==

On 4/8/25 03:48, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.134 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

