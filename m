Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB5352F8EA5;
	Wed, 24 Jun 2026 15:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782314345; cv=none; b=FMt+5PEztKiza5PkGP87Lh0iwjhL0DG/r5BmaKYdaQ07v7TIs15mMUYi5W6fnjTHeemqiuWTQjGDmMmEMUBX+ss/yGQm2XWIE/ZuupO4MAC6BHsZUL7JknxlTvIkx+F5jWEmy2JDOPzWidvIs7pAjWk/7C+U/SCyzc2nvnB5/BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782314345; c=relaxed/simple;
	bh=QRtmDFIt4aXfDOHUY3Mt3rvSCzaVNgg/7GNG7k7kKec=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=f0DK4sv1Y0P3PjyOwMWy4Dt0z5c08Jzi17HHwELsiDUR0BrnAaCVQK/yGRQdn/zc6kx8hDQ5Glf2JxKCtYcGtt52585NHuG8IahWkyIl3nIQrSFFmQSOuFYQZ8jmwRvLFAxaY0BB/gN6HdajfcIqUNXz738DEMz/51gcw2eGBcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcPNQ-0041AD-09;
	Wed, 24 Jun 2026 15:18:56 +0000
Received: from ben by deadeye with local (Exim 4.99.3)
	(envelope-from <ben@decadent.org.uk>)
	id 1wcPNO-00000007zzq-3dvh;
	Wed, 24 Jun 2026 17:18:54 +0200
Message-ID: <b6441670bdb04dc530f433bd21d6c64feb633355.camel@decadent.org.uk>
Subject: Re: [PATCH 5.15 299/411] ALSA: aloop: Fix peer runtime UAF during
 format-change stop
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, 
	syzbot+8fa95c41eafbc9d2ff6f@syzkaller.appspotmail.com, Takashi Iwai	
 <tiwai@suse.com>, =?ISO-8859-1?Q?C=E1ssio?= Gabriel	
 <cassiogabrielcontato@gmail.com>, Takashi Iwai <tiwai@suse.de>, Sasha Levin
	 <sashal@kernel.org>
Date: Wed, 24 Jun 2026 17:18:47 +0200
In-Reply-To: <20260616145117.047717921@linuxfoundation.org>
References: <20260616145100.376842714@linuxfoundation.org>
	 <20260616145117.047717921@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-kr5dCzr0/TGAVnX8CVPo"
User-Agent: Evolution 3.56.2-9 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-kr5dCzr0/TGAVnX8CVPo
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2026-06-16 at 20:28 +0530, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: C=C3=A1ssio Gabriel <cassiogabrielcontato@gmail.com>
>=20
> [ Upstream commit e5c33cdc6f402eab8abd36ecf436b22c9d3a8aff ]
[...]

No objection, but this is missing from the 6.1 and 6.6 branches.

Ben.

--=20
Ben Hutchings
Anthony's Law of Force: Don't force it, get a larger hammer.

--=-kr5dCzr0/TGAVnX8CVPo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmo79VcACgkQ57/I7JWG
EQkkkxAAwk5QKrmHOOZglVf+vJ8rppNqHTB8UUqZN3CJgqy8Mo+ADS2scvOZSORM
VDGu31utJC3/xkQzTN2GM8WvVY1Y0q4HPuhnsM20ISHWRzWD80cJkfZ33S6kH6zJ
AwvcczY0Tn41OflN15IlNi8edkkO9nb0xfbDlJqEwO0VzOoagX9EKNS6IgxN8p02
YFXTmBB9NTTRBYh8nw31MziXJNkypR833EHkmQeg/pQwToDEq7JHlZPdfJUs2QM3
jju0EuIoID1syar54Hl18nDuzbUao7AiXzvYLU4kK+PoxxFHSa5kHE/zymGPGEPW
6wX3SDV7muITk35PqXcAvwSireRx2j+2+RIFyhBEzIj7Mz5PFCTZeYEmkE0r4vv7
PSAoCfkaSfpLpulbNPwm3cRkz+W1F8XFVALRigeBAAuwMsvj6g01yjzuwujAcKd6
gCNUnw88obBIaDwW/BJkzFd41CA8Mxh2nML2nCzFU0nHTgE7IsRE1Sj2e0xX6mY2
ZjZjx+YYRH2IBgJglCLTLLsG044umNi5gSO2skkLuM9MK9ZrlNVBbvA2aCzvBZPd
y8g1f07xf/8i0dogftlEKPt9WwqgZN3l4DIcPPSUJM9fcUjgSNSXER/oOquGb8u5
DFIh3M8aFigRz/hoeAJzFWisLC6hWKTpCjw1HVg0hArpMl9WcaM=
=GcsM
-----END PGP SIGNATURE-----

--=-kr5dCzr0/TGAVnX8CVPo--
