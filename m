Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D6671B269
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 12:45:49 +0000 (UTC)
Received: from eig-obgw-6009a.ext.cloudfilter.net ([10.0.30.184])
	by cmsmtp with ESMTP
	id iD9KqVUHyEoVsiDdGqVaJY; Mon, 18 Sep 2023 12:45:42 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id iDdGqnNaBOCehiDdGq7Jtn; Mon, 18 Sep 2023 12:45:42 +0000
X-Authority-Analysis: v=2.4 cv=feK+dmcF c=1 sm=1 tr=0 ts=65084676
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=zNV7Rl7Rt7sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=xRhb3P85M6cqo28jIbgAnU0EHT0XkXdh9sJix+vgpoQ=; b=CLVsyjaYNdycONvuHbeKppPBmk
	B78ygJ9CHiXssHUPt89vhAXF/jCBIiB+/xcNPhStzvvtTZLCGpd81YdxJxZJC1y5HwFSNBDrcw8vN
	s0gVQxuuW5dG+crbnVa1WBs7BE3/fsI1P2JuzSj6FY0cfT2igrYP2M04tWg7gUe7mKt8Mg0H+vG54
	fffu9Lo7rBjvWT8N5rQB3vNweuUb6++Vljgzil9ERQP+J+GTG1m5AJCnhTT8Cez9SJgm7Ycj4cCJv
	z+VrnNr5sBeJHaBzk4SGJQv9PKRSJ+UjCPnQlO0kjrvdynsmTNapZJ+OgNuw4BLQhiJqICgX9XwzF
	NIYj+5mg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:40858 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qiDdD-000zFQ-34;
	Mon, 18 Sep 2023 06:45:39 -0600
Subject: Re: [PATCH 5.15 000/511] 5.15.132-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230917191113.831992765@linuxfoundation.org>
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <e8f55f51-e28d-e27d-8233-f8fcc72c6358@w6rz.net>
Date: Mon, 18 Sep 2023 05:45:36 -0700
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
X-Exim-ID: 1qiDdD-000zFQ-34
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:40858
X-Source-Auth: re@w6rz.net
X-Email-Count: 20
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFRJwMgdu4vhVuYKjCXqWYZ5lCHqVTEkeSiUc0/BlgxwKpXjfgnveU/ukUzQX+YfL6hOYXBmdYF4YM9GkAlYvzyaHdKVxk3ASbnktuOwqm3lGLM0ENBP
 wc175umvGMuLKTTG1fRCZi2aC5KCwium/FrbGZ6VuEu1wW2x/+uYp48CUxU54x6pEmNnBjBBZankLw==

On 9/17/23 12:07 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.132 release.
> There are 511 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.132-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

