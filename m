Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578FED275
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 06:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706078044; cv=none; b=cCXy8JDmMrK33I6dNVbcSiMIe/1aD5JxuGOmOmtkpm8tRH/ryKp3nszaQdxyL2x3gKP075lIQHEFvS/7Du10wFAOZImYKawbH4+qfAHCudYmisOtIiWNtTUN5NSMQaGlcIjWhrznM4C/6y2sZBxYmi44VRQ+U9+egUT8mVJbhUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706078044; c=relaxed/simple;
	bh=5YIrrYj0Si/6Hd480M/w7OJ0h2AH6GV9kwxXqRo+CR8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a7NiQ3AgycDCFMow48N3M0e08Sxn3+katbmBe8Zt+lfAT+WDDHjQnI2zCu0xjp+huc2OYUOe/KBAeruCUalauybogTWMzuko6UsTv+eLZ5JIpiWUM1Xeo2wqq/mz91kSEy591sXWf7wsaORF3drDzmbOreH0x2bIpMbUJUOJJoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Yt/UJsZ0; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Yt/UJsZ0"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1d50d0c98c3so49245125ad.1
        for <patches@lists.linux.dev>; Tue, 23 Jan 2024 22:34:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706078043; x=1706682843; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wwiArvKfER0AY3jSAMDODOvkCI4Zyn3MP5CTy914xZA=;
        b=Yt/UJsZ0SBaViLJu6IR/BMrM3aIqDtynyu4xWOCLK6Qq6gNJFs3jYCeCwGmcsoAlZn
         +AmH7ELja4ZzAni4OQnrXF1covNopp4oUn8QUQbCEr2JGjE3UUcUKRxjGsqovOdtcp7D
         vQzhu/+a99tUMcnDPvGn4NQ7hYFkK0FkESCdY/QhnypSbA4vc7u1eJKqii4CtCQpi5LP
         aHqKOZaQv4FPIei674aaMm3yKYq+x00P8PTNkfpdebvRAUos17cLLZa+AOtHAzo6+asn
         bysxb8tMA1zytEhae03TZyYH2n5YN6qyBYf6AwjcHJPEGexHmH226Zf9nQ6fhYVX7Q3N
         HAcg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706078043; x=1706682843;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wwiArvKfER0AY3jSAMDODOvkCI4Zyn3MP5CTy914xZA=;
        b=xLdgbhtRdxVvh7HlPon6vNYFBU2yfWYnS9R/OaP1kYCT7teOzZHRE8xtgDLjfVssQJ
         4g8dEjgXrEcL34xffwZwGbwrYMIYzNYNTej7ywjF5G9ZipmSjqQfsXfqMwfUGTJIoZSw
         A1kBXWV62uKNWFcTYDJRZ7bYRcdQFfbnTCnhNI394aMTbjjubB9RJUdNS23wk3KceC9c
         LmKQuHWrGPImqE+/el9gm/PeagSb64Pc9PCSaSIGPZsLUtmm2YZ8/GJMwGGz3UtMXu5M
         R2yO9lG2V5qfSI17QimBNEKpFiXtF/AaVd2MmWEWUjZrfJdJ03PuzzbgmrW77husVkxg
         XsrA==
X-Gm-Message-State: AOJu0YyyPzhSrOUL/7Kdtl8Ih5WI0js79bDw10zuFt8w9SUfRKHpgY3w
	2DptShKyp1bvqFiUo0faxrrMEeiAjTtmmatTyE9l8S5EdXWIqgs0
X-Google-Smtp-Source: AGHT+IHlGWCuEIykEDS0rBLhPa98kQAWC3kOAyYmZk9CBmd6ampHBBrgWmJmW/+WuAgUE2Z/4/PXHA==
X-Received: by 2002:a17:902:e80d:b0:1d5:73d0:eb7d with SMTP id u13-20020a170902e80d00b001d573d0eb7dmr705815plg.18.1706078042587;
        Tue, 23 Jan 2024 22:34:02 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id 21-20020a170902c25500b001d756bc2396sm4056873plg.192.2024.01.23.22.34.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jan 2024 22:34:01 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id D27DE184EA857; Wed, 24 Jan 2024 13:33:57 +0700 (WIB)
Date: Wed, 24 Jan 2024 13:33:57 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.7 000/638] 6.7.2-rc2 review
Message-ID: <ZbCvVWZDdJKdYzwI@archie.me>
References: <20240123174544.648088948@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="BJmZCM1n8HINQoj4"
Content-Disposition: inline
In-Reply-To: <20240123174544.648088948@linuxfoundation.org>


--BJmZCM1n8HINQoj4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 23, 2024 at 09:47:30AM -0800, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.7.2 release.
> There are 638 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--BJmZCM1n8HINQoj4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZbCvTwAKCRD2uYlJVVFO
o6ngAQC2zVMRCBg2iMXtB+uP+hmW44cKQRyMlnkPxbRa73caFwD/ZBl6VCSCxIbW
jeRrI4uuKZXBzjbdQHx9xdny0czn0gg=
=Ng2f
-----END PGP SIGNATURE-----

--BJmZCM1n8HINQoj4--
