Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A782020EE3
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 23:56:12 +0000 (UTC)
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTP
	id YUuBqW19eWU1cYbEDqKcYb; Tue, 22 Aug 2023 23:56:05 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id YbECq4IRdSCfdYbECq9a5W; Tue, 22 Aug 2023 23:56:04 +0000
X-Authority-Analysis: v=2.4 cv=M/1elg8s c=1 sm=1 tr=0 ts=64e54b14
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=UttIx32zK-AA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=EQwu3T12zX-_ASVHoRwA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=sHXcsrcQ2JX7PaJS3xNaWPJAISzumo8tG3P7erCaBfI=; b=Umscmz2J1uDsZ0JCtM72gWzEDo
	b5rSRI3K/GkdBEDbVtGo626Ksn2M/bBklkIUiArBVIcNZcWkDEl4Nq3nrRjgvj3Tn1faEuIFCC9KH
	h5xYpKjCsFaHTHDUUk6V4VdC0hTCWWoT7RbM7s7qLUFny2Ez9mCfl+v0BxRpzNIj56Ho9anLPqfYC
	+DnozoHT/MiOn02+wyNQfpKIzIGNxoPzNw+YcQzBLuPXdfxKSznQZjMbzflTF7bja+h6ZwOO8NOrl
	4lI/qK1Nl2/coqQjxdYMglNchIOaJygDJX3mV2qIAgSGNX5vBKPBRnJByMMjhgefsTOIq+Yt6HdyA
	CxbXguVw==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:52760 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qYbEA-0020jC-0A;
	Tue, 22 Aug 2023 17:56:02 -0600
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230821194122.695845670@linuxfoundation.org>
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <65a9032d-6083-cb4d-78db-9d4e77292fd6@w6rz.net>
Date: Tue, 22 Aug 2023 16:55:59 -0700
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
X-Exim-ID: 1qYbEA-0020jC-0A
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:52760
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfETrmSg8EQfCdcdQ0g5uajSeYdJd2+CPwKpdYkwpVyJrdVzXog07EEAa/9YLoWr/natmzJbEv5t2QnPIQS1v36Sek1pEUK2Uk5X6dhYFZsOZ4vCBj91x
 pMvJi0KJmltIpjjoMCdLg0UHVwOb0yZYBa/p+Ev1NW/VZnVpZZZEWHVzjW1Mm9UyyK1/NaHJA1BxEA==

On 8/21/23 12:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.47 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.47-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

