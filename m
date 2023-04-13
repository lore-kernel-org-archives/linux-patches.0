Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4148F2F31
	for <patches@lists.linux.dev>; Thu, 13 Apr 2023 22:22:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A588C433D2;
	Thu, 13 Apr 2023 22:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1681424577;
	bh=1tkGVNkh5mtgc1lUnPVm9sXXKjCYxesPI5fmgwuuyPQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ZWY3jYOVkEYGIRmU2gLBqJ0crhvbz7Ufz93+tiCtUHrit2ktzSif341pPgd3Ysjre
	 gUaUwIF78slrGvRs368ZAS5Gbb/Jy17dA65+654LJbpHzjo93toSssoiKdaRzvaY6u
	 mBZukuSLfNd4XOUruiwiKFFoM9k9/McYA9LftgoueaZSnTdnAQB/V3yL139cr7k6kD
	 Hs7jare8xK9ZW9DGTNo5v+E7nsA2gsTm4ERseqxK0bSv6Vv6m4Hiva/AK44PohTcTy
	 N/E9/skyCnwAB/9Wlpi6x5gcc4L6mfDp9RAqpeYoqGmuXoY+YHnObR8OmEeZgOWMRy
	 ZOlT2clibcJmA==
Date: Thu, 13 Apr 2023 23:22:52 +0100
From: Conor Dooley <conor@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
	patches@lists.linux.dev, Tommaso Merciai <tomm.merciai@gmail.com>,
	Emil Renner Berthing <emil.renner.berthing@canonical.com>,
	Hal Feng <hal.feng@starfivetech.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Xingyu Wu <xingyu.wu@starfivetech.com>
Subject: Re: [PATCH] clk: starfive: Avoid casting iomem pointers
Message-ID: <20230413-nastiness-endurance-3a9159e599d4@spud>
References: <20230413205528.4044216-1-sboyd@kernel.org>
 <20230413-creamer-overstate-f7ce5a72e437@spud>
 <558d22a8848f2f026f272fdc0528424d.sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1wIS3iEeVvli0/Lq"
Content-Disposition: inline
In-Reply-To: <558d22a8848f2f026f272fdc0528424d.sboyd@kernel.org>


--1wIS3iEeVvli0/Lq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 13, 2023 at 03:01:02PM -0700, Stephen Boyd wrote:

> Yeah that looks better. Care to send a proper patch for it?

Yup, no problem: 20230413-critter-synopsis-dac070a86cb4@spud

Cheers,
Conor.

--1wIS3iEeVvli0/Lq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZDiAvAAKCRB4tDGHoIJi
0ii6AQD2B6CeWTcD+/POiQaJpv6BhpcQoDReJbIkRNIwlf7tWgD6AlJxcRngsS/H
rVcwq4nNi1A0jw5jvPnj3CqbRDuk+wE=
=o5Ls
-----END PGP SIGNATURE-----

--1wIS3iEeVvli0/Lq--
