Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D589A6DD1D
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 06:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713249934; cv=none; b=mqjwwktTDBPVRHX329zQjLoNNQ5C6YqZnaPaWfMJ0CxhwQl9xe2UZQpysYV7I2uus/NBTmeiC9ytmur7QY9eb1V4o7Wqc1xpVufXwh4qFFPimOdHkjFQhhGBT5TboYZBnP+99z7ggLT7vkSg4F0BKVnUNCRjeRmnFOivZoE3ktE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713249934; c=relaxed/simple;
	bh=wyuTHcxvbfB/eF+OxSPnCHP4j9uWKud0zd4en5i12/Q=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=n46HSxMrCE2rCVAmL7J4LbIvOffFzL+T5ETDmMEi47jStGROfZpsj5Ane/AKCY1cv0Hcbz8Y7rS5d6yvK87jnoMJ5980QsI67fMJ4p2+vDYXj4i6M0fwekPgWTZUpj0PgYth7/51B7lL/qj2+ObzupT4VDgODBPtwpqz0gFtpeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=qEBjY4kS; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="qEBjY4kS"
Received: from eig-obgw-6005a.ext.cloudfilter.net ([10.0.30.201])
	by cmsmtp with ESMTPS
	id wEHWrGTYUs4yTwcZPrKqIp; Tue, 16 Apr 2024 06:45:32 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id wcZOrHxjUHHoAwcZPr7bDa; Tue, 16 Apr 2024 06:45:31 +0000
X-Authority-Analysis: v=2.4 cv=dskQCEg4 c=1 sm=1 tr=0 ts=661e1e8b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=raytVjVEu-sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=zTwTvwDJIkgUNqRoL0J4vERfpqlDMONOvnnBo8aW7Uw=; b=qEBjY4kSgXexvVHW5OL7x8nwTS
	UnRsXoIU3XzcqBqZ+9khIN+DS5fKldsOW0zwgUU0Q6+sXB+c9/xo4KkSyhnBWH2xX4qdAcZbkMeXa
	j26E9giMbt57++P+czg64xPO9xWVp9t1lgaTbjBv4uROLBH9jcbV0L/PeOA9OPWVojga6uE2SD1iR
	cWNX5PMsV/DSQM3smRfqz5IZeX9DeIxPpedEHictUuuqQ4SslDw5mlkZr34Xyo/hv4bPS7YGQxeke
	FdfW+RLj9HXL2LIH4cONSOWHG8NEKwPnNOu36iHVjHrD1R+jB/IEBP9Ezb9MlYMCXGaoNXeiLGgnj
	i0C3Ve9Q==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:57920 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rwcZM-002INl-2a;
	Tue, 16 Apr 2024 00:45:28 -0600
Subject: Re: [PATCH 5.15 00/45] 5.15.156-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240415141942.235939111@linuxfoundation.org>
In-Reply-To: <20240415141942.235939111@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <16ea6882-897a-5ac3-3748-25822da92bf1@w6rz.net>
Date: Mon, 15 Apr 2024 23:45:26 -0700
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
X-Exim-ID: 1rwcZM-002INl-2a
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:57920
X-Source-Auth: re@w6rz.net
X-Email-Count: 60
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAtgupB0LqatZhxM6Fvva/+PMES9GGwdxlxuEhenxrEDOwJfPtHbh3WLyUR7496l5fVUQIPeBn+X6uQJ3xUF29mVhaDYxjYYI7oqH7RsZYPxXhBZP+Re
 V0nlyngabaExV6vtzEXSqe0dQxTGr+JmstNmbKNrKWiLcCMzE6wndHW72bbsDJxfNkqmoGbVCVAgrA==

On 4/15/24 7:21 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.156 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 17 Apr 2024 14:19:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.156-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

