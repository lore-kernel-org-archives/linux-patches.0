Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C9DA4A
	for <patches@lists.linux.dev>; Sat, 20 Jan 2024 00:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705711603; cv=none; b=dWqLDZPgwLyVMPUpMBFJJxLs7Qg4OJlUQwHvsvM9osadnkDgqTuoa+S1GILfqqskHfE8D3MYzGax9h8XwzT1pCDhvFrwu5ocFR3DT+MK5loQoR/b6KPraLB5ECtFc3UgQhLIp6k4bnS52eo5ccsrMpZrX7dmMOopBEgatKK0JcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705711603; c=relaxed/simple;
	bh=XIZsv/RfQm7BgGT+oEhN8pKQIm+tOaegcjtaTUA0ghY=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=FGGaB2niau9Nxku/igqH3OJMm5Tf40w9XT81B6PtgA6pcV2iGq+vQosmlMQGW/G1Ci+1CQIBn3EVnpItMhsCxGnVrKBzBt7m0Biw7ZI0ANQyCmtsU4wBKYELIYgekl9D4YMvIzccfRWTCJs3Bg1vjCkMHMQLtX5/czxI/+6/aYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=SsOfTEWx; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="SsOfTEWx"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id QyO7rXYB49gG6QzVQrqo7J; Sat, 20 Jan 2024 00:46:40 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id QzVPrI2DMl5UwQzVPr2ETl; Sat, 20 Jan 2024 00:46:40 +0000
X-Authority-Analysis: v=2.4 cv=daKTYFbe c=1 sm=1 tr=0 ts=65ab17f0
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=dEuoMetlWLkA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wHu7zF97UQTgv3i/yyCxjGkDLfWtEHfYOEFNAgQbnow=; b=SsOfTEWxmb7hR3n2I54w7H+ysg
	zrNZYmuSFI6IvyrdM4mCUqfPGTXbQrgRZLnFbB7xRrZPn2LBFrnhY25XvTPE4TMlcEVgH+XOrzMT3
	eFHscg8G3JCRcU36K5TqMsFNtCtVWFIkL0o8vLPctMdrscFRLVaTe7f9M05XezU1FpzQW02HioqVe
	jfkZO6l8/hC4PF2ok5ELdrwYFWrF/4SDsyvIM0W2W0xHjbwRBFLk1O3t/RP92o1p8rM/vpvFl9M3P
	i3TQtdoZkTu8p8IPuhaZ3NJCDJY2yW/inC2YutI22KrE7c1+pYnZUFbefJAfmoqBRB+TVg/z/kvhw
	9zyzy1hQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:36008 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rQzVN-00145A-0F;
	Fri, 19 Jan 2024 17:46:37 -0700
Subject: Re: [PATCH 6.1 000/100] 6.1.74-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240118104310.892180084@linuxfoundation.org>
In-Reply-To: <20240118104310.892180084@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <a136c055-75f7-01b1-9883-dbfcea86d08b@w6rz.net>
Date: Fri, 19 Jan 2024 16:46:34 -0800
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
X-Exim-ID: 1rQzVN-00145A-0F
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:36008
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfKkeDyQ4HpsxGR/FHThDQ+qmXgmyp7O3AVHQKNt8q9mJMA5qjRv7rg4xPcz9A4D/2kSG8D3BBl8S4oU5CrfkgHcL1HqlhvVs2lRilbJAa+lEY/rPTlSW
 4OuG0EOeV49iLruSVYp+PTfOdGXlZsrrKZKzEMEUOVWyHX5opEfthzt3/PXuAb0tADbYGGJsryjLAg==

On 1/18/24 2:48 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.74 release.
> There are 100 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 20 Jan 2024 10:42:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.74-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

