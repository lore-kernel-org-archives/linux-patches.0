Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC539396B7C;
	Wed, 25 Feb 2026 11:43:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772019798; cv=none; b=QEoPJUesS8dqT4cfkqMPLcCyer3vi1iIStL2j4LzcRzbZef5zORIaln7aUS3JbPcbkXaRL3WyjFcAo1LqmDFsExbqVqGTDQsXv50hfbNEaMqCP9g3cbQtyp6RH6kephetM6WksJRRhjoovABI/qK8yLTUeTEYI9D0rECO0FU278=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772019798; c=relaxed/simple;
	bh=zz8EydAPl3MV3Fr68dgL9OzVrvHxLae1+94Mq6XnURg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OK8GSOf65sxYV6XG1oH+PAL881UzdCOefmjFMA+84l8hLVbiBm88I24K9JWdk1TnVLnTBMc7iEWWY0qOfkz/Anyjp8RgYXPf8/ZpFmcDDLhxjppzaRFBa4DXvR7NEX4KrN6KI0+pp2MiTU/1fHf4ia41pt8IQvHDxxBUYC87qv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=txGgfxua; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="txGgfxua"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D47C116D0;
	Wed, 25 Feb 2026 11:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772019798;
	bh=zz8EydAPl3MV3Fr68dgL9OzVrvHxLae1+94Mq6XnURg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=txGgfxua/8cF/MA4o1Oz9VbVKEhhcvMq3HTHsCTzWoD9XN7QvmavFYtCRRbfnNsdn
	 FUk1IYrSC0Ydjysmf1Pe8kk+C7W5lCaCQ+0+9PUgkXse7CvS0mEWFUv+jCaC6vgsr4
	 QFx7uRUP/kMdkyN7twncOk1YwaMmV3jpma+Y/6qYZTm5rJQPiq1CClhPRAXy4lpWnb
	 UIswNC7JLv0BCOAZr/LrJzDAfpZD3t88tBcLSJNJPGq53uz8cUyuxHCGY7mYnJ4p2c
	 HcN0VH+xoPxf7Q0fP1bFrtEpbC9Z8dpMAqMvCb/HQsCWrTqkSsRXPWL+ih1EJZIV2r
	 Grzk5LMbRb8WQ==
Date: Wed, 25 Feb 2026 11:43:11 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.18 000/641] 6.18.14-rc1 review
Message-ID: <457362d4-c400-47a2-834b-327ded7d6192@sirena.org.uk>
References: <20260225012348.915798704@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="e7VJNWWj2VJ4Z7WY"
Content-Disposition: inline
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
X-Cookie: From concentrate.


--e7VJNWWj2VJ4Z7WY
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 24, 2026 at 05:15:26PM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.14 release.
> There are 641 patches in this series, all will be posted as a response
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

--e7VJNWWj2VJ4Z7WY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmme4E8ACgkQJNaLcl1U
h9DQGAf9FeGTkDXEir9kS60ZUjm/vCivAMAYVcB2d1KOA4u/YjTu8BFXhghdkBAQ
a9GoRTAU6xYdN/Xf/HFQQxv7BEC9tpiM1ugTqLaa2091ZjNjh2Omc9Ys1KmoPHHi
YwseObb2AgdrXZmUd2FPA14NUOCsF/zFhSBPTL+dKeFRsNmOqdPfG9Q3wmfnPoSp
QIi591V9ys/SjZMrJJJC/wPXb5Ca6HdXpO0PDiqlKpPlPZls9h7duksJdpbsVKMq
BuUGoKxvPTVMyLHlbjHYEr/Xt7sdGODN8niyUODlYi6t6Ukv+GI6wFHt4j5Kt539
FtDtbKan5oMzFffkw+0FRtN9dTxwwQ==
=J4eN
-----END PGP SIGNATURE-----

--e7VJNWWj2VJ4Z7WY--
