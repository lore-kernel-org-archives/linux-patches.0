Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CBF213C3CC
	for <patches@lists.linux.dev>; Tue, 28 May 2024 08:28:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716884926; cv=none; b=gRw50jkXxLx6OsFUz7SAtS5qFV59w/Ji9mGNG6w3fI0PET0AwTL3Vdh7OcAKouIWTZtZ65bdCfMyo9WBjmQW/qv9UygyrOY7OZQ3GRNxDxSnjM50Wz+xX6z1EQGRU3ga/yjni1+bkDG9wYEjuGl36DYMMwnwpIzkkNEeQyyBj3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716884926; c=relaxed/simple;
	bh=7+Dmi2a3OCv15TElasSV7hwVIentUngqikUSgH5uZ3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=V6boMqvNTIQhnjAaBU0Md7wE36ZhL9tOfMMYA0WOmmlBSBoqrUQdDzo+xFV6L3vnLU8tI/pvQs8J4rL013eMRma8iolARMA7F95qu3+aAF5y2qVm2OUb/G4Hl6LViEavyMKvVzXFwp13AMcASVmGA1tmjAoJ8LPoTLOYCiE/y28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YIFMIUVI; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YIFMIUVI"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-5b5254f9c32so355921eaf.0
        for <patches@lists.linux.dev>; Tue, 28 May 2024 01:28:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716884924; x=1717489724; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=D+NFBxch5o2weMyKmXEPJqUhdy9B3WA/Sx9huWinPs4=;
        b=YIFMIUVIyCUJkr85Rxsb5U9BMhMXyMg2o4W1+d+ANJBYYcwPUVapivAchHLQh82tQY
         6s/B7KPIpuW8yJpqreFSfcIub8bTcCzrzLrcq0Xhdoau1zI0mdSKcx8kVvI/8RjDxxzg
         pOTck7EcIQcDUlYablKi0Digm2G2gIhk1OU6YYl0xTVC3hBkdU6dSNdmzXJp6Q1U9SMi
         ZzlioTf0zZ1NKby+jy0Pr9tQWxS/rbrhgxB36awG0unBvYLaEQg5ed6NoLn+HrIFieQv
         /HZn0ImQJLJscIWkWamell58yvC4LDn2mV1Q0LLYKXDupGAL+eFI+kA0WPF+7UafXUOW
         xjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716884924; x=1717489724;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+NFBxch5o2weMyKmXEPJqUhdy9B3WA/Sx9huWinPs4=;
        b=gRDVQ5eVMI75nvFz1Sq5SYsuwOeYIE0yrJBGAmSJuOLKbbJCf37HcnzyQqpl8kUzMV
         ELZ2JTPViPJu33shX5wFC8AMbhMmmczzOatVN0nT8SgYlv4S33CnyeRqQJhqJ/oDmFVV
         lktvUmNSJBpB10/AimVpBeksBzyBlZG3k0WiJ8WyxxXfAVQYzWMprJefK5qe8wB+7UMc
         tQkIhGgmJ/mbr3FiTJicZgrWm+WTATYDkFxl/rVpXSIhI8iOH14LhUfapMPWtBBYaUtZ
         bWRBNSusIrmtBTDFddgs7uxRHVKWgDZffV2AqEfXRHrNHeBzC5zOlIMWcXFWyXndDPMr
         jG5A==
X-Gm-Message-State: AOJu0YwEUC3cO/SwJAvYA6hP8eicmpnxyAo6k4UP+e44Qo8LXUui5HL+
	jXZhbE286iL7A3mmLvgA5Mb1T+w9n87yv12eeC68FfZSIsmN0gOk
X-Google-Smtp-Source: AGHT+IG0W2C9Vr08kpDwxSL4GFgML7zehKBlYGDcZ0u/V7Tszz0txTw7IV1F/avSshcLNP5rBHcQzA==
X-Received: by 2002:a05:6359:4c9f:b0:198:e85c:7f1c with SMTP id e5c5f4694b2df-198e85c7f6cmr151058655d.29.1716884924055;
        Tue, 28 May 2024 01:28:44 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-682265492a9sm6982180a12.68.2024.05.28.01.28.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 May 2024 01:28:43 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 39B37181B0975; Tue, 28 May 2024 15:28:38 +0700 (WIB)
Date: Tue, 28 May 2024 15:28:38 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.9 000/427] 6.9.3-rc1 review
Message-ID: <ZlWVti89yJTy4pRk@archie.me>
References: <20240527185601.713589927@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="D8/S/B9eUORHrQ2q"
Content-Disposition: inline
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>


--D8/S/B9eUORHrQ2q
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 27, 2024 at 08:50:47PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.3 release.
> There are 427 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--D8/S/B9eUORHrQ2q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZlWVrgAKCRD2uYlJVVFO
o+H1AQD4r2ke7pmMXyARVMn7KXpZL76cajKE9WetOnCqwO6TywD+Mw8yy6CBN6lj
fpktwn+SUkaafSH8hnwaf89CsQOeiwY=
=FJmB
-----END PGP SIGNATURE-----

--D8/S/B9eUORHrQ2q--
