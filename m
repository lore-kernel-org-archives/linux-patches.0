Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620F0156F45
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 02:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759286827; cv=none; b=Sq819O+Z8ApZNthOMB3LMX35wR0mVKLyHdgs22z4UabX8O10NSolUTEKVQqJMHOfIVaxlncnOEck87WeCIHkcaSUaP5rs0nlfANwqpKa57h+DG+YJFjm9ChP3KopBWQBUlrCv2Y6tuwZmNxC8uPj28k7QEmPiJ3DtsDSpr5kFQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759286827; c=relaxed/simple;
	bh=uCHXO5w65OPBubrXNoQ/bmxMID/0e0jWMi0sr6HcfK4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cs/GmkEN/Zg2cfZu5qTw6gWFw+kZcWi48Yc6u4z4lID/nh7SeTzkdSApXflTop0/qKx/b8KO9fcR03iNTNIXOiZrYq26mpjj7pBirsAyDoaJi+E+SkECBEl+gObQsWOqi2y5jE20BH+qQQ5Kw71iVBm7AMRY1LrhjZYZ27xz4TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=OZ6Raoxg; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="OZ6Raoxg"
Received: from eig-obgw-6001b.ext.cloudfilter.net ([10.0.30.143])
	by cmsmtp with ESMTPS
	id 3mKnvdOm0jzfw3mqOvnquO; Wed, 01 Oct 2025 02:45:28 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 3mqNv5yXGDV653mqNvmkG6; Wed, 01 Oct 2025 02:45:27 +0000
X-Authority-Analysis: v=2.4 cv=dLammPZb c=1 sm=1 tr=0 ts=68dc95c8
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=Cyuvsrd2OJRF7bCfhtsA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=EpRzvDfGiAFLCYHkBfEtWWthXUdWuLqIcn4910K3kFQ=; b=OZ6Raoxg5S0Qh1S0R4enNZFk0l
	QnHC3XijhBssvLv7e/14ZV76TrGqIZELC4Rdjs75JX+bxc2XVtZtemUTsTUrrsWIpgMboRtzxlMJW
	bYFz+hmipwy/F4Ov1DXPdSTjZ0UiYi9CmF84LFyF3RKNiblpiitcIOXOEWi9mcWvOxxTIRwGlQQGu
	MMqQCkgiFKt+lyP+6kji67ZaEDl1/QbdLWDTcfYQF/C9TEwgbAQyDzAVMjAZUGpwa5JTOmOh5qAnR
	wLsPlFGnU6W54y77tdvqHFuzt5y5RiVDSYZWFXGURiX/4ZBgVTdrFbHIkJntB3azKSbWMQKDg3ZOR
	bM6HlhKQ==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:36254 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1v3mqM-00000000V51-2BjB;
	Tue, 30 Sep 2025 20:45:26 -0600
Message-ID: <adff8883-25dd-402e-8f3c-a369c2cc8d45@w6rz.net>
Date: Tue, 30 Sep 2025 19:45:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250930143831.236060637@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1v3mqM-00000000V51-2BjB
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.116]) [73.92.56.26]:36254
X-Source-Auth: re@w6rz.net
X-Email-Count: 17
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfMJ6vxPEY+OAeOVJ8BjEYjZQxCKAbYrgiGkwgQczQ3VuyvwGFv2toSfjzJT3hQ3k4q0gE2fl+Gy/cRBC55LrZn4mjuJZh45cCCfY04upjQlznyY2bjQG
 UETwwy8OWjMW0jN0s3iopr3ge5ZE6EUNTtwCh5GhU1GuNiR6LqZdc6rPVDNa0CrmsDYbI5t92lqNbg==

On 9/30/25 07:45, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.10-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

