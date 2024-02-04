Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC5328E09
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 21:29:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707082168; cv=none; b=A0Ab5TqZ6mNUttNzg7f1MCVV+9JYscyH7MHvVJZG24bfJ3P0jakrDqMyiF/lJUthv8AySA8jSKy4l+MvoQQxT0s87XbateM9RY223Y4l63fwx0rxZiXcACbo9ewp9fZL/A4u3tiV9m6ZW0h2a/tb4qXyLDzPPnDSZPD76pABoK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707082168; c=relaxed/simple;
	bh=gyjH0ExK1biiDEok7kg7dY4j4lY4tkvXTMB2sK/el+w=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=bD7ISjGX12mUSeAJiCCiKl9uVgg1wohbdxC+z0+sg1Z1TkJal/XZc1+Ur/MNHN78QL3LgC7O1pT2DFdtLul1g0ToYLAi7ykw+CtvXbnB56WUv6tynF1rkVR7JjNd0UFY7VjzoFlzvd9D7nkc6vnu66lBadBuAFMO+WT1Jqd/fKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Z5jdxB4I; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Z5jdxB4I"
Received: from eig-obgw-6006a.ext.cloudfilter.net ([10.0.30.182])
	by cmsmtp with ESMTPS
	id WfnQrmXD58uLRWk1lrTpmU; Sun, 04 Feb 2024 21:27:49 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id Wk1krxnCAZh02Wk1kr4P7v; Sun, 04 Feb 2024 21:27:48 +0000
X-Authority-Analysis: v=2.4 cv=T/cvTOKQ c=1 sm=1 tr=0 ts=65c00154
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=k7vzHIieQBIA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EKXS84hPPaXBVOSEZCVDK5hIlR6tW++R26HeHha+bks=; b=Z5jdxB4IasZrO5+oNnVw0yMWjV
	N2Vnc1opv55vsBQ6LAYA2eYhXgo2YdEilFl+/k5ufRda8wOTgDYDO0nNyP/uC4Ii7X1nyC6vzTUUj
	Re/aL4fXLv5gKwpDVT6R/EYJr9BY8K/J83aaTyJbDko7ScDcc9VWzC9qyWcQzcbjy25ujUv87Xkd7
	0lpMS1Gm9z0vr0+4Ri7sDdHCWvhoFDFnbqP3FCqrnmVTj8+rFD34moBBs2bAylj0GQKoLLDIqtYwT
	lRx2lHy4jvHGMqzyb26iEBK3Zu2qsivtRnjPgg4kiDBvenG163yD8rUH4bzKcINDmZTThP2MvaJJm
	IvxgZKJQ==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:38204 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rWk1i-001HeI-07;
	Sun, 04 Feb 2024 14:27:46 -0700
Subject: Re: [PATCH 6.6 000/326] 6.6.16-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
References: <20240203174810.768708706@linuxfoundation.org>
In-Reply-To: <20240203174810.768708706@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <402173d5-ba39-dc5f-5a01-6a5e19a3d131@w6rz.net>
Date: Sun, 4 Feb 2024 13:27:43 -0800
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
X-Exim-ID: 1rWk1i-001HeI-07
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:38204
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJluMmI7Rm4mVZbQ0b0G31FtrtMGUyn7JZxnksxgwuE5ChkZzfqB9lDNvta+6m9vC3SzciytNOAyeA4tzcvMk+pv2lIs4b7ddrRImiNWKWCg/vfcG1JN
 u1fif9288p56ZTN2JAr5p5pW8Gkk4Fbb6tpHXlaWbhumeDr/KJitjPXmtHXjaMBqxmqdNOihRMMROg==

On 2/3/24 9:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.16 release.
> There are 326 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.16-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

