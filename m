Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BD4430FC37;
	Tue, 23 Sep 2025 13:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758633136; cv=none; b=K3osxnd4KoB3SZv5oC0rIFDq+Y55bGSqQzAtQQtS9rAXdLXB4jTgcyMK8vc4lcdp0Sgfo0DMLtcbYnvAWGCwly8iH5RbkgrrjEuq+Lkfq2t/GPExxGJdH8dP4Cl2EjfHR3fnxXJuoQiSaAW+z6kZbz8Itg/FrkBE0ORahfAaWYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758633136; c=relaxed/simple;
	bh=o9DNvZSUSXacN7bDm/2qYulrQJg0t8KH7lVaQJvX7G4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ucd44KYuO3AFOKR9ffudoTXySvSMLmASC8i40KvafZVy3NneYeSri4Gwa4I9AkGdyI9oLsiFpLPvEuKQEqc7qkbwZBAOUnMq+NaCLVtaOR6I41WcWnhyj6ehh6e4y3YA3ml+QN+cuunCDd1VtDpKtw7ulhy2aPI/RE/y7Z8/bEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AxvF3xEi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AxvF3xEi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542B8C4CEF5;
	Tue, 23 Sep 2025 13:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758633135;
	bh=o9DNvZSUSXacN7bDm/2qYulrQJg0t8KH7lVaQJvX7G4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AxvF3xEi7NP+WQYr3CnmXaAgucSt/DhUMAfAOtrTVIkT1HWmaynvwuVufMIF9Qy8B
	 xO/mPF0bd4tlH0ssp7kxu6J8i10+EU0zu+J1yOXulYfFk2vMoPAVhTY0d4ckpE6lfM
	 8oddEhTgHS6LaoBQoUAsd97NtRVR/GFHeIkUiOl2qrZzhC2AXTJknCdSrO8QQua6u2
	 vfvygSgN20Kobm5p7dcwjwdSKYzKZnNk5gXliSl5tVIeGsPpvNVhNTno1H9q8Ow7xt
	 G2G3X/RS1gUev/RyRChX1k+qn95NCAAqYcotHMNko30fHwfzp9/i99ZUbe3b+kWU40
	 U3dVR39CFyCJw==
Date: Tue, 23 Sep 2025 15:12:12 +0200
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.1 00/61] 6.1.154-rc1 review
Message-ID: <aNKcrF2c-RflyEbc@finisterre.sirena.org.uk>
References: <20250922192403.524848428@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Nx2syEKLnx6gt5ms"
Content-Disposition: inline
In-Reply-To: <20250922192403.524848428@linuxfoundation.org>
X-Cookie: Filmed before a live audience.


--Nx2syEKLnx6gt5ms
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 22, 2025 at 09:28:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.154 release.
> There are 61 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--Nx2syEKLnx6gt5ms
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmjSnKsACgkQJNaLcl1U
h9D/KQf/aheu4nXGRRA4g2ZEWcKf6N2wI8u0ahDbOX4vR51R06fLRbCXdrgAbJZo
+2xB8SEdFShRYrvTIuHMUCwy8fqZB+INbY7jVOcvfHt0Ta7fhqlUXQTFg6kNUxEG
5ljhvFFipFXJXO6D8MGgFrS5Km9yy/KwzWeeUCG/JmXR1oYq3MsIzjEP5wq55iQM
xphgYwPKAKRewaofpwiT4+VWiNEdM06h4Knax1RZKIpGOs47OBSUNwp5rbHAYI1H
6i/9FPwWdLLX0PdE90IC/VTDwhadMTiRrt2jX0jE3ARBHs4rdSKad7drNtR8BbEE
ANBrCpuTy+qBF+OWSGtlHH/lghxCLw==
=qcYh
-----END PGP SIGNATURE-----

--Nx2syEKLnx6gt5ms--
