Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5714F37F
	for <patches@lists.linux.dev>; Sat, 26 Aug 2023 01:23:44 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1bdc243d62bso11395515ad.3
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 18:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693013023; x=1693617823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=acKCK1DDVsUgCwVPQW4+BV+8s2HfSsnrUrjpFkgd9wk=;
        b=qZzFJ5Q5ESQ/8whIlhrjVp3nDjACHbnMZsluegvq6Ojinxc/067Osp2qbIlyw9OjoC
         GrRln/+N7K+EJ6CyNvvc+wOUkgfi4l1q64Ul9uSGNiBBZAVF8RivtDyeN7Ha+sTyJOaS
         LD/odcRNwB6O+gi1HjaHmDlF86++rjIJKEQ75ax2Mt4my1mA8ngmS7J7CH7ueAo62NGh
         rmJDnzO84abFyXgzrzbSc0TZ8HkmvG7Bk4tGOnSBPpvE0bvVIuhs9dluaoWv8GjcnWtM
         C3vb1aRCOnNEmeBc+8DIEHu3MJjtbU/oTaEjJwT/5Q+VpaLm82ujhnXu4CqBfchy1pUI
         SPaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693013023; x=1693617823;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=acKCK1DDVsUgCwVPQW4+BV+8s2HfSsnrUrjpFkgd9wk=;
        b=MeQWVTODHrcBzHmlX/E/w3De9m4jP0AviwxXFXr9a/26qA/JVNZZ8VsQe7cI/6q/oX
         Av9si0hrnVfCZaJYDnQJqV0H4h7w5vnBwAljQx1wfmI+qiEI8JmyzWUwavDWWAlfiIJt
         SIAMNWMekQh+EDWlHdmGoDR8vOVsVycjXoq8QW3VoQpnIh7E70XMWkIVFqxbQOHy91Tv
         xlW80Y6nV27fBmCFynhHsqf4MwaLfhRAsIEEUdaYqNSXz+OQOlEPRysER710c0FdUh/+
         eEPSKTgK08L09vkdO6iguFKvKpcTZN6aD8hkvdgc44ekIjsTY6rqs0+dUhEYnTOp6hCQ
         RCLA==
X-Gm-Message-State: AOJu0YxEHEtFndWQ6vNxwdBsgla46ImhBFUM1oZcu1W3MtDTi/JWLLID
	+bkVj+l+Ey6AYpKo6SlU/fk=
X-Google-Smtp-Source: AGHT+IH4NYnJm+tQgvR+rYaA45h9XoYuEpTCK8oT0lwl1wjhA9qrHf69HItpzuopdJJAAu87CUg0YQ==
X-Received: by 2002:a17:903:2642:b0:1ac:8be5:8787 with SMTP id je2-20020a170903264200b001ac8be58787mr14537859plb.21.1693013023425;
        Fri, 25 Aug 2023 18:23:43 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id z1-20020a170903018100b001bdb167f6ebsm2429875plg.94.2023.08.25.18.23.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Aug 2023 18:23:42 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id D2F5C82EFB85; Sat, 26 Aug 2023 08:23:38 +0700 (WIB)
Date: Sat, 26 Aug 2023 08:23:38 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/15] 6.1.48-rc1 review
Message-ID: <ZOlUGhlro_v6cvo4@debian.me>
References: <20230824141447.155846739@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Nr1MUEtNaDq7pJ3e"
Content-Disposition: inline
In-Reply-To: <20230824141447.155846739@linuxfoundation.org>


--Nr1MUEtNaDq7pJ3e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 24, 2023 at 04:14:56PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.48 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Nr1MUEtNaDq7pJ3e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZOlUFQAKCRD2uYlJVVFO
o0YxAQCzDPWVI01UQ8OMk0c1w4/zdbNTbiH8jmHRdhQjtJBpzwEAj6mpdQtFZ0/5
1WEuBsFeXqk/B+fVxLzQRakwl/wcWws=
=AgPL
-----END PGP SIGNATURE-----

--Nr1MUEtNaDq7pJ3e--
