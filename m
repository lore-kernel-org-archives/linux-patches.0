Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB53E2EB840
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 08:33:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764318829; cv=none; b=EcMRsmlnPDw2l/9G2vEwB3fOtvMMkO/OZk8xqiliTTSMvNDWxkUL0CNMnDDdh0/TRo8KuZeiwO4rvVNSm7ud94dvIyp779tfcMa5VZscwuO4wkkKCXU380JhJGRL+sKoKliJ0DrRkAU1QaEngO8ty8ndIjyYw1vDwcqimmPoaAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764318829; c=relaxed/simple;
	bh=waLFI6HOmyjl/mbtbkaKXUPk3iI50G0orYFNJd1A7T8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rCHO+Pf3gy1h8R/6pu5L7Xh4NycRt0HUtc9ygAumLFlf60bIKcu77dU/iHA2yHwze8slW0c0DZxPTnvWra5KK4mzy2VZI5InXdk5XymQ+APawWYtE2XOd5hli8IdagagYPFydy3juRrqGU85HwtsL9M321LI6AwU67u0HBEMdzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Fqjl+UNI; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Fqjl+UNI"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id OECHvb9LeKXDJOtv8vmEMf; Fri, 28 Nov 2025 08:33:38 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Otv7v0TJBhoT4Otv8vOM9X; Fri, 28 Nov 2025 08:33:38 +0000
X-Authority-Analysis: v=2.4 cv=XZyJzJ55 c=1 sm=1 tr=0 ts=69295e62
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=rqXhK7WHiVA6oVoFImQA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DiHfrTmwmVzTosRk2/0AO4rOz7bA+2ozF/k4p+TgKEQ=; b=Fqjl+UNItpZ6vux63ZKs1AXYS2
	EwTbbvpNvaxZfzJlim3qxAJaP3FBg+0gYCff76Xo8HAMLPObE/huGGPdXABdYX7xlltUL48PbF9CM
	HgD1BY3qM2uxYG4SGBlLSf69v7toYYPbl+z8Bp5VG1LCZWHgEge/8BZ3tox4P5m5oZXRDwkFtL5fy
	2mIE6FuuoezvVC3xVZkIEdeg4DfF7xlOyzvBIVwteyrADwIE4resmWEBS0vIVIqd4zNZBGgEm5O/2
	ZL/dPtFDOYZOh7PZJij+cj+IiG3VkimOYcxpuqr8URD2FzWaYjrEwQmPi8LwxYYEF2qXT+3k6c7XZ
	cVQiKR4A==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:60802 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vOtv7-00000001gnr-2lLm;
	Fri, 28 Nov 2025 01:33:37 -0700
Message-ID: <33cacda1-32aa-49ed-9c4f-e3f96f4eec61@w6rz.net>
Date: Fri, 28 Nov 2025 00:33:36 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251127150348.216197881@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vOtv7-00000001gnr-2lLm
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:60802
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfH4atJYCi6OLI+QrUcw2pX2VE3DxfzM0a+47mBa664PsMSKhM88gnJZ9vbba6t0kBy9eP1MxQ9q3E/iUhUZV22LOSffs1cxgHyEguowSqc+S4NpxmhUn
 jSjX6cQAN/x53RcURBQeaCPgDp0+fBQY40HEs1pZJZfFDDAfMBUhrR4hIxMLotX8TDYXnHjrcE6e/g==

On 11/27/25 07:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.17.10 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Nov 2025 15:03:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.17.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

