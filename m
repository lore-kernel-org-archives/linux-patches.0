Received: from omta34.uswest2.a.cloudfilter.net (omta34.uswest2.a.cloudfilter.net [35.89.44.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616822877FB
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 09:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752055131; cv=none; b=JO74zumT7Z/VjhoyndY221aDZVXCHez3D2gIsu7l64MovL/d74D9XD2Xstr7BLGVc1Yw+aFlhBnUOwEvtihH/stSUdXxoHZMaLij2oCU6GbbJfjIvON6i2vpgghvgXd0BX5YXI/9NIDEMQnURlvxUv0wqa93o5GxXlEFuuA4+04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752055131; c=relaxed/simple;
	bh=8nWTb81n0h18DwoRgCOwtdmkDH8pEICyg/BCNT06z0E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dKI8gn2cBk+UoyF1Q3ulLXU3xVXMtay+Mz9MPrOdpqvxmxgHbzsfbVEUfhrP1MghilNMLm0cXoR0w0APeEsxQTS5mKkHDd8W2RbhhsZazpSt6Q1AFXKKFSghZWK6+2e7jBh8/RHfzprnprhAy1h7jLflfP0N6GRAHsasbv1UK1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=WrH7QZl3; arc=none smtp.client-ip=35.89.44.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="WrH7QZl3"
Received: from eig-obgw-6003a.ext.cloudfilter.net ([10.0.30.151])
	by cmsmtp with ESMTPS
	id ZPU9u6tYJWuHKZRZaur7wr; Wed, 09 Jul 2025 09:58:42 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id ZRZau3EdbPubtZRZauDTr7; Wed, 09 Jul 2025 09:58:42 +0000
X-Authority-Analysis: v=2.4 cv=FYD8x4+6 c=1 sm=1 tr=0 ts=686e3d52
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=I+dNN6fbWA0KEUvI2+owr1v2I2NCE+eWihtrSeVVg3k=; b=WrH7QZl3uUJ6FowIY2Lw7UjMTM
	llDdSBIsQ2ZgzTq8k70IMmgPynC6f6Q9nrD87ApFMQ8Z1w8bbq3N/L/pyV9hiayyv79VOaqs1fzph
	HTv1YZt/bw6vXys0wKCo8lh4/ECIz48azKpRq4qntiEWsnROKB6EVmyTgVY54sxqfQfcMKhN/LMVj
	Mam6QiULl2OJN0bEJ0g6Ng/4+VEBYIzmc6no5UJGlid2BpkdASkKwfCiKh+Yz6EZZ6O8slwkfzxm5
	sB3oItnvZscwg6oGMNpk6IkZMvRXFhow+GaUJ+UbZqCtHW0bXl6/Ntd071JeyXj5UuyllxMTrhKez
	6dQigySQ==;
Received: from c-73-223-253-157.hsd1.ca.comcast.net ([73.223.253.157]:60910 helo=[10.0.1.116])
	by box5620.bluehost.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
	(Exim 4.98.1)
	(envelope-from <re@w6rz.net>)
	id 1uZRZX-00000003RYj-2sON;
	Wed, 09 Jul 2025 03:58:39 -0600
Message-ID: <fe87e12e-7e5e-497c-bfa3-c727e7f3a18f@w6rz.net>
Date: Wed, 9 Jul 2025 02:58:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/81] 6.1.144-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250708180901.558453595@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20250708180901.558453595@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.223.253.157
X-Source-L: No
X-Exim-ID: 1uZRZX-00000003RYj-2sON
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-223-253-157.hsd1.ca.comcast.net ([10.0.1.116]) [73.223.253.157]:60910
X-Source-Auth: re@w6rz.net
X-Email-Count: 75
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfOlq9EDQ7it1X2FvjT1A8g2deV1vkmNGFddMTtCV8EWnmKQnZY8KxrGrNWCc0hb/oq47Z52p6kG0Sc5z+XftAXdfpCH8QAQLcGWO0NaMJ/FVPZwtYfYu
 uVWZrI1Aqa6+TwqCZn7YjkmnHjk+9hB/eBV/+95r7jDFcZgHy940gUvL0NaE6Ja54xc6AmYXNS4/6Q==

On 7/8/25 11:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.144 release.
> There are 81 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 18:08:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.144-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

