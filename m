Received: from qproxy4-pub.mail.unifiedlayer.com (qproxy4-pub.mail.unifiedlayer.com [66.147.248.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABD117E
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 00:19:05 +0000 (UTC)
Received: from gproxy3-pub.mail.unifiedlayer.com (gproxy3-pub.mail.unifiedlayer.com [69.89.30.42])
	by qproxy4.mail.unifiedlayer.com (Postfix) with ESMTP id 28F048031E77
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 00:18:51 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
	by progateway5.mail.pro1.eigbox.com (Postfix) with ESMTP id C374C1004879B
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 00:18:11 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id 2i8ZpX0NhyUFk2i8ZpcxTI; Wed, 07 Dec 2022 00:18:11 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=NqUUz+RJ c=1 sm=1 tr=0 ts=638fdbc3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=sHyYjHe8cH0A:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=BpW2NQBi0vgZac7TTMQA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=NOCCwFTyFkLjX0u+9IH9OTfhBbB5po8gUHKlpXTdq6s=; b=S5l8Weqha56rSg00mMFBMRnhJ3
	EL43rPJydrTlDE1FFiIzWTfwh9IsE/8fO3F1+JcYH8b9OY1zpYxv/u/207uPuX5A0ihifs9IzQ317
	0KW9FyGw0EPf+AaPykf/VK1YHRnDMWcxAtJH5IVS83HuLvnc+g3S7a0ewHhBymGRbKbS6forszTiL
	IvhM8kt0DgjsQR2q9RMGYnutiAcskQhPTD6D1EeFeInqJvr62qn1ldSNBJKPN1P9AWD4UI9N0aHew
	DiNPXWwV426FrpFFnMnVVdQlcqNuiFn+crD2VTI7BdsKdf6bHJiatGGwI/7oC+9GKKFIJVJygHynB
	mnEqRWsg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:60442 helo=[10.0.1.48])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1p2i8Y-001Oi5-It;
	Tue, 06 Dec 2022 17:18:10 -0700
Subject: Re: [PATCH 6.0 000/125] 6.0.12-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de
References: <20221206163445.868107856@linuxfoundation.org>
In-Reply-To: <20221206163445.868107856@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <99dbd486-53ac-9f02-35a3-3b15e49dbe5a@w6rz.net>
Date: Tue, 6 Dec 2022 16:18:05 -0800
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
X-Exim-ID: 1p2i8Y-001Oi5-It
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.48]) [73.162.232.9]:60442
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 12/6/22 8:39 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 125 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 16:34:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.12-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

