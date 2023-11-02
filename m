Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95AEBED8
	for <patches@lists.linux.dev>; Thu,  2 Nov 2023 00:55:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="l0tKnyoi"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id xv66qGhehWcCIyLxuq1Li4; Thu, 02 Nov 2023 00:53:42 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id yLxtqDpcewasUyLxtqe4xQ; Thu, 02 Nov 2023 00:53:41 +0000
X-Authority-Analysis: v=2.4 cv=ZpP+lv3G c=1 sm=1 tr=0 ts=6542f315
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=BNY50KLci1gA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=y1/A9KzQdZErrHAMekzb9r7zRRUmKRUgzgMl4Pu2QwE=; b=l0tKnyoiaPJ7Hf4Sd2IyQZ9EsG
	0k2+Y6rJwD2bEdu6iUfnxidADRDV9jmmRTNhKadZmNrVARJoBP6Wgy2bEpk7bF3ZJDwKBSO7OEeDL
	6tfTx4ydVG8K4E0PA8jViHPqMLGYGClzEzQGsNSnE0bANWpQ65gLih06cTHVzFRdoFzIGkij2QcUd
	e/mAGE6Cqmxtd/wGN/xuc5V6DPeSc2dPxKhmMXtGz6e/dNxOmYWcK31q9dYDHpMcpKKpgEwubdCJV
	DMGmUUs0DSj6sUsopBJ76YY1TsDGiXX0gF1qIq42xlOoeIuj7lpN/3m/WhsA1IQ1ITgLHTUmJ16qF
	Z7sohtTw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:53614 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1qyLxr-000Hj8-08;
	Wed, 01 Nov 2023 18:53:39 -0600
Subject: Re: [PATCH 6.5 000/111] 6.5.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231101120147.190909952@linuxfoundation.org>
In-Reply-To: <20231101120147.190909952@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <ed8a6a02-e9f7-0c03-2fa3-08f8f9956040@w6rz.net>
Date: Wed, 1 Nov 2023 17:53:36 -0700
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
X-Exim-ID: 1qyLxr-000Hj8-08
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:53614
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPpT4KisgWqwnFZ4FJtIRZcgIUdiWU5/V75Luz2Ki7hSke0a7b9mI5F1AdFF8+0SHDPS9NMz50cMJuEQbF85pLI6kmL91QMBzScLZdUrNTQ+x1T8mPmq
 g00MnoIs0nAbL+cfyDyXNBJk8IEsBAycVs8zA3FcBeSIE3tw+c0jGLQ0ek86iwo43ihhZmCmoMZHhw==

On 11/1/23 5:03 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Nov 2023 12:01:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.10-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

