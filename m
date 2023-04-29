Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA472116
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 07:02:48 +0000 (UTC)
Received: from gproxy1-pub.mail.unifiedlayer.com (unknown [69.89.25.95])
	by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 626D08029463
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 06:42:19 +0000 (UTC)
Received: from cmgw11.mail.unifiedlayer.com (unknown [10.0.90.126])
	by progateway3.mail.pro1.eigbox.com (Postfix) with ESMTP id 0330810046C08
	for <patches@lists.linux.dev>; Sat, 29 Apr 2023 06:42:12 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id seHbpjfS1tKr3seHbpDCoD; Sat, 29 Apr 2023 06:42:11 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=DNxKXwBb c=1 sm=1 tr=0 ts=644cbc44
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
	bh=A92Ay4PYWxKKC1XRN976spgfi8NOAbWM1Jma7QjyJ0I=; b=RyHnIl5y0fp4pkM5pQp1ganPEM
	GTM/qPyO/KbCdaBcsmZLswq+jG1vEC7j/Ep1hQ1vAWZueOYKxtFWPODa+uJEZ14Y9VH0Z7gx/1ghv
	tdcd5Q4yKYfGTYGOw2cliYUuIjZzAgsIrR+rDFy5TIkLQHfvuyn2Ya5NMCYUU6uTazofFgQZl0hlN
	w4mujQEVfEFm/EdHlF1u6JLfPn6rl5fJ2LZaNIX/Jfi+C6nSC2nJxrbYgLevIuvNmth5RuvT7+hh4
	l/Ja4YNRI0mBb/ldGqLvLxDPSdBGLelTvMembQ4VSlhpbJjwbT08nrldIuHIb0yln8yDap+Jz+HVd
	fGb9jCCw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:36460 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1pseHb-000XCZ-9E;
	Sat, 29 Apr 2023 00:42:11 -0600
Subject: Re: [PATCH 5.15 00/13] 5.15.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230428112039.133978540@linuxfoundation.org>
In-Reply-To: <20230428112039.133978540@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <3f945e17-0588-c178-a01f-df175b172262@w6rz.net>
Date: Fri, 28 Apr 2023 23:42:09 -0700
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
X-Exim-ID: 1pseHb-000XCZ-9E
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:36460
X-Source-Auth: re@w6rz.net
X-Email-Count: 19
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 4/28/23 4:28 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.110 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.110-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

