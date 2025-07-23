Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D83F320DD52;
	Wed, 23 Jul 2025 10:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753268060; cv=none; b=q1TlXALr/+lAxlh0YFsXzhwe6cFDAPTx+h4KdTKUwALwgWcsqUzNLEQJC1BDsjmX4LoehIDfVZkl8dZQKAK6fxDotH43hYNS2U0FyXGIRf/dH2xuKEYnLV2XdYFkgXVelUT5ukdcaW15eHsUwtK7UuYnkzRBkXR2jPPZ04/vUJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753268060; c=relaxed/simple;
	bh=PTlgkzJ9wIR7RCm/x81z5fCVh3S3Xq6L8Vdtg4gcFoA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gXuh4+dlJoimz/VzjOhRAHsEQ0NKlYRo2X7F7vKYek+uQm8qAHM/Pn6uasK2HZnmQYjdOW/hgjFI5AEvRqE5KfRAlQHfCkiOI/6BWBmOYG5tG9s1eaCIoYi9CQUFIap4vmoe+BweSYK2+D2XqZg32ljXD2pt7OSJRmfs/31yMkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MX5857xH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MX5857xH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69720C4CEE7;
	Wed, 23 Jul 2025 10:54:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753268058;
	bh=PTlgkzJ9wIR7RCm/x81z5fCVh3S3Xq6L8Vdtg4gcFoA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=MX5857xH6qrfHEU0KVQKSBCIgI7VPGgzqOnuhBjJUZ8X+nIpwkt3ZME4/mklc7JPG
	 CmxZNjLTcMySug2BwmphjFZaK2lxy8ocKShEq5GTuGgJYAPUTBuhTWS68CSE0dQ/3Q
	 0TlzSnPSjU0zS/Xv52v8BmWsZUmbp47nRSPoxW/xLOFgppaxzaCLIuOtmIT4hQIjx0
	 mgXGCfd0Qq6yBZxmjrCiHCseR9YNk24MjGKWwrCrckDM7hozwFU57mvOMLq8BWfvww
	 01Gg39aUIMwc61Bt9x6vP3TEsH3ELVptOXhDVYhTOI/9oPLwhisNzOMCKlIGT9X7FM
	 vtDNRd/mXDAWQ==
Date: Wed, 23 Jul 2025 11:54:11 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.15 000/187] 6.15.8-rc1 review
Message-ID: <1cac5b23-1e32-4686-9747-fdd10c9890aa@sirena.org.uk>
References: <20250722134345.761035548@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Us7kYAGJpCJEaCBZ"
Content-Disposition: inline
In-Reply-To: <20250722134345.761035548@linuxfoundation.org>
X-Cookie: List was current at time of printing.


--Us7kYAGJpCJEaCBZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 22, 2025 at 03:42:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.8 release.
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Us7kYAGJpCJEaCBZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiAv1IACgkQJNaLcl1U
h9CUygf/TNbWGAG3byLdkq7Npc1ZbrZXuXntYmF3P2kBowsjxlQMbpFwjHpawbzh
xCoyCvTS9HrSUJLRquaKmNS+vGX+uzZWFQZFD2Dp4xJPQQ49VrYQVQ+YDaCSvOkm
1TN93XjY2BsTgHQYx4InLwx/Ah3EQPi9evZz0zQaj9aRpRikx7BT+6/OYhStEzRt
kvbVZdGaq37ZCoFh8dTjA8zJU6uMqqwQfWRt2AZPh4UKABxAjT1akXltQihmquyo
zcQti4nyaB6QnOGOkb5lbQlAlJAiX78Xipi91ihD5DddouC225WGJ7XKKAuGzK/G
4xStgx61Q3+2XWQVwg9qapPYmaqm+Q==
=wOsK
-----END PGP SIGNATURE-----

--Us7kYAGJpCJEaCBZ--
