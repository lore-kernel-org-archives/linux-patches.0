Received: from gproxy2-pub.mail.unifiedlayer.com (gproxy2-pub.mail.unifiedlayer.com [69.89.18.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8610D646
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 00:10:40 +0000 (UTC)
Received: from cmgw10.mail.unifiedlayer.com (unknown [10.0.90.125])
	by progateway4.mail.pro1.eigbox.com (Postfix) with ESMTP id B3DAE1003FA36
	for <patches@lists.linux.dev>; Thu, 27 Jul 2023 00:10:38 +0000 (UTC)
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTP
	id OoaUqwL4fNWjFOoaUqOkIY; Thu, 27 Jul 2023 00:10:38 +0000
X-Authority-Reason: nr=8
X-Authority-Analysis: v=2.4 cv=duget3s4 c=1 sm=1 tr=0 ts=64c1b5fe
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10:nop_charset_1 a=ws7JD89P4LkA:10:nop_rcvd_month_year
 a=-Ou01B_BuAIA:10:endurance_base64_authed_username_1 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=mdOrbuIhtOySShl96DIA:9 a=QEXdDO2ut3YA:10:nop_charset_2
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=+o6mJHXUL/3m9vwbrVIhvNY6qcHqa0T22htzLIe+8f4=; b=wzE3qDG7xzpzjm8FQv2lxLFW8A
	GqkKcLYli6ok9uGZSOK0pQslH1MYIBs9/mwogou5HfWlIbE9Wy9rhWWKlKd052MtiLO9wTSXRoaoY
	eqPoPD+gAJQZzCvh2pJ2BpOEWTvvgluLvGNHblClta4F0FaAVVfo5dAuxqIFQvYWdfBnxQIGwbkHL
	agO3BEKtLOMAqIWukGOhjx9rYhMcvTSTi2QXj7Ma15B4K+SgUXXhgNDycpIMLgRi+j3MOA70bVjw/
	U5FHIBTamJf0BPaWNIsa847ZZ+aXZfc1B3sFo+mcEVp5dQV152942J4Fbl3t7seiWm6dwKMKSZkfL
	ntNajBuw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:49612 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qOoaT-003tnp-2W;
	Wed, 26 Jul 2023 18:10:37 -0600
Subject: Re: [PATCH 5.15 00/78] 5.15.123-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230725104451.275227789@linuxfoundation.org>
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <89c4733b-3dd9-9025-0359-2d414e4ce993@w6rz.net>
Date: Wed, 26 Jul 2023 17:10:35 -0700
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
X-Exim-ID: 1qOoaT-003tnp-2W
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:49612
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes

On 7/25/23 3:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.123 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.123-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

