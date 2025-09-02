Received: from smtp.gentoo.org (woodpecker.gentoo.org [140.211.166.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62EB11E5B71
	for <patches@lists.linux.dev>; Tue,  2 Sep 2025 13:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=140.211.166.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756821182; cv=none; b=rP9tJrymhoEsRw0tP4ZaHnBIzkXoGUGk4Rs78a3OmIZ9TmaVZSp7fTsUXb05Nl4SKqulRBrIIAihRcXQ5aHegD+SNGBfE7Ii1khudu5U56vNYZAoXgAt5S93GuEZCt3Va4j68kr/R2uTFkM5fUHwXgW3jjneyqz1qrcJeuJVlo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756821182; c=relaxed/simple;
	bh=TmbUyGXmCtBs2QYbWJvf4ECFr2Sm2e2acpoCZjjZRaw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=UsX9t6XReTEhA3uLQ0TKUd5i2m088eRbBVWb2WkHLtMYHy23iZHoLS5zbHq38WOxEfbDtqaCCHTX+/EUu1H03i1hN9mGVoBsHM7onEqgVj9B24XVQ06U963Uw++e90hd1qU+c09pvZ+UgXgkkRXprH4FsUhIDHaa6/wEs485ans=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org; spf=pass smtp.mailfrom=gentoo.org; arc=none smtp.client-ip=140.211.166.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gentoo.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gentoo.org
Received: from [192.168.0.1] (c144-154.icpnet.pl [85.221.144.154])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange secp256r1 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: mgorny)
	by smtp.gentoo.org (Postfix) with ESMTPSA id 6E3C6340AA7;
	Tue, 02 Sep 2025 13:52:59 +0000 (UTC)
Message-ID: <97d648ff7cea3aecd6c2606ea60edf928e1cf1aa.camel@gentoo.org>
Subject: Re: [PATCH 5.10 33/34] ASoC: Intel: sof_da7219_mx98360a: fail to
 initialize soundcard
From: =?UTF-8?Q?Micha=C5=82_G=C3=B3rny?= <mgorny@gentoo.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Brent Lu <brent.lu@intel.com>, Pierre-Louis
 Bossart <pierre-louis.bossart@linux.intel.com>, Mark Brown
 <broonie@kernel.org>
Date: Tue, 02 Sep 2025 15:52:55 +0200
In-Reply-To: <20250902131927.927344847@linuxfoundation.org>
References: <20250902131926.607219059@linuxfoundation.org>
	 <20250902131927.927344847@linuxfoundation.org>
Organization: Gentoo
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-ZkGD/xl1XHHxMnJlFvVh"
User-Agent: Evolution 3.56.2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0


--=-ZkGD/xl1XHHxMnJlFvVh
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2025-09-02 at 15:21 +0200, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20

I think the prerequisite patch is missing (4/5 in my set):

https://lore.kernel.org/stable/20250901141117.96236-4-mgorny@gentoo.org/T/#=
u

--=20
Best regards,
Micha=C5=82 G=C3=B3rny

--=-ZkGD/xl1XHHxMnJlFvVh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQFGBAABCgAwFiEEx2qEUJQJjSjMiybFY5ra4jKeJA4FAmi29rcSHG1nb3JueUBn
ZW50b28ub3JnAAoJEGOa2uIyniQO1DAH/AxJgzLbhRfeChezccqEBPGh/yg5MS/n
RLb1Ogi8L92+d7E6u5qQs34iw/ey8aAe7OoBggAQ8slTns8mNHnUc8EagTHa1guY
z07Qv0aIHGfiqFLn/gQmE70vR99uMz3Y5MiYG1G6Vpv8tnzozWnmoioO47cv+d7y
nOzCC3zk6g72jow/HIYoctu+wiZHbIb4yrz4AEvcAOJImDAH7KDtldi6fz7jsbUj
DX7+8AigL9aZcaY/TGuZr1gCYOPwuxBfxQntYdSbJ1sTFyUFnPx2l3Egi35BNFbC
oKeUieyW7BJvt05aW2lkFQVlhFcQl2l63CzyBCxhBG9iZFDVYQuMY/w=
=wHb8
-----END PGP SIGNATURE-----

--=-ZkGD/xl1XHHxMnJlFvVh--
