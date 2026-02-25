Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14E732825B;
	Wed, 25 Feb 2026 11:42:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772019778; cv=none; b=gC7nHd2rrK8b0JSgs42HxUN/FBu4rQN/GZqJdC3KJz7guRMtlywp6BY6zfbN20lo58PcZPfwPu0GvdFghfwh9JzA2CuaGZExfSc66shhu9JJa5j8Ai81XVq0D2qa89hpejbKDjZL+f3zXsOL0Bx+u/0h+jLMmVhfZVzBpqausnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772019778; c=relaxed/simple;
	bh=dr1FetCGiElnKqwOLK/nzeBzn45UqrtNZC+0wne7FS8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jDBjERJAZFQLXCo8zSFHfgCw2WknvSUjBV01zJmWwGjwR+fIpp7EL+G1Tq2fOTFRRbdfu/Ir4Y7DFbTvYtGiSfwCOILO+AEmPSn7iaazlcPchg/GwzIrDEcwJMcI8cAccDZzghxJpJSz6XxGCE+hNRtpjrTMhYV+mOuVKEGiSiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QHxiAtBr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QHxiAtBr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B328C19421;
	Wed, 25 Feb 2026 11:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772019777;
	bh=dr1FetCGiElnKqwOLK/nzeBzn45UqrtNZC+0wne7FS8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=QHxiAtBrEEqV74/oOfpilYx4PeLL6pFRWwH1rcAEyw+lhiGUr+vFkBjHRbop9QCqc
	 OA7ui9dDmnXVnNNDXRc6b2iuxe5BTyy7k2z2sAz6p21GKdrOd1qdYkiHen3ZHjIXGa
	 wDadO5+RETQyDVwUpNTDRRVsWnyACJ/yL3XiCEocoAo2klmQiI+Q4tFIes7LGyH1TH
	 mG41xiy+tx70VXuW91AgMAMq8xHC3mekDv9Pa/2qoitkKcGrhu7FMFB1NoKAio6Zer
	 AHMVs+Tr1+1FRnnCxZLGK4dWW4VQEkdKqdA0NrXuN/7CD04Fk4U/IJWUWt3vLjnv5L
	 D8JoU8bSL6g3w==
Date: Wed, 25 Feb 2026 11:42:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc1 review
Message-ID: <3a23ccea-7924-4c11-b484-0740e016ef85@sirena.org.uk>
References: <20260225012359.695468795@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="1ETqR31m015ovrZk"
Content-Disposition: inline
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
X-Cookie: From concentrate.


--1ETqR31m015ovrZk
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 24, 2026 at 05:11:49PM -0800, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Kevin Brodsky <kevin.brodsky@arm.com>
>     selftests/mm: fix faulting-in code in pagemap_ioctl test

This breaks the build of the mm selftests:

  CC       pagemap_ioctl
pagemap_ioctl.c: In function =E2=80=98sanity_tests=E2=80=99:
pagemap_ioctl.c:1169:9: error: implicit declaration of function =E2=80=98fo=
rce_read_pages=E2=80=99 [-Wimplicit-function-declaration]
 1169 |         force_read_pages(fmem, nr_pages, page_size);
      |         ^~~~~~~~~~~~~~~~

IIRC there was a patch adding that function.

--1ETqR31m015ovrZk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmme4DoACgkQJNaLcl1U
h9C2wAf/XhttC2N8zLEIyEfaHQoIIfYiSAWqzxhnTwN6ZpSajRgpCgnsESORA3Wo
W4j0edFxV+uH9n820El4c/NdKCA5ZOZtH8Hu+hcrXr1k/qXBtoPzlYkMS6Cd8/8c
mpgBNTL7g4azbV9i11seRGfNsbGoEiDxOdulqKzkgGZaWtJUe0cbeIsrDIxG7gTr
eVeSQ+k/DMWU+Z91miAug0qtl2/jnmSfIg4banksvoqRVoqOMS8msHoyybeZRkst
FBsHsL+fAV0cYcZoIuN3N8Ml05g6RuR7cHQYobDFZ655itOJa0mx90EVTXRcDxOo
PhlPQ6DEwF9PKg0+ifW2REyJokc5mg==
=h3Zv
-----END PGP SIGNATURE-----

--1ETqR31m015ovrZk--
