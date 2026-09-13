Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B11345CCD
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 02:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789268036; cv=none; b=XStZ7uxtri+QRYcCaIMoJKNHPPEn5YmhPIiEuHiBsIJnzBfBsr0DZLrOf6rUSKRUT83KpcmpEPd2NQ2zvjXMGD6bFsf0JWwpkfZboJrZbapzqxp1BCWmj7x5duhijfTWLwO5bCvNop4ftdVgeCP6gMDOcytoBqFz0YmtPI6C5jU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789268036; c=relaxed/simple;
	bh=vF+aeKGhCKYZ1UEkmMolYzoJb09niBwtklJFl1X+Vok=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lpfHsPJxeu+KnG2VcTg63a6ZLaV4jE+H4xvF3aiBC/ChiPbLsl9cKfonJIfiMH3UXEq6QBioUVi/I6sFbSuAKzLp+VDvu3QFXeLtqs/F6STUApZN2sugBE88zQ/S1+v+DqLzFk59Czq65b93g5x7SgTCdAZD1PSjv+BX15UnnH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=muTQRO+f; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="muTQRO+f"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id 5PD1xKObOJFmF5aLpxRfAC; Sun, 13 Sep 2026 02:53:54 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 5aLpxWYukiutH5aLpx2Dow; Sun, 13 Sep 2026 02:53:53 +0000
X-Authority-Analysis: v=2.4 cv=AYuxH2XG c=1 sm=1 tr=0 ts=6aa61041
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=GTIYFbPaAdCZB4xclWkA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EzwfAeO9SfU5RaxzbNcwEZ+2pbDKDWm4/VnHl1VhfkY=; b=muTQRO+f499lYEJKYTCdNZZQiF
	gnL3u6W6KDjL8ksq75ZVgUQDidqcvzrOB9wHgUIZEXmodh0SPbOaghYgzsxThYI11TCcd1xodAobH
	DgrP2X5ll6iYSIIjsgV9sR8j9Fubtw6N+e5MvEAqccsSwCymAPsKSkWDfwPmL1/WB69igJgCn/5Ty
	Cvup6EmXo3hVwyrg/eWn/RCVh3uDUx+tOdtGUNCJtppfRlXpHyB2A+G/muyTOc9X3GwF8PH0Isf4L
	JR5dMx4pOQP6k2tkxjY553bII1Ph4cUEa7fMRz5Rxzfd8rHXTTixKZ9VT5vYI7wZUgLg6Stu3zm+q
	kfs5hGyQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:51804 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <re@w6rz.net>)
	id 1x5aLo-00000002pqg-2P2B;
	Sat, 12 Sep 2026 20:53:52 -0600
Message-ID: <82fb64b5-4273-4cb3-be34-ed9fd2d0dd94@w6rz.net>
Date: Sat, 12 Sep 2026 19:53:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/935] 5.15.221-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065526.833703348@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1x5aLo-00000002pqg-2P2B
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:51804
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGdPGfVrkJss9VQUIQzDdZDyM72m0fE7PaSi5LiNroGpFi9TATS7Vh7kPK1rjIbddrx071r63f6BKTKG4Bu2dOhIZDfEuI43Ifogg5K4/UJ9S6pYAMKV
 HZpATS5o4FoP4oTQyFEKTlqahB6iVrAMJmBJFkhBOdNlvUFfRf2oJsqNegV6poG2ojfONuUXhs7bOw==

On 9/11/26 23:50, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.221 release.
> There are 935 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.221-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
>
The build fails with:

sound/soc/fsl/fsl_audmix.c:469:12: warning: 'fsl_audmix_runtime_resume' used but never defined
   469 | static int fsl_audmix_runtime_resume(struct device *dev);
       |            ^~~~~~~~~~~~~~~~~~~~~~~~~
sound/soc/fsl/fsl_audmix.c:470:12: warning: 'fsl_audmix_runtime_suspend' used but never defined
   470 | static int fsl_audmix_runtime_suspend(struct device *dev);
       |            ^~~~~~~~~~~~~~~~~~~~~~~~~~
ERROR: modpost: "fsl_audmix_runtime_resume" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!
ERROR: modpost: "fsl_audmix_runtime_suspend" [sound/soc/fsl/snd-soc-fsl-audmix.ko] undefined!
make[1]: *** [scripts/Makefile.modpost:133: modules-only.symvers] Error 1
make[1]: *** Deleting file 'modules-only.symvers'
make: *** [Makefile:1843: modules] Error 2

This is due to commit "ASoC: fsl_audmix: rework runtime PM handling in probe" commit id 9145b2e38db943434df708bb818190f4a9e003b0 and 
I have CONFIG_PM=n in my config.

