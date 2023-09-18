Received: from omta40.uswest2.a.cloudfilter.net (omta40.uswest2.a.cloudfilter.net [35.89.44.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D866AA4
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 11:20:14 +0000 (UTC)
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTP
	id hzQJqrPYAbK1ViCISqyFD5; Mon, 18 Sep 2023 11:20:08 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id iCIRq3mGbXyW8iCIRqhNoM; Mon, 18 Sep 2023 11:20:08 +0000
X-Authority-Analysis: v=2.4 cv=IfeU5Ema c=1 sm=1 tr=0 ts=65083268
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
	bh=A8hhA0xKOrAuU+Gm1IuefMwmNPbEdpwZ1JE6l7dMRg8=; b=DFBY+heH+LMU75a+xmj9w6Sejb
	QwTxWXQOcFqiFoKG166jcSsvjsUjr3GDiSsyx6WbbtyNazzSHdeZWpQammM3UnuFzmxLnwia4WzXn
	2psGeYpvsDrOo/OnIat5DKyIXlhkJy6ipi5tzDeWUvvzolQHZsEeouK1778dRGx+eb4L69a76osH4
	Uq3mkNOEfy7yHP/fi9T27KIPaKrLeIGfKhqTcwtb/Ff55vBVVly5vq/XwfTPnaWF2G69GuAcs34n0
	Yfe33nZlulaITZ8haM+22IMp2jfZ6rJ98mxYd0yAnwiJbbWceePkXuPyaNTuPMBR6SOvWx29o2X2X
	FbIRSZbg==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:40824 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qiCIP-000Oa0-0c;
	Mon, 18 Sep 2023 05:20:05 -0600
Subject: Re: [PATCH 6.5 000/285] 6.5.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230917191051.639202302@linuxfoundation.org>
In-Reply-To: <20230917191051.639202302@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <01385204-3046-cc93-7e49-6d9c0fe4ad1b@w6rz.net>
Date: Mon, 18 Sep 2023 04:20:03 -0700
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
X-Exim-ID: 1qiCIP-000Oa0-0c
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:40824
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAho8VweZIOVJYeQSHppRobHi13myX+YUGSY9YYPhlVPhczBsNlpGVHCS1I7jVT/N04CLqF2FowPTZMINyWH0vReuodoZApdSYYJGYvMRLqDzP4KWRo1
 m2V4KZfs514rlarwhgjYy3FKMCjwOGzFaLeT0Qq+c8TqPLACfOtUnxTXkW2Teu1FwLTlJid5ukbFxw==

On 9/17/23 12:10 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.4 release.
> There are 285 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

