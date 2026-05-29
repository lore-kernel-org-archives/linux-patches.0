Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4C5E33291F;
	Fri, 29 May 2026 21:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780091443; cv=none; b=r7Lar3A7LulrHuiVTPnhNsfGXYeBzDeqCiNjurITcXwGCqK4ppwMS+KX4QKG1Yf0flAQ2TGHxiIwa04CI35i9N94YDMQO8fvs3VJBd8VOVqcpBgPGgIZMmLScz+EnmmA3acBkeS9xpxcoIgzl/QgtyCrV3ZpUyaQKDlJguBXzJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780091443; c=relaxed/simple;
	bh=Enwk5nWz8LXoEsyh1ezDKKOh834oywpjiYXD+SwaE/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Oq9M69tlovQRcE6iRHfyhincfuStX+nn3M5Tq1JSio+Anv1x0XqEYLLgR3KHQjac68glgF63O3oYwQTDxsWhzu83WCPXwK35GI61xQS2+zR9C94oZUWqIDaWkNbr+fdfqHLpaL8oI6zGYt98HrP7jtTjYqwHZ9RhM9m9qNte6F0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaTuIUPk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaTuIUPk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E6531F00893;
	Fri, 29 May 2026 21:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780091442;
	bh=0ioN6XjK1O62niVGcXVWf+JcluZwrHeHbgMsIsdNzvg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gaTuIUPk0bq85Jaf09lAoVN3J3HXMavJ3jPKIDsFyAPK6liTeJB1Yc0/ogz/PFis9
	 +29yMvrU6mfKBSyT/6IZPseXw8mlp5Mob7pXUUD36n+zIQ0cTdnAzrWzZ/ddBjWgEn
	 7uiwUKYLiAdUKQ5+tWalBgxFXwHZ9cllnz/7UKJkKy0tj10Q2uFhCx8hHhd9vVWb4T
	 YIIGW1/ogcGGTw+ISwU8PmODQKw4y25nBO4YN1dH3luNT8jwh94nsS40GFore9thDT
	 AcyinuPPZjVlTP7RtG5hFUiKeklwPUtCwSVB4kHpW2w2N1OnStHGzhUAJGlQXxY0iH
	 Q5V0dCiklP4Zw==
Date: Fri, 29 May 2026 22:50:36 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.6 000/186] 6.6.142-rc1 review
Message-ID: <2d75f594-fe97-487e-aead-bb1c9a1bddb5@sirena.org.uk>
References: <20260528194928.941004471@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="JbDHAJ0PU+OGwMly"
Content-Disposition: inline
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
X-Cookie: Equal bytes for women.


--JbDHAJ0PU+OGwMly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, May 28, 2026 at 09:48:00PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.142 release.
> There are 186 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--JbDHAJ0PU+OGwMly
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmoaCisACgkQJNaLcl1U
h9Chowf/Yy/H1jKP3ZLrtuMrxiEbwNotmgUxTUXpLz/2QBQSXMZnhcb7JD9i8DwS
kmNcUSAx79Ah79xZ4oHdCRCPq3K9zmyyTzNtpWiD7aMRbGsmJufn0O2vCAtiQR1i
su12Rec1q/Nx6yBD/QzsXKngw7umhMvAinZMVzNpKRsaIjXiDrSCTZwrj/XwPc7z
AxGQIyevpcgoGqs8Xrt6/kaMPUUlqKs122475Ef5nLPciTydBM7W0LX3MVjxwsJK
UqVAo2Yjq7DLv1/Vz6ub2XPTKxvDV2H0axM7jv7u77ITxz2t+2T8XoJTGAc+XOWO
5iHgLrFf7aykyutwVy/+l/Wg85ceHQ==
=Zpwv
-----END PGP SIGNATURE-----

--JbDHAJ0PU+OGwMly--
