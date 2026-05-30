Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC946238D52;
	Sat, 30 May 2026 18:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780167112; cv=none; b=fKTg8MLoVFWhg7pfsVcRPw/MMvK7DcPwIttN4nj2TDRP62tz6uIhjRgodbiLNFlkyLyeAkQ17gIoCCIQPlOr1joMZTYlNTqFIGarUqnhWgWWXLvki6mFSZzyjbjIT7ouQCO8/AJnEjDnSPFLSwN2W1l/bRYT4gkoDtaFGT8O6Zs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780167112; c=relaxed/simple;
	bh=N2rchIoT/K1mOXHHopOunsYkePQS+akHZbhMnp1Jvoc=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=jvHtHGs/mNg1DHp1LQbK9PU7uyQkBjI6XWtVplk1UB4rYkSrGVzXBGH6QqzZIypStOXX+GV1YRpQOO8m5bmODjtUwkLeTbHt6LN0/s1lE/Kd9w1fEH9I+tr2pNc/+bgfzgHc6Qh50nkvl/xqZ63WDV7qYfgC4YQGx2U9giTo/6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTOmc-000Jq8-0Q;
	Sat, 30 May 2026 18:51:42 +0000
Received: from ben by deadeye with local (Exim 4.99.2)
	(envelope-from <ben@decadent.org.uk>)
	id 1wTOma-0000000ExTl-3vQA;
	Sat, 30 May 2026 20:51:40 +0200
Message-ID: <daa0df3788560bd8759418d9c333e09c45368aa4.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 002/589] ASoC: SOF: topology: reject invalid vendor
 array size in token parser
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, =?ISO-8859-1?Q?C=E1ssio?= Gabriel	
 <cassiogabrielcontato@gmail.com>, Peter Ujfalusi	
 <peter.ujfalusi@linux.intel.com>, Mark Brown <broonie@kernel.org>, Sasha
 Levin	 <sashal@kernel.org>
Date: Sat, 30 May 2026 20:51:35 +0200
In-Reply-To: <20260530160224.642881938@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
	 <20260530160224.642881938@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-0ZyOMxjVi0hOzYtnadpg"
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


--=-0ZyOMxjVi0hOzYtnadpg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 2026-05-30 at 17:58 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: C=C3=A1ssio Gabriel <cassiogabrielcontato@gmail.com>
>=20
> [ Upstream commit 215e5fe75881a7e2425df04aeeed47a903d5cd5d ]
>=20
> sof_parse_token_sets() accepts array->size values that can be invalid
> for a vendor tuple array header. In particular, a zero size does not
> advance the parser state and can lead to non-progress parsing on
> malformed topology data.
>=20
> Validate array->size against the minimum header size and reject values
> smaller than sizeof(*array) before parsing. This preserves behavior for
> valid topologies and hardens malformed-input handling.
>=20
> Signed-off-by: C=C3=A1ssio Gabriel <cassiogabrielcontato@gmail.com>
> Acked-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
> Link: https://patch.msgid.link/20260319-sof-topology-array-size-fix-v1-1-=
f9191b16b1b7@gmail.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/soc/sof/topology.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/sound/soc/sof/topology.c b/sound/soc/sof/topology.c
> index e3aa9fa0f112f..b1682879253f6 100644
> --- a/sound/soc/sof/topology.c
> +++ b/sound/soc/sof/topology.c
> @@ -941,7 +941,7 @@ static int sof_parse_token_sets(struct snd_soc_compon=
ent *scomp,
>  		asize =3D le32_to_cpu(array->size);
> =20
>  		/* validate asize */
> -		if (asize < 0) { /* FIXME: A zero-size array makes no sense */
> +		if (asize < sizeof(*array)) {

asize is signed and this=C2=A0comparison coerces it to be unsigned.  So non=
-
negative values of asize that are too small will be correctly rejected
here, but negative values will now be accepted.

I think this creates a worse security problem than it solves.

Ben.

>  			dev_err(scomp->dev, "error: invalid array size 0x%x\n",
>  				asize);
>  			return -EINVAL;

--=20
Ben Hutchings
The Peter principle: In a hierarchy, every employee tends to rise to
their level of incompetence.

--=-0ZyOMxjVi0hOzYtnadpg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmobMbcACgkQ57/I7JWG
EQna9A/8Crm+0wLpzW6c7QRnqabvdmeLMsy6hU0XgplUQjlJN9jNX1Ai7sjwtrS1
goE+L/6GCuak+T5BDfGvFHkWp4f6W51InGZ3cs5RfxDNwpdYsjlrRhiRPkRSU8yT
YxqTG5tCTiP/UOzn5/JEsm16ZIbgGZRnRelt9CS0JufYDXvVavDMkfstcQEjKnKp
GJHnt5l40r8afeSj2g3AI7hq4kqpeIM+U4ng49AMxXbogQBlyzOwJ4y9G18qyJiq
j416J+XhrdB8s3PE+ObElfuZtfNDtxeZ4IkenIwlqf2hn8IwlfiNjm+Th0iTWfqc
4d/fKxiNWUPVMN87rcbmNIimm2zpjvxGxLbkbeGqvZtXa2DRWEM/OVBegK6eJ3/v
r6FnT3ByIRoO7voeByD8dji0oEKDqJYI5XbJwAIX7LlRo+BK4SMpMSjIKCkExgEM
qiYt8bJcde4RuapAeU/PNPq76P7+rXEpsoGh1Ftzs4TuJWenwhtsv77HJ9FH9o3l
Jz3K8QzYWPFwU3p/tr8Sf2yQjSMP8CZM3KEDy1Lr0I/PGL2NwLyYPanQS/9PVwlB
WmD5omoAnLKmjDFMpU7HO1RBXh5cHQNcwC3gOTvqyrjUXs7/kO9LDQQpHQqwH9xC
WCGsW2bSKBN8uZ+KhbpHD0C2eys26GrpIXOH48gPAV1AN+XXljk=
=7F1W
-----END PGP SIGNATURE-----

--=-0ZyOMxjVi0hOzYtnadpg--
