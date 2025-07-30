Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67502248881;
	Wed, 30 Jul 2025 17:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753897139; cv=none; b=JWAdmKDYSv8MNAwfvxidGcvUpb6qCAKbGuLpBvnRqx+dtL04eQRQKY+usoSvG4T2saO1wLlBad0Lfzkgwo05CddxROdhol7iV3q3ub5DZJriuBwOmaElsPrxMI949e3N34fwu7qvNhw3IfaBc11NfRLa0OAd6vpmMv5U8UNS6eY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753897139; c=relaxed/simple;
	bh=eGNbwYjC2+s5jBPIzd8lTAGuISIkTayYFpUkZ/D/XL0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Pb+u5tQbcG7HmupO0qPW9M9j3PCqmYUvKJC5vhBSRrPW9tLmQG4upWmonyDBDH66hNTea+U1pYv0kQMEJc/yjtrai+i+Pf/9G0viFJYe3EwqiTsEc5JBrnkWKjQmsztGClHhWn3UPuHMfsSV726DTp+kQOtIKnpi1p765MsCJ8M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sTtODgCs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sTtODgCs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81D52C4CEF7;
	Wed, 30 Jul 2025 17:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753897138;
	bh=eGNbwYjC2+s5jBPIzd8lTAGuISIkTayYFpUkZ/D/XL0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=sTtODgCsN2V+SIyBCNvXpG+CIWE2/vOTLsxclnCVlO/uRWFc/K+Cz0b5SpNx5vxbO
	 OUCIj2Plfr6qKyEzW5HyAsNMVax30/9/E8vF5AklWwSTvYHsqKHTl2YcCVESdySJb8
	 38m4bgLnIyEG9l18N/6Ib2EvyEBsf+LXu9FOAT+u50boaomrt/4DV8JcTGjcHKEn3O
	 jyK7fDIc48IcaZcQLc4P9OFAGIxL8Zx8sK2+ZiKrWVMKt1hProOeEGr9laNqmCati7
	 ofuRP3RIVSZmkOjrLmD7SBmqjuofA8+wxYznSLESNKxW8WmcBEaOyPNItgEo3Zx7qz
	 J/pxUkHtF1gKA==
Date: Wed, 30 Jul 2025 18:38:52 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
Message-ID: <2d6d51f4-e5f4-4a6b-9836-0775f3c5a0af@sirena.org.uk>
References: <20250730093226.854413920@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="HYKWSx9VKZM/vPdz"
Content-Disposition: inline
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
X-Cookie: Linux is obsolete


--HYKWSx9VKZM/vPdz
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 30, 2025 at 11:34:53AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.101 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--HYKWSx9VKZM/vPdz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiKWKwACgkQJNaLcl1U
h9DX1wf9FQTvOOw4uqKPdJiht5hBtheNCKX+IEGEBEIDYOmU8TfHLOvFCPvKpdi+
n/Ra7dj3IVm5uK1RL+VHilB0m0ewnpUI3u7jk6HFkjQTEyFnfXy+Rs5OcJVndN+w
bHMlSFwZYF6Qn0LlJHFAw0J2X/rNBdv89KlTqq7LfyACuQh0lEBW3H/+l9q5fR6S
jb/UZJcJd0A78AFuq/2l3z96qvnnkqGh5pZSqdx2/m1nY0cw6MriQ9/Vd+j4PU0C
+Z6Z/zJBPN76niyJbEDivyw7DtICMD6V5D3sYOLNw7cnWH+5hBNxdArD1fLbeoV6
WxjyMpOG/wtihvF/DGDWCzcHOwmk8A==
=vJfJ
-----END PGP SIGNATURE-----

--HYKWSx9VKZM/vPdz--
