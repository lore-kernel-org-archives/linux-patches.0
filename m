Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAAE7E
	for <patches@lists.linux.dev>; Sat, 26 Aug 2023 10:39:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C34BC433C8;
	Sat, 26 Aug 2023 10:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693046341;
	bh=RitoIFSZhjW5UlBYkipkGZOhMn5wsY+KxH7kfSkDkH4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CVlRu76SpcLwJW2Xx3+H65Q6/71FC6ThyRmb25EmtkpLFcMmTmPx1Aq+dhyCx2g72
	 EfNbA5QawXnZYviGDB9fh21pmHIn0WcXJ7lOhlXsjJnMNm0WfKBKT0NdXqLQmNtrHm
	 FuqyH4giU4NrkRZ/jAwWQ8/dQOivnAix4lv+nWaC2bGDuKWZ089GFy/KHCYFIDolXF
	 dbsmu4JpD5fby9bazqObbsFrTgZMUwQ8vbtnmHBedkh24tVPHpLjRGsyk0FcUSffrQ
	 kniY8tHOkNlZDrKq1i2eG+6WAWacqNOVBoX0LcW9Pmr+P3AnZooUOcmE4M6KuvHQcb
	 eGBi8DQjln03g==
Date: Sat, 26 Aug 2023 11:38:56 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Guenter Roeck <linux@roeck-us.net>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/135] 5.10.192-rc1 review
Message-ID: <20230826-huddle-designed-952a01db6e88@spud>
References: <20230824170617.074557800@linuxfoundation.org>
 <fb1c3952-1d72-4f9d-bc93-2988bcde462e@roeck-us.net>
 <2023082636-postnasal-cobalt-5ab5@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="rghNHbswWVpEDuGH"
Content-Disposition: inline
In-Reply-To: <2023082636-postnasal-cobalt-5ab5@gregkh>


--rghNHbswWVpEDuGH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 26, 2023 at 12:08:20PM +0200, Greg Kroah-Hartman wrote:
> On Fri, Aug 25, 2023 at 07:24:29AM -0700, Guenter Roeck wrote:
> > On Thu, Aug 24, 2023 at 07:07:52PM +0200, Greg Kroah-Hartman wrote:
> > > This is the start of the stable review cycle for the 5.10.192 release.
> > > There are 135 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, plea=
se
> > > let me know.
> > >=20
> > > Responses should be made by Sat, 26 Aug 2023 17:05:50 +0000.
> > > Anything received after that time might be too late.
> > >=20
> >=20
> > Testing is not complete, but early feedback: All riscv32 boot tests
> > crash badly with errors such as
> >=20
> > Starting syslogd: OK
> > Starting klogd: OK
> > /etc/init.d/S02sysctl: line 68: syntax error: EOF in backquote substitu=
tion
> > /etc/init.d/S20seedrng: line 33: syntax error: unexpected end of file (=
expecting ";;")
> > Starting network: /bin/sh: syntax error: unterminated quoted string
> > sed: unmatched '/'
> > /bin/sh: syntax error: unterminated quoted string
> > FAIL
> > /etc/init.d/S55runtest: line 48: syntax error: EOF in backquote substit=
ution
> >=20
> > This is no longer seen after reverting the following patches.
> >=20
> > 92609bb3a1f8 riscv: uaccess: Return the number of bytes effectively not=
 copied
> > e06648704417 riscv: lib: uaccess: fix CSR_STATUS SR_SUM bit
> > 20704d763646 riscv: lib: uaccess: fold fixups into body
> > 4f503bad920e riscv: __asm_copy_to-from_user: Optimize unaligned memory =
access and pipeline stall
>=20
> Thanks for the review, I'll go drop all of the riscv patches here.
> Really, we shouldn't be adding any of them to any kernels older than
> 5.15 these days as I do not think anyone using that cpu is using those
> older kernels (or at least I sure hope not...)

I know one of the main cpu IP vendors does run a 5.10 based tree, but
that thing is both an abomination of out-of-tree patches to core arch
code & about 100 releases out of date, therefore not really worth
factoring. Anyone in their right mind should be running something
significantly more recent than 5.10 for riscv.

--rghNHbswWVpEDuGH
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZOnWQAAKCRB4tDGHoIJi
0kUfAP4xb16YY0T200gX/E1eNIUB6qJFsOkRpKFiBXmHgVR2SQEA21dQYFqO1WY5
d6spP/yOL5Q39bkLnWSMl0Tafpw3dws=
=/L3h
-----END PGP SIGNATURE-----

--rghNHbswWVpEDuGH--
