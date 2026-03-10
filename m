Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E9E837474A
	for <patches@lists.linux.dev>; Tue, 10 Mar 2026 23:20:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773184835; cv=none; b=LW0I7o6UPXRA2DCZe8rJitG09101PZC9dWNWbPIMr2xXBY3+cSNKvxojf4dk/2PkHgR6VabTDhAkIfAhTepbDA6zlanXk2V00bXXD+qVrfeRTnrm+WkFQIfQR8lUZ7WGaazrIVxMG4xDIMvJea0ke1PpsCztzY8jl3rriIjMxsI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773184835; c=relaxed/simple;
	bh=K3VGsCMN9AT6BQW8zvw90LmegpSGr8CQK/e0GkyEILg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LbSIxEPCOZoRo2hKky+ZD1pAyVOVENIgxgP7hQCL2uzkLjVqQS0QBkqc1I8d38jrJBppu40WnjrJNGMJKEpoSdo8XAgd1v9+QYlJ97wGuH3cQxvul2pUIWNmZ5kYzHiCNWIfS0HjSFxUCl18WpTcGrQPrdHEiqMUOCw2ergFPnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=nUBd4azD; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="nUBd4azD"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id 05wTwpZDmKjfo06NIwY8WO; Tue, 10 Mar 2026 23:20:28 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 06NGwxAdChoT406NHw3bV2; Tue, 10 Mar 2026 23:20:27 +0000
X-Authority-Analysis: v=2.4 cv=XZyJzJ55 c=1 sm=1 tr=0 ts=69b0a73c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=nHqQo-rYKszzful_uMcA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=UIEEa5aSbV1wyKZ5NJKiRpfmTzQlUSN7gQ2zosMlAj0=; b=nUBd4azDBpx+NMMYe5Ob+Cc9Jo
	YvIOrbuJGAnuD5DEYbvkgs9L3HIcM9vfgXv2R3C+DTqEQ4yLwoQuPwdvBTDW2L3NMjqIj3sHCcYjn
	lwmPwgJbaVfXxnsdhyDc0LEOVja6bhi0SE+QnpkJTcTOdkzDpFFh4QG3kMi4nEUQfoucOuqTLAz46
	J02yzqEqevjYlHUchNIX9OqJLQ2QUbO+ZykDDmtJAOrRnOlplvC79Rd5CQHvNNMOX+Vh7r41lYXLI
	J+O2Io8hVikD+xvbJhiHgkwNxQtVpWa3m7yE/srahMJsRErP0xK5Kyy/W/m+HmN+Xevb2YX0U8r8Z
	j/v0Hn1Q==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:33130 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w06NG-00000000KUw-2JcE;
	Tue, 10 Mar 2026 17:20:26 -0600
Message-ID: <8ed725be-1940-4261-92da-5fb704a08f41@w6rz.net>
Date: Tue, 10 Mar 2026 16:20:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/314] 6.18.17-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <cover.1773141554.git.sashal@kernel.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
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
X-Exim-ID: 1w06NG-00000000KUw-2JcE
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:33130
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfH2NsNU7ZfezD7GBodXNUGHuzAUbQaVISRzKU27zezMriWS5ZxrVUJO5nJYG43lRhgrPAFFnKp8MY9VM4G+jzU3zraoFgJRGUzcrpcM9rEm3UjRR5aNY
 1U/DeeSuSAqJX7vhEKPQQw8ZnsLpc6dbwBhnT3Q+zet6B0NRvRLT+kQeTzVJTtiu4JakCj0jK6QpIg==

On 3/10/26 04:19, Sasha Levin wrote:
> This is the start of the stable review cycle for the 6.18.17 release.
> There are 314 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Mar 12 11:19:16 AM UTC 2026.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/rawdiff/?id=linux-6.18.y&id2=v6.18.16
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> Thanks,
> Sasha

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

