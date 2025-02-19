Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F872195FE8
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 10:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739961957; cv=none; b=TQJac8jt0tjYfBGqLPp0lbo7ORo/y04E09Q9Z3l/D0q8zmY85NeCkO0xtHoUCeAvwCOtn0LzQ8DWpk+KtfWc5EWe1mY+cSJIBy++Iz7kIWaEF+BMEtkpURSzrFnlDEbGj9QxNHt510TEii41WPE03IJCFVfPdF9yh+eqPeTkGD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739961957; c=relaxed/simple;
	bh=TogrUvQlt1gaFgztsa1pyw9ZegJKiY/hNcKknZYEB5E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SSo1x9PwdHV5rIcIGd26r8kVrxPCsiqJzA5Ws7XpsV43d/vw3SvzjL4a0g3cWBs7AzKtlUBZ9/rfw+yNvTci6T1DtUAYeSoH2FxjoKlkIeFbBfptjaX5vvuY0Cysfln1E/xP4phOzG3fsgYMbXasfYMNY3clwHENld+AAY9JYic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=jUgpPsRm; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="jUgpPsRm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1739961938; x=1740566738; i=christian@heusel.eu;
	bh=4JOeNT3gI6trmavC+IfWbMMGMy68iPsdhleeSXnsKlM=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=jUgpPsRmxnfDaSHYahSkOHAd9tKfOyc7LIqo+2RnGzvABLsWwUtiGLCRBD28Lvg8
	 6Sn98yBKVO5uXzzv/gu0ol49M5PoXlcpMktSPr/t1to8kjZXM3J4Ko2kpy2O0qCmB
	 PGxUikKl31hDbbLL+aNykAQK+RZNzqWVI1CTZH9qvrVdWE5zKH1utk8O37PUZN5K9
	 DzHW9HVkHoURRBmAZKIjWhFwEDX9R5QDm9nXf75Enyf3crbQfP0J/+0Z8uPdylerf
	 87LeQJR8NOy2HRRMjoEOLFlSZlSbNy+nquhcWoNt1h5kJcw9urbO5m+laoPtKx6BQ
	 pOGCpbC7uIUWha1IfA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue107
 [212.227.15.183]) with ESMTPSA (Nemesis) id 1MV5KC-1tsywW2oZq-00WBlI; Wed, 19
 Feb 2025 11:39:22 +0100
Date: Wed, 19 Feb 2025 11:39:20 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/274] 6.13.4-rc1 review
Message-ID: <e73566d8-6d1c-4e05-b806-734759dfc237@heusel.eu>
References: <20250219082609.533585153@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="gwd2hpvmfcpie2yu"
Content-Disposition: inline
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
X-Provags-ID: V03:K1:R3Z4jbSbRTwGXImYxYf+EkgwnYixT4CB3AhkHmm8KDUBaTmZjTv
 euJ0Px39g3pEgRjZf1tQtPdLYCSMJ2xStid7IQKEvtVLXesWNvoSFP0zF0LWYcUYARhTKL8
 g6GyPC5vv30wV3w9tClKsCtBjji5IhtHmDi+Hb3C9QA+nceIm7SrlyqQz94L3GKMUzdInVB
 uTv/59QA8d4e3O9TwVtLg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:bIsSdq08MLc=;JHU21rhvI8Q4tv57T34sW2xabUr
 EWmgIQKRv1Jb7JPkwNGpOGpPCYwj8HMlkv5xOTfgWRNtmymL7WU2VRd5yvl6LY836KsLc7O/I
 eIg3B/w8hjGc1L+9yl38wkF7lXtZp9vx7JHkjbADFBsySfUfT+NXB3dZi/F3Q4FI1EiwYyB7t
 F1tSpSNXgvKt84lFbRvlf5dKPoHSwGPpTvFjKv2XPExwY8ihnFKGxlL2bkteD9o45xGP3vx7a
 HT8ns7VBU6jAuTqczpdSpUAVKcVjiTRKK6KX8vJkEkD1ikT9M6db+OLo9AwVciJIOKmzWMqPK
 Kvn50qqjQlcv0i78LSiGH0f0Na1TIQoMltZWI4LWerLXQ8l25QJGc3DDy69jyTMLu5VL59C+i
 1hRp6WuZAus5ZLl9vukAnZAn2qEmOBUejhXsYMMTth7bFWckdt7Pj6JGgtr6xviy9llg1a7Pr
 7/efhS3XKdVn6dc4ZC9k9Z/V6ZIOVbztLFy6MJjeBeSKRJHxMcMK6XR9G1mkm4GD1bOWp01Sc
 BUC9grvNyqIALVSKQ/IxquEKysABaGKG/2qosk13h8zERiyOT4MQM7dF4bE7WLeCODIsBh/bI
 TW52SRQZw8MFfWRTx0Qyh5brAfHXh4bTZFocpsRrXwefPNGmMhahdrBFKeTNbPbcrES9+TRpb
 0q392ZvtQRE04Q/rJlYO87UkOaTZgTl1mMhJxIYrGFa5kDUteDkf244wEGPPNN2NkcIH8VCU9
 no1hVCjLb6tbGmksMcCDFmGhjNYL5/qsijlNWlXLcxd/VTL+DMakAespfJmDWb0gonEVw4bzi
 zbif2brnKwin5OWqb+G1JFEb74Sk5ZZ/XJ4GrxOOPQL/sWsRE8PmVVg/1R6ope6LB1j98gVcr
 8yLTWi7xlVd7htiu5oOR/rA6TpXiXebdrT+HEeOJ5b50kLVreI/m4ELaCdh+Nb4FxkbcxTlwC
 gkpgkWm4sL+v+V7JDAv5Zg2Gyoeg7UfNnHjap6fvzsA6VsRV55YZFXOnrC5nBevikTQJZ67dc
 RwAEawJUapHX0jceeDW1yBJxY6nuOSFGqZGzm2/ePkzQ/0SXuUqPHxbYhID5uvygkQb8QhxeF
 XRKhS13gz5rK4jW9Xo96SlzBlXIA9KB2qSsdUkW3IiKr5zMpMLIy+ejufim/MeCm5VSK+3EhF
 KiG5PNp7k0DvoduXdbcLp7syaSpn0M3gq1nywfFa19v9w+jNw/s+yMwvYVzguSBMstHJV7fRF
 IpgL8k/0OepauXqwoBODUpxdBqKg4xAGe2UWrl+feNCCtsucxw0mpSiPVY6KtygRFTNtKDad7
 JPiiOoH1wWLAp2B4r/b3BGFeA3mSPVhTHgoLGKEDwAnHWQoj6KH4r6n8Y80LAvJBo9VfvNnGS
 bANSnMIWOzaOqAoA==


--gwd2hpvmfcpie2yu
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.13 000/274] 6.13.4-rc1 review
MIME-Version: 1.0

On 25/02/19 09:24AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.4 release.
> There are 274 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
>=20

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant)

--gwd2hpvmfcpie2yu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAme1tNgACgkQwEfU8yi1
JYU29Q/8DboiQjHpTqR3Xs5SQmsoSMXdn2sMGfnphyksbYSmzm3hMKg1n+fDR2z+
7umDKTVtPVxZVBFUjT57KpM9swnjT/JXA7NLcYW0rJXJ9Dc/Crv0U34VQhACg3Wx
iobUxDun9j3E5ecgFreYiCQ8uAzkuMjzlMZ7lodqosQw3etaFb06hVjKDfxPWx5q
xFPsrBV9sEFpIp0Oc93nC7xA6J/z5Ysjg/Xf/g4XjE1rIDflEO9hfFL39iCkSpTX
xxIGbrNqLcpKbPTNyExMqzeDThqEflXIYDQRb1J5mb1C3I7DK1mFbf0263UbaWK0
X0mfPW0m++msg1RWw+sIVgeZyH6nVjMytBAzbKFn/A+88f4upVs2qMRKFrbjyDDj
P9x8w7JodhF0RYSSbCa11XP85ICnyesuCMqWwK+h2psw4/1oFNXasaQwwcQULT1Q
ZGgLoGiDmtIDISULd1U36tkJwKr8v4ItAYfSZOI/bDBG3WRA4YS1Sb89h3X850u2
Cb5Z5DuDkwF/TD0Mu748Bg1s37W6MjxcOKo4rPbkzwqx4wg6+RaXTc3+e2guofEF
yAYCKUiO8W3FbibTEPbIhjJwWzSET4nZkwvuskKmtPqRc55tcLmCbahcqNLvy1uo
pH8G5WH1qtqWeO0VHwcNeE8EN8u/4vUYYrnXTMWDmC5usrENAsk=
=TDb8
-----END PGP SIGNATURE-----

--gwd2hpvmfcpie2yu--
