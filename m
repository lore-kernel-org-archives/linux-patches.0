Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61441CD3F;
	Thu, 21 Nov 2024 14:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.126.135
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732198147; cv=none; b=qknsUFj6u25qogOjbcIcDzoqioh1Pt3y1hRM0CQNH7cMCFnQXgokY5dEzAdn4vhQDDp71TLIcMPC0edI3kcaKynxFionMLzw8uHMq0iRGYY9l9Eh7i9pBU8tPaoiJYIRVhbAvBedSlbZ0vA6+UdLjitZRll00A/Gwy8UmPBjVJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732198147; c=relaxed/simple;
	bh=g1rwzESXivDkv7cCFGj4dT0bWSWh+LNVXIJ81A9nmcU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PPtkK9zOVpQi4arqKx/Ed2A7gUkxkvRGnCSS2kbFFb+lI5vll/LNKvtonut+QTdiaMnpMf9zDL1mfjVtxNrMNhbhKbRlV0lqedwQdzRqCavVF/qbH2oDuxS2YkXDnzxUCguwLtpt+ezZmcL+zjttyvIqHGICyuBzP/ecwL8H/m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=cW2UUk8U; arc=none smtp.client-ip=212.227.126.135
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="cW2UUk8U"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1732198091; x=1732802891; i=christian@heusel.eu;
	bh=uBEcrrM2FNBINt3gRIVBxDSXWMqMDQ3vGFG2CCfV/DY=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=cW2UUk8U9HJn2imUhgUr0yBmTUxAE6gpjyEZg1c4pHFUpqhgBvVf/+eseIGUP8Ef
	 CY3gHAi7RoqXe2gP/E9BsEW5yO4OleJvp+OnuxSKDuyGRUlsfonrgJz0QYHO58HxU
	 mv+348ZoIoyxidCQYkGJjpp4SFu+goCnHlYZZKF6BfH//hNZuLZuRzHZVNzyLL6+U
	 +F+bjVfc+JZZBzopqM4ikmvSToBHUp8BTCxZakcAda7KYCaDyDYxE/vRYacWZ6POC
	 URjRqIvthVMX7Ms4k31c1PBILw9kza3PZlWzA2ceWCVq7H2RNUmFUY7zF9peQ4aGr
	 KnurUZtEIJp+K5GgZQ==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([141.70.80.5]) by mrelayeu.kundenserver.de (mreue012
 [212.227.15.167]) with ESMTPSA (Nemesis) id 1MNfgZ-1tOLFA0JP1-00Sjye; Thu, 21
 Nov 2024 15:08:11 +0100
Date: Thu, 21 Nov 2024 15:08:08 +0100
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.12 0/3] 6.12.1-rc1 review
Message-ID: <cd96588e-ee42-48cd-bb68-b7e7fd7c6f15@heusel.eu>
References: <20241120124100.444648273@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="lkaeemx33m2gftfe"
Content-Disposition: inline
In-Reply-To: <20241120124100.444648273@linuxfoundation.org>
X-Provags-ID: V03:K1:yLQo9LvKV8jI/sXtRg454Qe92i8uZWbeEabu45DSTb5T5MvjSKz
 6VvRn5iTNvgWPu2gnVcEpWAIcJAOa0CI4g2jV/hhRsWsfIeMYnXdU1tahXO27kZEUFN6/lI
 gj1+E8YsM1y8MgXjRwrR5Jj/rredmZtssergOIOYdUFIoAMKNupYQi3EvSAQz70GPWc/Auo
 uOLLWo8tDqHjjetUZdnRQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3IoPf8XdMdU=;XsN1V10/ovgE16+Dd48m4KwyykI
 hrW9ZwzOGCVlCxDKltk/8tIlaMS8p5hBwXweiI6XIr9644IWovyBPy7vtOwJMWtFTo/CK1xV2
 y4jhQ5cw5KTAOu5bkac6KdzGVM861lrIcnKbWzhMJ3XAo3ZNbK4k5xEEQ1VnuJyMQa/9WWnUS
 AXMAKnToKxe6vZ/PJf4tY7eLLycOGEVJ/TNxPj1tnWmHZBZgy9VuO7D2wcmSq1fwazOD8Hepw
 UQ9WAr8keNCqttJNlVpoLXSJOcWe/TbdljBeMV/pj/Uun+4jLB2BMknjkNHmymUhV8PbaT6j1
 s24xa7oudcs85JT/h9zaVIqj5wxXt64FCXmh7RQ1GSZtk8d4Gqf150MsHBaHdTQV7mMPIjovG
 aVtnBdSkD1csmT4EaWkIHQ2FEFpsKzCw45kTJyhUNNvyJYiiCA3O+uH2pdniRYlmu5j1F5Ws1
 930j8Zz4/iMy7IVSVCyiaNANtbI1Dw65Ff3asMPbG8KgjZazsqxxcy9DKBTXamL0IE0bWBc0W
 cmnqlNMWqSsfL8Dk/ADvGzWb/u9cVA3uXaENHFrGP+kRPMsZCC/fn+UiG0N743Kj55v1XnypL
 PUlSprk+wxpYYcfCYYp0WuA2pPXHMQRF1628M6Nt8M3tXiV5z/EfEDdj6TZh6sMnpuHY53MB5
 z0J0dSTtkxI47bOm1FVTGvWq12LcL49U++HmsXcXjYpz1ijJaqqoMNBBBPEI3aw4eyfTQazJv
 pxLwGJMhUF8Q99a4hEaULzppOjAJ9HL7HFpGAHoM11TxBJzxl10QnqhIjUv+UHt8l7Ve+LvgV
 n2Hb8Rj9g4wjGUFrYWwlIIsy9IZXjNCfB3CkV/55pCMowjTk4D4uoPKmpr3yNe74Uu


--lkaeemx33m2gftfe
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.12 0/3] 6.12.1-rc1 review
MIME-Version: 1.0

On 24/11/20 01:55PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.1 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Fri, 22 Nov 2024 12:40:53 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU and on the
Steam Deck (LCD variant)=20

--lkaeemx33m2gftfe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmc/PsgACgkQwEfU8yi1
JYULOQ/+KI8jCz3zHVYYj6ee5T9ZA6+PsHLu/iWqtlLg6PX9jt+dbfPyicLmoGT/
lBtve513WsnGwbecXpCjBqjXfWSfH2EqLfsKaL86RWcJmhPzkHw1CG/PEyI046px
HFrEMFgn7o1+GWie+vyWlFvlv/M1ODCxAgww8Wq765AqALdJcfF+HyZueqQ6777e
MjztluqEoeczT8yVQkfv16xWOaQUl7UzJZhMmozx0KXGuONRo2cpvPwOKcWLd82y
7CdHDpZ/nVfV5mNwzzHDlK80Bp5F7J13WFxd8p3RB9bT0cRM6t6ju+1S9Rh8X74R
ZloktyMnYivcRZhDsmZiUNm5OuL+MIx/AskP08ZolapPiqhAfGEKz4Gaw6uT/s/n
rQOF0tOlv/ZodrXydFRJeEoi8jqy6B0I2PUO7NDeYrBWBT42PKo2lbtYgw3Wz7XT
m2j7hkRJIli4Ay0/V+q6cTXIydGUxngroHfOf2SLkCWlCXOzPNl/z2oYn5UYT3Zq
DZnAQz7f4WNAIk1D8JUU+UVRMnEDPDE2RRQoscH5X+ePoiutKdj7Ajx9PvljQ1lL
Kcj91vuggu1jpuO9HpasoiDN79Q427T0pd+3qFTfwW8ofm4BUVvOVvtzNU08sUDB
b3DuY4fZdBJqjNDYqEHeEWvGQwhXpcp0XwdmVKROxc3qNho1llk=
=sBNF
-----END PGP SIGNATURE-----

--lkaeemx33m2gftfe--
