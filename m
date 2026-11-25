Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=185.128.211.58
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625105;
	b=FPt5rIMgZBSfXJ3EFMWRZ0yS5pshmZ/bTp9rQKlWJN5jH5QOz+KD0lGVoDkluoT2DtXc
	 wqV5NFlgjhoQOToA4kTjeIe1Bza/E6yAmHRUoC5BZmuuJ74Xkaro+k4zqXRLjdDFlAQTw
	 8NDRO+vyP7T5G/+mIWY61op9AqbsdxAr3GrYfE+p34n4f2qCs1MG7Aa4XjoMtjAnVNc3N
	 03fE6rTtu7u34pHeKUyhlqCnce7lbSKYWAC21FPQ4AmiiDN7/5Bxr8lAoO5MTIHu5Op6a
	 MjzE4ZTSd9BbTIhjtXtge7+FH1lDSHI3wqp9EL0/Qslz2DWk5t+AI8I4jJu1Xhz+laA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625105;
	h=DMARC-Filter:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=DwGwTm/1M3kaz0asEIDymcyq6yUBE0aPJnm3oVj3yFc=;
	b=W07fiBeVOgt5BExJ/wp1ATcvx3w10om16qi4qdNqO0tY4k/QfhM3oVwuGObI9GoOZHhV
	 lHprP34wNYxn6EJL+7uUzujLuLbohmI2xuJBULl3A1DKIQ6PkQCPu1hLLuRQW/swND3Du
	 antFWr880ODoFoofU8h6b6yvnCQZPqn1OrC1L4SzP+NxT9PrZGAPjCyp5arQURpJ3O0u2
	 sXqxDEPyH9DHBsuUHXDZcu1W+6aoeAumvZhCiIUP/jabdHX8nC3eG94rybrcq7Jq/WFlQ
	 OBW4gXTRpg4kR+F4pHdAxK6nzt4lej0brLqk6Odk2Zb+Y0rQMd0yhyMyroKTs0oAYWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=librecast.net;
	spf=pass smtp.mailfrom=librecast.net;
	dkim=pass header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=qT2h0MaO;
	arc=none smtp.remote-ip=185.128.211.58
Received: from bregans-1.gladserv.net (bregans-1.gladserv.net [185.128.211.58])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FF2606A332;
	Wed, 25 Nov 2026 16:45:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D4FF2606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=librecast.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=librecast.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=librecast.net header.i=@librecast.net header.a=rsa-sha256 header.s=2026110900 header.b=qT2h0MaO
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=librecast.net; s=2026110900; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
	Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
	List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=DwGwTm/1M3kaz0asEIDymcyq6yUBE0aPJnm3oVj3yFc=; t=1795625103; x=1796489103; 
	b=qT2h0MaODd2DFnylt7g6dMwMV2B+3iRiidGop9FEk0FUNxS1O5+KIxt3PkHAfwfkLw9K6mS7EBx
	z57UWONLSSS4btkcokOHlUtFF2FQvEn46rZvWxs5vNGvXdiBTmBoWEhclE9xx6tvNNG3G2dXk9g8c
	HeDd6S5mx6hO7x/5JeZjubttk0xsdawSh4PqRuImdTCGkFc04507UxaGhvz8RVTFzIbsJaBmdbb1u
	7THEGbKmSbl0ba1qJC5hlRNUux3EAXF+okZbTcv4QnkxZz5N6t/kuSD6Fhw9a/reU+MpwP/YZXENp
	DH869I8nixWJAwDgwcfZaEcx2GFLmIju/67g==;
Date: Wed, 25 Nov 2026 17:36:08 +0100
From: Brett A C Sheffield <bacs@librecast.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/990] 6.18.66-rc1 review
Message-ID: <awcOeGCwL3jSzG5f@karahi.librecast.net>
References: <20261125143822.072087159@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>

On 2026-11-25 15:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.66 release.
> There are 990 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 27 Nov 2026 14:36:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.66-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.

Similar build failure as for 6.12.120-rc1:

  LD [M]  drivers/gpu/drm/amd/amdgpu/amdgpu.o
  AR      drivers/gpu/built-in.a
  AR      drivers/built-in.a
make[1]: *** [/usr/src/linux-stable-rc/Makefile:2051: .] Error 2
make: *** [Makefile:248: __sub-make] Error 2

Reverting 4d1bfec69f617f91af00b5cb9b86cae8850049ab fixes the build.

-- 
Brett Sheffield (he/him)
