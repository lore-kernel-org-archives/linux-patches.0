Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93FB114286
	for <patches@lists.linux.dev>; Fri,  2 Jun 2023 09:01:45 +0000 (UTC)
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-557e66063e8so1288804eaf.3
        for <patches@lists.linux.dev>; Fri, 02 Jun 2023 02:01:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685696504; x=1688288504;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kws7y4VkDTZYQ3nyC0nxFkZqfRS9Xqe8rcms/oZZOcU=;
        b=oWywxfMHX+105fVuwQITBZfdOAXhyC4cy5+yf73os1h/j9mjUddf9NBdUddAAuOBvZ
         AfnyWDHRHEKj7zMtgupGsf4ZoDRADlhi78QT2T9LBvNe5AITcEED1SvPBJiWDAFcKXhm
         9Dcn6f8vqUfhZATVnHBYohL/3N9Z8z/vFDkIEtdXoVVyjGkEbboK0h11y1YHvN4vvUT2
         LvoVHw2EWLknp3zzbdGye6WIqg3wKaFLvz0ldaKIjxGGdqiBDKfACYCgH1mvXNMj1eiy
         gn2u2uBmjIWJldlHfWM7tuDebf0Bp0ib6+CbpCzA5EUJ8P8huT85b/D/0EEo4fNgmnho
         4MOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685696504; x=1688288504;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kws7y4VkDTZYQ3nyC0nxFkZqfRS9Xqe8rcms/oZZOcU=;
        b=imYO3LEHZc31BIEh0+taM4AOKhFoITi9hWe240pT4viaI1OLOwx8aRx/mGQvqH/bdR
         mRno6PCU8TJhqbh3cRzHCxKWzHe1/fz699ZazT5w/Iecvbva8UCb412+t3x1N+WaHOHX
         il8KUndQxlMha1eahUVhucIk6pp+Pp5L19d6Sy0ylBYeGGFLQCsCBjC9aE/Nczl+Gd8j
         pgg0aZVUuQo0hc7sTPZZ+rNtiw4c5fsopZAi5zcRfffQFnxgOqAhzuYYllsoxTcxbhc8
         oLKsqyRIf1fJaWwIy3QD/SVxCXNmrs09sQolyLcvinP83u/1XIFJnvfxBpXSZlijucUV
         p6Ig==
X-Gm-Message-State: AC+VfDxzksr9j6D9Ac1g0hfUTVr6TfEFn+3gxiD5yDniRczB+MAYXvDs
	SQgUfxZ7xaXlepoy7FON86U=
X-Google-Smtp-Source: ACHHUZ71ASbbleh0vAkdGrczHAvNay7xsB8T1bsoYWAd7d5kyoqr4Pra+5RsRSdr/Ecn0nHyxbCeTQ==
X-Received: by 2002:a05:6808:1d5:b0:398:4d61:aad9 with SMTP id x21-20020a05680801d500b003984d61aad9mr2051172oic.24.1685696504349;
        Fri, 02 Jun 2023 02:01:44 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-3.three.co.id. [180.214.232.3])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902c28300b001a245b49731sm822266pld.128.2023.06.02.02.01.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jun 2023 02:01:43 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id D15D0106A05; Fri,  2 Jun 2023 16:01:40 +0700 (WIB)
Date: Fri, 2 Jun 2023 16:01:40 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/39] 6.1.32-rc2 review
Message-ID: <ZHmv9J2-oGhI7pQq@debian.me>
References: <20230601143327.479886832@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="mJ8XI4Gw8QAc66Dd"
Content-Disposition: inline
In-Reply-To: <20230601143327.479886832@linuxfoundation.org>


--mJ8XI4Gw8QAc66Dd
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 01, 2023 at 03:35:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.32 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--mJ8XI4Gw8QAc66Dd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZHmv9AAKCRD2uYlJVVFO
o3NoAQDWtj/c35QsvmIKvWiUvDsh7nXEpnwgM0JLjSlWPohmoQEAnNUZJLfcQDeE
cPHHi8XeTuKRvoLU5oNEshjmsvUZnQ8=
=0WUK
-----END PGP SIGNATURE-----

--mJ8XI4Gw8QAc66Dd--
