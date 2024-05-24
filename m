Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 152841DFC6
	for <patches@lists.linux.dev>; Fri, 24 May 2024 04:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716524610; cv=none; b=FnROqvEcrgu1HfRSl8MuehWlcNE3wzkBfZd5jxgmebdVsJe6bYiRz4xEXK/x/rY9xOYCQxaSnm89uqoGfxXkNW/qlgfR/pS/SwC3l0zPM4oZPPB62PcDv9ghAC+Ohf3iYjy9K+ZMrbofnL4RUWaIoypLItJTN7VF+b0gfid57Vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716524610; c=relaxed/simple;
	bh=2LfolRYLLxKA0vNdufyOzsa+bWHaW30aM8s0d31YeWQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=en6v01cMosezS4JbCviuV54MQv6+/43H4D/1y63DIJqwE3uhmtTblDQhk3rPwCMM9M7FI+h/S///TCpDnPBQg9rdFWCK+1fQMebNfYnUTkQIjFZ+s9zOYtjRU924M4tcVkFininnySwpqU45ru9KWSRiYJgxws4u+bWTnQvEALo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g0tPzUkU; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g0tPzUkU"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-681adefa33fso344862a12.3
        for <patches@lists.linux.dev>; Thu, 23 May 2024 21:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716524608; x=1717129408; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=OeePSp/RgwC8Je30bbAZD6yPtJsoOz+P6dvGPXjZ8/I=;
        b=g0tPzUkULrB1ZrrLra03IuUkf4RoRmhaozTJQdXM69TNHaS7YQyMVbhiiN64k6ibDd
         3j7OBoI5dcDctj67z97hRRh6o7+OpoznzZL+oromiQQXtDSMnMB3vF0pC00JUk2/dnKd
         yrFNMgFcq0jFsbqxBnO/3aFLtocQQ78nZVbZc7tLzbcTdXmSzT1oqey03mQxUn9ReA+I
         h/Djm/hgjwgvrWOPBvF9+dcDD3U94Gd80XNzfmv1f2EHZmZ7eIU8T7hYKLQPOmaI48ew
         ldgqcsw04Ay3/lP1dMhsLXPOvNYS6RlDWyQZ8nZ0Js1qnDPII2H/vlSkyyUjo+5SbG/B
         0/kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716524608; x=1717129408;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OeePSp/RgwC8Je30bbAZD6yPtJsoOz+P6dvGPXjZ8/I=;
        b=GRQ96OsgBAcKRutH420BrVkFGPN29Y3TIQ1o2EVtcL1uHywoY+UgESuBPrAbdvxAqx
         xJ7NjXI6z8BS4buZSpisZjiPAtB+02nzuj1jJGBMmnYZoJ4lYTYNh1O0fb8KwCScSwbu
         CbUe8yCEqJ5FRIJGZTYcGP9bFAeDMvMhgtQvbAD3hdVLook0aIBI7JIekBf0OnE0LfQ/
         /fqsI1DNJdBNg3xKlu9eUScnz/Ow2jwdur1dsji2qFNyFYPJe1vt0bB2GjAne9ivAlcv
         JEJ+uhVpXjMpWAHxwzmi/B8B+foavhnaHz4wqO8vftG81DOuhcUlhLwIcrpYqAGqpuU5
         50ZA==
X-Gm-Message-State: AOJu0YwpYiJb2iYWNBV+a9RMZfPbOfF06SIAIiIxXknONhaMoo4S8AWE
	yjV7wOoDFZvyfLnEn4UFt2UFmsspWsoVwUTiu4l5j4EcbWWCnK8+
X-Google-Smtp-Source: AGHT+IGL6Qf/LrNMcPvOToaA6hvscgczsPZw6Uye4zSKUPm2OAeplwZ/7x7PKchhMiLbLC8a8/Tk5g==
X-Received: by 2002:a17:90a:34c9:b0:2b9:a7bf:8701 with SMTP id 98e67ed59e1d1-2bf5ef1c9c7mr1383796a91.21.1716524608227;
        Thu, 23 May 2024 21:23:28 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2bf5f30aa1bsm460479a91.7.2024.05.23.21.23.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 May 2024 21:23:27 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 8189B18305344; Fri, 24 May 2024 11:23:24 +0700 (WIB)
Date: Fri, 24 May 2024 11:23:23 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 00/23] 6.8.11-rc1 review
Message-ID: <ZlAWO3Z7YaD0_-aA@archie.me>
References: <20240523130329.745905823@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CTPA9SvdXJ6T5ZnG"
Content-Disposition: inline
In-Reply-To: <20240523130329.745905823@linuxfoundation.org>


--CTPA9SvdXJ6T5ZnG
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 23, 2024 at 03:13:27PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.11 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--CTPA9SvdXJ6T5ZnG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZlAWMQAKCRD2uYlJVVFO
o8VQAP0VBXeBkjyxR9vKizrdWjHQAeFmJX4ajFxSRfY4ScLLtgD8DMbEuCaDQFr8
VS9UdjMf+VYVgK16xeM6Vz0cFFF62gs=
=OANL
-----END PGP SIGNATURE-----

--CTPA9SvdXJ6T5ZnG--
