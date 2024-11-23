Received: from jabberwock.ucw.cz (jabberwock.ucw.cz [46.255.230.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEC2829CEB
	for <patches@lists.linux.dev>; Sat, 23 Nov 2024 17:47:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.255.230.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732384068; cv=none; b=d2XrErAPKeTD/UmwO/GukyUG+ArmBLVZMmYpGytX7EY65W+OpUGKSuc05uNgd56Qouu4/Mx10oySsz2W8Z9owDhI2BhEctEwnXpZ0nUmRDiGa2NpYz1QPJVri5+zULYe2SwoT7CG9mmKeHLrjNxvUIQPd8kNml5kHQbUUyS0ryE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732384068; c=relaxed/simple;
	bh=lMObQn8yBdrVaEnBzcu44IiGjvVTLgfyH5x+62U3p5k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=giRshpW52bstRxPSPbTWPsyxMHyExcTPLC+B2BIwXj0A5dfH2KzuBvyiAxewEgJ4/TfBSk7NxjFXhmjzNicqEm9H/qC75EJui1DYOq/3xpf6oNWiLHWr2wt9NQeniK6LLb02Svk5B1m2DdlaJPlEe3awRdxYXkdb08aBG//6hdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de; spf=fail smtp.mailfrom=denx.de; arc=none smtp.client-ip=46.255.230.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=denx.de
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
	id AF0DC1C00B2; Sat, 23 Nov 2024 18:47:41 +0100 (CET)
Date: Sat, 23 Nov 2024 18:47:41 +0100
From: Pavel Machek <pavel@denx.de>
To: Chuck Lever III <chuck.lever@oracle.com>
Cc: Pavel Machek <pavel@denx.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-stable <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Guenter Roeck <linux@roeck-us.net>,
	"shuah@kernel.org" <shuah@kernel.org>,
	"patches@kernelci.org" <patches@kernelci.org>,
	"lkft-triage@lists.linaro.org" <lkft-triage@lists.linaro.org>,
	Jon Hunter <jonathanh@nvidia.com>,
	"f.fainelli@gmail.com" <f.fainelli@gmail.com>,
	"sudipm.mukherjee@gmail.com" <sudipm.mukherjee@gmail.com>,
	"srw@sladewatkins.net" <srw@sladewatkins.net>,
	"rwarsow@gmx.de" <rwarsow@gmx.de>,
	"conor@kernel.org" <conor@kernel.org>,
	"hargar@microsoft.com" <hargar@microsoft.com>,
	"broonie@kernel.org" <broonie@kernel.org>,
	"seanjc@google.com" <seanjc@google.com>
Subject: Re: [PATCH 6.1 00/73] 6.1.119-rc1 review
Message-ID: <Z0IVPdzqPMSWuCoU@duo.ucw.cz>
References: <20241120125809.623237564@linuxfoundation.org>
 <Z0GDhId6mYswr+K0@duo.ucw.cz>
 <4EA31082-AA71-4E14-B63D-A7AE2480ABA6@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="qCT1nQSgHcYnHj3y"
Content-Disposition: inline
In-Reply-To: <4EA31082-AA71-4E14-B63D-A7AE2480ABA6@oracle.com>


--qCT1nQSgHcYnHj3y
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> >> This is the start of the stable review cycle for the 6.1.119 release.
> >> There are 73 patches in this series, all will be posted as a response
> >> to this one.  If anyone has any issues with these being applied, please
> >> let me know.
> >=20
> >> Chuck Lever <chuck.lever@oracle.com>
> >>    NFSD: Limit the number of concurrent async COPY operations
> >=20
> > @@ -1782,10 +1783,16 @@ nfsd4_copy(struct svc_rqst *rqstp, struct nfsd4=
_compound_state *cstate,
> >        if (nfsd4_copy_is_async(copy)) {
> > -               status =3D nfserrno(-ENOMEM);
> >                async_copy =3D kzalloc(sizeof(struct nfsd4_copy), GFP_KE=
RNEL);
> >                if (!async_copy)
> >                        goto out_err;
> >=20
> > This is wrong. Status is success from previous code, and you are now
> > returning it in case of error.
>=20
> This "status =3D" line was removed because the out_err: label
> unconditionally sets status =3D nfserr_jukebox.

Aha, I see, sorry, I missed that detail.

> > (Also, the atomic dance does not work. It will not allow desired
> > concurency in case of races. Semaphore is canonical solution for
> > this.)
>=20
> I'm not certain which "atomic dance" you are referring to here.
> Do you mean:
>=20
> 1792                 if (atomic_inc_return(&nn->pending_async_copies) >
> 1793                                 (int)rqstp->rq_pool->sp_nrthreads)
> 1794                         goto out_err;
>=20
> The cap doesn't have to be perfect; it just has to make sure
> that the pending value doesn't underflow or overflow. Note
> that this code is updated in a later patch.

The cap is not perfect, indeed. I'll take your word it does not matter.

Best regards,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--qCT1nQSgHcYnHj3y
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCZ0IVPQAKCRAw5/Bqldv6
8haSAKC0qWimwT3VUEQTpsD4n03YHfIHQgCfRpVrg+vN5u91ju9p+WrXvjMdFDE=
=VxGh
-----END PGP SIGNATURE-----

--qCT1nQSgHcYnHj3y--
