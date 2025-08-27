Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68619CCEC;
	Wed, 27 Aug 2025 17:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756315824; cv=none; b=qciDWN/cjiTGIEB3bF12tEXyc/QhjT3jkDPO8ks+HITckS2NpgD+neeA2+8PwPtjI9M91wxmbJTOt3iHpbLL+qp5pFW8AByR5myyTLbRVKfPQyv4+jB4ZzH0jW7YBZGSydx6SMvOtQBzOzI7206h18K4xYz6ZhOUK9AZA3J5t6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756315824; c=relaxed/simple;
	bh=Ldgiz2GuhClXg2UMzhvrhRQZw+hw5GM8cArSw82JF+8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fR1QXHBI33ni3ZMTQpiRtpHC5S8Rfezkgue0TDJ0EMeborhh5EUw1j3Mngf0+CNt7fWe0gtZhhxkP97R8WQDN9BoY7Z8KGYshZWBLRAN4ilrWQLwBNEyV+A4GX97Tltv8gHmoU/EAeXlPQu/W+CHD8NAY4ogouNNc041dhetvZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q0e/LOgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q0e/LOgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63903C4CEEB;
	Wed, 27 Aug 2025 17:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756315824;
	bh=Ldgiz2GuhClXg2UMzhvrhRQZw+hw5GM8cArSw82JF+8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q0e/LOgJd7QkDQDg3xUk1b/IonFPtKv3Ose5FChrXmLTxjK51M3zyyh58Z8sAsKe4
	 rtS2V9znGQBdhjPkmzmZX7yATlsMN8ckZSv1zfyPdluJnoUCdj4PLDJMC6tWnmZPxf
	 gwz0oDhhYiASTeJ+f1/KtZVGswWr1pQewyaLt4qMWQkPKvTI+YuwDgv4rJmi3jfNXa
	 Cc/QN2y3OnBX7/+bK4hKMCdI8eAz8H4vKpAa68rZpB4ae9K3DNS0VJ+G7k9gFCAt8l
	 DuJpbPyVh+FCGTteDib5L0UI2GMiDSakSb0kply6F0H6u3ijeSgjFMpb3ihjmIQ7oj
	 7WN+FwfS9Dq/w==
Date: Wed, 27 Aug 2025 18:30:20 +0100
From: Conor Dooley <conor@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
	Kees Cook <kees@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>, llvm@lists.linux.dev,
	patches@lists.linux.dev, Palmer Dabbelt <palmer@dabbelt.com>,
	Alexandre Ghiti <alex@ghiti.fr>, linux-riscv@lists.infradead.org
Subject: Re: [PATCH v2 09/12] riscv: Remove ld.lld version checks from many
 TOOLCHAIN_HAS configs
Message-ID: <20250827-unvalued-imprison-3ce3ce4275b4@spud>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
 <20250821-bump-min-llvm-ver-15-v2-9-635f3294e5f0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="R5mG8D6tas3Pwbly"
Content-Disposition: inline
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-9-635f3294e5f0@kernel.org>


--R5mG8D6tas3Pwbly
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 21, 2025 at 02:15:46PM -0700, Nathan Chancellor wrote:
> Now that the minimum supported version of LLVM for building the kernel
> has been bumped to 15.0.0, several ld.lld version checks become
> tautological, as they are always true. Replace them with a simple
> CONFIG_LD_IS_LLD check.
>=20
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Reviewed-by: Conor Dooley <conor.dooley@microchip.com>

--R5mG8D6tas3Pwbly
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCaK9ArAAKCRB4tDGHoIJi
0invAPsG/JWS08f2B17slnzm+vAHqLKU1mIw4NastP78Wr2ZoAEA6h2+WO0ujNy5
0Vb5WxYNkKBy6X/GNAseBfozgSuxpAA=
=6SKS
-----END PGP SIGNATURE-----

--R5mG8D6tas3Pwbly--
