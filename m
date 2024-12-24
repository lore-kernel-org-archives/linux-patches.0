Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5751B1B6CE7
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 10:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735035758; cv=none; b=OqEbN+fR/cciyNJnjwSMyamKd031QPEOz00p73wmtQsFZjQ1YUGlGfuHF+TSwBK+tjMUPE+R/BKqKbTEBUPOiB39NbcwzcKDBsnlnoD5Bpxst6n6cO6k3axFO7huMrbGPKEJzsVVFgCLSfgLfX52Ff4TR7H1nlfCKXtS5yZ/Plg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735035758; c=relaxed/simple;
	bh=iv6qmhVOx10htCR0ApHjUnO+Q2jR1zkYG0c34Uez6go=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=e3sEibyEBhDOx+mhO17sGqip3ykgZNrHqXDZIvprPESk7BCxR0B5O4Q1tH8FqKbBRlv5bZG9hJB1YxGXqCp77MLl537BlH9uhTYC83c2x6g4RFoF1FY2RuaZIzm+SgKj3YICGwhTGb/1uyFiqA0oRUiuY5KjoPspK8py6HSOV0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=PWdGl5fD; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="PWdGl5fD"
Received: from eig-obgw-6007a.ext.cloudfilter.net ([10.0.30.247])
	by cmsmtp with ESMTPS
	id Pi81tp1e4rKrbQ23ftHlLY; Tue, 24 Dec 2024 10:22:35 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Q23etqicOgyLyQ23etSX96; Tue, 24 Dec 2024 10:22:34 +0000
X-Authority-Analysis: v=2.4 cv=MsJU6Xae c=1 sm=1 tr=0 ts=676a8b6a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=LfUO8hwaTv4gm19jDO7+bI7wFjcmsetsN79YPn9LJ38=; b=PWdGl5fDScXm1jBtqiIlutklxP
	C18KmqZPmzKZL1b68LutMJ+XCOBJ1XWnJbtMHY2P6icxXzP+cTR7bCQg9UMIexafcVNsbGSUcjBa0
	Idmt0oCwZXs2EzOs+UL/ggq7QRsZ8BbEqmbxmu1tdB7OFBEtFM1DS93s2KhjQBVhDGqm0F7TqPI7u
	WhhqkGEScDyNfgBGXqFxEaoBhu/GEFfYKMRBS4zoi1cZB73ecP2XS/DZ7NKf4Q4PmC95GKjSuvks7
	PGmanPBN3HA2mPVNeXwq4fgO6sBlzQLyw3mXzhSpUgPl/Q+JCXlTta204tm6e63bWJxQbJI+UghPL
	IRfhn4Rg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:48832 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tQ23d-002Rye-1L;
	Tue, 24 Dec 2024 03:22:33 -0700
Message-ID: <eb91e146-4d03-482a-84f3-1c69c2c425f0@w6rz.net>
Date: Tue, 24 Dec 2024 02:22:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/116] 6.6.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241223155359.534468176@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
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
X-Exim-ID: 1tQ23d-002Rye-1L
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:48832
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfP/z+mI8jI6W3rxyezisWDCR2O9SVqUshUhanS2dmsUD7XK7DOo1pD5qrB4xXl+H4zubiLmwzlxoSdFQf8Ciemjy/Crw0fX15PUxokMW72zVuEtUEdyH
 Ymu3OYQcsyQipXjJkg3uSIDLJAthoIW2YbTNpNe2+WhWJ+TQEU8TZldEQepBnZGPEJ6bKXevF0fWDg==

On 12/23/24 07:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.68 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

