Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C72D49CF29
	for <patches@lists.linux.dev>; Thu, 10 Sep 2026 14:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789052259; cv=none; b=sKTLXeAZkNissj3l7qwf0CnunyT62z5RbG2GV9OHMJVLsc0TUnWkmLXzhnZRoPBjyd+IxpBjzvehnbmd+1cBp5qbmLX4p9KxB75TyvNcLBLHYneBe1R6NfUvXLzb2g4Ci13/VlhR8ao34tjWaLsVGdcmtsVNeAaZqZIXzmjaVO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789052259; c=relaxed/simple;
	bh=MdLSULf3d3qvKV+vE3zXiAyNrNZe0yPTzOESM2avdlc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=up8Fmf0PTN3HNcSUdt/CDOCjynjhcKAX/AiuY+QRgbOJ/zIN+h7Q7ZhbQKBfu3Qnw9EGHzkmI3qcgZDgaTLb3bRZME4NCdEATWftwQWbYWo8xwMRe2jPQuzISgOnZyYI9Hyt5EauZRw1OpSiAHMLkWyIguZ8OQuu0LIB5iTp1TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=q83puyE2; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="q83puyE2"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id 4OnkxVbzCaC0U4gDTxVGXV; Thu, 10 Sep 2026 14:57:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 4gDSx7H945NF34gDSxczqi; Thu, 10 Sep 2026 14:57:31 +0000
X-Authority-Analysis: v=2.4 cv=GaMXnRXL c=1 sm=1 tr=0 ts=6aa2c55b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=HsQM0NtH+7ObRZRg4qitg2mGRHy2UjGToKtnghGJ6mk=; b=q83puyE2hgYiYtAzNTkqEYgelH
	7+hdutQ7UiBQk2+k8VfCSGAf7IwT53iuJdjQnqoeij+IqY7wUiZEu0p+wd7iYTz4cMre8HgmFWD7r
	fv7U74hnB6F6f9GtfScgcTOb5XGglov4cNFP2+UwcBm/WIFKA9pU+gU2m+uTiAcKlyjTrjNJsvRjL
	iOMMZSuaogQpoT6DudZ5Vd4KIoTyd1d70u+KCPkH70DViH6X8JXaz8m9UBnG18uD/96b5fWjGBKtM
	PaBmaxALiwTUulDfgx5AivWeVFgJypmtOo2jm1en52Or76OaFEo/6gLyngSjkRvM4M1MT5wEqmRYb
	nK/mcEXQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:40986 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.5)
	(envelope-from <re@w6rz.net>)
	id 1x4gDR-00000000HwG-3kGu;
	Thu, 10 Sep 2026 08:57:29 -0600
Message-ID: <887fff2e-ef6f-469d-a4e6-4455276518c9@w6rz.net>
Date: Thu, 10 Sep 2026 07:57:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/556] 7.2.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260909134230.441546314@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
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
X-Exim-ID: 1x4gDR-00000000HwG-3kGu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:40986
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGRGxaJUaIRChSnWCr0Y88hu2p3xr8tjCRNICHrvIrUL1Tv5gvZ92+tPoJG7/8dtmfWYLZPcYrJKJXy3ZZsrFtK8PcsqJRTCr6Y92vILl6V+VtrWcDox
 Jes090VZXe42LxyxxOdw47iamRJCwz0yb6fzmppdck8mHE1V3pNuU8jmHAI6OpOOoN3fStxlrvRRHw==

On 9/9/26 06:34, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.5 release.
> There are 556 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Sep 2026 13:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.5-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

