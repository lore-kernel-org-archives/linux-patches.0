Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEA57142E9D;
	Wed, 11 Sep 2024 12:23:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726057414; cv=none; b=SVFEHQU4gOj8w6ORyghvOFsj9vrpsQiblS943jHsjtwQJzGVZEsAm24KmYxKDowa1Ys3WpPOmyMNqoAPScWTwBMiH0j4ul1F+U0cp0ZNWJpd1+jQcmQKaaMNqGs2g1DbteHV+AWG7z1oj5Xj1sl6TdhUNj+FmI9xm3D3WBlrunA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726057414; c=relaxed/simple;
	bh=DqLXaji5lH2QLr1w3bBVF9EeaBQoVRIIV8XgFCrhhSU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sYoV0jWbxCTkm9qrsBY9keWUu4P2+pYBPOw/p0FJHaos/OIF9CTQH/8xxzVf0zVncfACQk/8xFIXLv4+lsWlDZFBpDYJiUAZMw20Xla23cLdEo4VdOdYJ3AWykYVZJZryt34sJQvfmY9jylg2vuzhqEov5B4Rzx9rqpXSwnoMnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=SzJcLeoD; arc=none smtp.client-ip=217.72.192.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="SzJcLeoD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1726057373; x=1726662173; i=christian@heusel.eu;
	bh=RbCZJv4mBL/FdxnaNMh7aE8UT2XZ+9DcRN+xckpQNFA=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=SzJcLeoDouLb30yUDu1WGSZQZ2qUMLw7dwbpnk3BoisqnIUfsoKkkXXh1Aq2Sqe+
	 huWQBCv8SJSDUvZbiqzCx46S5uPyfgfZjEXSmh8Jcu+uUOuB+PQREHh21SHff23L9
	 hPPt2JTD5K7oHd/+FClidkm8P04MhAGihenIgHtWFcf3P+g50V7HjruLJEBa6i50s
	 d7bN+0e+g//hJCfFoxAkqn071AqoH0WfUrUpaPenhzqiNE5oY2MiBY1SlRPTg2AsZ
	 tCamF6hFu094X+yaLPW5KcdBTyeTJuwmf62h1X0SwUtegLTbidtqxm4zI7VcvnCCR
	 ub9cDVZYWJWpq1ctXw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue109
 [212.227.15.183]) with ESMTPSA (Nemesis) id 1N63NW-1rvKyb2gDw-016eUN; Wed, 11
 Sep 2024 14:22:53 +0200
Date: Wed, 11 Sep 2024 14:22:51 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.10 000/375] 6.10.10-rc1 review
Message-ID: <3b946649-8204-487f-a173-968288701eb5@heusel.eu>
References: <20240910092622.245959861@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="xj3xznqvjwvwf5ri"
Content-Disposition: inline
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
X-Provags-ID: V03:K1:pwWXrMZdMBs8R7+3b19VMLK4MTTYGRQ6OAp/y/uiyC4MP6CRHJK
 M9HgXC6fSe1G1Z26g9QSf5ovz/K/eRIsX4cmzg69dbkYO9lcC6YSQf0GBb8JcV4mQsMca58
 A/jeEmgPk/Y0et+Xg8BA/8hVXqJ6yF17oYdCkilzF//Ia9yqp9+ZqhTk8LT8V8Z09wvwPzl
 EhwljWsxlcW8tZO0UOlog==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:qdiBTps56VA=;WwdF3rOZGzIVencPwdm+ae/8St3
 rQx4D0SZsv0M6hBYUi+pD/7QFCFgZAVCLLl6HECcJHmAuetXdVR1qKeS+z4Wrl44P2BqiHDbE
 ibCkxR8xI/cAXQYi8FXWE0r3+1OTrm3zfdO1b21VtD7S/uodoRPcQPfRp1S26Y9VWpb+FFw0T
 F3TUmGtuu8Bd2zbRcTeKA3N9F705dMOWVL7Mdt6s+kMyxM9YXvdDz9eEr3Nwqdndw4+t+gfxR
 KTJOHhYxAGLg4H0q+gnrRzp12Ly7wF8n8GjiHLrkLRXHt0EW9jVKIQsQ1X4k8Ea/BrtARrHaG
 VGYBoD32F9/44GtodwmdlgA7q3s0+tIlBitSeWx+j2/kaMRxOANqwDWmBRAgRCqUUjiEb+r+3
 XjXsFu01uFjR0+NJQuwNDTP5gHrN0JWGgoLYa1u0EINLk5R0PfTbkmktazMwAwM/X/m/+RGRc
 5PN82i8i4XnkVbXBpdBgfhqEJ2yhos9kmTqlRMz9pg2p3nWXIH4WeAC2FR+U8B8QTejc6nmoA
 6YI3U9gc6IsH1C5eGPf7uxtkaDQ+V9/4KgFu5vNyVCdPV3G0lzT0TuwWhbFUW0UPcyn0J/16k
 Ka1+lfHXDSTTgOORiEPT31P0gXoV25XowLwJGX61c834wkYSB5X+j9r7wBV/r8BSkMUiAhFBA
 er0dG192fL6f0T3HGv8vC4X9/zwC7OnVyYMP79ShKpTRm5EPInsr8+0zA4NZ9YAtNMRy559v5
 O3mxSzBTqlPrqnvyXrSfwocpDowX3hxoQ==


--xj3xznqvjwvwf5ri
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 24/09/10 11:26AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.10 release.
> There are 375 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD varian).

--xj3xznqvjwvwf5ri
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmbhi5sACgkQwEfU8yi1
JYXI8Q//W/7liD0ogMri/rAvtFFbKCn7QDvcrh4woZm6IbHnQjnhixVbn2uenOGg
DAqMpAy2VTI6nTOhELAHsnm68V0gwHbGUXqq8Z8+spYJOq55SmhFqlcEVGwQXs/o
WROGpfGsltMVILxk2cNlTC3zAWIvf6IcHI1XSih1AVJxXXlZHM5HNVJcwghXt5jg
h9CSksSOB21jWVlbFvRGzPGC0byaA4f9187D3GLy85XUTNB3TroQGcwatrhaPPBD
S+GBIYsqtnvgOH9KEm7xrY/nQWLXgFuzq5GS7S+i7br0QwOuw337PUCKSi24TwE/
Evin9Fj0vgRsvFnCBTc6D4wGUZA6QnZpRhSkAEuqWIFc6XBqtn3KG8pQhgXJvYVu
Tyh4rdZnoy3xnrzqZT4vtNcuVlr4Hva9QnwPUAOhO3JXah/JitD8HXVwrH4DxGii
w8tkdLI5tUV1GuiiFn4bdgEXNtKHjwiyt4i3rvNLfOtTBnlQbyMkKwd2yHrCzfMs
JNQc5FAk+pVKhUnOeSybY0BkD9ebSeb5fKfK9Mxd9SLGT1TbnbfqyyxAZGMCy1Vu
iBHyOCfBAihNVGrrReyUP9qdU5FYmE6UCfsJlzWyCrJQkBaI+fkMyDaji6ALKUk+
zWCIUZNmgzF8cMSCkhVDyY7KN30+2yunhJsqQHDPPA6EPqMt/88=
=rjMj
-----END PGP SIGNATURE-----

--xj3xznqvjwvwf5ri--
