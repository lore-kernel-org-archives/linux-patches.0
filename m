Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C3831A055;
	Mon, 18 Aug 2025 13:05:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=82.195.75.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522324; cv=none; b=synoM59RuiZQJ7ReRh75ZYdfQUdkWyxDzR2VKv9AVjRwmGjlqoilmP2DpyAuqgjY3emjCg9Vw1ksQAXxvV90alWTdAukkNUem23XKbuG2PwhzPdPViNfkQXLLd6Gx3YasqCe7AIa/+5whxrCprtU9Jg3Pjp2A9OmzSpU/j9zCNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522324; c=relaxed/simple;
	bh=MNJU6Qcta8+PZ8QggXzoyOVUQxULJp5Bu2vDhdVEfQA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WY7jl7usOL8KiR3qtsfum6ODe9ve/sqTYq1mtP6PQodYRmtCEpxCZJJ/mkzbG8Y6zk4lKW2K4Fk9H59ia4J1RJ2VgYuZ1paLgVNC7Bf0fBwwplO9VR20OHTH0VkIFGSwbootUx1za/Bx9bXytvtjWHJK0oMiMiFasl7dz31Fc+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=none smtp.mailfrom=debian.org; dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b=hK4bQe6T; arc=none smtp.client-ip=82.195.75.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=debian.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=debian.org header.i=@debian.org header.b="hK4bQe6T"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:MIME-Version:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=jsoXS8QEN4FQYPEXivHVqF/AZdqGlgtgSF6PwHfwxl8=; b=hK4bQe6TWTFcKmbtshaaLhFQF5
	GMMp5x6fEVRZVVBlk35diT7Bp5q9CXFngpJL+ougSaOy78I25drQ9koY2FYXEZ3qmfHOHYHbFupKz
	NYWS5n5EnN2AxqHcE90KZbSbVjunJwo5nmRSpxnRnoZo0niSmSH+QwL+k23b9zBiclHc9bRpz7hef
	9DbzjAyYDhd78Jm811OJiU0gX9IvqSPtoKgvdvFpKxq2iE4wl1b66P6QDaudQMhPE9e2NXS5gN2+P
	k5h5h5xjrZruEwCkW6ailuCVqXQxRk8xg9hPgztAoU+KJgsRKH6AjbxcNpXmR9JBCtAi26I1Xoy6c
	xnTwRajQ==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <benh@debian.org>)
	id 1unzY8-007EDU-8o; Mon, 18 Aug 2025 13:05:20 +0000
Message-ID: <bb74920dd1047a596bf2bf0a389550ddcad54dfe.camel@debian.org>
Subject: Re: [PATCH 6.12 164/444] bootconfig: Fix unaligned access when
 building footer
From: Ben Hutchings <benh@debian.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, "Masami Hiramatsu (Google)"
 <mhiramat@kernel.org>,  Sasha Levin <sashal@kernel.org>
Date: Mon, 18 Aug 2025 15:05:14 +0200
In-Reply-To: <20250818124455.045136639@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
	 <20250818124455.045136639@linuxfoundation.org>
Organization: Debian
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-Bsxy03WHqJAxvmbpokvC"
User-Agent: Evolution 3.56.2-2 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Debian-User: benh


--=-Bsxy03WHqJAxvmbpokvC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2025-08-18 at 14:43 +0200, Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.
>=20
> ------------------
>=20
> From: Ben Hutchings <benh@debian.org>
>=20
> [ Upstream commit 6ed5e20466c79e3b3350bae39f678f73cf564b4e ]

Please drop this from all stable queues.

This uses the BOOTCONFIG_FOOTER_SIZE macro that was introduced by commit
26dda5769509 "tools/bootconfig: Cleanup bootconfig footer size
calculations".  But you shouldn't add that as a dependency, because it
will cause a regression for other configurations until
<https://lore.kernel.org/linux-trace-kernel/aKHlevxeg6Y7UQrz@decadent.org.u=
k/T/>
is applied.

If you prefer, I can provide a backport of this commit that doesn't use
BOOTCONFIG_FOOTER_SIZE macro.

Ben.

> Currently we add padding between the bootconfig text and footer to
> ensure that the footer is aligned within the initramfs image.
> However, because only the bootconfig data is held in memory, not the
> full initramfs image, the footer may not be naturally aligned in
> memory.
>=20
> This can result in an alignment fault (SIGBUS) when writing the footer
> on some architectures, such as sparc.
>=20
> Build the footer in a struct on the stack before adding it to the
> buffer.
>=20
> References: https://buildd.debian.org/status/fetch.php?pkg=3Dlinux&arch=
=3Dsparc64&ver=3D6.16%7Erc7-1%7Eexp1&stamp=3D1753209801&raw=3D0
> Link: https://lore.kernel.org/all/aIC-NTw-cdm9ZGFw@decadent.org.uk/
>=20
> Signed-off-by: Ben Hutchings <benh@debian.org>
> Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  tools/bootconfig/main.c | 24 +++++++++++++-----------
>  1 file changed, 13 insertions(+), 11 deletions(-)
>=20
> diff --git a/tools/bootconfig/main.c b/tools/bootconfig/main.c
> index 8a48cc2536f5..dce2d6ffcca5 100644
> --- a/tools/bootconfig/main.c
> +++ b/tools/bootconfig/main.c
> @@ -11,6 +11,7 @@
>  #include <string.h>
>  #include <errno.h>
>  #include <endian.h>
> +#include <assert.h>
> =20
>  #include <linux/bootconfig.h>
> =20
> @@ -359,7 +360,12 @@ static int delete_xbc(const char *path)
> =20
>  static int apply_xbc(const char *path, const char *xbc_path)
>  {
> -	char *buf, *data, *p;
> +	struct {
> +		uint32_t size;
> +		uint32_t csum;
> +		char magic[BOOTCONFIG_MAGIC_LEN];
> +	} footer;
> +	char *buf, *data;
>  	size_t total_size;
>  	struct stat stat;
>  	const char *msg;
> @@ -430,17 +436,13 @@ static int apply_xbc(const char *path, const char *=
xbc_path)
>  	size +=3D pad;
> =20
>  	/* Add a footer */
> -	p =3D data + size;
> -	*(uint32_t *)p =3D htole32(size);
> -	p +=3D sizeof(uint32_t);
> +	footer.size =3D htole32(size);
> +	footer.csum =3D htole32(csum);
> +	memcpy(footer.magic, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
> +	static_assert(sizeof(footer) =3D=3D BOOTCONFIG_FOOTER_SIZE);
> +	memcpy(data + size, &footer, BOOTCONFIG_FOOTER_SIZE);
> =20
> -	*(uint32_t *)p =3D htole32(csum);
> -	p +=3D sizeof(uint32_t);
> -
> -	memcpy(p, BOOTCONFIG_MAGIC, BOOTCONFIG_MAGIC_LEN);
> -	p +=3D BOOTCONFIG_MAGIC_LEN;
> -
> -	total_size =3D p - data;
> +	total_size =3D size + BOOTCONFIG_FOOTER_SIZE;
> =20
>  	ret =3D write(fd, data, total_size);
>  	if (ret < total_size) {

--=20
Ben Hutchings - Debian developer, member of kernel, installer and LTS
teams

--=-Bsxy03WHqJAxvmbpokvC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmijJQoACgkQ57/I7JWG
EQnXAA//d5Gug+WHpPIXhS+b9jFBFFu7qJ/7gdIGeps54tCVmfrDyTgDB1JS+b9A
+ni13BaBGWvcn9bn12rPlZjQcm5fiaKMnqhBv0ahOXyFhT+nD/2UQYHaiiihIkPp
4ZJCNtj86tIfZO1uA4ygYB5BwJPAjeuV8p5qxwaqqKK5NEZvposQMSyThVIMjMVo
uJy64ekP10G66vN5jLyHTzGp3BfwKwajLieQYeyCli9NYXruoGyGYzIZ/g0T4YmF
r1ZPmyt4T8uvH6JCbOkuJ90qxoh3PKPd03PY4QP4th0NNKNQs5q9bnzKNM1A6Xqd
4UVKqqFvAeI2+TA9D2nE20SpvYaWVupkBebigXQ3293bQbnBnRtX0LJyJzhoiuQY
T7kSw+GLpZc5ckRCuF58c4ru2keJSCymU76vhP7PczWa3WX2RF3Eo+J/Yl2AX0rn
faas2AdwZYlZkLjSQF10NmQtJNbKl0TALMxBVEN0d9Dso8W65ZDJ6nqiT2zkhcAJ
TrfUq7nAdjSKSkU/HeQISm98rrEke0bP3VkxKGCkuq7ai+hL4MPytdVSRtEW25JP
7zhyop3BAc29v7+jE/Mw8XF4rAximzdq0p+5TSL4ZSmQBLOq/JXPrd+vpzwh6wCu
85dVT/I5KPKmzZxXfR0Aa0Y7KdKI0kWFdwUXrm0xY+KOS+8vTSg=
=1mJg
-----END PGP SIGNATURE-----

--=-Bsxy03WHqJAxvmbpokvC--
