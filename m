Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4D82D5957
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 12:07:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761653253; cv=none; b=u4Rl00oCLn1PwENVoOVTGImS4VnSPOtKjgtlkg9AGt0rHMprfYjTJwqCkbvbDxzrD3qSGTq85giGHgalKNlEtcgfT/MkCx2oRxNHvjRsFVulC/Dz7kdMEu9zQQkHTsx/9luUGGRfgOwDwZEjm8FtA/Ke57nKUYGApBtBZ+z4nic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761653253; c=relaxed/simple;
	bh=Fcfh6kaZo7yeS/1uDHoLfMDPZOkkiTRUJGyoBH2vHQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Zmb3dI5JaUtKWcWsOxcPv6/l0LIfosiwhPvvwwAhp5z67rllFaoKRcDTPGyY/F/VKtO4z4V0JtfIRyopnMVED8FASVF8MkKXZgCP0g6kQAY63OXhapLI75HYJo6TdAudvC9IhoAtzqJHsFiEQNzmnZeuUUgVsOm39/C7Q1dxhBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=a6gopqrF; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="a6gopqrF"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id DVG0vxMu7aPqLDiU5vvQrI; Tue, 28 Oct 2025 12:07:29 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id DiTwvHxHiniktDiTwvwv62; Tue, 28 Oct 2025 12:07:20 +0000
X-Authority-Analysis: v=2.4 cv=FOIbx/os c=1 sm=1 tr=0 ts=6900b201
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=mI5VrmPg0CdlQwlRe4cA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=n6O6DBKd53+BXK2/d2bLFquIW/SCEivimwCxbLzKvNo=; b=a6gopqrFfstda5UFx408ef7Jsm
	4NNyF5rN1w69kPpF6+4gpRidDqgQuLh1HdgwVUg8r563rk3f3eYgRjhNNzT78mOglB1GfFMz0WZa5
	5tT9VvH+aWG6an/+UwRzJtupomMNII5k049Bb8b5bUB0CAm3jmFsiclR+Lx/w9RPgQbOjYfgS4GKt
	d6GejDA2D3GSe/hjuS6qsGHXuaWxMbR9+q4w2QkxERnZQOq8LK22LaVi10p6Y+slXvYCXfUzuAdwC
	y3oHNXYBnJmTKcOHD+4yDWMMUgC4n8IH4vdUurdNft8S1HFMUjffXMrS+ZqS2A9K9P2cLXd3X8uUD
	unJXU++g==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:43268 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vDiTw-00000002IRs-0eSs;
	Tue, 28 Oct 2025 06:07:20 -0600
Message-ID: <096e6b1e-71b8-4738-8f91-1bc508273f18@w6rz.net>
Date: Tue, 28 Oct 2025 05:07:18 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/117] 5.15.196-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251028092823.507383588@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251028092823.507383588@linuxfoundation.org>
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
X-Exim-ID: 1vDiTw-00000002IRs-0eSs
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:43268
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfEdCwUbhwUJHoq7HIv7gAUB52b27UVIg2OHjS0UPf3ZH2tZ2Py2faAciNvqaNgNCvgqggVgB6xEPVUDlaLtmGG46VzpsuUklkc/B2R2Bj/gLRjeNgOKA
 4EbN7C9D+/sOJ032UdxEaJ9SzRn7XntbjVROoGhCD4iXHwqqEdo7UeP2fNY1CcZy+8w4thL0/Y+tew==

On 10/28/25 02:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Oct 2025 09:28:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.196-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

