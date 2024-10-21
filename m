Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 659F71FEFDD;
	Mon, 21 Oct 2024 23:05:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729551934; cv=none; b=AbmPnA65LtKGFLusWognxluPIDMn1+oW9Rxzd5CMD04QEvNg9yJFfBop0E6/wqelMymRVtB0QW+vxvKf34W65+cnqomjjbQdYIu6Hme0QPCusf7mv60Z4Vt7LY8x+CSfA+CBvIEPKikvreUco+5OpbZt5IGU8sOoIAkJC3QD/kE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729551934; c=relaxed/simple;
	bh=GgGk3/Y7H2IU2xsVU7CzwSTqSvZtBptn3on5KhFGVAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Kzjv+/2yC/Q/Hcrd2KARmM2CfhPJoRTueV1rb8AwXUtKiKBysPQfKN+vPxoOfCVRjWt/tvQ31CsexHLjGNpQfcSHO+7kidYe+5ulI0ID6KfUk36SWiMBrFQeGy+fVXrWhSj164QePK53WkisjwZsWQ7om/1J23awb+Hmp7B9Zys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WgtTLqpf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WgtTLqpf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DDFC4CEC3;
	Mon, 21 Oct 2024 23:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729551934;
	bh=GgGk3/Y7H2IU2xsVU7CzwSTqSvZtBptn3on5KhFGVAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WgtTLqpfDjmawLfzTdlAs79dkX5SV43b2VbiIRHCZiYff8YdajrdaAJrZseEc0VnJ
	 XgDtQvjgNes3UWICWV+r+Z1VxatfV+HdSjUCPW7F8Zr8+byKSg4wMnwpWHadGhaZT2
	 aiM/+N70ALKC1ESZW5SfcdX10GpMAUCOHhf2baZkfy+GlY+UTuR0L7J53+RvmLqk95
	 y+eHjVTUG8fvv+zxj0g5TjY7xtCTasZ5X8Jef8xuHH+u8JZqGFMISxoOlGxtg8CqJS
	 5UJc70AF1g0Rxdjrmjl/T91ij/n4n/pjPmv8XHEg7jaY9OfizaEpPcgGzgQ+eJzGKv
	 A9MQxXMptdlqA==
Date: Tue, 22 Oct 2024 00:05:27 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/124] 6.6.58-rc1 review
Message-ID: <bfbf2def-c3dc-4435-b218-8ca8d2e969a5@sirena.org.uk>
References: <20241021102256.706334758@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bmU92ulhcJv30c65"
Content-Disposition: inline
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
X-Cookie: Most people prefer certainty to truth.


--bmU92ulhcJv30c65
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Oct 21, 2024 at 12:23:24PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.58 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--bmU92ulhcJv30c65
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmcW3jYACgkQJNaLcl1U
h9CY9Qf/c6HO74lLhfRLnxl37KSTjprUCkTkUN6jS1cFZ1hS+xs4XgYDthFKINMz
RjvPesLTQ4AdszdwkHHPAQ5qXipvE4ZqpcZpsCntZ4QYPH5/qwaIGz06SQZpAceN
F6EzZzDw3tWhFRqntKlQOFv+ASNPzetF35D5MOwFcXRCh+dgz+sI27lxvYbQxE1k
wbvY3D9a6f5ReGXEWc+adBOH8NyMqKeyKfBjM+6GoAdBfYPdcIn1dNgqKZaXRkeU
4Kqn5DrPTCdQRfSoSOjJYSAOswc1Gca9bKmCULyZyjvvPTPxi31lKr9eJNgGFWov
cJqKzjcAMv8YSVa7P2SmtCBsQKRoMw==
=DtN/
-----END PGP SIGNATURE-----

--bmU92ulhcJv30c65--
