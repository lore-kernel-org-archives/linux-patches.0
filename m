Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F241F1D95A3
	for <patches@lists.linux.dev>; Thu,  1 May 2025 11:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746097797; cv=none; b=SvmJdu9aPrb7ac/tru2/GdcMm98LOzTfEgVABu0L75XnPmmCZ/fQN9rMC4hdhGXiSYHoAaPgPNVs4/+MlPAlGHkfT+Ksblfy1Tv269NGuqAO0hH7Hd5/5vwKEtSOV02wqFe86aFRpCFU+weR0t3vL2i3PH090qUhqfKgyAHY9XU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746097797; c=relaxed/simple;
	bh=J7kijETQ2asEm+lK4uKe63fSwqBXyFmQ3v5eEz8FXwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s2Ws+pi3pN6aReGJrUTc4BmOVHHyuI5YnnLbw3Rr8VSoQKbzbRnuar9uaZmmVyBe1FUyV39GsB+1wx6RUPVZXkG1SSxLoYXTrlrHnCThCnZtLkhthkPDIstRMBkNLsYuNZFjvK/fC/es5KA0Gnr9l52ooSRL0Pgcu/Qb+CDGVXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=NgwgoAeb; arc=none smtp.client-ip=217.72.192.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="NgwgoAeb"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1746097752; x=1746702552; i=christian@heusel.eu;
	bh=hAjMdzaURmZllwIbYvh5tG3QTpVTx7txDeFWtmQfcZc=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=NgwgoAebA2YjhmI0SoWNKR3mwRXQUulRCiP/7Vi+wjccSjir91okFM9g1/grtH5k
	 IUNx9LX67+BXtGq39JjR77LJ/XkduqQ9Q7W8pYyG0nap95aHn3OilNPUpqtGfJmWU
	 kSRcEevY6Tq2BQVOeNbs9bnr19BLHQ7Ok6NgpE3AGMWvh7AZg2Zib9FkfGd7xpnWo
	 dUXlDPWwUg/Jx1yhvTTg/81PNRBirZux9+4omiqkqr4vPNZEQ/AYd5Nunx2UQlLyY
	 IZ+Yd/1Vm3fjbYR1s/RnYsrESBeOobSRyYsoVvlsrzYnpKhQiN1E4SeHyd8Od9yjc
	 N38vt/rxw8ygNI1cMQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([94.31.75.247]) by mrelayeu.kundenserver.de
 (mreue108 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Ml6du-1uvvAC1kzs-00qZ9e; Thu, 01 May 2025 13:09:12 +0200
Date: Thu, 1 May 2025 13:09:10 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
Message-ID: <04f1b7d6-affb-46bf-bb94-020f013e431e@heusel.eu>
References: <20250429161121.011111832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="jxvcqh6kinmdq26q"
Content-Disposition: inline
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
X-Provags-ID: V03:K1:l0dFvFXonn9aZ0DS7ojFGSZhcRkTDiLEEVC608hIClhlzOcRBO5
 n14VgP2kq1f3qLBf8ZZbljUWOxbpFKWa8JLcl8+eKwOdHmUEiNFBK5s6r5EynRuibgCmQ+/
 7bjuGoMPCPScy35Uk0QhyRjHI/9VXwuEn8lCHeZ4ARgTXGdAgNnRCTzRWD8VhhwQKoUO3hD
 Ci0bv5O9ImP0RII4a1jTg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:cTAmAdvx+rc=;VV7aaFyFbXIaenHIdX5Q3O3huFK
 wBOl7MSiCkSPAYuyXnDo8nvr1PdjTvrzhmcauhMiNBtEqVyJlXHYKn40O4CkpOakXuguVNH3w
 887AwKYvqfdO2JZHZIyuDXUZMT9fcK5ijmq/DAuAfzaojeukYOk9e56QVlTTMweuIBECvPf2b
 bNqHRndWsbuNylWdN7MfalpuWlr6tThcy0UDsHaFKEF+6FS1zolLYqhfQEnAgewbDiY6Ccsys
 JBrYyudX+V5jqERmNwYJ1dTRWdx7yjmi5aZZL3ew1bB7WDUWsH7yHapRM0Hv9144d1NesFym1
 P3OaAQ8pdrMLP35mGCyibKxiEnPoDP8+587pxZRrDMZVx+wiJLocyQTgk7Q5ydieHrx0hHT7m
 WuK7iJQRA9RtoRYiywgreUAINn9QKufxF5YyWonNtxO+6iKfWqVT+3RVXahyLO3WbSLijJNni
 LW0P7GT3gFbH8uw301sI5jBBH9WWBWpE0StdAy8p8wipEcJcjybAsoM6bOkh4hGu4z67RVg8s
 +nQqp5N0eJjct3p9lw1V9m5IYzt3N7mggnGFA0oON7VOlLQW7iuXIf6J99shnPRT1/cNJlNkb
 zTQ6A0KsypHpRlM8587nLKsZrReLCUZ+826s8vLauCQWMFpP59xobQ+9SyN1TyohJkg5thO+2
 jpAIFQWGSOCMV+TlEXHEH2ddY8c9RJhcXNx5bNPzAL9G2pOGnevAxW31NJzIgXabZdQLCILkC
 WrDkAADxkzmJFwD9A34oD9zBEu/UB9UYuMRz5UdEBe+/6eel/XFfw4vwyQ7MxFpvYtUmpgVTq
 mB/x/JThSPFlEnv7tB0xw8eqKAT2aHd3J+/L/s2DiKM59WrPRCbbartSfYI/m7j2xaku1f8C+
 clMJ/bhSoK8t3YbLhJRy6enssRQahMOSq+a4AmX+U/IwLiTVIoZVULtbP8GrZCxTu30FCTdiw
 ZWOifvRbxWcgLKsccHePuSA1NGDNJkBz9kxwKeLHnm6yfBes1IE+NLgwvndCon+x9f1+ROvXA
 GF3U3zAOVhsqa3UOcQPTlZOEaRkYZpxPPmjKVqg6oqwi2NVE5qlayAnMJ3N8SGUMyLX5HiSM5
 R7+UwEmEAXUGfQPwB/LS1VwsZAQHHtJRBEKId/61Lzf/z+Lk6ylv45Fd61qDCFw1/OEVLrGas
 DeovyRrlXwqg/HC2eWCjUVfoGIFo7RCnHYd6jwf3y0UAPrX3zgckVOVFnq3SmLasvVeVOt9jD
 wplMp9p40jwc+iVuHE8DnWe1LkI29pb6IJSMji1RXHZTc38sz/D1W02DpOIHZD6D+4s5/cA7x
 4/mxwho+iMntQz01YRNVrQyLHCaRdRuBLwOSmwQltgiboMUpLzOBw+Z3LUzHVNdZTDMK8+wwQ
 iSqOgml5gOxuZMYWq8z/WjgAx1WfW+lqdRv2/+xsPoLKq3mBLRXC34UoN5roRDVP7W0Qlj1p/
 uNp5A+g==


--jxvcqh6kinmdq26q
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.14 000/311] 6.14.5-rc1 review
MIME-Version: 1.0

On 25/04/29 06:37PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.14.5 release.
> There are 311 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

--jxvcqh6kinmdq26q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmgTVlYACgkQwEfU8yi1
JYVMXxAA48Su0UkecFjj05X9O4K57WK4IjMqZFb24rPCaXwdG+51KfEKIl+TZalh
FiQk4sWL5LgF08f6pEoAMBRG4B7X0J81IUi5Ik86O5UvrrC1wN80/qn8/QTn0BS2
uD4VdPckhA8CZjo/I0VP5ZFK/tdKGJUeXGXvYB0GPO+B6IWqietuH0hfpGVbIPZr
aINLSX6AMb2vrrwA4/33QCt/dRcMy/46Egjr35js8v/dG3hROVsY31ufa51+BeBw
oFedreV0E9Qt7hXsgmOrchgaCvYM7UahTi6R+EITdjnSdb2nXUJLrBkBc2MTo66u
1R3u+eQIIRFLoJLbL/GO0ZUvfQ9BWwLMypTblJEK+w4efgAfki4hiQmDq/AldSyn
QIXDN12l9uAG9eYRiVwGiWTAoxNJCtOUsYQhzrKla9aNVuMin1WPklBMLE0Ac7mX
9ytcjQld5WsBMVbC5DjXhqlEwfNdK1xY/TltieTfWghnRGVrp15a7vy3AVRBlOvx
ztqDvRHkxiimgd1ZUv8kKMc6NbOYaukUzMPniISibSIs/fq5NZFFRDgjmQU+QALj
hSKMi6TplDqPoTGlI8SjC7+m4JqQU5uhRJeCW9ytnzLXjwP4ZaMX/bywFqOxF6Wi
WGJ+XR9w7gbXu2jZ0cQm5urU/ql637oKNYEAFnEKdWHKNMj5Svg=
=Heyc
-----END PGP SIGNATURE-----

--jxvcqh6kinmdq26q--
