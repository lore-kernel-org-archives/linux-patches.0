Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EAC013AA36
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 08:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727599413; cv=none; b=M26m1QQL0mNdHXH9at2Jeasvs5syF2uAVajWNO/0ddCb+E7diBOgqdd1YIuNh2AL++8mkQ9h0niZtal61OqA5PlcXXE4gFPMc0aMu78qFqENBsR/Hx3M3PXDohu/izNQgNoKFbds8s9q26dJqHWPgWbOEaEz87riDxIgYnsL3i8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727599413; c=relaxed/simple;
	bh=T19KQz2/tTECmsi+5N/bBijXJzba822WCfvlRud2QjU=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=o9yNIRg0fuWqB1eHLOBPWiwINRDZRflcv0cURngHwi0Bx+9voBFX2lJeHp2jEPP80UJLwcHwdTQR4AQP8AKCFGPPcNoqm+BAE3Ksk7+glz7mwoibew7amLgRJBbW7U7BIthKpvhVyPM9Krc/D0LvVVgs5oa0IQGvqv+2HRFISpc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=GdQFGbM+; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="GdQFGbM+"
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
	by cmsmtp with ESMTPS
	id uVX0sjJrCqvuoupWcsRXIm; Sun, 29 Sep 2024 08:43:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id upWcsmRjPky5UupWcsXtDu; Sun, 29 Sep 2024 08:43:30 +0000
X-Authority-Analysis: v=2.4 cv=Cum5cG4D c=1 sm=1 tr=0 ts=66f91332
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PeMHkyFFRZyyPOSMFU2k1WM65T2JKiwqNKpCmYj1jqA=; b=GdQFGbM+R61tslx17hD3031fUZ
	xjkEINEhnsTZFYEoM2R9JazkE1p2h1mq53QW0QyHXv7U90VqF34YND/hv9BU9VlmkdkKvH/Thoa2g
	Mn1RZovERGasEbfqjKqFq0Pl/JPFkG6yvFfq3mTVGKhFSHUfxDXVlHRuUGE06aqftvYodiT0HAiP4
	y8NqFAR95OtHKJG/0zSbCs2HHlPfLI6ikKFFoPtUmYBA41ZMGAQkLcgZOX3VLcbMo0ustgV94p+0V
	4Ceb94PnqX0bVY8qVq4quEeIGxNH3PUQb0gVCA8X66kjl60EOGX39Gnb6CQCLSid7i/XpdzGoqTSe
	1s6r7SdA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:43258 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1supWa-003szQ-0d;
	Sun, 29 Sep 2024 02:43:28 -0600
Subject: Re: [PATCH 6.1 00/73] 6.1.112-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240927121719.897851549@linuxfoundation.org>
In-Reply-To: <20240927121719.897851549@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <b8dc892a-7b23-eb3d-f016-9494f2b902b2@w6rz.net>
Date: Sun, 29 Sep 2024 01:43:25 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1supWa-003szQ-0d
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:43258
X-Source-Auth: re@w6rz.net
X-Email-Count: 60
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPOmBbNNgHWVM+1lfhVTNgmoeIYTZa3jhRyUwl24hc9q1RsZcNPwb5OURq+xcsaCqCWHCHiuwEcT3QW40hXPlV5px9j2fRSNUB6zfetYsL6/Dkh4MVoI
 S0AV6BeL8ubmK/f8PawLE35qA4iBINWlrpEWWjdqh4hwIf0HqyDZLadlzhyTWCMRLU/HoZL1zBEwIw==

On 9/27/24 5:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.112 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.112-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

