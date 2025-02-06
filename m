Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BBBD22687C
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 09:33:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738834423; cv=none; b=b3Nch7/nOWFLvUx9gsYhYgL+QX5aMh+4Nr/fhYQZQdhAKeVJSXJHROynSm/8gqGsbD9dpi9mlltOOdZWX5rYGxguPRodegjEQgp33X/RQXQZV4QBW0zW9w0Utj1RXuzrQf20aiwmHPyOJ7zjkaZ0DSD/xa4ukDddh7V6jEslm9Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738834423; c=relaxed/simple;
	bh=usdz62LURijbWQ2Ga/7vGTMaHUbDX8+cCgvM+iEDBJE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pp6rtyR/Z65MJf/gB6X9/zUqDu1oVLNiMAt5V9GKz3/C5uPTidf3VKAVfbApqf+2fm9I03idDUeaXyVvWOwzd0va8+oF+y7mF0/7t3Jd8HTQifNJk4lXiLVCGTDFDmE2iGliDxhn11oDL+qhWDCxAc6dtfToWdDkB/bgUxq8Vvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=aksC4HcP; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="aksC4HcP"
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
	by cmsmtp with ESMTPS
	id fx0TtHNpkAfjwfyGNtA58i; Thu, 06 Feb 2025 09:33:35 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id fyGMt1wXEvt5YfyGMtXast; Thu, 06 Feb 2025 09:33:34 +0000
X-Authority-Analysis: v=2.4 cv=c9JgQg9l c=1 sm=1 tr=0 ts=67a481ee
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=T2h4t0Lz3GQA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=g9OED4ookiJITInLTEIPWloDXRRtGC/+P9KCScsYSdQ=; b=aksC4HcP+RjmcglH6u/QW6svcJ
	65bznwhEy5oTC4EiDMRHnltKotGFMshb75iryQCFGZptqeUmps6VPqYGgd6LnUgMTrlLhnjd5dlU3
	ztmwecvyrQMR5u2g1JyOtpZjoY2/FIYP2szZbmOKgB9NJlrhBY0YxN9xDKkkxrkg2mQLoCOfzs9hb
	j+MZLvBh08V9ECkvlZ0ZRa127r1FCpjQ0rMaN//yI0qg/+6wn6Ldj4/utFXa/jhdsO4LKpzSW3m7+
	kagCOdf8zhwpGIiPxw4CJhxRhMkQqLgWkLwn3AoFiqiC6Xk3h/s/0PL1xCq1I1ugTMHYRPuvN7oZu
	JTJvT5+Q==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:55396 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tfyGL-001iYW-03;
	Thu, 06 Feb 2025 02:33:33 -0700
Message-ID: <97713b4c-e3b5-4335-9827-a695f00a09ad@w6rz.net>
Date: Thu, 6 Feb 2025 01:33:30 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 000/623] 6.13.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250205134456.221272033@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1tfyGL-001iYW-03
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:55396
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMnwCKsIY0mLhuEeh7UHfKd+xb6PZmdnMIaF2nE4eJjn9X6BSlI+m61MPQIX5vKtHFtmBUIYpYSdD0HuRlLfpo2VOnXiOVArU0UZm3EQOqu5ekw8pBUp
 rL+9eZ8BTErjUH3lnc0manswftQLN4HFe4jOBAFlRqFjYiHoYOgwC22PQ2Svb2YtJeBVysE3Hb+SiQ==

On 2/5/25 05:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 623 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Feb 2025 13:42:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

