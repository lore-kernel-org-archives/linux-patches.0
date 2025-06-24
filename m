Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 249953D3B8
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 22:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750803667; cv=none; b=KfqGwSDKXMg5+vVCjka2HPPkbPQtV7m7oJ/9A4P6A6a4d5zgl2VjlDBAEMgjOdN74nQNGf//WzGtN2rp7uX4CF7RY21sE962DEmqHCWh9c8pvsO1O/PoZmLgyxOgfLJN0WVbGJgyGXCDHd7VGtBg9M94vUYv7+bcHogF/kDMr/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750803667; c=relaxed/simple;
	bh=1eED4mBxxa41vGVxedCAPzdxMNfIB9r1fcfLhnFfTog=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=QXQ4RiGnCRkoxK90JJAfd/1BbfJCDi1+sUnQst0oUSct0A6DWZc96gavflcvRV1saN2LYlJy4vh5Ebm0Lcv7BOIrV0xuBYTj04dC+VKFMQW3T6jUAnSenJ1pNHg3NENBLlS9xADJDe/owFDSH8bPQgEPH6VCatQiIHKKZjDTR4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=CN8RGuvV; arc=none smtp.client-ip=212.227.126.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="CN8RGuvV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1750803640; x=1751408440; i=christian@heusel.eu;
	bh=k84MJ9mlpMMXjFPHzH7zdej7Q7ifP2HIEnnm12B0cgg=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CN8RGuvVk1qoQksacGCZdiygCMvPtnSrOWazotUoS53Z+yacT+MlZgUY7a7J3dnx
	 A+retIrSzzHRY6ipllloLXuXLytkH35UIb6YtYlJ2LMY/13T2PbSjD7r7UrHx81PL
	 E4vbStpE0XlY7vLjXfd0W/Lt6Nyse9YEQZFM4wl/xakNdQmRkrIzqUehoUmTe5cW8
	 MI1hIHh/NeJMWi5mKa5mFogDxmHfC6JwW0CH01EWZ83HoSbzTCVBdwSFqImTqkybm
	 JXeEH+ZRCVSbSBYWSXONbCyEBbgKV0I1bkvVlUaZdSP91aq1UVp5qlzhdd6CneMOy
	 rfy7gaj9KVJlGf+nAw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([89.244.90.39]) by mrelayeu.kundenserver.de
 (mreue011 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1MkYLW-1vAeHu0hzy-00nH2w; Wed, 25 Jun 2025 00:20:40 +0200
Date: Wed, 25 Jun 2025 00:20:36 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
Message-ID: <77c62de0-8236-46b9-a94a-8bc68873cffd@heusel.eu>
References: <20250624121449.136416081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nturzagk3ts5ndbq"
Content-Disposition: inline
In-Reply-To: <20250624121449.136416081@linuxfoundation.org>
X-Provags-ID: V03:K1:UTT0E38s87OzCdAygoU8p56GP4oApCv4yiNnw4v3qWs7Ly8eVk/
 lQzZATJn9BN9GRpbXUi/VJMjUnfiMIGlvoNyzsskp+FpU8GsOmLz9doN7T/VpkNuUnQBG3B
 tpbs+OYWR+MsV9br8o55StL4svvGDUEOtFUGCGiyWBaJRJ+dAw6P8A1DmBNRzwgFAX6dzWp
 ktWh2P2VwUk2iAnfSLaFw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:5dTZMWQJLNY=;5iMDF9ApPX6ivJZFK23ezMfOpIu
 BAMnUwHedQxNvTv79ZxIOg/j4rlGgUP7+4IApnOewNwwI+RcUK2mtOdE0V9euG1aJK4qxIm5G
 ydPzhqyQd/ZGfh1I3dtr7zkRUqJ/z8HRp3c3XBQWEZfGEQDva5tQVd979rd+rkvcDVLTQ5ZTq
 tZVTxcZANPcNvMITpTtL+H5MbQK0xPm6Khz/r/wJZuC6iNqayS32VxaZe8iUE7o7WrzP2iFLm
 H3vrYj5m8mXmAU7la0XvhAj3/qeYQZTPOcopTQuigTqnfI2hsuUbk4VHJb24wQtfIscswZagC
 ku2+KiwuHbUScXU6ql4O+a3aKllVJbnUX93X9W1k7i6bjGgaSsLOw77tF6Oa6OqWnjrENJzMU
 5AasTjMU+KRTigfSfRcNnpWh2lnRFv9L+YxNzKjCItFZkr8oKsWdtziylRZnMGwPz66A1y2tT
 LPveusclmddIHKGfOCkr7XfYCMfY2uoYIfbJV706o5iiv7/lXrnKyU6eCwfp56uRI1YA/MdWi
 PXYowFDj/PE6MnJZMBPBKdjVCCzTnozF0Jx+dmkNlH/0u7LItTCeyHZspZ36+27DCJiPi1OBy
 ZRjUcMU0wAa4/hz9Uc7O5URWMRWQDFghAla5LScmLe9QLgjb6KQ39rTcNl+lpUsjDMWzAOMa6
 Ugtn6wAsGcVNY71QxCBMR7NqUlvuabVgfH7kiBUGDwU/z0mPY9uWKAKy82wPNFwa9POAXynIK
 0kMoyaD0X08LWSFDI1SzpRv/XWJZtCTfT123uVFRyvH3hA5+ec0BwW5WcAS90quJ25T2aTi5a
 ZRzRww8hHEBXJzDx4qkAMo0vX4NTPzdl7za8MixLrUbHKbz58n2Lz+RwOZUH8RZXBr9GGdgIl
 LrV1IWkvWfqqok2TdX9tzfZtzYngZJUOSDs4T3MNbfFy+CsT5JS+iVgkQhtEPK20x+XHEK8wt
 tUHdZGAQntwe/UAAUderCt6ahCR9fHMXxX8NVZCWoOfZSsHMc7bOwL9DhfgfyBMvvzi73FqUc
 cAO8X3UNRUCbf/nx47/clenchrDscfbMPN6LVz7E+JJGmvwEgAuHuOUPrOaTmTj8bS/4TR3HK
 d9BUbwKPofSIstfVCBottxp8b8+ADFk7RwIu5GOVhdm7LPfzekMLSFp2OEznGBWKzK+wyP/eO
 wjwSzZgSC3NZFmpggGDWVF0zfq1NNQ7tHibQls9kVlKrp4TU7jGiEHSrCMF/jd77KXzg8jnlr
 ugmPiFJmIszcLaz0zoviINDpE7bpp+NZmbVVdnKU+FxpJjz7+V224hYEPkyzWqmvWPaKFd8Nl
 AaDzvwCDIPOgmX7Phxsl+YDheX0n6Ut9Wzz7L85+8EKrzj3eL8Y/PiVxcpmNZqXPNeXofJIpf
 UKFgh7R6N2X0cQDsmux/jTq+zh+UN4iv6o1etVraKT3fh06+coJIPUe+sZ


--nturzagk3ts5ndbq
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.15 000/588] 6.15.4-rc2 review
MIME-Version: 1.0

On 25/06/24 01:30PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 588 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

--nturzagk3ts5ndbq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmhbJLQACgkQwEfU8yi1
JYUW4xAAy3RZvpiOmTLoN9GNNxzlO8mUorLkvDo/9nQlrTQKVyScD8fDVTolEOnf
SddZR2ozuGN0uPsjp2j/yuQW9qR7ftwMrAQftBmvID3huSqfxMjEq9ukZxACd5bu
ElhniZZmWguGH2JtuVHwIWtnzwyNqMgX3b7zRqMuyQcSwn+GZ09569AZ494Y+IDj
cA83UmeASPS9dbZmS51QxU396GbwaGzYqonDes96hYZR8jd4tTCJmCcdS3d9JGBV
O1OQxTqpW1H1zJODhIGWN2ImVOLYjKSKX/HpZ0nPnausAb+Q12yFbocQ86zG4DeU
ZeKHeGEPJtJAsJP+BFR9CUGkwMgxlzAsewG/5DJUaGuH8yQQlHQmzGsRkzdD4/cr
8AStrVPozU/peVHMovwy/4I0q9OwQzEU50d9LsR16qu3bGcaIIiRtg6iKOid9ygA
Hm0qhACamtp4vck9duk1YjvlWngbbJmizywZOZUlxhQ715t3XcS7b+T9fic+XanO
WoSypOtLK7eyu4RnRYGXg9JrIFEBbp1cX6SxqWjaEnwMMATFfZNgUERfX5DzTN+S
rrR2zbMQnjDZuJcm1P8C+YkzE6z33gqdRW5Ls/qHTSzdddjqj2E8Q/WY9a7RHkDu
oKMLqTdRfyk2rF3vRCoEkUscyvN8Lq9BCI3UtFOG46u51kpkJm4=
=aWbh
-----END PGP SIGNATURE-----

--nturzagk3ts5ndbq--
