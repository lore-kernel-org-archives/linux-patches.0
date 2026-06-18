Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05DA285CAD
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781771497; cv=none; b=IXERm2PzeZDjvY0C+lKDCyEz2+a5kJlUn32nxUl0fqg+k/41i2TGbUDKzUAscVJYTCDLF8xAIxgxRgQxm/aMQ8JaF0rXTQlL0Dymm2lRYDYMX4q5biOb3BX7UisjA9N8fTQPkNoAT97V70IaWMz/8NArOIvMWuhfLCxuC4K17b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781771497; c=relaxed/simple;
	bh=oalKWUa0RrnEC25wlR5N/jW4SHL3BFzsA4VTUanc7aM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jmrtN/qjMpDHf8ZeaooQBfDtRTBhgDlV06mVd9y+Zqlbya2ZB55q2SbCIh4hCyGCpQlnz/kpfQsJ+/+P2+fw22FxE/CPB1TAH12hXs/rGTFTomT/0/DrLDyPiTPbz8r5xbRhQAfJKaHk6dfkBVxdiVWi7FHr1+pWQw2ynNmZSsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=pB6O8XuO; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="pB6O8XuO"
Received: from eig-obgw-5002b.ext.cloudfilter.net ([10.0.29.226])
	by cmsmtp with ESMTPS
	id ZqoGwNvrMMFEga89vwhcHC; Thu, 18 Jun 2026 08:31:35 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id a89uwnOQhmZHDa89vwr5j1; Thu, 18 Jun 2026 08:31:35 +0000
X-Authority-Analysis: v=2.4 cv=M6lNKzws c=1 sm=1 tr=0 ts=6a33ace7
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=wT+KmmCCwuZUgF8W5NZ74FwdWIuqzrhlRPoAInl9W2o=; b=pB6O8XuOto748lKdzeRJ0hDV/5
	lTRUmV5bvdHaSLPzKLvABjySckUIpPsskNcIJhdS9oS26wYQS3uuV88hKuBQMrA2NHLgwRZKmcXY8
	o64DA54K983XPYKxaLHoXZ/7eGRcg///SuNMJb5dKw8Erxr4akaLUuAaerjWQr4i2pIYkiZ94JQS7
	d+koGXfAJ/HEx1AgAiFkCFKuqT7lJiZotDPRLxwZyKvbtBwD5KPrKmzuol1Gd3gq/VuUC87C+3DeB
	iiv7UGWZDu0pEXOU+tmszr95dalMWdFuDK5Ru0tKdibsYRaJCApR18IGwhNHxddfuTZvFKUroN+Lu
	v/bQ1wjw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:49442 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wa89u-00000002gH8-0JCj;
	Thu, 18 Jun 2026 02:31:34 -0600
Message-ID: <5d46ac0a-7728-4959-aac4-1feafc5e4735@w6rz.net>
Date: Thu, 18 Jun 2026 01:31:32 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/410] 5.15.210-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260617080316.111043001@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260617080316.111043001@linuxfoundation.org>
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
X-Exim-ID: 1wa89u-00000002gH8-0JCj
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:49442
X-Source-Auth: re@w6rz.net
X-Email-Count: 98
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAkcPAJpLFeAfdvyoo+1OBzEvHP87tchvHIk00i4dLQ2OIHv+iqyKyJ6Lm1Z5iefWCxRR4S6Elu2iCz97Y2YWGuoLjNMk0CfU/NPtGNojpM/UNj6HQAG
 la4GhN7ixlrVP4KI7jNk2i1PfB8zTAw1IdgmGQ4kpfCWQz2Ayanuvz8QtxbQ6ZGaLjSFtjs/ZKCmTw==

On 6/17/26 01:03, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.210 release.
> There are 410 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jun 2026 08:02:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.210-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

