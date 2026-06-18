Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B45D218872A
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:16:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781770570; cv=none; b=mOAsoP4ENxvtXB4wvNojVZLb2ri6RVLJ56/supHxyPhe6AZPcOxmK0VhhfBNSJhJTuDZB/XXmLSeAn4xgCATcDHfHDU25hJ3AWdznNUSiw9FpUmXmVbjRQZll6fo5q7rHNUf/+psZ52j/3ImEz5ho8KSxLxDhzKSk5c0iUIN8As=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781770570; c=relaxed/simple;
	bh=GHyigE0ZkY04GYxhoukj/4BiAheCQrN5JrNPTNOZ5yk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ln5GA6qXsHHj9qK1pY/8Zf0G4xR5Nqd2f+Lmta8O3cIaXqqWyIol8z0ydTSZ8eG68p4Zss0dZtuRkuhIixc2CQbFx7Fu9MgY2QGmdENG7GV7We9ZEQioCq1faapxqT8LjNEsEnLgcBEENl8qHui8gVdbF6T0O/pUs8D9ciJh2kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=AXMerhEo; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="AXMerhEo"
Received: from eig-obgw-6005b.ext.cloudfilter.net ([10.0.30.162])
	by cmsmtp with ESMTPS
	id a5zWwR1cRMFEga7uywhXGU; Thu, 18 Jun 2026 08:16:08 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id a7uxwScMQTzOda7uxwRfOP; Thu, 18 Jun 2026 08:16:08 +0000
X-Authority-Analysis: v=2.4 cv=FbE3xI+6 c=1 sm=1 tr=0 ts=6a33a948
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=9GQXaQUDpQhx98mIA28A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=a4QcjtBR1JHGc73gmaVGmlGEB3kKn1lLJ3Vy063lEAo=; b=AXMerhEoUuFGV630d3Xp/jaGzu
	L2CGLJ4Gz9fliZL7KAKXhy2YbCdDtmWknSq4NFGoYWWG3wwTmFDCYg53M8/YbmCJ/9m69gdcSvGj2
	eM145cuEUL4XovMlmryJFTS/LnV4z3Vr4F/x89/x96cro/I7934+KZMyTDUqrDISJX2J72PKCfEqs
	3946pbYHTw9eTN2w4qwkgJnekyi//4bD2dXHL4OCdDc/0z9cVJ4Lz9DEMv/AeZe1zWDPwuVrLUizD
	UXlui2G44IcoqRNzDc3l8//D3I6updUWUWoQdqWHArFyu4Xtuyj7cbGZCOm/2MTqlRy+vQbdrk1c1
	oWMul8tQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:48134 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wa7ux-00000002YBw-0lge;
	Thu, 18 Jun 2026 02:16:07 -0600
Message-ID: <0de8fd53-895c-4496-b084-efe5bd4ccfda@w6rz.net>
Date: Thu, 18 Jun 2026 01:16:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/452] 6.6.143-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145117.796205997@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
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
X-Exim-ID: 1wa7ux-00000002YBw-0lge
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:48134
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEuQBwr0JBAEEMgZAHKviYxomVxoeKo7VOS53uGXJM1JzutTaHKk8lcGZ/jiGOHYqGRkCHPEl42x9RTTjAJcb6XGDtrWLzQp7aJi9V4/W13FkX7yWHK2
 bdcs+NDBsEXC3rus4T+cbIMIag6QemImE4V7n8Rldzd8thATHFVV+ejZ7CTtXfs5y8P2X0Pq4K29Qg==

On 6/16/26 07:53, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.143 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.143-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

