Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24FD2F260F;
	Tue, 10 Mar 2026 15:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773157978; cv=none; b=UB4T+n0vM/ikm2YR46e+XUGUvyCAkI/0TqTNVrWYJDm9vaTsoTO2b9eQ9PAa8gveLAPtELRPTCiNrPy9oTUbmmBc1iCQvQEeiG5gQCby+mYmnjUaLTj8yckJao8MRBSqamw7kTwLdbDITuZ6Cuo3lQtYJMLzv/EKl+4gjEVLrf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773157978; c=relaxed/simple;
	bh=wkitZQeNBRkjQi9Az3Zc3sVZlQJDuhnwq3pYzcCD4yE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aF1myK3u++5/baAUHbyAvceWyW+I6sq2haDj3OR6dVf6KdErPZQWfcMRGtjTc0SG8PBMdLkPwPvMj/5dfveM7ME5MHmXxMfMqe7jnSENnIbbU2bkxXwtbpMUy0guF0XDMo+Gm6gSRD4irT+JRwIGrcuCP7JsavKVsujLNT+6ykw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n6dnPeEH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n6dnPeEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB080C2BC86;
	Tue, 10 Mar 2026 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773157977;
	bh=wkitZQeNBRkjQi9Az3Zc3sVZlQJDuhnwq3pYzcCD4yE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n6dnPeEHg6juP5qa1ClKKlexDnXW0HR06xqE9uwiN27u/PGWezBtdSddzX5rleM25
	 XToqu9wf9hOd43nND9h7Ol5xqolh8x8A8S8xTrkBM7yV+p4AINE7lMaHjYXef5rdui
	 4N8dFhJAx202ysCBsgZ/bFr0rzxlqRsFzabYcnPl8WbWyX8uF0gGDhYYxk1NBGljMy
	 eHdMg1PIjBUkMLrxiz1C8be9dD2YKE2t68XZZBD+ysh0R/rOxej1f7OBuLO16B+Kb9
	 YWui6meEonKjUwk3gKXS6WZjUCRS2s/TSyU2oAOI1G4tfNhtlPup4ZwKhLwXgCxiWD
	 LM3YiDh+IkTzQ==
Date: Tue, 10 Mar 2026 15:52:51 +0000
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	gregkh@linuxfoundation.org, patches@lists.linux.dev,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@nabladev.com,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, achill@achill.org, sr@sladewatkins.com
Subject: Re: [PATCH 6.19 000/311] 6.19.7-rc1 review
Message-ID: <5d86a585-d0f2-45ff-b908-786ac459fb33@sirena.org.uk>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="KYBQJBc4+XRwPQfj"
Content-Disposition: inline
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
X-Cookie: A fool and his honey are soon parted.


--KYBQJBc4+XRwPQfj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Mar 10, 2026 at 07:05:54AM -0400, Sasha Levin wrote:
>=20
> This is the start of the stable review cycle for the 6.19.7 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Mark Brown <broonie@kernel.org>

--KYBQJBc4+XRwPQfj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmmwPlIACgkQJNaLcl1U
h9AJ6Af+IHIXcj3rnEzxG4uJqGxZoJM+DEfoUih8qoCl2kbk2dSBT/Ansmq1VtrC
wHQ23mZjGQeJmWCZ09rIRtniicXGaJk91tJdu/tnraUG59OW3byQEqp5ns0vh438
7Fk7FiuhXYYZexa9GjbhSehHp6gUS22KqKeF2CAAO7yWqFoe6QIzfSbEo+ycxuGk
nLNQgtpGLinZWhiAm7UQ9sKYdXuZpu+LIP2dR/jUEkcTpWa5ry8qixNIgJFtKhsG
sDjhTwGf/dHzh/nZn+JCcYErspbIh6kYtOOOJnwKXk3vGSLApznkRhjbdGRzPa8e
2FWPKUh6kCcuajEr+uWEpHOyhwhZRg==
=rxYJ
-----END PGP SIGNATURE-----

--KYBQJBc4+XRwPQfj--
