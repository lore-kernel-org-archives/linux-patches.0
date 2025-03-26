Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1358A15990C
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 19:22:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743016939; cv=none; b=ba7+6KHwCPTmqUmAHb51n1ofFT2eWTXxXpSQRoiNAB5NbsYcy+CZlQy9CNL0rfeuLQA885EnW+HcpxxBSNOHNOG0WS9OiODDL/0uWKoU79SZg9RvYBkTRpFHeodUJsySg/jOcf4Jrbx48aTLTnxYC2DMNGoTqHbhhsMnYCkT8eQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743016939; c=relaxed/simple;
	bh=qPuud6hQtUOpq0TI0kySy61SAsgR3IbvzwnPgGwUfOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Yud7xraq/cAZcm1uRS6R1b8lZVoX8iqJypUfVJooAbYsnD1xMY8+lkJjngxL3nBRddq8VczT/KgT88zHo2NnDYGbaEb4f3JFo4LwuspZQjSKzS4oczqxFFbIkCTiPXQA/MVfxgYDYed4Q8v4n3mz5wZxEidZ86JwV4eyj///upY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=Zl73Iin0; arc=none smtp.client-ip=212.227.17.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="Zl73Iin0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1743016897; x=1743621697; i=christian@heusel.eu;
	bh=cC0SZP7Q4aEIS3+NUzVkYwY2u4HQnTUh3X+v+jKFAgQ=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Zl73Iin0K0IxxM2Xlo9svp+FvXCYEN85cnRwlewg2Q0TnIe8vaUhTuEy0kXoSmA1
	 m/fMwU2KQcN+5YppCW7b5TNmai1g0geutu4Eg++cvwaWe/XfFX6iibaNSBOuldxkR
	 XdqAx6dt3hWSj1Wg5zZmN1WHzyWjPtr3DdVDvSUZEumrPRMFqi41chMqBlaoLOLHE
	 6tPav95ofVDxcuun7zidv6c0FmGarxqz9SvKVTbLjZkdjJy6b0B915o51NuXrhALx
	 XgKMhpqH0TKvvUmKxPG7ybXXnZhLelVq9YTffLoErA4XB9MDh58OoYfXOkuGzQ2iK
	 oeHtPAguf2AnmiulNA==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([80.187.64.202]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M8xsm-1u1M4k3Nqw-00Fyj0; Wed, 26 Mar 2025 20:21:36 +0100
Date: Wed, 26 Mar 2025 20:21:34 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
Message-ID: <f2b079f7-d666-48c1-bfc9-0155dcc9b4a5@heusel.eu>
References: <20250325122149.058346343@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="qrugcju3lf3vwyjc"
Content-Disposition: inline
In-Reply-To: <20250325122149.058346343@linuxfoundation.org>
X-Provags-ID: V03:K1:HpQe7Dut4b0aICmrtZlF2dG1x9jQ8/S/5haSr79leaLIkettg+9
 eI2bfciN7c2GW7ds+YwYouBbaS/4jGgagQSwKGuTCyBtF1+AwGxQDNW36oIlWDcA70uJwI9
 WFypvTi22lwsD9heSsYU01BRQfOE1e5MxVFrSwSK4hh0RbJCQIiMIuWt6t/SalEWdLOq56O
 Q5+3RdYZI+4VOvPuRNRXA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:EGKEhPFiGko=;RRet6CSESIMGwEb12f+fi//k6l5
 xZvPKeu7/QT7z3NZ76dpmnZMTi0W1t64DAvbQEFH/2+b6hC8ALqu6h3pe4hFGl/YV4OpaWM4z
 HvmRJBPZtlZI7PHUp33Rux/0Yk/xUH7/E2weaD67iDBQcqPMfZM1GMrBOE9YQKQY+TuQ7/LcJ
 dZHJ0s/ggUjnTRtb7XTN8nPGS9fOTQapSzzfZR5JQSTWf0RdDVPeeAGoNNI/YLupoUW67WZjL
 XGduAWw+NfeDBDnS/xNo1ocAxs77LBitUyytM758mbD4EM11OSm/csVKmw91mtJpRwnKskvEn
 bQJjZzhFBTqEN4SzWAeCKAQoa7hSwjepygY80VHQTX5xg1+XgZpQDCJlXElvTEfrxxmJ1As0Y
 0YUk9PNOMQNypg4QGI4Rf7q/+NaXD1smgqglxVBtg8CM1HPTSAn1rWrkk8C92hV2huMwzCsRO
 PSwo/46dk0Ph2x3S2AZQCdcgu6v8mBUdjzq7ZE+lm0yfck6fVqIqUOyZuPsyJ1Cj/39JUXH5O
 O5chaGND9lzadhAT/hApwsb/rlQbUs/JJTN02Au2C4R5fv6FJnmnGp8ZzXaSafwZfGiRFGMnA
 XpfZQb5CK8c+cB9SgQjosCKKic691Ip1ce8mqKJ2enx7ndFIVD3eRUSepTck8Lb714mMkYV/6
 A6zymZ2G4CdlbBm1GltaqkDA/Ucud5Vncu4Qkk9MGnKEzvHmeQpijVZsi8DgybhyQ+mncVp9r
 X7faKRMUvKnM46uxjnIQieW+cUXIRnaqsNEDi1Fz1YMvguFiQJmtTlGagj5W5qVuYIsHj2/v5
 RAXZdwkzWveKW+gax1ZNZoNx1EF0+a3W2RwOgSWo0aFmsETE4ytOpWHaLdtKj2QD7MkmlXre+
 nljI3567BY157ydmU5o+8S16/fVS9KVIS0knrhkHHa/zyftETn47wpeEAbygNvN4TBDabiYoo
 0b5RucnOeYx9uvJMixHDrGtpI6d3KCTMwQGIVD1aRXc8dNWzb89XeEMhCGE3F3csrq5Arf5v9
 mh+5DOktmyrB2SvuFasRPYm7bKFcrTPtmC/K4q6xBYiUQOX0Dyy9vbA1/rvWK+Q3h/jfnq98D
 OUMpP3tJgid79JTmGkEfsAOyXDvBmDmnr2zf03QFsKcOgHFboRVhN1LTuBde2DzvOl5rp6Ol/
 pZPrHy5F96+0aOhD7lAw1nhfjtAtTtFFeSmVRwaUggoA8b3kKsdlijpJu0ItV0Sky4uyzckFm
 zlvpv56jM8jnYAJZxnhUNV7wSA/W0UTKQ5mO8R24DgGnMQ1Ej6qnR9mo/uFfYDONLOHjdRAwz
 tKngS3vN4JtCXWLBjl7/r9J07x/Taj68DScZW4ynf1fUGVBX35tOFqVtRL2AhGWZyE06jcCC7
 qm8xtgtjcWIplpHM9zNl8hWj1yEqnnbuOS8IA=


--qrugcju3lf3vwyjc
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.13 000/119] 6.13.9-rc1 review
MIME-Version: 1.0

On 25/03/25 08:20AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.9 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 27 Mar 2025 12:21:27 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant) aswell as a Framework Desktop.

--qrugcju3lf3vwyjc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmfkU74ACgkQwEfU8yi1
JYXu9g//R27iUOFq4JnHuIVIxt0JYN/uwQZwLB+hUTkCU00fal/OOKai9pRfG1HM
mZRj2nC+e5spYiQ4104WsLP1ZvwRqPTNZ6nzzGTW65F3ejZADNoJbBUA1C2yr9r0
R7nwQ3Cz0Vfi15JeSHnj5rSo2+OPf1hV6U6uJgk+7cF/vKiVkBw3VIWqEyPO5o1W
/zBQCTrmnIp8ksqWaR1wevSYuaC781d64RCaBHyfoRw/wuKdw/qCwmFut6knqx49
Rlr+5NSjz3eeWlK77zD5KBMTIzBdJLhlmylZn2IJoPx5lSPpIxVRfZdbXBodECSB
iRBaDqnQ83Kw9+U3sRae1zRwTHcDYAygSw9R3Ghjrbl9oLQ8Plc91RdMv5qsGGe8
4Ne+hdybWh9HvT2eeU0JP8UF1q24JqaDzQzJYWx0QSgItnG3Hrt9gv3AoyHzvCJg
sWvz3VSNnQ5HeYfjs7dppozgGFuGVpbitqIS4TPnIrm+jpGyOqt/LGM8FG1p3qKL
cqyFnv/LStdhtUrSFNLeeKlkHseIcgMzLmOHQ4LSog+TCMTR1PPghjc4G6Bu5/06
9HigW7KXcc4aQiQamKhR7HXlFTWHXmFytjCrZm6k78c/MyapvBqiAt4F3/3bEkC/
29Aimt0mPaFiNSKx6nmYE06urulqztt7J638Ja8h17WioT/uB4k=
=Fnl+
-----END PGP SIGNATURE-----

--qrugcju3lf3vwyjc--
