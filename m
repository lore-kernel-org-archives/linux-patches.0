Received: from omta036.useast.a.cloudfilter.net (omta036.useast.a.cloudfilter.net [44.202.169.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0591D6DC6
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 07:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725347351; cv=none; b=cMtPY5r6hNYpydncGVRKfpesG7c1RVOij2gXQtA40l9b0xz4x0q0X2cbB0rcUic2SH1YsebFUiHC8rzX6L5mbXVmSrAITr5MRkwh1UmZ3EniyfBHF8wvH79KpQy+wJ0SMgYtCaS1OgdRU6Ily5pxYWh2odGVVeahBeWWRCrpcGw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725347351; c=relaxed/simple;
	bh=PLl7HZaKNJmlzuDTxOMe7aFguk1ZmVE1Q7rqbPiG6KU=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=Tnw1xWnYsyJ68y6rZrGRh2Svn1EvVgU2F4CBx0Q2cw91lXqE7b+e4+I/+/+Jez5BuS+TDVfpP7lx8s4H/RWLc5NK91hJRZgDOJTr3BvAQaiomRLJFyVRB6z/DHRDwz6XaN2JpvAh9rRZ9pj4w7bAqBPkSNbPxKUkuC5+KnqGdCw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=jId/djHM; arc=none smtp.client-ip=44.202.169.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="jId/djHM"
Received: from eig-obgw-6001a.ext.cloudfilter.net ([10.0.30.140])
	by cmsmtp with ESMTPS
	id l7NFsGY8niA19lNevsGcL9; Tue, 03 Sep 2024 07:09:01 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id lNeusBP0OZlJQlNeusXVV8; Tue, 03 Sep 2024 07:09:00 +0000
X-Authority-Analysis: v=2.4 cv=DMBE4DNb c=1 sm=1 tr=0 ts=66d6b60c
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=EaEq8P2WXUwA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5qKvnjbeiT6eEQl47fWm4Ghr+gJnjmRt7nSNZM9Mnu0=; b=jId/djHMaxTm/3Spe3223xhjGh
	I21SlGFNBIx6BZPmexb34+qTAWACEDJ7jFEExREoV3keMcd/kX2sn3+VHE5q6j4YPEXHN0Sw5FViX
	x5Z2A9z3pNtb0DefvYWjSMp0w7Izzu04Q0YL1iZ32bcFK7ec4DWGili3kuem9eqhMe7mPlB27mBai
	GDTHhzAmfiljrI0CLXab3pO6at8hMYkzVM6IYxv6LBKpSFQTjlYMNeSDSllSvFklo5utyBFEAkxQO
	Eo/I39761qkiRy8XNmcNBhntW7tcG7QjLGcC4xiNEeCPajvwkP37rqqj/cgBKhWe/M2cVGC/Mku7/
	4Ds7dACA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:38084 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1slNes-003kL9-0Q;
	Tue, 03 Sep 2024 01:08:58 -0600
Subject: Re: [PATCH 6.10 000/149] 6.10.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240901160817.461957599@linuxfoundation.org>
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <bf6c8cff-f533-9a94-0227-6f187e51c24c@w6rz.net>
Date: Tue, 3 Sep 2024 00:08:55 -0700
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
X-Exim-ID: 1slNes-003kL9-0Q
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:38084
X-Source-Auth: re@w6rz.net
X-Email-Count: 3
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfPrLNLsCpcZ4r8jDcdBSbhb6tgeqc7g/9/biyxvolXN7dQJGTm23zqqQxXUqsoIiudr5J3z5+TrmQ5N1bkNNmZiSptkpnsFGyJLkxmNqdpSsxwFTYpmr
 HGPHzF0h2DV5StkqRyshDx45GGXA/o7cwT96lGMbXk2Ymh4wXPkQSMUHETqO8EKS23iz3jbo4JUpbg==

On 9/1/24 9:15 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.8 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

