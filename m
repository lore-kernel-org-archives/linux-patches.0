Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E444B4411
	for <patches@lists.linux.dev>; Sat,  2 Dec 2023 02:40:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="QzS/a9D0"
Received: from eig-obgw-5007a.ext.cloudfilter.net ([10.0.29.141])
	by cmsmtp with ESMTPS
	id 9BScrSeZKjtZ39FvjrFffA; Sat, 02 Dec 2023 02:40:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 9FvbrU09OqkaT9FvcrXqim; Sat, 02 Dec 2023 02:40:24 +0000
X-Authority-Analysis: v=2.4 cv=bY547cDB c=1 sm=1 tr=0 ts=656a9918
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=e2cXIFwxEfEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=uOIN_qzTAUQ1CVH6syYA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wecCP6qWyg0CiDeCAcHuomYTctD0knb+GmZrYJf9CB0=; b=QzS/a9D0bn4y8O0QKOFKaAn/sS
	htY+otFCIJ8Z2RQ6RBhEJLf2OqullQyj8GWaZ3fsca5QO2u/6YokSI0nbvd5JZWWbugzEXwg72StN
	vHU/Haan+vSYINRF5B8VVSM1mO5iA51EyZGUEWF8LTF4rUk+ARpQ4gsLo+UeHkatcNByf/t0MfQsx
	CJXSNPkVXcv/25aqR+Njg3AryCICjkSuZAg4yiX8dpnRv47EmtvJrFs+MF5qy/Fk/dSJYm6iXjNlj
	xPcCm2cVsSzbDBLutpWQ+yKsj5FTEFBmhQHB+HXT4Snc4VgRLjuXkIKxF1OMc/gw8YetPEgqQ00Oo
	w23TKQmw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:57994 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1r9FvZ-000Os8-1R;
	Fri, 01 Dec 2023 19:40:21 -0700
Subject: Re: [PATCH 6.1 00/82] 6.1.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20231130162135.977485944@linuxfoundation.org>
In-Reply-To: <20231130162135.977485944@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <7a0c1245-0868-4804-0c81-f7558d4ed40f@w6rz.net>
Date: Fri, 1 Dec 2023 18:40:18 -0800
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
X-Exim-ID: 1r9FvZ-000Os8-1R
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:57994
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfG3+/NjjecMkaTJkLzNc6F7kfiZG+uOFm5mFczbhuBW9oQlD/H4BumPs1gWGAUt+Bb5fm8IJBlOWT1Oq6NBFjKZhvGNwZqXFSiergvcSiKWxKfiZS239
 d2Vhsppia6exdhtRnP48nBVNGUBMe/bq6pbCFRh7CO/s1kdoPTqhQu69Zpk1m7NxLu6XHoZl5ukqRg==

On 11/30/23 8:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.65 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

