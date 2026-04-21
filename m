Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F1B386436
	for <patches@lists.linux.dev>; Tue, 21 Apr 2026 07:10:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776755412; cv=none; b=l+9SRN2+RFdovq8vLT3yueaa1R61NQvLSsrSb/vGNbTqlAnymTutLsV2rmiQ+mt/R2u2oTEv7x3lBjQqaY4Dqd9WGgkuJ2AhquszHaVEkA/tRVn0vaZ7p7ajo5l7V/6sXX6WW+5SXKIHEFfv8QPMrUlmIIO1ZcxYg8u7wCcrJvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776755412; c=relaxed/simple;
	bh=ja9sAyL3WPiNKJeYsaiFrLdpUJTQEu3Dl8Dgu7a038I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pcqYCdD72fMw6BwsL49T9H2CIgI77Lwr0BQ0d9RYxgka8U/+HhTHoI/BbzpkehkboOkSnh98CsAZnQf2WP0ELQ6IFXUdHjLspeCAYhmKb/xDyd/30V0RCvum7d8lU/ecrGzEXNVVImQ88wKE12lJLkFe3xak4OEKbqwgReRorMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=hs8AmZiW; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="hs8AmZiW"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id EyX4wGboJ4RkpF5FKwGfb6; Tue, 21 Apr 2026 07:10:10 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id F5FJwqKeNraqeF5FKwbio0; Tue, 21 Apr 2026 07:10:10 +0000
X-Authority-Analysis: v=2.4 cv=UNPdHDfy c=1 sm=1 tr=0 ts=69e722d2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=AaIY4YTrwRz8sAog88QA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Fe4dCnSvAjC2MRi2kSRIX9mf48HP8jvFvYcr7GW5U6s=; b=hs8AmZiWLVTaDARM/Gt7AuIlJv
	+njN/MhhBPqlI+1liCsMeJ7g6zB0HXsEdaY09Fo4NheL75RjAKk+cgijrzfArjNzAsocoUXqsAsh3
	FhI+gcu3ekhsDbW7rTXhSNrZMAMVc1rlsnEnEpANkginviP9fPKWAn/xgmDTblNEpfxLkblr/utnN
	C/Vb1vJbMj2fWINOCRU5YyjH2eOiJFkzq2T6si2PMxwIa/6UbZm4ghefxCcQRqX1f2qgqof5TrSrg
	gkZ9pR6ybnGO5UxjQdTCeiFOiYP1jJagF1Iyi11Cri+nLObI11dIHE8WzQCSbsKdNyLIqBQPLolqS
	t9mm2sRA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:36258 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wF5FJ-00000002K4B-0hkx;
	Tue, 21 Apr 2026 01:10:09 -0600
Message-ID: <fb23be11-8313-41a5-859a-1f627b9570e9@w6rz.net>
Date: Tue, 21 Apr 2026 00:10:07 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/162] 6.12.83-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260420153927.006696811@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
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
X-Exim-ID: 1wF5FJ-00000002K4B-0hkx
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:36258
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfH1rLyFoAaOGYuO55aWlAi3FCN6YmdYurteDoCAEcHoucr7eQVPmxvX2jiofYE2okoEoLy9ir80q7/g65G/B17ejlyzTw8UYAI9YZm1nntQTRxphBABJ
 Cw2TbSSwALy3QXP7oVFDOQ1hkQbmcOHBMabiOf2rJvxT+649mLYoVtuYo5TsAHZp2E7obCzuJd3Hnw==

On 4/20/26 08:40, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.83 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Apr 2026 15:38:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.83-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

