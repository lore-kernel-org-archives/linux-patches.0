Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C5619DFA2
	for <patches@lists.linux.dev>; Sat, 22 Nov 2025 11:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763810254; cv=none; b=XOJEhGmYAJmPdOTFE0iCBM2nPnEivTW5PZ965V9eokmUlWHeaPwpVKoz2aPTH5De7Kg0lCHDa2XNTebzi74KNIX5MYR5qiI+lLaUKD3KcF+Qqpf0uAkq40NDY4zc1XVH7lTdJ/htnas1Aq4zE91mfBuUTnhqNO13+NkhCNm/Dpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763810254; c=relaxed/simple;
	bh=QufHtPrb6st8QqstczUo6OVv2b1JGZv7SZ2qmAP9/3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dGra6yYtzoSACg7LxTOZ0zOfXCPVXByqQ92ISRK4c7R35QQDddB1pIVzpJBg48T3os8cj9IUqWMqHZD87NkyY6oTOd2v/XC+Ikze/+6rX9VPNLVCsksHM3Yo9bdds5vxymIG5XWE/QeEmYGbsjpOqF4jqOtducpMol86Af1EAR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=hGZxLI8G; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="hGZxLI8G"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id MlALvAD0uVCBNMlcRv86QJ; Sat, 22 Nov 2025 11:17:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id MlcRvguxffjs1MlcRvs4bs; Sat, 22 Nov 2025 11:17:31 +0000
X-Authority-Analysis: v=2.4 cv=So+Q6OO0 c=1 sm=1 tr=0 ts=69219bcb
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=wslb3YrD4XxGTB1xvDIA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=4TyPN5w1xJsLz33ocIqa7aFXOOziTWqVf4fXzULp1d8=; b=hGZxLI8GzsWJ2NYjqhLRRMStFC
	X5JZRZGuVK+R0gOp9qGF8gumegzUdGJgFeSHVj/OhzMTM003aLpiyLNuZNIvoTgWjaL7OgKSv/pZA
	zm8ti+2JLhAcGfkvMKlp2hnh7sGah08IGLghLRDa47IjpGBNaUFhJNxpuMMlUpwFZNGb/H53TVhkr
	5ymE6l6xGvLuBTkgrvP2xG0ncHO3mksHSrZUuXFY56KI54dHLPw13loSoupD02UHFc3NJX71RmDT3
	sbZ/rXwxZiKCQ6FOOlD4gEqW7aZU4yj5AKJIyf6lipTBMPMgckkzjkZvKegirJ5ST4EjetfnNXV4y
	76qBr0nw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:57046 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vMlcQ-00000001JmH-31rG;
	Sat, 22 Nov 2025 04:17:30 -0700
Message-ID: <682299e2-be28-4065-ae9a-3a90940deb3f@w6rz.net>
Date: Sat, 22 Nov 2025 03:17:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/529] 6.6.117-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251121130230.985163914@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251121130230.985163914@linuxfoundation.org>
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
X-Exim-ID: 1vMlcQ-00000001JmH-31rG
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:57046
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfC3W9dLx2owYJeR40soiov+Mwf6FDmzH1fPkXzP/wk/dzzvKNSFekTKd9dGNy3ypdaNhFNb+VSDk4LskODBjPM+H3nNYZgPwxSKMqYjsW9NXEF+xUfQ7
 2chGokOuzdx5OGqHni1AELXxQlVSMgl7PGRYAJ8VgJ5DyGNwNdcVF3eeOMxOIy1Gwkz0l6K0G7j52w==

On 11/21/25 05:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.117 release.
> There are 529 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Nov 2025 13:01:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.117-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

