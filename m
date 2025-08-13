Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9753221638A
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 21:56:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755122178; cv=none; b=cB8JnX0k+h3oTqfhR9rAiEgrDue2TbYm395lSL5Jv+fiaQP9umIV8NEr8D6mq2G+w1kVHu+BFgjhleMnGXuWkqeYnJ81dSJ9Yq9BhSLKZncuachD5wUbq0mv+eoVGGUnFe3cnEnx2dRwKeyRR0mDJstW1Zrd2gmHlh6VuXXhh6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755122178; c=relaxed/simple;
	bh=3bccP5G4ZVDV6OAhkchGrCnYBJbFBkw1qqCcvCIeSRE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MneMkzu+Q0psY7cpluMrfBzExB4v6o2LZWhKPbkuzjHCqdna+jn3yZFJbvaUcbuvDt1k0If/7w0eaCunOVkOKtbgaWoq7j6VpfhFFDfEjPCkr6pF467LvuFu6KxTMCFkx8eItcRc/Mx8W8bqA0RxcTscGHxNKeZvvOQP1JzeVwc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=cZ2/tfdm; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="cZ2/tfdm"
Received: from eig-obgw-6004b.ext.cloudfilter.net ([10.0.30.210])
	by cmsmtp with ESMTPS
	id mIAPulz0j1jt6mJSBunYNr; Wed, 13 Aug 2025 21:56:15 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id mJSAukDMkwYTkmJSBubDz7; Wed, 13 Aug 2025 21:56:15 +0000
X-Authority-Analysis: v=2.4 cv=fYCty1QF c=1 sm=1 tr=0 ts=689d09ff
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=SXGRLDKPG7BjaL2zA-YA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=Ee3sYPoOI8DKcngtIejia/XVFEfxIt+ZRzbJiXxB1I4=; b=cZ2/tfdmFl1io2CaRSdy9O//cX
	0E+r6wIa/q/JFaNY1hrksWlAcXjRbO5eTePuF68qD4dhAi9F7rPvkRw26sQdCaB9nFSDbKdpr1H/b
	eej8cA+CHhpX6AGWWVNvI5bEFWQIce0eA1iNrRys6A79EsvVd6+UIs5Cw1jzaO0/3MVTVd/HunSyi
	4lXcKQvpZGRFORCl3Aq3m9GUHxNJ/vr6yBhYFdlfcfdw8koXPBNsWJ/RG391/ocrdKhfrg2m2smkO
	+63kl5m0hQTOwv4eIj1CSeDFnqcKVRTLuOC4koD22oWBNvz+PGW34k2l+Xew6sXlLL1jUqbZGB6/V
	WuyJOZoA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:39160 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1umJS9-000000021yI-3AsY;
	Wed, 13 Aug 2025 15:56:13 -0600
Message-ID: <8a4d31ce-a535-4558-8cdf-8238d7e8e3e0@w6rz.net>
Date: Wed, 13 Aug 2025 14:56:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/253] 6.1.148-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812172948.675299901@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
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
X-Exim-ID: 1umJS9-000000021yI-3AsY
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:39160
X-Source-Auth: re@w6rz.net
X-Email-Count: 98
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDonYpNkSQel5FgQR0qRmD/VZF5r2XI+0JGbrqVgxrbuzUPi42rFlnQfqapwGwKqNA8vmXjK3PzJYbyZqYTa4ega+N65yFwb4VanQfR3bo7hoih+KiN4
 xHnResl3GcuC3lPl7NtaDXzWj6Nn1i25eLNSMEMk1XVIReLidA/kI4oypcwpqmm3LK2tXLx/xSJ77w==

On 8/12/25 10:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.148 release.
> There are 253 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:27:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

