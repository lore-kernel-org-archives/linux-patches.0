Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C8B813C8FF
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 18:39:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752604744; cv=none; b=KIZvjTiunWexxrN46Z61M+dOGv4yJDZeVw02xNriN3fr4T249irDtFdA4bt97oE8IZjZvRtm53ER6cfbIkNSMOQ2LNlV8K9vLdJU2SNgUJpiqS+UD7/w88H2NAq88DoefeiLhlztyzzDSVft55rC/RwslP6PRZYAco24b760z2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752604744; c=relaxed/simple;
	bh=I8L3ew79X5CSvq+s/7n8cEYRMDXbbDNRkMsVvRH9Jfg=;
	h=Mime-Version:Content-Type:Date:Message-Id:Cc:Subject:From:To:
	 References:In-Reply-To; b=drzud+0Z0gK4E+m4/G+Kh2yoM+WDgGd3gL9EWgPQXs4Js7qhgmB5oEz2mKCgdM0H8Scg7mjavGRaKKH0l5reP1k6fNuwTV9JUt4FqOKvSFs3ziItPVWQW968jcra5rBhPoquexIaUImyFJImtbaSDmZxWJRsQ9kIwPRjIiDnB5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=BS9Nq68f; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="BS9Nq68f"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-2efdd5c22dfso3151344fac.3
        for <patches@lists.linux.dev>; Tue, 15 Jul 2025 11:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1752604742; x=1753209542; darn=lists.linux.dev;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=80i78qYt3Pv+lypvP3B4IMlSZ1afCERVWEA7YyAzlDE=;
        b=BS9Nq68fqfDpYLvFk1mG/FXrT/7ZkdcMZI/TqldsBHqz28wX/wUwZOlZzovP1TGbWU
         fBZ5+pDkjQlfwFkwR6Ct4EY8xCGcn8emZuArRYVYf4FYH0Y0qZexEPsMVnXFXgVFfvLB
         8Okd9w9kM0SYZxyrNAe5XE/+8x4h3PuUn0oCunTpsZRw2IjZE1jmKdw7Tbg7zTKY9X+y
         zYN2TjHTvH3nerdMLVTQHyuhXj6iwbMXEWsbN9yZY7KZMqDHNJW1tCx6UHXt59/hgSJY
         V2xBaCFrVBCvIyH6xG8+oS2nzYex8Us79MKHLN6Dwa2QX6Fks1hZ94ySmcoY+ZqfLKwa
         ls5A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752604742; x=1753209542;
        h=in-reply-to:references:to:from:subject:cc:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=80i78qYt3Pv+lypvP3B4IMlSZ1afCERVWEA7YyAzlDE=;
        b=o2qRW1mnMtOVSlagwT+SF4+T5zcYAvLM+7PBHufi+lpbB+Exw5OegXXQCmm5AOWAyv
         37TJQ903krqQkLRhKFj2bI1Pvp6NJLgOLVxw5J8QtRF1zgBttfUQbOb91E/aS8VSxmiW
         0KWwKgtF5F/XtxsTF587KBgC2lXm/rsqmfenQXHObmA8X4sWg9lArIw0IPkfVbb7t26x
         /xGYroYRsK6u6JhumV8RUr7JV300xoDlMuzumKRDRpU2u2noLViZIITM6b95BwO/T6DX
         +V7rjfTunNH2gdtCgbactnbajld/iHNl6ApuPLk9LEipqZfE/dZFanbES93xEEPRstev
         +OfQ==
X-Gm-Message-State: AOJu0YyphBlnm3izPZpN4dyEmVgiQeIMFaI5t1eTRI+jlVOfFX9FdT76
	SN+l1UEcmODQbL1DXrLiOyg8hxNoGI+b7NSsdSh6WuEVP2d3Rn0TcZhE
X-Gm-Gg: ASbGncuHexxIsOKeaXIl6JRcLAIJsEHfHbCkrhafRyTy8LjGQQx1IDixcz904193sSl
	yffImZg1QuLSdWZK04dMaVBPEc6ZvPaVb8lSyA+JhmjSfR4HKos+0HUHx68XalChymDKYmOswW8
	lYEesQoUVEBMk5x0wfZZaNBTEvVOIYLICOF8+nJ7zx1zckvPkSEIopolp7GQLuqiAysQ9F9/wG0
	XwTKndY3MMySoP5Y79rxpQInL13R21SNwYEr9yNm2TEyaSddjxNEubG+amhD5PjmDzKfD0+fKYC
	j79Q3YWLTWv5VuFtDTFvLgUOBWrwl02ADQCcfCOwybuyP88oZi60CduL9ysBFRXuvGawF94sepH
	F2LAnLv+e7IYDBXA=
X-Google-Smtp-Source: AGHT+IFY86/4L9JmlcJO5FaTpJNoLzHbjQg+twhXtC3EPeJbMGjfusO5WXBfvalsGk/8tcQcciHr9g==
X-Received: by 2002:a05:6871:529a:b0:2d4:ce45:698d with SMTP id 586e51a60fabf-2ffaf235f3amr542268fac.4.1752604742003;
        Tue, 15 Jul 2025 11:39:02 -0700 (PDT)
Received: from localhost ([181.88.247.122])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2ff116d68a8sm2830718fac.38.2025.07.15.11.38.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Jul 2025 11:39:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: multipart/signed;
 boundary=acc470c6f884e867562e65ba2487d89062f142533239f6b3138001d72221;
 micalg=pgp-sha512; protocol="application/pgp-signature"
Date: Tue, 15 Jul 2025 15:38:58 -0300
Message-Id: <DBCUJ1QHGTKA.3H4TW1FB3FYJC@gmail.com>
Cc: <patches@lists.linux.dev>, "Mark Pearson" <mpearson-lenovo@squebb.ca>,
 =?utf-8?q?Ilpo_J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>, "Sasha
 Levin" <sashal@kernel.org>
Subject: Re: [PATCH 5.15 53/77] platform/x86: think-lmi: Fix sysfs group
 cleanup
From: "Kurt Borja" <kuurtb@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
 <stable@vger.kernel.org>
X-Mailer: aerc 0.20.1-0-g2ecb8770224a-dirty
References: <20250715130751.668489382@linuxfoundation.org>
 <20250715130753.855799519@linuxfoundation.org>
In-Reply-To: <20250715130753.855799519@linuxfoundation.org>

--acc470c6f884e867562e65ba2487d89062f142533239f6b3138001d72221
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8

Hi Greg,

On Tue Jul 15, 2025 at 10:13 AM -03, Greg Kroah-Hartman wrote:
> 5.15-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------
>
> From: Kurt Borja <kuurtb@gmail.com>
>
> [ Upstream commit 4f30f946f27b7f044cf8f3f1f353dee1dcd3517a ]
>
> Many error paths in tlmi_sysfs_init() lead to sysfs groups being removed
> when they were not even created.
>
> Fix this by letting the kobject core manage these groups through their
> kobj_type's defult_groups.
>
> Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support =
on Lenovo platforms")
> Cc: stable@vger.kernel.org
> Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
> Reviewed-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Kurt Borja <kuurtb@gmail.com>
> Link: https://lore.kernel.org/r/20250630-lmi-fix-v3-3-ce4f81c9c481@gmail.=
com
> Signed-off-by: Ilpo J=C3=A4rvinen <ilpo.jarvinen@linux.intel.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/platform/x86/think-lmi.c | 35 +++++++++-----------------------
>  1 file changed, 10 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/platform/x86/think-lmi.c b/drivers/platform/x86/thin=
k-lmi.c
> index 36ff64a7b6847..cc46aa5f1da2c 100644
> --- a/drivers/platform/x86/think-lmi.c
> +++ b/drivers/platform/x86/think-lmi.c
> @@ -491,6 +491,7 @@ static struct attribute *auth_attrs[] =3D {
>  static const struct attribute_group auth_attr_group =3D {
>  	.attrs =3D auth_attrs,
>  };
> +__ATTRIBUTE_GROUPS(auth_attr);
> =20
>  /* ---- Attributes sysfs -----------------------------------------------=
---------- */
>  static ssize_t display_name_show(struct kobject *kobj, struct kobj_attri=
bute *attr,
> @@ -643,6 +644,7 @@ static const struct attribute_group tlmi_attr_group =
=3D {
>  	.is_visible =3D attr_is_visible,
>  	.attrs =3D tlmi_attrs,
>  };
> +__ATTRIBUTE_GROUPS(tlmi_attr);
> =20
>  static ssize_t tlmi_attr_show(struct kobject *kobj, struct attribute *at=
tr,
>  				    char *buf)
> @@ -688,12 +690,14 @@ static void tlmi_pwd_setting_release(struct kobject=
 *kobj)
> =20
>  static struct kobj_type tlmi_attr_setting_ktype =3D {
>  	.release        =3D &tlmi_attr_setting_release,
> -	.sysfs_ops	=3D &tlmi_kobj_sysfs_ops,
> +	.sysfs_ops	=3D &kobj_sysfs_ops,
> +	.default_groups =3D tlmi_attr_groups,

I did *not* author this change and it utterly *breaks* the driver.

This patch should be dropped ASAP.

--=20
 ~ Kurt


--acc470c6f884e867562e65ba2487d89062f142533239f6b3138001d72221
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSHYKL24lpu7U7AVd8WYEM49J/UZgUCaHagRAAKCRAWYEM49J/U
Zk3ZAP92t38XQIYRJWuljb68R76QUHIpl0O6hNcW/vqrjw+c+AD+IM+NEeAczSX3
73Y71kPT8UV5dZEyGtXL74YO1AJaAQI=
=gIcr
-----END PGP SIGNATURE-----

--acc470c6f884e867562e65ba2487d89062f142533239f6b3138001d72221--
