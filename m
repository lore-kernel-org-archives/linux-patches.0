Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35663A4F
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 09:32:32 +0000 (UTC)
Received: from progateway7-pub.mail.pro1.eigbox.com (unknown [67.222.38.55])
	by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 6A1E48032F8E
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 09:07:35 +0000 (UTC)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
	by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id C3A1A10047406
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 09:07:25 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id JsnVp8S41iJ4bJsnVpCEgh; Mon, 23 Jan 2023 09:07:25 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=DfLSFthW c=1 sm=1 tr=0 ts=63ce4e4d
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=RvmDmJFTN0MA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=CTAK37LMT9sX1YELjOMA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=fJNKXsf2XCjdUYzXIo2MahyNH27PGpZbn6EGeGemAAY=; b=NCCA8SdTSJPHB/sRVclDxMBGiG
	VmJx4+6wXYvnLJ7JM/Dqv5MWeFzolbpnYQNKCvl4/hCN1PKJfWQg8zPzPI5n5rOzwHCw2ISP+0MmO
	SQYcJ01w8vB2wPIjFhsN8C3f2T1UmoDSnROhBh+zkzOFh90AKJlo8cEcNUgRFmAIPoIdRKehNM2m2
	lvMWx4xnQm6t0aX1c/xQDgG47E915MvmGxunCSX78Ve2K+CAguN9Ik/HH3wVWQYQHK8myKySTPdOE
	xq9KJ7T9Xxwi4L8k22YyrxARaRLbsmpAHswmKD4gNgEJSsjqz599e5KATl0d1+BCZCcJfs0YKqkhN
	cRyLyajA==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:52456 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1pJsnU-002Y1r-CN;
	Mon, 23 Jan 2023 02:07:24 -0700
Subject: Re: [PATCH 6.1 000/193] 6.1.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230122150246.321043584@linuxfoundation.org>
In-Reply-To: <20230122150246.321043584@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <7afd6674-b105-cb77-2260-b93e13e5da00@w6rz.net>
Date: Mon, 23 Jan 2023 01:07:19 -0800
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
X-Exim-ID: 1pJsnU-002Y1r-CN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:52456
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 1/22/23 7:02 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 24 Jan 2023 15:02:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

