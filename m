Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D9C863AD
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 07:47:52 +0000 (UTC)
Received: from alt-proxy28.mail.unifiedlayer.com (unknown [74.220.216.123])
	by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 7AE01802A319
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 07:27:17 +0000 (UTC)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
	by progateway1.mail.pro1.eigbox.com (Postfix) with ESMTP id 110721003A121
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 07:27:10 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id EPa1qWxN6xKeeEPa1qCY1v; Wed, 28 Jun 2023 07:27:10 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=NvUUz+RJ c=1 sm=1 tr=0 ts=649be0ce
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=of4jigFt-DYA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EQbkGBY0Drc2aUyH78u9WpO5Y+VD/CrnpeIbXLGwLqw=; b=sZJJ5PDyGD4QmwN3GWko5Y3vXu
	rVKgzaO5Ya4BX6ksQuWFly0dql3FcKC9PZwzoGbiXJXb2VtOpFToOJbyx4/P3CrBwITXKMciDsgnM
	f0xKq+fH86rYFFI2Xy0XCB+xf+SzemkNBViKZlByVX+QCuKQyi8BAz0ksbnsSjmueedsXK/5tQnXz
	aLl2RWMJOHmPF/5tWdv/DzMZdRtF89JF9sLU7O1QYg/SYdeDd0aYale8ZuztqtbucqVFeyxr7m6Lr
	YPgoBS7lBgNUSBfMipzSFo1KKiptRBfhCJvd2r+yT0ic0dx0r7TvsCxtaa9VRG8DoyxoNpcn0sMkW
	ElYw9+zQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:45726 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1qEPa0-003RMo-Fx;
	Wed, 28 Jun 2023 01:27:08 -0600
Subject: Re: [PATCH 5.15 00/96] 5.15.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230626180746.943455203@linuxfoundation.org>
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <f7b841bf-0edd-243a-38aa-2213fcec3ec1@w6rz.net>
Date: Wed, 28 Jun 2023 00:27:06 -0700
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
X-Exim-ID: 1qEPa0-003RMo-Fx
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:45726
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 6/26/23 11:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.119 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.119-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

