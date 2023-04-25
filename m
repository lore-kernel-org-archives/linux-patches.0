Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78212A93E
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 21:04:00 +0000 (UTC)
Received: from cmgw14.mail.unifiedlayer.com (unknown [10.0.90.129])
	by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id 0D6ED10042F8A
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 21:03:58 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id rPpNpMTSDIYZarPpNp7ACC; Tue, 25 Apr 2023 21:03:58 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=Q68XX66a c=1 sm=1 tr=0 ts=6448403e
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=dKHAf1wccvYA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=7FJTG0tBB6y0otyCyPnNUcNQhQyKrli8Nxvq5nQGkN4=; b=nxZGohxAnAu7cMDpk2uDm8ElrJ
	vJAzimJkquF5g5zmw6oZsru+YUm0ANtI/AxR6iAMIz58+7hiZLq14xCOHF7uLuinPMFiNu1x1y5V4
	Rva9S5DJr4sSFurg82HvDcUrpOmUupVLmWCAyI2C/y54CKPyB/pcSC5ka9w3ujCym0RdRtjuoL+Kh
	nmUWaUqeXMPALh7Iuy73xBpVdTSkQqiKQyIeEDliOrpUeGUI2ZJfQyCx0Xr8R3n8c+qJNi7Kvdq2c
	MY3TXi649VMc3XZcyXyilXNYSyCP3qU6p8OMt5ytjvK0RErB+ZuW8ind0zb7vdMzSwgCjEhX2K96A
	W8h5ia+A==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:36114 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1prPpN-003lKw-4a;
	Tue, 25 Apr 2023 15:03:57 -0600
Subject: Re: [PATCH 5.15 00/73] 5.15.109-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230424131129.040707961@linuxfoundation.org>
In-Reply-To: <20230424131129.040707961@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <1b632c4b-88cd-ef76-d399-7860626027a3@w6rz.net>
Date: Tue, 25 Apr 2023 14:03:55 -0700
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
X-Exim-ID: 1prPpN-003lKw-4a
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:36114
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 4/24/23 6:16 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.109 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.109-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

