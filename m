Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 720AD171CD
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 16:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756313188; cv=none; b=kHJvOqECvGj18/pV1Hpja2UHR3b6vNWLd1nLGSOiEkOQkM+9X/C3LzM0yREgWQXqjzpsQcXBo0imOyRQowoIyOkomKPqKe7NkJ1oGrf5tzAeu5BfeOqTNjADlv5k0mn/MYtNSv+V3D5/kIztkkCGPhzeQP6QUzKO1Na7ec680NA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756313188; c=relaxed/simple;
	bh=3CJtJ5vFXngowMKB7Bdgd6eKQKDaN0DObWec9lgfDkk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TyrLbe+PbAut3ItcnQfaRyy0a+ikYHZswMLVZNYFRD8wYnczigo6SXNpWFjC1YnHUinlpb3zIy2L1CrUK3DAE3e/JrDdeOHOo/Y0c8lsgJlQpwDfIr7N6VyXdcdqOKa7FKwneVxsJzOwAKxuVdYhzxPYwNqETcmBv83IeDhCX+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=O4gEaM7f; arc=none smtp.client-ip=217.72.192.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="O4gEaM7f"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1756313143; x=1756917943; i=christian@heusel.eu;
	bh=4BgvfIWpq1zAjrUiinTpJPpwIdUp6H5Arkv0i8oX8Sw=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=O4gEaM7f1L9ILH+GYRCFXH8rUHGd+tcuaW0w2wnWaar0hbb4LNtuPF2frm146c5z
	 9K+79ur5Z9VSXpH8W84Y+1S1HJz20O478J6OyZ/FCky7lhsaI8/VsgIDtL7EMKniZ
	 Zip5ldFrOmwDFftGIHS88jy1JgUEq5Ch3P9i5QuEPx0f+ngDcXW9S+cR1al8xvEYi
	 nfqJansNlr8fDvkkEH96+61M5peNfkRM1vXxOphv+LBDOTCcsKSejrD6bJUl+ir6s
	 9T/n8APXYVew1GtSDIBMYKDsoyPxCQV4id2LtmQk2e/o1xvIv/GNz//Lo8LML0jkd
	 63rtAjd9jb3+8QX45w==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([94.31.75.247]) by mrelayeu.kundenserver.de
 (mreue106 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N1gWU-1uOtQN1H2m-00vn2N; Wed, 27 Aug 2025 18:45:43 +0200
Date: Wed, 27 Aug 2025 18:45:41 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
Message-ID: <f51c8113-d240-472a-9231-81deaaf95e54@heusel.eu>
References: <20250826110937.289866482@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="nbtzd3b2lmwkf4dz"
Content-Disposition: inline
In-Reply-To: <20250826110937.289866482@linuxfoundation.org>
X-Provags-ID: V03:K1:0C3SdLhtqc3V/gIlldVy2ea9maxR/9RwiMUFRqJrB3uMF9g0vam
 ijbpq/1+3eANieFhnV2mTunH5VmSHCKp68DdfDJ/HfqHJa/Mh9vXvQMXdoPHRLPBKiLCmqB
 f1Ct6zB8j+FPg9uQNS6Qn256sFswHWBQdsVfU557MXWrIavG0upziNxpp1Ps9xYI107Inld
 n4xjN/SLfeOyIP3uJY9DQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Z1JRZlBqtA8=;yKBa/PEC7BHIW1dIrO02j/yfG03
 eNA2R0VuKOyycIfLeFhIZuMDHBLeK/wGRIFJgZ4NF4YSPHey54rTLZZsLD0Kqg0H4S109lTy6
 UPG+tBUGOYq8Y7i3eA/Dfmft8zHEWqUIkxKeAaWCkyNuKMkFpHqaAig5LM9xAvqe0tUL6QKIx
 qN7mmyNYY0C1mrf0r5jgP4N0Ym/z8jt8mkvpDD1ffFDyxGMaIx1j9Vhp61M0jpQtmQPWoYr+P
 8hN956Ybt0Ppxxu1CUp6utm48IQAdljGV8y8iLfrgOAJQ6ca9EM1WW8dLmI92ryr+9sDzddfS
 48jiCwbeXKdaeSe8ySOCKzCR5qS3sA3Cvq1286/lka1IX8xGG1kP6m7aiIEVhR1NlG8c+O0s3
 IhPe6pBkBeABCwZUwPWPsiWhP09jjUfQRFu9mxWkzRmRcdjtzjXj4VzNjv7BtUJtX2cYktd3h
 tt1WMlJgVw00Ww3hVaqETNBOLld0Y81hUSru6RSs2OLc6zgXiBWSPyQmeVVq+Q+dM2gU/Xl8Q
 lasKe5creKpzRLdc3bOZ8jv1AmmaJ/cjavZW53w4/Z4P6URTyeOFxf+IcwI8zCi9N6Jx3LwaQ
 0TrYBcpxrpm1ortolIF1q9K1MMmxvEuexE/EdXbjp3iEnBuNGW22umIduIwTtCL/+D1E71g50
 RjCF8QDb4R47WJIu5JWAfBZBUNaMtuXie68ZmrbX5hEljjsmTuAzpnM1LswjYp4oqexMarqN2
 6NIPBQ6RUbwYGCCAqIdA4Lt6A8OVLyWakJ9KIw5I4FQrW01F8KxVwEfW5NccPYSjNG9ycji8i
 P8pK1o00c4z2I9isrEGeOD0zysGo5r3+Tpyk+tUPEoIwetJNDrQmb6janFxdr3jSl/qFB4hbi
 l8H4U3RtnG18PdIofQDur7OfRQ77ydcl/G/wZqa/fVfYey6r7Z4VAm3xsKJdle42rYNoNnifg
 k3KNrH3CdqJM3feCOliLspywJvqrBtypcchaPicdQbgDB23+eoY34xa2zo3ONHzmw2Avd7u9w
 cxnagQA4P2BrzdT3g/vHgOAOuueUciSS7OUYLhHQW2ga2w/jzwvGjfQZEkza6Z2peSatSpBlN
 ZhZoUyvhRG6f8qvVtE1PhzqdnXQbaZjr4E9AfBHQLzgfHr3wPVPcIl1fQn0g5v9TkwWN10kWN
 vHA9OJJDcUKdEaFNRN81ozjGbgki2glHJH909VQmB9wWjaVuWKJPTa6aG/UbZL9w8IL9FAxbZ
 F1wydJlqZs7fnBTD02k7FLOs0jWESBgVe0e5MP9bLrH+GS99LE0wmT/ly01jSIJGslK08dx1S
 57Ox1w9JD9OPj6/nMdPmNJuAtQxOQ+egGRn2vTqhxnks485YVtZksFK9m0MwbcjzWPqDkgRWO
 zA/aIXB2qKDZf7KTc1yqCn/zQurW1czGhKNu5eo5Jy5MbxXuZuod9m/6PTsu2BAOBWpaaEar/
 hbGUY3BjEyGRT6Axns3waAMjAAs8iRdT9nGhTBZMnVWgCptdNFZH2LfYsZU4u9ct/77MZpnZH
 kwQFujsbaBpB4coPgM34sG9lmBJLM94pkgRiOASvceiz582l6qzXb5/TITke6a5yKcRttRAnI
 Gwhonq1jCpgCDYciAsilrF/r0oBzYHHOvKpR+OggTBxFI2/jABpQMTJTlfRGtGnLffqZ65icM
 x0cod2s0+ee9K14T0SJvaP8DqqgaoR/qDBjymtCKnsVQ==


--nbtzd3b2lmwkf4dz
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.16 000/457] 6.16.4-rc1 review
MIME-Version: 1.0

On 25/08/26 01:04PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.4 release.
> There are 457 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Thu, 28 Aug 2025 11:08:27 +0000.
> Anything received after that time might be too late.
>=20

Tested-by: Christian Heusel <christian@heusel.eu>

Tested on the following hardware:

* a ThinkPad E14 Gen 3 with a AMD Ryzen 5 5500U CPU
* a Framework Laptop with a Ryzen AI 5 340=20
* a Framework Desktop
* a Steam Deck (LCD Edition)

--nbtzd3b2lmwkf4dz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmivNjUACgkQwEfU8yi1
JYVSkQ/7BD60GKc9qzitZRgqv6jNdOen75IdoZ5yEVl/p2B/fZKMz7N8dj9t1cz6
wdHk2xhwWxpf5DxoiMDFO1cMBLWDz5RvYroBJDfr6PrmMqOoAtqJnmsiryHvHPyK
FVZzD6bO9WJb3SWjBhMYMWBNxUIu8jY/NlBGaJoaqhR2W2w529S4pZpcXVtsPAHz
CEQSrEuU10JHX0JdvhE3cz0npm6AMl9sPshfgxAuSOr8HTFSpyvd8r387bU0d38X
HXPFqG7Yj/uxDUs7p2WDQW6w2HV1BYd9Bgi/1dykDzUJ3MEO9iCzG9lkm/rtE7NE
Q0nQlFkLoQexyemyYD2iC3igFFQjq1A2j9MYWnj/MpJ4orZL386rP2oslcr7rOws
C6BS6kPVY+IN59GrrdQ6u7kZUgkbzqaWGYICepR25mrzm2vTYoSAIkxZsUwp4soZ
Oi60JPutKFXcBDE4o2Adzp24ru2vj7xZQ8uj03NQc9nxWD8UH7Sf074gc1Q8c1mm
UwWQMBa6zZW1aW44fEUw/7cAv5QWrgVFggH92qYfKbhbCM2OStjkrfFDPV5qr7cz
ueH7OYTL8IkuysikP7cqsDLXHkgPo40WEbJJS4zgVbScp/mwnRja7iz5nnPXsIjH
QyeYMDOyzF4yMPispVHhB/1HsryEGdUvakptBJjn8VmEVhA4Svk=
=UNhW
-----END PGP SIGNATURE-----

--nbtzd3b2lmwkf4dz--
