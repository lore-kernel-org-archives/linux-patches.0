Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72BB3242923;
	Wed, 23 Jul 2025 11:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753268502; cv=none; b=W/FVEKc/obnkMDOjdyA3OzyyVVeaHa7f77PwTn74nuAxu8qAa0EZS44VtR9Klkeq/KDPTS8J0h1XEyX1c5BrDftaQy2xzo6HjCgdfQssQgXvGKveGsx4pUERHMpaULHlDZ+Va8FUXYUQehKkIzvSgarkpbIb/PYxXnjJdsONh84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753268502; c=relaxed/simple;
	bh=YWpfzJkjhB/lzcmJst7MFAPzwBU2YcX/yN06m387qI8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rlMyHaexfDGIMox7TELU1mUHe9VuI8+hZo3HGT16BcXnbLRK++EVJciPpb+5+wJpbH9bDm93gkvMEC3DkPkxeT4c0fbAzI3OHmeq6ouNruTOKTtbcBlKtNf7NavTtZQJYAQsu6qWdQt3UaBqkZSF5+3rvEQnRubUElh7871LlmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FY2bxxva; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FY2bxxva"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F27C4CEE7;
	Wed, 23 Jul 2025 11:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753268501;
	bh=YWpfzJkjhB/lzcmJst7MFAPzwBU2YcX/yN06m387qI8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FY2bxxvaxrL9OZu0chlOK1KaYLTlNGiKuPGcgXo7wBm7HZFDEkNnctSw4f6BaorOW
	 LNIaliwR59kSz3xSnaDyTn3OOvwAL8s5jT2BXx4KMnikG8zO5cTWaLazOMNW+f1T3t
	 MPeEP+8XwPOjJsyLyzs1vF5j5MpnY+r5P2fwVLUh4urR+dZjXVKgoKBuCdT7O/5YnA
	 0MtStOBVyacRpfwH8+UdDIPDciyc0Li3KAvWfcs9bX3ZaHUKwsxbQWPnodtZ/7HnRr
	 RCe9wp8cZP7zrY2BD7KvoLZAjXDfXWOwpyDatadcbldX+71YOjy+XqSaUVX9D7AJjy
	 aS0sXlpBQxYTw==
Date: Wed, 23 Jul 2025 12:01:35 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
Message-ID: <37152e6a-e5b1-45f6-b182-6359e28eb73d@sirena.org.uk>
References: <20250722134340.596340262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sCHXLL/elbyRZv3e"
Content-Disposition: inline
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
X-Cookie: List was current at time of printing.


--sCHXLL/elbyRZv3e
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 22, 2025 at 03:43:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.40 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--sCHXLL/elbyRZv3e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiAwQ4ACgkQJNaLcl1U
h9CIvQf9H2SYW0QMLVj02k+FVTlogRzqPHzXrKCC/Xv7PS+z6FsDSZPVFvCDkjQu
et6aJkwG705+xIEW63Me0Veebnh477b7ctIVBl7aecA9rxVgh23fLqAKx60gvvcN
YdTeW6zR5Az+/emp/hKUIfkor9zvNOPAc+VSjZa+jy2f6Df/lfLyzcnQKzfMXQtF
Zidm/TcwpoinmIjczMaKyJ/dzaIb8E+ghd7UQSN1IGVI1DINdZlKe9B95kRqYTjB
vR1dWFd8wUWJKCy8FP1rJNYvZCXDGQygn3SM47JCF91TymRasIbHDX51qzE9NtJD
UV+WOSsJUQTz482zJEmLlgDHvh5uLA==
=Rmmy
-----END PGP SIGNATURE-----

--sCHXLL/elbyRZv3e--
