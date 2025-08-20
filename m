Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E5F19F464;
	Wed, 20 Aug 2025 10:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755687485; cv=none; b=XKgsgiwWeaYYy/WAudQOVJTkCcUQpztO55z1zgTboOL5inFS4u7hDt9iYTBRUhmSu+btVGuvvzkbq3IEwECUtWg4T9vfJSzw+aaamW5theZViZUoHxTNnp6nQ8ZEWmBFglYvaPu1HkoyZ1rHSQDb1BkrLwpILUWkojMtiAihDBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755687485; c=relaxed/simple;
	bh=4NXtbsIF7zkWSWd9a3AKJkxNkmMkiT2u3m4nyMY6uWc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mpITagu88pqRdE+t78Uv0KbstEO39BNaxAJ0JqVP3wK2etABn4EBUg/Vye/AVBU4MvDzpAeJIZFH2T6i/rp9NMLubbDrWo1Z8mjsWfI0c357lwrzWmWFSm71rd3v11/XFSGFaRnA0GKTuBwO918nUi9My9EIC0kCRANmn/SoeeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vja5s3Zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vja5s3Zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0590C4CEEB;
	Wed, 20 Aug 2025 10:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755687484;
	bh=4NXtbsIF7zkWSWd9a3AKJkxNkmMkiT2u3m4nyMY6uWc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Vja5s3ZtAW9nZ+lVGVRpb1nQ4zjrPUukx2cV0WX7QX+0ywkV0E1LT7WMzjldY/oD/
	 07GzkdUhgTJOQfM7Kb9a4+nZ9XbbjlRt1aMT3AMt8bqlsoclstqN4ZsAJiJrqKojyM
	 hwx5YT8qoBR9ETmvVfEQyMYkmm/WJ+PIU6if5IKCEF+30BneLXyGijUOfiaWTjv12k
	 odo9sw+9k59IskPsktvcs1HWUZIYpKxZIrAd95wClia1fd971/k5swQj3sadqGOguf
	 pE3u7cG3gfSBd14nSuKL+XtARGOVADFgsd51V9kECGml3+KCFdo6r0cLj3WhFzKafc
	 3CyQEJ70EjTmw==
Date: Wed, 20 Aug 2025 11:57:57 +0100
From: Mark Brown <broonie@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com, achill@achill.org
Subject: Re: [PATCH 6.15 000/509] 6.15.11-rc2 review
Message-ID: <bb8ebf36-fb7c-470c-89e7-e6607460c973@sirena.org.uk>
References: <20250819122834.836683687@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="H4CAt+Juhodk0/59"
Content-Disposition: inline
In-Reply-To: <20250819122834.836683687@linuxfoundation.org>
X-Cookie: What UNIVERSE is this, please??


--H4CAt+Juhodk0/59
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Aug 19, 2025 at 02:31:36PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 509 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

I'm still seeing failures in the LTP epoll04 test which bisect to
"eventpoll: Fix semi-unbounded recursion":

# bad: [cf068471031d89c4d7ce04f477ba69a043736a58] Linux 6.15.11-rc2
# good: [cb1830ee48ef7b444b20dd66493b0719ababd2b1] Linux 6.15.10
git bisect start 'cf068471031d89c4d7ce04f477ba69a043736a58' 'cb1830ee48ef7b444b20dd66493b0719ababd2b1'
# test job: [cf068471031d89c4d7ce04f477ba69a043736a58] https://lava.sirena.org.uk/scheduler/job/1696008
# bad: [cf068471031d89c4d7ce04f477ba69a043736a58] Linux 6.15.11-rc2
git bisect bad cf068471031d89c4d7ce04f477ba69a043736a58
# test job: [ed147e6b0b6f77ab37b64cae52c324bb4d30ffd6] https://lava.sirena.org.uk/scheduler/job/1696635
# bad: [ed147e6b0b6f77ab37b64cae52c324bb4d30ffd6] wifi: mt76: mt7915: mcu: re-init MCU before loading FW patch
git bisect bad ed147e6b0b6f77ab37b64cae52c324bb4d30ffd6
# test job: [f228799b3622c5e7dee0ca367ede5c5116dd2749] https://lava.sirena.org.uk/scheduler/job/1697068
# bad: [f228799b3622c5e7dee0ca367ede5c5116dd2749] usb: typec: tcpm/tcpci_maxim: fix irq wake usage
git bisect bad f228799b3622c5e7dee0ca367ede5c5116dd2749
# test job: [379a9a450eccaea2781063475865a759609c42d7] https://lava.sirena.org.uk/scheduler/job/1697316
# bad: [379a9a450eccaea2781063475865a759609c42d7] net: ti: icssg-prueth: Fix emac link speed handling
git bisect bad 379a9a450eccaea2781063475865a759609c42d7
# test job: [22919356643e8d2fae162c80fd41d3a18b699ba1] https://lava.sirena.org.uk/scheduler/job/1697640
# good: [22919356643e8d2fae162c80fd41d3a18b699ba1] NFSD: detect mismatch of file handle and delegation stateid in OPEN op
git bisect good 22919356643e8d2fae162c80fd41d3a18b699ba1
# test job: [289acd66730cee0a50eadea70d09c796eb985fb3] https://lava.sirena.org.uk/scheduler/job/1697768
# bad: [289acd66730cee0a50eadea70d09c796eb985fb3] ACPI: processor: perflib: Fix initial _PPC limit application
git bisect bad 289acd66730cee0a50eadea70d09c796eb985fb3
# test job: [acda7f7119d35afceb774736a2dee8453745403e] https://lava.sirena.org.uk/scheduler/job/1697900
# good: [acda7f7119d35afceb774736a2dee8453745403e] sunvdc: Balance device refcount in vdc_port_mpgroup_check
git bisect good acda7f7119d35afceb774736a2dee8453745403e
# test job: [9a521a568272528a4bf9a9bed5a4ead00045c7e6] https://lava.sirena.org.uk/scheduler/job/1698135
# good: [9a521a568272528a4bf9a9bed5a4ead00045c7e6] fscrypt: Don't use problematic non-inline crypto engines
git bisect good 9a521a568272528a4bf9a9bed5a4ead00045c7e6
# test job: [3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3] https://lava.sirena.org.uk/scheduler/job/1698312
# bad: [3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3] eventpoll: Fix semi-unbounded recursion
git bisect bad 3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3
# test job: [222c3853173605105bf3a4dda135a655ef894fc0] https://lava.sirena.org.uk/scheduler/job/1698459
# good: [222c3853173605105bf3a4dda135a655ef894fc0] fs: Prevent file descriptor table allocations exceeding INT_MAX
git bisect good 222c3853173605105bf3a4dda135a655ef894fc0
# first bad commit: [3b03bb96f7485981aa3c59b26b4d3a1c700ba9f3] eventpoll: Fix semi-unbounded recursion

--H4CAt+Juhodk0/59
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmilqjUACgkQJNaLcl1U
h9DuFAf/c7petUxB4P+0ecqrsblDOFTNLxTddsTY809ZWMJCvW6iQ4xZdCVyQby7
mMSc8O7MHzQYOrJEbo6au+peOZD9U4Z0jp7QU6SMzBgcBAS/ruz7YQin3AS+62+1
D1d1GWAoE6F7rt1uNyJHYbepGME8LHUFYLuuy1KyfL7TBrqTkXA85A9j0/5pWsyu
0GJeDZZE+AunNpxo0LK7i+9Bu0GPe8RzhSEknmzSp4fSSN4JPGfr9mkVegjUFzjX
cgFjyc61xIzyEZm3gqHpFCnK+ryE1WtTUFH9atVA0HINIp9VnjSw+pAicfXdf1xd
Qtykc+/zT90wCIL9vKpPfoAe3QLdcw==
=LIOo
-----END PGP SIGNATURE-----

--H4CAt+Juhodk0/59--
