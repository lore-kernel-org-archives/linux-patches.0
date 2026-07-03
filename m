Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36A23E5EC6
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 14:31:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783089107; cv=none; b=tKYNZTNjNXXIhX6bD2ehJ8en0v4gz02i4MzPvG0LTqjKAh6cS+XEon6Hv3dS7gAwS7Kn1g90NGRIox9b6bNcEkkqURWwKfcgscsdSozn6UCgSfAoA3MsiKhBcOiOXbkRYP7HCC7S/m3Mo/ltECQt51S0sqPiZb/MKBvFjY7UdFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783089107; c=relaxed/simple;
	bh=M7dZgovOfO826MiZ3qVrZbC6cOLVn7WJJ8mz6vKCcO4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lRYYoMVXXQiJlbQLhp0vjuTM5zOME43pv6LkT2705gfA92RVc15cYd5KSieh7f2ql3zzEq6cV+pgccaCCQK/Q3YOf0LpbQAy1c3I0i0baVYZV4o6WF8W8OpkHXfjgdeT05krWvkn+FPZmwS74hiH1/4wrHOYGivhbOWvmFN3CeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=EPEw7MTf; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="EPEw7MTf"
Received: from eig-obgw-5005b.ext.cloudfilter.net ([10.0.29.189])
	by cmsmtp with ESMTPS
	id fOVwwMPEtMFEgfevdwn7YF; Fri, 03 Jul 2026 14:31:41 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id fevcwjxWGFb3lfevcwkquX; Fri, 03 Jul 2026 14:31:41 +0000
X-Authority-Analysis: v=2.4 cv=Xo36OUF9 c=1 sm=1 tr=0 ts=6a47c7cd
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=RxZ3SLQm1dEoavai1Wh81Nt8LIS1M2dahEoDioHhnCs=; b=EPEw7MTfTEO68cx+bEDpo4b2pX
	eeea/TjbCTMa9D6LuEaSdCByJM/QtXlW/vDx8yS0vzXt6OcZjk7N//NO49lhu4xoM47xEzL+gmlQW
	NHTQfnJ1VABZtgEuKIqxWuJIqzURkr9G7nTZ6o2CTZfQAHb4A90d0GinMbMX+RPVA8sx7Hb7CUTKg
	a4SLBBQ6f9sJEl29t3GEE5AFYZQxfWlDIvsc0ZFCWsDkKp/LLPiwUy9D2SyDWRvUvWbiavD2Oi1LW
	EYPeCMHBjVd0QInJ7DkPjqigfeeWxZ0Lc71my4GlEWchtgRFoWaLAlp12gXPTI8nbHxY5JipI7naA
	yL02pe/A==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:44864 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wfevb-00000001NqV-3vGH;
	Fri, 03 Jul 2026 08:31:39 -0600
Message-ID: <02396a34-f043-4473-9ce5-54c25b3d0cff@w6rz.net>
Date: Fri, 3 Jul 2026 07:31:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260703072825.068705122@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260703072825.068705122@linuxfoundation.org>
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
X-Exim-ID: 1wfevb-00000001NqV-3vGH
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:44864
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfIyXdQBm2OX5r7CJWnf/Bi+IJZnRXhN0ehnVT/sptWGnvxT0q+QXhnLHe21RYqT7bV3JVoOy44dU61w7WXIE4cMI0jhX/c4sIdLp3s2AS3PP3z2VBFrM
 jOHk8vK62iuKsjxzgdqnOVxDunQzN9oRI3/BA+JAaF4FenLtfFlEkOmJa1MQy0FkX8gJC4jv2dRTrA==

On 7/3/26 00:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Jul 2026 07:28:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.95-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

