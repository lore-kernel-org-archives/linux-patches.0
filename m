Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C934764CC9
	for <patches@lists.linux.dev>; Tue, 12 Dec 2023 21:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="DxRaJI41"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id D7DkrEbVs8HteDAkyrU2Bl; Tue, 12 Dec 2023 21:57:36 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id DAkxrp5dz3WZADAkyrPC4Y; Tue, 12 Dec 2023 21:57:36 +0000
X-Authority-Analysis: v=2.4 cv=c9W4/Dxl c=1 sm=1 tr=0 ts=6578d750
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=e2cXIFwxEfEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0cQHmX4nwYpBrUPThzpHV5PH8SkdWp/17nq7d6ebImc=; b=DxRaJI41o9i6woKLHsgFnIJVKe
	kcubgGaZHaFbVG5btE77TVkdhX0L5blto3HaQeJdVOJKtuwauATmVUb+EqaBimsIh6rY5xkKTiVZm
	nmzriv8avVZtuF91W6igvmvdHz2fxduL2TR+IyPt94jDPSkAopu0fkq/HnN1N3Nbw9g9zsosQi37N
	KNm0N01iojOnTnHafL2kJLVoBPoj+/ksoi0lKnvSPseCTaTkJk6qvbOeyY7d+zr3+QkfhYWMBf1az
	JQU1zfmJSEqTx6s6nVpWlOGDxPh6BBIO60gBkIMXPTQzBKwKdY9u0xCA5qAwveKOLVMZ/OVCo9+Wi
	gOFGc5Gg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:59568 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rDAkv-000sVw-1R;
	Tue, 12 Dec 2023 14:57:33 -0700
Subject: Re: [PATCH 6.1 000/194] 6.1.68-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20231211182036.606660304@linuxfoundation.org>
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <619b9375-3c15-e627-699e-7fb164803828@w6rz.net>
Date: Tue, 12 Dec 2023 13:57:30 -0800
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
X-Exim-ID: 1rDAkv-000sVw-1R
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:59568
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHnD/HZ4iE4BgbJEDPkXopm4FuL0qR1r0eKS1O7UY83dENwvrZbrh7zRrG8ssTUaMe2nTgIdhtyvDHdBxPU2boSEoeOKq0M/0iZbkLouTQ4sMmbGo5uY
 cOv1r5lUMQ47cxQV9zRIxBFwc+4bCCkGALqlGQxnl2yMi5YrmxlF+4/xwgIpjvkvrzHy8dXjIWohrw==

On 12/11/23 10:19 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.68 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Dec 2023 18:19:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.68-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

