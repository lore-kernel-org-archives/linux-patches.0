Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3987E37B41F
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 22:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789339607; cv=none; b=GgSs+XyZ+wYJIyzIJK6jTbiGDpkgTxaFHoBFpxfga/f63ye9wHprxqf51xWo9xB4Iy4XqUr/GCkZgfLZu4XEnnZlpoFIWn9wuovosX5AeDOzgVaX0AlDb9mK0LV5pqY7z2j2G7iOAXb9pIgwneneeTThOmmn40O4utetx4hKlig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789339607; c=relaxed/simple;
	bh=a6gqY7byHZQTJtLRC7+9yGiogoMFsjtKReKQ2ZiiPGY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LL3fxGgqbX5otQIjKFTXPUiAJXm/omNfqjJpdpRV8MS5rJ/ubsG5BP5NFDxeby15wgimQ7Z8EkKjpjk2HQvncX8sF+Gz8WVMrgZM4FnVrNbvRux5lykMXlI1+njakys/3kSmoUZQA8w19USCWyHGnFYgo1DNrewJReq431w5IYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=foHovVBr; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="foHovVBr"
Received: from eig-obgw-6002b.ext.cloudfilter.net ([10.0.30.203])
	by cmsmtp with ESMTPS
	id 5obVxxZH8v0nd5sy8xWCkK; Sun, 13 Sep 2026 22:46:40 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id 5sy7xSUzMgxfo5sy7xOgoX; Sun, 13 Sep 2026 22:46:39 +0000
X-Authority-Analysis: v=2.4 cv=B7G50PtM c=1 sm=1 tr=0 ts=6aa727cf
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=xLK6yUXbnnwwER6x930A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Unsubscribe-Post:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XejKt+S1pjAPZYpwZfEQ5mJ0fR4Q/gyDKFO6PAE5Ad8=; b=foHovVBrW3sO6y4pWdWz6E8GXl
	SP6pRBfqOnv4dJ6gk+M+U+yIDnzP9onbs5eynwz0ANmnFf9kQGebfE9AYomRbylOt5i7/YRXwhkcN
	A0ibzKV4Lv5sRMIbnRiUpIJEnsNFfO1ZHFiMflCvQJggus9vAyLSsvCWAjxvh+d7co8BwfxUyEQpb
	isxx9ivi/QRpNPhGdLwrgtSPymqqtW566ZSSGDhc7YnRPEB2lMKcRAPXGPkAmeDmFVlDFxlCqImTw
	Ht8BqOicwEUGhCq8WstQzwyRIm9h8GbQZn49pcV1cEtKuwVRTpqw44fDSHJCfgBn2zZCj3HsQqTQ2
	pzEtimBg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:38336 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.100)
	(envelope-from <re@w6rz.net>)
	id 1x5sy6-000000027mE-2eEl;
	Sun, 13 Sep 2026 16:46:38 -0600
Message-ID: <cc6f0c40-22a4-4de6-9449-afe05b9c8f35@w6rz.net>
Date: Sun, 13 Sep 2026 15:46:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 0000/1815] 7.2.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065648.999753832@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1x5sy6-000000027mE-2eEl
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:38336
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfHIvtAi6iHKWfGnIq9YCzesVcOp3zVOXJgrtWTLCjQ4LVRBqIJ/w5d5/jCJE1eQfmJfVmWAf6ADut2MsU8amiLr6O0mvJhYl/UGXulbk5IToXkE6sY2+
 z9YaXxqvaCk+Vpkqly2qMLJ2/4RlLR0FfoLgwt3EwBHem/OkevNxqNQbNlE6l5YNqBPAYp2aLBW42w==

On 9/11/26 23:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.6 release.
> There are 1815 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 14 Sep 2026 06:54:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

