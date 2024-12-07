Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AA164A24
	for <patches@lists.linux.dev>; Sat,  7 Dec 2024 07:45:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733557543; cv=none; b=QGWsZSCDwcAj3I3638Y81pI5J1UxV0ag5yb/r4PXyXUUjZcBPoBqGA7u5naSX7dBI+KrP6vsstKmJNL2AMGaxewtnIE7mcu0kP2Ze9wpWSEloOMJl1EVI6gz04g0VaXU4H2fVTWx/hqUHyqk8lyF6Zl6ZxBtHkXhqhCv2N+TQ5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733557543; c=relaxed/simple;
	bh=SNpFgPdSo+t35pzmqSgf3icZ48ToM0Po88JTwUAAA4E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vBwDEuyEHvcxRFI6QE6DBvdxoLqR/fvca7+iXygy1LO+dbvNCU6t3yoOlpmF3SVxjtb2J8AKFpGgXjnnbTHKETPxZBfqEtIabOZjCLVo7bdzazyPKgMetuOXqxJaJGTl2mODD7JVVah2SO6Y0zeijQkXRwTKVkPJLeLJ+cC33hI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=DOFGwFOh; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="DOFGwFOh"
Received: from eig-obgw-5006a.ext.cloudfilter.net ([10.0.29.179])
	by cmsmtp with ESMTPS
	id Jj1ttuuaTrKrbJpVNtQjPt; Sat, 07 Dec 2024 07:45:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id JpVMt6YyNQjIYJpVNt9x39; Sat, 07 Dec 2024 07:45:33 +0000
X-Authority-Analysis: v=2.4 cv=etnZzJpX c=1 sm=1 tr=0 ts=6753fd1d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=uJ7QF4CZc7MYPwvNa44NzO6hHAkLkuutND+55bVBz6A=; b=DOFGwFOhXx3qrXPVpVyVNgxJEu
	BAiwnvICa4giwoB/MrVIXS52R3jXDoYHhv8yEHrs2UmmojQS6I4MBvbCcECgE+t6jq/dxm9dCAJVF
	aQTWFFDFvmmCr0NB7T/L6qWWDpFAcWkW6CGd4OAxAml3kXrQfcmKBNVbC2KMaLE5J4DAkS5xG2Anx
	w21qHHOB7lyfLZ8zbDDjo8RQMlYqJTLvcnWDiDwSzZ32v+eDWmgduPUWTNxqvFwWm0re2iByBZtIk
	YucFlMl52Jnm5KbgGHnw47Eekuho4D3QTIPDdAaStvhFTdUPmU5Vi6ejgULmLdx9/nhaBATtgHVdN
	DBbU8ADQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:55222 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tJpVL-0030kT-2C;
	Sat, 07 Dec 2024 00:45:31 -0700
Message-ID: <08fdec69-df68-4a94-98eb-6e71eff2d14f@w6rz.net>
Date: Fri, 6 Dec 2024 23:45:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/146] 6.12.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241206143527.654980698@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
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
X-Exim-ID: 1tJpVL-0030kT-2C
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:55222
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMnhx1VZ4AZmHRiAPF01xWaDHAc/4wZahbmbxhCWm95eXT4vZ9ChJcctpcsOEsM7gS36yLTAxTcUU1Lp/FKqDTfYnXyXg0qtDU6P++XTJ0CUMWIVFlD1
 CqLWk4BIqy7fZug3yVHii8ylicJeQU4ktxqstyzVvshJ/cg++cPl2f0THoQ5RnS3Aj/IWeyA2wCfKg==

On 12/6/24 06:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.4 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

