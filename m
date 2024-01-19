Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E4F8320C
	for <patches@lists.linux.dev>; Fri, 19 Jan 2024 06:45:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705646752; cv=none; b=n32raZJZOAx5nc3X011SpzyHvJGZwMYzs4GftzgcHolGBVF9AISYGJIoWofT4NSlp0YnEd+6NwGNx4lec51CYicfUbOtEg87am/MKuBFDsQL0yerTw10I7X+fChI6JAL8yoAatMKV6TwhaLBPyT3Ebi6b/AQUTvLifhh16W1XNo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705646752; c=relaxed/simple;
	bh=wQk4FOUlnnv8BFLKWr2FYKxfjNLY8sHTXI6EqsBnuMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OUx+uO/wyoVfNn92TGfIzdCJ0OoB9aOTw6csmD1i258ItmjeNJu570fdUPadpeO2j3ebpX3pvSzBp0UQjqww/BHU06eeuU/Xh2xs2S62usX3jSqs4Q3Fug60X5AgEtHefDkI7pk+maJB/XeOuaWqB00NazYMumK2A6uaeu/olcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EZwt6Wcm; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EZwt6Wcm"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5cd8667c59eso404791a12.2
        for <patches@lists.linux.dev>; Thu, 18 Jan 2024 22:45:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705646751; x=1706251551; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wTKVPZWGYFU6FXuHPoulVuF2kETQ9HD+uYcU74cb1xI=;
        b=EZwt6Wcm1+jgwQMue6v67EPS3c1f4V4yYG1fNQBFsDSquuSrU5/Rr1S/LQTaCA7J2L
         OVz5at7x6L2/QHIFl0/JGdKUwZ1mzqnEQriIVBf2iGwCUAZwD+1ESv0h/Kx0H7xw1dVM
         z/mj0tHoAYAZpK2qxze+UZny36P0tPBYZ2kBN34gsvk1CjM9DSewkv6sGGOlrpwF0VQP
         KGDBDk1FYEQqo3E9sFl8zfr+NRlWu8zkBwQougHObyr0FP67lSZDu1jSt+R/5GpSXUHb
         KQz8T/R/vJlg8vF0nJ/NscB5bSp2zwIv8Es7sukd3g92LTaRh4Kx30vGiwPoSjJ73VyB
         PQag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705646751; x=1706251551;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wTKVPZWGYFU6FXuHPoulVuF2kETQ9HD+uYcU74cb1xI=;
        b=kcn8UndoAntvt0KjIop61Dd5KSaTFMJ5dc4V1yPYKDEoTcDrmFlp1JAWLRqXdFoorS
         6X1ts58IfSAcjbse1qnsv1e/77kPuQ9U/whmoXTormplLLUv8KJmU8qt4VTtTFuzlCi0
         jO/c1adfTqHH7qv0fRBPJTtMrHKsj3bzfbvY559a6/trH4Gd98Ek01fwQjiOVXTyKeVb
         RIs9iPBr+9E/1mXHG36pCs9y9Facmqbdw3WJ8QMH7EzQ9ZGqU8rfoo/d3MefjDw8jEab
         vNPqvubfqU4GLe5CWcbyfd60shsXqa7uqxnyQjGqjA47mDsrO9bn2OiLZVU4Msuyz4AK
         m1xQ==
X-Gm-Message-State: AOJu0YzL7G508OEUGYX1S/8ZkjMeD6zB9ACe7qfw8DxOJOW9YXFcaBBC
	lsCRhd5bQkLaZs6u7gbUOra5qlSLK4kouKfs0teaZgMmC3f9KaTW
X-Google-Smtp-Source: AGHT+IE90ay1HpXv0tuY9/Vu/wIY6ULbl1WxalXDALUIyoRxbSFIDXIy8E5Zv0zxEwLjdi5mqeA+BA==
X-Received: by 2002:a05:6a20:81d5:b0:19a:d795:7ae8 with SMTP id r21-20020a056a2081d500b0019ad7957ae8mr1818901pzb.82.1705646750688;
        Thu, 18 Jan 2024 22:45:50 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id k9-20020aa792c9000000b006d9bf45436asm4372549pfa.48.2024.01.18.22.45.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jan 2024 22:45:50 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 9C2C4184DAE02; Fri, 19 Jan 2024 13:45:46 +0700 (WIB)
Date: Fri, 19 Jan 2024 13:45:46 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 00/28] 6.7.1-rc1 review
Message-ID: <Zaoams2Ca2RgKB0F@archie.me>
References: <20240118104301.249503558@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uveMEZpKYU3Kv0ph"
Content-Disposition: inline
In-Reply-To: <20240118104301.249503558@linuxfoundation.org>


--uveMEZpKYU3Kv0ph
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 18, 2024 at 11:48:50AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.1 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--uveMEZpKYU3Kv0ph
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZaoalQAKCRD2uYlJVVFO
o67kAPwIbu+cMpTwjCo2YUWCUWcIvqh3zVWY8ZW6VJpDWacXyAEA+DDItFr9LArJ
/fBg3dEJQ6tw7c5yixxIgn/w5bEKvQg=
=/zNN
-----END PGP SIGNATURE-----

--uveMEZpKYU3Kv0ph--
