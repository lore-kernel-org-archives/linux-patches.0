Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.17.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D4AB25487B
	for <patches@lists.linux.dev>; Mon, 23 Jun 2025 13:51:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750686697; cv=none; b=BHRw8OnratYKtZ7CV0H82x2DX5tTrhKks9/PgIgGhoaEiFxYIxl+xkiUHTb6iQ70Umoh7Lh/iUA7b3iG1y4FyE/tEApE53w6YV6DyH57bwJ9lzwmMgDdUhWpl/pfCcAEm1RrncT/ZnbtmM54y2mOFfwRJw9hmtg5AGft6ubuZX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750686697; c=relaxed/simple;
	bh=ospZQHAx1azzHgqpO0329Qy3iUeVF89ddO9PCGb2UkY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TeFYDtoc0sWzIxF6PWM1e7sIiA2v0m12gjrFP334Os3z/nqPLqz59DXDlShZofQ/JSoxTVn+B2YmVFZVKopdfWCdWl0ozTlaDWwucqV6deIURAQQuD2fV4IYW6j6DXyU6qNz7UkxrJ3/IpEbeZsVwNBPFzBp5CQj4rldHX3pQjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu; spf=pass smtp.mailfrom=heusel.eu; dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b=kiZ3HiBv; arc=none smtp.client-ip=212.227.17.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=heusel.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=heusel.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=heusel.eu header.i=christian@heusel.eu header.b="kiZ3HiBv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=heusel.eu;
	s=s1-ionos; t=1750686647; x=1751291447; i=christian@heusel.eu;
	bh=5Onc4Y8lpnattujCyjGKi5wWqwWwEpnJ7+2O5Ajcx7A=;
	h=X-UI-Sender-Class:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:In-Reply-To:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=kiZ3HiBvPyrzJ7aKeU+WwqaRXSCWThbvKxWQ4SganOf5d75EeoKVaS45UzgPW8iG
	 AJOZFQSVoNvah7KZbINiNbhO0HsG33cyVxTmkSRiJ3mmm55FtV/Im9j0ZB9xSiCQB
	 bEtAW/TP1Q6Na5lor9CKdOdDzlZtXjrOW8hC0rYsZM7AHSusRgrKjuG7CSoK+Ge1y
	 xc5h03uJgVmIbkCkIiNtdT/W5JzemLQCypt9Jyln3wOej1f4R1+AKAzz3KIz311z+
	 MXqgxkEHsRHuuG+g+rj7YK8lt5v7HBGkO4qWv8nT3tWG/9rY7RW9+rWrBKVTdxMI4
	 +Kl8QA2+Oves31TfXw==
X-UI-Sender-Class: 55c96926-9e95-11ee-ae09-1f7a4046a0f6
Received: from localhost ([94.31.75.247]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Mzhax-1ugfyg2FZh-010Vx6; Mon, 23 Jun 2025 15:50:47 +0200
Date: Mon, 23 Jun 2025 15:50:45 +0200
From: Christian Heusel <christian@heusel.eu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, akpm@linux-foundation.org, 
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org, 
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, 
	hargar@microsoft.com, broonie@kernel.org
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
Message-ID: <a0ebb389-f088-417b-9fd4-ac8c100d206f@heusel.eu>
References: <20250623130700.210182694@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="bzrlzjrxqd77i3z3"
Content-Disposition: inline
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
X-Provags-ID: V03:K1:xQORCzsKcY/1G5rTjYyoobOjvK/C4mp5jHpyY05xgU6Q1cU5+rf
 SdLTMzVMQbqPNHLQSd9PILqzuj1kIEd4kkBfMjYulFb4t0V2tG2jF/0sWWUTqI38ygcKg5t
 /y4es4dWDGbMZHAEuHjwxJG0te6c91gdeLK2A4K8WATYD2BKmMDe8YPeRSeRJ1DaMmzgZIT
 lMxq2jG81BTI5GYFyzE2g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:JOj1uUFmIF0=;ApuwC2GWMXKAIY8oF+p9H0wHL6c
 y0pF3h1rMhrx1wuJrrJ/MfFT9djLuxzrjNvLxwmPEC7zwh3eFfe8p8/Q5ZwUyQyDMfcHuDOo6
 KBHtD3/JkwZyX9kpzl62XDFASP8qp1A2Hu2l2N6JsYXs6UbSr31vBBs9RHA/qg1+M/v9udQHt
 OGTlPGjn7ltiR4WlEvvkTgz1P9DLOOXMBUw9N0UaPv9LCcwstZ+QC9Mv6Sv6TIuPGJhGxsL/U
 oOZBNvcRE7S/IQcL4IpfwBTcOvMfX6TcEzxOSNLX/ehzmavObA5MRkVxnQ15BpPnPd4k4EBkn
 fwJAevRZOv1xHvxnrowSNJBJGCan9jvwqS4iJ0R9kWhneKbuqpliqwkjNR1NmV3xEofEY6UT4
 k+5Ubq14kSvgG1ASAT8vVCxSqC+hWtI8SBdUjyZywEzJaAYbDfTFCIoUzBr7tzHGu6U1pYbUk
 kqQBE8z0FTLmjn7z35icuxBX7QDHr1hs7dgs7hCL2upr1V3xv/rnzWh3AopJCyABNe01+ngPk
 EkBuqCPizmOLg7IyJZZf+XmLzqO4xG7IC6sttkT/8XeIa2EsEsDyWQpjdQ7pUVCG0SZWgBKsN
 rwmbooIhDFzbZr/zXQbDrDMpjvZ4kvfexlodKpsAajnzVwq5UosGhn9b/GAmigF+qG7aNNpsC
 wvUkjQsElNZHuuxSJ3bN38aQPSzuv3n4Wz3rnVCzL53EX/xBupn1mSzn46DU28E77DWJwWBeZ
 cKDl7wo9Y+sPXGsUcXiLwP7zoEayDhfqnmA6dL6RcescEAlrkAdh9DdLIatzg3/qBuYWhilOQ
 7+WEj+Sk8e+HHVtq7mNWJcsxZP3miBa7wNTiqkBJ2HkEd2FqHkrOoeiuYq3rbUnaxu8HnPVwp
 rFEgMRBO9szPbhaUq3YWp7Mjyjk8mMdqw9QfeHtIcNoL0D5U54nod6dO6PvhcGUVtdJ9G7Ljy
 vmIJeG2aSWK4cJ3e1WoI8CcTcE0YQlsxnfN8gvgt5UoKLuQbvmuA/D0TiBmOYEuNUzerCjnEq
 Ntk0bI32S6Dksw3hBj7oWB34pl4RsmUH3JA383SQgidKiRJuyXEROyb9TDE5r1H3fUEEGgvXb
 u/ek4mUisU5OMCOQqOWklUpo3EMDL/GNGJoyONgjXwb2ftCmzmbO/YSQ1WXdsUCDTp6A+gE41
 DwRsDg1tKNJCdRcALzN6frzqZnK5MrApKSD1yDg4J6n6BlauGQigiMmKzsQNbm6b3E7ZIGOVs
 px3p7+NYy7iWFlIvbu2g3KbAkqkhlEFRp/7LkoN4jMzQ6HQt8skyqNA1i9BbEkDPerQm4EcT/
 GuQQP1gMNpXcuLcl5dhtC5x95QYTfv/thw2EBfzRTtm5S2dDYay8K9ZNpeZjAALRti4tK6RA0
 W4tI7Zit2MCqDOM6H5Hug1mPCEZdV191zYrP453g9QIex1BL4Xv6yAWi7g6Y1XC4io5q9xWLi
 pQ4zhYZgYdvzLwtGyAEWGGTm7gEs=


--bzrlzjrxqd77i3z3
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH 6.15 000/592] 6.15.4-rc1 review
MIME-Version: 1.0

On 25/06/23 02:59PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.4 release.
> There are 592 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
> Responses should be made by Wed, 25 Jun 2025 13:05:55 +0000.
> Anything received after that time might be too late.
>=20
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.4-=
rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git=
 linux-6.15.y
> and the diffstat can be found below.
>=20
> thanks,
>=20
> greg k-h

Hey Greg,

this stable release candidate does not build for me as-is on x86:

error[E0432]: unresolved import `crate::sync::Completion`
  --> rust/kernel/devres.rs:16:22
   |
16 |     sync::{rcu, Arc, Completion},
   |                      ^^^^^^^^^^ no `Completion` in `sync`

error[E0412]: cannot find type `Bound` in this scope
   --> rust/kernel/devres.rs:226:49
    |
226 |     pub fn access<'a>(&'a self, dev: &'a Device<Bound>) -> Result<&'a=
 T> {
    |                                                 ^^^^^ not found in th=
is scope
    |
help: consider importing this enum
    |
8   + use core::range::Bound;
    |

error[E0107]: struct takes 0 generic arguments but 1 generic argument was s=
upplied
   --> rust/kernel/devres.rs:226:42
    |
226 |     pub fn access<'a>(&'a self, dev: &'a Device<Bound>) -> Result<&'a=
 T> {
    |                                          ^^^^^^------- help: remove t=
he unnecessary generics
    |                                          |
    |                                          expected 0 generic arguments
    |
note: struct defined here, with 0 generic parameters
   --> rust/kernel/device.rs:45:12
    |
45  | pub struct Device(Opaque<bindings::device>);
    |            ^^^^^^

error[E0600]: cannot apply unary operator `!` to type `()`
   --> rust/kernel/devres.rs:172:12
    |
172 |         if !inner.data.revoke() {
    |            ^^^^^^^^^^^^^^^^^^^^ cannot apply unary operator `!`

error[E0599]: no method named `access` found for struct `Revocable` in the =
current scope
   --> rust/kernel/devres.rs:234:33
    |
234 |         Ok(unsafe { self.0.data.access() })
    |                                 ^^^^^^
    |
   ::: rust/kernel/revocable.rs:64:1
    |
64  | #[pin_data(PinnedDrop)]
    | ----------------------- method `access` not found for this struct
    |
help: there is a method `try_access` with a similar name
    |
234 |         Ok(unsafe { self.0.data.try_access() })
    |                                 ++++

error[E0599]: no method named `try_access_with` found for struct `Revocable=
` in the current scope
   --> rust/kernel/devres.rs:244:21
    |
244 |         self.0.data.try_access_with(f)
    |                     ^^^^^^^^^^^^^^^
    |
   ::: rust/kernel/revocable.rs:64:1
    |
64  | #[pin_data(PinnedDrop)]
    | ----------------------- method `try_access_with` not found for this s=
truct
    |
help: there is a method `try_access` with a similar name, but with differen=
t arguments
   --> rust/kernel/revocable.rs:97:5
    |
97  |     pub fn try_access(&self) -> Option<RevocableGuard<'_, T>> {
    |     ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

error[E0308]: mismatched types
   --> rust/kernel/devres.rs:257:21
    |
257 |         if unsafe { self.0.data.revoke_nosync() } {
    |                     ^^^^^^^^^^^^^^^^^^^^^^^^^^^ expected `bool`, foun=
d `()`

error: aborting due to 7 previous errors

Some errors have detailed explanations: E0107, E0308, E0412, E0432, E0599, =
E0600.
For more information about an error, try `rustc --explain E0107`.
make[2]: *** [rust/Makefile:536: rust/kernel.o] Error 1
make[1]: *** [/build/linux/src/linux-6.15.3/Makefile:1280: prepare] Error 2
make: *** [Makefile:248: __sub-make] Error 2


--bzrlzjrxqd77i3z3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEb3ea3iR6a4oPcswTwEfU8yi1JYUFAmhZW7UACgkQwEfU8yi1
JYV7pBAAoLezFTzYpDLyAa2Xg8+9dwvSN121/S9xM+EPfrq72KeTvU+H0emNmKa+
+nr5DxoIlE5ywlPMu759wMoS0sv2vdCSO4Fo9u0RYLwY8igZO3F7gNCtzLTOl5w3
m54Dg0zKeKt+YljwZbXOeFiBVW6SGCzBXfRIukYzZU8Lx+6iDfQgAYVuTuBpe8Dg
RodEzxKyw4W83yxbU9X7h/uNWc3HNmHu+YtPsvEnBLMlIXQ8m/gUSB7nDmLRlLW3
HoJxDx1122V3vcZKhiNJYVScKqXtYI3jAVuzsnq+5s/HF3IEBQPiVr/ouHO1Lpkx
JaRt1xv/rpLSAO2M9Zbmhhz7QFj7sJ0WpcIVYnixJQxjSGAL/GQ4cVKGfDVIYPL2
yQPmI1aVQ7d7pGS5RD64SXXtTrl2+7UAdbvDuFxjTlCeY6ZkGreGuGiy+L4eB9vc
n9pvVjAJSC6FkE3ICvS3OFxIF2KrSsQS7d3kDQ5GFqoQfVsFJtb0DLsOkhylUitm
wF3pP+42RKUSPcsEdYJe7PCTAeCAWQVcaBtnM2KjctQGkTW5QcfX0to55W1y9xiM
upVPaxdCoSUOGlpSYQuapIe39B4VyQad9qN7OdYe/4iJWbbto8rg0IqOS9JYbdJf
w1/Cv1HYzowFUdxT5TKlPLCPQNaLC9VYSleec/iOUC2ig0VN5MA=
=Nnoh
-----END PGP SIGNATURE-----

--bzrlzjrxqd77i3z3--
