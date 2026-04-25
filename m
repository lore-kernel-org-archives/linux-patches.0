Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E14331E82F
	for <patches@lists.linux.dev>; Sat, 25 Apr 2026 21:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777152733; cv=none; b=AQRF364KfWZG1wcXZ+TGEDXShjhVABHGcW9pkN12mQgjRNiKg7waj1s5iJV5+wsQ0rY0gf1mBLNFYIje4TsXRwBmAwnm6R7e2SzVkZfJNb6jK90iiguUndAMstmzMM7FgMO2IAjZ9uNdLhtr8AAlqSz9HEr/4EwTmA4FdtSVeME=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777152733; c=relaxed/simple;
	bh=DGTvntoMCEnvmXWnw2Xpvu+Wlpgk0G50PQ8NV5hleC8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DSm+ynCn2PXqNKcHfBxTrcOhGsAj/qOp5V5zCC+75qW3R2il08y2cb76lRCYlv52Zd2iFX8txZ7NN6rN0mpdid9mG6SWwQN62oUOKYvZmEaZb8xG5KooE86OmznB4Sk7ghGbDHZ7FYOFvgDVurxnWIfr01ZXg7E4/FbaeDB6yFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=jPM8/9ot; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="jPM8/9ot"
Received: from francesco-nb (93-49-2-63.ip317.fastwebnet.it [93.49.2.63])
	by mail11.truemail.it (Postfix) with ESMTPA id EE1401FCD7;
	Sat, 25 Apr 2026 23:32:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1777152723;
	bh=/ZfSjEpfHUG0jAOH4TeF8PcRsrVLKWaAfz18PUUvlX4=; h=From:To:Subject;
	b=jPM8/9ot0+Wu0vhMJnokAqLPl4Bkoa7cLKJa2MvNPUgbUACY2F8q+2V55h+DtND5h
	 CDgGIGqCbG5FT4bhiqibk/LqMsfw6T6tKCaX0BjKlzmNY1AhbLK1CLGNwh19GwOMyW
	 pztiSKrI5eS5lfJEwV1rAMK3dXqPkq4J+MvkBDkIlzq3DByzjZpo+B6u6DCf2KW2YM
	 ywCvt9EpmHeO4TQoyL6VuVrY2S0uxj0Ds28r4Bm24mgNo5UkJAtmF7yQrHwiJ1cOqG
	 tu3KDh4BHHHFiwgXs7eH97dezjVCxwdJ7BuqNSzqILwC6n3dtOlYGEqg3+HWr8CsXf
	 gkBIbzcLz9EHw==
Date: Sat, 25 Apr 2026 23:32:01 +0200
From: Francesco Dolcini <francesco@dolcini.it>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 6.12 00/35] 6.12.84-rc1 review
Message-ID: <20260425213201.GB17563@francesco-nb>
References: <20260424132411.427029259@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>

On Fri, Apr 24, 2026 at 03:31:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.84 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>

