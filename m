Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36F1527B323;
	Wed, 27 Aug 2025 17:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756315876; cv=none; b=rJL21VrJYMqxa2JJ6XNbN0RIzxBNJttlqduJVcD6ragkf3NWHI+0gavLVvZwCAV+qBv7GkGFrXrBxJmThYd0es/7MMxILM4Dhhq/Rw+laRiIi3KHQEJMDksqGCyhdiAUJPExatqbp6giTep+ioRQqgFqFUCF3y8M7AfUmLezuAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756315876; c=relaxed/simple;
	bh=cXxFf40MPDViexLTcqO0ztrjyez1wiDGf0ZJBEGexao=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGTL2iWTeShh1sdKta9STfvVr2mGmzyT7XAjBKAutACs0hDzaLHWnHS8yvYpnuWtF8BJhrAVhv9MjkQZaczG9oBiaJwQX0TEo/zERHnEK6vWT3Aq1KWFE6mNDdEOSFB8NQJcCXem8tCRYN7lHsyU2f22oSIP160GC/jjRNjWMPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=tyR2QNtN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="tyR2QNtN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7677EC4CEEB;
	Wed, 27 Aug 2025 17:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756315875;
	bh=cXxFf40MPDViexLTcqO0ztrjyez1wiDGf0ZJBEGexao=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tyR2QNtN22RvMDohWgsRxKLr4FDC+++nmC+K23QB0czoCoV9wY0GfXKCx6P+xDtW/
	 ZpCPe49Yu4BqdPI9kZYDJxp4y1dzpN/OrQCtYTlfNu1SFTfGBjJCWlz5Qt0mJaoOCh
	 5V5ecyHf9IgmKtmyaoOZm47WjmTTPimv+CSUN+toJ2qxd00wwzRpzKoXwLJN0ao5eY
	 05XOUjLA/cCTP6ENn5rv5r59tJEoE3yfUjWqZiu6Go3M/yFqAVbfFtr4JVSlh5Sg5g
	 l4sD/2Ko33Vlga370ZkhPXbMhiaZy1lOsdYrovz/unS6m2srqvq3UJkAj3R73vKjyq
	 9Q78SHoGD+pHQ==
Date: Wed, 27 Aug 2025 18:31:11 +0100
From: Conor Dooley <conor@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev,
	patches@lists.linux.dev, Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 07/12] riscv: Remove version check for LTO_CLANG
 selects
Message-ID: <20250827-stick-duly-b40d7e90de1f@spud>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
 <20250821-bump-min-llvm-ver-15-v2-7-635f3294e5f0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9hV4SjGmbLMT0uH7"
Content-Disposition: inline
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-7-635f3294e5f0@kernel.org>


--9hV4SjGmbLMT0uH7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 02:15:44PM -0700, Nathan Chancellor wrote:
> Now that the minimum supported version of LLVM for building the kernel
> has been bumped to 15.0.0, there is no need to check the LLD version
> before selecting ARCH_SUPPORTS_LTO_CLANG{,_THIN} because it will always
> be true.
>=20
> Reviewed-by: Kees Cook <kees@kernel.org>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

--9hV4SjGmbLMT0uH7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaK9A3wAKCRB4tDGHoIJi
0nSUAQCDJ2G/cZdQFmAmDOl90XeIgL2nlWFCnq0Pv2BL+l+WwQEAlL0ORgY2kcgL
CJQL4AtmMpjkg5O2g+HksQ80QfPKFgo=
=KfEH
-----END PGP SIGNATURE-----

--9hV4SjGmbLMT0uH7--
