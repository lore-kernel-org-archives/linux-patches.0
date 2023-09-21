Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3AC41947B
	for <patches@lists.linux.dev>; Thu, 21 Sep 2023 22:05:28 +0000 (UTC)
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTP
	id jJb5qmC6IEoVsjRnWq5ecF; Thu, 21 Sep 2023 22:05:22 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id jRnVqjgXDlyTbjRnVqAZvJ; Thu, 21 Sep 2023 22:05:22 +0000
X-Authority-Analysis: v=2.4 cv=ZKLEJF3b c=1 sm=1 tr=0 ts=650cbe22
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=tuAibXX7h5CehZDVqRsA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YhX4KR0WZD1WV9f/+WG1hlT8wpCXaTUz8WOm0ZSiSSg=; b=LZNX2Hw9Tm36KsRxaVUHcRQTdJ
	ySZHQdJJe6xPVKgHIkfSduTaVf7cLAKZcec7rdUIdDv+P6kx+IR5eHQW/EBVAAlQikSnZpPtZZZAI
	nYRjpYxkZYyLd04YJBrEasD5Am9wQFa2SuZHsIFZ7YZMIotcxTmPWZJbRzrcmmkFQu45wkn2AAZ77
	nNU1IO3ivW0/Y/dgePYGT161lipNBBRUOFkE0aKcSTofjqYIShGt0zO+GDDqgBLcZ5ipJDK0d85B2
	sXM6CjymdIKmAjgiUafPTrH25pWkNpV7Ph31UDtcQqTK72a2f23P9Y1oRXrmLcygXXA6ljM8HpGS0
	UqxtwWIQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:41614 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qjRnS-001nAo-2k;
	Thu, 21 Sep 2023 16:05:19 -0600
Subject: Re: [PATCH 5.15 000/110] 5.15.133-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230920112830.377666128@linuxfoundation.org>
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <8d73ec10-9847-0174-4a3b-0b6a9303ffa8@w6rz.net>
Date: Thu, 21 Sep 2023 15:05:16 -0700
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
X-Exim-ID: 1qjRnS-001nAo-2k
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:41614
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfF0OgQjg7jQ7JtahLXu5F53WbtMPHsqI1RmBXWroHhLXzL6SZhzusKnCrGLP5+buiDjNJ3LwSUnX3HgGyKh+oFJ0p6FskOWU08IkP0HhrJOsXdizIG0v
 h0eZJcVOdocR68537iwXA+1oHpaJx9oJubE6EpDDb8p7jQabRAnVztGHszjJvL8qRmflQKksjGrH5w==

On 9/20/23 4:30 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.133 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.133-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

