Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6430730EF8F
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 11:51:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761652301; cv=none; b=Bsj2DApshV3hXgHViT8CZAnIgUMAhK2tKi9GiRL0Z/9u2g9OTokHpeI70mhiUxocWXMqZYKCoGr06QZpJT5OmygPWO1/b8/rVYsiRvG1Oj6VQ1gZnMBaBaiK8XdhepQu8nBzea945z8P/1SOewNhqeRnuZ4AiW+55nyC+TAHqaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761652301; c=relaxed/simple;
	bh=FA24KbyXlHkSNjDnlij5cYhv6loEmd/5dDRVHJr3dQ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tQr+ddgHCMZjoMvlJCyYte82sRNQTXy2yglgIPXxYD4dHPUcgR59Cm4xRXUSc8eZ9bPL2LHNDWEFwm2xO0cRiFYVBFQY63jKEhH8szBxptugcmMV1DAY60T85f+08Ivn3pcqvP7a6/e7058yjIub9xIkW7/oarEtFvL3li2lpoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=G2nyqixh; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="G2nyqixh"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id DgOuvDUzmjzfwDiEfvRhFy; Tue, 28 Oct 2025 11:51:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id DiENvag8dE0qRDiENvnIlC; Tue, 28 Oct 2025 11:51:15 +0000
X-Authority-Analysis: v=2.4 cv=Q+3S452a c=1 sm=1 tr=0 ts=6900ae45
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=NZv-JJVNZ7gp_QotK4QA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=TqfalvD4g9sDc+z5rGZ0llaKTRI0iEvZ6aTIlcxMI5w=; b=G2nyqixhdhPKwMyYZCJCmM8rfS
	stM6e6BbjioVpcXHDdpBAZngKokN/fe2f6orD/pe3R9nOrNXOpzktcjgeYhp5j1JsYmrU8EhlojXS
	zdSJUbG4puHaBYSyCfTrCO7y6UZaGqfYE3NSHk2KjBCkPNVcmCr5exH1SB9wez4F1MVoShYOSPf0w
	/gPcaFmPmDeZfFxK3q9w9VftsiId5Rk7CkWjPSxWPgfk5eW0Xuc0TWy+lwVs+QTBB2iSd7b4HNVN2
	uWhFamFNPFyARSI0XgeEwZtRTW2VspkUWpEp2xUamXtu6Ars5VfYxSvD9iRwO1gSKJSqIybTiiDIM
	cmycKbbw==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:50822 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vDiEM-00000002Bcj-3nEJ;
	Tue, 28 Oct 2025 05:51:14 -0600
Message-ID: <a53b3d74-4566-4505-9a3e-7584a8e78f2e@w6rz.net>
Date: Tue, 28 Oct 2025 04:51:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/84] 6.6.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251027183438.817309828@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251027183438.817309828@linuxfoundation.org>
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
X-Exim-ID: 1vDiEM-00000002Bcj-3nEJ
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:50822
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfP9nr6WvZIFnBugedXxmKzI314xfxWhNIb5HVAT4NCIScJXfEsaV/0qR7zIEmng4u7bqqP+qm0oxMcO5jbu/mN/ApqiM78vPT7H2WUmN5Te9TtfHJbt5
 4CtkBwc5zITesapC6CU5WU5UBnjEvhXGYA1Ttvb8U6xqf3u1NUQzs6SN8o6btyQaqlw1yALsUFKmVg==

On 10/27/25 11:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.115 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.115-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

