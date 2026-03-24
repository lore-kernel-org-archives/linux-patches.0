Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B70613B7776
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 08:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774340665; cv=none; b=PmTzPCkRYCBRsa2ZIjtWXL7a5SjRFcbrw7RMJVSLFDa+cwIj3yIyTZ+7ZRGMbigj3RBAD8jDKgEpk9aq8cTYm5ljzTDlB82sN5nEE4/X5VHhtZbl92oYtgxvAh75gOzccrqpKOaS9rpExLau5GvptducbwxcTgNHG553BFRmA7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774340665; c=relaxed/simple;
	bh=p561YWL/tpwZ5oQrx5gQZ7sIl6upT16NE2EIyUShkUU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HMdHjUmWajMUu7snPrT+6R6WV0Q/45azLrGnsbS0jeztSaOOZ02d6cdWDr+9luFKDay4XOd1c6RLBa4axueFbs9uPZWQ5z82yZhz/wAivIltdIbYV8mrQDNx9gGrMvjzHVEP8X9eMRnI4ulCQzyESDOkT5pZ1u9dz/+dVh/NFx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=uSpNlM/r; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="uSpNlM/r"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id 4ur4wt2n7Kjfo4x3dwSLDH; Tue, 24 Mar 2026 08:24:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 4x3cwgOxfvXvH4x3cwKydn; Tue, 24 Mar 2026 08:24:12 +0000
X-Authority-Analysis: v=2.4 cv=e4IGSbp/ c=1 sm=1 tr=0 ts=69c24a2c
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
	bh=DFyCfOfuYyKCEXxKGhvQ2E8NeFYI3OjtsvJL7T8DAkM=; b=uSpNlM/rJk/AmabB4QPqxj8Dnl
	beTplUPXUV+4qxI2YrLE93q8JzVWs4265+kgddIEMGADvBf0IhXSf0GZw5MwU0rCZNghGS/ZHQdIb
	HWLpmdEigf/+rxCkdqm8bwYQ01IRTaG5DasS2hA1meM323z3iqjVNZRWBsjD0TkyvaTiA6Rb70dOA
	a21n+uzMEccb9qm6hWtKD/SElg6alPcR4QEJiR4VQRtAkzAXvm3Fpw6riiieKvW4P+YG3dXpMILZP
	uTM5HYY3Guny8HP0NFYBYzaTm1mFLg1DiRPFghz83w3X0fFRYHwAlmgwytHTmyBQABLE1v/5Qqold
	CqoHbikA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37456 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w4x3b-00000001DE2-4ATa;
	Tue, 24 Mar 2026 02:24:12 -0600
Message-ID: <2109c55a-3650-41fa-afd0-14226609c578@w6rz.net>
Date: Tue, 24 Mar 2026 01:24:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134526.647552166@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
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
X-Exim-ID: 1w4x3b-00000001DE2-4ATa
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37456
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBVKi93df4H29afpK5dF4Kjc5cX4mNoWWXjtA3ej4RoNcOen5WvFhqpQ9SymSUnWkgbHZSbZFVinJljGCng2tFnwHFRsYl0/8k018MZMSWrma3fj5uaE
 1CH7oUAA4fFogDJDNGV56/zWk4RGcgfTqWxBOTtf5MuAFgCE8o0ZUhg/NaQ3SqOcibQC6KLnFP2qGw==

On 3/23/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.78-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

