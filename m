Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 203DF17C6D;
	Wed, 19 Jun 2024 14:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718807305; cv=none; b=CLvNVJqOrrT9gBSvK3IPtAOryCR79eFhjR7lvQMsJwOaniHZ7Uomo5B5WeJC+p5xYpLislgYaC+Po0EBBIagE3j0DP3eK0Ph9jYxKOyiV04BrNdCSN86xMUHPBIR2BEGkFxNqaD2EHmWlD8ENmXkpTaonmdZxnuU15oCP4Lmc7g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718807305; c=relaxed/simple;
	bh=AU0WHFQ5f9xKg1pwbsFB6VDOn7aISrKJJJKEaONzOfo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dQbnFrTw7HXBw529PEWL1bub8ayv9Ghp92ortXR671ZxQFVAPZgraDWvmiP5S8h3X8BORFPLjUNx9hiSeWywyGwjpbi2s5+0MBM1AZFFwJH+ABEEvaNBU7kirYsgjKKJllLLdBLUV9XN0FjqSDpwrQT6vinILbpBHw8YrhL0fjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a4x6Esjw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a4x6Esjw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB513C4AF09;
	Wed, 19 Jun 2024 14:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718807304;
	bh=AU0WHFQ5f9xKg1pwbsFB6VDOn7aISrKJJJKEaONzOfo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a4x6EsjwgWgy9f8NHkw6gpqQA61xSfCusJeEbprdFz2EOLdVAKwNod9DxSMNOKABe
	 NMnBIF+hqkJA+txmeQOGJX+n/7U7yuN7LMDuOH6fhQIo+0tm3hAocrBXClq4jduk9n
	 64m4M1oPsPfpL0fENzs06vUI6Dg/sUkyR3C7s4/I4Ljif0fRePFP3A228S2yLNqm52
	 SctBCwxoeNA6q7bW+dYE3d/ga63geztp8uQy00Lq/NKr9GhypPKWHgIMo+7ji8o8D6
	 YJu9XLyFpcvVlHxbdM8U9wFa6IvLkxtlCjHDvgFCOXNq/D9Qk7BU/5g3Ybj9vnbGP7
	 fLWgC6BqUpSuw==
Date: Wed, 19 Jun 2024 15:28:18 +0100
From: Conor Dooley <conor@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Conor Dooley <conor.dooley@microchip.com>, Ron Economos <re@w6rz.net>,
	Pavel Machek <pavel@denx.de>, stable@vger.kernel.org,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, allen.lkml@gmail.com,
	broonie@kernel.org
Subject: Re: [PATCH 6.6 000/741] 6.6.33-rc2 review
Message-ID: <20240619-kerchief-grove-20c3996db1aa@spud>
References: <20240609113903.732882729@linuxfoundation.org>
 <ZmYDquU9rsJ2HG9g@duo.ucw.cz>
 <ad13afda-6d20-fa88-ae7f-c1a69b1f5a40@w6rz.net>
 <2024061006-overdress-outburst-36ae@gregkh>
 <20240610-scabby-bruising-110970760c41@wendy>
 <2024061140-sandworm-irk-b7c9@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="HSkLJ8OZPVtN/Kw1"
Content-Disposition: inline
In-Reply-To: <2024061140-sandworm-irk-b7c9@gregkh>


--HSkLJ8OZPVtN/Kw1
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 11, 2024 at 03:06:01PM +0200, Greg Kroah-Hartman wrote:
> On Mon, Jun 10, 2024 at 08:26:10AM +0100, Conor Dooley wrote:
> > On Mon, Jun 10, 2024 at 08:28:29AM +0200, Greg Kroah-Hartman wrote:
> > > On Sun, Jun 09, 2024 at 11:21:55PM -0700, Ron Economos wrote:
> > > > On 6/9/24 12:34 PM, Pavel Machek wrote:
> > > > > Hi!
> > > > >=20
> > > > > > This is the start of the stable review cycle for the 6.6.33 rel=
ease.
> > > > > > There are 741 patches in this series, all will be posted as a r=
esponse
> > > > > > to this one.  If anyone has any issues with these being applied=
, please
> > > > > > let me know.
> > > > > 6.6 seems to have build problem on risc-v:
> >=20
> > > > > arch/riscv/kernel/suspend.c:14:66: error: 'RISCV_ISA_EXT_XLINUXEN=
VCFG' undeclared (first use in this function); did you mean 'RISCV_ISA_EXT_=
ZIFENCEI'?
> > > > > 694
> > > > >     14 |         if (riscv_cpu_has_extension_unlikely(smp_process=
or_id(), RISCV_ISA_EXT_XLINUXENVCFG))
> > > > > 695
> > > > >        |                                                         =
         ^~~~~~~~~~~~~~~~~~~~~~~~~~
> > > > > 696
> > > > >        |                                                         =
         RISCV_ISA_EXT_ZIFENCEI
> >=20
> > > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/j=
obs/7053222239
> > > > > https://gitlab.com/cip-project/cip-testing/linux-stable-rc-ci/-/p=
ipelines/1324369118
> > > > >=20
> > > > > No problems detected on 6.8-stable and 6.1-stable.
> > > > >=20
> > > > > Best regards,
> > > > > 								Pavel
> > > >=20
> > > > I'm seeing the same thing here. Somehow some extra patches got slip=
ped in
> > > > between rc1 and rc2. The new patches for RISC-V are:
> > > >=20
> > > > Samuel Holland <samuel.holland@sifive.com>
> > > > =A0=A0=A0 riscv: Save/restore envcfg CSR during CPU suspend
> > > >=20
> > > > commit 88b55a586b87994a33e0285c9e8881485e9b77ea
> > > >=20
> > > > Samuel Holland <samuel.holland@sifive.com>
> > > > =A0=A0=A0 riscv: Fix enabling cbo.zero when running in M-mode
> > > >=20
> > > > commit 8c6e096cf527d65e693bfbf00aa6791149c58552
> > > >=20
> > > > The first patch "riscv: Save/restore envcfg CSR during CPU suspend"=
 causes
> > > > the build failure.
> > > >=20
> > > >=20
> > >=20
> > > Yes, these were added because they were marked as fixes for other
> > > commits in the series.  I'll unwind them all now as something is going
> > > wrong...
> >=20
> > Really we should just backport this envcfg handling to stable, this
> > isn't the first (and won't be the last) issue it'll cause. I'll put a
> > backport of it on my todo list cos I think last time around it couldn't
> > be cherrypicked.
>=20
> Thanks, I've dropped almost all riscv patches from this queue now.  If
> they want to be added back, please send working backports :)

I went to take a look at this, but since 6.8 is now EOL, I dunno if I
actually need to do anything here? These were needed because you had
applied "RISC-V: Enable cbo.zero in usermode", but that's a feature, not
a fix, so dropping that makes these changes unneeded. IIRC the previous
time that there was an envcfg related build failure it was on the
requested backport to 6.7+ in the envcfg addition in "riscv: Add a custom
ISA extension for the [ms]envcfg CSR", and an assertion failed because
of a definition for the maximum number of ISA extensions was larger in
6.9 than 6.7 and the patch depended on that.

For 6.6, I don't think envcfg is needed, unless there was some other
reason that you backported "RISC-V: Enable cbo.zero in usermode".

Cheers,
Conor.

--HSkLJ8OZPVtN/Kw1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZnLq7wAKCRB4tDGHoIJi
0nx/AP4nGlbl+Y1qoFUNKskbv1SqUeIpe3vQacxSGhk/yb01lAD/c2suHh/qsktY
bD5QJR2jwXzfpuOXToaOwpsMvZxFoQY=
=01VC
-----END PGP SIGNATURE-----

--HSkLJ8OZPVtN/Kw1--
