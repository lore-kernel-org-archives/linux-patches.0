Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C32E4A0C
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 06:51:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768027879; cv=none; b=Wt8Lr1+Q9EM+/elpWtltZN3VPkmU6mvFemoY0ZF2YxXKQcm7MkiZ4HjLY87Oy1pFtT6aHKd7TbYiERlCwZl+HszlOWPioRcccFlmRd6Regeh978d1ONc9lEzaEdxrbxpJUUiWSOu08LG1wxzCWKEqYvj7EbAvOLCibyubJwiUvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768027879; c=relaxed/simple;
	bh=NjmfylT7yD2RTspLXyVOBxg2uYBn3gwL3dRX+4V/k7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ftuVOVaYNl0vgT0G/kBThcyIrpmjKY2hgM56lD7FJMfLe4N5nNp2lFbiyFpm4D9fqfEZVLexYvY+RhXeixS7cxREiiEnzBYWZ1KAwTUmW8UIqerFxpI9J2YT7ARUPHk35GMEAvKWquhYPhYq6GTZoTvfdU+NUyTI1G64e6/83pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=woTHFbgq; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="woTHFbgq"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id eO9qv8jBtKjfoeSofvnMEp; Sat, 10 Jan 2026 06:51:17 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id eSoevDW53HSQMeSoevCnMe; Sat, 10 Jan 2026 06:51:16 +0000
X-Authority-Analysis: v=2.4 cv=GIQIEvNK c=1 sm=1 tr=0 ts=6961f6e4
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=vUbySO9Y5rIA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=2O4G9lFrC229S/fNgAi5IqRVrwtLKRp1mZl9VpBlHPU=; b=woTHFbgq8IAz4H6kJlQb3sdy2z
	zw8y16868vyn9g0t3nT1GyPuW25XiE8ybjV/diRDIFO81K2jBjMY/sN+HvBm+1J5hEBBCJg7cX4rM
	63CxPhvhJ/HTXYEId07zkebR/oydA+spo3p3g2JwFr6T+26eND7mSGATUDuNvl5YJKhd+olOmbmzm
	sS8Hrn6EFIC0VuCL21XIQNnuRPw0/BQBAW7vCiwEZx9jWUUBc8tKXxCC+7sLwzpR/B8XwVFRTD32r
	r1f5iO6xW+8Ih4hNSRed0eMf8bcal/5wXoEgQMwxo/sZf1x5MtMCY969JUY9nv2etuOxLHZxtRTtA
	fb9tRFvw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:47680 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1veSoe-00000000yHx-0KZF;
	Fri, 09 Jan 2026 23:51:16 -0700
Message-ID: <96be7a54-66c2-4d69-8812-c3d9a339082f@w6rz.net>
Date: Fri, 9 Jan 2026 22:51:14 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/16] 6.12.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260109111951.415522519@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260109111951.415522519@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1veSoe-00000000yHx-0KZF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:47680
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfD2TAX1YGWfQ2tZSowaBW6BLSfUaBt8V1c5ag9xEM4/CH9RLNA0LsU2MkYXjUZr/9aVuCIAb8ZmpVkiqfK3ufA/2u+RAvZWhrQ5iOxvo6niazqbfjGso
 xK+Icwt/DaeyhWGMEXvZNNiiKDINwl6S+QORZha+IPIkMVZlMWrc8dTZFDW6jZ/Eb96bAl6U05Rm1Q==

On 1/9/26 03:43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.65 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 11 Jan 2026 11:19:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

