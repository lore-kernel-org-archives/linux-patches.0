Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FEEF2D5940
	for <patches@lists.linux.dev>; Thu, 14 May 2026 00:37:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778719070; cv=none; b=bR0TU0M8LjZldxtTh1ssMXvauwwV6p9rPZxNBVSmplwHm5PbNOr0Fo86BpWd8I8/DJNIYTntgHn9Ad9E0SN5VknXyHHYPyi82ssY9i9agfiLlLDKBBJFSNN9XxcwloVY3zhiiYqYrlXOeHduA3Xu57xYWViv1DMjK+AzW+3ZM+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778719070; c=relaxed/simple;
	bh=yeWhoyckRf6rgOKvx8NWSaEqZ+CpEuTynmi+CRkMIQg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Dc7XV/YlpIVfCDiKjdnHEVRcYupi3YczUKN2IyVqcZS7acdTeI0sNkcIEvuVkZARQFPYh22/rafYNy7D0A2ruK0e0ys7ZJHGatCxg4TKu2ilVGgbXxWYNhp7EHHSDKYzS+OCQdfJFGiBmpbzg6vQ63KxR1du0xHMAvQg/diZUtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=g0M7qJtA; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="g0M7qJtA"
Received: from eig-obgw-5003b.ext.cloudfilter.net ([10.0.29.155])
	by cmsmtp with ESMTPS
	id NCAYwtoFirDqVNK5EwHfDm; Thu, 14 May 2026 00:37:48 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id NK5DwlzuSCKa1NK5DwYHZd; Thu, 14 May 2026 00:37:47 +0000
X-Authority-Analysis: v=2.4 cv=IaKHWXqa c=1 sm=1 tr=0 ts=6a05195b
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=5G0WRUIxEP0gLMBNPuSopZfRi2shEJ0o3AxwzubAV2w=; b=g0M7qJtANOg8xE7ey9WGYnoSD/
	W9mI9SitGbACWwVceHSUaD8F44D5U2pLAq5jyhiM9fojaCJl+TS8CCEiT7Sm0UuCZ67Aosta5HeTK
	TGQbYmID0GskYMueFJ4VdpmLFxxepk9ujSoB80IA7vq+eEqDX+DPLqqLFDmY/azLQ2TFqI13YjYeE
	0R3Pv7Ssst9UglOadjHexMgweNzPz4Aj6RYSk8Vy1bv5AjfLCy0WZFYwwXuWfS4PHj/gHWJks5aHa
	p3hvRBrojUZD1QY6o0Rwgth7kChOqJVC1qsFIK+7Mrc640TTL42Aj1CnVl2OwN8PhZ8Z8ocSJIYR9
	GxZ0tNaw==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:51662 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wNK5C-00000003T5B-2GsL;
	Wed, 13 May 2026 18:37:46 -0600
Message-ID: <e3a06902-9c57-4df5-af2a-05e5a484be16@w6rz.net>
Date: Wed, 13 May 2026 17:37:44 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/202] 6.12.88-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260513153743.326058350@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260513153743.326058350@linuxfoundation.org>
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
X-Exim-ID: 1wNK5C-00000003T5B-2GsL
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:51662
X-Source-Auth: re@w6rz.net
X-Email-Count: 58
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfAGfi+NDY7+iJV53A6pWWwlfUdJehdbaqkWaWLHCBB8PZKsG7DpN8EiH734CJytYJK/b5gX6ovbAx4TiW1fYT9fl+rmbp4t5lMij9hLmkErriF2OWufM
 svHuB3Qiq5DKACJOqtjNgUIxm18isvC88wxKONjdeXd4jWZzLBAphtMAm2X7Nzl3qYts6Jq+wk5bGQ==

On 5/13/26 09:17, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 15 May 2026 15:37:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.88-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

