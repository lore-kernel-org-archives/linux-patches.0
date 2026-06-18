Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DDD13B27F4
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 08:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781770139; cv=none; b=gbw832/q3TgW7WpK4CSVAhdZDUnCz2aR6XoFe+ZpY5+Yzgtuu0nmQqZUBgqElTDEyrgUbrdcNSEHZKFHi9tQAXlzw5jlV9XbSesCl0XyByrOF2X9rph5Dgh61YZ80NZKn0tdOAv7jnyBaOISBWa/XiCb8Vawg1caOMRDA5ypoyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781770139; c=relaxed/simple;
	bh=kQDq92TZ0/zcHt7npGEiWArikkJTnEfK8CahfQQCh3I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MbTE2Hctn5hkdF9qvrIFF5zNnakXBKprfQtg8vEBkUM1oy08XZ/xASUEkzoqPmN4LTncRb/GjLcyA1Z0bCvd85EHHEadtZQud9LwJik0zFu7phKuefTJCLj3NJBZwEmrqx616C9sBRuUzLAk85z6JWjKXwXbg94XBgElfzSkZAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=H/vZoKpl; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="H/vZoKpl"
Received: from eig-obgw-5006b.ext.cloudfilter.net ([10.0.29.217])
	by cmsmtp with ESMTPS
	id ZvUZwP9XnMFEga7o1whUn8; Thu, 18 Jun 2026 08:08:58 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id a7o1wEOF0hFZUa7o1wJ5AO; Thu, 18 Jun 2026 08:08:57 +0000
X-Authority-Analysis: v=2.4 cv=RduQC0tv c=1 sm=1 tr=0 ts=6a33a799
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=9GQXaQUDpQhx98mIA28A:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=gzqjjqtIMvK8LPow+2uCg6tEti/DxqjjGl3o0uxALdQ=; b=H/vZoKplcQSatQ2uBy7vh/6yGF
	d9KK6Qa+bx3spHSdQrBTeyX1uNifkMBfxrg7TnljgjYXbzKPXw40oVGCUcvWzVS0Fi6vi46Nd5ZZK
	xk0JOp+W0GiPZbA4D+wRdpog3QDMeI8TC8NVxVEdfuFT6N+F/6mW2jteMrc+3JjNiLKn0aJT9OffL
	nvuCliSc3tQxfk//5PYUXfDAaRpM2fk7FR22sQggBDFnaOrfc2T/wOTH7FEFBjoH+aJHkx5vCPEde
	W7op6NLPlFr7K1J9319/WZo5IZK5B1mG8NC3oiCZ38CGh60WVH4zKDD/L2SGN9rGnOFNYx4it+qKQ
	DfsLWkjQ==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:52572 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wa7o0-00000002SGv-27Pn;
	Thu, 18 Jun 2026 02:08:56 -0600
Message-ID: <0dd0ada3-28f8-4369-942c-4d1f65c2a1de@w6rz.net>
Date: Thu, 18 Jun 2026 01:08:54 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145044.869532709@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
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
X-Exim-ID: 1wa7o0-00000002SGv-27Pn
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:52572
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfCs0L9ObqqfypBo43v/xz4dr5nXRKioiMB2rwY20FW77wBQJZVaJ3ygOEb/NVrNnjf8l6ww2PKN7YMIOkjlh7Z3b0ORCrfMsOUzT4Ti1VLPJcmpcxBjA
 Pxl2Yj1BLuAObUUlv3pQ8qnpjUtLbVaCAMCHkvQVBh8OlSMQiiFh3pTGgDBvyo4LObqmAJ6sUNCAEQ==

On 6/16/26 07:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.94-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

