Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5491B37883C
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 08:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775721855; cv=none; b=TrHFrXmSb7DF8Wz37l9J7yF2KL7XtmMvwxK/Onk4QaCjNEIKQ8EwuZ8xvmw55hBxU57TZjqWJEdkUV1JKnbayn2Nj7n0akEKDeLkfDuFUL4JTi4WFig6pwU6c3LUgxfuPRHvs+CQgKNvSnUkWeTqUPfoqwAF0L0kb8TsjFTHYpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775721855; c=relaxed/simple;
	bh=nOst/iSNDhiRzDWtHnOB8RwWxPuR1zVMTHj3eCcmQS4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mmlSeGLp+NeMPSxFDXGFQGYy2V9yZnE/+0PUy7/205rhy7wayoZgT4ILOsQcPjj95WdM38R7eH0MnlTLNwKE/fz+HKcQWR/dc+hmr65lMCGoLtv5VjhW3h+z48tsfC5JYX832S79ZaVWrbammF57/6eTAjFsUfxmTIiexs71yeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=DsSR4u2k; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="DsSR4u2k"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id AfZTwMyVAObRfAkN3wmpw5; Thu, 09 Apr 2026 08:04:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id AkN2wRyWYQLXzAkN2w6dqi; Thu, 09 Apr 2026 08:04:12 +0000
X-Authority-Analysis: v=2.4 cv=DodW+H/+ c=1 sm=1 tr=0 ts=69d75d7d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CjaWIUSdNxIzt+lcTa9ETZ/N+A574+caN4yvTbp5sRQ=; b=DsSR4u2k9JnYOjnGZRaELioIQz
	AM5c2KtkDlXEDQO8XEVzueKhjyfOIPS1n6ef9DRXCO1LQbPI7wtdfSYQjUppcB/go8cJqeFpsjdu4
	SaZ2uD+iJqSs/EqXf4qr3pXi4FEGVyiSYXv3SuTHSATcynzS8lXMZPwMKOuEFQUsN0aSYNHHBk267
	DXo9uKR8ygCqoIO1RvFL6qDucdKmuRwmK574pApLdcPy3LCyeSX7HstH4oIUdlH422WBh+KtXKNtn
	+s/DQVqdhaAuRHR5TfvCfJku/b8wj90WPJ2WSXgzyQb/DOwFyTH76ndfw54gjawK3N/veDioYNZn+
	Olvs4UMg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:45748 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1wAkN1-00000001xnC-1uOV;
	Thu, 09 Apr 2026 02:04:11 -0600
Message-ID: <0777f171-bf7e-419e-9b37-643faca1cfc2@w6rz.net>
Date: Thu, 9 Apr 2026 01:04:10 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/242] 6.12.81-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260408175927.064985309@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
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
X-Exim-ID: 1wAkN1-00000001xnC-1uOV
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:45748
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCiHxd8IcSMTkldyPLnXHHy/Pm3lKtXGZkLOrmgPhq/azvrj0hxuj9+PcNC3laomYXS2ZNbOvtezB/mYO/ZH1+kKDuOFcAlpvj5H5WpgJH31jgThUFNX
 RPxVK8oQNbAGPP1faEcYl19SHlYCSfJlQCKvIYJ9wBs8M7ZrsHLqXIN0bPyCrVoXKdvGu+7w2xfnHw==

On 4/8/26 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.81 release.
> There are 242 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.81-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

