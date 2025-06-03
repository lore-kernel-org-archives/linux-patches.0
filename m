Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB2E11C32FF;
	Tue,  3 Jun 2025 10:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748947573; cv=none; b=JHyanoRqNFgV7yK+DEX2+hpFGNkzQZftRgKFviKA0GECGRbBxRXvFOlWfPbykHUNaiSuNkRCMLH43tqBUrT0s35O8GUh6AsNIruPVg6ckzvpW4LE1JktCTG8POXZ8tTwBApt+kuNKSON31uhK+zoBgmOo1aYFIy6k350X3bpgPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748947573; c=relaxed/simple;
	bh=u7+rGQR8YnbIhg+Ut8CGfnXe/MVcQN46BQ98CcOI8fY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=saM9m2rcLzNkchLZ8/mhMKbVt0crMrM0uTWHs+YOf97B2U0q1eP42IN42EVN88Ptt8WVUQQ5ac32ZQN2GbavxtZTbALW5LoYyPc9B2IhG7lzMeAjwyjxMRJIcXwobPvcQIZUBA9asaANO2rf+wdagZxp22xy8SZtx5B4EQZJCx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ulgtjzp2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ulgtjzp2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E94E5C4CEEF;
	Tue,  3 Jun 2025 10:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748947572;
	bh=u7+rGQR8YnbIhg+Ut8CGfnXe/MVcQN46BQ98CcOI8fY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ulgtjzp2AB78bDGrXDgZ274uy3DfdBwjyd0AjuHDZyzxbEPsBjCxpRfmHavIXog+Q
	 Qp37E+MPWPok+dKPp08aa+37hMNKi6E7/yoK9KCW+KEyUsYmRGdh/uhacUAowWPIW0
	 bjnLKnGJIZt6Yz2DgCtZAo0Fanowx31vB2phdEkLjW+3jcxFGyRUWMC4jDjNC31HUQ
	 eu5gM7jduEotuBIv26BscgF71F+iwgB6LeaqNrBZLVR6mwn9t40wWIpMUU5TcDaEAT
	 TGNFMBwnrOUspBxb7f6yVgGL5wB7RW6OqoSjqHY34aq+LKqhU8R4mQ/R9R43RjuH/r
	 esGRfOsnGHtUA==
Date: Tue, 3 Jun 2025 11:46:06 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
Message-ID: <4ba58b4c-414d-480b-b02b-c1724f6761f9@sirena.org.uk>
References: <20250602134307.195171844@linuxfoundation.org>
 <6dd7aac1-4ca1-46c5-8a07-22a4851a9b34@sirena.org.uk>
 <2025060302-reflected-tarot-acfc@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oKdheFR3ZFNHnJa7"
Content-Disposition: inline
In-Reply-To: <2025060302-reflected-tarot-acfc@gregkh>
X-Cookie: Avec!


--oKdheFR3ZFNHnJa7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 03, 2025 at 12:06:34PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 03, 2025 at 10:45:34AM +0100, Mark Brown wrote:

> > This fails to boot with a NFS root on Raspberry Pi 3b+, due to
> > 558a48d4fabd70213117ec20f476adff48f72365 ("net: phy: microchip: force
> > IRQ polling mode for lan88xx") as was also a problem for other stables.

> Odd, I see it in the 5.15.y released tree, so did we get a fix for it
> with a different commit or should it just be dropped entirely from the
> 5.10.y queue?

There's a revert in the v5.15 tree as 2edc296e2107a003e383f87cdc7e29bddcb6b17e,
IIRC it went it while I was on holiday so I didn't test the release it
went into.

--oKdheFR3ZFNHnJa7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmg+0m0ACgkQJNaLcl1U
h9Dozwf+PW62Yrq5PadUHzc2/xbOeKGHAIUPf6zvLH7xXV1V7F39peA/1jlAEXnt
iwV45c255KpF5qTI/kOJKNscoERg+Rukzs0a2KXxuINbPYY0vfMGuFdPy9Dd7JFG
OMg8L/D0Tz8XDNfqOp1oAohGoMqSa58/XPwa7KW5Y8q33jZj35/BfwoaF2cDo22K
txzmADAfl4i44adRzbS41ArO3zn4bFiX5HpHfPdj6b0z24VcDoE0ckc7ayUOGRmv
cCZUjsHspC1nMvodOazhvWg9eNgbaI8fI/dMjjMLBbf51W2wZahuN/WREgTzTHXC
PIm4rEwDMbbrM4dv2i7eGRUeh8TIsA==
=a9cn
-----END PGP SIGNATURE-----

--oKdheFR3ZFNHnJa7--
