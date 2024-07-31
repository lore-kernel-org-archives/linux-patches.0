Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0E11AE856;
	Wed, 31 Jul 2024 12:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722428328; cv=none; b=D6d8LmUIMDZ4yW/7vWYx/npRaSzkglewsbLUjX2GTbXFmeJyhnCjnwuC1g2xjr/hXN6zmkSsFM5XuFTwz+u0pIvSS31qAhsyvimwQ3RtOLRPLDkJckDtD4WQmkbo/O1xcFazmVxftuCPUxYnoSy6M9oTQdBFC5MacT1r94HL6y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722428328; c=relaxed/simple;
	bh=YjJUjpmByhq3hloKZqTgd2yI6C+i5CiuqxYIdbJitRg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UsgkagoLFwpmHoMPWeHvJkkoZBWxvjATgOs+DN89rlX6zCdBon5CbmH05/lStHc8u8sZ+U5L/hk6mTTXB1xIB8DuftgUtYi7GXYoRdKuLahJWcQPx902wb4vcRzQYKJubETqOtFv2kJEKghG7SHxCmE1/MGzoBJV++tL6U1FgBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XCbIlBhS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XCbIlBhS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B58CC116B1;
	Wed, 31 Jul 2024 12:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722428327;
	bh=YjJUjpmByhq3hloKZqTgd2yI6C+i5CiuqxYIdbJitRg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XCbIlBhS6iR407nRCqojl8pmmIzdk2OlvPNigTQ/iqkJjZI+uyMoi+qPu17WV50HH
	 8+iHYTZF6Rh0vnaelxyFivSm9fUN1npKb6LOrYRqaoLwRwWwhGK3qGRxRlODFGnakI
	 ahDxG3kLNF0hx6yam8ElKkKpmkPQL0W3GQgXqZVude/Mxwxtz06E2iRG/rklCsi0pC
	 hoqW/uWYCl85Zm1FRGgM0IAAMZa1wIyVMVBS84qBXpC1YkPJ3EubV8tuDqT9nkxyXV
	 4PiqHmmEB0uv5vtzHrT10lrioXSx3ptkvpOpyk0GpsmtXizRCXoHU8teYSa/2HY/qh
	 CFYERLbWp67Aw==
Date: Wed, 31 Jul 2024 13:18:41 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.10 000/809] 6.10.3-rc3 review
Message-ID: <0fafafbd-b178-47fb-87d9-c1385ced1ac1@sirena.org.uk>
References: <20240731095022.970699670@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="03gNGp1Wf7Gt3h8B"
Content-Disposition: inline
In-Reply-To: <20240731095022.970699670@linuxfoundation.org>
X-Cookie: You are number 6!  Who is number one?


--03gNGp1Wf7Gt3h8B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 31, 2024 at 12:03:16PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.3 release.
> There are 809 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--03gNGp1Wf7Gt3h8B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaqK6AACgkQJNaLcl1U
h9D24Af/SzuZRiSRI67xOVc+w0+t321qmiv5Q6FI7iEpdrVyzTlmjzAo6rsPh0lE
KTC1ESjkC205jcmFTNXrrN4GhT64eLBUbbRlaf/pX7iEOf2ZLpwsixjtt3uMxXgC
SkCe7+HQIT7LQSZ7oOWWpLID/+J4xmCfZ3lpdzCfUnf/9z5S98Jx4F/th7IkvavP
7eZQEcUB8ZZEiwBWSe/bcU4L53vEswagfwmRB9QjmVGQnxh1KQ3etLxIH6xiEYHT
bkUEfSlomdJ0CIajLo/E7/HdRjI7NE+w3Bgo+P+5QJ1h9PSyoa7smR1KQgJtzP2b
zE9tKfD387850Mmnnw8XkXxsXK9jhQ==
=dU8X
-----END PGP SIGNATURE-----

--03gNGp1Wf7Gt3h8B--
