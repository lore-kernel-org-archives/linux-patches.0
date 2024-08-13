Received: from omta040.useast.a.cloudfilter.net (omta040.useast.a.cloudfilter.net [44.202.169.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF0C01A38D5
	for <patches@lists.linux.dev>; Tue, 13 Aug 2024 19:54:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723578874; cv=none; b=VmILLXz8UXSvcf0WGQrWSOwF4Na1y2bIhXwwsae3jXhEM/0lGao1wxepn4M3XJenxpBcQazg8mlNPDL9TZRvlaYJDICLEFyHUkMF9fL5DQDlc1cMfI9IEMFXdJAHa1oFta1Mz6URILSJPWZhPwQ1zotxFRFdjgfXc3Fh2fVksNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723578874; c=relaxed/simple;
	bh=enxY3ryoWp3VaV7DfNrcRSuftigREZDM2nOTakomYFU=;
	h=Subject:To:Cc:References:In-Reply-To:From:Message-ID:Date:
	 MIME-Version:Content-Type; b=fmnt68lGRUTI2ivvYPCPuabFrnt5g4iayVfw8bI/DMdJtSoURHjDGP4LsbLzeLlE/5hzFXimGuY6WjLSTwZEJCTjbj/JSjBG2cs2ZfjddJ8Eiq1u3wYl3YNBEAiBhb4LnjgBfUE0n1+7RX8UZKmdw1+1FEFDRyChEUjxe6vBIrM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=cn8IOjCo; arc=none smtp.client-ip=44.202.169.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="cn8IOjCo"
Received: from eig-obgw-5003a.ext.cloudfilter.net ([10.0.29.159])
	by cmsmtp with ESMTPS
	id duBpsiu6DnNFGdxbDs6yEk; Tue, 13 Aug 2024 19:54:31 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id dxbBsQsLFO7CrdxbCsKUwC; Tue, 13 Aug 2024 19:54:30 +0000
X-Authority-Analysis: v=2.4 cv=Pco0hThd c=1 sm=1 tr=0 ts=66bbb9f6
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=yoJbH4e0A30A:10 a=VwQbUJbxAAAA:8 a=HaFmDPmJAAAA:8
 a=LiOICBD-F-yQjxfn0DMA:9 a=QEXdDO2ut3YA:10 a=AjGcO6oz07-iQ99wixmX:22
 a=nmWuMzfKamIsx3l42hEX:22 a=hTR6fmoedSdf3N0JiVF8:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Date:
	Message-ID:From:In-Reply-To:References:Cc:To:Subject:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=ld1dfqlFeYWZAA6V4L5YMRNBg2IbDVmFMTRqQOHwxd8=; b=cn8IOjCoiETktihW+qFSxnTtqK
	3Pfgz4k58ZmJBldduPKo5mHKLdV1h0gXQBRxELZbrxX8fpD9SlK1gs7JYRVhEjRwWb0K3hPdEtfA9
	wGEUe68GhtVcsZYa5CHowByxnAObXT6UwWhUyhJy/Eqt7vQckyWIiiLovyvGGah4GEwD9epFcct8X
	YTInfb+XFInHvYDbPUQI9v0Kcz1tQYp0tXuJXYSz3kMlhQ5OfVoNUYi2BMxXbwR/18m2cmo3I8+b2
	4SnsuNvdGEt6EQdOaeG/CthPROID1lMSNXD83mnqwQCwyd0Np/2caxXwV+V1Rf6VVCUtWwGP6QQgL
	owRGvLcA==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:34490 helo=[10.0.1.47])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.96.2)
	(envelope-from <re@w6rz.net>)
	id 1sdxb6-000BDu-08;
	Tue, 13 Aug 2024 13:54:24 -0600
Subject: Re: [PATCH 6.1 000/149] 6.1.105-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240813061957.925312455@linuxfoundation.org>
In-Reply-To: <20240813061957.925312455@linuxfoundation.org>
From: Ron Economos <re@w6rz.net>
Message-ID: <57ca1c07-1cd9-eeec-6668-fafab5a8cc35@w6rz.net>
Date: Tue, 13 Aug 2024 12:54:18 -0700
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
X-Exim-ID: 1sdxb6-000BDu-08
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.47]) [73.223.253.157]:34490
X-Source-Auth: re@w6rz.net
X-Email-Count: 41
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfK3Tc8h7CtVgPginpST6v1vqKeJ5YWhSRQqt/NdYCia02UoThwmzCXHnfxc31iuu4x1Ki9+JgWc8E0iarAgMLaCwytkHtmq52nbtB7gczJGfadvYOAbA
 v36CnYJidoqNvLL+tkjkBYP4ARENM0IILObeDhW7F8KMCZJBx6mASdf3NsfxH4DEO57eKB/1x0mW9w==

On 8/12/24 11:28 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.105 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 15 Aug 2024 06:19:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.105-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

