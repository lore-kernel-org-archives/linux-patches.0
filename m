Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01EFF1DDDB
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 07:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712906587; cv=none; b=C2/ZyoxFKkXqeL8ZBLW48PPE/bNsmrIB7X5wotfieNKtdBLe+tSWrUzfDaOObfqyarV0AQhVMOlNJHx0suqJnNyMhiiY9w81RbuBkTej2JpYgCPFiZd4SHX/AC5K0vPP9Up8/3csIcKgk9MgRDugG4ir83SGII3oRPXeCZZPa+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712906587; c=relaxed/simple;
	bh=tnaRl+07TgPNaGLo+DMettk+/ANxlkVqGBES6qrN3rE=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=EtWw0RFjOk/+V6AYq/n9x8zSo2vHPEMXxohp/QgLolNd1+0EtG7WaocTg8h7iK6Puh8Vg1Jv5HvNmFnM199jxUy6AnqJNoXeTgI6baJbTe5/+u+VvHYSAnYYw9fjEBeKhymEsKBfrcJZgmzEdQVjV68w4n8VrCzrS15aNRldxP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=3SXozjj6; arc=none smtp.client-ip=35.89.44.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="3SXozjj6"
Received: from eig-obgw-5010a.ext.cloudfilter.net ([10.0.29.199])
	by cmsmtp with ESMTPS
	id v929r9y6pPM1hvBFYrSyLm; Fri, 12 Apr 2024 07:23:04 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id vBFXrect3o82kvBFXr5VBw; Fri, 12 Apr 2024 07:23:04 +0000
X-Authority-Analysis: v=2.4 cv=WOB5XGsR c=1 sm=1 tr=0 ts=6618e158
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=raytVjVEu-sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=iIpkR4LGDAw3iw8gTDEA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yZD0awkJFXsV5uZNAbcQfgoU9HCUbLss4TtVwqSAO6k=; b=3SXozjj6GAL1BL/mE9iENQxSnl
	l1VD38fpAhu/UohZkwVRsGHz+4+TSpARgj45GKh2dcbfifhmxkAxc6osf2w81xFCCrMUznoD50W1O
	JNLV1p5F5/EPRm2AVVZMXlCyj0dUKB3zczjC1mzhHNKuQR9E8/oUsc4ZKn2cWaZXkl8/lrUlq7fuL
	CFeYkkWGxVUz8tlf+IVbuEEgvSBCgsEAnn3XaIkWHZFnjFqvrn0IVI/qM0+1O4jGt2RbGDs27DJbB
	29sHMR+9er58+3gdRvCyThVYhOW5hU9KX2Lm/oyp0DH9scY2BCkUpateDoMA9mPHl7SEsh38owMxW
	oLRVeLKA==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:57252 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rvBFV-0021y3-1E;
	Fri, 12 Apr 2024 01:23:01 -0600
Subject: Re: [PATCH 6.6 000/114] 6.6.27-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240411095416.853744210@linuxfoundation.org>
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <07aa3df6-ae22-282c-0a81-8fe63328318d@w6rz.net>
Date: Fri, 12 Apr 2024 00:22:53 -0700
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
X-Source-IP: 98.207.139.8
X-Source-L: No
X-Exim-ID: 1rvBFV-0021y3-1E
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:57252
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfBLIWFQdoezznwJDfn1Gzum16LDHVaqkCXG+zBzbY+QFj7meoPhkgUChNu8GJmtsjSVyYHkCVB0HHFGYhrQ+JwtdnBxLoKFcuU9eCzKtpCQEThiFxebA
 GlUfiezM82c4LyAadlfBsmgVqwptuXglDat1kLQqsm6OFUVBDu95j8WwSCeeUx38dW+w+yz09pUoPg==

On 4/11/24 2:55 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.27 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.27-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

