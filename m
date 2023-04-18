Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA814290D
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 13:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1681825139; x=1713361139;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=pJJC11WAuc+OANctsWFTJZU6Xb9byC95sJdE8ckS274=;
  b=C6ZrTw0cHQgNwS52Z+l79N0XINfG4MFqgUClhiAzxxeCDs6/gxODS14/
   0fbu5aVVHEwO3lIRU7KV2R7E91F6BGOnz6Q5rjDggJuZiVFAR5nAdjRSd
   XiNIcsXf+F6QOiN8NH4D2fpr8Q7PpgBqljary+9oKlfvLLDl4tckti/7h
   YOY8VJaBf0oBiQBzcrtYO35YfBD5Zc5xBlsviXgoi176iaeIY5JWue7Mq
   ZAYjYq0ZsZTFi/a5ONoFAo/2XkGyr58tU2Q98G90vVIA8frssapxq6zb8
   Zb7ih1FVWDe/etfdWTSvYEZqe/uxbQS3fvndisB8q/h5eA4WNAfq3AAs3
   g==;
X-IronPort-AV: E=Sophos;i="5.99,207,1677567600"; 
   d="asc'?scan'208";a="210081986"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 18 Apr 2023 06:38:57 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 18 Apr 2023 06:38:56 -0700
Received: from wendy (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.21 via Frontend
 Transport; Tue, 18 Apr 2023 06:38:54 -0700
Date: Tue, 18 Apr 2023 14:38:38 +0100
From: Conor Dooley <conor.dooley@microchip.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <stable@vger.kernel.org>, <patches@lists.linux.dev>, Alyssa Ross
	<hi@alyssa.is>, Nick Desaulniers <ndesaulniers@google.com>, Masahiro Yamada
	<masahiroy@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 127/134] purgatory: fix disabling debug info
Message-ID: <20230418-wrist-glory-14a2aa00b2cb@wendy>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.600787422@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="WwxYlZ02mBcemm70"
Content-Disposition: inline
In-Reply-To: <20230418120317.600787422@linuxfoundation.org>

--WwxYlZ02mBcemm70
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey folks,

On Tue, Apr 18, 2023 at 02:23:03PM +0200, Greg Kroah-Hartman wrote:
> From: Alyssa Ross <hi@alyssa.is>
>=20
> [ Upstream commit d83806c4c0cccc0d6d3c3581a11983a9c186a138 ]
>=20
> Since 32ef9e5054ec, -Wa,-gdwarf-2 is no longer used in KBUILD_AFLAGS.
> Instead, it includes -g, the appropriate -gdwarf-* flag, and also the
> -Wa versions of both of those if building with Clang and GNU as.  As a
> result, debug info was being generated for the purgatory objects, even
> though the intention was that it not be.
>=20
> Fixes: 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
> Signed-off-by: Alyssa Ross <hi@alyssa.is>
> Cc: stable@vger.kernel.org
> Acked-by: Nick Desaulniers <ndesaulniers@google.com>
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/riscv/purgatory/Makefile | 7 +------
>  arch/x86/purgatory/Makefile   | 3 +--
>  2 files changed, 2 insertions(+), 8 deletions(-)
>=20
> diff --git a/arch/riscv/purgatory/Makefile b/arch/riscv/purgatory/Makefile
> index d16bf715a586b..5730797a6b402 100644
> --- a/arch/riscv/purgatory/Makefile
> +++ b/arch/riscv/purgatory/Makefile
> @@ -84,12 +84,7 @@ CFLAGS_string.o			+=3D $(PURGATORY_CFLAGS)
>  CFLAGS_REMOVE_ctype.o		+=3D $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_ctype.o			+=3D $(PURGATORY_CFLAGS)
> =20
> -AFLAGS_REMOVE_entry.o		+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memcpy.o		+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_memset.o		+=3D -Wa,-gdwarf-2

> -AFLAGS_REMOVE_strcmp.o		+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strlen.o		+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_strncmp.o		+=3D -Wa,-gdwarf-2

How about just deleting these 3 lines, rather than pulling back commit
56e0790c7f9e ("RISC-V: add infrastructure to allow different str*
implementations") <20230418120317.572094889@linuxfoundation.org>
as that is just going to be a bunch of dead code?

Cheers,
Conor.

> +asflags-remove-y		+=3D $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x=
))
> =20
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>  		$(call if_changed,ld)
> diff --git a/arch/x86/purgatory/Makefile b/arch/x86/purgatory/Makefile
> index 17f09dc263811..82fec66d46d29 100644
> --- a/arch/x86/purgatory/Makefile
> +++ b/arch/x86/purgatory/Makefile
> @@ -69,8 +69,7 @@ CFLAGS_sha256.o			+=3D $(PURGATORY_CFLAGS)
>  CFLAGS_REMOVE_string.o		+=3D $(PURGATORY_CFLAGS_REMOVE)
>  CFLAGS_string.o			+=3D $(PURGATORY_CFLAGS)
> =20
> -AFLAGS_REMOVE_setup-x86_$(BITS).o	+=3D -Wa,-gdwarf-2
> -AFLAGS_REMOVE_entry64.o			+=3D -Wa,-gdwarf-2
> +asflags-remove-y		+=3D $(foreach x, -g -gdwarf-4 -gdwarf-5, $(x) -Wa,$(x=
))
> =20
>  $(obj)/purgatory.ro: $(PURGATORY_OBJS) FORCE
>  		$(call if_changed,ld)
> --=20
> 2.39.2
>=20
>=20
>=20

--WwxYlZ02mBcemm70
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZD6dXgAKCRB4tDGHoIJi
0hqrAQCEeNdb+KYWF2N4id5tKtG5ZoL2bpCKDr/uNXuuzx5IFgEAg9rSS/khH/RN
0uGQiWVMchGz1z1Ve/NpYM2P/qjSswY=
=VJFp
-----END PGP SIGNATURE-----

--WwxYlZ02mBcemm70--
