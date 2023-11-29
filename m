Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F77012B89
	for <patches@lists.linux.dev>; Wed, 29 Nov 2023 09:00:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id 970A61C0050; Wed, 29 Nov 2023 10:00:44 +0100 (CET)
Date: Wed, 29 Nov 2023 10:00:44 +0100
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pavel Machek <pavel@denx.de>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	LKML <linux-kernel@vger.kernel.org>, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, alexander.deucher@amd.com,
	mario.limonciello@amd.com, zhujun2@cmss.chinamobile.com,
	sashal@kernel.org, skhan@linuxfoundation.org, bhelgaas@google.com
Subject: Re: [PATCH 4.14 00/53] 4.14.331-rc2 review
Message-ID: <ZWb9vGuZck1sGBIN@duo.ucw.cz>
References: <20231125163059.878143365@linuxfoundation.org>
 <ZWUBaYipygLMkfjz@duo.ucw.cz>
 <f4a7634-3d34-af29-36ca-6f3439b4ce9@linux.intel.com>
 <ZWZQCJtD7kmX9iRO@duo.ucw.cz>
 <2023112818-browse-floss-eb6f@gregkh>
 <ZWZSKgxjSRcA/qUK@duo.ucw.cz>
 <2023112844-sesame-overdrawn-5853@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="teF5qnI1d0trbQ69"
Content-Disposition: inline
In-Reply-To: <2023112844-sesame-overdrawn-5853@gregkh>


--teF5qnI1d0trbQ69
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue 2023-11-28 21:10:03, Greg Kroah-Hartman wrote:
> On Tue, Nov 28, 2023 at 09:48:42PM +0100, Pavel Machek wrote:
> > Hi!
> >=20
> > > > > > > Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> > > > > > >     RDMA/hfi1: Use FIELD_GET() to extract Link Width
> > > > > >=20
> > > > > > This is a good cleanup, but not a bugfix.
> > > > > >=20
> > > > > > > Ilpo J=E4rvinen <ilpo.jarvinen@linux.intel.com>
> > > > > > >     atm: iphase: Do PCI error checks on own line
> > > > > >=20
> > > > > > Just a cleanup, not sure why it was picked for stable.
> > > > >=20
> > > > > Just an additional bit of information, there have been quite many=
 cleanups=20
> > > > > from me which have recently gotten the stable notification for so=
me=20
> > > > > mysterious reason. When I had tens of them in my inbox and for va=
rious=20
> > > > > kernel versions, I immediately stopped caring to stop it from hap=
pening.
> > > > >=20
> > > > > AFAIK, I've not marked those for stable inclusion so I've no idea=
 what
> > > > > got them included.
> > > >=20
> > > > Fixes tag can do it. Plus, "AUTOSEL" robot does it randomly, with no
> > > > human oversight :-(.
> > >=20
> > > the autosel bot has lots of oversight.
> >=20
> > Can you describe how that oversight works?
>=20
> There have been many papers and presentations about it, no need for me
> to say it all here again...

Give a pointer.

And explain why AUTOSEL is full of cleanups, as noticed by Ilpo, me
and others. AFAICT Sasha does not hand-check patches picked by
AUTOSEL, simply spams the mailing lists, and hopes that maintainers
will react. And they won't, because they don't understand the
implications, and simply ignore the spam. Or they will, and Sasha
simply ignores the reply.

If the process is something else, give me a pointer to explanation.

Thanks,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--teF5qnI1d0trbQ69
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZWb9vAAKCRAw5/Bqldv6
8pn+AKC0PXJoJA4sjfhgj6Od0KjiMtA0kQCfUJAEAmSPqVhSQol6U5nSV20+e6Y=
=uT2R
-----END PGP SIGNATURE-----

--teF5qnI1d0trbQ69--
