Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A1C1991D5;
	Fri,  7 Jun 2024 15:54:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717775682; cv=none; b=OAdxn0aU6KsCOxJZNfc8yPEDhzsq3Lw8ckln8zW0Sq8V+S7oAmo1417e2oajdW97V/ovErkPQGxn5me7WaJOkes7AsrV1oEbdj1F5cGf5Iq9574KN9no13d6rSf49b12WcsKV/zd+dhdNZYHSytIDsaOeoP6gnJ5AFsYPaYKgU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717775682; c=relaxed/simple;
	bh=MFaeXmhix5eaxxS4d1BjhVv8v5zdiL95TNv1+Je9cn4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nYUYkqXu7rahYFj+MbERJ/FtWF11Lrkmskgo9o7GnVDcVWu1sSi6kQNpJjyqeAjPns02Q3Umb9ddNCBF434k3LN7oWMQpaBNbQwIxP07mhnGoHZH05CZq1LTeiCSwB/5jW/H1O5vaWCCxhraFFPggdHppS0fPiypLgpSwkjgMro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l54PWuxe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l54PWuxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985CEC2BBFC;
	Fri,  7 Jun 2024 15:54:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1717775682;
	bh=MFaeXmhix5eaxxS4d1BjhVv8v5zdiL95TNv1+Je9cn4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=l54PWuxehpgFnT9UPaGHcmB0kb63C+AdVndkCbdEVJy3mLN9SZtc0OBWr/Jfpl0Q0
	 xaejw/vJVkDcKbVyQ6SvomkpQa5FkMY0xyuTjN+rmuCtLWPkTibOusiFn2kZf7QVZE
	 j4fiwbcSIPZwr/LsI5w2jzPuHJPJQw8P+7g8uDCAmqx0PATU1MX3aKPN2HCCUhzILg
	 cMGtVHoIXFrKPVVq2s6k80JLOOj8FPsLp5BnSqsdjsQjOElWUVAEyKZ2QXeWoj9i57
	 KdXHkVD+Hqaa9WrisppkN6YnBeD8hfeVAGjxFJx+GJRFtWi3U2plZNIca7RlEhhsFn
	 itQB4hCdjk7ZA==
Date: Fri, 7 Jun 2024 16:54:36 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
Message-ID: <20240607-verdict-distract-2e220fbfe2a2@spud>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240607-footnote-script-3a1537265b4a@spud>
 <2024060756-graveyard-shifter-ba74@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="Zyl/1zyiKCZKMLx+"
Content-Disposition: inline
In-Reply-To: <2024060756-graveyard-shifter-ba74@gregkh>


--Zyl/1zyiKCZKMLx+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 07, 2024 at 05:26:40PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Jun 07, 2024 at 04:23:47PM +0100, Conor Dooley wrote:
> > On Thu, Jun 06, 2024 at 03:54:32PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.6.33 release.
> > > There are 744 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > Tested-by: Conor Dooley <conor.dooley@microchip.com>
> >=20
> > btw, I requested a backport of a riscv patch to fix some userspace
> > tools, but I didn't see it here.
> > https://lore.kernel.org/stable/20240530-disparity-deafening-dcbb9e2f164=
7@spud/
> > Were you just too busy travelling etc?
>=20
> Yes, I have been on the road for the past 2 weeks in meetings and
> training full-time with almost no time to catch up with requests like
> this.  You aren't alone, my backlog is big :(
>=20
> I'll catch up on it next week as I will be home then.

That's fine, it's been broken for a long time, one release more release
isn't gonna kill us :) Safe travels home.

--Zyl/1zyiKCZKMLx+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZmMtPAAKCRB4tDGHoIJi
0njIAQDer0G3btmJzBsMGa42YqKNc+WHM783APSPwrq+flOhwAEAu6l3+gLlIquA
ja2MoxBLFca/KeDvnHzIPBzWLCTM+gA=
=LlYP
-----END PGP SIGNATURE-----

--Zyl/1zyiKCZKMLx+--
