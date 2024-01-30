Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB55383A1
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 06:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706596631; cv=none; b=aJu+gbvydKeHqraAQMRHHzPdUSMdk0PaS9xKMyE5hqR+gzvGboO72MsYeF0P5FPHdDIMiFFOzP0eMeZTbVz/lK91xZo38Fa31u8bXG6tbipaNrYBcJes+cRoPHtaPjyq1Fud8qb6FHhoRt/Gw9iu0THt66B7azLbdbfW+GEKX0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706596631; c=relaxed/simple;
	bh=Pt0LMo6SGcA34xoqbjesioYU0CcVX1I7PW/asESQ0j0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZH+nT7WWVFc5taVDNcZGmAinhMlwMGUnEfBgO2QGP77hvPCHwVC0BDdtKGZRf5KIYm7VaoUeJXdjzaH221RCoF0TsQa4sVYJfxv1/H4i90lTB5Jtv+v9jkJ2NT4Pnx4rG+PM1/2EBvHGJP53nruI8rBcCTJMAg/sYSgpa1wA+bs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OSgdTtcW; arc=none smtp.client-ip=209.85.160.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OSgdTtcW"
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-2185739b64cso1753865fac.0
        for <patches@lists.linux.dev>; Mon, 29 Jan 2024 22:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706596629; x=1707201429; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=HIcCz0Mzc9BxMF6SwHpcNCpuboJRjlo/WiVPsfyzt7k=;
        b=OSgdTtcWi3Isu1abBwTktdE3Wlj5XjqsNohSit9vjqp8Xe7KFwzjoCyYJMixCdXYjO
         hHCUIo8YpGAYWTVDvBf/FCbd8Aj6JBuDnNWxqIjEM3+9CkNFTfypF1/RQ/XwGzjrrcND
         5xLkhPtoznkY9oijq6G/0OUQ63ZG1CFzgKrbWVeeh6ukJSjVHjYk9kN3wqoymJsMDkqJ
         JpAnSs4j6AGYKxlF6mNpFH2jm8wnovxnUIxLTOLT96ITrVDm42mc4m1OFo7szlVq3wrt
         bvNa6AD+ZZRtf3VK0k+tLSmG6u2Z24FC1alV20q8N6OZK0l8PavqSvfzyCWMzrSKtY1I
         BtEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706596629; x=1707201429;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HIcCz0Mzc9BxMF6SwHpcNCpuboJRjlo/WiVPsfyzt7k=;
        b=B0x8pIosof0HmWdKd+Em1GP663rUii11uo9oBu9C1+wd9pD7wbD9G9CDFLJFc0Z6rF
         fEylKQH51hK4WeT07MM+nfwSK2nQYk4j7DsQpPGDZToJwhwbc0q4vluRt8ETIcn44Fgp
         JhWLGakegI/32upuMk1Yy00oHST3elFp/2iAWfkitqtSh1yFdBI9wI2s8Ti74EPBMMys
         fmR6F0ObhTlx81XjH1Do++ceDgWuHEJSRwG8PGj9HpoSW9CowcHxNHbzAMZkMsnJZcv5
         7GprXqlZnKE8E/Yj2IavW/j7WqZZ16CUZYtNGyZj5EY+GFqLCn6TDNIE+Qh6wbihVWpB
         6GAA==
X-Gm-Message-State: AOJu0Yws1doRLSWpbFuUl47av4vXF4ow+ActvUqX96sBAMOeOlXUkzHk
	3dIXIL8TPGEy78vp4GKcvUk75GGRl8JNAVa4ZREqxbLCMep0SPlU
X-Google-Smtp-Source: AGHT+IHt+p2OeOZfz041Va/zrBEWGNjlvIjR4t7egPI3rb02vl1yaX30F3AJ1JTs3GFQKicjjvyPSw==
X-Received: by 2002:a05:6358:524b:b0:176:569f:8921 with SMTP id c11-20020a056358524b00b00176569f8921mr8351321rwa.56.1706596629107;
        Mon, 29 Jan 2024 22:37:09 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id m1-20020a634c41000000b005cfd70edc1bsm7297503pgl.7.2024.01.29.22.37.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 22:37:08 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 08C3D1866A4D6; Tue, 30 Jan 2024 13:37:04 +0700 (WIB)
Date: Tue, 30 Jan 2024 13:37:04 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/331] 6.6.15-rc1 review
Message-ID: <ZbiZEIGny2PIuF_c@archie.me>
References: <20240129170014.969142961@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="/mVOV2Mmh6IDwzHM"
Content-Disposition: inline
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>


--/mVOV2Mmh6IDwzHM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 29, 2024 at 09:01:04AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.15 release.
> There are 331 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--/mVOV2Mmh6IDwzHM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZbiZCQAKCRD2uYlJVVFO
owWXAQDXCSKB363QnUJTRrC3odrGNWpQBwmy8Fb1hlkF1p+ejQEA5kXnB5jF4Sio
96MJmP35mKDfdQ/N2NrkdGb9EBACZQk=
=A1hq
-----END PGP SIGNATURE-----

--/mVOV2Mmh6IDwzHM--
