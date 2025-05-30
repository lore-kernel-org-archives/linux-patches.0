Received: from mx.denx.de (mx.denx.de [89.58.32.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D68C221284
	for <patches@lists.linux.dev>; Fri, 30 May 2025 09:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=89.58.32.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748598312; cv=none; b=iM9oxFY6IVBwYTJvBRKTh2AhZa0p442Vlz/VFDD5IHN83IOoS6YjiJimerILPMBAlvtZJvZlCA86xxAw9xIj9a02J6Im90W9O9tRk9UjX0+lNJgIecYtIx1y6Ru0mr2ayp9hsM5V1pw/eVIBmFm60r0hkO4YNagiCv+H5fyXXCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748598312; c=relaxed/simple;
	bh=/bwLqV5nASs6+DMIfTcq7Odcwj7oCElg9hXNBgJoEl8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h9X8gusHyHfsJvstT+YAou3U4NR1CPppCCHI/AGZ0x5TNEnLCcFnLs3gVaXWlYSrFB/7Ocgid457JYIJKmwSLE5VP/QpImJmv/QglBZDFheQFYCQ53zulC2ogQxBH7yWRjH5ZRIAVUXKf/KPqEzE5UGonZqxL/Mtf/1DP7DVb/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de; spf=pass smtp.mailfrom=denx.de; dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b=PhcoiNFo; arc=none smtp.client-ip=89.58.32.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=denx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=denx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=denx.de header.i=@denx.de header.b="PhcoiNFo"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 24C681039728C;
	Fri, 30 May 2025 11:45:06 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de; s=mx-20241105;
	t=1748598308; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 in-reply-to:references; bh=5NyYSu0VsjViCLvFMlfnuq52JsypRQEOct85mrveSWc=;
	b=PhcoiNFoCrFxwcalUpIQGnOoB2rC21FZEinzBM/s/+z4S+4s35xQ1ySKo33XPDwRCT5Sg5
	Difef93Z0zZydNmOA5VESpYl9sYkJbl1AyoMriKHgEI7avbUq081XMGhVldIE5cpEupzEW
	UUw2exOeaecOdGavrdjxCPZNbFzs2XQe5VkRc3jaLecnYCP6frrpQpd4d/7bY7x7vHe/bb
	bxVSYencFezkIfxOI3WvP7M6D4Bt+wD3q/EMLaQokp64KYTotH4X5rsLUQuBEfQipeHLi0
	5RQ1ovuRNVp1/9P8WPhiqB75SP317qIV4zjAQ2laqgni+e+LEwhhD3+QMcxiBw==
Date: Fri, 30 May 2025 11:45:04 +0200
From: Pavel Machek <pavel@denx.de>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 063/626] mailbox: use error ret code of
 of_parse_phandle_with_args()
Message-ID: <aDl+IKOLgLDMnwuK@duo.ucw.cz>
References: <20250527162445.028718347@linuxfoundation.org>
 <20250527162447.617855509@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2ys/RvCLxvhIrmns"
Content-Disposition: inline
In-Reply-To: <20250527162447.617855509@linuxfoundation.org>
X-Last-TLS-Session-Version: TLSv1.3


--2ys/RvCLxvhIrmns
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi!

> 6.12-stable review patch.  If anyone has any objections, please let me kn=
ow.

"Less precise error code" is not "serious bug".

Best regards,
									Pavel

> ------------------
>=20
> From: Tudor Ambarus <tudor.ambarus@linaro.org>
>=20
> [ Upstream commit 24fdd5074b205cfb0ef4cd0751a2d03031455929 ]
>=20
> In case of error, of_parse_phandle_with_args() returns -EINVAL when the
> passed index is negative, or -ENOENT when the index is for an empty
> phandle. The mailbox core overwrote the error return code with a less
> precise -ENODEV. Use the error returned code from
> of_parse_phandle_with_args().
>=20
> Signed-off-by: Tudor Ambarus <tudor.ambarus@linaro.org>
> Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/mailbox/mailbox.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/mailbox/mailbox.c b/drivers/mailbox/mailbox.c
> index d3d26a2c98956..cb174e788a96c 100644
> --- a/drivers/mailbox/mailbox.c
> +++ b/drivers/mailbox/mailbox.c
> @@ -415,11 +415,12 @@ struct mbox_chan *mbox_request_channel(struct mbox_=
client *cl, int index)
> =20
>  	mutex_lock(&con_mutex);
> =20
> -	if (of_parse_phandle_with_args(dev->of_node, "mboxes",
> -				       "#mbox-cells", index, &spec)) {
> +	ret =3D of_parse_phandle_with_args(dev->of_node, "mboxes", "#mbox-cells=
",
> +					 index, &spec);
> +	if (ret) {
>  		dev_dbg(dev, "%s: can't parse \"mboxes\" property\n", __func__);
>  		mutex_unlock(&con_mutex);
> -		return ERR_PTR(-ENODEV);
> +		return ERR_PTR(ret);
>  	}
> =20
>  	chan =3D ERR_PTR(-EPROBE_DEFER);

--=20
DENX Software Engineering GmbH,        Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany

--2ys/RvCLxvhIrmns
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCaDl+IAAKCRAw5/Bqldv6
8o8PAKCN/TmCNrnIBRB569HRi/wqRsBXFgCeILxPJ7aMU85kkkB0PTSZAXRAKu0=
=t9ga
-----END PGP SIGNATURE-----

--2ys/RvCLxvhIrmns--
