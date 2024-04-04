Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE49E1C6B8
	for <patches@lists.linux.dev>; Thu,  4 Apr 2024 03:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712200921; cv=none; b=NemadQ92HjNJ2P3gi75zFF503tyWXK2qSBxGSE82UyI9TMMou2XgPQZ8ZwONbAlaai3gDIgztqAM3i0MeJa8VVjZ+XbfTM96OOXquSQWIq8n+UeyecQv3KNOTQ0+ThIRLoTF38qzgbqvDQTnkSsweUjSiAiHuP/mPyrWNUYgmpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712200921; c=relaxed/simple;
	bh=5pihKYJV5l+zZgyKQNY7hM82SMB3ycBncFBLNsf40Uk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ss23NjgWqApXEElf/aQAtbJigEIZyeguRaNtG/6pc4wd+1Uzn7gl41qa0eqv9QGsQPQnKJ8eyzS1Jpy+xSDWHzX6ZZ1s5z12pANoIeyw+vpcGziGph2k1pahRBR+YprFjbHnqPK8V38sB3DSlEnLbPFP+qAZ3rDNZzVkusuuhGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hurg85dV; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hurg85dV"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1e0bec01232so4429985ad.3
        for <patches@lists.linux.dev>; Wed, 03 Apr 2024 20:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712200919; x=1712805719; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GU3Aux58UPVrbH3W6Uj3wE48hUzrsKIMa5z5pxoNqog=;
        b=hurg85dVaBKBOAkMzSND9rbSZEa9tgjkRnPKjSTLj0vEtWrH/5m/iXyZYAkS57M+0q
         zflcvJEuQFReI3AOhstnIDQnV0kJ/yL2cmes6v1N3fMfzvROw553IKXNRtQ26eBI4mga
         rOE138xy3VWL1L65/ZGuutbBpD5F8F5rij4y4pykg/D7ODe04p+m/EMx/4Kf0MsnrvnJ
         AR0q9epRh/INHvQeDKr+Ij9LY7V+fUwqM1u3ePSO535LJpztldxRkI9lYH8qMOp6ayDj
         3pDECDzFLXEJ4Oodn0jPZbkg3ncRMOzt/R8d+ulIbTiAQNJSKpa+n/hh1auiZcZr+7pL
         Xi8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712200919; x=1712805719;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GU3Aux58UPVrbH3W6Uj3wE48hUzrsKIMa5z5pxoNqog=;
        b=j4rdVw/YH3iKUn0gFSGFD6bNoKnFTdRcb0o0fLpv82xXASMuTziXVnmQ5IRwcBwCRW
         gfNcnqslzMbP6YfTlpDV8eJkE50a5zWxcvARYFvRkS8fHMQ92Vtfwg4ztwltgZ8+6DbY
         IkVj6neDt1zeTPG/3oUZVK/gEJJjSu3nLmrPk6TT8qDaK0MUK9N06SYzTFKAwxJLMla+
         1eSDmRXQfRrwXu/xMgk5UdceYscJASlCm/bAJuyqmxB1E8DYha8e5ZcKlGCdEwuRbRly
         9ctB+yzb34oK6js7IqC+krHPqGmag2O19TUOt/itsO0Q9A35TLlw/z2OXf7pu9yWgyjK
         uDMg==
X-Gm-Message-State: AOJu0Yzo+ClbLep2GYKLO0Eb2L9CojxWWSEltSx6MlT0OM7hT0xEtWPE
	ZMzNb5wHTKxDkT6KTYYB+0mwAHCWYfUllINmPSX3NFYLFtzDawcQ
X-Google-Smtp-Source: AGHT+IHwC+n5eClvoTsJmGHVuTvo8bbZ7J+K9bWAMhxszyqx5x+n3iKFqDNDtOQz6nwl8Gm6+A2ZNg==
X-Received: by 2002:a17:903:494:b0:1e2:8a9f:1032 with SMTP id jj20-20020a170903049400b001e28a9f1032mr1010680plb.34.1712200919036;
        Wed, 03 Apr 2024 20:21:59 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id l18-20020a170902d35200b001e23fcdebe9sm1833939plk.98.2024.04.03.20.21.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Apr 2024 20:21:58 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 2CF7F1846B4A5; Thu,  4 Apr 2024 10:21:53 +0700 (WIB)
Date: Thu, 4 Apr 2024 10:21:53 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.8 00/11] 6.8.4-rc1 review
Message-ID: <Zg4c0QG67_ehquKA@archie.me>
References: <20240403175125.754099419@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="CStTHQ9ph6xUQEGW"
Content-Disposition: inline
In-Reply-To: <20240403175125.754099419@linuxfoundation.org>


--CStTHQ9ph6xUQEGW
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Apr 03, 2024 at 07:55:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.4 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--CStTHQ9ph6xUQEGW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZg4czgAKCRD2uYlJVVFO
ozMZAQCt9++fZDsa9UJocLdzy7X85idIwQtjiEp6d2lF7WB2/AEAnVWRn9Q78QY6
Zxebg39d42Idwf+MS4GvJQrre6edTAo=
=i3zm
-----END PGP SIGNATURE-----

--CStTHQ9ph6xUQEGW--
