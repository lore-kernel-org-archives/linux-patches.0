Received: from omta38.uswest2.a.cloudfilter.net (omta38.uswest2.a.cloudfilter.net [35.89.44.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A19C327BFD
	for <patches@lists.linux.dev>; Wed, 10 Dec 2025 22:12:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765404754; cv=none; b=rFryJtrk4SxQDUfXPxyVw/flXOxiR5bB/Qds5K2Ay4h+rF5NW5/gTk5mXuWmRLw+kfg7m9MMxUBg9XZf/rnpogwjGdyY5m/ZwsOP/8J99clxJypdJK2L4j3Sis6jAmGmBicaa6fSRL4xg3VA9QxjhdjAqQf6sO41gXaKDKDXKqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765404754; c=relaxed/simple;
	bh=3YtcOKY8A31HEq4fRTlcWrzIzVHlAZp8XyxEHvalXWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oWyaM00dIZyO92EF2yg9cBQgoJa8fup8/bcBGZQ04vF480fJy1vjHfOpZaFha9zjEqzSUQX1vMf7tJFZxGjbulATzO5DYip75c4UsGV1CFPOXMC7wwvTFG9yufMFvYr1TUHVRYM9ufqMDNHKXMKpdOZOHJ6+SaWMDrLdZoZWKMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Jia6NHP+; arc=none smtp.client-ip=35.89.44.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Jia6NHP+"
Received: from eig-obgw-5004b.ext.cloudfilter.net ([10.0.29.208])
	by cmsmtp with ESMTPS
	id TDKRvWx6GipkCTSQBv05S4; Wed, 10 Dec 2025 14:12:31 -0800
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id TSQAvpUTOqfpWTSQAvkxho; Wed, 10 Dec 2025 22:12:31 +0000
X-Authority-Analysis: v=2.4 cv=A55sP7WG c=1 sm=1 tr=0 ts=6939f04f
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=wP3pNCr1ah4A:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=HaFmDPmJAAAA:8 a=49j0FZ7RFL9ueZfULrUA:9 a=QEXdDO2ut3YA:10
 a=nmWuMzfKamIsx3l42hEX:22 a=Wh1V8bzkS9CpCxOpQUxp:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=C3dCAq2CdIGfaK2B9Ymf19bTFQtg6uA8yiJ+ZpzgZgc=; b=Jia6NHP+LA/gsuJHbxrIQme9AD
	k0TIlO54BgA/vVIkka7U/VkQMbqUjcXJVYoD51l8+nYgQXfVdpBAejRPNv/t+t0i0qheMZzQrwoLt
	y5Aa6/HWoPjRQyFw5jFoFzaXHJfmI8AbjzThsFLz0GEFtgbVvZ2zF0Belz0CYLOpD/Snj6+0j2XMH
	wCg4zs19HIpabVroUpLGfoxihQPKXaCXa+44TIupC7HBpkLN50DhT97dtSSv4P6yJbdBUWFoL6Tbc
	Iv890SMegw2tk0con741zt98slgrOB46JI2z13hlEeXGVLy+f0MPE7S/T+UbHlX+tq2jwFGFcWayb
	ueA2XzDA==;
Received: from c-73-92-56-26.hsd1.ca.comcast.net ([73.92.56.26]:46082 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.98.2)
	(envelope-from <re@w6rz.net>)
	id 1vTSPq-000000011wC-0LRp;
	Wed, 10 Dec 2025 15:12:10 -0700
Message-ID: <ccfd3227-c94a-42da-9d53-a9e4f05e4baa@w6rz.net>
Date: Wed, 10 Dec 2025 14:11:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 00/49] 6.12.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251210072948.125620687@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20251210072948.125620687@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.92.56.26
X-Source-L: No
X-Exim-ID: 1vTSPq-000000011wC-0LRp
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-92-56-26.hsd1.ca.comcast.net ([10.0.1.180]) [73.92.56.26]:46082
X-Source-Auth: re@w6rz.net
X-Email-Count: 38
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfC/CAIeHmPB17vN1iaAb/LlEmDEZa307YSSAotwQ/30LBajfxnbuBjbqUR25pX/oZbXxBYDH8zcBneG1DLAIhPfYsLFhOl0UHEnfUVGoR/pbqrt+fHMT
 /HC65LGBR13NOvq+6PQHtf1aVW2KYxyz6RgD3Wvy6ujHGFBQKgBTWxxKHZtm2IM9CMwpVB/+QF2msA==

On 12/9/25 23:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.62 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 12 Dec 2025 07:29:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.62-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Built and booted successfully on RISC-V RV64 (HiFive Unmatched).

Tested-by: Ron Economos <re@w6rz.net>

