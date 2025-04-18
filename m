Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C8F2AE66;
	Fri, 18 Apr 2025 15:59:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744991941; cv=none; b=QXuscIAvmZmVx+GT+XpsRp+FM09KjI9+50vsuFYkf/2JVTtPAHYTMYnyMgtOu2PK+P+8gHmUMUTAS0fUTpVfcKZGDELD8iXC6GSJWrukC0RvVOReC6Zun7VQSrEBW0IquR4m43ngtsYccv67Ga34SOfd8t4u92RPkMr1K2sdBoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744991941; c=relaxed/simple;
	bh=cktnoaNCPJ5RzKzqfWgqapx2mLM1K1i6EwPjd+tq/uU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LIeLvAZg0RhBK3ubKlMFChryB01uW+Jza6jaRRExyj22g05j63RgqQ1r04puoRAqMim32DTXE6h7njOn/Qlq94VLbP4BQC9Ta6jIdTdOg1QBIJfWndrNNyCYswnoxBryZRf9DJzQLWJg6wKVvLccQ0e1Q2yjbpwaQCS63f+x7tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=cc7GqGnE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cc7GqGnE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC6FCC4CEE2;
	Fri, 18 Apr 2025 15:59:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744991941;
	bh=cktnoaNCPJ5RzKzqfWgqapx2mLM1K1i6EwPjd+tq/uU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cc7GqGnE2rU/uCAZ/FNpZW5pnb8C5Vo9jIGQYnQ0Z86oH14QhCM48vogCc52ztUiF
	 /VSyaGwFHzGoZksIJuefBaAX8i/NxG5ZF2Rku4O5IvlhxIP1sV8EIspBOONrChCO7n
	 6QLZb3my3paq4YY5vv5XbOLY0BdY9Z46qDYMngXoYkUsc8kL/qYvMmpHCdMP3g7AvK
	 SM6ZhHzOOwVZa0BRzEW3ODJGYDjEDA6SFRbd10n0MHAxsWS6jiCePc4MS2SqYGUIKZ
	 nbjKwvgqcLHx5mWm3SHTrccg72g6BPiFMYYFASlapfTIzF/ZGruA6Z8TOuZ+9yHzdB
	 Mw9VN27sR86/w==
Date: Fri, 18 Apr 2025 16:58:58 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/392] 6.12.24-rc2 review
Message-ID: <aAJ2wqD7SqI-EMNP@finisterre.sirena.org.uk>
References: <20250418110359.237869758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="cerCIE8KJ0YQkCGE"
Content-Disposition: inline
In-Reply-To: <20250418110359.237869758@linuxfoundation.org>
X-Cookie: Well begun is half done.


--cerCIE8KJ0YQkCGE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 18, 2025 at 01:05:08PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--cerCIE8KJ0YQkCGE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmgCdsEACgkQJNaLcl1U
h9BxfAf/RlMfKGy9u3BCO2vKKkqTx8aj8+5NM9G9ttRaXP6LILuhzSze8eU660du
GO6johznQ5ZfYaBdQ2iB3gjWiMJduI/PJapI8Y0HNxS+N9FpbSvb8HvhmFu4TLVt
dwQ3wEySUz25+Ng5DCm+ONy4QJpJ46bhowKjvYL8SVRa++12sULj0b5wMU5df/YX
2tpb8iAMzg1QWhRwvvEaZDC5gu+5cFF9pdTLNWGQ2HIgi6yD13TbVAcSeyF5amFo
PZvcQFw9Sq8h0/zlkaFKsjX1nmFjyndXPWSnkEwGFJZSuAcQRQLKtgdqfrpebkzb
ypa539Ox5TiX79lU9qKKhDgL/PC+BA==
=dTU7
-----END PGP SIGNATURE-----

--cerCIE8KJ0YQkCGE--
