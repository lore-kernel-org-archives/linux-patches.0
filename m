Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E6E4C77BE
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 11:03:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784718202; cv=none; b=CBcqcDYw2NZ/RTjOn2gRgZlX2+BTzYEAX7XMOZi6KBQuWJzZW0bK5XiKW/+xTnNFgx+b2PKOKC3FKoWHAdhMwqvlop+pzlD2xSOsjsP+MeSQK+H9fQfpEdoC81Uv3A7mXmeHLreojH9Z+Gnuk95qfduuvEW1/sjstnq3DhIfFdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784718202; c=relaxed/simple;
	bh=nzMiOcvMBf3K+RPUNkrXmck92lcGefVB6Y6DEq4Pz0g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fi7lT3P7lCzAjTG0URMyog9mQH3rscZv6IGwkpjf5LwgVTKT7NglGBDs8Yg6HTCpSPSq+8ji122Rh0d6Xem2x3mQRgGdbFgyk2hjzKYqrhHj3AwhwleCQd/7QhLLWzWyK0VHLump7MPuRrp+5sLAXXsm26x1oixVWfdkkgU9BYQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=tpgLu2oQ; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="tpgLu2oQ"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id mJRVw04bjaC0UmUjLwxAFk; Wed, 22 Jul 2026 11:03:15 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id mUjKwWsfktyQ7mUjKwaJxx; Wed, 22 Jul 2026 11:03:14 +0000
X-Authority-Analysis: v=2.4 cv=E5LNpbdl c=1 sm=1 tr=0 ts=6a60a372
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=drHL9oBl_C1s5T8VGSUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=FKe3JV9BAPW3K/8yS1Ki4GrpsNN6nzcBkDCzXSzFgtA=; b=tpgLu2oQ/kWh7nP84OEC6pDaTg
	4TuuJUWHgS6ZrtB5xfn9ih+ZQ/EXSze7g+m0DVfSv7cpAf5D8ND3G0MD8MW9DMiWbwbz9+9qh4hk/
	bgY4jXJ64de5ijpUfqIAAeQlERme283rzXbibutOBCWVpeihWsCzdo10StaEGkFdCius3L78kgSx2
	dKmexkjPm4MfjUNUUrE9IK87iLe9OPP/DSR/Gjj62Ltgq/E1SEza6VMqIyaPnTay0J5iNoYOXYuBP
	MYbIT0vRYY6DHErFcP/3U+PwuPLNVTaLx5q/+M/eB5gMkVVuwiAYcybq18+RpETpRn7pe9MNuEgkY
	RjxgVgvQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:40006 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wmUjJ-00000001NHr-2gwO;
	Wed, 22 Jul 2026 05:03:13 -0600
Message-ID: <b4420b92-deb0-4ea6-8404-3016abeb1c0c@w6rz.net>
Date: Wed, 22 Jul 2026 04:03:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 0000/1067] 6.1.178-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260721152424.521567757@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
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
X-Exim-ID: 1wmUjJ-00000001NHr-2gwO
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:40006
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDri4jrqVAATYd0RkU9BXzJ99IWSy2DMZpEdr0Q93+jjqCMQEm9WRQOyKF+mueVUCRIlZVQS0IlyLetcB+Ntx9OT9z70oIjWkWFlPdn5g2EH/wKbzjhP
 PLeJiIRuFAT3r1oJMqgMa499zsqFcJCpqrfSJURg6HRXgQwuqHTYjaPosrdAD6rqm8yHRKwOLnCOFg==

On 7/21/26 08:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.178 release.
> There are 1067 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.178-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

