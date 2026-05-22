Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B08DA26B742
	for <patches@lists.linux.dev>; Fri, 22 May 2026 00:55:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779411346; cv=none; b=Y48f1tefe9vk60JaAszAF56bJAilLmEVHtJ7GY/cz9S2U4u+RPCiZS5yhBJ26H5G6N65YY03QjsoE1D7hLWHSXMeMplo0megZSREIu06UcXcxgpe2UJQ0Lh1nh74Jv+LQxGAz7LNcYOuhot5Epp+xhUpwrcqPJIBhU+A2I7wxx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779411346; c=relaxed/simple;
	bh=AfbZbzn/v2kcRTGzICaLnmYRKld5A1OLFciVODcz8RM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CGSb7NA7K/s5btfSiqsZBSTTjM5+O2BJnx3i66m0bb7x7QZo2UAksWxGZyBX3w19ouv8MHa5gm47eh6jAdoaizomIYwmxuHQPzK/rjr1WHXaBTjVqdiLx01Kc4eOkJWN8FkXFTodkhwXX94fsR5vENkSC21rp/d/ol56BdHI/Eg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=yZm2y2VO; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="yZm2y2VO"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id QBQxwNs3TlPo5QEAtwaVpY; Fri, 22 May 2026 00:55:39 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id QEAswJax39e09QEAswbNIW; Fri, 22 May 2026 00:55:38 +0000
X-Authority-Analysis: v=2.4 cv=SY/3duRu c=1 sm=1 tr=0 ts=6a0fa98b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=7tCdydmXtREoD5JP-u4A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+nKMrIqF4zQPxLt3PP/gm9X2SXMOY4WnFqW8dwsM8rE=; b=yZm2y2VO46evZAD0pVEYc7fclF
	bd4i0i67yQqqGs4+cznPaJ63wOwpIttO6MXlBnelRbuwSkVuOtOI6QA/+2cD/Yn5wXoJOBmoBI9xf
	/I8GZVrIOsy3L4FnGH45iPad/wRkwXdL8OnBvWf3pTgWot7gPJYDpfKA+rdIOh6SwrVsWcyBvG291
	ZIx296M5ZtAJagD6kqqO8qNR+Hyno3x37J98ZCpY4G0bSXtfA7T5XLARQzqlv696AqkeA0sGi62xQ
	+dKn1FBm98YzqwJtol9fvJFeN5bmLY7/AnFbBdPQCvlyLZ0QWE/9XQfs6wQBygwhXc7VeZDhKoAA8
	NqS58fEA==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:48050 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wQEAr-00000002YBe-2pMR;
	Thu, 21 May 2026 18:55:37 -0600
Message-ID: <1c6d9110-ede1-481e-b4b3-863857d616a3@w6rz.net>
Date: Thu, 21 May 2026 17:55:35 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260520162148.390695140@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
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
X-Exim-ID: 1wQEAr-00000002YBe-2pMR
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:48050
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfI/uksA0waSO483xu3I3pBxiUEvFVn5Sgyvn/H6U28kAeh+TTcBEBO1RmuZMWcN57Lylh8AQHwgLk/fGnDZ86HcuZXDE6gGjNcar4HIsxbA+cQK2ye8j
 XaUucEaTkoUxlaWmt7zoHiTrv5Lg1r8EgZ89XNEXgmZ/sVn2L0Obd+fXnSj2pZwMgei6IIvrk9VxHA==

On 5/20/26 09:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.10 release.
> There are 1146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 May 2026 16:20:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

