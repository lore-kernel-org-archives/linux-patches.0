Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8848F44
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 06:48:59 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-68fc9a4ebe9so1498083b3a.2
        for <patches@lists.linux.dev>; Mon, 11 Sep 2023 23:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694501339; x=1695106139; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=egRuiJfDe5zsNnCMEhNXnPwEU9c3Rzgfd0yVAigNkTE=;
        b=ZtY+iz+rMBmryk1h0twfr/1YvvBmgXHSjELh6wh3UI3Xp8bfF0G7RLV+MuduhXmw5/
         S83X6UKQTDyRLve7DKUfAg08S4SwZPYHIvfNLQQ5qkHds0iZ7r2zpuntC/2/irf1/zxL
         aXGB/CT5YlQkDglbnx7x4zdNmDmOa7G6rkRyaCiqPcJVdwNQQIe9xVGTlU5RVLtmjSk5
         NIxPFYD2LPdwhtgx8HMnnKdwTzUmxrgrqps7wtN7hbuYWC2FVVMZrYNOhCdvBJSa9M1M
         PAkstVFHzbzDUIx/N11gGQ73v/N+dXIRroKGmVruv3equ5pGGYrieQDj+Hk8fMLVsGi/
         VD7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694501339; x=1695106139;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=egRuiJfDe5zsNnCMEhNXnPwEU9c3Rzgfd0yVAigNkTE=;
        b=YOSTOgdTc+lH8ik+Sli2s5MZ0PdWKgQlG1Ye9NQZdOqIEJ9Zf63YMtomqrDdWoE4r2
         /ghcQ9r2ZXqtXmeMeZjvWgWvMsMU7278RKXQvXGY8wr+8f5Cv2mkhjkw1CpnPT3JS7Er
         gObVwDdt1v3ck9dvTRG8u5VC/EW1T8/ZPTKTS3uf6J3EJKAoN4bTe9Zk5b6AbKEc8F7F
         KLDMw2y0113TKXLrKPC//U/WFeW5zLY10Zn2TydMARCYz0Lu+18TyQNEpBmB6LRQiWgR
         wpYtJOVAXxhbe5fURO0z19oXVUH1je3D7Ny7+aRwf+0lSYEEScAI6OXT/uyYeAhIXX2x
         1TzA==
X-Gm-Message-State: AOJu0Yw3IYEFxON3uSGC9rZ4LReXjoI/dbx25QAPhq4cYggtEySlbuFy
	ZmTPSLNvrERQnC/MU2tveO8=
X-Google-Smtp-Source: AGHT+IHZNXXxz10UjN3OUcZ+rCkFGK2zC8NbdO7rAjwlTdOsnVuBO5qXRddf4ZQi6qTUBxZti6JieQ==
X-Received: by 2002:a05:6a20:748b:b0:12e:73bb:cbb6 with SMTP id p11-20020a056a20748b00b0012e73bbcbb6mr14299423pzd.14.1694501338925;
        Mon, 11 Sep 2023 23:48:58 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id f18-20020a17090ace1200b0025c1cfdb93esm6743862pju.13.2023.09.11.23.48.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Sep 2023 23:48:58 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 6F5BF821F337; Tue, 12 Sep 2023 13:48:53 +0700 (WIB)
Date: Tue, 12 Sep 2023 13:48:52 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/737] 6.4.16-rc1 review
Message-ID: <ZQAJ1OF9rSj0pOmi@debian.me>
References: <20230911134650.286315610@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Q8v7qVMLKC2EtWDZ"
Content-Disposition: inline
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>


--Q8v7qVMLKC2EtWDZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 11, 2023 at 03:37:39PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.16 release.
> There are 737 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Q8v7qVMLKC2EtWDZ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZQAJ0AAKCRD2uYlJVVFO
o1ptAP91vlwlzGp1gJEW3a6+TgTXjvtkwHSzi8htGS859bRTAwD8DsqodWS4uRt9
hBTd1d+GoVYgxZp7d8CBkbyuoi6dfQ4=
=PNBF
-----END PGP SIGNATURE-----

--Q8v7qVMLKC2EtWDZ--
