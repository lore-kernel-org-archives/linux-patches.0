Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7759223779
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 23:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="f98f0DAb"
Received: from eig-obgw-5004a.ext.cloudfilter.net ([10.0.29.221])
	by cmsmtp with ESMTPS
	id v0S2qlM326nOZv3ttqAmqa; Mon, 23 Oct 2023 22:59:57 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id v3tsqGoB6nippv3tsq7zXD; Mon, 23 Oct 2023 22:59:56 +0000
X-Authority-Analysis: v=2.4 cv=VpAwvs6n c=1 sm=1 tr=0 ts=6536faec
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=OWjo9vPv0XrRhIrVQ50Ab3nP57M=:19 a=dLZJa+xiwSxG16/P+YVxDGlgEgI=:19
 a=IkcTkHD0fZMA:10 a=bhdUkHdE2iEA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=5SMoDr0hu4qfrcIuQekA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=nHGUrsyN+6los7Hev7rkFyWULCCoURrFUnLf2Mtba8I=; b=f98f0DAbvUTP0eXCcxU10Ksdew
	NaXfF+YYaq+oSSpp/ahYJ2a6Jm1NEJhsj1OpB24mGM7FjQKONCjJLdlgL+dnv8MCuSBWJc//RZuKP
	5u7WR31NhghmlB09cqlZD9i7jorpYXRydc2Qjt5WjfSqQU1sES1ERopMvwy4dpgWkINkS5+r3ODBZ
	QLbC5jIPtk+VT03qlDoCGp29te+PJyvHxmtuKDiBg9Bm2OQpePStNmoICCD1pMozsbPqv1y8YrMj3
	hCOICVha5tBUlY33eCylvczoD6JZwm0wh3lYbV4rUOVz/vW36POWwX9zS3xdMgmfzVXRhD0RMaBkz
	FLvhzA8w==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:52484 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1qv3tq-002dbf-06;
	Mon, 23 Oct 2023 16:59:54 -0600
Subject: Re: [PATCH 6.5 000/241] 6.5.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org
References: <20231023104833.832874523@linuxfoundation.org>
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <785d071a-0b03-3f1e-7fb8-c8f91d08a396@w6rz.net>
Date: Mon, 23 Oct 2023 15:59:51 -0700
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
X-Exim-ID: 1qv3tq-002dbf-06
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:52484
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfDrH9Trnz8da7kX+YDKeAmls4KEDL9aiyW8jsvMIPTVbs/EcdAzNRMpPwy2I0iJpuQ+fR5vskTnHMbeB+FB3v/4Q32PcLgJPakn7KY1SvymsPbU+Frpb
 NkOwU1YpNH90ZGlFXfkPtBOOvPfYrWRwXHP0ARhjNq9q7zU5HGARIaF/sWrtSFPN4FS234K5mBITkQ==

On 10/23/23 3:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.9 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Oct 2023 10:47:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

