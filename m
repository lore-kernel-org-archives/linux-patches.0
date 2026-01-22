Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 050D62517AF;
	Thu, 22 Jan 2026 18:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769105721; cv=none; b=DnqnOoyZhQY9pmY85r7uDnnGFjyZiZMlb7hECqxb1EpCw1J+ze8mYvsnXeZcRdkcHsNjj71OOeTZrPTQaks3KiGbrsbcL/h5/VBuFKpt5f8rEh1OIiqzmv+OjB6Ml7WZJRwOCPTp/H0Tyham1nuYJL/sZeHAKskY8hoJjpi0Z/c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769105721; c=relaxed/simple;
	bh=7LKFfCFbzmlEynwe0Tr8raROJe7wN73Kd9MIXE9C1zM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=d8X4nenM7w17qINLrHsGn+flaLlQO7cObYhQU0kn3okerXEuCPh9U4ze3grbveFwV2fAoi7W5Xsjf3xF/XUydr1tqNUiTrwLVclUDt1KdxU3+zJq7Dkl5+PY1eS0NUUFWdWLIiMsY06QNAPvLYfRRgsgePiGWu+Nx6B1bH3IDdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YhL+VLXQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YhL+VLXQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A688FC116C6;
	Thu, 22 Jan 2026 18:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769105719;
	bh=7LKFfCFbzmlEynwe0Tr8raROJe7wN73Kd9MIXE9C1zM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YhL+VLXQUcCxy0w1Mq7nCEoEExNuM9OpjW+E5sCyH2R6AtFnIGULz7AzCYsr8cqT2
	 76IPzFtZAxtLXM4XBuu+A9KwX08GCVP2xFiNrcZZpNdIdXSByqEW76BVW7vJ1rvJwR
	 VIrCp8XvbBuMR7tFoN89Fhg9qDifvH+3wpViTUA879Vr6mB/CNr6uwEVMiXSo6fde3
	 fB/Uzio9Lx7knrPox+UIB3BvA89Yhr9Psc7V7hWbjy8eE28JBwz4NsnaC+yE+Lij/3
	 rh05b4DI6Eamq71TOt4lxHbZbI+ranYkGiJ7zhObvnSCw8tfkpQsrcxQwW0WqFOGaQ
	 L3IrVjWtDom3g==
Date: Thu, 22 Jan 2026 18:15:12 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com,
	Ryan.Roberts@arm.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Subject: Re: [PATCH 6.18 000/198] 6.18.7-rc1 review
Message-ID: <392ccce0-4042-47ac-abdd-d1ed830ea27d@sirena.org.uk>
References: <20260121181418.537774329@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BuFbwiFtP7fxVovs"
Content-Disposition: inline
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
X-Cookie: Don't read everything you believe.


--BuFbwiFtP7fxVovs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 21, 2026 at 07:13:48PM +0100, Greg Kroah-Hartman wrote:

> This is the start of the stable review cycle for the 6.18.7 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

However:

> Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
>     tools/testing/selftests: add forked (un)/faulted VMA merge tests

These are failing for me on arm64 and I think arm (something literally
exploded in my lab so the arm bisect didn't complete yet due to the
half of the lab with that board being powered off until I get that
fixed), that in turn causes a new top level failure of the merge
selftest program but the actual failure is purely newly added tests not
working so I don't think the kernel itself is any worse than it was
before.  The tests are OK in Linus' tree so we are I guess missing a
backport?

Log:

   https://lava.sirena.org.uk/scheduler/job/2395273#L4133

# # #  RUN           merge_with_fork.forked.mremap_faulted_to_unfaulted_prev ...
# # # merge.c:1283:mremap_faulted_to_unfaulted_prev:Expected procmap->query.vma_end (281473166635008) == (unsigned long)ptr_b + offset (281473166622720)
# # # mremap_faulted_to_unfaulted_prev: Test terminated by assertion
# # #          FAIL  merge_with_fork.forked.mremap_faulted_to_unfaulted_prev
# # not ok 16 merge_with_fork.forked.mremap_faulted_to_unfaulted_prev
# # #  RUN           merge_with_fork.forked.mremap_faulted_to_unfaulted_next ...
# # # merge.c:1349:mremap_faulted_to_unfaulted_next:Expected procmap->query.vma_end (281473166635008) == (unsigned long)ptr_a + offset (281473166622720)
# # # mremap_faulted_to_unfaulted_next: Test terminated by assertion
# # #          FAIL  merge_with_fork.forked.mremap_faulted_to_unfaulted_next
# # not ok 17 merge_with_fork.forked.mremap_faulted_to_unfaulted_next
# # #  RUN           merge_with_fork.forked.mremap_faulted_to_unfaulted_prev_unfaulted_next ...
# # # merge.c:1420:mremap_faulted_to_unfaulted_prev_unfaulted_next:Expected procmap->query.vma_end (281473166647296) == (unsigned long)ptr_a + offset (281473166622720)
# # # mremap_faulted_to_unfaulted_prev_unfaulted_next: Test terminated by assertion
# # #          FAIL  merge_with_fork.forked.mremap_faulted_to_unfaulted_prev_unfaulted_next
# # not ok 18 merge_with_fork.forked.mremap_faulted_to_unfaulted_prev_unfaulted_next
# # #  RUN           merge_with_fork.forked.mremap_faulted_to_unfaulted_prev_faulted_next ...
# # # merge.c:1495:mremap_faulted_to_unfaulted_prev_faulted_next:Expected procmap->query.vma_start (281473166610432) == (unsigned long)ptr_b (281473166622720)
# # # mremap_faulted_to_unfaulted_prev_faulted_next: Test terminated by assertion
# # #          FAIL  merge_with_fork.forked.mremap_faulted_to_unfaulted_prev_faulted_next
# # not ok 19 merge_with_fork.forked.mremap_faulted_to_unfaulted_prev_faulted_next

--BuFbwiFtP7fxVovs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmlyaTAACgkQJNaLcl1U
h9BeRwf/Tp6aH6UsW55SmaGC1ZzDwV3rF6Y8pHzX5GpSkciwHdkcYL74KMgdYjAq
LNoipMtmiEDnVW2NEyzlPfqvOdjgET2sN0VZutPuZ38aB7kGnk2Y6XvYyuVGyW/7
wfbnpAI0rl/lQlxo/k6dgwyTm1yzl5TJjnlhsduhSxTs6bsn4G6maGEMAFDXc5+5
DSnVR96jqaAvdcjcQpHQD+MVxPMWAOTcI7KOaZBpprZ77SWvhHXQsaXKUK0UkL9k
QPGzIicyoTzlsJn4lAtc86zlNZRBVlPxqTUXKKn7jg3e0ewgAVmrfGYvAZA1Ka1y
ZOndzPdQpZ72u0o9ERyuxBEs5UAYHQ==
=tnH2
-----END PGP SIGNATURE-----

--BuFbwiFtP7fxVovs--
