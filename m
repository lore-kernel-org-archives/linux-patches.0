Received: from qproxy2-pub.mail.unifiedlayer.com (qproxy2-pub.mail.unifiedlayer.com [69.89.16.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEC6625
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 00:34:37 +0000 (UTC)
Received: from progateway7-pub.mail.pro1.eigbox.com (gproxy5-pub.mail.unifiedlayer.com [67.222.38.55])
	by qproxy2.mail.unifiedlayer.com (Postfix) with ESMTP id 104BB8026A55
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 00:34:37 +0000 (UTC)
Received: from cmgw15.mail.unifiedlayer.com (unknown [10.0.90.130])
	by progateway7.mail.pro1.eigbox.com (Postfix) with ESMTP id EF74A100410C5
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 00:33:06 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id VhzeqlUNSC5NcVhzeqvwsU; Tue, 15 Aug 2023 00:33:06 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=cqleL30i c=1 sm=1 tr=0 ts=64dac7c2
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10:nop_charset_1 a=UttIx32zK-AA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=CwsDGA5IroMrxA3cASu5U/pFnULDnascIEBYb30F1QM=; b=j7kWztBUJCjt0wdDgw9p+oYVms
	iil7xdsN50pnROoRsEz6BEBd44EuxZ8he5bIYZDLiHaaPDBu1jxy//F3lBYuYfLtjSOOLT87XKDLJ
	A1qqBwzceJWZjUkHa2t1yPKFfhZW1/Yr9MAP8llYo8Og3SGoVANxYj2eK4/RTgNvMIpem1sS5I7Qq
	d4c3+CLPKNBntvh6KFPUFfFuJKzUHOhkBLqzxpIrV4lIoO7s0pN8bK1sn8jo6V/jTWPk4B5u62oGc
	NZA3zthCtXXtwLoKGNwztfEwd35GgpfXihOF21oC3MpM1WuFDJcM1Thl7NNCLOZK7oZgJxJMg4atz
	89mCQ+yw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:51862 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qVhze-003hDM-0L;
	Mon, 14 Aug 2023 18:33:06 -0600
Subject: Re: [PATCH 5.15 00/89] 5.15.127-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230813211710.787645394@linuxfoundation.org>
In-Reply-To: <20230813211710.787645394@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <e07ef4f2-bbe8-3290-d10b-c969233f54a8@w6rz.net>
Date: Mon, 14 Aug 2023 17:33:04 -0700
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
X-Exim-ID: 1qVhze-003hDM-0L
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:51862
X-Source-Auth: re@w6rz.net
X-Email-Count: 37
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 8/13/23 2:18 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.127 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.127-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

