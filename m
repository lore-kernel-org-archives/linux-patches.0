Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9356F20F063
	for <patches@lists.linux.dev>; Fri,  4 Jul 2025 05:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751608692; cv=none; b=qSUztvRQKf0kNAD3oo9bEdHwjMGLEZRyVUqdDtfZL4Qg860cWI5HHd1ip1/ydwq2oomr4qYjP/BZXRaq1le0Dv+sv6XsX8+tfpYU66qNCoxvlRgnfuaB3xZAcTTSB3gJwMKgcdVm5O9N4qVi4YddA9KATEoW7W/oFFiJjzMbHA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751608692; c=relaxed/simple;
	bh=uNOJM30vunsbNc6OrFnAOpOitPh65jgCAXCqOjkm1I8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Y0UjWV9nIeYRZz0mEztJdOhaGJ8VcI09oYpKlZev8XdNaZTQlDpPDYRjFXcSjztEaO/9SF2kyegGqOLIHmFQ1NFuYBM+b9QAh5ZVDorH+l4s453Rbmtbt99CQ2K5DK5MVqhR+DjPPApAEkysWYbojmhDXQGpZUX3mJgp7IfUpBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=JvsQXO/y; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="JvsQXO/y"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id XYWruj8ofbmnlXZR2uHHU7; Fri, 04 Jul 2025 05:58:08 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id XZR1uVUfXn1UKXZR2uONTB; Fri, 04 Jul 2025 05:58:08 +0000
X-Authority-Analysis: v=2.4 cv=UIcWHzfy c=1 sm=1 tr=0 ts=68676d70
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=ZJCAKeS_rTr8ZDEThcMA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=d3oHl0SkMa8xlA86FNMvR4ZISNCRBg2BotCHljy9tbE=; b=JvsQXO/yHlUde3JYYCkMAVacNM
	Ficiv8pP49nrsEJuevZk4XvKVYbiOxrcm9vfsan0mxQL1NRFky4o1TlN+fc9ayo8uf2ev8gv/lyii
	JiAwwUgQUEcQI7JTXYguI3m6YUayrRTlieo0eiZX+ciewKSlVG5VNsc80CufVFwWN/FMGvviEBRKG
	Ur9YEG1S4p6zlgZKDq7n8iPGzDLINa+Q+VoIEfIovgK2wgiaYvcUZqeqXFGE65tHs0YTeAW0O2RpR
	HSuqR5VffJ/+wT9BvF+WSmVsRX6YaIA9yIZMljBoKovCcutx7kUoiJyOzh9u8WWMfFqQTnAEgetAV
	zrIPNWpw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:52316 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uXZQz-00000000ocH-0jaN;
	Thu, 03 Jul 2025 23:58:05 -0600
Message-ID: <9d3ea6cc-be2e-4748-90a9-47f0bd352c9e@w6rz.net>
Date: Thu, 3 Jul 2025 22:57:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/218] 6.12.36-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250703143955.956569535@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1uXZQz-00000000ocH-0jaN
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:52316
X-Source-Auth: re@w6rz.net
X-Email-Count: 36
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFoFV6a2a9Tuo46nT6RFurHJLblEH1q/68Rc2lQJwIvgdbTcPG1/3AVojgvDaM7HCNHU9zcmKthEb8rDxsTHIcAWcUIIlkSLjiuSNFM3VZclEYMA8P4P
 SqTs8VHWiuYuJPMGBm9wB8K3qdKupELvnvFuG4mBi3pdt733aE13R/ki1AdatsSOmN4fga0RoBQKKQ==

On 7/3/25 07:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.36 release.
> There are 218 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Jul 2025 14:39:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.36-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

