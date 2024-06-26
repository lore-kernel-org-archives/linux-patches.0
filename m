Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7C08134DE
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 02:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719369302; cv=none; b=D8FxR1Y9sC05iY+YD63Jj8rDyMbpWM5xg7t5BT8j0DiNe5oZfJnI89ENb/RlzB2ZJAYPY1CCTe8GRMFqxXxph9rTOCRQrAOZ3ZIi2zG4nXFRgzHedgNHzJxpDw7ZjEE1d8+CDhBHOJUct/yI5DD21RpFmFoyQG9oH1/kJOZ/rL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719369302; c=relaxed/simple;
	bh=4Vjb2tHyAUUYGbzlCwqawkkir3yBKn8Rbhng8N62OCY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lqFpqwXxvR3EQZA4yeaHI4/7SwH/MPzz7Zy0kSyNzhdGTq55ZpISck+rUsDGsh1DJFHwUuRtd5t0FyI6kJw3Owo0c12NNumCm4h88xFMvYeTUm44/CSDEUnuj+fXevrr2t9S74dehcZJ1lOPcTFzHqWs3r6ZFFQhygSxW/lNMyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Dx3fbw1v; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Dx3fbw1v"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-1f47f07aceaso48689595ad.0
        for <patches@lists.linux.dev>; Tue, 25 Jun 2024 19:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719369300; x=1719974100; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=7ZWF9nN2QXFvBke0Huzd6wFb2kCuu+RIdg7vyQmFklI=;
        b=Dx3fbw1v6u1jJJwfkzF3BkQCsxl/KBgoYli7qXHDf/sP8CIYZsT/G+xBHVkMkKx1es
         BCNKgqqeEph24tbxp6mi0MSrQBzc++YLD3Tseb00r23vEp+0r5a5qdzPtGvtJB1zAdWX
         f6IWraGkYlHIiZwUdTQEy0p0N7tGyKdxN0EfHDzr1AQTnsmVK08W35KfldqiHPpaGplx
         zsZl6ePyyLrJPDe/7UUCbEbeLUF/2EjNNU4fWIm30hRqZtyTw22c38BWOJksDDmYkZj6
         GT1Vv2jZQRd6/M6cb4UzJ7o9G+uNcVYKrZdS+xC6lynd1/SHC7wpM88JfEFZuVJzoCAL
         8A7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719369300; x=1719974100;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7ZWF9nN2QXFvBke0Huzd6wFb2kCuu+RIdg7vyQmFklI=;
        b=cykrSs+LqHHY0y9uP1PAZwPvdstNmV/JhxUlWLb0zRdi69+uhYpCXZ9yXnzbjknF0y
         pXnGl3coka9gAGvjGPbwBAaSVgARKcwsLHElEG9jtovyJipTzKHlnhh8hq1lVVf3qpGY
         yjOCPylG5epP+bCMpxoar+Wy82E0+upvdoR0zmUbLU4FZ3XOXXOjfKeeIJkwNLRBc8kL
         jOULsGqCrvrpAALpCbOPqaHtkc5+hQGz9GvCN7aYGtEgztTdMJnnmQqFhbNZkzWX8faK
         +zghs0sIYYZNM1yF/Vc4PpN7yLNt3IiIKUb6yxzTLj+OssA0tyxxybPvC7dQF6WJo6pu
         Twzw==
X-Gm-Message-State: AOJu0YzenuwmB8q9ZO/X06F7fIgcCzi6FZMuLZTF4zWyFFRYsQGnZvYk
	0Rg03xnYUu4O8GrLWG9vws+mPYHOc/rbdb4RtOVSI7Qu6hBdxdBl
X-Google-Smtp-Source: AGHT+IE5bYlswtKZymD8Gik2xErljLWxchhQv4CRUjhtZluoHqQo6z6WaSKQDizibqrINp0ODzbR8w==
X-Received: by 2002:a17:90b:3ec3:b0:2c2:d163:d761 with SMTP id 98e67ed59e1d1-2c85067faa2mr7154675a91.47.1719369300032;
        Tue, 25 Jun 2024 19:35:00 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2c8d8068faasm363151a91.32.2024.06.25.19.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jun 2024 19:34:59 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 9ED091834CA78; Wed, 26 Jun 2024 09:34:56 +0700 (WIB)
Date: Wed, 26 Jun 2024 09:34:55 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/250] 6.9.7-rc1 review
Message-ID: <Znt-T05Wn-7ZsxE9@archie.me>
References: <20240625085548.033507125@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="tFBuSGGi66cKpezs"
Content-Disposition: inline
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>


--tFBuSGGi66cKpezs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 25, 2024 at 11:29:18AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.7 release.
> There are 250 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--tFBuSGGi66cKpezs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZnt+SQAKCRD2uYlJVVFO
o6j+AP4s7/0Yttqfl2YJTsh8VuBKgw3rHiyfVY2mLQDyhmFVfgEArOmPKDFEscuS
LbWXxNC55x+tpspXHdo51bwcnUrekgE=
=noIh
-----END PGP SIGNATURE-----

--tFBuSGGi66cKpezs--
