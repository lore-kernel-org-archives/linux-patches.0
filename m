Received: from mail11.truemail.it (mail11.truemail.it [217.194.8.81])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C85037B400
	for <patches@lists.linux.dev>; Mon, 14 Sep 2026 05:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.194.8.81
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789362529; cv=none; b=H+HPC0hYN9gtxDCVAwm2zoqCzC5x5xWojsrI2fUKgco5VJrpyuN4lVzRaLBaDM9ksEtkRivlqMl4nseJyPz0o0vZ7GzQRgplDgK//uEpE5QRnKrH71ovyZhnvaew3D0rKhLvd4VHg1hduoizEIJ70RjP0Sv/jKzNpSCGdfgLdbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789362529; c=relaxed/simple;
	bh=JzJBpGl81aXSebDE02l7kCnjSuuK6GZrBrbYbHQe+x8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bOGhg/rW87u/UvIkB80/d4/9Gj69r9E7Sea/VFb6HvQIMz8aduGYsG50Awgvn4DaVGWidF1KuGl5Hmfz5MZcWnDixjGNk3ewxbXGUMews3UCClf3DgmwtNYJ+MI+KUVXsqL8gR+AZh5Pqzot2TAyBdte5wjs7y8zukfgLyN0q6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it; spf=pass smtp.mailfrom=dolcini.it; dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b=BN73q+Yl; arc=none smtp.client-ip=217.194.8.81
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dolcini.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dolcini.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dolcini.it header.i=@dolcini.it header.b="BN73q+Yl"
Received: from francesco-nb (248.201.173.83.static.wline.lns.sme.cust.swisscom.ch [83.173.201.248])
	by mail11.truemail.it (Postfix) with ESMTPA id 0848824461;
	Mon, 14 Sep 2026 07:08:40 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dolcini.it;
	s=default; t=1789362520;
	bh=riKm+4fvd5kRjGwq8180YtfFX4MGZR2V2vH3sDauuMc=; h=From:To:Subject;
	b=BN73q+Yl/JgDCAprZ5MxGylRC0NkpE0V4jF+pnMxdiY4vXBzeun+Lif8qQIJoEFnD
	 KFsrIdMJ9F88t8zHxtnHNh/iB6GuIIH+dFxZFJC4dsVJF+GPkvlw5NLSpC7KzaLTLj
	 BGFDcL3rLqSl3VLLI41XTsAH59LXWXDfH/Pnu/wdvubWA5hXU2PwIZXc5Ip8S1/ZME
	 5ycql/GHpVgD6NQuqGF4KOiDl37jc6I22DqKCPjJ82a83dGFvWhus8oXxhWt+N6sU9
	 GZR/VylnFR8iucJVN/X2g1bWLCPAhSeEmUgnTObABYzaxkm/dLiE39gecUCr1rLxyP
	 HwyXE0LmuXR2g==
Date: Mon, 14 Sep 2026 07:08:35 +0200
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
Subject: Re: [PATCH 6.6 0000/1424] 6.6.157-rc1 review
Message-ID: <20260914050835.GA17380@francesco-nb>
References: <20260912065607.279695368@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>

On Sat, Sep 12, 2026 at 08:40:32AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.157 release.
> There are 1424 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com>
