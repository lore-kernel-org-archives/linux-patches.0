Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [65.21.191.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1EE32D1F61;
	Tue,  9 Dec 2025 15:23:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.21.191.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765293791; cv=none; b=SfjacWaMBTRoNYscn1XhBt0ysVgwygUr7S6ib42BjiBAmPGZfiQAulJHFf6ThxwtJoICk6H9aBzl+KuKyxvnBy8OzkcIShkFYuK2rzZroMdE1KVo/b37THLhgqV2JkrcYdcB4aUZLwnNZqHIOTm3MBAb1q3zoMTmM1RA/Dk1xSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765293791; c=relaxed/simple;
	bh=Nviqoko1YTJNEi7jpb7zeEavGZgIiEU9EJ79SiIxsg8=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=lVfKBSH4mqGeXLrD0R5SX5aI7YO55/MhmrfxJ3g6CmmgC7k/BiYZmSLCCTL0wUKisOHPp/c9jhP0xHOq5u6blCY4ykBg3Y7ii18NNhkLk29Ty7VJwHZPrIOk49EfTOb+C2imZqTAyxIoPKiEG8zzt2LE8n9B2tPw69mKMaGseRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk; spf=pass smtp.mailfrom=decadent.org.uk; arc=none smtp.client-ip=65.21.191.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=decadent.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=decadent.org.uk
Received: from [2a02:578:851f:1502:391e:c5f5:10e2:b9a3] (helo=deadeye)
	by maynard with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.96)
	(envelope-from <ben@decadent.org.uk>)
	id 1vSzYJ-006qRQ-1B;
	Tue, 09 Dec 2025 15:22:59 +0000
Received: from ben by deadeye with local (Exim 4.99)
	(envelope-from <ben@decadent.org.uk>)
	id 1vSzYH-0000000050L-297W;
	Tue, 09 Dec 2025 16:22:57 +0100
Message-ID: <b052b71589bb576dcad441eba38c20da81443a46.camel@decadent.org.uk>
Subject: Re: [PATCH 5.10 117/300] selftests: Replace sleep with slowwait
From: Ben Hutchings <ben@decadent.org.uk>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, David Ahern <dsahern@kernel.org>, Simon Horman
	 <horms@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Sasha Levin
	 <sashal@kernel.org>
Date: Tue, 09 Dec 2025 16:22:52 +0100
In-Reply-To: <20251203152404.953619835@linuxfoundation.org>
References: <20251203152400.447697997@linuxfoundation.org>
	 <20251203152404.953619835@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-o3/RuO6I71OSht6BNykS"
User-Agent: Evolution 3.56.2-7 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 2a02:578:851f:1502:391e:c5f5:10e2:b9a3
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false


--=-o3/RuO6I71OSht6BNykS
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2025-12-03 at 16:25 +0100, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: David Ahern <dsahern@kernel.org>
>=20
> [ Upstream commit 2f186dd5585c3afb415df80e52f71af16c9d3655 ]
>=20
> Replace the sleep in kill_procs with slowwait.

The slowwait function isn't defined in 5.10 (or any stable branch older
than 6.9).

Ben.

> Signed-off-by: David Ahern <dsahern@kernel.org>
> Reviewed-by: Simon Horman <horms@kernel.org>
> Link: https://patch.msgid.link/20250910025828.38900-2-dsahern@kernel.org
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/testing/selftests/net/fcnal-test.sh | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/tools/testing/selftests/net/fcnal-test.sh b/tools/testing/se=
lftests/net/fcnal-test.sh
> index 806c409de124e..2f5cdbc5dee39 100755
> --- a/tools/testing/selftests/net/fcnal-test.sh
> +++ b/tools/testing/selftests/net/fcnal-test.sh
> @@ -183,7 +183,7 @@ show_hint()
>  kill_procs()
>  {
>  	killall nettest ping ping6 >/dev/null 2>&1
> -	sleep 1
> +	slowwait 2 sh -c 'test -z "$(pgrep '"'^(nettest|ping|ping6)$'"')"'
>  }
> =20
>  do_run_cmd()

--=20
Ben Hutchings
It is easier to write an incorrect program
than to understand a correct one.

--=-o3/RuO6I71OSht6BNykS
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmk4PswACgkQ57/I7JWG
EQkoShAAilGiOMO76vdkgTjQVaYoTg92YQpeCovSMVNnUzgryHaVdOJK3sYylorK
WE5lxzdK3FYnSK5G9Vga89oyagiKQOa6dFEd6i15Qg6xOkXf+RHHJEkl6s32zY7P
lp4seDf0BZeuI0rXD2CyLTsqylpEq02SikpEtrgPFdEWJB/mIUajs93ABi+nM9oI
lvXf+A47itUdHEEmlXcHnOFrm3e41Xza4C/Mz4Yc0ItLUjQzYwOHGU+fYl4o5p+Q
Lzx/QsUAmpTSozw5wJEKBLesGLaakbAw/7Gw09B5oNewxFLbdhXZOntrks2rvWL8
+OrbgtuxTcSXVlm0q+cqrNJ/sH033YsKOBY+YyMiHDWt5mIYkRqV36gqndBjhWXh
2vBagf9M9/FSosCu3OtPT3YTByP/Nud8PQvG85LGWvU2/pHZG7olE01ksvKr+bSA
4pTPcD96W0Jas90OXbJP87ZzlTwtGBBE8A+PnnL3xRpNoLdGZGssLf6YEj0JIWL3
PwZt9mrR4ANYjLerdusF0yCCCRhEJx5yJ+N1f5k3xWUABWJCz4mLPIU8y92Xk5zL
Bj+7Yjz3PxDYWdjTKCCekB6T+Gd3aJIm+ZotEhrD6mTRAiQ12bzlPSTiKIcO5bxE
3RoXSEPvfWwrKjowovEXOZeKc7Pom9Xg74v3F+RURMlVQ/3KEgo=
=btXZ
-----END PGP SIGNATURE-----

--=-o3/RuO6I71OSht6BNykS--
