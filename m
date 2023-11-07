Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABBA66FD9
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 04:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h0gXaccZ"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-5bdc18756a3so34895a12.1
        for <patches@lists.linux.dev>; Mon, 06 Nov 2023 20:12:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1699330376; x=1699935176; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VWGUdKDQwEZVxOi96ik3Okr5Oky1aXrKnY6m5jfCDbU=;
        b=h0gXaccZ+FQ3OnwfuhvKTpTa3KlP2U42N2mcRO5n+VuKvc5y+brLBsuCLrg5f6nA6+
         FlWlCSgFvYk9L3+gxwntmKP0TOZNXOPWL4QufDfpk/nnNwnc40etarXoT58RkdL0Et1P
         mnJu3ncI3XxqHehAxM/NclvMPnGWsHlkDU3Bw1QZj8n0r1LfjjHYfkev8QO4L5GDTAEB
         u4CFuprmhYqqPZDz+jCL0mBGuFtG6i438l/sDzE5Dro2v4ONapdS4a55dt687aCGBE5q
         dthJ6woonmZNXoFOWVNrMXMdmeN6T/8jj1SUdNC66dr75836zsnesV5KNQ/3/rh7pULL
         4bfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699330376; x=1699935176;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VWGUdKDQwEZVxOi96ik3Okr5Oky1aXrKnY6m5jfCDbU=;
        b=V5zhQrETRi9tsdsc6FEr9GAOQi4I+YuO7ng3SJB24krna+GW7/63IS4KiGn+G3EP7H
         XJPRhNo8TTKUfSABihT6ztM+OmqCmR7vIZXWTmktXXqxrl7fbPADyFYPI/iohMXUI+0H
         eHSXy/3gqzg5o5/d7IU6WXriXxCqETzNfGxonDQb98cOs9HvPGGVrc1k6bjLQj/0cdLc
         k/hYJsP55SMH0kkCyRzLDT6OQE6J+W6PjEL8ugBP+ThcBCs8SWevFhcssEIfd1kokYFY
         Hvhb4uyjNnrczi5LaLJs/B6r8hWV45YZwxoY9tVkTvMHht8iJluv+Vjm4Kvo3g/mp2o1
         2nxw==
X-Gm-Message-State: AOJu0Yw3DUm/VBoeHeCiovuur89tyQvQYVl684BVAnpc3eNloBUPrr/u
	cFo3k6/obg96KJ7Jqtrtiwk=
X-Google-Smtp-Source: AGHT+IEZ0ZhcKKp3OemGzSLtlF0+XnYGGdXHz20rb7hANsuLl7T4TSR5HojatHRX/Ov7TliIu3jYSA==
X-Received: by 2002:a05:6a21:7885:b0:184:9f3d:f7ba with SMTP id bf5-20020a056a21788500b001849f3df7bamr1750803pzc.33.1699330375600;
        Mon, 06 Nov 2023 20:12:55 -0800 (PST)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id z20-20020a170902ee1400b001c735421215sm6554513plb.216.2023.11.06.20.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 20:12:55 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id A5C9B812C340; Tue,  7 Nov 2023 11:12:51 +0700 (WIB)
Date: Tue, 7 Nov 2023 11:12:51 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 00/62] 6.1.62-rc1 review
Message-ID: <ZUm5Q89d2CzZyyPS@debian.me>
References: <20231106130301.807965064@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iIlcz5nryRovASij"
Content-Disposition: inline
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>


--iIlcz5nryRovASij
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Nov 06, 2023 at 02:03:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.62 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--iIlcz5nryRovASij
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZUm5PQAKCRD2uYlJVVFO
oxZFAP9rmhpJxcRFb4pA+uDWcG5qago+ia/kYFqeaHyYGWZkpwD+JA4rYo2uam9a
zIfp9ue4E3UlBsgvW8sZKZOwVR1HVww=
=78wO
-----END PGP SIGNATURE-----

--iIlcz5nryRovASij--
