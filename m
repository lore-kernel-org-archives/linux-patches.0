Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1059517D4
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 04:23:52 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id x24so46056plr.4
        for <patches@lists.linux.dev>; Tue, 18 Apr 2023 21:23:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1681878232; x=1684470232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/PeCUCoOm5EhpEKpIU7t6XGEzaaPVIfEbFGJ8Ltf0/g=;
        b=jGrreaywInXNQSQYd9Zh+ZtQZFmQDZY9Vj9jRE59f5jpWbUmi9GEPjZUfKjLUALbha
         yTcQKl60yBquQpx4vWNPrvI5IaQ7Tt710qSJu0ShsB9eDVb9MzEXsFpf8J9FsEXOXQk9
         xihZmIGP9uhV6mZiSHg82ucM2AcHHU83uA93TDMlKqtuaetg+QByxt4A9IUDKe2kFXvl
         TCSBa9iTEaYfOjpmmpiVxgw9NhOdGP5xsksxPe2ACcmhG6Eh0ROejElwY0ZCl0sfyVJT
         nFSnZ/bmQSiWT1XGESTrLWNK6/77MMBjvrRQzjxwctlBg/ouUH6bkpB0jkN/fHB9+WeZ
         qSsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681878232; x=1684470232;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/PeCUCoOm5EhpEKpIU7t6XGEzaaPVIfEbFGJ8Ltf0/g=;
        b=VHgygfznK1iw1DfA/QSVmuK0NMUAIQbdSXtXr3/Ru/OxjgZ1Sy1W6E5BJruoNKY1Fg
         o935iV+TBD0JnwC7O85hzdIUKQo4w/hWbXhf+WPrAB68Us/K6tl4M2+n2VQLTIZNVPJb
         9AyLMu8Tz1QLhnmeR95k/TwBFqIbprLnaKiFoVzf+RIZPhOPi8gSVc1E/QI/gBXUk7U3
         3Xhv9eHE0R6d50NqH1BVJJbvTfRsyWADxKVEtqOzzAb6brH+ajSUNXlQepEVGbyiolAY
         dVSGm83lL4H0e2hWtjt+xXPM2MAoPYrUD4EtzHJpOU4wPCHK+a4tor4D3CEekaKHzrtg
         RUBw==
X-Gm-Message-State: AAQBX9fyYJn+sPn2c0lbkgim3xOSr/++SbrdFFZsXBmBS9ftca0q07/M
	x0YnYgRsV5rYErt3RFzSEv0=
X-Google-Smtp-Source: AKy350Y9AoiopbDgdbaP0ocGGffqIsx9hYk3F9jc6N0Rc+cBsrSb1ZUOXFJfhTMMDISKMGcPH29q8g==
X-Received: by 2002:a05:6a20:5496:b0:ef:bd:3b with SMTP id i22-20020a056a20549600b000ef00bd003bmr1844212pzk.55.1681878232316;
        Tue, 18 Apr 2023 21:23:52 -0700 (PDT)
Received: from debian.me (subs32-116-206-28-1.three.co.id. [116.206.28.1])
        by smtp.gmail.com with ESMTPSA id i7-20020aa78d87000000b0063d336629e5sm2551262pfr.59.2023.04.18.21.23.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 21:23:51 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id EAA53106692; Wed, 19 Apr 2023 11:23:48 +0700 (WIB)
Date: Wed, 19 Apr 2023 11:23:48 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/91] 5.15.108-rc1 review
Message-ID: <ZD9s1Ms7OXVQZb8b@debian.me>
References: <20230418120305.520719816@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oJkdrppsHe4zHKKj"
Content-Disposition: inline
In-Reply-To: <20230418120305.520719816@linuxfoundation.org>


--oJkdrppsHe4zHKKj
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Apr 18, 2023 at 02:21:04PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.108 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

I have also encountered the same build error as Naresh has reported [1]
when cross-compiling for arm64 (bcm2711_defconfig, GCC 10.2.0).
powerpc (ps3_defconfig, GCC 12.2.0) build isn't affected.

Reported-by: Bagas Sanjaya <bagasdotme@gmail.com>

[1]: https://lore.kernel.org/lkml/CA+G9fYs9sHnfhn4hSFP=3DAmOfgj-zvoK9vmBejR=
vzKPj4uXx+VA@mail.gmail.com/=20

--=20
An old man doll... just what I always wanted! - Clara

--oJkdrppsHe4zHKKj
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZD9s1AAKCRD2uYlJVVFO
o4CEAP9cusbW3XkvfeuE7trwAgRGlAImwmbvNRT/oJEts65tRAEA7rVUc0VrzUVI
aHfUF95MUgi7i2B00d9aziLN7e6WbAI=
=fEN9
-----END PGP SIGNATURE-----

--oJkdrppsHe4zHKKj--
