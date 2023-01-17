Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 676EC1FC2
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 09:01:15 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id p24so32835894plw.11
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 01:01:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sysl900IrcFFi2TfHQ/z8o1gLJYPUzPi/XTOajMFP5s=;
        b=VC+BeuxFB4UP6hq2dtPPySdo9s8b6MfVvuTe5T66eeoWQAufPzSPGav4Id7ILnxRPv
         KfEYJc4mitHJzbPGt0CXLI9/JEIezgzttg2eLQ7jG5ELjlpgtbNwStOnbfWr7RDceuXy
         KbabKKGa3xdFgEuMdZuW3JBzxp1SHBVzqB1AbAql2/EICTcUeOP4IRJlO75D7KPYI+qU
         ByPqJMJ3G3geATRvnSsWmkq1/YE1J8TP2SFAJFzHS3xXy9fFOAqu77cUqo95euaFn3Ic
         c5SSwCVgC6i13tGolq9OmT5wUzngBVjxKOrfUzjwRsXwjarf+bdSQGdPwVIKI5lX8z1E
         NnBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sysl900IrcFFi2TfHQ/z8o1gLJYPUzPi/XTOajMFP5s=;
        b=ARUDju+OQ1oWnhvqvC0ylIcJqrM082k3WrDShRPtsSr3nqeRBPEZ9BVWfGzKjscxur
         ZUnGzNQs1hC9AGY6KVe8PMUVKeFSoZ9Ke888NtQyGzQdn4Hjk6r+it5AE4Oq6kYPgQut
         3GE6D941etmzARwH2H5s7w7Msr+lPiRoFvj8+IcWEM+3uzAU66KhO4EEZxrNIGynyWOA
         c0bJL9uYXVc83wYUz/QXQ4op+qFfi6BBkwNvbrQx3mOFTdMjlmXBQvjXRYVwlFu7h+pq
         TaoLL/fA9PyCtgQq4Y227cMEj15KkN+8JsI0beNuNinExRSqb+dpA9ohbeZJeP5eoBJj
         9t5A==
X-Gm-Message-State: AFqh2kq8GCrfjzGAHlkJUkDl5hKc8xuS/VVndYUcMJ7BUEXLbzlJvfLs
	Zf7/5zA1DBUBcQIzn2EhyGk=
X-Google-Smtp-Source: AMrXdXvD7Q9KHQmbhNc92/yKRfnw3jtsMfMoYpOwomWGEtMqWH2p/kSispHYpfqkki+y6DioDEMuSQ==
X-Received: by 2002:a17:902:f70e:b0:194:6c1b:60b9 with SMTP id h14-20020a170902f70e00b001946c1b60b9mr3143394plo.25.1673946074705;
        Tue, 17 Jan 2023 01:01:14 -0800 (PST)
Received: from debian.me (subs03-180-214-233-28.three.co.id. [180.214.233.28])
        by smtp.gmail.com with ESMTPSA id n13-20020a170903110d00b001925ec4664esm20616309plh.172.2023.01.17.01.01.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 01:01:13 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id B3210104432; Tue, 17 Jan 2023 16:01:10 +0700 (WIB)
Date: Tue, 17 Jan 2023 16:01:10 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
Message-ID: <Y8Zj1kVH1ZsTT9VE@debian.me>
References: <20230116154803.321528435@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="AB3Wrsy8pv5BIByR"
Content-Disposition: inline
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>


--AB3Wrsy8pv5BIByR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 16, 2023 at 04:48:43PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20
=20
Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--AB3Wrsy8pv5BIByR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY8Zj0QAKCRD2uYlJVVFO
o44ZAP4wptgSFff335a9du3tsByRgSiFcdRi9hNkV8FnjsdHmAD/SnmDT8narLfp
8BlLd7gsVD1+dEtnuqhlLW8gR3D74gc=
=pgAb
-----END PGP SIGNATURE-----

--AB3Wrsy8pv5BIByR--
