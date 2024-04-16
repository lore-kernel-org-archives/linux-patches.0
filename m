Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D2ED1AACC
	for <patches@lists.linux.dev>; Tue, 16 Apr 2024 03:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713239466; cv=none; b=jRQK9+lk8FwQE4HOW6F5ISU/l+j6qowM+N6NTxFGUYHtt91VhqBYhCJkPgfwo/fSGnqK26YJd7zsMV9OfHQRJQfVv0WJr9E4oJc2uFbx1XddPGX512uTkkwCWDAG/J8pevtRkb0C4LcT55YV5bbL5n3GPn0CVu4EotEtJrUT9Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713239466; c=relaxed/simple;
	bh=P3DgkQW2viOoJBU4pbfa0M0RG2Gxai3iYNRUNy6jYiI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VlTROvmSKV/uXrcICytUjm+5AS07Wu8F7dm3a9n4VRpmzxmYVVLDQ0t5y/PGL2Ewe2FbLYZqwTGcgzJV45O93RDYzOAMKoOkqgv04PMo7FmTbPNCcUJ96fI3+dOkZqHe2ck37pPVzuggd+ZnEKAshZoZ4ZND8jPK6+c9OQ/9aXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=msOBO+dL; arc=none smtp.client-ip=209.85.210.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="msOBO+dL"
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-6ecf1bb7f38so3611927b3a.0
        for <patches@lists.linux.dev>; Mon, 15 Apr 2024 20:51:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713239465; x=1713844265; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LX6FHcjjwFTUVDd7n7O9sbio9XsGH+ecRXrlK3mp8Zc=;
        b=msOBO+dLDrRuipBeBC+NxMuAAbaISXR6rtehIbnm8CKKcW9xFfHmrPGL7cstm9LMcs
         DqfhGPZJOUCH4WzK5fUMTVgQGJF7L34JSYvjCigXU5NRp284aDvcqJnXWexbHDp9F9OM
         9wBHpUaeO2rX8+Dm0PQkxVb4NDZ/KvXaYEkzoTkDeNDMzR5i9ZGxuQPIvEKxdDKYeigh
         DzScm30QVdHToiMfTnVpRKEYZuzmeZLymgoeBJEtBs8CAoKE06doByuaAXI9MmrU2SPv
         m2rtey9KWgSriW/Eafonuq7Oo8d4Ayh91o6p1XK+av1gOvJ437gQYGRIQeJR+JiWOn3M
         phzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713239465; x=1713844265;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LX6FHcjjwFTUVDd7n7O9sbio9XsGH+ecRXrlK3mp8Zc=;
        b=sogqxLxiaUpuDGlUqebzyF72z6l4UmaapxZAqoUl18MnAWkYKrHrncRJzPehquAq+q
         jgrMKhs81gITzDD3wBjPuTSbh/IdWAfF4LyLXy+UDsAyz6HHkZbw0YsaZYIFg2eN3JGy
         CmwRVDaeZ+HdBkTj8cmG9YKoxei1iYHurkAjFJySZCdKvQnE0oamIHLLReFL/DFQUYf4
         qww+QP5/p8YdgkGwGJYEjHguIxGgS5JT7BDBIIcoIrQXHRXMK3+AF/8+fNQMgl3ta6Lk
         /viMzMPj7hNnV6+WQj0IjuD7MCL3Zximu7I7BhcU7jH1rqDZz+lRdfIF2CbwKVH0g3u6
         SZPg==
X-Gm-Message-State: AOJu0YwWLyfCiu5+8c8THegLblOnc8e5SccrncFuL5XPsvZZEfXx4UyA
	LYjgbAD4/DPtmcUG5TS7Wo/4H4uuqj5+58QV0MXZMorTxsIE5zkl
X-Google-Smtp-Source: AGHT+IHIur0c/TCXoYlr0j9DqqPmSFovFafZ1KQCTrbsQscWzuSEF4tIRIwDOI4jCfxvICVPtlcCBg==
X-Received: by 2002:a05:6a20:a11d:b0:1a7:7bc4:e214 with SMTP id q29-20020a056a20a11d00b001a77bc4e214mr13044628pzk.7.1713239464787;
        Mon, 15 Apr 2024 20:51:04 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d15-20020a170902654f00b001e41ffb9de7sm8879005pln.28.2024.04.15.20.51.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Apr 2024 20:51:04 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 00DC118462BAB; Tue, 16 Apr 2024 10:51:01 +0700 (WIB)
Date: Tue, 16 Apr 2024 10:51:01 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 000/172] 6.8.7-rc1 review
Message-ID: <Zh31pTGbTkN5A_zN@archie.me>
References: <20240415141959.976094777@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="r4y4EijudvVppG+6"
Content-Disposition: inline
In-Reply-To: <20240415141959.976094777@linuxfoundation.org>


--r4y4EijudvVppG+6
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Apr 15, 2024 at 04:18:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.7 release.
> There are 172 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--r4y4EijudvVppG+6
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZh31oQAKCRD2uYlJVVFO
o7seAP9e5X80kS3O8QipkMOoSbj5a1jfjVB3NhT/xShO30X1hwD/bks7sFKdi4Z8
Xt9hnaUWGfpfLmF7zn11EwHPE/5YWQk=
=oNVo
-----END PGP SIGNATURE-----

--r4y4EijudvVppG+6--
