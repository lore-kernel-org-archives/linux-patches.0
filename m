Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 749E5A4D
	for <patches@lists.linux.dev>; Thu, 10 Aug 2023 04:11:42 +0000 (UTC)
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-56c85b723cfso414357eaf.3
        for <patches@lists.linux.dev>; Wed, 09 Aug 2023 21:11:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691640701; x=1692245501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=o+dip4Mwm48SH8KstKNswZHVM/1cq/fJ+7Qb/RetnO4=;
        b=KTGjm+5jSsiFQ+DlZOaKRZjnYq+4Qwvoh+IFUr8VINd7glHc3ZqVmiH8Ka1TG8JplX
         Xnet+c3lqrdrvUyEjEWkPVpJO3ye97AWwu6MLjFG2eK7+JlXea+AhjYLyXRU+INzN4J2
         bxT2CyorXqYtLhxLGEZo5MtRWFSewGRa7cFVlUbzqHkFOy/rfaefn6ujQQWQ9VrQ5meY
         zhYR2OT65Smgoy+Sk3goHK4eI0nvvlByvPFcuxa3oTJzKuI3DDabGFwZDJ4XzfiLfdo4
         N083j+XOvHjTOR+VKcSd3jZFRF9o4GD1rigCYlz7MI2i61NcF0ptyVaFtb0ZnI93DJOD
         G1NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691640701; x=1692245501;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+dip4Mwm48SH8KstKNswZHVM/1cq/fJ+7Qb/RetnO4=;
        b=dAhYVFKjFC8WQOg9kijqDBeUyAV7FwKpf4x6zMg8Bw3kZtiX9BSzj8FuG7Nvqa2xNr
         KiTQs6MbQeTT62GkjYAdYk1al3dzqZXSoOFQILF3kn9HbfDcsEpSXAnMN5rdZIw7k4Rl
         xxPuUvDxfV8CirRnRMSCQwkZV/6JhSCk0TfJmv4m6DwctLbF/vCOvv/gVqAGdR6jQqzQ
         EIlbyOtArO4hfVMZ3xSVD/BqbteKFju5drHLOprGIEk4mRKf297l2UnIH2eZPgdiYDJS
         EnE1qM6n2yNkr2onsAg3LYbhY/Jr2hH21dFzcGz+mtbQvGN1urwYJDfdFq7ipi6I2hzk
         Ibvg==
X-Gm-Message-State: AOJu0YxQhEIQ2cZCHGmlX7DjuquT223HZ9vTnF4VmPIRM10EPKrPV75b
	h6xCA4fdSGuZ74PIT8t9Lco=
X-Google-Smtp-Source: AGHT+IEENb3xfBnVXoWRnAFlS+RjFMQNGEnye47af3gxdc9pzD6pP1qma2dHPwtc73tk/6lA0kTLgw==
X-Received: by 2002:a05:6808:1453:b0:3a7:6213:6898 with SMTP id x19-20020a056808145300b003a762136898mr1741989oiv.12.1691640701331;
        Wed, 09 Aug 2023 21:11:41 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id 11-20020a17090a194b00b00268dac826d4sm457675pjh.0.2023.08.09.21.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 21:11:40 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 5BD418196A01; Thu, 10 Aug 2023 11:11:38 +0700 (WIB)
Date: Thu, 10 Aug 2023 11:11:37 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/165] 6.4.10-rc1 review
Message-ID: <ZNRjefQECCD23UbX@debian.me>
References: <20230809103642.720851262@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Mk1kwhsNNWCwZCAs"
Content-Disposition: inline
In-Reply-To: <20230809103642.720851262@linuxfoundation.org>


--Mk1kwhsNNWCwZCAs
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 09, 2023 at 12:38:51PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.10 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Mk1kwhsNNWCwZCAs
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZNRjawAKCRD2uYlJVVFO
o5Z8AQCx5BhfcBN2+PuI7lnalUDaqwS/pmXMzH3z97b8yWapBAD+IDLGx4j4/uzC
9ZqhcsgN9MMOkWXxFnNdSzZhdi9i5wc=
=y0Xr
-----END PGP SIGNATURE-----

--Mk1kwhsNNWCwZCAs--
