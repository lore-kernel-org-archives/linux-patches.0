Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=62.210.214.84
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793267409;
	b=oYK8cm9sxKdO6wb9C3BNhndM/KUsnh3SOulvV5aj4LaYB80l0kzYSTBoo+em4af38Qrq
	 rEr72bs2SwISzj2Xk0f122STaMfYOHQUI43e/IFoIR3tsT39oihwqumQjdftzhXhkkx7m
	 89rjbcJfQz4At/9P6/8RBmgy4JDlWBVBVprk0T9up0pPIVFDAfNiWIvdMGk8Rmglft7mJ
	 LBKav/bXmRduxScR0ZruQnBJHHeuSyi6ZFfPBbnN7/Aa712xESfd7UJ0it0qAj00LXq/x
	 pcQd/Zow1ULcZ+URCCODFXFcH2Gsqr8ean3eXgufLyhGKe8khLg7O8QILnJACrL3KPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793267409;
	h=DMARC-Filter:Received:DKIM-Signature:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=/46P3SZxoGq9do4PIyS/wVKYLhd9OgTlRs8CpabIqNs=;
	b=bOWZemPFaG9zgAe5qphuEanvsgm4WQ6FG6C3dQlLWP5sl6tHJm2nbg4IkswvFXsm8Yxv
	 mTZi0t4IFTKFWVdqdmRsLgoU4WleKspTEDtVKa94WjB1c5+hjNOs7TpxHCOP1XBZi+t0R
	 TlnEmu5uauqDBze6/w1rdfTrfANLlFWpAAOEh26eHylaMbByea7UIt/7KhZaVJS08fsWp
	 nSVjEqPcBqxK8soC+lzks5J+g330VDw/mzgoJ7kLBZ7k9U8bojh9TF1ScmE+lUP7JqOf/
	 5CGeBau2CKQeykIsUf1gvWCgNTYkcjbQELYB9bs0Eo5n7f9elI2ytq8dq4vjO1cYPKg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=codewreck.org;
	spf=pass smtp.mailfrom=codewreck.org;
	dkim=pass header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b="3Ft/Vcfo";
	arc=none smtp.remote-ip=62.210.214.84
Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B971606A324
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 09:50:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3B971606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=codewreck.org header.i=@codewreck.org header.a=rsa-sha256 header.s=2 header.b=3Ft/Vcfo
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 52B5314C2D6;
	Thu, 29 Oct 2026 10:50:00 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1793267405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/46P3SZxoGq9do4PIyS/wVKYLhd9OgTlRs8CpabIqNs=;
	b=3Ft/Vcfoba67OVp8TdmH15XpOlGLj35FIRVN38cB3y8nsh04fu9w/elcGmoakeEk6zRnf0
	krt+3gSoFP4SUxExW+FhPF0XsxlfQaGkO9twtuzmHnY9OO1rBcSzBfS2jObPETiuvviGwT
	YXZXzYNc3nWRbtCqiAl6BVaaH4XyWOP5ZoPXrpCZacDiRsFBRpPbQCbY4WiDVgwdCSSKnp
	hkfjtgKEkaH686REnkmubr27HYDyEtugcWsmWEiZGXChIDpSUB+zn9rui7KX3AJlvj9ave
	kIxGaJutVNRaIFQPnTJdkfn5ypp+2rpDQqSnCprplyTXCm8stryUf4YXqNgxIg==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id e9c74814;
	Thu, 29 Oct 2026 09:49:58 +0000 (UTC)
Date: Thu, 29 Oct 2026 18:49:43 +0900
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
Subject: Re: [PATCH 5.10 000/516] 5.10.273-rc1 review
Message-ID: <auMWt-gmiUyazT5P@codewreck.org>
References: <20261028170003.522232767@linuxfoundation.org>
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
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>

Greg Kroah-Hartman wrote on Wed, Oct 28, 2026 at 05:52:32PM +0100:
> This is the start of the stable review cycle for the 5.10.273 release.
> There are 516 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.273-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.

Tested 827e3840d937 ("Linux 5.10.273-rc1") on:
- arm i.MX6ULL (Armadillo 640)
- arm64 i.MX8MP (Armadillo G4)
- arm64 i.MX8ULP (Armadillo IoT A9E)

No obvious regression in dmesg or basic tests:
Tested-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
-- 
Dominique Martinet
