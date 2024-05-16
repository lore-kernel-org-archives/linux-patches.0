Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76D5145B3D
	for <patches@lists.linux.dev>; Thu, 16 May 2024 12:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715864167; cv=none; b=NajncSzDUgberqX7Uk1ZPg2uIBje+1oKYOhFYqFP/9MS+x/bPmgZSOHCaSZL3VRAfhAClgapxYUYLhka6de4u5Ywi1aFq28NZFIgGFwzC6lyPprMotzIjXu7sDcZ7KBRVdEZyRXTG00kEfxavhk8pqT7uDYlOmteA1RAk70/o+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715864167; c=relaxed/simple;
	bh=kj/YzGnjcUNCYwHQlT5y/Pxy3SVtMbkxcvch1Cof2cc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YuQhg05Yi4+eHOYDBGEsn4hGrP8s17ScTr85XY/tjZANl9JQDAnEDQJjiZp1nJBkngOmadInI06HE61Cftcsi7M0aBJtkZYtXmkRJMogURmQMUMotWIpkvZTXNKbA40Qk6MIiwqKEKyGXBrCD/AhM7MJBg8VAY7mLBBTzhKhzx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 09B0E1C0081; Thu, 16 May 2024 14:56:04 +0200 (CEST)
Date: Thu, 16 May 2024 14:56:03 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	richard.weiyang@gmail.com, masahiroy@kernel.org, ojeda@kernel.org
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 000/244] 6.1.91-rc3 review
Message-ID: <ZkYCYxoxqrwlVSI5@duo.ucw.cz>
References: <20240516091232.619851361@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="87sHDbxo2I/u6+uI"
Content-Disposition: inline
In-Reply-To: <20240516091232.619851361@linuxfoundation.org>


--87sHDbxo2I/u6+uI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> This is the start of the stable review cycle for the 6.1.91 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

> Wei Yang <richard.weiyang@gmail.com>
>     memblock tests: fix undefined reference to `early_pfn_to_nid'

We don't have commit 6a9531c3a880 ("memblock: fix crash when reserved
memory is not added to memory") in 6.1-stable, so we don't need this.

> Wei Yang <richard.weiyang@gmail.com>
>     memblock tests: fix undefined reference to `BIT'

We don't have commit commit 772dd0342727 ("mm: enumerate all gfp
flags") in 6.1-stable, so we don't need this.

> Wei Yang <richard.weiyang@gmail.com>
>     memblock tests: fix undefined reference to `panic'

We don't have commit commit e96c6b8f212a ("memblock: report failures
when memblock_can_resize is not set") in 6.1-stable, so we don't need
this.

> Masahiro Yamada <masahiroy@kernel.org>
>     kbuild: specify output names separately for each emission type from r=
ustc
> Masahiro Yamada <masahiroy@kernel.org>
>     kbuild: refactor host*_flags

These are marked as Stable-dep-of: ded103c7eb23 ("kbuild: rust: force
`alloc` extern to allow "empty" Rust files"), but we don't have
ded103c7eb23 in 6.1-stable, so we should not need these.

> Miguel Ojeda <ojeda@kernel.org>
>     kbuild: rust: avoid creating temporary files

And since this is just a fix on "kbuild: specify output names", we can
drop this, too.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--87sHDbxo2I/u6+uI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZkYCYwAKCRAw5/Bqldv6
8nKKAJ9Kaa9WpGFmUXebdHdPuYwDml6gHgCgppOIs+y322ZNmeQD7bC7YfeRbYw=
=V3Az
-----END PGP SIGNATURE-----

--87sHDbxo2I/u6+uI--
