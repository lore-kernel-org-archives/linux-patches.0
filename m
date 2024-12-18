Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32120156669
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 06:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734504134; cv=none; b=pmvnnzb8FyF/RnUHkYyKght/5zYlNh3/O26lZEQQP7CHYy9g6cpZybYAJOOujJdmKmkBdhw0XgEyZgxHO1G/Axm9q8gicKx3bfhFtSwq7+MU80rWVdIIoL8Z6QAjHfGIxN6RG7MbHogzofBSh/AooJvAX6WbDmbJE/7gbU1lGbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734504134; c=relaxed/simple;
	bh=biPTOeGK5kNXwHfntlzD18SffZPTQSAkvtm4SLGlpK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FM02y71tsZXLotam+ORdUn7sxyOSyOkAAA9PHwj5e1oSwPeLpVao3pqzRoQyMdIQPOHZC6Nx+uOMlIH+Pw6FENiWMTW6eIEvka76RpHC4ItXp+rTrBp1wfHPK1FPXT5k4eFos66Sycihm1LZfIJg/BFnxDTC8QynKy6sJh5G92k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=opYdsLSa; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="opYdsLSa"
Received: from eig-obgw-5001a.ext.cloudfilter.net ([10.0.29.139])
	by cmsmtp with ESMTPS
	id NE1Ut1d4gqvuoNnl4t3q7U; Wed, 18 Dec 2024 06:42:10 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Nnl3tPgNlmNYjNnl3tGmxF; Wed, 18 Dec 2024 06:42:09 +0000
X-Authority-Analysis: v=2.4 cv=fb9myFQF c=1 sm=1 tr=0 ts=67626ec1
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RZcAm9yDv7YA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=HPvIB9lQppeJS2B-OsoA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DNXrao/3f+rQ4IwMlW1jtyRCSmmcxYqv0iDNaoRwtbY=; b=opYdsLSa6CyFY/Y91enfpa9aoq
	929RTNTorwjhL34j2R07LFHX26oZEuF2vz+/K2EIe2C3r5QVbHCW9r+niVfGlvu/5wNX54ndpY+2z
	jMu6+t2GkLFVo69GVGwWvisH+gjR8Uo+wLwQgFUE21eOk1r6D0nPVh90XyYovSR+PnD1mzHr1xoI8
	KV3pP3yS4Px4/Bg0U+qIF8Y0vnRSUU0lkt3qaKLfSuC2jwyOeSoDPZdXVdwhvAKf5ha5GZdwzR0X8
	rcV15eBnur7zHscApH0n2yHHneiW1AHPRk1ofPxTA1/BN9+AViIwIbPt1B4AUNPJGRa6fa33fDk1K
	CcKpolbQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:44230 helo=[10.0.1.115])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1tNnl2-0001ts-14;
	Tue, 17 Dec 2024 23:42:08 -0700
Message-ID: <8554e516-d9ee-4419-8478-89aa3607af9a@w6rz.net>
Date: Tue, 17 Dec 2024 22:42:06 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/172] 6.12.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241217170546.209657098@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
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
X-Exim-ID: 1tNnl2-0001ts-14
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.115]) [73.223.253.157]:44230
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHIK3uKMLcxBQT5W8uZrsvVgwJDNFzdzqHh3Yxn48MfnxmOCzxsIucCYkxCHrIQHYNNvX/BkU0YZIoO/JdIXMJ9ymDkjhZWB7O9h/S1K8kFaoCUB6Z6A
 WfSZDDZi3s4+hsIaWQrg2L4rqvuNgU11XDTC892U2erz2KWVSEx4rn+t0SAnbjyDCoB5xFsMf9DnXA==

On 12/17/24 09:05, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.6 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

