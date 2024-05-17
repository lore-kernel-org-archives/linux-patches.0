Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D1428F45
	for <patches@lists.linux.dev>; Fri, 17 May 2024 02:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715913457; cv=none; b=qcY2RoIsDuxCUyvo9NPFeMxi6JRARp44VksDNBRykejGxUxFh02UEByJ9CXRdm58/KUiuuz7pywXUTQu8XVmdzJtIr4d0Az/B6kl6kM7TM5CboWGgDbeel7s+csLSIi+m51G1uHNHaD8DWPcLo5qukdhCwMksbUrJBydTNNNCqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715913457; c=relaxed/simple;
	bh=2dKSI6wqijqA7agrm8EhcqT8ikiKT0WeullcDAYN1lI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uweOXJMyxS0NEhFtCVT3Ehbqxi6pk6kS+DOb4waBbpZ8IMQvngpBxDfu1o04XMuOgEJdZZ7k3wceOZeHLqnbnRZ+s7dQmzbla+ZAwfbektBqXZaStSIKrJ2qUbGti8i1paiflR69sS9AS0UnGa27ZNhvq9jcTidkqokkvwC4OJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=d8cKJtd0; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d8cKJtd0"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-2b4aa87e01aso724382a91.3
        for <patches@lists.linux.dev>; Thu, 16 May 2024 19:37:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715913455; x=1716518255; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=N1bV36pJMdeLqi57LPsIILR9dVkyUf6MNsXvOWFVqDc=;
        b=d8cKJtd0TlBc4k4855rFUAKuEM/OrZibGQYJDmXnIcdeizc3TGFyI6KZBGClWmvZNC
         fkPh+D8JrQyWMOaKiw2vvtiOnyDDpK6KfjgVyVDqABI/m0zp5WSqeeS0IpC9tmL+AMDv
         A2I1d1U6cpPqXrZrhllRluPC0Od1wm4h+lgJZLHyUqijxfR/RDf2kLXbJbGBXwmtiPu2
         lzfLFyi8QVenzZyfZYPYhVzUvdJHk9FK10u5zuSGLNWC3bVkqqiN0TzsQo3lNiTNxFEQ
         6AyblwK4PTY9FU71WN8FhpeTOW/EsQ7iDnoHQBbyRMO5iTXgzGNcHLmGt/dKKqvrDQvy
         TWBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715913455; x=1716518255;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N1bV36pJMdeLqi57LPsIILR9dVkyUf6MNsXvOWFVqDc=;
        b=wfVQnn8XS5syUYW1P7l5Us/d9BOx4OnTFJbT7YX/FZvEav9kyouc2bJrSRsJILtKQy
         Y+bGcp59jkAv4nBtbX35eBzaXqpj9KJjMeSSbLTFcJpxiFUe8cyw7dwv1B+K343s74ph
         +yaMDipo6JYxNMnNBVaWmPrPADmfK7e2wwMZj0EXLlMeKPhrBUbDp9mS80WbOd6HCFHm
         GvliVLwaIPcULHIajvHzYfTMWTwSliM+wTwoOhw/iN1icg74KrGyoZ8OR3S9dY7B4tUE
         48uYNCPYLSVemEGPX1Y93Bz0047hQ9JgPVIReX/AGuAt7j0JKd3ZhTLyCpEZE764bCgo
         G7Cw==
X-Gm-Message-State: AOJu0YzA058MAACZ373VLcCzBGYHGiUQb4ZNYjwp10PXGVnjrkCVOvBi
	fMgxTzONLS+phNQ4iB1prncZHsiHVBmK9OApjkaI8N5Y1CRJ2YhL
X-Google-Smtp-Source: AGHT+IEx2E3lPYmU6R303wxd59YlljM+e4ZAMrpQgif5X9zHASJgK2YsiVwb5fSOSYVP/d/X7kLY0w==
X-Received: by 2002:a17:90b:3708:b0:2b6:2069:f825 with SMTP id 98e67ed59e1d1-2b6cc03f442mr19519560a91.8.1715913455409;
        Thu, 16 May 2024 19:37:35 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b62863a5fbsm16469563a91.4.2024.05.16.19.37.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 19:37:34 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 2B644186DD434; Fri, 17 May 2024 09:37:32 +0700 (WIB)
Date: Fri, 17 May 2024 09:37:31 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 0/5] 6.9.1-rc1 review
Message-ID: <ZkbC61CKkOPIZsFY@archie.me>
References: <20240515082345.213796290@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="L4pKaacYqaHosWha"
Content-Disposition: inline
In-Reply-To: <20240515082345.213796290@linuxfoundation.org>


--L4pKaacYqaHosWha
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 15, 2024 at 10:26:37AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.1 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--L4pKaacYqaHosWha
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZkbC6AAKCRD2uYlJVVFO
o5eRAQDkJz6MyxYm59PTs4d8+39lgNKUgZtIRN7KBZlF5BPElAD/axDvZtbWhhNs
hQtZ/GkPLPnlA4Nyyk0US4omlilyWgQ=
=V7ou
-----END PGP SIGNATURE-----

--L4pKaacYqaHosWha--
