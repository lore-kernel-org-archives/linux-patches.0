Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1486111B6
	for <patches@lists.linux.dev>; Wed, 14 Feb 2024 07:22:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707895361; cv=none; b=riVPDoVkyvSgx6nJ2SlNwul7wAVjCgWlpOOFOYn5omtoIcdTflR03+QRgXLaW0UhEVHb3mAEn2GDEzX3X87gkd6k3fmOdwXQyns/jne2ilFJVpqfDg5UHsdmTI3BpxRJmhjlu3ZjMkKTUz4lr7N+tmmAc7HCiw1HUaAwOQKaqkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707895361; c=relaxed/simple;
	bh=nqjyHDMbmEkQSwLjy/5HXA+s/z+q9DngX5eYqSkxTs0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AaUTqjkRG6IuK+pyyWA5IlTq7r3qYcBuwn7yRyZnyLvqpDSvJevAk5+TotKsi/FEEMadiLiksu5DUThVsbq0eTE6TOU5Aw9lVad9hrLGvOXd859s94wzrn4LjlW2BGA525JDR57nk58aPxtJj/F7IowVY+DrNtwRNE4gefUw/BM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TAXJ37Xa; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TAXJ37Xa"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6e2dfc98664so1887101a34.2
        for <patches@lists.linux.dev>; Tue, 13 Feb 2024 23:22:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707895359; x=1708500159; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6l8LOzpoRdTnXtIWk0XUSllFHVNvLBI3TlPCc028qZg=;
        b=TAXJ37Xa7QW2zYrMUqQuaUGdwucTeKskVAadDAu95nInjw2YXW0kMUpWPGPOwwt3pE
         Gv9XIyc6yKNcFD4cHfl8igh3de98kCCFxwvjIZwYYfpHyXIL82A710Az+qTNcuxK5fGZ
         naBTtxs5sr9kbjLeR8n0ZB+byNWWla8OzXmg+LEtxRdLWJ8YN2SPx2RfW9HD/7ewv02z
         QJK04q5JtLLcxVTtfQlP7QJSvBteOvuMyDyTUK5etGSX7mvjg+uQHNfLkyyZ+GZYs6TV
         11FNZjJiu8OAFZk/kOxrledbgzInWwfi3baUL0lAXJLMw+Uymap+Fyj8Oicj20Bi8KAX
         sWgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707895359; x=1708500159;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6l8LOzpoRdTnXtIWk0XUSllFHVNvLBI3TlPCc028qZg=;
        b=jM2sWp85jJzv75j45Hby35pPtCBGibx06rQjjYNYx+oPADgR1U2PF/6rDdYvoxlrEj
         MWYjrZH4y/ArXdZj5xmvlgranFJWGoE5l7t0YqpxKYUDV1gQfCjbyHgQU3kIn/9c/cG5
         vv+CLqseeLnTMDOQ5/zF8KDK3Tl/yvLSU3Uq7LdkNzu8ST7iE1rQyCg502nWjg2aTjNQ
         tGsB6pWck0d+ecSNZ71Zi0KAwnkGQoeLCznQvbUiBwwW6bzy1lxxZMe8cFQPkjxCXGvC
         toO80gq4WspbCpMdC/qdzMf60BoAkpQQT7sX4zxBxUzV+K8Gy8VIGxR8qTrxfdfgDn95
         iWPw==
X-Gm-Message-State: AOJu0Yyc40yLR+72iI7j9YYYHJLZ9XA8p9kree+DmvliwF41Au7Xu13l
	WepMGt4xvemNiDdWsJ3Ysj24XG/e8m6NvaHM4yW0qBR7HKpgAvvc
X-Google-Smtp-Source: AGHT+IH1W7/UDuUfafFHO6E6lc8GP+dwFw2fCUECiJ/kve57Xj4cAZow2GRf5wuleRqic9jgRmTE4g==
X-Received: by 2002:a05:6358:712:b0:17a:e307:6b32 with SMTP id e18-20020a056358071200b0017ae3076b32mr1855564rwj.27.1707895358657;
        Tue, 13 Feb 2024 23:22:38 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCUfemv8BxazoqblN9iSQ3dDfCJGdQjljqOBTNLR9bIV271rDlZFHFwgJbRZWH6V9PITrBxXti32g89gq+7D0Tu7AyfRavwTbij8eom3AMJevZIyIRXyl/mgJPoFoR+jUoEGdxUU0x5nhUYWH0zcKo65Xg2719pAVGysESqYtXDOJMeYRctBkGteauMQXJkA4YWcl/CYh2zfvNxPR2UmNrPiUZ49KbhoqC3P7RqUTW6eM20nVWD3uwhMZn4Zwr4jbVrjvKBLQQlUKBJ/fDzZGvQwRn5Ui2IpF9LP8Z3Rjt3zBeysZUy+nt/fh6h6x7ydva/E4b1JlUGpevRUyzjQnpXJpLZPkbuWYW2sLJ/dsmCr55L1+ewh575q9frDf0m++mG6a5i92rvyhWoLkG04kMu41n2AxYYObQAnCgytT4Fn/3ZJ9SSraCRtNyS+2hWbQ8tagx/kjcHMb1L25I+5aVFHFTh8X8IazMRI8zhEZ9nCSXHYB5rbP3ZxMAcUW/Dm6sX5/uJ3kcX9bgxeHylSwd7/26TBX5u2h/tR6phX+A==
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id ei52-20020a056a0080f400b006e0e4b9b7e6sm4437685pfb.212.2024.02.13.23.22.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Feb 2024 23:22:38 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id DE01E1846B488; Wed, 14 Feb 2024 14:22:34 +0700 (WIB)
Date: Wed, 14 Feb 2024 14:22:34 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/124] 6.7.5-rc1 review
Message-ID: <ZcxqOgkGKaR7i0x9@archie.me>
References: <20240213171853.722912593@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fTPpX5yBn17PcrIx"
Content-Disposition: inline
In-Reply-To: <20240213171853.722912593@linuxfoundation.org>


--fTPpX5yBn17PcrIx
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Feb 13, 2024 at 06:20:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.5 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--fTPpX5yBn17PcrIx
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZcxqNQAKCRD2uYlJVVFO
oxnrAP9oDssHhKcbZ6oE7x51hDWufn7iqYBmr5NEW0D0FAspWAEAofaRhJPiaxxE
pAGbrmtd7rpfoF2QsX5Zih/fT7jMMQg=
=SQXy
-----END PGP SIGNATURE-----

--fTPpX5yBn17PcrIx--
