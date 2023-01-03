Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789AB320E
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 12:07:22 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id p24so9886673plw.11
        for <patches@lists.linux.dev>; Tue, 03 Jan 2023 04:07:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=4YTcBq/d5uRH9l2ywJ8UunndbU4kkt0aA/4OyP9/uKU=;
        b=AIybuFvKfbVUmbkQiGcnrCGD74SRbAgrBWTHYTNnLGf9JjO2yzeskkFyuUeaTysVRl
         D6JCtCI8n2Z/IgyOPNcV6ChPu34uWzSggZFeElGa5qjRU42xDI/DXbGw4TGCkFuduOC9
         BiljlTGAhqQZOMfOe2sebwSPQVf4B1QtP70YuSY1vZjeeIP3uvg2JcyvKgYAT9D7cAyg
         3OhaZmYCYNpmx5iccHbn7iQLoW1vicJaT9VhpxilVPTl/8aKGHBmiUhmEZt92FRO14br
         kMF9w/Rjn7IJ2C4z64Q5ZmaXJruZXFnuwsk6Zi/3rnrQHe5jQ4HZJLBjAY/HO2PGsfRU
         8JKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4YTcBq/d5uRH9l2ywJ8UunndbU4kkt0aA/4OyP9/uKU=;
        b=Enx7B5lYgCGiSZYYe8MXZdDQXc2ptqlJdc2wzdnD5T0w961OzevwQFWWZLdITGsV+a
         VxUOA73hAF0vleNhdVHhinqnEhqhMYqydYBpCPjfbDLqiODaSFU5nbNv4pyupkkoeyt7
         fxPdW5bUjdfnjtGFYPuCDFzPDwJL/Uisn+W0SPT9ITeGRrpWF1KAO77m5vDsVLa0XJqx
         dMhJOs1FR8ZyylM2eBFWihj7OxOJjc3tdLXqdJotZy8zBoVRJ1NSPj1/BnXtwT9YoNlp
         aGvYApqfipD/ZjOYI48Sb7o/B6WcU26D5ALdLBfzyt/+SVW0KSt+pRD40zwgPOc1MUlE
         0HXQ==
X-Gm-Message-State: AFqh2kqfZ0S9zc5hK2M8tbpPCOkw7HVzFx06wNd/oowM8bpBQ0GG686A
	IVIBMn4FmnBlIDHy4zz79YA=
X-Google-Smtp-Source: AMrXdXtCfhYPKQYgQzigoyMRBT+ufCTEhqmuyXK+M4Q5JHThtVt4HZLhXRtHtAm5KE/fbWgfXnjp1Q==
X-Received: by 2002:a05:6a20:94ca:b0:b2:2719:8f11 with SMTP id ht10-20020a056a2094ca00b000b227198f11mr54171398pzb.55.1672747641896;
        Tue, 03 Jan 2023 04:07:21 -0800 (PST)
Received: from debian.me (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id y25-20020aa78f39000000b005823b7da05asm5752745pfr.122.2023.01.03.04.07.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 04:07:21 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id A2C7F10415F; Tue,  3 Jan 2023 19:07:16 +0700 (WIB)
Date: Tue, 3 Jan 2023 19:07:16 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
Message-ID: <Y7QadKdJpOynpf9c@debian.me>
References: <20230102110552.061937047@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zoa2ik6VUPcuUovB"
Content-Disposition: inline
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>


--zoa2ik6VUPcuUovB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jan 02, 2023 at 12:21:33PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--zoa2ik6VUPcuUovB
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY7QabwAKCRD2uYlJVVFO
o080AQDUMN3ykJWoLoM07Xhtv3wd4Pk7XHpeezYQXNpqzkS7kwD/euh/tAW+F5DS
rW2FKAg2HWPe75iIocFKTNjVBG7kiwM=
=evB3
-----END PGP SIGNATURE-----

--zoa2ik6VUPcuUovB--
