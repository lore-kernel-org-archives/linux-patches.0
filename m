Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73E1121FF48;
	Wed,  9 Jul 2025 08:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752050966; cv=none; b=uI128HZOJbKWPEjUyXVbMpKZHZROtY6iYCKT+zeOUYcrmmLJpxlW/NaPxyU4JzN/mEJ8/E7NKmAjHFvTEPeL1Sqw4sEDtFsr+XvJ76b11zQ5TOuRhC0qNEWFx43hkVdctJoFIK+/Z16VPAJvQXuTZO97FNtkPV3HVofhEuXJMiI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752050966; c=relaxed/simple;
	bh=ODwf59qpxl3utS67bdE0O9tcnsD6rPyGSUg/MQJGXbo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eMj56HU6ksbE7DJMxSqbCPPLUEBjS5TmSCE9/8lHYHah+7L0HHTWhcrcS/wDHUG2Y0olfqwG6yiKLstW140IoeLswBn3rHpky+mDE/TuXWyduEjnY5ZCLQ9zQHdPnxlS/Tm+6McpzJ7bMrUAOq0qDt7NzqArXYF91tH/QhzNhY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=agDdKtAL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="agDdKtAL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6CCC2C4CEEF;
	Wed,  9 Jul 2025 08:49:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752050966;
	bh=ODwf59qpxl3utS67bdE0O9tcnsD6rPyGSUg/MQJGXbo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=agDdKtALGJxMV7GcSMiB662KzQmCAtCpV7xXdj9LXcCwF0pyixmwDSQTCsEn9J0WH
	 HVxjVQzFYgumIdzt9tC9AP/MjenSpvl1dFhKsTzKQcVrCC64R2Or9T4c70ynuHSDmN
	 TPDCmXA6GGXucXp0V2AeGXJPA3SuDc28PrLAjTxkX0UI+4TECG6GcIVmVoEQPW5BRy
	 hZi66VsOHq4KAVhmk9WQwxbS+tWstZtxQ9dl9az0luJw4jqACrnZHBftYqjCle7DzN
	 jmUL0gxQQSJsQbNIlMfk7Kwm+SjIda+9ipO/omszzhK4nuZWH+FeT8KMeGMk/h+zJy
	 j71pVisJv9u5g==
Date: Wed, 9 Jul 2025 09:49:22 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 000/130] 6.6.97-rc2 review
Message-ID: <aG4tEosdulTJT0rJ@finisterre.sirena.org.uk>
References: <20250708183253.753837521@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="3QVwW4bUiuLSVLKy"
Content-Disposition: inline
In-Reply-To: <20250708183253.753837521@linuxfoundation.org>
X-Cookie: Do not cut switchbacks.


--3QVwW4bUiuLSVLKy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 08, 2025 at 08:33:42PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.97 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--3QVwW4bUiuLSVLKy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmhuLRIACgkQJNaLcl1U
h9Bdjgf/bW9HHwh6Puwq+NQcXJtUbKAYwY55zm3Il445htetF5sCSLucRhRu/BrY
Lf+CkaXLPBrgWdgJ+K3p7mE9PxfnweBIcnEhES9pwe1sK1v3j0CYO2QVubJX5e4B
YqXTPX/qH8B4DhajM9N10VaSy3gKijDupDcNFKRinJT0hRfKTQusljrb1yiizms2
JseP6W9b00QRUFQiZTIiaKVjeori3VtcAmHzVA7H1ZMq5dUrxo3X5XNu9EtmIqdG
SDD47i07AdE59MmAnuLHLtxnhzdbry+9hi9/LL5W/t/qlcErh+tskcf51PfNv4Ke
tejL8CeztXJipMC35NqoaWCx2PK+JQ==
=Bf5o
-----END PGP SIGNATURE-----

--3QVwW4bUiuLSVLKy--
