Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F642C235B
	for <patches@lists.linux.dev>; Thu, 19 Feb 2026 06:21:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771482116; cv=none; b=IEA12XTv6f1pb6R9MFm/KePvyIE6oXBmqsKRgDaRF3dQlfaM2HVAYvPYiPKspxecWO4teFhtR8UJOaPbysZQvt1TYyEAla2BArqtjoY+AK5jRwO/EjvR8MA978kS0qSOJRVAK8KBNY9XCJe9gV9PHn9E7pDkIqjgQ7YPPzwhhes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771482116; c=relaxed/simple;
	bh=UIi+DxIyR8kDVnXIFHxCqjQozGtTWABJ0nx4AXJmgzI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UZ6tlV3h1p3w0lGOYxcGCUYC5azUdtOoUTGLOsR1gBGkLgnVNercBnPWyn6pv33BxkcKeXeFsO3JFztq21fGIpGDm64se67k4AUvREDDefkHscSveZc8551f5J7JR8zvFtAEENSfa1Xajku455uCAEoPBIP+DvaevVx624UjXzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=R79eHSdW; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="R79eHSdW"
Received: from eig-obgw-6006b.ext.cloudfilter.net ([10.0.30.211])
	by cmsmtp with ESMTPS
	id swTXvFVs4KjfosxQ9vsI46; Thu, 19 Feb 2026 06:21:53 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id sxQ8vaPGovXvHsxQ8vR6yR; Thu, 19 Feb 2026 06:21:52 +0000
X-Authority-Analysis: v=2.4 cv=e4IGSbp/ c=1 sm=1 tr=0 ts=6996ac00
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=x6Ducos6UYMGwXt6jLcA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=QrqSunourYZek9zVBdnSLgUJSVikJF4446zIHmgGv3o=; b=R79eHSdWunt6o95mxHsMtiwvww
	FwlxpHoDEMRK94bk8MFt1I6ikwIDQnM0EihkExw9LcAJKTEoy/HP4KuOC8IQD/Ftp0wcQIv5pCrIv
	1u9SQt2aTqOww1PRoA34IJE0OZXVe+P1LJv8MYMQupz359VI+dR91/tdropgx0IYyBe2pzRN/3XMs
	vAnLTFdi9h1B3FRiRnJ2uESwDglfFoeLKF8MnW4ApG9PXf4gYEmXk5/mYSqamNQ7Xq3MzyHHpBqVG
	g/jlfJujFhad81/RL8KLci7MH+RNXhvPWTb6wnE2JX/Tda2GaPOKBQDhyqOSj/A3LVuMgxSPqqgkw
	I9iaV2Ew==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:39698 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vsxQ7-000000024hG-3hLI;
	Wed, 18 Feb 2026 23:21:51 -0700
Message-ID: <03ac893b-b4ba-43b2-b08d-c5a3349ae269@w6rz.net>
Date: Wed, 18 Feb 2026 22:21:50 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.19 00/18] 6.19.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260217200002.683975158@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260217200002.683975158@linuxfoundation.org>
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
X-Exim-ID: 1vsxQ7-000000024hG-3hLI
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:39698
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfN4bUJJSlb6q3LOdefamXuNvUASM1SpOwCcz6sQkgJlfxypNm2cUTe0Fx60dALMooAk4rDd2KskPNDjdM9Fj/A40LLnrvqQxMQqO35SFW9nexCJd1Pus
 IB8TjB7tf+N9QtVxSsCTdweJBriszXxR71j/5pC2+bUpEE5txOEQmMACl71zgwG64mmsfEg2MKERPw==

On 2/17/26 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.19.3 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.19.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

