Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D4384238
	for <patches@lists.linux.dev>; Tue, 24 Mar 2026 08:41:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774341672; cv=none; b=g0I0Q7z8tg2ezcOuZwLYBDIHSU+CDnV7k5u37XnyNvFLtrt//ovaXBwoFdNL+DfglfyqhBeEAKSRNaaW6xzKCxc35hHPAfDxdh9UcX2Wuc1R1agWV/3vOU7TauzMUtVAzGonm9GC4cs8v6PCCcqeppQG7eZLjPPd+H9HWTK2N1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774341672; c=relaxed/simple;
	bh=1p9TcZ6iSbbUpdwrh92iA3UsrYBUXudJDf638FOdEFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZSzN9oXfNdoh8LRZ2W9+BsRA75Yt9+9zcEPJp7P9UfU41Dpevoxag+Jk4Z7tMDId7U6fqO0IvTP2G+L6yL2f/V891Vc8S/d8g07LUf8tdhkxDPZlCCz1I7V87tKkQNS5A5zCc1e7K8Ud4nz0Jfpw3HtVdKXxyJdxFS2b2INeyC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=LtKMm2ii; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="LtKMm2ii"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id 4oFfwySX2VCBN4xJxwhXMA; Tue, 24 Mar 2026 08:41:05 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 4xJvwdv232l0k4xJwwUssY; Tue, 24 Mar 2026 08:41:04 +0000
X-Authority-Analysis: v=2.4 cv=UfRRSLSN c=1 sm=1 tr=0 ts=69c24e21
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
	bh=EpAw3ClMxyDboGwDrs4Gw0GssBS7rJkh/NFNm93APCM=; b=LtKMm2iiCchZRsKtWSktt57PxI
	/CShlX7cN5pAMskV0v4Fv4w/P9KHbiG61QekdNY9XGVXh7ANQsfEtyvfmK7393CXm8JPeaEuBXiNu
	e3waSjbI8/a6qbP1JMeGW898Ic3uqSmOt92OvD21DzqlgrG8QHNOswKugmM0yNQiLVkJDUXLI0SCn
	hvxfVDUurpmxT8QPv3RikgqAWizN1YkI75jUTy7mfGyYHPfMOHAG/UTVywysq2AjZQLqPJ9fnSqHh
	ivQXOyCSrQ8bpURyNOxVi+sV7wcwkBWrTefPG4DZH2vlieYFck8//9VP/VtX8IMxdUCsRxNX4JsJ+
	NfWH+FdA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:45756 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w4xJv-00000001KJx-1dE4;
	Tue, 24 Mar 2026 02:41:03 -0600
Message-ID: <92bad9c5-14ce-496e-87c1-ff403e2b0633@w6rz.net>
Date: Tue, 24 Mar 2026 01:41:01 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134525.256603107@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
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
X-Exim-ID: 1w4xJv-00000001KJx-1dE4
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:45756
X-Source-Auth: re@w6rz.net
X-Email-Count: 98
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfL/skj51qv4l5QFwXqXqh8iayfAZ0LxDHb4O8SGrRG0tjMqoio+6MnabQPGYeRlS0419YR6fGoANdzN6SUnUesh14KBNm2dfZ1wccDwswB35vFrtdNFf
 pYyUyxHCLHXHpeq8l1eBJpaJjHCRq6SngmgqUC0AF7Nkd2a/Ze1suwdttnxuPnCkHW5eZzMjqhZuIQ==

On 3/23/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.167-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

