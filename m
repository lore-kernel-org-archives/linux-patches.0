Received: from omta034.useast.a.cloudfilter.net (omta034.useast.a.cloudfilter.net [44.202.169.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF94413B58F
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 20:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723841611; cv=none; b=dM2ZsRpnX2RNxd75lWhk+Fau+ymO4S8OTCL6aGmvwNFmF443MxQKhEsP3AFqu5cqI1a9g8XvOJoGHy29NijsDha/4kpbe4/hpbDXHFAp0rq9Rv1BYJ1oXfIWDN1x4MmUcLa460RxVUmQrKy3bbvdZ5s9PxufVH9mDMFkJuFeFfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723841611; c=relaxed/simple;
	bh=wu/nrRtusJ1ZmSrs4cBH1WMs+1feXfjCqd9WvPnzqzM=;
	h=Subject:To:Cc:References:From:In-Reply-To:Message-ID:Date:
	 MIME-Version:Content-Type; b=R4n1Mab0hL/8ZCCXJdBtvWKhMvHVet0RU22/9p8f7e5uUDdhq680vcdFH/8Pyfxj4beWICIcTOyaNxg1AiwxjGREQc73tf2pQtSFuRxlFfFBAT0StEkpTDEvSn+MHXE1f4BhzIYZtJ0T3ucixD6jdfPLyoeBzVIFd6yPp1VwWpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=XJJTx5sN; arc=none smtp.client-ip=44.202.169.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="XJJTx5sN"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id f1cGsO7Oo1zuHf3wvsgmA4; Fri, 16 Aug 2024 20:53:29 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id f3wtsYmtyO7Crf3wusM8Aw; Fri, 16 Aug 2024 20:53:28 +0000
X-Authority-Analysis: v=2.4 cv=Pco0hThd c=1 sm=1 tr=0 ts=66bfbc48
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:In-Reply-To:From:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=yZIWAXXOUQbRbKx3GtCM3kQc+3f/6fkRgCAH+j0kJUg=; b=XJJTx5sNStnR7fyJLVDqiowyV3
	HOI2dMVK9opBAOng4uUANGHHJMDTDh/ILa5M7nnzftpjNZIl5ETc8k3k+ATeos0pa+O7VGrN336DC
	+BJv56rbgVKVQmrWgdJBwS0EdYVOPFAZ56RN8I4MrpnL86oq2q9Z/G9v5xJmghQLkGKZEU1p4o1hI
	Rz06uHL6tDk9R0md8XdUwNCK8cXSlOHHx/Koq69vthTlGRA0A6dpL2122k63W9vGm98FaPpVI42MO
	vDWsS6vbGwkDK65R4yMkuiY4TbL4GH1viBMW/2fh7cRGRLvLKhKAmD5P4n05RIo6S8rGkQI5sWoYJ
	u2z3oV7w==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:35234 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sf3wp-000DA1-1V;
	Fri, 16 Aug 2024 14:53:23 -0600
Subject: Re: [PATCH 5.15 000/483] 5.15.165-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240816101524.478149768@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20240816101524.478149768@linuxfoundation.org>
Message-ID: <4021e4bc-e532-5fa0-a2f5-46891bb99ffc@w6rz.net>
Date: Fri, 16 Aug 2024 13:53:17 -0700
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
X-Exim-ID: 1sf3wp-000DA1-1V
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:35234
X-Source-Auth: re@w6rz.net
X-Email-Count: 60
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfGlrEPkNrhwIBtIGSzvkQ7U/YzqJejJMZ9KzTZS6bmIm2AFojtcvJ0Gp118FfXQy/SnuWFklejB7zvCXXF5rDbIwJv7zKfRfdp3eAoYq9CbsdqY/lAMy
 haFFphewb7vD9ZFQwH5Iji5VKxivwSUHeagyJVLSlF4VUZqdITKImUWYyb9AGuP3iib65rwx6uHcsg==

On 8/16/24 3:22 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.165 release.
> There are 483 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 18 Aug 2024 10:14:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.165-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

