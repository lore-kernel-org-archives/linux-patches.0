Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70E385235
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 06:12:38 +0000 (UTC)
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTP
	id bsjfqcq83bK1VbxMzqqDah; Fri, 01 Sep 2023 06:11:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id bxMyqjpgm7NfbbxMyqent2; Fri, 01 Sep 2023 06:11:01 +0000
X-Authority-Analysis: v=2.4 cv=EOMVbnVC c=1 sm=1 tr=0 ts=64f18075
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ZdJvYIG7m5v28Xnbdu4A:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=PESOuoR1J1C3RTuUKmwRTDNd53jx2PAn9GndryMFWf8=; b=xWqPE90k7EnaAFZIe+7iRN5mel
	f2yOuxeR3KcrvQVBhDKW71MnBEVhS31ydL+6VXPkdBvu86xdkgpD3mrmrdhBhp/TwAi4jVcSWU1Sv
	NsQk36iQZNhOVovlisLxo0zZhVqX/cQqT+yPLs64BuBv9ojnDbYOmseKoCEU91GiSItith66h0grE
	IHfE5uZvsNxDfyCdo87BUJ3bS4Yv5fJJjBdKXjT/+PnuJOv+wZnbWmA2gOEVYza0lvshYLcvgAhdA
	zxFxCThiqKedwVziW7MJ+XFAey93wiat7688Lo3DQTASxIB4vWXuqOLq0X4bIlPO+XmcCnjFFumV2
	ajR3/q4Q==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:53804 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qbxMw-003FOn-1l;
	Fri, 01 Sep 2023 00:10:58 -0600
Subject: Re: [PATCH 6.5 0/8] 6.5.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230831110830.817738361@linuxfoundation.org>
In-Reply-To: <20230831110830.817738361@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <8a81cab7-6079-434f-4500-4fc0453fe0d1@w6rz.net>
Date: Thu, 31 Aug 2023 23:10:56 -0700
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
X-Source-IP: 73.162.232.9
X-Source-L: No
X-Exim-ID: 1qbxMw-003FOn-1l
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:53804
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKdHQDOcm49MTOccWwnT793WLpvxXrN6W1g7A+3NsLCOitef4ZtoeNhRKGTK6YFhJpDnAf5s+tcQp82CausoUnTVIql+L8QVWa3hUAtMHdAkBoe5xdTf
 VJE6Aas5Oa5v3KpaUuTyax4+X70qO2w/+wZt/0+2ch7JzVtpQ2ZFfepSBr8ILvQbOkwpN5wSkQ9sjQ==

On 8/31/23 4:10 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

