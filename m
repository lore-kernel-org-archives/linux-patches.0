Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F0053DEFFF
	for <patches@lists.linux.dev>; Tue,  5 May 2026 08:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777968360; cv=none; b=TziEpk6VVHbxT7U0FmGBGISmPURisRUV/Clteytz/PVrBQoojWnk3eM7glFt/fmQXAfsq4FfxxmyPdk6qw1t7xyOFMWcGGS1UnBwdM8kmEgAordi1x/+IBq7dkeYrP15dYy8vsSPRtSvr5YkcWq9NSkziEYDsptX+mahD1Eespw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777968360; c=relaxed/simple;
	bh=ku6yRcON1IJG6qLD5X6p1ecKTgebJw2CVTy8t2x8ESo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uTVzjBdag2c4y7g7qCgb5ye1WYrGBEM6AXP5W5HItPjZitgzkjKEjNExgcWqsP8ALW7CWy5rUv4xNepG4NNLBKhooj56aZM+WLd3pmcGKh3+nV7N8Yifv9splUHdnbVU62jare5e8ork4HZFBV7vbm8e6CEa2qMmQetneKP5+lA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=bJ/IwbAw; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="bJ/IwbAw"
Received: from eig-obgw-6007b.ext.cloudfilter.net ([10.0.30.166])
	by cmsmtp with ESMTPS
	id K8pAwsHWTnv6VKAmzwdiBJ; Tue, 05 May 2026 08:05:57 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id KAmyw9VMPYO6jKAmzw7eVg; Tue, 05 May 2026 08:05:57 +0000
X-Authority-Analysis: v=2.4 cv=ffyty1QF c=1 sm=1 tr=0 ts=69f9a4e5
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=j6b/B9cVSWChaGY9yfto4YHQDPWYBjokxh6BHoMMZDg=; b=bJ/IwbAwoqnHFQr6ySLnHNm9DA
	24qpSCuJd2RpWgSRiSDQb0SSWFPbwr+D31MYX04KhiKtaZtOuTUUa49YoW4U90owjGN2B/ey12ahD
	dwTW1Fcbqt9+x7CnQ/p698GDKLWShtnjdxARXibA3LZaf6p0jRzIsqhwKxzAz3pGkHtfxt4CYY4iP
	+Z0CX6U4PQLsIKd0rfMRm9/qHpl/vA4+gTLn2pxX4PqC2Hk7IEVnFo/NAGADeCIxa5qv/c3bOzC90
	RiabWaVlRD4Z//qXw1ohJrNcmdNDuFMygnI2OMZH5QSXAQPeJIlOJBAeuPC4RJmG7uP7tpHAMv+PU
	ATOcmDMw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:51230 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wKAmy-00000002Lof-0ucr;
	Tue, 05 May 2026 02:05:56 -0600
Message-ID: <142b6583-8e80-4dc7-8dbf-66582d699f43@w6rz.net>
Date: Tue, 5 May 2026 01:05:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/275] 6.18.27-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260504135142.929052779@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
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
X-Exim-ID: 1wKAmy-00000002Lof-0ucr
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:51230
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCTKi7V/O6kvF4rhl+mvK/+OQu2mxlEqYxoMKXUHiv9FKt2MKxvFHYoF0ljcGm7fJEtUymizlEavLevGn6gpAvUntMTUAxdFbynraU6yGpitTPQ3NWyv
 bIhoAuBM0pk2H9cjExQgmAkISoliKZqnutBmJVZcw40ahI/7fEy0f2nmFZ8rfR7GrfHpTLBrF5oDLg==

On 5/4/26 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.27 release.
> There are 275 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 May 2026 13:50:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.27-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

