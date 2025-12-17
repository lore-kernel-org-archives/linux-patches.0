Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 545141799F
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 05:24:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765949079; cv=none; b=KrQ2lNMuYZ8q+kBl5jFT8wsLPcXgyEtoyIafPm3y2vz/L+hJr0l95a+10KDVcdQFBdNF1Y7lFxvczc4/nhaLt+EzmawroPUQXgGa4hjPrniiEiYnMxpxjtQCm6BpmcZNH/0cluilbl93d21sCkslv3P74P++/J+iwhSjJoLaSOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765949079; c=relaxed/simple;
	bh=RmMt8lC+DNZb4qkpkFIN0JDM6NQA6YYoxZ0d9AQKUTU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VWdFR/ecVndhkMJwuyoO5ny9undE6yVRzTyZ0QDQ+savDof+EV72V1Z0UjivOY2j6uUbkoT2KCvmyih94uEuGd75vIqwW72wVpfcDEu3FtXD1cnOKvN3c0DnmizyyFQZ0WPesKuJXwPRKRX3YaCfp7kgPjGap5xX7CXYldpvIp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=rWNzbmpJ; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="rWNzbmpJ"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id VZCwvwdqyKjfoVk05vz4Sm; Wed, 17 Dec 2025 05:23:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Vk04v7kLcV6WMVk04vHc7C; Wed, 17 Dec 2025 05:23:01 +0000
X-Authority-Analysis: v=2.4 cv=E//Npbdl c=1 sm=1 tr=0 ts=69423e35
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=shKLvg-12WSsmoj5OQgA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1ry79zZ0BMDyGjQ1Xu6bnHTLh4S250iNMTQH9bYZbMU=; b=rWNzbmpJ+E28R4vzrQJg15XsEQ
	tkTTcfLf8iwjbd7jctHf5H19bvl7wkeHkI4cH7xYAk4Cr1hAYU+XqVc5jxvTAqMdYvP+xPSAdMNam
	KKCbZICfdabptG/1Y3gs3IMONWlSw3P1pqu9zeeaVRd8HD754gbRiag/ZA4PqDSQ5tnhSSjgPTgcY
	ZwHA6o9XqvyGNFxiBJxxbNySPyeL9ZXsTvfHyC1scPm/xGsNeGfcPVXjxjHQgoeCd9NIWxmpp9lXS
	Tt8OWUh6/A/tYAlVTsA6tpw+uUjdbsv6aXYVxhbcafIceL5yFOtNAmO5miXXW0fDe+0RJyvLyQvcd
	U0qy/gmA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:42952 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vVjzk-00000000Aww-0PmN;
	Tue, 16 Dec 2025 22:22:40 -0700
Message-ID: <09e38999-a6b2-4330-9b70-731ba1d2b4bc@w6rz.net>
Date: Tue, 16 Dec 2025 21:22:17 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/354] 6.12.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251216111320.896758933@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
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
X-Exim-ID: 1vVjzk-00000000Aww-0PmN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:42952
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLAzfCIKMTWpwK1musUqTYSNUh/LQhzdMKQfQtaf8Q8RpXMFup/OUsQ+qClGoOI5/4Hi2h6qv/R0zcfC2xT/MzVDvBu5QEqfF4mQ9yVqtHBBKvfxmnRX
 RCV7ux74cVusu7loMCJo8M0OspZ37H1Nk8UgaqqPW0AagACKqMcQwfz+dNqiO0wRy8/bLUQYuGVLKw==

On 12/16/25 03:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.63-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

