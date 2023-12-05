Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F150C5D49A
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 13:26:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Zq2cwNOW"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-5c699b44dddso1096520a12.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 05:26:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701782763; x=1702387563; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sjQ8FbYAEzFu8r4HsmvBApJRCHY6/m3K/5DU4Y50k/M=;
        b=Zq2cwNOW7yQS+8bHLNIsoiHTNWyOGZ+FYwAm5MryK3u3yZI68k9yS44gnoJ4QKF/8H
         318QH2hWifdMYXNxo1S0OlPW2F5EAILlLzDrIjVnx2nPi3F8RlVjohGRWxH5LUQmsiYD
         8qPPH1HfVHv5EVSYMU/+lMenhzwdQrel6uXOpqczvV4NMNBB+nn7DOVLkqDZLC338Mzh
         0FUb6abgZEMxxhRnti3XLbb+hz09px8Qo9kI6Mztfm/1xUE7468ijQ9ZrE8mdWa7Yg7r
         jZJBSK+NWjH+pjwNI/OqhLMqR5Czme2pUhVS0tsGlzmvY7pmOxOvmuiitsD4rSXiY/b1
         VqVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701782763; x=1702387563;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sjQ8FbYAEzFu8r4HsmvBApJRCHY6/m3K/5DU4Y50k/M=;
        b=c6YJAfDx3KeVVezB17sTjDpdZBLDFX+YQJBgsWhgcKzo64VleXJ/xGjC5hfbsBvy+n
         oceZqWeyWLdaGJodY1IdR6H+bX4eHcI3im6Ag+1sM1Slkg5zPZnhGVlDZ7kcoIREyqzU
         YIw6NwBDEOHxDp+Uhse4iQ1oSjPJTeEaSWVpJUlEn8cW0eK5FVFCM8Sp1U5Xv1M5MZKj
         /ioWzDVFy4Sx2cwIFXbfe7YWThhCfSv33uGE3BLFnG0I+A8QJAQ7Uvuyb5inMpPQhEMe
         M4L6lyDQYnKebWmy7rKQ8Ci/8KxNuxTCk3v7KgmgkdCd3HNUYf3Jh22/KTWMK6IdmxrW
         Wscw==
X-Gm-Message-State: AOJu0YyMhBMIL4wh0EV/wvAEd32TSIGbM2ytHCnzr1baiDiGDPDLr25n
	sNeDPVLeF0qX3JzgRuAs/l0=
X-Google-Smtp-Source: AGHT+IFp2Jj31O+0BXJBVxO8BaeSKJ7diLNOfgCRhO3xZpxPwleAwXdlIiF3KnJLTnUQGjThMvsqlw==
X-Received: by 2002:a17:90b:2685:b0:286:6cc0:8858 with SMTP id pl5-20020a17090b268500b002866cc08858mr901109pjb.69.1701782762886;
        Tue, 05 Dec 2023 05:26:02 -0800 (PST)
Received: from archie.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id 30-20020a17090a1a5e00b00280c6f35546sm3864062pjl.49.2023.12.05.05.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Dec 2023 05:26:02 -0800 (PST)
Received: by archie.me (Postfix, from userid 1000)
	id 0A802102278D8; Tue,  5 Dec 2023 20:25:55 +0700 (WIB)
Date: Tue, 5 Dec 2023 20:25:55 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
	allen.lkml@gmail.com
Subject: Re: [PATCH 6.6 000/134] 6.6.5-rc1 review
Message-ID: <ZW8k4xq-zVRSiBfi@archie.me>
References: <20231205031535.163661217@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="fWlXNSfIUeLq0awe"
Content-Disposition: inline
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>


--fWlXNSfIUeLq0awe
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Dec 05, 2023 at 12:14:32PM +0900, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.5 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed the kernel on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--fWlXNSfIUeLq0awe
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZW8k3wAKCRD2uYlJVVFO
o6mOAP0RMX7+rbnuDUG/AieS0bEk7A4zKiBbn/cxEuJoKjGZigEAjzdFmJIb/M01
IA/++F53PTz3U0rf0wED1lL+p48q2AU=
=OO4r
-----END PGP SIGNATURE-----

--fWlXNSfIUeLq0awe--
