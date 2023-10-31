Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DE6208C7
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDXAjc0l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B1DC433C8;
	Tue, 31 Oct 2023 17:49:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698774564;
	bh=yfAybFwo37AKz0koNcIulbe/MEndE5NqZfhiaNe2/Fc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZDXAjc0lXRmnk8SaHAc/wXnQFj4vSj5thxadwzrG3LfHVSYo2DJK9niJD0vSan/DA
	 eOgP0hblsnJXphM8igpM90AmfAtAkjaB4dbt9MCdm6iGzE1lTwkyvkwpw9lohE2Buw
	 aqO54LkCVFvyYRpr8aCUhf2DSBWnsBX21fhfoe77attrmYKA2UxIlbX7aJmr2boTmt
	 9t22VTu/AKLTSOxok8QSzdUW1aWHkecDVJNBKlW/zbROg2QxjLuMV4cXTcUHlBIUox
	 cm54TA6SaZv47lfSF7qEBKTlJwc08rF4wK1nlk6r/h6YjhLc2yBzWfkOASIe6NActL
	 1XuUtvAzAR3PA==
Date: Tue, 31 Oct 2023 17:49:03 +0000
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= <u.kleine-koenig@pengutronix.de>,
	Takashi Iwai <tiwai@suse.de>,
	Nicolas Ferre <nicolas.ferre@microchip.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 05/86] ASoC: codecs: wcd938x: Convert to platform
 remove callback returning void
Message-ID: <8744aeca-36cb-4d47-86f9-92fa70a234e1@sirena.org.uk>
References: <20231031165918.608547597@linuxfoundation.org>
 <20231031165918.777236098@linuxfoundation.org>
 <958957ff-bbaa-4fbc-a796-30e2fdf61453@sirena.org.uk>
 <2023103133-skating-last-e2f6@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5p9rVLrHpNPq6KgE"
Content-Disposition: inline
In-Reply-To: <2023103133-skating-last-e2f6@gregkh>
X-Cookie: Is it clean in other dimensions?


--5p9rVLrHpNPq6KgE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 31, 2023 at 06:44:52PM +0100, Greg Kroah-Hartman wrote:
> On Tue, Oct 31, 2023 at 05:11:27PM +0000, Mark Brown wrote:

> > This doesn't seem like obvious stable material - it's not fixing any
> > leaks or anything, just preparing for an API transition?

> It was taken to make the patch after this one apply cleanly, that's all.

Ah, I see.

--5p9rVLrHpNPq6KgE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmVBPg4ACgkQJNaLcl1U
h9AbVgf/V1/PUDKl2vsSHoruN2JgKZ09hRoqNMY7EDXLjJwGrRRY6IEBxcIB8itG
fVUXafdEcWlRffUKJaMjBImc6ZfN6K2TPbR6YmlA43/HwQ+ug3hBjvHvyRtvyS3o
SNdcLvOMhvPo4EyxldJtlBaMM2nLGGfqBqNA7SlaP5JP2eO3+sDAXzpPhL/uHTfo
qjEJWHtRl0C+VGzC7lbE4hEPbt8zncxR3ilLg+mXrj33O7wJgBnOlWv4+DoGsRP1
n6+ifuyhfr9B8OrN2tqP8BW9p5xLyRLkQabHHlO0SD6mtVQClMaGGjmIgcdWarhg
HI/8oSW3UwviQFZy24pfoOrSOem0eQ==
=1mp4
-----END PGP SIGNATURE-----

--5p9rVLrHpNPq6KgE--
