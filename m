Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 052541E528;
	Fri,  5 Jul 2024 16:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720196557; cv=none; b=NY/XhOSf6eGOAV23Lt75vEvXAC7/6YJ6eQT+5HAOStUqLi6AUoEtCJQK+lqT6a3vU1tyIBPRrj6jIQWce8jL4F24gHUc+0+dlvl/PJvqOexSHYp+y5jjfCtn32zAynWsss7xgC3Fm0bZ9jgk/Unrx+BRCtMgnVAs7kZPuA1dw4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720196557; c=relaxed/simple;
	bh=FTarWS7gHrThN7zGbhtx5PbymvpLZ/in3U3tm3pPHUA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oZylHElIi0k2yRbba1Wvmc3lp/UCzAJ9NW/xki3TMGCEacSwch2vZxp+40iBAStLnwtj8/mt2Y59ZoZEA/f+l7rSmsEK8m7K1XHxMKX4b5FO7+vGLAtZSNgd3p1J0o/T2nk7z0Meb1fCEGjxMKiYqGKFUQxkiVol2iVBenO9G5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ssahWiUQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ssahWiUQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59FD9C116B1;
	Fri,  5 Jul 2024 16:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720196556;
	bh=FTarWS7gHrThN7zGbhtx5PbymvpLZ/in3U3tm3pPHUA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ssahWiUQYaY1xBpUAYFwJqUAjdrsk+Qkrt58Pmd32qlBKFBMKvpEtrKujhpvA39+k
	 31NlcKc5FDox6PIvgi0LcYaHeNynoT4CbTgnjvKOm5OZDHlXFmjXQsAA79VOJ5TRtX
	 bOykmyA1G1YrHkcD2qtsGZWp7EPXm+FwSUK8nI+5r2MCzBl63fIiPUPNBsVgsDKLyd
	 AaYEQ1kawa4/k8QQ9lXCsxlcdjfrzVQmiQFFZc/SQ38hnVeFImpC4w6S1TNecKxM/F
	 L+akZVOXbCX/VkCA4mHbuovONJuHsqJ0e5OPDg89/2kw+iRCwSlQ68Rysx17p4GBqr
	 b94+7DSo/zblQ==
Date: Fri, 5 Jul 2024 09:22:33 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org,
	clang-built-linux <llvm@lists.linux.dev>
Subject: Re: [PATCH 5.10 000/284] 5.10.221-rc2 review
Message-ID: <20240705162233.GA968905@thelio-3990X>
References: <20240704094505.095988824@linuxfoundation.org>
 <CA+G9fYswG=vrfp1SFmhsbM2Qno=WchrdyFzgEvhoAKVuyOS29w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYswG=vrfp1SFmhsbM2Qno=WchrdyFzgEvhoAKVuyOS29w@mail.gmail.com>

On Fri, Jul 05, 2024 at 10:46:46AM +0530, Naresh Kamboju wrote:
> NOTE:
> clang-nightly builds failed due to following errors.
>   scripts/lld-version.sh: 18: arithmetic expression: expecting EOF:
> "10000 * 19 + 100 * 0 + 0,"
>   init/Kconfig:65: syntax error
>   init/Kconfig:64: invalid statement
>    - https://storage.tuxsuite.com/public/linaro/lkft/builds/2imFeC8AXBH72AyuJQzpKgizG4t/

This is known/being worked on:

https://lore.kernel.org/20240705160007.GA875035@thelio-3990X/

Cheers,
Nathan
