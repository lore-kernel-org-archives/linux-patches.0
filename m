Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E78291C00;
	Tue, 24 Jun 2025 11:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750766334; cv=none; b=CmLgWaVta3GhcK/jXW0+ASEJ+lPK5PM0OfofOdl6jQIEIZWUjIkcdCQD31RqQikiFbIgzaKamkXxZV8qXlNjl3OpjJ7pn4LZZnZ2thg4UiQ1gRO76TUIsI9yjWiNNGpU/UOBJcXSAaMoUztdQbK8k4evanisMq9j0XdMzkV2DY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750766334; c=relaxed/simple;
	bh=KuM27WIXPFdB+gaZFGSSJ2Cq0PYVadWDZBYeDHRGPek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HJt9htYCzAP9X9EZ4kbZT1aBYdxPpU8DjuivQ0ToRA3n5NneeOyAyCUkYltoe94pK3aQ3TZFMrAduBKI7a9dRtjgWA2SlO0dmiG78epmWl7ZE+yofBRNceESHwJpYEyarw04lWwVTn7IGTo2o/1j65IxW4ztXOVxg+gLOdJoz48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Npa2J3Hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Npa2J3Hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C73C4CEF0;
	Tue, 24 Jun 2025 11:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750766334;
	bh=KuM27WIXPFdB+gaZFGSSJ2Cq0PYVadWDZBYeDHRGPek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Npa2J3Hr4OzoXxslNGaky3oc60hcH81P/01oi5M4FZIdZlkUim7X5XTfQKNub7sc4
	 +5isJIGSu2+ms23YeVn3mwmjaUeZ0zS9W5QoGu5Xu8UgwokyQHRYOIuZhX818NLGU7
	 ieYzm6yAuRywBGsawmBt20zKQEWwcXip0x3sCFqhL55v2uw+KW63VK7cOPhSJg46+1
	 NJDvzlYrjY9aCnQIZcDUItoTo7vJE5BkhCknm3bmTQu5OTETT/ogAKhZkhS6dcVNTp
	 mCg9VtA6Ikcxb8L8N9/GgZ/wWs1Vfo05a54JvMwJMrQYZ8uLuN9EpCDqLmI+vA95bA
	 CmnV3mqNE5o8g==
Date: Tue, 24 Jun 2025 12:58:48 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.1 000/508] 6.1.142-rc1 review
Message-ID: <97248277-f25c-44b8-b727-2e5e59780036@sirena.org.uk>
References: <20250623130645.255320792@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="w4p3Ncpvy/tbxYbF"
Content-Disposition: inline
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
X-Cookie: Do, or do not


--w4p3Ncpvy/tbxYbF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 23, 2025 at 03:00:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.142 release.
> There are 508 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--w4p3Ncpvy/tbxYbF
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhakvcACgkQJNaLcl1U
h9ACsQf+Lj/OSfidt0AV/1WbPyoOln4cznS/Y3+gS/PPJmRNtXjqdkYr0Yd+pN2H
clSC1LRDU45t3Q5OmPMhsXaNHxsjNmxpnFiiWwbn3WNJd6WbmBiSdAebFqfFKZoY
/mMNRi/6jpqNlyKXmiDYl7VIbvWg108+uPEp5Zl/z7VID5ia3yQvOIKxComDuFJL
O44I6ST4e7OraCgqlEKPHwiPpN+VRCqRA42V7rPsHIxU+oJiLzM+VZVgCH7aK5xu
ldjMZlvS53igja8yec8Sjmj5bprYVE1lhONSaF0FCmi9ASLxxl4bTAAw2BLQXxxr
ggjDLz8OIoJJuUuAViApVhyopBw88Q==
=Hy2P
-----END PGP SIGNATURE-----

--w4p3Ncpvy/tbxYbF--
