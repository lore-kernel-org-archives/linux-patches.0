Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 793504CB28
	for <patches@lists.linux.dev>; Fri,  5 Jul 2024 05:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720158643; cv=none; b=c0ckJsyED7hnqg2nICLbtAA/bVvAL00c+cFqmJXIHt5/iIWGKRSmwJyS3W5n7UT3A7Ivb0qlxk4sRQnCPfwap+2zfR7kOkfMOTHqrSO1iPWE6dcq0pQXFl+PezIcdls4jeYgZJqZDAUNQwUlhwdmWrKKBZcpGNW7wM6Xf2Ud2js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720158643; c=relaxed/simple;
	bh=2wYzthuZ8kDfQUIPG5TCWw/ONYN+ILCr79+g50WweIc=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=OFh3ufH7o9xvf3B55Cdyzsb1bFXt9QAkvyyOcCZrmhdadtORsJst3Lrc36akqWx6Na9f6peveT7A1PS3crF7AiFf6p5a8PHAlLXheQ8ZzhkikSxzGRCyfRh3S0ShP5xjTsslzomgv2t6/BVfSCK6usLLJu0Tr3Se8AuCT7nqTe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=kTSkqkyX; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="kTSkqkyX"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id PY8Vsg3hLAidIPbq5sxCZg; Fri, 05 Jul 2024 05:50:33 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Pbq4sASRqW7YzPbq4sxUVm; Fri, 05 Jul 2024 05:50:32 +0000
X-Authority-Analysis: v=2.4 cv=J/es7hnS c=1 sm=1 tr=0 ts=668789a8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=4kmOji7k6h8A:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=8BM4xLTM5nKzOUQdiIzCZ4Dp7kjQR2h1ogwZ6shdbRs=; b=kTSkqkyXfKYj59Hu3ZSjwBPVXR
	gbV1mx8qgzfjh2pkia36pSyyt8xaO0j6CG8E3TAH0YbpEXkOqBe+CezB1048RZuMv9mHB6CE7YhC1
	XgBANAYIg5V3K7Ux27u6ERkYSZv6selWowp4EDGvXjKbaCWoV/gNkt8BcbtrRShaOjmf5v80dJVV2
	Ksfyh7qblOIvX4NCkLSSg6bPj0BR0ekKDDBitWmRZwiH4ncHwoUzOWCe4lClpS5Z1dgv886487a9u
	pzXML45AHwg+7KzAue+IyF/F4aE8lmxkb/gVLN2PETuoKmUW281Rws9VZ1eQgIQ24vm23F3b46A5Q
	0okfvUsg==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:47186 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sPbq2-002jJs-0Q;
	Thu, 04 Jul 2024 23:50:30 -0600
Subject: Re: [PATCH 5.15 000/356] 5.15.162-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240703102913.093882413@linuxfoundation.org>
In-Reply-To: <20240703102913.093882413@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <2f59541f-d238-5072-0e71-9b40ea1638f0@w6rz.net>
Date: Thu, 4 Jul 2024 22:50:27 -0700
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
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1sPbq2-002jJs-0Q
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:47186
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfP6vvMfM0pO6Ywev3pkiAxLbXOGrXl9auv2yMeC8jrq4D24Or4ifqUZQZrmJdeT6G/BH9YgikdsMT6Vt30HhquZmZVJE24w265/X2FR7EY1up5lwRuHk
 K9NpKQR5Lrvik+5pZf5NpyR4eJoUMHz5c2y5QpuiTBwgCGgtOuZEZXi2yUu4Tyi1F3P20uaEGVm4dg==

On 7/3/24 3:35 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.162 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jul 2024 10:28:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.162-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

