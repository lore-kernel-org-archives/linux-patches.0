Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69DEA28AAE3
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 11:00:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417247; cv=none; b=HWICWZShJNmyDNRFna/fjIjPnDMEHz3yngYylQDvh2yIOcVraEsj6EpP9wcAmyXLQPr4VDirFJqHMrygqcmCn8lqb+Nj5QwYzvDQSDktbwYx8TpMl5KRHEFFK9ZgI8DGEjwSwMKYKm9k8WH/dnJs0UZY4lvmbkvASkBYjZcxecg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417247; c=relaxed/simple;
	bh=Nnp6kM28SJhn1dHgxsnfgtN7arSCcUjewvZiqRMzyOg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=m1L6BMArUTk1NixqaV/8U+pF49+OzuFmgxDBXNs/sWizX/sDSa0ujTVArv9Dzu/QecbnQG9bD67HsazAz2XtaKYJemFinoi8sdnsI0R6UWAdxPK3LNUFxJz8cYNfwEihhy58XiZpwsBILJcBDq3J264/QUrdC0lZFs+WvdCG/cA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=Ocbol4wz; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="Ocbol4wz"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 5FFFC104884A8;
	Fri, 20 Jun 2025 13:00:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750417243; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=s5YDRpjfQeXJg/PmH/YnAlgs85/TD94CgobRMAUZNo0=;
	b=Ocbol4wzr4rDnqvfjoHa3WUCNl3UVAPHuYSN5kJq3MY8IRuCH1ahxzf0T2IReHyMIlriA/
	Cw90M3dm+lL8iCfxg9qr1O78LfP6y89GQJ0+bOa/v76ILClRFrFsSpNPf9HAs0i5NpUeFp
	KGa1wQSLmrhaNaxM6qd7MJNkzcpVEpxyKuCAYTZC008IQcW9Ziuc3saJxAVSCwqaqpStub
	+6s1Ao+O1Klf7CNz4FLUkXdiLXBm2VIPsE/SIFC+RCDKBSSFh9RJ6k+Z2dLgzSPrYDFI+h
	99njuk9zkA5Qo9n/Ith5XWdM3+Fj0tVFCJJ+wUh+QP6a1qh6sI8mG7z9z01DlQ==
Date: Fri, 20 Jun 2025 13:00:40 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Kees Cook <kees@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 094/512] overflow: Fix direct struct member
 initialization in _DEFINE_FLEX()
Message-ID: <aFU/WFSChI0rdiPE@duo.ucw.cz>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152423.388858988@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QIF2iB1hD1tdQXL/"
Content-Disposition: inline
In-Reply-To: <20250617152423.388858988@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--QIF2iB1hD1tdQXL/
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Gustavo A. R. Silva <gustavoars@kernel.org>
>=20
> [ Upstream commit 47e36ed7840661a9f7fb53554a1b04a5f8daffea ]
>=20
> Currently, to statically initialize the struct members of the `type`
> object created by _DEFINE_FLEX(), the internal `obj` member must be
> explicitly referenced at the call site. See:
>=20
> struct flex {
>         int a;
>         int b;
>         struct foo flex_array[];
> };
>=20
> _DEFINE_FLEX(struct flex, instance, flex_array,
>                  FIXED_SIZE, =3D {
>                         .obj =3D {
>                                 .a =3D 0,
>                                 .b =3D 1,
>                         },
>                 });
>=20
> This leaks _DEFINE_FLEX() internal implementation details and make
> the helper harder to use and read.

Not sure why this was selected for -stable.

BR,
								Pavel
--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--QIF2iB1hD1tdQXL/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFU/WAAKCRAw5/Bqldv6
8ix7AJ0TYIXBLT9dyOqkieKKVu6JakXrxACfW1HQgcOXb33xNZV/ch+O2ez0Yr4=
=0G1K
-----END PGP SIGNATURE-----

--QIF2iB1hD1tdQXL/--
