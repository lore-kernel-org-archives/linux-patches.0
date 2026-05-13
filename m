Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 631373446AF;
	Wed, 13 May 2026 15:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778684844; cv=none; b=WGreV14Ymzxfq6UlJ1+p5ssXEY0vmPsZ+h7RD2bqNfmWgMGVTnzXRaiSQ5BrAIYtsxYbP8OKYIeNN/2B9fWDVGWu/PToIVjt6x+LOQQ6TfMNSCp/hZrHHgnExwF4sy8XWNYcNJT8Ti7zsDg8eROScKFZNDttMyjan/1DkIUgRyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778684844; c=relaxed/simple;
	bh=gl+CEg/yrehATBlUWyOI0JKsU69HIcJgzFq4mPuIPOM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ogchW0J1Y6KnEVpEcroC8/WUw2n3Ls8Ad9QphNxDELLvmDkIC4E6WbYrsBqx5bE45vY0OCMue+z47xawOKY5PuG6Ddrp0h7241kNOfL2U9laA+OZZq6fZrd9KI409+PwvAJ9Z6dwLXovFiLL7GbZO3rhdg0T8+hunDJkDgkVwD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bP80ApjU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bP80ApjU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA6F8C19425;
	Wed, 13 May 2026 15:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778684844;
	bh=gl+CEg/yrehATBlUWyOI0JKsU69HIcJgzFq4mPuIPOM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bP80ApjU3uu0AWwYGlg2Y9K0SZsPXUQQBJhOB8B0ItYhNoBkrIt5t28y20I3/hvzB
	 mdcE7eMnQw9ESP8TKpP0LUOTuZFxJbbvP0dg8mTIUE71IH/nu+5+1IIrRI8STbxWE3
	 JDS94y79PHTXGSKqof/pFj9dHJEtJYWNwjcDdvU0uV1wR5lWxvN6VCvil39Dn6ONRp
	 VY4q8sYt9atLI6IVUuIUu1VovEBnjhlo5qgz/Oo6bBXIjjjJSHaV9UOMQbo4tEMziE
	 mZt0JFYCjnhaT/VSHhdXpBe1sgsJ/+Q5T8nIglbgshU9hNZWCpbNq1j/RBbLUbj4IJ
	 GPQfBjtphGmUQ==
Received: by finisterre.sirena.org.uk (Postfix, from userid 1000)
	id 8100F1AC58CB; Wed, 13 May 2026 16:07:21 +0100 (BST)
Date: Thu, 14 May 2026 00:07:21 +0900
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.12 000/206] 6.12.88-rc1 review
Message-ID: <agSTqYwkGQgoOapu@sirena.co.uk>
References: <20260512173932.810559588@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="384gAKQyt3KAniaW"
Content-Disposition: inline
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
X-Cookie: Truckers welcome.


--384gAKQyt3KAniaW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 12, 2026 at 07:37:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.88 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kerenl.org>

--384gAKQyt3KAniaW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoEk6gACgkQJNaLcl1U
h9DViAf9G+O2MfQ836fOqD2n37mDe+XytQ/aoINf8dAkzvQMxo/L0RspVo1Tzdqz
ItoQN8vK74lb/AIiys2c69tuz4u9tnaASvz++3Fo02JQ5AiUi7rzLYVlYqIylxyM
cm2WH9YMhpocW/p48omy3LGghIqiEW0MMP4H/UDlLv0P5Xz3c9mU3yD1idaXxN53
5BKkn/uzyHNmmkblSe2K6ndEdUekVUI8Jt5Fv3jJtXvG/XsigvP+yZC1NdxswjEn
WIVLwIDFTJqcmYrPNlj6ls4O9c+xPAiom+iMDxqerZKX1herhfqjrt73gob6zh+0
mZi76RWQ5tCcLLf78hTkpdG4Vmo9Wg==
=vjLb
-----END PGP SIGNATURE-----

--384gAKQyt3KAniaW--
