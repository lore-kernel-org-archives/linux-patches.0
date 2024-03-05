Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B860F9EB
	for <patches@lists.linux.dev>; Tue,  5 Mar 2024 04:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709612279; cv=none; b=MT3XxDm7S+5/l7beOEsgXy5K8JjO71o3L68xh2d02B7ITIExu2dui+UUrQjisgHR0bI+LXrl09VZPSaWafh5isC0b+NPEl8Usz9JDjsgBiV8AvE86Ab7WcZ4Y9H4t4xMvIy5yIWle1CBqJ1RzvvYS/+fz1bT1zNutBXOGgewkhc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709612279; c=relaxed/simple;
	bh=PMm6IJbVUU20g9GmtA1BcIAyZWOfquQicAEh8ioQwis=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mEB14DlbBcK2aydddJIryMyHIgUc6z0Up+OibtnNEjmPTfLv2exhcvMk7d+Gzy5DPwjV8UUigdVrJ1mThStRS5t47h1l1ZoI/7jWOUAr88tSFXwIk51FAyoHpzSl9LmfzJqRZJRftfQKLKo6iSiR7woH7TeGeIaZOgkHuE4mbno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LtEobYaM; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LtEobYaM"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1dcb3e6ff3fso26139065ad.2
        for <patches@lists.linux.dev>; Mon, 04 Mar 2024 20:17:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709612269; x=1710217069; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PQaq34HoVtHjvXgaDxLIUrazOpOpb0uW450dmoQsxuw=;
        b=LtEobYaMWf1bDQMp2kzcoEdu3s8W90ckWEgBtcqgcfvpKVS7XLKtBZpSc+BdeCain2
         73yDYzJDpxHvdr9rfxqmoAsDXXT9+fpF0JDlPvQHP7QdrbeC6jtIFFl91UHY90Oc9tbV
         eHBRAk2o6up6p9SIYFhotf0JnDqI/fOAqXtCrCQteP1fJASpr78snKL6mc4CDMamHhTR
         7KOeb7LydTe8JMkM0l6glvFwXrvdn2E/PtlFyS28NdRsqTw/jqaOicsp1Tyjbp7HSFCZ
         mvbWGJp6e8cuKhVq7sXu/+WKVe7owoKXzv5QJ7j5+ig2xcZ/FdvKRphkAiaNMzNL22zz
         SVYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709612269; x=1710217069;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PQaq34HoVtHjvXgaDxLIUrazOpOpb0uW450dmoQsxuw=;
        b=PCqTUgzh0Mg9pdl5vmuhZ3pt8oHYRNFap4qhmTLwOUmY5fAprDYYJtXJw6EC1JPnH6
         59aP4fYM+ehlSZZ3voGxsI/MDacCnkXIwOfVXf8WXz6dY2e2wAXwQA/EcAIAE3K+OXkP
         M6dpwtj8Zt/bDC8xfl1uGqEPiqiHsX2rs1hWHQ39AADQQcOZnYlyQSX8weadu0h12X/P
         S0yPW7j9+MTACArRm6G3qjT2ns1kIRYPazzR/bU8dYP3+82kFyUUv75t0hjPuKPhGVYP
         3CoBzwxOCIcxX4kWIgaL7VNw9bTrBbPv1AFbGa05sAqlMJ35DPpbhpOusqvffkmEbwgi
         2XMw==
X-Gm-Message-State: AOJu0YyHEE2/yDY2rImpaZB9aqpzZm97UVJVroKbig+AdkJK3qa+jop9
	sbZ7ghjCgTtx5WnRmiCezyv40CxxKq+Oj0rfxsheFBPzJnrS55pJ
X-Google-Smtp-Source: AGHT+IHIlsa9YB+bVzYd/+WxOaXiNYu/xNxqaMa1UED3Hz5jg+P07OlwsttsmBAYJBETkxH8Hd6Urw==
X-Received: by 2002:a17:902:d2d0:b0:1dd:7e0:29c with SMTP id n16-20020a170902d2d000b001dd07e0029cmr1022213plc.12.1709612269227;
        Mon, 04 Mar 2024 20:17:49 -0800 (PST)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id m2-20020a170902db0200b001dcf91da5c8sm5519409plx.95.2024.03.04.20.17.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Mar 2024 20:17:47 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id ED0C3184CEDB9; Tue,  5 Mar 2024 11:17:45 +0700 (WIB)
Date: Tue, 5 Mar 2024 11:17:45 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/143] 6.6.21-rc1 review
Message-ID: <Zeac6ZuQZcLfeao3@archie.me>
References: <20240304211549.876981797@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="NP6dH/psSJnTgtz8"
Content-Disposition: inline
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>


--NP6dH/psSJnTgtz8
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 04, 2024 at 09:22:00PM +0000, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.21 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--NP6dH/psSJnTgtz8
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZeac5AAKCRD2uYlJVVFO
oylgAQDm0/YUAzWYS/z7s1dCuazDkryEOFZyPPZIijm34L0vMQD/XdrFq8DVd/9O
YGAPYKJJSwmEy/G56+3aj99fiTXPdwE=
=/PQ4
-----END PGP SIGNATURE-----

--NP6dH/psSJnTgtz8--
