Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB883451D3
	for <patches@lists.linux.dev>; Tue, 19 Aug 2025 10:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755598305; cv=none; b=GES+EER4L9w51M7wkeRM1KV3cqUkHF3566S1ylAVwSP5JfsS+RCFxcoryANF7E12ZF3+lcLduMH6a1FR+rsdkT3eAj+s8i9x9ulcPH/z46K3Rg5NomGA66O8BDEVM4/GNkvhC/9sDrmsK1ICRZ6ztXndZmgpgZXzTsLABPIFcYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755598305; c=relaxed/simple;
	bh=qGOeN9G0GOVrGg/LZcsAF/tb0ZSoRNGCrLQuN4OaQ5A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V5FkZaJBmyxeRomVDU12aNJyfYgUS/+qnUuA6tTsu8Zz2teYU6W0F35cAItlXhc949wK3SGYqw7cJUiAsZDIMNbG3ueTu3REewUKik9ohubZIzXs7fEhuSj10AaveqZnSDezCoyZSE713o9Odv9qjbHKP/xZP6hQrbixzJI+Gfg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=He23El2/; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="He23El2/"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id oGwNuFRwvJLhFoJJeuu9Lo; Tue, 19 Aug 2025 10:11:42 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id oJJeuL8QNwYTkoJJeu4Beo; Tue, 19 Aug 2025 10:11:42 +0000
X-Authority-Analysis: v=2.4 cv=fYCty1QF c=1 sm=1 tr=0 ts=68a44dde
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zkcltEHC+5PUp5pdWSPG1bQNOG7bmN5S7wIPvuz9Rs0=; b=He23El2/cA5tokK12YA8w3E2qC
	mqwOs6/URs1tavdxypbINjCtTUbr5ADhhg1iJISfyX2fKmwBbQplwBDxVtVT4wlF62iLRoHlKxm1/
	sRyC5Nh9lS6xRyX3N/ERgogjUJS6dcb/pMNRtpV+T1A5CWegsKdzXEPxDthMky+TdoOdzB0bncV8i
	AaQTpay+5OLlqZydsiu7zIx0Re2/LrZ+0BPiZBu/P47WYphU37xrAs7zAY1ati9On/0z0QXj9taWS
	Ba4eT5/MOl8mXqOQFzd3HTy8eC0ueL/JL7b/Ghkz/y+N2TMPD4Twv5lPpAwGX671ANvk1Gg0E9eLn
	1PgxGfpg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:59336 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uoJJc-000000022WE-2M3v;
	Tue, 19 Aug 2025 04:11:40 -0600
Message-ID: <0982571c-d1c6-4475-a0b1-dd045db2b96f@w6rz.net>
Date: Tue, 19 Aug 2025 03:11:38 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/515] 6.15.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250818124458.334548733@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
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
X-Exim-ID: 1uoJJc-000000022WE-2M3v
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:59336
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJiw1NHagMPD9yH87JVa9Ufe3ud/nHXwhnonbZH2OaOfaHJ0Cb4LVlh9bWC7N0gjeZYlFQQrhLtwlhWbXYgEmVMqpp7zaZYMG34DBJSd9tS43Ojnk9kG
 dMJIc1/bQgdqe9m4NeIgnA/oV7VW1t6NghhJGElesDkUkCxikS5eiiq8mumM+vm7wmoNTJB/8LZx+g==

On 8/18/25 05:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 515 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

