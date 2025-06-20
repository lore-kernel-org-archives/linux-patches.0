Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17393289E05
	for <patches@lists.linux.dev>; Fri, 20 Jun 2025 11:12:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750417959; cv=none; b=gKgIEFtaOncgyVFLRyTaXNMinXs7phRwNdcRF1K7ms4cVbzQHjjYCXioo2IsmYnFFFK9KlpkWXQeqKXaZO+XbswQqZxoYtJYp6MgtYHJAk/sg44Jklpg8dRUXLpxDzEFysXCbcdfs1Pvbfm2oh14B+xCP3LYpJFihb4G6Th8iGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750417959; c=relaxed/simple;
	bh=SyiNu3Ob3L60e73AaxuCkOg2fa6bO5VsriKl0+zBk7w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvS+8Zhjn9d8o4RlodpIp2UlGOHPA4vkUfm0tzxjGtPv3LZq+IaNRaIuWEsTh1RIZM0SXGxrY5pCNMMqfLjrRgCaSWQTjfE89y4LooZ1d2YjTP7jG8Z0kmiVBVIMsfXb38LUF7K6vjpxFybZxi6FeqXg2xvg2P4VveS4UD3uPDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=RC53chOb; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="RC53chOb"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 16CAA104884A8;
	Fri, 20 Jun 2025 13:12:33 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1750417956; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=dIN4rVjoLDyX/x9WQKi4XWTSKbdre1w+oADZZlm0n3Y=;
	b=RC53chObsZcZb2o5E1IVRMMBjhKlfDW0cz4hF+JYu9qdqOIEPq73lXPRULalFE1nl2VWNM
	4Jw1CkW8MqPV5RwEy4VZKpfsc+xineXs5HpyTwD6OnkB/fH81axMinr6/VzhKnYOpS3cBT
	lkvU0yIT7IhC1UeyrbNnyB/xI9XwHLZItc5NXZ/MaJl5UxOeFOAK9rcy0l+OCsY3xTeuMT
	l0eE7aAlPsfJG9aTdKqqUW2KP7TI0GRjfiKsHu9+kWj9W/PtCbUcdH6GsNNIVyNzzNZLyz
	Fo4ouWtOomiu6Uqtt2luBC7qoJLCuHc+PvkKLJ9yx9RztCnf7Aq0413N7p2bQw==
Date: Fri, 20 Jun 2025 13:12:31 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Zijun Hu <quic_zijuhu@quicinc.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 471/512] fs/filesystems: Fix potential unsigned
 integer underflow in fs_name()
Message-ID: <aFVCH8CeAEDY2oEj@duo.ucw.cz>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152438.664510685@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T8rYKFgKcQuMsP8R"
Content-Disposition: inline
In-Reply-To: <20250617152438.664510685@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--T8rYKFgKcQuMsP8R
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> From: Zijun Hu <quic_zijuhu@quicinc.com>
>=20
> [ Upstream commit 1363c134ade81e425873b410566e957fecebb261 ]
>=20
> fs_name() has @index as unsigned int, so there is underflow risk for
> operation '@index--'.
>=20
> Fix by breaking the for loop when '@index =3D=3D 0' which is also more pr=
oper
> than '@index <=3D 0' for unsigned integer comparison.

How could it underflow? for (..., index) already means we break the
loop. I don't see underflow possibility.

BR,
									Pavel

> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
> Link: https://lore.kernel.org/20250410-fix_fs-v1-1-7c14ccc8ebaa@quicinc.c=
om
> Signed-off-by: Christian Brauner <brauner@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  fs/filesystems.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
>=20
> diff --git a/fs/filesystems.c b/fs/filesystems.c
> index 58b9067b2391c..95e5256821a53 100644
> --- a/fs/filesystems.c
> +++ b/fs/filesystems.c
> @@ -156,15 +156,19 @@ static int fs_index(const char __user * __name)
>  static int fs_name(unsigned int index, char __user * buf)
>  {
>  	struct file_system_type * tmp;
> -	int len, res;
> +	int len, res =3D -EINVAL;
> =20
>  	read_lock(&file_systems_lock);
> -	for (tmp =3D file_systems; tmp; tmp =3D tmp->next, index--)
> -		if (index <=3D 0 && try_module_get(tmp->owner))
> +	for (tmp =3D file_systems; tmp; tmp =3D tmp->next, index--) {
> +		if (index =3D=3D 0) {
> +			if (try_module_get(tmp->owner))
> +				res =3D 0;
>  			break;
> +		}
> +	}
>  	read_unlock(&file_systems_lock);
> -	if (!tmp)
> -		return -EINVAL;
> +	if (res)
> +		return res;
> =20
>  	/* OK, we got the reference, so we can safely block */
>  	len =3D strlen(tmp->name) + 1;

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--T8rYKFgKcQuMsP8R
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaFVCHwAKCRAw5/Bqldv6
8n7lAKC7FRBlstoy31b/pVdxKNB/E8GvOQCfS0vCPsnSewe9fB25XvyjTWMcyqI=
=YoLX
-----END PGP SIGNATURE-----

--T8rYKFgKcQuMsP8R--
