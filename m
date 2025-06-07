Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35DC71E2853
	for <patches@lists.linux.dev>; Sat,  7 Jun 2025 11:49:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749296947; cv=none; b=SZRKoNuAhIuZRHzy8zctLdcvA8U6rtj4kp85notLKCbpcoY/UpNz76jNB1b+cNJvBfjcCOXltRs4uCWSA0dUsc5OnScAd3Eg/d7RhLlp5XCKaAndfz3o+w/QAIK++Ol+js9QYs24OowgSaweNPGH6WTxlPdACfYs/p8YiApIpDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749296947; c=relaxed/simple;
	bh=A5VFj1e+xpbR6SHxeq2NDLvtJFEJtEFEkt742n8/blA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kPiAObO+RdIdpK6/jb+YHBn9eZCL86QwusUPz90igDCVBG76vdl3EhKzyFR8X55g6OL5OR7dqrC/nKRzUsfoxdr4Rg6XOF6T4u0SNQhz3V/BqPZmbvyiySV44t7bp90JUOw8nZt0b0Je714UI2MP7zQwECAGKnAq70wC37BkC5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=CiU/PbOx; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="CiU/PbOx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1749296937; x=1749901737; i=christian@heusel.eu;
	bh=gIYlZ50mxQXGvz6F133XjL9sWrBBVbI6DqKQT9SVqnQ=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=CiU/PbOxTUN/iFI6io5lYxf1WmID+fY6M8HnU37RPgyYObIH/r4xYXoSxxPSb8P3
	 cRp4nkHVn8MOefCIOCRYcITnER8Tbg7OmXRrL17u5Ld9ZkrXF6TXvoxCPehxzmSTw
	 Vb469nJf5UI+7lNkZ7xpu2niOL4OUxRPnYRMpNBmXXfjvN+EiRYhfcqs11O6ozcbr
	 WWupidWVWiFhc2rWLFAwKPtOfEwvtepoEgFY43SxbgfFXBPKfdyb7BE3+S3S5Vx8k
	 1j9IVa6p1ObrwcYI57HjFk7SIGajcs/75YUwQvZzDGpEcmkFJVaLBiktzQ6g0168I
	 2O4b3WrxDex/blluOg==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([89.244.90.37]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1McGxG-1uyJ9j41yW-00hj8d; Sat, 07 Jun 2025 13:42:36 +0200
Date: Sat, 7 Jun 2025 13:42:32 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
Message-ID: <d8e69fb7-fd1f-46b4-8031-13ab23ed8226@heusel.eu>
References: <20250607100719.711372213@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="jj753swazz7l7vzc"
Content-Disposition: inline
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
X-Provags-ID: V03:K1:yI7xnS0BEN970P6M2FWovJNt5Pig2NzeKXfDXnoS3GKC7ItLPaX
 QJfvdk8lbsrZAJ0mb4ZKFT7G0F2fDkBuwSKl8aTO8pO3UIkC+X9PkKbTanHZT6QrEi0P+TM
 u5e/ccnbxAjHRHP4IKXlc4ORbNQaq69yTDHvfZYZikwuvUH71r5eat5virwC2fzgFBOZY/X
 ixH276Q4UfU6ROFWPW5Lg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:CHu/Idb2VaQ=;8nIHJxZQIeDPP2DLA+dxd+PDv8L
 vXlcw9V6+D2x9q2Xu9DDG1nmqyUUoRRQXb7SROVVYIzSw2latzg0nHVBS87BgSQzNevg92dxb
 2mvT4ZEY4K5tSMAy59ZRbpqCWFt6gauMYiZ4Cwf593qQsVgQrLqX8UDxRqerIlZyJNqn7LLMG
 F8YPlEeNvdlI5TebV1rQQ3Uy2GC7JT0iZEQ5Lx9tThWMMz9hrFnJ8er98lJXgYRUYLZkGwrqc
 eulLeAAZUUdI0QUWAB35yv6LIIbiqRYetvkIIQTP2lutU7F5dy3l/ZmjTYquFcrqfjAscJLtz
 tj4txmBzYWdJZ/HsUekB8lvrKiQF62FZDraPWqu0ZhAIUwtLOUSFuWhUhJpsGvkH1TnwtNxku
 GBay+0Lg4WnPmxRYdFKcEkVuDx3I80YgGVZ+GcS8YhIHLelz69YFgjznFxbtzl7E/3cuqHEi/
 lmgGOl1XbhY0Oxq6bIagsXm3Ru2wcxexza80PR6pGgDnpxlaTCIJ71OY0lCe1cha5ZlVL9Zuo
 7WDXntVj0cXRNYO0b0AfQ+J88S8TauDCbzJNYa+RjE+CbBOx9yVpVj0RU1Ju6FnWuaFDS8Ib0
 EM9SmOnNL1MfkW0muL4HXVVmlsdc11WoOEQwEzd9G5QWTn9xmi1ueNVLtmxZfTnCg+XRTBZBN
 LFNdKIWnp/4BpNbTs09Lot/r4oN2Pv91Rx06C2qeNYeWpqIt3EAPbJidephg14HcvRiHc5acw
 yGlNt/HZWet4f9vhwhjle4GlYbR5WYDY4mZZaVZuRoiX5oN9eledRR2dZ/rfg6H34+kKhLVx9
 6ToZIrtiPyZNoqxsEl/16UoV1F9jgWDtcGdNGyW8Y5OTO5wBr+xeufqV40y9bzwuyDLm/eGYL
 lxynOX0YufVmVMG8F3ez1bGo3N0FO8bimdSOBlH9JQ3gamVNqbwSulRzOjxuJIbSa1syt8uGW
 bStOqsZxitbgx4m9P+5nVUnCyi1/DlaauwcH9i8tI3gkCAlltwRi0Ddc6Emk+4d95cBK59TKv
 uvmcxMsBhvNYkcuUOUKQnENa7S+wQcilI0kxfEgxosmy4q35FCVOh1Dqh/7p1a1mBjWBv05cI
 g44RvhvC2Fq3wairc7NAaTZKs8mZd2mDZCEErlplJldSvuYTeiKdAz9CkF3obNfKAi5QGOPoG
 pqpdr0iYLpDPrB+C+v/2+/TrUF+4yQWuLADSw6+UiQOdsQKBP20LRcXWjtwOU9MVbxeeBDBOW
 JAjNkjeOTV4IYgoMWMzwPwoLneEODF5hGfbaRiVmYU6l6jjCg5gK2Q9LKSLgEmmjYS7uEXTbg
 tbwXqhA+kPu0uBge056uU3dtBFY7gxXbI72Fit2rOrvA1NKl1zGf7ISRac3NPk+9/GwxFRTmN
 CeTdoWeenZDcbBt7hIESOOZ9H8aZSRT9PeXgZNAX7oCeEGupGgQhs4bqmTnp9cE1mvCG54oXf
 fLjZ7FQ==


--jj753swazz7l7vzc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
MIME-Version: 1.0

On 25/06/07 12:07PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

--jj753swazz7l7vzc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmhEJagACgkQwEfU8yi1
JYVRIhAA0CHQq5ZUUCu6jIrBj6sVfnhYzkuiFjknop83PudJOunnfoxJOE2sw/Yj
LbbFLGSaaKp1v2ZHLVL2pQ+rZgUeE4oUPmk4PUGuopir+PTpQkucmCuj/kvt4oiv
JS0/wU5I20MAQ0/5BWto7MJPcaaLv+b8DJTyiQviGK6HGm9E+mEHaal/z9ID1ush
ksFcjHzx52dbF/CZdM+tPy/9BAtNfxUWHb72KHbpnibJN+711thoLXWi6LMEQRyt
QJB57RglQj4mTLouffN3TVS1DW9dNE8LHswpwv0RodBuAKv9vmA4TrK8zusw2fvg
YDKvOPm9Lfwm6RaX8IzzxlLcbzmw87D1PepPFzPOI7Gta206KwU9Geak7Y3bm4RR
UgTVPhkAX+ufeHPRyDrw+XwzG3SgxUnhg12G7BR+Q90ZWdM081/7jZvc8KJxXrAS
+vKto2PlUCUoDxtM8KhkD6fkEVwNaLWY2Y69G1MK6weDn/m1VXoJTIX2kgHxtE/K
Prec1aIOqh1Cm7AGv4vdcyCvAJn3viHRmHCCskS5vSLDqdWZFnhTmFeqFMGKZcdQ
rp154zC6sTu7hhnLzrIVUxmZrWw9tOtx1X+r9IIcxtkO4jbzjVIBiXBHKL0kMlgp
IWWtC5lo4Jb3nqjSfzpSeH0Ulel3AUoYXnHz2jdtz1LYKH4D/OM=
=ubGG
-----END PGP SIGNATURE-----

--jj753swazz7l7vzc--
