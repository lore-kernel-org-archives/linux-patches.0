Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49A644317D
	for <patches@lists.linux.dev>; Thu, 19 Mar 2026 04:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773895807; cv=none; b=ao+7WlGDZrrTiHSTlKYs0YWI36PIb95kVsYmGk5Zgb7Ky3T4QrUOEZA13IS2P+DiT4aChaOqSSczDEFhotnek1IvwUl+gJ4LQvTuq0ZxpnE13hSmLBHbt8HjslpJOlC7vdOVlSLwkDA4zSpcTlQZ3XrLJfVu+dO7jzNrFJfoXkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773895807; c=relaxed/simple;
	bh=FDcoSrmixMyY2O1xpF0SWUMhfLTYSwxh4032HUDIXjE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iJEfSZCfeq6JvINZkerwrwJLx5TYbjUQ32F1TFP+mu/6/KgU11ZSsy3Z/et1oj1fqFhtTckcw73VBfKDMvvL201vRx8uz2MQodPeWricwKDexMg4vCYcJjvepMUvSnGoBzhZiqExIQIpdqx1nQpKTA60/v7TPw6YaBKUopq4oV0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=JC/wHhM2; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="JC/wHhM2"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id 31ncw57ghKXDJ35KZwdDMS; Thu, 19 Mar 2026 04:49:59 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 35KYwokheN3K135KYwzvEg; Thu, 19 Mar 2026 04:49:58 +0000
X-Authority-Analysis: v=2.4 cv=UdRRSLSN c=1 sm=1 tr=0 ts=69bb8076
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
	bh=fT769vdYou+aDRuMDO/NADCfSuK+ejypBBByAE30CEs=; b=JC/wHhM2ZQE3oclqJEwQGOj8KX
	1kPqHznk57Fr1FvLLns7DsI6QptGt0sjIzoDcHAUDutiinuvAXAVClX9Dspk1GHxarfFrBiC9ju8L
	xW2SBETUN8dOdAxXvTnTC5XBFosA7gr71I6UHJPeyMc4Mw+pkTFQAnSMp6QSfBW6VFGpwm1bKiznv
	croPpahMFatSnxR3rU5MIkNdjWrIVjbWkiOLC5iWbbmyL5+n6B6KgH4ti6z1PlKlCXOCs3mYeEsvt
	SlaiToYMi5Lqwj+wWLrcGL5xD7ABtSVy9yGuOerajuxOG9E2jnoh5l3GEW1COajqJJWNnrI6DgJVT
	mL+BspRg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:57060 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1w35KX-00000003x1U-3Wae;
	Wed, 18 Mar 2026 22:49:57 -0600
Message-ID: <3eb07c80-39c2-4074-9cd7-a582ac779df6@w6rz.net>
Date: Wed, 18 Mar 2026 21:49:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 000/379] 6.19.9-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260318122547.233850204@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260318122547.233850204@linuxfoundation.org>
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
X-Exim-ID: 1w35KX-00000003x1U-3Wae
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:57060
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJcOy0h2orvR9csNq3YL8y0vGAb9MIsl9IEf4tFlruUYE/jaJC2h+C4lvpyXR0YxcVueoQQWQ6c9A7DA028/Lce5sHt4ZxZaVI5+llCqs+qcjoA9ASkL
 2o/RvWyrmLZk5o76jEcJ0sqJWQnFqicNYPeGOvGkwCHVYeqTAJ0hXVb/Z9DeIaVloWacoNcLh+kqVg==

On 3/18/26 05:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.9 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 20 Mar 2026 12:24:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.9-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

