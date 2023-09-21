Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B043B641
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 12:46:40 +0000 (UTC)
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTP
	id jIuvqZVV7OzKljJ4qq0lgN; Thu, 21 Sep 2023 12:46:40 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id jJ4pqqBe4FuBujJ4pqgFFn; Thu, 21 Sep 2023 12:46:39 +0000
X-Authority-Analysis: v=2.4 cv=UIrOoQTy c=1 sm=1 tr=0 ts=650c3b2f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=rCapCwsGvWrsnXoSlYYA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=em6GeVMRXGnfAAqIJ8yFcySD56AuEtqV2uspgTAC4BU=; b=Fu2CCDWAEVW1Bj4p46f4l1ir5s
	XRuLU3xCpKarrGS9ROwiokLrDqS4hB3Fcp+IM98td7BKMZlxa4tL8yxebWwWzSiHfg0/Tmn1BGTOX
	xf7of2RGOhKWuBszvmkFNb3L43jp83BdiJlWjUyfUBEpkUr31WMZN8dud87i8zRCBQ54wpDxmuWIS
	ZwdPeLSthfxtvaVuZ7wIHkKQQXLneIm7JFD3tmyFK8TuOgs9f9jSyOjApvrGMSfC/+vA8sIpyrie6
	5HR2jz81v5oe6zAHgzft0Xcs8ysCq/gTJuHHwltYrrWnxuEM0fNMcypulRaGQzFLwr+C1J6QIsHOi
	0tosd/xg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:41430 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qjJ4m-002Wuh-1N;
	Thu, 21 Sep 2023 06:46:36 -0600
Subject: Re: [PATCH 6.1 000/139] 6.1.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230920112835.549467415@linuxfoundation.org>
In-Reply-To: <20230920112835.549467415@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <42af9153-62be-f4b0-8f02-2c281f7e3e21@w6rz.net>
Date: Thu, 21 Sep 2023 05:46:34 -0700
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
X-Exim-ID: 1qjJ4m-002Wuh-1N
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:41430
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHAwZXr45bTApbgsr4cbl4NJZJvd/MrWQ4cn11xI/5yRjzApn6KPWvsPbFjOdJhvtT2nGIND2L9kPFlxpVdDGc2DJO8MJt3E4AREFYGegTk5EC65Gf/E
 NMHL2hyNCqG/n0BeXoU3qSk/cdU1HpthyJNi0WRvjay9ytg1VvK7CKcjlPIoXicABgFMllyRGMXPWg==

On 9/20/23 4:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.55 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.55-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

