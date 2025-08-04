Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 246BD1482E8;
	Mon,  4 Aug 2025 11:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754307374; cv=none; b=hlG7fKrrsVmP9jDihj8fWGBpAWF4FdrEjs5JY8YpB4dWneY5oPDfMg5l+YlAEZ7dlnxy2Ottg9G16jTpIivP9dREWOYNrMXzwzfK6bBDngXc5s62oZ5yDbya7LuD9maaW5Mv0tndnhI2PHsDuerOtfQVsZV65j4QeNiZo68eZYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754307374; c=relaxed/simple;
	bh=ORG0wB/M4qMPDcT6cKOR1scPbgPHW2A9accXiG563rw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JLbuYqDzTVy2JZ3hfHS7hmZgiLIQB8wzGJ7/u9wxSvoHe2er5aVMznKWi0DFTfooZeQZ+jxW1dD9oNyeR46kwcwVwZWl/aJgKXptmZ12kHwqj7RM3/cLxngy1FkAnNUZVdKbbrkVJyC8YroWTOgYIRx4r74CJLQaqZfrj+jTLEk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FNZX1GHY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FNZX1GHY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1118BC4CEE7;
	Mon,  4 Aug 2025 11:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754307373;
	bh=ORG0wB/M4qMPDcT6cKOR1scPbgPHW2A9accXiG563rw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FNZX1GHYkBkAHJyRfdcYtr2JK8aAVzMAuMZ4YDnMEz2mpkqa2+wYQSm/WwW+BnZQV
	 riqmS99JoZr+TZh2mmbidswQPpH8V+lqsiCHx50R4ZgJ3hcbF0JPyWMEEM7DmX3UNA
	 bYivMIkd++IfQQbmg/yUtXOPMQaKPrtPuqDqx9yGLO3zdzrnex/mFN1CsTeBIi2/gJ
	 NIIMP9BCjvLEtGSYAmnTrIEqgLfLaUVRwiPjhu+EenUeAx8MHllYKVqn88JUywdsb7
	 0ObusQVi8A4Q/oC2Po9584ydQxJ7Kkw75gmk9UEmDar+916p+sYHmgOrJdavRoqQXi
	 m93GQ1UP2C0aA==
Date: Mon, 4 Aug 2025 12:36:08 +0100
From: Mark Brown <broonie@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Romain Gantois <romain.gantois@bootlin.com>, lgirdwood@gmail.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.16 09/85] regulator: core: repeat voltage
 setting request for stepped regulators
Message-ID: <38852b6e-20b3-43fc-90d7-29d10fd90abe@sirena.org.uk>
References: <20250804002335.3613254-1-sashal@kernel.org>
 <20250804002335.3613254-9-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="urprXkXJYhHv3HO9"
Content-Disposition: inline
In-Reply-To: <20250804002335.3613254-9-sashal@kernel.org>
X-Cookie: Shading within a garment may occur.


--urprXkXJYhHv3HO9
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Aug 03, 2025 at 08:22:18PM -0400, Sasha Levin wrote:
> From: Romain Gantois <romain.gantois@bootlin.com>
>=20
> [ Upstream commit d511206dc7443120637efd9cfa3ab06a26da33dd ]
>=20
> The regulator_set_voltage() function may exhibit unexpected behavior if t=
he
> target regulator has a maximum voltage step constraint. With such a
> constraint, the regulator core may clamp the requested voltage to a lesser
> value, to ensure that the voltage delta stays under the specified limit.

This needs a followup fix which isn't in mainline yet.

--urprXkXJYhHv3HO9
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmiQmygACgkQJNaLcl1U
h9BMIgf9HW0/kKMoykG2Dbv3Ea4j6lUxwMpw8a8fBsijjTqQTmBJgTCgleg9K0bJ
mM5xErzQ8SgnxHI31KehY075h87gotpTsIavVahhjtaaLrNbHlbNymPK7uupw5Ot
IekJw+pP2PyhOabVg5jPMEJVJ2XxN0Np5PVvLWr4Fk7tMdLOQtrA40/y7XptOG2u
Mf4PzY2RXSIV9gvS3LUJmV7sT+IBSYGKXMCzIytu0b4sIgCQJsXURdtZa77JmhR6
9K8/KWPgjDPIXhIVFzffJvuA/8IGMeQczrrZ5720tfwx2J9TK86q9qnMNjsd3byh
WSTm2EpDgyNflhRA26O4DYCeQ53KKA==
=DqHh
-----END PGP SIGNATURE-----

--urprXkXJYhHv3HO9--
