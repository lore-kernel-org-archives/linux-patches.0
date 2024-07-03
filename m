Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB10B13C3D3;
	Wed,  3 Jul 2024 12:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720008143; cv=none; b=GRfoVDyIj22MM06V0iGT6S/qd7AdA5duWCSS1PhMs/hXvImbH2XuJhdfuVJ55S4OJbKQK8Pr92ENZuxTiclpoIGtmp5wxhCj9DK5IzJn8omkRq97w4Ry+6V6F+Bt6/1UUaWy9JZPrwjEMhcVtXzC+WaoiCv2AyjBgr1OqaWdiTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720008143; c=relaxed/simple;
	bh=Al8/JsQVoiEny9JlYrmZkCUw5uitD7yQhpfmW2ScTIA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gbhm+vnVq1iK4bxwsy3vtejSJzpSYeQPP3jLVN4LsvSogVXNz4xYg1eOzd/Dgl//6qF0G7HA9BoJztOsK7qUaZGHajYGI+S5PF1eXskw7rkmT6ePLCSuJJMOuiC68ylcl4Pafle+R/8Xb9QtgYRWLdR036XkeP/fzIoodJazSW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=duvB6pxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="duvB6pxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C082C2BD10;
	Wed,  3 Jul 2024 12:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1720008143;
	bh=Al8/JsQVoiEny9JlYrmZkCUw5uitD7yQhpfmW2ScTIA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=duvB6pxBu7z/aLGhPfQxOuDkxa6JBMQiRAX6Td1fyEQwaHEBV+qnKpmiCFuLT69aD
	 pi9i1f0BfnSZdSuQj0ynFPeTgLykh0Ea30cWGxOAEHTiOfC9Mua8H6xTP09U35g/Dz
	 v9m+jxX16zgzXFIuLns4GQA7Sz2WHUjFwraqUtClC4+CfnAD1Xu9AjB+18MkWWENY3
	 ORCK4shVzdbp78FOzZK7UAbt9H48FANXtvrJaJud3i+qUMY7EpQkKZc5In2eQ5fBCq
	 Id9Hrxb8pgaHrfY/xPPrynp5xrGdzRvc3FZPlhtIAsB180vquzcXht5sZ8jzG5y8Be
	 A/77zOXEl/dAw==
Date: Wed, 3 Jul 2024 13:02:18 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 067/356] selftests/mm: log a consistent test name
 for check_compaction
Message-ID: <416ea8e5-f3e0-47b3-93c2-34a67c474d8f@sirena.org.uk>
References: <20240703102913.093882413@linuxfoundation.org>
 <20240703102915.636328702@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="RIHx1C9vyBB2MOnu"
Content-Disposition: inline
In-Reply-To: <20240703102915.636328702@linuxfoundation.org>
X-Cookie: There is a fly on your nose.


--RIHx1C9vyBB2MOnu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 03, 2024 at 12:36:43PM +0200, Greg Kroah-Hartman wrote:

> Every test result report in the compaction test prints a distinct log
> messae, and some of the reports print a name that varies at runtime.  This
> causes problems for automation since a lot of automation software uses the
> printed string as the name of the test, if the name varies from run to run
> and from pass to fail then the automation software can't identify that a
> test changed result or that the same tests are being run.
>=20
> Refactor the logging to use a consistent name when printing the result of
> the test, printing the existing messages as diagnostic information instead
> so they are still available for people trying to interpret the results.

I'm not convinced that this is a good stable candidate, it will change
the output people are seeing in their test environment which might be an
undesirable change.

--RIHx1C9vyBB2MOnu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmaFPckACgkQJNaLcl1U
h9AhSgf/aap702qY059NOepY37zjg/l9QiyMxcSHLyLE+vGJbnBOVHRKME3uT0nA
t99OH/u0QM+kw5932QAU1KqE/IYxH+QVYaPBGRPR/YwmmLCYIhoFkGDzKagziMwh
PxouO1u8VPgV2DdA00xNPIKil+MFzKa0fASfmy8PUnKIoccGB6pLMev5WJkjo4/V
/AASkds9vc+/8lQ6umpT5NPcGmAZPuPclluH0l/vj4udCPKpSXRuqDlqEySgLwPB
+n9i/9R6I+VuCjzOCxQOc8aXsYvIcq9BqBuikZDwDQYGr9LMnaJ6gi7mnKmsvfTk
ZdELaY2Rx6dNdblVXeXzpkWaXKT6KA==
=5sUY
-----END PGP SIGNATURE-----

--RIHx1C9vyBB2MOnu--
