Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7313423C8D5
	for <patches@lists.linux.dev>; Tue, 13 May 2025 09:57:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747130255; cv=none; b=fnyf8wzapo0Y+QIc79CRKSijMEqnGhoN2Dmokls2W+syznK5wh62oJ6FfNUcA01zz0eGDHUFdBcS9gJRIpznOEfbBEsy9i1lbR/VtLuwUzhbsQ6gwIrvYe/OvHZubtYB2SriGqSR0U00KSa29HI3ItVT8+IAyNUGY+jiQujhZXg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747130255; c=relaxed/simple;
	bh=JdAZyvEfFv+b3xCHhPfd7LcKXAFu9fTO6LCfNdrPf1E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VgyZ8fpMv40HzbAng9OAAY+k+e2cFsYvHJa5NVWLXXOWbN8veSFNRcfPFx/DIGtu4YjP7y95VPAfVVnqB35jQ1ez7+qNvug0ac8vxgi3cTr4pyBA07Huw9RbZihuF4EXOhBkK4V48tIy1OMQEff/kVPjUNJrRQGirzP3auP5ZeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=yEgiPzt7; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="yEgiPzt7"
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTPS
	id EiFTugkpuAfjwEmODudwxl; Tue, 13 May 2025 09:57:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id EmOCuH3LE1vNyEmOCuLtw1; Tue, 13 May 2025 09:57:32 +0000
X-Authority-Analysis: v=2.4 cv=VMQWnMPX c=1 sm=1 tr=0 ts=6823178c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=3LSEtfVInsQZ+YidTGzY/S0vZoyti6cDV9ARJoZIG8w=; b=yEgiPzt7AiD03xiK+RpDOVWQ1c
	821DDlHxcvGfMLdPsb79yLyZFlZ0LO2pMT7+X7sJ1T4/kuvJ95gdu7eEYrEPMXTLaxvItWaCNiPd5
	GRZehdXG1PYNg9gNxz3+PWp9/5UiYhE8Pes+9sN9vUmEuLIMQuIwqTTNtJkPxD9Hp7hRznG6uWWE+
	VO+b5qOA4gG+c66hc0sWMcrD8hV1xxcjmZGqUuJdWrF+3xXDcq750wJ/n1WWCrXnF2C2ms5cfwceU
	/vSIMCh/evktmyQXJM+waxTGhLA7HUV84+eKyaF++LyfFchTLnTnTJtHF2q1AMFAHfyY+xF1wvW9Y
	zywgKafw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:40850 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uEmOB-00000003MnA-0Cyf;
	Tue, 13 May 2025 03:57:31 -0600
Message-ID: <5e868efd-e6bc-4577-b6c8-9bce69027a97@w6rz.net>
Date: Tue, 13 May 2025 02:57:28 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172027.691520737@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
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
X-Exim-ID: 1uEmOB-00000003MnA-0Cyf
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:40850
X-Source-Auth: re@w6rz.net
X-Email-Count: 55
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNprL8C0z5XAy8oHP8rk7i3Ne3rMuKgwPVBVo4chpAPkWC91TYi8vgznQGg4sogjnkrHzpO7R0SMaJaBdhgEGY2VRUGQIaQXl4ODqSb3XZXQMUcoI+v/
 sYSG6i6Dm16jnUtRV0o5x0bk/z7bkjidocvwzcdKzNX9E87Bxw0M2+QxqNNBqo+J8U2ckcBzfWTRog==

On 5/12/25 10:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.91-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

