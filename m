Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AE1F632
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 00:13:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726099991; cv=none; b=ab0b92MHN37Ve8CdHkWgkgq0jA3ZNLJx/XYskt3o6Zxv0qmDVQiMVHVncC+1Tn4ioVghrI5AaBrED5Zg6OgsLBZo1chuAVyeL01lpPCDcIEboBOp//oR++aNxJociHjfCN7rFso1KOrjL96BF72OZsh0sMGJLDtlJS7K0bMOAFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726099991; c=relaxed/simple;
	bh=0jN5Jl4+HEZ5nZ+VPVRTwXVfctircjGNX3+eQKScwCk=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=HcgBoadLMi7DV63eYAkp/UzbeXIxwyMSV2KIZTZIIsa31iX3dajFmg89zIMAp3rkiu5gIVM0Ubzaqf9Y2xMpKWTDd+jMs2JXJ4z8Y8dUjWnuUMg3/G2Gd97dkNeUM9iJ5lu/9D1/zKlu46KOJlX510S1rK2QkIFGURfcjGzl338=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=UOGZIMEp; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="UOGZIMEp"
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
	by cmsmtp with ESMTPS
	id oWU8scaDFVpzpoXSHsu1PJ; Thu, 12 Sep 2024 00:13:02 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id oXSHsE4xpChpEoXSHsw7tw; Thu, 12 Sep 2024 00:13:01 +0000
X-Authority-Analysis: v=2.4 cv=XdWPzp55 c=1 sm=1 tr=0 ts=66e2320d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=BU-0VEHJLDsOG5B_DZEA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=JPLc/+XFHTUsd4uq9z5D52CThg3h/IkwE9EbBHWYsaY=; b=UOGZIMEpdq226U9lvxOVjcQpR2
	MEVSmFJ6cTCo7R/8yB4sDgqLoCoN/v+NPMprOTpd0TVhQBo+beEP1MOjpix+tk0ZVeUquh9usi5D6
	TgfFCg/nweeeqHOUM48OdKYvYfDl710zYVZsyUH6kbOdpwi12BeAr6OuNddPdhfVed7J3EwTVgSdA
	84+1+JCVgWoEqgglo1gxqLTrB+T3fO0Y3mutU1dy+4EXSfo8U8DzEsM3HHAi98vsFppN7GAveZ5at
	R4cCJMb9VRbWm6eYkPSkCIyUrcaxnQ3RxO2erYCd4Q1iP7uknfByntOLhFaVlwo/N/fKGbl4H+e/Y
	ukMYvKtA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:39864 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1soXSE-002xLQ-2D;
	Wed, 11 Sep 2024 18:12:58 -0600
Subject: Re: [PATCH 6.10 000/375] 6.10.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240910092622.245959861@linuxfoundation.org>
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <7b91734a-8a33-b5d0-2a32-3bca06f1c1bd@w6rz.net>
Date: Wed, 11 Sep 2024 17:12:56 -0700
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
X-Exim-ID: 1soXSE-002xLQ-2D
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:39864
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMzRvuD0Pt1p2dfw8lmhXErPyJVDF8kQRByGZOzXxqgQ1PZAxFa5MbO2+v5MQcbrCoddRsghK4Tuoyy5y48ea5EwwCAYP3+2gR8Oes8PI4LD5f8cApt8
 KBtgkjGP8psc2HBOsxN9zc4Y/vYkzg3Tz8BBkRl2f6FZA4xVHx+H0MKu3ps/Qfn/JaZy7I0mYgPV4Q==

On 9/10/24 2:26 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.10 release.
> There are 375 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

