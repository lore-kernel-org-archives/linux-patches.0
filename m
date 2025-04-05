Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD061CA81
	for <patches@lists.linux.dev>; Sat,  5 Apr 2025 02:33:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743820431; cv=none; b=mtGYnQQqF+Fop41LbbKPO2nm7RnZaKbPFf6DfpYCPVWO1vy4FLZO7p9EbwmNNBAB2Ehsg5DVeeEMhVnLgg1o3SW1qX0bY8s6P4u0X7R+oxSa3Nb+7rAqfQVXpWFuJlssdNIQtQ3Gz1MHbDmTpzlaD5z/vKbnKq6HO3uTssq3abw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743820431; c=relaxed/simple;
	bh=I8uvn4WY/+vMALnYlWhpp6p0Y4qVPa5pt8h/vT7Ij1I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PBpPWZqsuRImx2ePHtVyvCvE1phonANYWs7CKTH4cKEm06pBXqqE2CpCWLt2lcpoC8lfwm0REYyDQhNikFfMSuod8e4fRHA7xbY9oe1enW4JOyGZv7XkGvNbHwmOgdDHv/6uJq6iueNpoD/WT5Me/urK5t+oF1peZB0UccZZz3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=XZeX1G/B; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="XZeX1G/B"
Received: from eig-obgw-5005a.ext.cloudfilter.net ([10.0.29.234])
	by cmsmtp with ESMTPS
	id 0gcduGLY7Afjw0tLwunLLK; Sat, 05 Apr 2025 02:33:49 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 0tLwubhfzq3CN0tLwuHiOz; Sat, 05 Apr 2025 02:33:48 +0000
X-Authority-Analysis: v=2.4 cv=VpfoAP2n c=1 sm=1 tr=0 ts=67f0968c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=CTIpb7JmY0c5bVNJeN8A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9jg908sd79yyPAeoc450hkP/QBwbmDpq9MxRNa/8FY8=; b=XZeX1G/BltX6cynHRyRsJImCDo
	qgitfZB+lB+fzSTEAN4d77jBOVCV5k4qmB6RtbePUl0gboDxpVzWLYF1XSSOrZGMsUs0wDDQRODxR
	fEfvob7DuJ0uoKxm8ytOSfB3tWdfqHmu9fZba3F6YACfGxZdHyO7uOy3V+qotrO04UqB1Dn4RWLS6
	MjZo9FjXJKiuRs1TOYrZM5aRVT+yeQPyi2d5Tg5siOWTPTLu9FZpb8jYlZYUIxqd4mrW5STgP/SM1
	XaAvgPTPbBpY/ZdZCeVBLV2fTxfKO8Dk/9hcxbKuP0aAB9mOmMjWnvk4lq/G7AcJsw/4s0I7dRQJW
	J59x8mTg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:50074 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1u0tLu-00000001ebZ-0Dvo;
	Fri, 04 Apr 2025 20:33:46 -0600
Message-ID: <dc1025fe-346a-47b7-ae9a-b17966bc747b@w6rz.net>
Date: Fri, 4 Apr 2025 19:33:42 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/22] 6.1.133-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151620.960551909@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
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
X-Exim-ID: 1u0tLu-00000001ebZ-0Dvo
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:50074
X-Source-Auth: re@w6rz.net
X-Email-Count: 93
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJJGKODPnAkOa//v1nRe+0HbomFXeZZ+zD2HWux7vlf6rsjUcARaKzWOWAtFccR1Q9OuoguGSNaz3Ngfp6gbSrDwQEAqgtR6El2RPGgdamncaeYUQ6Wq
 BkDnlcer2iEqaFaMWD3Es1R7xvz3sg5/rpiH6QipquJDA8xWp0bG1Rd23vFOTtB1j++TpFBcTvAE5g==

On 4/3/25 08:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.133 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.133-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

