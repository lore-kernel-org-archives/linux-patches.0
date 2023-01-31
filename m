Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D09A3629
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 03:22:51 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id h9so5142085plf.9
        for <patches@lists.linux.dev>; Mon, 30 Jan 2023 19:22:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vG4HRPGwHOheVVf/QPtVzGGTxbkGE8FSy7eSh3uTxcA=;
        b=eHDZcFPLyZOm5E1L9sYIUGfqk2aeslWuBQgkI9k+9MSz+9mCLxVGeHS+NDyeUGEyjc
         JVuwe4AWhX6ncqv3hBcvMPbLkoTX5RGXx1iq3rPw4V9nCdaIxWkqHcAOkQPRFJ6IAJVb
         gy5t28VggcNRzV7s/jgwoH9dHsB1e9XjbwjE3O8WpQY3QAyKnVyqi6xV6YOB24N31sJt
         gVzq0/poTz30G438VNM6SIpb5Phmiw5GfqCb2JJ+jq+awG2yHZ/TD9I9SFrhrAFPr4h7
         hLH3SG5jGkNeaz1moc4UjZcAQBwJ+GyMEreprCKk4YIPUq0bhie9ICAc6kuEB87aVZZt
         GwvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vG4HRPGwHOheVVf/QPtVzGGTxbkGE8FSy7eSh3uTxcA=;
        b=x0irP46tnrHDVr67XsQIjX74TINGXYwhs82VeWUe2HILTe3I2DS6H6W0DpThJBxWVn
         J1Wc3+3Pl8Ms8xmhjCw/C1OPbXB+MQixUYy8/dFUHFmAJxc2MRsXQRlfJ47xIzyedw7w
         C7w+Na8+Y6ARvgBhyHE33wu0yZnfkJ0CIpkAwGZpl4+p34GXq7gljk4GHIbJ02uHhNEr
         7EYZ9vun5xnO181RfO8yE1kOPQHqgWU4GYT4/nOFs71KMZjdPzIg+gNKq8RvnwoJuUGN
         NT3W69/kgn1KISXAGtCGGw8lMgHMNrnBUattn2AOiQswjvggi6iwtD5toOjHxwrP5O7q
         Yr6A==
X-Gm-Message-State: AFqh2kqJ/1I+f9/dTw+jbxDbOR2NRYjf8nJe7/QQHCxuYa1TPVmhIeT5
	3H3YpaiHBLfz49C6bptZA3m+Gh0bvJk=
X-Google-Smtp-Source: AMrXdXv7M7/voezgO+LIkFY7sVQESvlLf3yCrzfKpuNTCWH0Jd1xN2jr/T64dYhDfF+GEkz7Nt+5+A==
X-Received: by 2002:a17:903:2292:b0:195:ea0e:3226 with SMTP id b18-20020a170903229200b00195ea0e3226mr47240068plh.31.1675135371294;
        Mon, 30 Jan 2023 19:22:51 -0800 (PST)
Received: from debian.me (subs32-116-206-28-47.three.co.id. [116.206.28.47])
        by smtp.gmail.com with ESMTPSA id jc7-20020a17090325c700b00192588bcce7sm8556591plb.125.2023.01.30.19.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 19:22:49 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 516D61051B2; Tue, 31 Jan 2023 10:22:47 +0700 (WIB)
Date: Tue, 31 Jan 2023 10:22:47 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/204] 5.15.91-rc1 review
Message-ID: <Y9iJh8u2QpRfsg60@debian.me>
References: <20230130134316.327556078@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="iLese16q615lvexf"
Content-Disposition: inline
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>


--iLese16q615lvexf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 30, 2023 at 02:49:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.91 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
=20

--=20
An old man doll... just what I always wanted! - Clara

--iLese16q615lvexf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY9iJhwAKCRD2uYlJVVFO
oz0OAQDhuo9JyToQsD1sMx4rGrCsr8yE6wTEaAKDxvsnqzBOogD+PqReVsSWFB8x
bm8NeCQCKGZnjnVtEz8jagNa86REEQk=
=F3d5
-----END PGP SIGNATURE-----

--iLese16q615lvexf--
