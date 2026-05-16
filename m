Received: from omta038.useast.a.cloudfilter.net (omta038.useast.a.cloudfilter.net [44.202.169.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CF3226F29C
	for <patches@lists.linux.dev>; Sat, 16 May 2026 22:06:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.202.169.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778969167; cv=none; b=ukqGcUrYQkMBh7gHXf9gNou8wYhf2OfT23ie8Mkp4TnaIH2K0aTGOyJCIOwUr2fCnUrBuwHM9YmXkoYhAoUGqVbo3X3Pq09GS1C/IeEL23Hhf5y2FXMxQBMieOVRW2Y1evpK2pd5NAB9XUphoswzpY3gTHTirLaeyHfq4swl53s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778969167; c=relaxed/simple;
	bh=ilCilaaf6gRwgjemgSnk9U0GJeBNUx0usDpqJx4xnBA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RHql/oM17x76fUouVoJrgKDww2g2dONxBZt8NfdHwJP9T0d9ufpQhi8n+K2liQEIOwf2xvyVeJehdDvHH8izSPL/2VLaLzW5M4b6GG6t+j20KJ2hhvYhaCs1ehK8k3n/wO7S2+EV2TiIVVqU8OTAmVCOV0BEykrG0/9IOu4yMjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=UCeycS0g; arc=none smtp.client-ip=44.202.169.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="UCeycS0g"
Received: from eig-obgw-6003b.ext.cloudfilter.net ([10.0.30.175])
	by cmsmtp with ESMTPS
	id NzMzwZYnIuVXCON8xwLqIr; Sat, 16 May 2026 22:05:59 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ON8wwAC69rFQpON8xwZlmI; Sat, 16 May 2026 22:05:59 +0000
X-Authority-Analysis: v=2.4 cv=bqFMBFai c=1 sm=1 tr=0 ts=6a08ea47
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
	bh=WNi2D3kpNM0OeRaHDp54oPvEP6/lp2pJPvAHpjaxLFA=; b=UCeycS0gjJHZm9bDhlJQmibCtG
	Bq3EoOi9upTsJ29X5x7qAhQeQyv0Av4suymu9wxkUQ89KeWtQsQSy+sL2wCN/MBORU/c8won6FBSi
	D2J+pvy31hf/p2nl/eZd0P3wMiLKNxLuhjEta08p8rNYrbkCO4EyG+CmeKd9N2CxC8CGbh0quXoVm
	CEqQqhUxjrzMD/ByLT3V79Dfx6z2ONuLsuzAXam8m3LL8UdHemckHTO6tOZXnnuM8HBS50QCkwdTG
	/duVU2EFh+8YGdzPv/G9t6AY+otuWKNFZOf1eg4O7sv/38ubhquurIs7eshbC+p9VY7zzDQ9j2xY9
	TEz/QAow==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:37900 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wON8w-00000002zfx-0SO1;
	Sat, 16 May 2026 16:05:58 -0600
Message-ID: <d9152b53-449c-41b1-9a40-a81bd30a4650@w6rz.net>
Date: Sat, 16 May 2026 15:05:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/474] 6.6.140-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260515154715.053014143@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
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
X-Exim-ID: 1wON8w-00000002zfx-0SO1
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:37900
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLz47WgrmaYvClFczgspQ2OzxPB/CVV+Md0T3VN8URdU6+ZJH5x6zMfa+huq3qxurlbd3g3cJbvzu2GQWyqvCUlEx5cU1oHJzeURv9HpTUj0gznYF77F
 pSIAyM1KPDpmuFFNCDhCySvY5fFL+D81m2Nmnq8af4OWcDjcTVy2Qe73ntTKRVdlY0GSPDoVgbLL7w==

On 5/15/26 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.140 release.
> There are 474 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.140-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

