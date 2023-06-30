Received: from qproxy1-pub.mail.unifiedlayer.com (qproxy1-pub.mail.unifiedlayer.com [173.254.64.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E2ACC8DF
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 11:48:23 +0000 (UTC)
Received: from gproxy4-pub.mail.unifiedlayer.com (unknown [69.89.23.142])
	by qproxy1.mail.unifiedlayer.com (Postfix) with ESMTP id 703ED8030656
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 11:48:23 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
	by progateway6.mail.pro1.eigbox.com (Postfix) with ESMTP id 378BA10049554
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 11:48:17 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id FCbpqnAPH15GqFCbpqLuK5; Fri, 30 Jun 2023 11:48:17 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=YJRadTKx c=1 sm=1 tr=0 ts=649ec101
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19 a=IkcTkHD0fZMA:10:nop_charset_1
 a=of4jigFt-DYA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Jrc7CLIahwlOR-p7YVwA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=1DOgCVW2Sy9RjweoOq8OKyvquk4jU3/8rXFrYWqMJlQ=; b=hkhUtJwcnuC5oTV06OfVrZhdB/
	2IZYB5M85obFu0VAQRrb6X2tDQ6e6eQfIIF361zmGWWaXqdVUaFbOx0LJiq8q0KFGJrhS14s2BUoJ
	yWpo5KdH8Fjio55q2rt1n9FtiUXRQvCethi+FGLGF/Tt3MpNOVFnrmaYxDiMo9JVtmTSfczTMDVl5
	Sz5zzW34Fzh14SwU4yZwiD4S5AmUyZXpSWzENyBhdAUY0ZmBKDRSz2zxHetzn99TFnJ5smJrZo/wo
	u+y+khxW3NynwHasTX2tijozNpPpJnjvPGgd2KYAHSRUtKMNtKL1mCFVgoTOl1tjCYmKHS/JTSu0j
	o5PjH7eg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:46134 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.95)
	(envelope-from <re@w6rz.net>)
	id 1qFCbn-001w2W-Sx;
	Fri, 30 Jun 2023 05:48:15 -0600
Subject: Re: [PATCH 6.1 00/33] 6.1.37-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230630072124.944461414@linuxfoundation.org>
In-Reply-To: <20230630072124.944461414@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <87618009-e6f3-4267-401a-85e29a5b9bbd@w6rz.net>
Date: Fri, 30 Jun 2023 04:48:13 -0700
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
X-Exim-ID: 1qFCbn-001w2W-Sx
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:46134
X-Source-Auth: re@w6rz.net
X-Email-Count: 37
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 6/30/23 12:32 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.37 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Jul 2023 07:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.37-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

