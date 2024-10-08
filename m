Received: from elaine.keithp.com (home.keithp.com [63.227.221.253])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7273C84A35;
	Tue,  8 Oct 2024 16:09:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=63.227.221.253
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728403775; cv=none; b=eihG3puhnC+cR5NVlqHXt23++LxdrI8m/GvBjRYCrTL9+DGlrt2AdTEyELy7Gz0S6UMmLYd0/bUyT2PWvxm4gAaUTgfO1uHOtEd5X4Vk2CH0Q8I3XWN0m1Rz/zqHtP8ve4BBQkez/lSdmO1buO1e9jCHHOwBsFnUmfuKi5houKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728403775; c=relaxed/simple;
	bh=oJizpp9aoOY0AopSPxylxEhhCtx+WlqEdtLodFwISho=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=URL7b1YC1GzgCGk0lF2x/LgN3f9HbCqBUzFW0L6AdXu1lOztju1DjGepxCmSifKQQbocAOMW/XTcpCj32xkfv6b92HQA4GHU4emVB1il10HDMxXIUSTshtXZRaFIAh85Dz29y92kenMV+c2uTbn0KGAqP3Dz9Uv2IAJY1lxsV2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=keithp.com; spf=pass smtp.mailfrom=keithp.com; dkim=pass (2048-bit key) header.d=keithp.com header.i=@keithp.com header.b=Zk9bYakH; dkim=pass (2048-bit key) header.d=keithp.com header.i=@keithp.com header.b=NSOj9hJX; arc=none smtp.client-ip=63.227.221.253
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=keithp.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=keithp.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=keithp.com header.i=@keithp.com header.b="Zk9bYakH";
	dkim=pass (2048-bit key) header.d=keithp.com header.i=@keithp.com header.b="NSOj9hJX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=keithp.com; s=mail;
	t=1728403773; bh=oJizpp9aoOY0AopSPxylxEhhCtx+WlqEdtLodFwISho=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Zk9bYakHOUzQevZrYXCQdXBwTsIS5nq41acB4bsphbLmhLTYSyaXRBvQ/wpXNYCMW
	 A4nw5snc1cJpmvG0auJZ6pG+nVepA5tXPZ3CByJmkGh8ahJijudq74dm9/dXu/ZAtu
	 jS97S/U+Wt2wTgIcjazn7BBCX78Ttw3TwmzP9vQSKjGQxXA7Wyyz6ratkbZ2kkTsCL
	 5lhcSp2JtVVoD4fImTWHru0z5JDA4ySGqvLMVfvoeEK2ZSBnGmx6pBHyod9mHMx10k
	 tzHI2AIfQmnsd/Ux0AyvWZltpgUxRarkJJoRgGtg3/3RHqPKddNAabFm9s84YPXyr2
	 pVN26WltMk8pA==
Received: from localhost (localhost [127.0.0.1])
	by elaine.keithp.com (Postfix) with ESMTP id BAA4C3F2275A;
	Tue,  8 Oct 2024 09:09:33 -0700 (PDT)
X-Virus-Scanned: Debian amavis at keithp.com
Received: from elaine.keithp.com ([127.0.0.1])
 by localhost (elaine.keithp.com [127.0.0.1]) (amavis, port 10024) with LMTP
 id yKexJ_RQZQJk; Tue,  8 Oct 2024 09:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=keithp.com; s=mail;
	t=1728403772; bh=oJizpp9aoOY0AopSPxylxEhhCtx+WlqEdtLodFwISho=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=NSOj9hJXUKpWGlxGQaDVv+uH0SmT6MyLkQDbBdfEy45nmCLfbAK0DnTb+FjcOEn21
	 z7cf99MaJkoNan2k6IIo5Cz8tCZiqLQk5lUHiQJMK0P/8V6ejiXS5hFMSV5VR4eF+F
	 1+0xUuXi5+q9HxIyB4WLMrepJ9r/btzY9Evmp210t16mlL4EpdH9NhLfO69ItzbRna
	 RROQKFKpbcnePP3tJVKTsK/SSGox+9EexFPuq5+F0cA6ObQ+jl2L9rxyFt9HjkL6DD
	 9otdZSXaMLfpqcjtejPGdhcBbKpUUWom27rLVGDHsoeMduuTDPREVNYGf9VtWOGyeS
	 gmyQCOangUMhw==
Received: from keithp.com (koto.keithp.com [192.168.11.2])
	by elaine.keithp.com (Postfix) with ESMTPSA id A4A193F208E2;
	Tue,  8 Oct 2024 09:09:32 -0700 (PDT)
Received: by keithp.com (Postfix, from userid 1000)
	id 6643A1E60239; Tue, 08 Oct 2024 18:09:32 +0200 (CEST)
From: Keith Packard <keithp@keithp.com>
To: Nathan Chancellor <nathan@kernel.org>, Michael Ellerman
 <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy
 <christophe.leroy@csgroup.eu>, Naveen N Rao <naveen@kernel.org>, Madhavan
 Srinivasan <maddy@linux.ibm.com>, Nick Desaulniers
 <ndesaulniers@google.com>, Bill Wendling <morbo@google.com>, Justin Stitt
 <justinstitt@google.com>, linuxppc-dev@lists.ozlabs.org,
 llvm@lists.linux.dev, patches@lists.linux.dev, Nathan Chancellor
 <nathan@kernel.org>
Subject: Re: [PATCH 0/3] powerpc: Prepare for clang's per-task stack
 protector support
In-Reply-To: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
References: <20241007-powerpc-fix-stackprotector-test-clang-v1-0-08c15b2694e4@kernel.org>
Date: Tue, 08 Oct 2024 09:09:32 -0700
Message-ID: <87ldyyvao3.fsf@keithp.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


> This series prepares the powerpc Kconfig and Kbuild files for clang's
> per-task stack protector support.

Reviewed-by: Keith Packard <keithp@keithp.com>
Tested-by: Keith Packard <keithp@keithp.com>

=2D-=20
=2Dkeith

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEw4O3eCVWE9/bQJ2R2yIaaQAAABEFAmcFWTwACgkQ2yIaaQAA
ABGMCQ/+P5eh4p/7FKNEwLPB1NvaEIPPnwmj0iF7AGh45nKXbtvCVPYuBTXTs+/z
xhYj8zmizQJLgfEjuhJVBLE2DHGQ/hw6ajS/zUPOkwwwmtT81e5sV0OsrxwWqH1E
LPA+jbNyqETz/Khznu5ev2gT5q70AvPigFpufd1CcLZHT/BQjkGKm0WmIrH3DbCH
bsH8fJb1wwmudUQO7XLv/X/znlyFp14wmb3wpVAWooeCzm8dYPoIY139TYbr35HF
+UFQ5HtoA6CsuZOOspjuUSc3GvcDRPEbs1bO3WX3RZVBiBesZsFNiel2Rg33Xlw/
VsGOKkxAotpZbJA6nYA+O42aizykgL4k29/AHaXGVfDONx7SPLzfHSAE1YFEbqRZ
g3M0OxVOJFRF0vo4Pw9YVs9lgxwdu6tWSYMVbF5UMROxSX1CDU8hOzgbQhJ1XaV1
ckJaJNu6E1+1d9dzHydbrgYPZsvAfeeKLjyVaqTroYHfOM4u8ObKNbzpafVFZ9Sw
GTgOS8k5iwOdQT3Pxp9NXimVmqzcRJqs3VnODz9kuYjhGHHO5gU9dm49J1u0HXVV
9xuP2wxAjiP9ue9DWs9hW52k4bYj0o2ssrl3oG8LWQvssuZSxo0jXd7Blmm0ygqJ
FAqH2qOYU8C/Fi/n5iQdPgmSu23BCfS3rnq0cQzit2QjXAiWXKA=
=7U2U
-----END PGP SIGNATURE-----
--=-=-=--
