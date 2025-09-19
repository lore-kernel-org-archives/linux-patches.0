Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 809181B87C0
	for <patches@lists.linux.dev>; Fri, 19 Sep 2025 11:12:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758280362; cv=none; b=TuxhgDp5mX9D9GNRNywcuP6M+gvtEm4CA7P01VTdV7S5zCj7nN0rihBjtWg6RsGLLBLFk1ROgueM4TUsvGVK+tToA1IiqBRJJKrhiuwgpwx4mbdk8vXXJ2UHWGVxM9zybQw8l1vYFYzDAKTb4k5NufvSPTR8gXO7RLiNavq6MEY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758280362; c=relaxed/simple;
	bh=pafYvqVlCfEqCJSsMEMvjxwX3zW2nds5SuS2t75SE84=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=slv12/vP65YWUmyzdOxaaYNIYYbVZGPCkbXte0l+3ULCfDmtAN0IpuKiqwPhJiM3r4QBhDG9wwgquMca5K6MHmuIeLEMZ7YMT5jviuTxjB7/4Shpys+a12IjtacoFT9QWCW6Vy3LK99yOUGcSBqirFLpmq9JKCveDPaiy2tfmv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=VrfaAPde; arc=none smtp.client-ip=217.72.192.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="VrfaAPde"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1758280322; x=1758885122; i=christian@heusel.eu;
	bh=NmY7tGL7hQWgxTyAFWu6qYyoysLYJEMm14YjuSWpKOw=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=VrfaAPdeTIZ2g8uGPkWYq02odfQLKH93qHcy+kOchesh1HjWxLetKA0r6oseLb8K
	 e9YD2zK7Wv/goltlyBlyLSPs6e+XrLisqv3WlvRFw8Laqid4S/WTUmoYE0wynWYSX
	 EjFMqxK/n6YKs2pbKGg0G46ji22QbX0Eocj/jQMMVzrYaaBeRmtutRWb4WW4pgfOa
	 SC+g+ChjkWPp7E5bcPCR4FvhVRMbvjxWgpyEbJWmORK1pIEPIzlqmZKTH6u/pY1PW
	 wTqCNY1BJTixNC7Wgm3yQ0ar1klIUQLgB14ca6D9cRU4WVFbJFf4To5Ll5PQSOUf9
	 MNfOx+6i7OcP9Err7g==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([94.31.75.247]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M9W78-1v2qpB11PA-00H5Gx; Fri, 19 Sep 2025 13:12:02 +0200
Date: Fri, 19 Sep 2025 13:11:59 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
Message-ID: <5df3745f-5e2c-4a54-ba2c-5b52f5bd61ef@heusel.eu>
References: <20250917123351.839989757@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fekihvo4oufv72u2"
Content-Disposition: inline
In-Reply-To: <20250917123351.839989757@linuxfoundation.org>
X-Provags-ID: V03:K1:egLBHGBO8osJymiBrNOe9DAAlH9TKDZJBD5iyAAGsCSXcgzsJ+U
 V4nCd2Mwh6himHtTGUMw9k4nrGTRscaJWS7vtbd2uJTt6znRQ9jBg8UTscfBSZvZzIjZUHc
 rXiPmoYlQ6zjrGE4SwvrPlvprEZLr4La/trvwOOnBRXLg97gbXXZ5ZYFPn/7C/doyEF6nV+
 BrG/n3eDfzx+59BZnQFGQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ZJ0Jx5TjjN8=;XTcf5G4OuEEH3gwFnPgE3Ue+Yvy
 NRlfBVaJc2XMFDEInyyR4OH41QwpudDpLwUFvUcTldO06LIMfd33O4w96sbRnWrgDcURutdqm
 5mc+VEJfSm22TNixEugem+U3rZOcAMVwHMukexm55eIbhaURL9LvaOm6gum53+5PurDDoVHs8
 Im4/4auSsec3C9ovA1MpVw4bkmV46Kb6eLubqf9HAINHr6cbWefgU2TqhZum0bkC7DyG75jxt
 H5v6Cz2VOoB0GY4W7C2JwsQBm/VXR58jybXV8key21AE/uhzVEA+bSbogXSrFvkJVP3kVrBam
 ehafOBACtrWkFTbm29cFnGcLAPBAyIfuevCmWUcpR+s9rPCx/MQ+zX3WGpD5NsjobEaBEkuqH
 EmUEgyM69bx5p2sUyZQg9B5kOHhBkyw0ejyzJG7ZUpenoCkFuwhxEnjkt8Jdni0l3hgQLK8PZ
 8i/E1L/ucc0Ocj/PK7JP07mEOrGdGtRlGeMJNmWHMXEhUUpxWrk1ePvZKkealPzi+yYb2eqRa
 LNv2/mHBgl2F2mXE/HgPBkbh+sKSIReZmaXxXpuae7UrEuwYEV+QY2bmPHoFJ8LYTHdWqgKdv
 gGuq14HltUdOkTKlB54KQBQcdqkDMnrH7GUenKTu3JIurShKf5AQgWfos326aZeGDdMcWT9MY
 5Lt96TEaYd9ELA5zjGJ6m63aFcpha9DgQzg8xemqlYOZ7DJZQ7+o8ffzE9MpS4KLih5nSOSHj
 887HAcixFTNJrV7RtIeSa5VuRNYlImfw6IzNGy+uQeQu/GSw30S6X/glIF1St23uUvIXgrbiX
 JcCj8rC41WqqrAbLgJS5bY5ilsaurdsY3Bg3MvnSfvsuAG1spcqc9F07OEhZnfuoyuLxS2wL6
 HLAKS1o2L2aP/IokBsyXvldNEGVbN5q2f6ekc6jueB39gU+JrQIdhEtYIFVa83Megib0EHDOL
 DnN6DEbAFy0Cp2An7XmStIQ/5pdadlSMHbrlOOxS3uAEyyqcd8pH0/ZIAKqnYpzuBcu2wLW8v
 Pp3NhSrsmQECffHUtDq/TQXENJX33VpfyVgXCEDBdihxapWLOK64BkzTKofhwFBzDIApHGt5f
 9KiCUq5S++Af2XDklHDrBk93ItF3QNQRXYCfkMglKY21HXbkUD6+PyGg2IYpqqEDDXa+xUrhv
 e327dZU+KRGZ+ZrGPGnGcI6vWu2r5JLRhmNjCk9gQwjbsUHLFy53rfSEHtJmU7gjSyckQUOUz
 S2wcRM5X/UMjp/9j9IQOEhQsqWV+4I3h/3tKLuuIf02nXjLIYd8D7KCBqtuhjTWLp3/XReKW4
 2973GdK0llgXRkBnU7qJtcqhF5eLb/aZIJg+v0yaVrr1nD1dos47T47GSXVMOivXqwFUSQqfl
 FFLkOGGQl6TiDjg7lJGfCFWLAYyPiDs8tDwGtw+9Jce/TRJx3fcCklCkULa5FSjxi3hd9UJ70
 9mv9yJQAMHV858zjis70eDrtzSRU7SUwCDjw5FlAWVn4S4ySUJa56Wo7aZc61JLW5QSBhjmlM
 oCPWdrU2AaDSQUAkIxksYqj9laAdVhCZDdKynPtlNAsHB3GbwRW7vWsAKSwQaQCx6uscgegdv
 8eC5mGo/jYwkjSyP6gu6xdWwNwYyJD2muz3vBTf8gAOCLI0WutdceUHNFuXn20lSr6VFoaLUU
 nJpNLVpV2VJaFDj8B/2v/fI4l/sZKhDxU3r7GAeMEQeEbKHv9uRDaQRUDlRkFfrMbDiLRfQ90
 aXVsuOwCCqHsB


--fekihvo4oufv72u2
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.16 000/189] 6.16.8-rc1 review
MIME-Version: 1.0

On 25/09/17 02:31PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.8 release.
> There are 189 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 19 Sep 2025 12:32:53 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on the following hardware:

* a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU
* a Framework Laptop with a Ryzen AI 5 340
* a Framework Desktop
* a Steam Deck (LCD Edition)

--fekihvo4oufv72u2
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmjNOn8ACgkQwEfU8yi1
JYUv9BAA0JCJCkpSWQVyl75uCgL/e3DemtMcAVNYHc0FJEbB/DHyRaX1O+RsYk5n
cL/2KCvkAPRz6PRgc6h6CieKFDOZceTtIPj/ObLk848gyGCa7BRib5xURHWDueLX
dw5b7FX5jqhV9utDOoHBkvM8R/jsrN1I0fub2aaBZf+kzLxbZIDGvakGgdQdKD0n
76q7MNX/lsuczLFGPjm97Nw3I3lwbgh34y4xAg5a2TxRazWcDxuJVHCSgVL1a7Zv
N2kgnl1ssomWPXcm7phruuBIPHZ4I+aUIbYo6wdRjKpFJkLXBBvRRdEVoVACetUV
aOCnl5HGjvicnDkh1vPJjsw3UKGZ/JvWFRqV7gD5AOMaYt1NCbHqeVuvFVp8UFp6
WMvIDdDT/EzF/0pZlczA3tqjbwP61OY2/KYOTEALdVJzZY7VoL/YyfbK6UM3M/66
n0yEQZ30ELrG6hrewU3+gyhR+2pd7qbNVKKdNx+jew+MHaAWxPJZU2nDU8j8leqR
9PrBOXbZXxmdkrIchWQaVfjh5b5FYmc0zrOYVMPX9JKNDxl5te3hSFiKqjeZHO7X
gQxP/roZ7nXCuGsJFJavlTBO1Dn+X5MFi7i+uS4BF7qp4BHevLWtmqpv1cyVQinU
qZIw0LOKqL6h0XrrYHGWcywRsdCUigaxHAf5P56uYZwc+gwoFCc=
=z5te
-----END PGP SIGNATURE-----

--fekihvo4oufv72u2--
