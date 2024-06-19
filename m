Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A703A82871;
	Wed, 19 Jun 2024 13:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802313; cv=none; b=TNsxrnCxKFdZD97IKvRfHNAi+QQMnkZCZADqGiJb3WlyptUmSqjDXDMuFypOAT1utrNMAn7XqIfDybBnfT+3PgceE31n8+qoq2DrWCFz516G2MpE85FD4a3IGKzDHRr8NqhzBd36nbfkTvLqvPlE9SvIOAN6we8Ah+JocdGcQaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802313; c=relaxed/simple;
	bh=PTRu9LXtUGp3s0mBOOAQcnj4X6eQ12NeJbkhz+7wh7c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UViRkS7rq/1MR57pXX+qP9ZYe949yMXC9kQMuHXUau+nJTb7U3KnX4OsWZO2Bsx4DeIvSmfzOeCWHRKZ8MqJIP9CqyZFrnYjM0NgPg2S3aZrfgrXHGwDRRbJS+EEDX1Kx6qJby0dfJdMys8CO+3UfsOIOstwd1eh6VdxeLDj+Vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nhFD+ouJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nhFD+ouJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD62FC32786;
	Wed, 19 Jun 2024 13:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718802313;
	bh=PTRu9LXtUGp3s0mBOOAQcnj4X6eQ12NeJbkhz+7wh7c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nhFD+ouJLyF8aMkRyqhYXC5Q5DjPG8/UJR/GKCUPna5Dd+lnWwp6kMtpmrz1hlESk
	 jjr444Xu0jDB0CGkuOJdyaXSr0/QuF6EhCg5Tgx2ZMoGLK9TsQlyyzY1Q/+Ef7uuVg
	 ROsD/PlfKPdMwOql1Zu1zMScbrC1kMnNJXduO4JIE4xT2NAlcJp62c0tOxg3CL7FEq
	 QfHS1y1aqAIcYjpSx6OD2iGBuhWLrwGBea9Qr3WYV9BVg2WsMD4cjM08BIEREugsN+
	 IHZ+eZQfPJVaK3Zhh7wTWFytS+BaW5vLVQEnxZZAKfhkDgtGeVtENyFRYn2ceXNal7
	 GqKkTBkFaqzrA==
Date: Wed, 19 Jun 2024 14:05:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Muhammad Usama Anjum <usama.anjum@collabora.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Shuah Khan <shuah@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 069/267] selftests/mm: log a consistent test name for
 check_compaction
Message-ID: <72b9e2cd-be65-4fb7-82dc-04e870464b3f@sirena.org.uk>
References: <20240619125606.345939659@linuxfoundation.org>
 <20240619125609.005611983@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="S1swdCi9UCbRMg3p"
Content-Disposition: inline
In-Reply-To: <20240619125609.005611983@linuxfoundation.org>
X-Cookie: Don't I know you?


--S1swdCi9UCbRMg3p
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 19, 2024 at 02:53:40PM +0200, Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Mark Brown <broonie@kernel.org>
>=20
> [ Upstream commit f3b7568c49420d2dcd251032c9ca1e069ec8a6c9 ]
>=20
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

This will change the test names for these tests which might disrupt
people's CI.

--S1swdCi9UCbRMg3p
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZy14QACgkQJNaLcl1U
h9Aiiwf8D+Yagu4pmsdH3sCcpTR853zF7/x6i3YJ69KW3zswvzDuSDGwfLtWeKBM
JIy5LjkWnbMfFN+/Q/ujQrtH0DDAsqfhvdabvlC7qQeLmiPIGw69gszUj+SssDDx
xWvzkmCQDbm0smJQrajSGAHROZiG0eWb4BBgSKm/F+hQjVlydu7nB0p2fa6g2UMU
UGCkXCUQodIGrGkU/sOniwgcwIQ8I6LSDYM4GJldRgbM4d5LVHuglpsAciz3U9uv
eF1auV2d6UEpCRjI5rg7SOPH3d2J4jcx61jcEgTE0gBck0onIRSK+G6IJH7FfxRQ
haP+GefoxDWeE8uQcpbGsQ7U7bf7bw==
=Htcm
-----END PGP SIGNATURE-----

--S1swdCi9UCbRMg3p--
