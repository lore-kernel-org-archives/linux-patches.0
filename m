Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A307A63CC
	for <patches@lists.linux.dev>; Fri,  6 Oct 2023 07:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="hOnZLiw7"
Received: from eig-obgw-5004a.ext.cloudfilter.net ([10.0.29.221])
	by cmsmtp with ESMTP
	id oYGBqjmSdNWIeofSEqcu1O; Fri, 06 Oct 2023 07:40:58 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ofSDqNXNtjvqiofSEqHHIR; Fri, 06 Oct 2023 07:40:58 +0000
X-Authority-Analysis: v=2.4 cv=NvvCzuRJ c=1 sm=1 tr=0 ts=651fba0a
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=bhdUkHdE2iEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=YcJi3bqNH6bkEmPYLxo90TV7ptUeIFEJk920krE97ak=; b=hOnZLiw7X8Bb6pC/jbT1yeRE7q
	OdYUICShSGekSYxy+WFAuVZ8CfTt0SQ3eLV+JjIvgJIvH+SMb6bcRn4loL6HhV1TxUhw49mJACM15
	AcHmfdgDkFPtmX4bRdpfO54s8w71JrVIqVOihPK+lfBX+vOJYvQ7OxSvH3uKtSPj8pIS7zQTPa5dr
	5W7FgWwq1jHLTVt1wgX5aS5+n+/vMAkycF48H0NBN0nsxE9sOp7xcKs9UMsr3jT7mBGkKR5FHzwFe
	FEl0RWYxjnBVIvAQ1XPKABhZw3NiF73CWJm8tlDytARSdpxJL3CU1dXYbHABYOm6JqlVdsBIjV4IL
	zOOHFNhg==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:49394 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.1)
	(envelope-from <re@w6rz.net>)
	id 1qofSB-000jnz-1k;
	Fri, 06 Oct 2023 01:40:55 -0600
Subject: Re: [PATCH 5.15 000/183] 5.15.134-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231004175203.943277832@linuxfoundation.org>
In-Reply-To: <20231004175203.943277832@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <63be6879-82f7-d925-856c-bbfdfbdeb263@w6rz.net>
Date: Fri, 6 Oct 2023 00:40:53 -0700
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
X-Exim-ID: 1qofSB-000jnz-1k
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:49394
X-Source-Auth: re@w6rz.net
X-Email-Count: 20
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCMtcG6+/CjzQ69Zk1q9sQVs5XG09iDYJtzIKA4RnYwGrkHTniJKs645SPhnh9ToZaoQqcw3WWBQ8D7+m1gYxR4mrv/JglaF5+u3cVNy98zvgkbDLJmr
 MFZ9G77R6CqPnUxbjiIjoFP4FMl80964s1JcvhNh7+3hhWCjUV0CNniIL4nvG/Mp6G4txXAXY/KLgA==

On 10/4/23 10:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.134 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.134-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

