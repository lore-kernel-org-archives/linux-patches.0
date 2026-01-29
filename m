Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6DC33CE85
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 10:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769681896; cv=none; b=sNDK34bBFEnfQ3VBZ+e0GtxMVwGQxFL9Ce9UHWXvbRF8uXIII6iS20cEAHmrkHYFhv4KHA9QVUM0tTOiLz9WXG32oOHvCuFeqKxpCSnkj2QdpBR/ILKv8gOy7qttFagl+XBeCsGrQCCxKNqPX2y+Fj2lF5GEYkZX0h/mNpum9aw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769681896; c=relaxed/simple;
	bh=TWNioC6FzyTcrIRAQ6r3fAJ/6Qf5JLUbGJSvW0ums/I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QB35755ecNhigadHqxgJHQmkF99r+9XBwJhab+vnIkfoAu8/XEaKMZ9+mmgbJE8YmRntwJsNPFC46g06MTyRc54mMNHvN5hQdiDwrpSfXqd1MvybyaWRBaWDebI26x9EG3+ZyJ+JzxJKMqV/bW8H1piZzCeVXzdGodYgeMTx5GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=mXVfk9p9; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="mXVfk9p9"
Received: from eig-obgw-5001b.ext.cloudfilter.net ([10.0.29.181])
	by cmsmtp with ESMTPS
	id lLajvhVcYCxrGlP6LvCuCi; Thu, 29 Jan 2026 10:18:13 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id lP6Kv8V5dSqlVlP6LvxDry; Thu, 29 Jan 2026 10:18:13 +0000
X-Authority-Analysis: v=2.4 cv=I7FlRMgg c=1 sm=1 tr=0 ts=697b33e5
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
	bh=ubZDWEp7AcMJzZR0+fZ4Ijvmt7ZOM/tqqmsoJEKzHQs=; b=mXVfk9p9cf/TjZV9+ex3AwlPiZ
	41XpCSe2cBHFKJANNx0qCiZwP3Wfnj5Btd0CzsIyCWUrBGxqgv7/KIuNmVHF5H3UbAlzAT9aIkCVS
	jiCfVMavWnQKxSS2vKvS+H+2f4SGZcLTcQ31U4pfxol5Q/aO68Yj4X2ShE6gq5CCIDcElNO2fbKiD
	61qG96IWaUun0tayQW/F9Tf152iB1gtxiOlBbaQPIyaWRz+ceozXPn3uO8hj2Ht9Hvcw/r30p4ebv
	xkWYIxdt60wSz3iaKReVO0S/ngQqyK6CMrJOJHfd/QnYt7+uQ7VePytBoe486EI8OeB2cEronApti
	ewioTWOQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:55966 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vlP6K-00000003xxk-1rAD;
	Thu, 29 Jan 2026 03:18:12 -0700
Message-ID: <4fdade0a-63d1-4a79-8076-0c978b2be860@w6rz.net>
Date: Thu, 29 Jan 2026 02:18:10 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/169] 6.12.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260128145334.006287341@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
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
X-Exim-ID: 1vlP6K-00000003xxk-1rAD
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:55966
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBPhFVzQhFgud/nWristXAG7A189olSzqd5Mu2uXPKoKstGih8c6Zel1MYhmUMfdWvv0d9OgCXko4vz2PgrOc/57dkFhfzeHBZj+r5pyTvKhsFySfAT2
 UM1XKySv+7qgWf5NG9erxbY6AlXmShIdufb7gPnkTrgwldPQeCdFwJEisPcwblpxm4GHXCnADtoGrg==

On 1/28/26 07:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.68 release.
> There are 169 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 30 Jan 2026 14:53:02 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

