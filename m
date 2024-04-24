Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2066157468
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 08:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713947318; cv=none; b=ZbMk48RCeDIqpYXHCTVdLl7JpojGtZFyS04Rx3JbTsTSrAI9GKlBOAXLxExqJJEHtqbdHfh3hMA1KN7KcLi6efrg8NGkIRTQLjQkUdRQl0Aq/1com6fvaeCqFN8RwdvInHomVlaESPXHGCw0iFT5+xxuDkPBqOgbPJbj9ayowGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713947318; c=relaxed/simple;
	bh=KYTWpKpv6oeY+/R5jsWkNe5xS0x8WQ750NNzb1M/t1s=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=tl7SaS4CuCHx12a6W7hHXL/e7ge4nKwCnxu1GBJ55Bp3vgXH7crKPknBNcZXSJCWIbprJI2M91fj310A6b0ENAvU0mlFbve6JQqJr95Uk+hk/ajoLA/D20+TVU+F+W6PydHT2RBCIjSxk478jAh4z8rHpP4O9ecbdpTeZJ4PwLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=s4iEImEd; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="s4iEImEd"
Received: from eig-obgw-5008a.ext.cloudfilter.net ([10.0.29.246])
	by cmsmtp with ESMTPS
	id zIFGrNlNXQr4SzXzXrGrad; Wed, 24 Apr 2024 08:28:35 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id zXzXrHyb1U0uyzXzXrszyh; Wed, 24 Apr 2024 08:28:35 +0000
X-Authority-Analysis: v=2.4 cv=VYTxPkp9 c=1 sm=1 tr=0 ts=6628c2b3
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=raytVjVEu-sA:10 a=-Ou01B_BuAIA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=CMKPsDBNFkSOfaRWdswA:9 a=QEXdDO2ut3YA:10
 a=AjGcO6oz07-iQ99wixmX:22 a=nmWuMzfKamIsx3l42hEX:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=XmzQCDWatu9ptYK38PXzDUgh/4x84Gi6I78nuRqijYU=; b=s4iEImEdmvB49yeN6d7uUi+WWd
	/vZK1TIBC4UjmnyWPMXjHpccX3As9kP6cK/gce8abnUBoXEk2cycH1VoyN2mcG8M03tOl7zTmsmfs
	ilQGGkWzU7ldd/k6I2Vs6yNgydkKgTS3onyWHFjPqXdjrVCVyWBLcXSwIw7+00d9BNrN1YDGwagrY
	WDTKY7qAGjSaPkMrS60kJCUhRUrDkcv9VaFGVyfkO8Qs7w9fnbtICd00v8EgnUERems9cgc8IJiMK
	qUlwqZHY+BlyQYQGYNtgm5/inySYJHmq1k/GPK6ObS1Fp0NOgheHx6hfDxLctVv3v+ym5wjgKJr+U
	itBvOukw==;
Received: from c-98-207-139-8.hsd1.ca.comcast.net ([98.207.139.8]:59366 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1rzXzU-003d7O-1R;
	Wed, 24 Apr 2024 02:28:32 -0600
Subject: Re: [PATCH 5.15 00/71] 5.15.157-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240423213844.122920086@linuxfoundation.org>
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <da2f9f9f-5a75-2ce2-22be-ec7fdd97f6bc@w6rz.net>
Date: Wed, 24 Apr 2024 01:28:29 -0700
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
X-Exim-ID: 1rzXzU-003d7O-1R
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-98-207-139-8.hsd1.ca.comcast.net ([10.0.1.47]) [98.207.139.8]:59366
X-Source-Auth: re@w6rz.net
X-Email-Count: 60
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfFkIRoNqcI+9tc+S1GqvSb6GWJN9V7EpQHDhBSLqb0RjjF0Xhl8U/rCXtr74Y5sfzTZoF1qn92AewxK5ws1dBCk79cKj5tsD/6FZkQZIBeaF9qc3/c0R
 XxCAqLRaYvzSxZCEzWE+w6EYs4nebcTYOt82N9bFi7MgAEpr1AbAU0Ny4A5LXsN9b2Bkm92ObqPSpw==

On 4/23/24 2:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.157 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.157-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>
