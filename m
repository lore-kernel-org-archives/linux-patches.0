Received: from qproxy3-pub.mail.unifiedlayer.com (qproxy3-pub.mail.unifiedlayer.com [67.222.38.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB08C290B
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 22:59:22 +0000 (UTC)
Received: from outbound-ss-820.bluehost.com (outbound-ss-820.bluehost.com [69.89.24.241])
	by qproxy3.mail.unifiedlayer.com (Postfix) with ESMTP id 364EA8037352
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 22:34:18 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
	by progateway2.mail.pro1.eigbox.com (Postfix) with ESMTP id A70E4100478C5
	for <patches@lists.linux.dev>; Fri,  3 Feb 2023 22:34:09 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id O4dFpK6QMx5dfO4dFp0n0X; Fri, 03 Feb 2023 22:34:09 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=R+nGpfdX c=1 sm=1 tr=0 ts=63dd8be1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=m04uMKEZRckA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=9uMecodHOrM1Mh/Ettcy3fDGpdPiW2Q6fXzJRqmojTM=; b=lATq6kpm/nF0NqogvFwOLxtryJ
	8uDxhquvkv8ScvAuV6gCB1rBuweOwmTRS6C6hbZXf0PK5QfoarK0Aw5obOmMK1EvrombzxTWKq6aB
	c5XS3gKgWWu/SSjFzJp3CKBkx2uGv0eZyCDTyRjlNXN9GhB36vvQ/8iXjBhZ2JF3X0/KtbOSMruXf
	Cg+GG1MUJlm1bRlQv5QeSF/HNjJCszNORG88uLO/TDgzUegVgyTMRMceqx2rZVyVzsl8XsrtBQhql
	BFogntQIPODB906eNSigIHJoeAruRXDsDSY80tvu4m0DOtvAtieV/ms2jDB2ua9ePv6XDyS7yW0lL
	X0A7/+Mw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:53436 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1pO4dE-003xup-KF;
	Fri, 03 Feb 2023 15:34:08 -0700
Subject: Re: [PATCH 6.1 00/28] 6.1.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20230203101009.946745030@linuxfoundation.org>
In-Reply-To: <20230203101009.946745030@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <9fc58557-e0b5-02a8-3a18-bfdeba716e95@w6rz.net>
Date: Fri, 3 Feb 2023 14:34:03 -0800
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
X-Exim-ID: 1pO4dE-003xup-KF
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:53436
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 2/3/23 2:12 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.10 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 10:09:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

