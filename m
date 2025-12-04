Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3834233ADA1;
	Thu,  4 Dec 2025 12:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764850009; cv=none; b=a0jUnlEFFdKT59yBuH9uTguxnaDoA4Qrmea9mOuSy5dUzeFXomfhX9CI6wTOCBHdVkoXHSSgvapOiBeP184Ii2dXbTQucIgCIdA7pyYMWTMmxxuTDKedYyGZJwqXVvZqjtrji63TrowukgtOif25tj0/qKNkQdeXad2k+yRuYoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764850009; c=relaxed/simple;
	bh=uW/IM5H5N03exE7DyHMbqvGdw2ofUUhgc/dw7UaJ1no=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VQWjApWtwB6+wUq6vdLN97ULIYDMmJUgY8VSJYZ3O7lkGdYqAreVWwHb1lMiCyn7Sos1EvstO3OvHhDaIJWno3u6wwrUrgyHyOKAa88nPnVPhm6uuv/cYF1bdtbwx9coE76HfWgNvb4HkJcKAgEq1vyuXqxuffdrFaLjgAiznd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z8RGh1Db; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z8RGh1Db"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32FA4C4CEFB;
	Thu,  4 Dec 2025 12:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764850008;
	bh=uW/IM5H5N03exE7DyHMbqvGdw2ofUUhgc/dw7UaJ1no=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Z8RGh1DbKEQIP+hj2cT/ri3IDFGk51i4C8P+s8IFpj2rFrIlh8Cf4yF7FkxAnyiDG
	 KNrBs3Y8F1Tny4ZLDhVpI1PaDtUQ0anSJqR0uXbKS0z7XjoMjxAL5FhLp9vJIAJXiQ
	 lZ/MhccygoO8tWN2N84P2jDPxQRUCgsh759MSCoEkrrJ2a0x8DdGV+MN0mKVwsY3iq
	 7ZFEsZPYUUvl3oFJXXhCDRpajrCSGsG0rZEgfnI8rYcJ8/8zkqVw18E3H1lYtkyIvQ
	 rdPr8ryj0dOWmht4S+Z42Yo01s848Rc8w8zrtJX8XkWa41GvGPZOijBh+yo5/oguzq
	 GTMP7XJ/e4SzA==
Date: Thu, 4 Dec 2025 12:06:42 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com,
	Kiryl Shutsemau <kas@kernel.org>
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
Message-ID: <bae0cb4e-9498-4ceb-945c-55a00725d10e@sirena.org.uk>
References: <20251203152440.645416925@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bm5sEkE+B5k5YwQD"
Content-Disposition: inline
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
X-Cookie: volcano, n.:


--bm5sEkE+B5k5YwQD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 03, 2025 at 04:20:02PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm seeing a bunch of systems start failing with this release, they
start OOMing when previously they ran OK.  Most of them aren't exactly
overburned with memory.  These failures bisect to 61717acddadf66
(mm/memory: do not populate page table entries beyond i_size), sample
bisect from one of the systems including links to test jobs (the bisects
for other systems/test sets look very similar):

# bad: [abd89c70c9382759c14c5e7e0b383c2a19594c5c] Linux 6.1.159-rc1
# good: [f6e38ae624cf7eb96fb444a8ca2d07caa8d9c8fe] Linux 6.1.158
git bisect start 'abd89c70c9382759c14c5e7e0b383c2a19594c5c' 'f6e38ae624cf7eb96fb444a8ca2d07caa8d9c8fe'
# test job: [abd89c70c9382759c14c5e7e0b383c2a19594c5c] https://lava.sirena.org.uk/scheduler/job/2168338
# bad: [abd89c70c9382759c14c5e7e0b383c2a19594c5c] Linux 6.1.159-rc1
git bisect bad abd89c70c9382759c14c5e7e0b383c2a19594c5c
# test job: [43c650106e8558fa7cfec5a2e9c8de29233b6552] https://lava.sirena.org.uk/scheduler/job/2168373
# good: [43c650106e8558fa7cfec5a2e9c8de29233b6552] rtc: pcf2127: clear minute/second interrupt
git bisect good 43c650106e8558fa7cfec5a2e9c8de29233b6552
# test job: [b56fbe428919e8c1a548f331d20b8c4608008845] https://lava.sirena.org.uk/scheduler/job/2168393
# good: [b56fbe428919e8c1a548f331d20b8c4608008845] net/mlx5e: Preserve shared buffer capacity during headroom updates
git bisect good b56fbe428919e8c1a548f331d20b8c4608008845
# test job: [445097729a995f87ff7c80d5a161c7e1b5456628] https://lava.sirena.org.uk/scheduler/job/2169640
# bad: [445097729a995f87ff7c80d5a161c7e1b5456628] platform/x86: intel: punit_ipc: fix memory corruption
git bisect bad 445097729a995f87ff7c80d5a161c7e1b5456628
# test job: [ad3b2ce45cce79ddaff01c977d0867d079fa8349] https://lava.sirena.org.uk/scheduler/job/2169710
# good: [ad3b2ce45cce79ddaff01c977d0867d079fa8349] kernel.h: Move ARRAY_SIZE() to a separate header
git bisect good ad3b2ce45cce79ddaff01c977d0867d079fa8349
# test job: [de07228674e9cee27f679ebcf8562f7e3b2cda21] https://lava.sirena.org.uk/scheduler/job/2169731
# good: [de07228674e9cee27f679ebcf8562f7e3b2cda21] mptcp: decouple mptcp fastclose from tcp close
git bisect good de07228674e9cee27f679ebcf8562f7e3b2cda21
# test job: [dca2a95e4ed753ed33da11d7bb78157441d69bad] https://lava.sirena.org.uk/scheduler/job/2169741
# good: [dca2a95e4ed753ed33da11d7bb78157441d69bad] pmdomain: samsung: plug potential memleak during probe
git bisect good dca2a95e4ed753ed33da11d7bb78157441d69bad
# test job: [61717acddadf660fa6969027bfa0d6fd38f8e3e2] https://lava.sirena.org.uk/scheduler/job/2170912
# bad: [61717acddadf660fa6969027bfa0d6fd38f8e3e2] mm/memory: do not populate page table entries beyond i_size
git bisect bad 61717acddadf660fa6969027bfa0d6fd38f8e3e2
# test job: [0de5c14c8e753a547d158530c37efb245f7b40ec] https://lava.sirena.org.uk/scheduler/job/2171171
# good: [0de5c14c8e753a547d158530c37efb245f7b40ec] pmdomain: imx: Fix reference count leak in imx_gpc_remove
git bisect good 0de5c14c8e753a547d158530c37efb245f7b40ec
# test job: [1457e122dd70574a0ca895eea6d6c12ba91312bf] https://lava.sirena.org.uk/scheduler/job/2171268
# good: [1457e122dd70574a0ca895eea6d6c12ba91312bf] filemap: cap PTE range to be created to allowed zero fill in folio_map_range()
git bisect good 1457e122dd70574a0ca895eea6d6c12ba91312bf
# first bad commit: [61717acddadf660fa6969027bfa0d6fd38f8e3e2] mm/memory: do not populate page table entries beyond i_size

--bm5sEkE+B5k5YwQD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmkxeVEACgkQJNaLcl1U
h9C80Af+KlkQW21OjqmDWNcSV4Ad1KeZI0Ndr3qrgEfypIT3ht/aBii5nTcUT+Eb
AJqfuTS1HWVExIX2mA0S39/eMshtaXw/rUHNzzZY6HxSNnwd5VXqxJTie3E9hmeL
jTOyrae6l7lMoubyUZGPqvWL8QmMCoB68x/4JK60FbSIWU2lK62vQ6Cmnw1NhaXa
8zQbGkwIGy0hNeQ+6F4ZAmItohOgY09NsnfZRTO6T3wDin70MutgWcvBV3D39C0U
0zwXlDmGlnxzAPY7GofvLDEsBSW+o4chGZxvGAFeu3+jxb1UFF5pr83SO1sYdW8X
JNBDNvnO8/54EC4b17+pRYg7M5wTEg==
=rNuJ
-----END PGP SIGNATURE-----

--bm5sEkE+B5k5YwQD--
