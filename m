Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257941E4B0
	for <patches@lists.linux.dev>; Sun, 29 Sep 2024 08:29:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727598548; cv=none; b=kjTb4BF1vFOKh11nqlpaL9C4yPemvTixpSu6pM2uJuqOWg3FwK2HIWAj2yAKJ2OlFVIfR68APyic87Adpf4rId8507oTxNL8EyT6qp9+kwnN7DQUmPj6zbwxIik+uJ5TO+9Thmjr/mx8fiKjX7znRcvS+gKBNb+dOOgrhbohEnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727598548; c=relaxed/simple;
	bh=tHRyrLPcSm3HM6u3JAcVuv3MR6egb4hEmiK5dPlx4Wk=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=ElRo13lL3Bqcyu0eSS/UmNZmgAbal4tv9Ff9gZNNtCOQPL9G6QxXb1J1gbV1qiwWtsrG4hppWfoiCgKPTnl/BOB6R/CrjYkFHpV40dEzmw7SvyhN55kReneJTF7qPQ69nCrGLBFOalfb2VVXugClPRdDZZG5TLvXgmAnc8N5h3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=YtOoZ2m7; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="YtOoZ2m7"
Received: from eig-obgw-5002a.ext.cloudfilter.net ([10.0.29.215])
	by cmsmtp with ESMTPS
	id uPAcsnMhYnNFGupIfsgFcO; Sun, 29 Sep 2024 08:29:05 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id upIes1onFcEKuupIescPIU; Sun, 29 Sep 2024 08:29:05 +0000
X-Authority-Analysis: v=2.4 cv=Z7YnH2RA c=1 sm=1 tr=0 ts=66f90fd1
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
	bh=2dUug4SSSRbXq+6phi7ey3Q6yy434qBCNBQpg/HBdho=; b=YtOoZ2m7xLloai9c6GxPqCZs2S
	zq7cT9QhqsHlV8BGdrEPoDbrN05TzwXlAJy2DrDXMZTpDMInQETuvcQThOMWU5pmxGQtNuxwOegYT
	8l2/BEafTtJ93IpFjM3xKfIMn7Zg77UB7JKrkN6nMIraLyA/qR7tLOTN3RNeqmFASPsYrl9KRqFpt
	9msp4n/S6M1nl7ud6VGxGEdqNBnwvkBsxOtSInCby7Y8OS0Cq6XYxDjzTChRm2Yu/KlJ7qUVanxQ8
	zk/O0Cgb0SoIwD/yLhkiJAPlc4bBz8pal7ukvH4vR8J5CHoU53Cd8Hf0cqPGQVwJmdf4xAY01JzcP
	lHIrQDhQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:43242 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1supIc-003o0s-1p;
	Sun, 29 Sep 2024 02:29:02 -0600
Subject: Re: [PATCH 6.10 00/58] 6.10.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240927121718.789211866@linuxfoundation.org>
In-Reply-To: <20240927121718.789211866@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <d9f09cee-b860-7329-0347-f556ce485cf0@w6rz.net>
Date: Sun, 29 Sep 2024 01:28:59 -0700
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
X-Exim-ID: 1supIc-003o0s-1p
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:43242
X-Source-Auth: re@w6rz.net
X-Email-Count: 22
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCT71lbuBZsJpG1Gw1j8IumP5/Gwh3wBWaFIXu423fy47hSjATJuo5iAFV6MDGR7SFCuM4Ry1WEPfhOqZdYNQXgP86o95jE1sZdLm9lo7MRj1xABH5xJ
 HbUDoNmVq0B4fS7LBIGQ+mFH68zl749562GUOYZWw0CDbyE3JEYmnt/HQTl3Yq2QTpvLwVnaxQ5Nug==

On 9/27/24 5:23 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.12 release.
> There are 58 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

