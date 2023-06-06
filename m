Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0346A468F;
	Tue,  6 Jun 2023 10:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1686048073; x=1717584073;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5gngC/o7dDVu0tjO/fekC+esw9RCF5CblBlDQvtOBCE=;
  b=gHzqnEtfiX2MMcmDlhsIyP3EngpEfxa14LHSmzGPO7O87fkV50esHMpA
   VAlm6yNDq6cUwczhj2HD8gpZCz+07R8gm/XUZDLlFSt0FiR2lI08TRcj2
   G8gXUmJ0LD75G1P0n4bLC1GtMQvyNXTfoV1wCQi181EtJDafugE8hwZrk
   YiD81ECIXlvRH4NhVx/ODxvRi2LCoWql78mdzyMB/Swt/E4YgUSTOvzOY
   7RJkvOIYZepN946rQhMHTevlnF0LmQCYmuyn0C/amv5MJhdYPcZ5wwxgD
   UlQ/fCoJvANbj36wfE32Un9X992PCYAn7477nbB83VIVUDXiN3Vu+OHf5
   w==;
X-IronPort-AV: E=Sophos;i="6.00,221,1681196400"; 
   d="asc'?scan'208";a="214837298"
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jun 2023 03:41:05 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 6 Jun 2023 03:41:01 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 6 Jun 2023 03:40:59 -0700
Date: Tue, 6 Jun 2023 11:40:35 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Nathan Chancellor <nathan@kernel.org>
CC: <gregkh@linuxfoundation.org>, <sashal@kernel.org>, <palmer@dabbelt.com>,
	<conor@kernel.org>, <paul.walmsley@sifive.com>, <aou@eecs.berkeley.edu>,
	<ndesaulniers@google.com>, <trix@redhat.com>, <stable@vger.kernel.org>,
	<linux-riscv@lists.infradead.org>, <llvm@lists.linux.dev>,
	<patches@lists.linux.dev>
Subject: Re: [PATCH 6.3] riscv: vmlinux.lds.S: Explicitly handle '.got'
 section
Message-ID: <20230606-exploit-refill-b9311f2378f3@wendy>
References: <20230605-6-3-riscv-got-orphan-warning-llvm-17-v1-1-72c4f11e020f@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="hUdYCm5YT6D3efCv"
Content-Disposition: inline
In-Reply-To: <20230605-6-3-riscv-got-orphan-warning-llvm-17-v1-1-72c4f11e020f@kernel.org>

--hUdYCm5YT6D3efCv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 05, 2023 at 02:15:08PM -0700, Nathan Chancellor wrote:
> This patch is for linux-6.3.y only, it has no direct mainline
> equivalent.
>=20
> LLVM 17 will now use the GOT for extern weak symbols when using the
> medany model, which causes a linker orphan section warning on
> linux-6.3.y:
>=20
>   ld.lld: warning: <internal>:(.got) is being placed in '.got'
>=20
> This is not an issue in mainline because handling of the .got section
> was added by commit 39b33072941f ("riscv: Introduce CONFIG_RELOCATABLE")
> and further extended by commit 26e7aacb83df ("riscv: Allow to downgrade
> paging mode from the command line") in 6.4-rc1. Neither of these changes
> are suitable for stable, so add explicit handling of the .got section in
> a standalone change to align 6.3 and mainline, which addresses the
> warning.
>=20
> This is only an issue for 6.3 because commit f4b71bff8d85 ("riscv:
> select ARCH_WANT_LD_ORPHAN_WARN for !XIP_KERNEL") landed in 6.3-rc1, so
> earlier releases will not see this warning because it will not be
> enabled.
>=20
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1865
> Link: https://github.com/llvm/llvm-project/commit/a178ba9fbd0a27057dc2fa4=
cb53c76caa013caac
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Seems reasonable to me chief.
Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

Thanks,
Conor.

--hUdYCm5YT6D3efCv
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZH8NIwAKCRB4tDGHoIJi
0uPMAQDmbQHzmgYV1anMuSfDVX2ah2UZzhysHE3OJcbQsgGvGQEArKBOtM1RdmbV
ucztRbZaGYtD6FTut83S/F6gJX64Awo=
=9b+g
-----END PGP SIGNATURE-----

--hUdYCm5YT6D3efCv--
