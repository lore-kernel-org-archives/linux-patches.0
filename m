Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795186417;
	b=Si2FwPaBhPRGx61WEhyG9FFb3VgETid3ccT5Ha7elwqxFFHyoYUMiheIPf3rWieV54zL
	 3TCCONIXLkQcSxVL7W7gEnAUsz0YXldolgaVnJFKR92jJXXpEyGrBiSLF56L+LL7he1uz
	 dC4FBM0AtVtu7Sxli0/Tb3aA4isZODgIuu3ZUkk8rcK3dCzUYe7O2RgWgAWizC9QBega5
	 4io1USr5OGQnWratouF9DjlelX2X3IcUnUWARU1+I3+6mA28XDK65D9dphly99o656TWo
	 fKNRHuBtbIGlWgoaduDuJMSyv7SRtYHtnlnqGYR1F7oHcnG0pG2JcMJcpD+0H2BeDqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795186417;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=2seDiGmqUUFXsjKJX5Ql4DU55t72ojBgfyMZ3QXuugc=;
	b=DjMo53wl8fR9Ec7UHu7GvxhSIiMWjF+MOqrorN0ksMwU+4HzJoU/3xC6zkOQ1+gT3R5B
	 1eWMydVq9dr7lMxqD3gFCCArMhrKFSLKxUwUPTpyFpUcF8Bks3GhEaq+Bv5+J6HUXjlrE
	 9esGj5pb1cnCh3/iOm/imW3IySoMTRYKmC6zbwxVT960sXx2UhPUelCfNkV7E4KcXQPJx
	 5HWzQ5nakW+5vIXNxaKCCN0KvIR/lr+xgcAJb16uiNxPxp8qI1K+kQDRIS5VIEjssjDe1
	 rxH1+Ze/zjX4KDawZlZ0xoWTuFUSPUPfH2/fQ8FvDHmNIrc+sH21UPOpoK0rOA4ix3w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=vBXv6ni3;
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77161606A336
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 14:53:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 77161606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=vBXv6ni3
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id C363D14C2D6;
	Fri, 20 Nov 2026 15:53:26 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1795186412;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=2seDiGmqUUFXsjKJX5Ql4DU55t72ojBgfyMZ3QXuugc=;
	b=vBXv6ni3bs8s8Rm9YXxSmjGL8Is0pBZCqpLHTXKusNqmcECNa3Vy5KK+dzxfdgFAEX4UMQ
	HijczZvO5kuveToDN2D9bYtvhdLtanGpYPk95osXmpfMNW5R1zA9H5+gQfWZVgP83gX/79
	FgvS3rv/56VM5mRRpw8OKUALLw2t0YSwihsKe9c8rJKQxjzUs7twXKjFOgOgaKg9a9ou3n
	ZMTNO5L7WIzeNYjsaIoNGiuz7AxLtyfzode66YaXTsCSptkkrAuSbN9tD2zgCQxxewxsxH
	TqZFMf0G4IHK+NbwVWlHLsUfoMIMh+XCVTVp/lT9/VMyXoItl16H6FOl7JyTMg==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 91e97872;
	Fri, 20 Nov 2026 14:53:25 +0000 (UTC)
Date: Fri, 20 Nov 2026 23:53:10 +0900
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
Subject: Re: [PATCH 6.12 0000/1736] 6.12.119-rc2 review
Message-ID: <awBe1p90ebot1Qh2@codewreck.org>
References: <20261120054951.366579794@linuxfoundation.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20261120054951.366579794@linuxfoundation.org>

Greg Kroah-Hartman wrote on Fri, Nov 20, 2026 at 06:57:42AM +0100:
> This is the start of the stable review cycle for the 6.12.119 release.
> There are 1736 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.119-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.

Tested fd1d7c3cc36c ("Linux 6.12.119-rc2") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
