Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3217BA58
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 07:20:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="MZDIXZHR"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTP
	id q71Eq1OWQIBlVq72Oquw8a; Tue, 10 Oct 2023 07:20:16 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id q72pqsTtPPEE7q72qqbwRV; Tue, 10 Oct 2023 07:20:44 +0000
X-Authority-Analysis: v=2.4 cv=XuHphHJ9 c=1 sm=1 tr=0 ts=6524fb4c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=bhdUkHdE2iEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=0qshdgB/R9zP+1e6Mf1kczdXW1Eciz/zqHIMnxxTi8c=; b=MZDIXZHRhImRkpsH46nKinGw4c
	Rv7ukm+7LwWtQvQQj/z41vWKlLf/NoYI6+1Ua2iDvdXnv9D6e61yvOJdo8CFTma8ONI39XwGxY7c3
	+8I523X7YbCkxl7ZFnKUkWNJD3BXeWUHcTZ4BNP7BfC9FHYJ0kxhq28N+gB9kHYEePOF1fVgl9GpE
	64fRnjSvhGUQGV+rtFWopkgMZQTqQj748E1M3ZgNfoFwDOXAlIGimpuqnZM93Ls7FfZy+DNnlj0dw
	hlM6cPrrXptqCmRTeOK6LiI9mKqKDC0O7Jim6zk40jxkn1QeLHAwq/JSZbpLLynq0OjYk1ERawndW
	u+BMTEXg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:50760 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.1)
	(envelope-from <re@w6rz.net>)
	id 1qq72n-001M7F-1a;
	Tue, 10 Oct 2023 01:20:41 -0600
Subject: Re: [PATCH 6.5 000/163] 6.5.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231009130124.021290599@linuxfoundation.org>
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <41ae75b5-5a40-3db4-748c-fd7cc766742f@w6rz.net>
Date: Tue, 10 Oct 2023 00:20:39 -0700
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
X-Exim-ID: 1qq72n-001M7F-1a
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:50760
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfNBtBclSCLcubGg4GytyzytXbKnu5tIanr3AJaeFRYQyZ6f7w6I+2uny6v106iGEnOBaGLaM/Wt90/9GmKjd8cmQHgj1sCYwoyiL7RE9+Pq2pUnax7F/
 2V6Gfd7yKwfJNLm91/b7eTd4PC76uyp7BnZ0JT72/xgIOOsMvQV5j1s0GF3f4gjtIWvJ0OF8N2c4ug==

On 10/9/23 5:59 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.7 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

