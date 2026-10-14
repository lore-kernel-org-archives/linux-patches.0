Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E521B2F9D82
	for <patches@lists.linux.dev>; Wed, 14 Oct 2026 00:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791937793; cv=none; b=lUunpb9OQC5v2aEC3oheresUcpfqmRDA2GyguiLr/HsVGF5fHN7huxSqnyOhCjFRhD0Fp/sp0TTPjEsFGu+E6bdRiH5bfB9D+wqk8hkLpo0WlWxHHC5MoQynm7LMQBxTQzqOWCRITFmiirJ1pTXj2L9xvcY6a2oNk6q0I8hNJbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791937793; c=relaxed/simple;
	bh=XKI3tZkCyM4/TeKhUgNUVlBp6mh45GJ+REJfN4UHpEU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d79vbKCONm1DOuQqShmUjQzfDrStSAVE9zI1DCSZ6dUExY6y40gBcXzJWJPFYeQxpPfVW4sO8F1/3FizIzaO6ufPG0vwkKE1nsR8umJudlmN+Zv8GIifSwzOy2TQtmzuhzvIuWm/UcnLM20ZwnbNfYrRK/nHnoeL22MLS4zSpvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=uoZVhxuc; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="uoZVhxuc"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 90FEE14C2D6;
	Wed, 14 Oct 2026 02:23:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1791937425;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HFxL9EiG2VnTn+f1tPMCKHSR++5LrOW9CrXmSSjJ3i4=;
	b=uoZVhxucwFTSoDD2AXoYZ8DfipRk4z43XHJaAHasZcbNVkPjH1Pg2gK9Q3wtn/fc/1Xl8D
	CX2lMvOPxxaxu/56vq3/QThWXXXw3z7UHRf+3ASattI1VgjSnl+g0Mkj7OBnw9A7oIFG0K
	ijftoQC7MSrJO3f7x3jsA2QoO/trJD4FqgCtT9Xwa1DnB/0P16laAFTgQJ1k48ZoY43dpK
	T9f9T2u/yn53Dx1E0Tr5ag+Fvyk7c5AnMoacfBQheRUm3jBi2DwH/qQpyDT62nD6XGFQ3j
	Qf1cMofTdhk1FGo0/oYkKkmnqdnf70E3HoDatJomuV//MbvKpW5EPFpYnVAX2Q==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id c4e334a7;
	Wed, 14 Oct 2026 00:23:37 +0000 (UTC)
Date: Wed, 14 Oct 2026 09:23:22 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/497] 6.12.113-rc1 review
Message-ID: <as7LenFDmnKqmweE@codewreck.org>
References: <20261013112907.864180619@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>

Greg Kroah-Hartman wrote on Tue, Oct 13, 2026 at 01:32:47PM +0200:
> This is the start of the stable review cycle for the 6.12.113 release.
> There are 497 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.113-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.


Tested 03c552c46ef0 ("Linux 6.12.113-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
