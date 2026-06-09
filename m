Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D790221D96
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 01:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780968840; cv=none; b=tqgs8fYmrwKDtcLTFG1qCjxqBr2tOCVbkerrP6HJ6JysQgF809puFAXmJTAMpTjiTw687v1KQTCS5xREaNYwBp3MfbXdsRwtgaC4J/IJAepK14LDyf76TJ+3dwTkuQyK+1+0PGkRKX6hb59ETRbBTXdCz7f6Tdn3nYnxyFxEzpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780968840; c=relaxed/simple;
	bh=gh1qUAwiu0ZFqddEHycL69A5f8M26fJSNGzzEnjuEy0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pzSL5DNTd9QbtrmZrtSNzfTdz6QTsATic+O9l5DIMw+bgRnZkZPGoigax6jGRnUQYezhrD3Q6ORMcPwKorxr1NpEwBEUsv2mnj/YorbKC9ZQ9F30cdUC+P6Om0tGZmqvsiFenTqm0jN4szbI2O3WaXg2PMdz0Ypc2Bi6JPuRMF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=yZmaoRxC; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="yZmaoRxC"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id BB22C14C2D6;
	Tue,  9 Jun 2026 03:25:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1780968332;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FIcfNe1lUu2aDulJ8VNg2DmSoGbEFmaLVNUTbfxoHYE=;
	b=yZmaoRxCvvNlUUANs4aJIfskMcB61Wko7FT0BUdTzWTHr89tktpA8bM9hf7LxTBcR7NTOX
	apsMzpFBTz05/+l0sinNAs/bjbqI/jrGREYk6tqmeeBIMl/AENZ+gqrlu6LR+exl7QHJn+
	vWzZmA+lytdBkKizGHPQmMV9HjRY6Gc3vPoDrK6pEsjiEsLbssHWTH3FezcJwspgDjRX3c
	cU0gTblgbBuEM/usRKmet45DEwmvQpo8V9hgL/tuu800kx5fk13OhmsD+7KVaU98O/hexA
	CGYnmyACNWymVWpyWxYcGWwnU4DXbDYT6c6JJN5UFDdk9R5qzUtfdtaDM7Dfhw==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id c9531382;
	Tue, 9 Jun 2026 01:25:25 +0000 (UTC)
Date: Tue, 9 Jun 2026 10:25:09 +0900
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
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
Message-ID: <aidrddA2MWY6VNTC@codewreck.org>
References: <20260607095727.647295505@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>

Greg Kroah-Hartman wrote on Sun, Jun 07, 2026 at 11:56:37AM +0200:
> This is the start of the stable review cycle for the 6.12.93 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Jun 2026 09:56:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.93-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested e22d99f0e6cb ("Linux 6.12.93-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>

-- 
Dominique Martinet
