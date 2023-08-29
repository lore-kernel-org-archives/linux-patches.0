Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF8713FF4
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 09:28:15 +0000 (UTC)
Received: from eig-obgw-6002a.ext.cloudfilter.net ([10.0.30.222])
	by cmsmtp with ESMTP
	id amBeqy8xKWU1cav15q63hj; Tue, 29 Aug 2023 09:28:07 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id av14qwqfRjKgMav14qicOt; Tue, 29 Aug 2023 09:28:07 +0000
X-Authority-Analysis: v=2.4 cv=OZuLszfY c=1 sm=1 tr=0 ts=64edba27
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=UttIx32zK-AA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tm0K7vNpALIUKOn5jaC6GAf/ksk2wfE/Y3Cb5yCBJ2E=; b=PGbR2AVPYWBbH1cv0gw2TMZ5iF
	adBusTHV3sU2+e8vhJphO59WS+gTwJ/8vtPlJzGHzLUHEFNCU1Jyg4Sb0korR/nD0T1y0+a2hVkXZ
	eLecb3hRh/pYsJkbgt7AHrW1eyKvNN5GFWyxmUud31CrDtMKoZSPuNRC0WcaYabVTy8Kh0bKoFzEI
	PhAwqrvRPDn8gexwJAkW3wFv6bYNLrHCr7g+RUAjwFBTXtORqbrVn4sqUz6tz/+5W8cFYc3wG3kgT
	uF96uDHgJHtgysE5zCuTWtDC0l2LE5fjGY0joR19Kd/o07V+DVLJUknVW/nvzsMHFDpAC05sd2hiX
	xHoY3uHQ==;
Received: from c-73-162-232-9.hsd1.ca.comcast.net ([73.162.232.9]:53488 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96)
	(envelope-from <re@w6rz.net>)
	id 1qav12-0043WH-17;
	Tue, 29 Aug 2023 03:28:04 -0600
Subject: Re: [PATCH 6.1 000/122] 6.1.50-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20230828101156.480754469@linuxfoundation.org>
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <0c7bcb4d-73f5-c721-644d-6fa712f90770@w6rz.net>
Date: Tue, 29 Aug 2023 02:28:02 -0700
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
X-Exim-ID: 1qav12-0043WH-17
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-232-9.hsd1.ca.comcast.net ([10.0.1.47]) [73.162.232.9]:53488
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCONszkreAOSWYhC5MFP/e8lFvm1qsqKlgPBfdi4MMLPOYeToM9TvSDMJXApgUH5RQ5XByfcqIOefP+v4f/vywkpbVVKqyPaIMbVR4NPqja6gkPl8qot
 eEybn/2RNdy7/4/mU8HtVsiaJS8iPyPQbYjHVdQJHX4OUmSs6Jx82FLKc4h0xIXzWDpJJX/KGvW5yA==

On 8/28/23 3:11 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.50 release.
> There are 122 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.50-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

