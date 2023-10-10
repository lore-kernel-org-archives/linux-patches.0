Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CB093159F;
	Tue, 10 Oct 2023 21:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6nC8pqv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 769CEC433C7;
	Tue, 10 Oct 2023 21:02:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1696971762;
	bh=Z7ej04uU0GR3MOipg+o+WcIRoRs95S+/l2+VMvWDCoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=D6nC8pqvOlM/9XRukSpgRh43PP4yI3ATygMSOJfkqmN4KZxsCLRDSS04U+9/g0asx
	 vO50wlxbdKx5IfrB0mJWx8awqb0DI1oIbcy0n6sbnGyYAWbpYTl3cVX/OrglUq1vyy
	 MGdqSH5n8nsj+x5Pels4uL2PBLljgGfdd37Cv9tCGhyswXtbgg2n6dAZVtAIFZoOCB
	 mm0UdVs+3YpHMkLku9MsMoqW8xTXFxtIRu/0hGZmgYnlLTLNL+lGtddPcubog4m1JS
	 4BTSUO7CNslJGygvLxunmlJJpNRxdfxfXgQB5U2CiyMuIVC3OnA7CuIjpWbFlWBj1h
	 1VArvghic6maA==
Date: Tue, 10 Oct 2023 22:02:38 +0100
From: Conor Dooley <conor@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>, paul.walmsley@sifive.com,
	palmer@dabbelt.com, aou@eecs.berkeley.edu, trix@redhat.com,
	samitolvanen@google.com, twd2.me@gmail.com,
	linux-riscv@lists.infradead.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH v3] RISC-V: build: Allow LTO to be selected
Message-ID: <20231010-ungloved-tropical-c731e05d86d6@spud>
References: <20231003-riscv-lto-v3-1-8aca61a4ecb4@kernel.org>
 <CAKwvOdnMeM4YArw=hyVkev11cLfks5gaXWXNK+Wo0bcbeuMZHg@mail.gmail.com>
 <20231010195247.GA2233717@dev-arch.thelio-3990X>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="R1zu76Uiutz83xFt"
Content-Disposition: inline
In-Reply-To: <20231010195247.GA2233717@dev-arch.thelio-3990X>


--R1zu76Uiutz83xFt
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 10, 2023 at 12:52:47PM -0700, Nathan Chancellor wrote:
> On Tue, Oct 10, 2023 at 10:03:15AM -0700, Nick Desaulniers wrote:
> > On Tue, Oct 3, 2023 at 12:17=E2=80=AFPM Nathan Chancellor <nathan@kerne=
l.org> wrote:
> > >
> > > From: Wende Tan <twd2.me@gmail.com>
> > >
> > > Allow LTO to be selected for RISC-V, only when LLD >=3D 14, since the=
re is an
> > > issue [1] in prior LLD versions that prevents LLD to generate proper
> > > machine code for RISC-V when writing `nop`s.
> > >
> > > I have tested enabling LTO for `defconfig`. The LLD took ~2m21s and ~=
3GiB
> > > on our Intel Xeon Gold 6140 server and produced an 18MiB Image. The i=
mage
> > > can boot to shell using an archriscv rootfs on QEMU.
> > >
> > > I have also tested it for `allyesconfig` without COMPILE_TEST, FTRACE,
> > > KASAN, and GCOV. The LLD took ~7h03m and ~335GiB on the server,
> > > successfully producing a 1.7GiB Image. Unfortunately, we cannot boot =
this
> > > image because the `create_kernel_page_table()` -> `alloc_pmd_early()`=
 ->
> > > `BUG_ON()` logic limits the image to be < 1GiB. Maybe we can fix it i=
n a
> > > separate patch further.
> > >
> > > Disable LTO for arch/riscv/kernel/pi, as llvm-objcopy expects an ELF
> > > object file when manipulating the files in that subfolder, rather than
> > > LLVM bitcode.
> > >
> > > [1] https://github.com/llvm/llvm-project/issues/50505, resolved by LL=
VM
> > >     commit e63455d5e0e5 ("[MC] Use local MCSubtargetInfo in writeNops=
")
> > >
> > > Tested-by: Wende Tan <twd2.me@gmail.com>
> > > Signed-off-by: Wende Tan <twd2.me@gmail.com>
> > > Co-developed-by: Nathan Chancellor <nathan@kernel.org>
> > > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> >=20
> > Perhaps worth a v4 due to linker relaxation resulting in boot failures
> > you observed:
> > https://github.com/ClangBuiltLinux/linux/issues/1942 ?
>=20
> Yes, agreed. RISC-V patchwork folks, consider marking this as "Changes
> Requested" or whatever other status there is that indicates that I need
> to send a v4 working around that issue, at least until we better
> understand the issue.

Done.

--R1zu76Uiutz83xFt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZSW77gAKCRB4tDGHoIJi
0sxoAQDKAL6kBoEjgZZtq5CheMsG86H6TjIzBjzK4JtxTI1LqAEAmG8ct09mDd3B
hLJi7x7mXPeC4/yBKNHTDjodzgrLDgY=
=C53g
-----END PGP SIGNATURE-----

--R1zu76Uiutz83xFt--
