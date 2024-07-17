Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E67117F4F2
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 13:33:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721223197; cv=none; b=paUs/oZ/5NeGqg76uujxSiJJjH3yKmtjzIaNBtUL7U0GEGY2JQmoRkCdOUE6CmIDIVpHCH1V/+/oYPDqqtc78W3I6f8OU3IhRz+/jGU7gcVNrvf1Ixg8HdZIt3jwivihaClf5SBf7S+QU/9TnK5PXs57QnMpU5fw3M84/0pNfpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721223197; c=relaxed/simple;
	bh=saJ0t+oDc4nyZo9TP1ODjvc4qRIc9gbBenuWUOyq1r4=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=KjFgQexOepoXQbrLP7VaPYLVcEh4FlFKxw8/dx3vJ3j4EvRp4EJ84rtReMWqSSyoMpBS0hA6my7/r+y7chnoAxmjbzlyKNddrb9jiCtS+3FdcFjROEMH9Lc1jpPHZDTj8TaiW7Dw8fMyAsF8Ehy5SDtOvMTfm1lAywuYAp1LRdY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=i83AUpWv; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="i83AUpWv"
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
	by cmsmtp with ESMTPS
	id U3KIsuKwRiA19U4mQsvN5P; Wed, 17 Jul 2024 13:33:14 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id U4mPsQBK5pG2AU4mPsQgyF; Wed, 17 Jul 2024 13:33:13 +0000
X-Authority-Analysis: v=2.4 cv=E6rLp7dl c=1 sm=1 tr=0 ts=6697c819
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=R36JCkTgm8ufyWgcq5suta+RMTXoH1Fj81nG0/VKur8=; b=i83AUpWvsikTcIC3Kaa9l0nNC5
	sl7ZsRcBkviPKRUzyiRPFH5RKxIWj+HtwP/U3eJMNMgSbSq8vt8wNq8SsszeuQx1LbXdOcjj4Ww44
	wvtfkyvsHUWuxP0Ocse4H2Sg+8x+5hpLH+W8+TrzVkvDL87bvPjdhANyKADoHMGVFoDXR9a3Vs0/R
	Tq4pXf6CMr30/PEz3I+WmMXPUkovPh+R/53f1Sf/Nlti8WDRx+MRVZ1xxo8hJChaxPpnWBJqrykZ3
	tt8FgLWjKU1Q8y5lCqBUTVXVAvHV56PkyxeD6mCYbUB2OWoh6NFITX9XWOPH7lGVqi24iPxmZXTDI
	OIv1JFCw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:57964 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sU4mN-000TUk-1p;
	Wed, 17 Jul 2024 07:33:11 -0600
Subject: Re: [PATCH 6.6 000/122] 6.6.41-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063802.663310305@linuxfoundation.org>
In-Reply-To: <20240717063802.663310305@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <29091ce2-7337-6247-3597-e5a0d67753b6@w6rz.net>
Date: Wed, 17 Jul 2024 06:33:09 -0700
User-Agent: Mozilla/5.0 (X11; Linux armv7l; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1sU4mN-000TUk-1p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:57964
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHH2FQfT0TpsMbw6GciKvAvoShsdeQdjNzd41esRmkQe9ylem1exF/sNO5j+143ki3oQV5Fdm30El2bh1n9dCznlYKWyC/u+tLvQB0p+ZzfyCoqGx3q5
 lKxD7XvaBwISv1zmW5abhXBWTqTim0wIpGUOi04f+pRlAz9ZnOKKZozcynqaYMfThN+NSe2B2K1clg==

On 7/16/24 11:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.41 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.41-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

