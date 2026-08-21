Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2DE341E6A9
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 22:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787352967; cv=none; b=qROVFWwSHQc/RJGD7iv/3OwfGfNOyjlOmdAzZe8bmHLfj9E+NfNdTxSzmisV6501vkkdNGm+5rI7xq1xt5qKeDy+ldluKkyeqfDS/LDiUnq/Op/cQ4Fqc01jcz9OliuFpvy9hWLtoOVJbuvRhdzS++Q4WHImPKZSLqEoymKaRI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787352967; c=relaxed/simple;
	bh=cKiUKYUJyqZz12zNowv5ZAK6aL2jLhetzxcMMOAlBI4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rz8/gSZiaLnYng65PTYGf10XBoIN+YfqxIqwgNV9+kLpSd5i83/85U14LCKKKZ0Dg/stjbU/QpSPZHjDIZlPuAWtfj4dfuU8AZYKSqvIvIb14sbfw+OLXLrQEZgu8w6ql4JHUPEWqtLU7nSUoK/OFRMJPJdwSYD/8L4ZDC87qCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=JFGkenhg; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="JFGkenhg"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id xRsXwk06lLvgbxY9WwDFs8; Fri, 21 Aug 2026 22:55:59 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id xY9WwLPMvVE4wxY9WwqxRz; Fri, 21 Aug 2026 22:55:58 +0000
X-Authority-Analysis: v=2.4 cv=T4OMT+KQ c=1 sm=1 tr=0 ts=6a88d77e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=zXxSttX-2r3IGRbXeFgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8RlSpXZNZsY+0THTCiOOivbzeutS1n5VEcKcP9i5Tao=; b=JFGkenhgc4ai+Z9jp8RP/yNJfI
	VxjFXb8P5RTu0AU9jSyAmEqM8f9WBEn4EvqjLdHUocI1uv5mOnzdYRdigf9ql5gdkptBUBkbeS1QU
	p4+d/otj29rXzHyN4cOfx6hKoY9ewmBKHvz8ogP6X4vCCt7I2rPT/17KBYEun0QS2Q1cFdF4XN7Pd
	3Ljqz7pApSLcO9SQIF0FVxWaW86VOORNhgl4v3LEdoKPSFNvDP+3JvbTIah/P2eIOW1qV0yly5lgP
	k6+2iCFSjG42MtjglGAEGTnWM7ZegVuv7XswcKgulZ/976zAF0Y5e2+vlVUY+8X81WbgyAlzI/kd+
	LKTrP4AQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:38812 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wxY9V-00000002Pmw-2YTT;
	Fri, 21 Aug 2026 16:55:57 -0600
Message-ID: <cc2896ca-9a1b-49c3-9986-f388299964b0@w6rz.net>
Date: Fri, 21 Aug 2026 15:55:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/160] 6.6.153-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260821142844.249995408@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260821142844.249995408@linuxfoundation.org>
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
X-Exim-ID: 1wxY9V-00000002Pmw-2YTT
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:38812
X-Source-Auth: re@w6rz.net
X-Email-Count: 78
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBuhsPaYcWj7OMnFPT0sjg1WRYh6yFWYKGbF0VTMOuk+33TaK8Jq5yqmZo+gB2p3VPhGDmqIsGPyJBIl3ducAyLHR3/phwKtCH5wrXTy8Q7YpVcFUgq8
 7xpxlx6OBKXtOHAu7bmJ2V1TspiUyNuPA3wcgDoWvDA/7rcl6jsXf9UrKnvS2t3VH8Jl2zTmr3uF+Q==

On 8/21/26 07:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Aug 2026 14:28:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.153-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

