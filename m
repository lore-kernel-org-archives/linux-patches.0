Received: from omta36.uswest2.a.cloudfilter.net (omta36.uswest2.a.cloudfilter.net [35.89.44.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EE9533B6EA
	for <patches@lists.linux.dev>; Fri,  3 Jul 2026 05:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=35.89.44.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783057312; cv=none; b=NQN32nHRs7lw8h0zG2i/b+f6ZoIPfAG+2U94RVtxJWnnmS3Uj5XMYLn1VQhoLK853Y+JZ0g7nr5zfDJh05HGblc1uoP6D8kygugEWkZ9kGB0GtWarCxMlEBxJ3jmweHk8tdEbKeNhO75BHy48RehWqCBwYq2xOsKcDZJwUfCxsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783057312; c=relaxed/simple;
	bh=1pJH6MM/YI04BFzDJJll5C6T+U7N6I/hlXQqgKp7w+U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gaWz+cyq2rJd6LmZErRzIzCS0mXHex6zuU70QXO6glGNo85VQFwo/Ag0QJXFAq62zrOMiiD959atABuNEozJiouX24JqKhYjj3vi0KIEw47SBCjpSmH/4hLYHET29X9DNSzIRgopLKsW6xMCdBspBGOeuxwAI/Aoo9mZh8QgoYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net; spf=pass smtp.mailfrom=w6rz.net; dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b=Co/OpGna; arc=none smtp.client-ip=35.89.44.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=w6rz.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w6rz.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w6rz.net header.i=@w6rz.net header.b="Co/OpGna"
Received: from eig-obgw-5007b.ext.cloudfilter.net ([10.0.29.167])
	by cmsmtp with ESMTPS
	id fQO3w1R37PpWVfWemwZa6H; Fri, 03 Jul 2026 05:41:45 +0000
Received: from box5620.bluehost.com ([162.241.219.59])
	by cmsmtp with ESMTPS
	id fWelw9U243bwffWemwMcSI; Fri, 03 Jul 2026 05:41:44 +0000
X-Authority-Analysis: v=2.4 cv=fv/cZE4f c=1 sm=1 tr=0 ts=6a474b98
 a=30941lsx5skRcbJ0JMGu9A==:117 a=30941lsx5skRcbJ0JMGu9A==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=7vwVE5O1G3EA:10 a=VwQbUJbxAAAA:8
 a=smfpkZXRov3BA9rGheEA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=L5EjiQpGQaFGZdqT14z7:22
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=w6rz.net;
	s=default; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
	References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=IpbFOvjkuLZ5F6PCLXLKuWI6WEUni97OdegGtjGwNOM=; b=Co/OpGnazX9lDGKS2yLxq8Vwhw
	RhYGKo5JR5ZN+IEihE9JbuF+/Jp3phjzlM4oU0MMyNk5qHHQKs8BuYECbJ548Xaem3+n2fhymgvAQ
	j21G2sUD0B/D7Td4H24ix3/Wwe/d3leIcS2KzZBEG4xGPYCetrcEe5+TFar3B0qPUk4IG64B32VSq
	csASdgTfkABWlOGd36ugP2FrEKxWfVcuWg8Tz2Qfu5Lff3jbFupTaSC1EYcOdBDGskBNYwSDBONat
	vyUE9nVGbOr1GldUJG/iUOuNbVQhonHlyVKPfvWa2SkKcSewqJCYnh6nru52+Emez4vNmhfnGGUbP
	EZErYHHg==;
Received: from c-73-162-206-103.hsd1.ca.comcast.net ([73.162.206.103]:57166 helo=[10.0.1.180])
	by box5620.bluehost.com with esmtpsa  (TLS1.3) tls TLS_AES_128_GCM_SHA256
	(Exim 4.99.2)
	(envelope-from <re@w6rz.net>)
	id 1wfWel-00000000a2U-0l6Y;
	Thu, 02 Jul 2026 23:41:43 -0600
Message-ID: <45619dda-652a-450a-bc91-6bcdc3e6edeb@w6rz.net>
Date: Thu, 2 Jul 2026 22:41:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/120] 7.1.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155112.964534952@linuxfoundation.org>
Content-Language: en-US
From: Ron Economos <re@w6rz.net>
In-Reply-To: <20260702155112.964534952@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - box5620.bluehost.com
X-AntiAbuse: Original Domain - lists.linux.dev
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - w6rz.net
X-BWhitelist: no
X-Source-IP: 73.162.206.103
X-Source-L: No
X-Exim-ID: 1wfWel-00000000a2U-0l6Y
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: c-73-162-206-103.hsd1.ca.comcast.net ([10.0.1.180]) [73.162.206.103]:57166
X-Source-Auth: re@w6rz.net
X-Email-Count: 18
X-Org: HG=bhshared;ORG=bluehost;
X-Source-Cap: d3NpeHJ6bmU7d3NpeHJ6bmU7Ym94NTYyMC5ibHVlaG9zdC5jb20=
X-Local-Domain: yes
X-CMAE-Envelope: MS4xfLceW62j0vWG6xAl7honVLbWgYN9wXGBx/ERsMtFlcsrHZDcPOO6fYbUijnG/7I/MC8YnUs59+KY2LmFX2FzFinuKtozMqMy709A/qOQpSKC5Zx2/FMO
 jM3WlWBZyPPnGGVlp1qpAiBaFpiStETF9h++u3h9cBdFONpelWugQcXuLjM3XVqwACOepNzB3z0rYQ==

On 7/2/26 09:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.3 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 04 Jul 2026 15:50:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.3-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>
The build is broken on RISC-V with:

In file included from mm/kfence/core.c:36:
./arch/riscv/include/asm/kfence.h: In function 'kfence_protect_page':
./arch/riscv/include/asm/kfence.h:25:17: error: implicit declaration of function 'mark_new_valid_map' [-Wimplicit-function-declaration]
    25 |                 mark_new_valid_map();
       |                 ^~~~~~~~~~~~~~~~~~

This is caused by commit "riscv: kfence: Call mark_new_valid_map() for kfence_unprotect()" 66fcdb7f71b9d3d32828130cf5895adea059016d

As already reported by https://lore.kernel.org/stable/6c5c0723-66c6-4f9f-8021-2562efc95c6e@iscas.ac.cn/, upstream commit "riscv: mm: 
Extract helper mark_new_valid_map()" 9ee25d0a70ff4494b4e1d266b962d0a574ef318a solves the issue. This commit cherry picks successfully.

