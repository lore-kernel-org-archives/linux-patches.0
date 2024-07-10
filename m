Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9FCC19247A
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720616386; cv=none; b=lLQhC2q2F6oA8DAS/wxos+L+Pd0t8RZqntscK+7tLMAKqNZkDQxDO4XGu1tl/OVzKYtFudNTLTfK2xjP4geIm47qpucLpBxo/aMJIanF0g4y1xNvMR43tuMFExuAmiKTeADfmoZZ2cUSjGmIPdN7QPI9G26PuhVtRQEfoD04XM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720616386; c=relaxed/simple;
	bh=obHF9AJpMxnGLrY5noCk5gC/7nZIV0lagmg4KPXKWIs=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=VQ6Uw/uXcXHnZ5t8gi70A4mNgEzwBsTtyrp7HB8UZD/bv3QpexWgpReZ0BkYL03KvdcmZIsBe7INFLGTfxIrF9iz99iIDBYv3wi/2cvcmS8CWs95v7rbFfSadN7D2sD4GLr1nar7cpwr/xafp8sCKJ3hjTzUMY4iXUXabnpdKzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=vYx7VkBq; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="vYx7VkBq"
Received: from eig-obgw-6004a.ext.cloudfilter.net ([10.0.30.197])
	by cmsmtp with ESMTPS
	id RPQysTlhFSqshRWv3sG77W; Wed, 10 Jul 2024 12:59:37 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id RWv2s0TJTDweaRWv3sne4N; Wed, 10 Jul 2024 12:59:37 +0000
X-Authority-Analysis: v=2.4 cv=BcYT0at2 c=1 sm=1 tr=0 ts=668e85b9
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
	bh=ByEBJS4d3crkbAji8f8f5XgXAQWRnugm4hD1So0pZnw=; b=vYx7VkBqHnuay/hP/6O5hbOj3o
	gz6vgQbbQQb06mzc0f6w6J4f6IjVl1y6bMecAOMTazScMUcLdR77eLHE57ung84uaGcwAoymT1/Qw
	XcHxLnaPDgZPXOPlaaZVjbql0VPHaakjXDbN5N/04fa/7m9J2ltsZdrYAVd3hfyHVAYtjc9mmFou4
	/jdFaItRVe0obhVVsH5Th1IIlZ2rCxTPSPdLwyi5pDH5lVpA1WXyTsceplJKa8IarsXCQsm0xiLqc
	NG4AT2HYSWHHYn7isuly8gcRZCtXCjY/Ya4FRISBQgnngCq5RbMJcOj6yi0a86SzSGQP81yb+ZuNT
	W1+AHdTw==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:47970 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sRWv0-001cyG-1t;
	Wed, 10 Jul 2024 06:59:34 -0600
Subject: Re: [PATCH 6.9 000/197] 6.9.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110708.903245467@linuxfoundation.org>
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <0edcfe59-908a-dc29-a34e-afa7923b25a7@w6rz.net>
Date: Wed, 10 Jul 2024 05:59:32 -0700
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
X-Exim-ID: 1sRWv0-001cyG-1t
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:47970
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfJ1aakVu2C87Yf28kcPipRkAaL/bEd3XgAIz+Ih0QataID9NkAco0BnlEilChg5f4jf52mkzgpuj3OJFMu/B1PYAafmfkJgNNeQN+5Pb1dY4Uyy3GB3O
 hPKP99BZ+3qab+3ig6isMDHI8XhObjYK/6ce38IwA3b/kLYuhkeFdkMyUbuSp3rhgDJq/aLV7tInmA==

On 7/9/24 4:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.9 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

