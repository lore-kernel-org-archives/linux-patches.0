Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13D03164D6
	for <patches@lists.linux.dev>; Tue, 18 Aug 2026 10:12:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787047943; cv=none; b=r1gKIrU9M/bLY/cTN0c0tO+/8TEjdjBkO433xsJ5s7q8movP1Ri+uIY2ZU0RYxVKev7MPqiHE4FFNJkpcq23Wd/47zD2tD+dSbwSey30nNXaOHf8cnMwpsbYin5gwCN1zUTKlgDbCxag+FR2yZ/110rIHzXwGmiWP0I3oI6bXO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787047943; c=relaxed/simple;
	bh=x/Lbq/xT++ejr6fmLsnIBgXrPoSVBJQNdfyvkDh5qc0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s21kY4IvMPVUFoUXF99T9Wk1NCLldYE7MjKdpW2UKoe1bLja/Zzzf9LpgNuvvkKbQbKv0tHgbej5qE9NHGl/1mwPxOWVQf2vCMCvCJ1W13Yvw9qR/1Hno/pmHBNt+fkfWVtfMbf1mamJdtR0fYKUGgCegls7YnB6xfQAOZDQLHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=rLXmWDRi; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="rLXmWDRi"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id w3V7wSb8JJFmFwGnsw1wEa; Tue, 18 Aug 2026 10:12:20 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wGnrwtoTRJzb7wGnswN3dq; Tue, 18 Aug 2026 10:12:20 +0000
X-Authority-Analysis: v=2.4 cv=Quhe3Uyd c=1 sm=1 tr=0 ts=6a843004
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CPmyXrjRXjZ0PPJJ6yvYXBQSkjCgwOAq/gAO141Fvys=; b=rLXmWDRiaF+awFfiJhdn8cQ8Ts
	7O40/Di3zyQXyMqkLTVrHNvkxTRr4BgNkiSF1DUCGt4EQUYkqKhfxota5ahOJFbQ39FgmV9QAZYLe
	7eTWj9M2t5qGukeFvpfnJosY87jPaG9C+EgadtvpSIYP+MIwKPUezEKaq3hIJvmubl7aulP4VrPH2
	efZ/UyuozWVHFSnB8axiQJHCvKT/JOU8aGT2Wc+QPRfFgwaFttj/wuGbVOMTnqyD4vKpnlb1elx5x
	3VFF9sQefe82Y1H82CAl6ZOMg9OAltMgcUwY6YkVuFNkPDxhKHgChyBa6Dx7iKT/ypH+JDTTswv4v
	fY1+Zrwg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:55804 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1wwGnr-00000002O1g-14NP;
	Tue, 18 Aug 2026 04:12:19 -0600
Message-ID: <29e987d6-23af-4892-805a-8a64e95b7797@w6rz.net>
Date: Tue, 18 Aug 2026 03:12:17 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/609] 6.1.183-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132543.039278408@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
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
X-Exim-ID: 1wwGnr-00000002O1g-14NP
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:55804
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCF+ZN+n4kLqjcX0mineujbvlaNcOFNgSamgHFoEXKbqFInUeq2m+CiUF9GbYuM3kpvlQ0k84ozLJY+0XSHrsOOjhFroIYmUSGYhrs99wwFD1uG7UsYH
 teblDW8IuK+8ZwreRBHsm14Zi24nU8pH9O1zCFx81PHIysz6u5r/NZb9w9Hp1njnQLxvZgFPEY7bHw==

On 8/17/26 06:24, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.183 release.
> There are 609 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.183-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

