Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.10])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3147221DA1
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 14:47:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.10
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744123627; cv=none; b=ug2NDbCqA2ZTSUj3yQw80Su4M8YZ2eh9uDtJT1lP8gQmtFQ6O5KukFxLZJAj1D8b2mnxff8yhB1/0BIg3t81slyI8i4pmzRzHF5huIrZSJ0o3ufnBiW4LtiloV4C6oOepUnSzgcyOVWixPQf+lQZJAmYd5/2sKnLKsy0Geoqlw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744123627; c=relaxed/simple;
	bh=AwmtNo9ZDR4iJbtjVTwzSCOORqtteA+dQ8HAwoFoG+s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CbkO9+XxMeCfx/187WYYpVo4sM0Xw+m+DDUcISp8jAe0W3SFYeCmPPkc1JOGyGbaz+LNq3TYl2QtnuL6xZEcgX6JTlyZGKBbrny2xNkJrBAjNNfyunPguIuQsm8Cl/0NFtCtNyebCrOH8uv0ZgoHFxGfjz/BldjAPoWobVJ+s4g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=not6oD5z; arc=none smtp.client-ip=212.227.17.10
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="not6oD5z"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1744123580; x=1744728380; i=christian@heusel.eu;
	bh=4mloTaNWZSqWikJfKKnldkm5oPapFtMLnPOS9hgCK4c=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=not6oD5zXzmlYm67lkdO9f9So7s4kqurdy+AvLHG4yxE4Yr5fR8rBTgi2Pf5FFkn
	 NAv1aijVcGuhJuI6l5XgIqDtj9a61oS2tTl51OBsRDObLxxAa+W2eEjy1e47cX/NZ
	 nt9iC5fOFrzlPw/k/Pwxxr8ddelEaFSMnYdoHBl2aqxSBAH63zOoXwuEEl9JMQiL4
	 QMLhePw2y/ykNDXed0R/P2O4K6UNxgdzdxu566bVgARONVUAkN8RWg20dp2zGp1Q6
	 Ur5+3qqPG7UeMs/nIXzG4NTxe8ldPm4VHw4GBf0sco5/6k/x56YGFwZFJkLRSvJWq
	 jGDtrmPIVU3ARnHVLw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([89.244.90.49]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1M2fQ9-1u3Xeu3iEJ-00FwPy; Tue, 08 Apr 2025 16:46:20 +0200
Date: Tue, 8 Apr 2025 16:46:14 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Thorsten Leemhuis <linux@leemhuis.info>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, Miguel Ojeda <ojeda@kernel.org>, 
	Justin Forbes <jforbes@fedoraproject.org>, Alex Gaynor <alex.gaynor@gmail.com>
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
Message-ID: <5924f2d5-1004-4f7c-ac20-3cc7752e5452@heusel.eu>
References: <20250408104914.247897328@linuxfoundation.org>
 <c06b17f2-fc80-47a9-b108-8e53be3d4a76@leemhuis.info>
 <2025040857-disdain-reprocess-0891@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="sylc433es3domftc"
Content-Disposition: inline
In-Reply-To: <2025040857-disdain-reprocess-0891@gregkh>
X-Provags-ID: V03:K1:O9ZzllCwMeuBExIumftzPqDcuXpsm0JZTBYWOf/GnRohZT3ZU2y
 sFlmMoRwteKriSosALQE7GrQvno9SYln4dSigUENb0gt3AqTxnT0M4zPGd0QGMdyArzg/lZ
 0P01bjbhVXqWDvlFLZb+hGSk2IlGvZAJZ82gojC3BWY8F1fFGcEqV2bNpUU67TBPwKgf4d3
 QntJIKRaS7CcW4ulY0uRg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Zf57XI2APu8=;8Woq1/ezwQhAsqxJLKlaZwCaosV
 H5OL7pYcUmT5G2YXMy7ZDZ7RPJdAkyQhZ/AP+t0N4KIMDYnB9w9Lx6K9SdFEpfytXUUVtGtcf
 xC/PcoqKvez5YuiaS/uRUc5FppxWLzAw5aosESOv8cPT0ymzEm37i5TxrikvrFyW1ajjQCUaW
 RBl/kbIPB6T88ttWwpplXI1jYrshPSy53KlBzANRuF5R2Xek6PzweDCq6m/og7HGcVgiiYFR1
 d1KYPx2i7M2Z2IHpP9tbmWErRuZKtPEhcrewjdLnSfLF1yyNznGbCsY9nw1gkcgliA+lFXYJG
 REQSfzxTPWLQnfv2oS2Emx7w5WVJy+XtNI9kfWnm8NNIcMwa+zqH6AY/zGJHK1Mawi7mi2CB2
 B/gd28y2t0m8SdyCSafwUorJgCurjZipbTQqesJANiFrvD5P32tmumb6LklhVSjJOsN1kXpOz
 ob5r71x+igS2HN50YA40mFiHpL9n1NqcpVdVyALjqfsRfF1CfNydXUwN+aU9pCJ1sMwCLl4Ve
 oqErJXUVjah/eoaVkliTACzA5L8csia1vfHoDxYgvUOPLuqoddaASJWXDCG3ZJkAAsSATwgs7
 3+LXz0/+ZTlF5o9et3e0Orc9PlVu3nwy9Bo6kmJpq8bW9D7QJirNYMDMzsreA2b3/I51oowP4
 PPM2xvdu4fl3UK+EAMpXlUc2VJbdqCkY8t5Yy+UMbejEooKuhPTDcX3h5LSgDZ4PrumK2sIwB
 t/MIl4tVF4xW44qIKdy7UbsA3vbCqFDqEtN80eYdyXaifV5ve0gs0TCeFKC0ujRZcxadO93M6
 IXQzKxRUSIZg04BNRk0SpyAlKRwnYqgK06wG5zkHOPRGNyyv4IpS6GNqgjvOd+7X/EtUYi3U1
 rBAyB6MLo6Mnv9R02/Huv+S41vWDIDHKVCh3XIcE2Qtw3zpN4uk3YSxUR0QAYJN0p9A/DcT9W
 Fpc7yuvGYQilixqFJVdnzkE2qgVS4opUn57BwHXrC0thNWVy0gP8VTSfFnmKjm1bnZCmceydv
 4OvtRw1Q5q/PaAgQK280MZG4XMjen+59HrvVNn+ZurbRb0gYkUfzLQ9Kp9whu0sMNXj7DraWp
 YsvwyK3tkuU9JwSmihe5gbZZRHePgSBVyWHVKkr9vaFkRO6klkadRtVt+DIatLM+uSSu8LXlV
 uBtfeOZqIbhwp+kU+n2CNFzmypvDN3PM3490Y6v7vTgPLiTH3BN5GnQpi8JGvUXswFe/IKCUi
 S3k6HCSWKPVFCwwj+eaYWxg9xCvecfIFuy8zOxl0L0iy4sniKqgISmvh1D1DShOrRig+OziYG
 P7BZRUNOcdDcJ4pbAhopqH+9FU0h9P4Od+kOno1o3IZJzVM/WoTLZ0A8DbQQlwc3tz/grt2SI
 clIZAfyu208gyEPvDNr2PrchwbI7BpcHVOEzo=


--sylc433es3domftc
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
MIME-Version: 1.0

On 25/04/08 04:02PM, Greg Kroah-Hartman wrote:
> On Tue, Apr 08, 2025 at 03:16:31PM +0200, Thorsten Leemhuis wrote:
> > On 08.04.25 12:38, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 6.14.2 release.
> > > There are 731 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> >=20
> > Compiling for Fedora failed for me:
> >=20
> > """
> > Some errors have detailed explanations: E0405, E0412.
> > For more information about an error, try `rustc --explain E0405`.
> > make[2]: *** [rust/Makefile:482: rust/kernel.o] Error 1
> > make[1]: *** [/builddir/build/BUILD/kernel-6.14.2-build/kernel-6.14.2-r=
c1/linux-6.14.2-0.rc1.300.vanilla.fc42.x86_64/Makefile:1283: prepare] Error=
 2
> > make: *** [Makefile:259: __sub-make] Error 2
> > """
> >=20
> > >From a quick look there seem to be three changes in this set that touch
> > rust/kernel/pci.rs; if needed, I can take a closer look later or tomorr=
ow
> > what exactly is causing trouble (I just hope it's no new build requirem=
ent
> > missing on my side or something like that).
>=20
> Hm,  odd, I thought I was testing Rust builds on my build system but
> obviously not.  I'll go work on this later tonight...

Thanks for pointing this out, I was also missing the relevant
dependencies in my build system for the rust parts in the kernel to
actually be built .. IMO it could also hard-error when you specify
"CONFIG_HAVE_RUST=3Dy" and the tools are missing =F0=9F=A4=94

With the tools installed I can replicate the failure ..

> thanks,
> greg k-h

Cheers,
Chris

--sylc433es3domftc
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmf1NrYACgkQwEfU8yi1
JYXBvg//V3udBoUMLykkZ7PiDCKx7UmxHb9Reo5V3p/nOYBvewmmrT6nGr/qmqCk
/UcJJOotyzr37OhqLoiSX/VEGhDx3TrPMMy8xBGAaJJE1j5AkaxN8lHBPO7wzbzK
zysqLS2/AfFroy2l0qSvkM4nAUXrOy3Q16ki5SyzgGo3EL3zzh+E7RNpbWmOO9mv
+1gX0ohqiWZVX1Q7q7BO9t+NyUx8Tf8Fu1AJmbnzwK1bmmsSmIUTBw9zwUi5FezR
nEclbmpaAtEznN53Ra3m1N0GT6NGHD1JYT9Qsiz7bN2bNU8mYHDR+WyD5DBWwfwS
L+KoyGpG5LeFlCLCx2vFlVvc5Mf6T+GU0tfIt8BpNCbcAeaVOZp7O9i4vejyWCZI
115di7NKTKTpDIfNJyjJKtrup5rY6JTXoU/Wh3ky9yzb2lyVXnAC9iM+pXbIXKKN
ooHfPXwin3HxYYQwMlMTJyg5GyrsW0YmwDKwuqLRpbiH1OOG6L6uT15gUiMi1Rch
89cz6lY2PYODBzVIvEghEAOwm1qeu8APVdFQs9nxAY1i6yuRJRBcojomQRh3557o
jnmkWUbR6yZbv3kdI1pdpIBdJ9IiSg8IKst5MVSzGKPF8oKoVLz9vz7ihk0U+ame
Nsi3WTGuRcUco/uJ1OOIcW/SDLGZIl2CcXOwu86Tc4EYg3cDi3U=
=TLo/
-----END PGP SIGNATURE-----

--sylc433es3domftc--
