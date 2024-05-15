Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EB9B224CE;
	Wed, 15 May 2024 16:42:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715791339; cv=none; b=qV+CDo+8TvlarwugIYbjmLV1eR0Org8RY99GIHpBi6I0bWvQ/x5HpkCbM6i8da4XSfWyJD70AIL6GfNSZIssqParx+7wtIsXJsJiANrzEAziVRtMiS6U4jCv/XfhjMGuaN7c3ykQJJ7Y1DNtYa2luLBvm7WqeZAh+hwPq0aXAt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715791339; c=relaxed/simple;
	bh=rUgqrNNVFpNtKuqpjS26h35aihDZzIQUN8MwxRBd0hM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CQau1D7o2LgkGHFIzdLh/Oqrs6M19AFNgmjsYLvu8xSsQzY8qlzU0N+wkJM/I0Dcs5d7Bekd90bKWm/ljXfYMBA1e6ude9zKpb9r58UaJhO8XQoohsfMxyNJfE8PIPW9N6iJCWt3Wgd68EXaKsbGQB0IisRONiLLvlibIDtrsDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ChMzNWT/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ChMzNWT/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CA3C116B1;
	Wed, 15 May 2024 16:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1715791338;
	bh=rUgqrNNVFpNtKuqpjS26h35aihDZzIQUN8MwxRBd0hM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ChMzNWT/bMQao81D+JTqpiZam95nxarDhB5hP1mvGJWtrp0edOp/gVmD3OKX3U2kv
	 NKA1CahBmt4bum1hqndCerE9KTbIq+L1f6ZIPBwUtYOJ+AGIb6Pn/X3KkobSU2K5WZ
	 gH5xqjgxr1SjlJGkngj66Ro4xoJVPO8XrjbTlNsNudZT8rJq61G1nw1sNRTXNBNz8D
	 LBLlqOw5D/06oZrAd4rMMHFTDCdbg1RuN3QNSotXrwM19BOTD1qvXgDD8f831UMT+M
	 tmA8A2UP5nWmkATnetuIm23amKbEcbyQM+IDk63pYSm4ZR4My87EsxjxRe/gGAI/ua
	 IYwM7PwSuvYKg==
Date: Wed, 15 May 2024 17:42:09 +0100
From: Mark Brown <broonie@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Doug Berger <opendmb@gmail.com>
Subject: Re: [PATCH 6.1 000/243] 6.1.91-rc2 review
Message-ID: <0357ee6b-868f-47f9-9554-48039d674ab4@sirena.org.uk>
References: <20240515082456.986812732@linuxfoundation.org>
 <39483cfc-4345-4fbd-87c2-9d618c6fdbc6@sirena.org.uk>
 <CAHk-=wjntFiQ=mM-zDHTMnrqki3MN3+6aSXhjnJozBaKqLLUDQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="451TC0y6zug/yq4B"
Content-Disposition: inline
In-Reply-To: <CAHk-=wjntFiQ=mM-zDHTMnrqki3MN3+6aSXhjnJozBaKqLLUDQ@mail.gmail.com>
X-Cookie: When in doubt, lead trump.


--451TC0y6zug/yq4B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 15, 2024 at 09:20:48AM -0700, Linus Torvalds wrote:
> On Wed, 15 May 2024 at 09:17, Mark Brown <broonie@kernel.org> wrote:

> >     A bisect claims that "net: bcmgenet:
> > synchronize EXT_RGMII_OOB_CTRL access" is the first commit that breaks,
> > I'm not seeing issues with other stables.

> That's d85cf67a3396 ("net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL
> access") upstream. Is upstream ok?

Yes, it seems fine in this regard (I am seeing some performance related
issues later on which trigger timeouts during tests but I'm fairly sure
they're infrastructure and they're definitely well after this issue
manifests).

--451TC0y6zug/yq4B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEreZoqmdXGLWf4p/qJNaLcl1Uh9AFAmZE5eEACgkQJNaLcl1U
h9C44wgAgDg7TTiDlp0WbQumgK76Howjr7voUw3lGAPNp5+NBuWigcqdEnTfKywI
1CBib8rcbELxqUN2/e6qXvAMP7l2BwHtPPe3YBy7PEw0VtwLV7FK11tm7lgeRYo4
zCMH1sEprOdXYkfqBz60FcsOZdM05GuE8wLhDRM1MRv95gDIb+MvPEVUmVUSF8hG
N1I1qk7Xld/n5RCCpAfAhjQEaxjHt0YrZRGjrr0sU3KZl+c59YhG4VoVTz78v4ue
vT8D7+ySnPJBmA0/LvppvmEoXCeu8rbwJiM7B+vS4b+V1b4i1rWb5VmJHZx/cWIU
Dw4alfAiwrG56r93eihfkeMTE8cF9g==
=UJe1
-----END PGP SIGNATURE-----

--451TC0y6zug/yq4B--
