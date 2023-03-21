Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF34185D
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 04:51:18 +0000 (UTC)
Received: by mail-pl1-f181.google.com with SMTP id w4so6783946plg.9
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 21:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679374278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=AII7onvNh0XTKeparTJKT1aBkAQlRV5EfnYZkxUIGPI=;
        b=QoRHphEL8ZIwfgoYH/NGmU3kYdjTIO5xFzzu/YNEtRfE7M0mSwhy9UIZQeqz02M8oy
         1ViZyf3tOspGHBNELlcIKN1PlTE9Rg4wI34/EXumUC21vCkqG2QGg4TQcpL7HwtmURHY
         l87jTlVz8brLLQOTd9cFDFvBp2b/LXfWqYR0R8SQINTPDeSBeesT5FsuEKn/yBp0x/A0
         s3npnN+dwyygxwibr7e2t1mklBx+969P8HyqlBq0Xmw4J8ikfePObWN+XuRoxCWqvtwC
         ApMLmyGXMExQmLslXPeHllKV9VFthJAla3VS1l+DkQTSDekj/Q1wbsriNn7IZtDrt/1Y
         8r4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679374278;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AII7onvNh0XTKeparTJKT1aBkAQlRV5EfnYZkxUIGPI=;
        b=z7kVxER9IawGKPYAuYzOS9zSrdeWJ+i4j2LhpFHxhnvlYZz7oNfuyqhv+C8nxL9vjG
         9r9PRNpbN9MRBXqkz7d8bXdR/mz3wmQ//3o7buKBgx2S7Jim3blh4Nx16KG3W5HcrQfX
         YV44vYcoHGk5OSTE/l/I6lo3yHUU+JxaeKmURwsDlapy4z7+2fowznQTAXP9XrDEHqTp
         yhfDxhRC7YXJ7RIFaZg+IL8V3XDfKmOt8/f2X6psQysxwrWnKticuhZchs8+M7FqVr3K
         rbuiK69FqPogorxwDlDfF1G8nVbkbf8YDGeXlZav0e4mJh0bVPteuUZ8oUEr0n1MMT8h
         3TYQ==
X-Gm-Message-State: AO0yUKUO+Kp8ifw2w1/otKwwSm9FVqgf91ISDpfry/yaO1R/O0tMyNJv
	sRfFITrNNAhp3nE7E7ipz04=
X-Google-Smtp-Source: AK7set9SuLai7Lg6fyJzhgDANa+f/KtBjfTcPdjnsx6UKECjqZ/rLR/F3yTENeBP5hru1Twt+1R9ew==
X-Received: by 2002:a17:903:124c:b0:1a0:65ae:df32 with SMTP id u12-20020a170903124c00b001a065aedf32mr1120468plh.37.1679374277737;
        Mon, 20 Mar 2023 21:51:17 -0700 (PDT)
Received: from debian.me (subs03-180-214-233-8.three.co.id. [180.214.233.8])
        by smtp.gmail.com with ESMTPSA id y10-20020a1709029b8a00b0019a7bb18f98sm7601920plp.48.2023.03.20.21.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Mar 2023 21:51:17 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id A8485106617; Tue, 21 Mar 2023 11:51:14 +0700 (WIB)
Date: Tue, 21 Mar 2023 11:51:14 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
Message-ID: <ZBk3wibPN5dSe7cG@debian.me>
References: <20230320145513.305686421@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="oCLL87y0E6lcm2MM"
Content-Disposition: inline
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>


--oCLL87y0E6lcm2MM
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 20, 2023 at 03:52:15PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--oCLL87y0E6lcm2MM
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZBk3wgAKCRD2uYlJVVFO
o2lVAQCxBh7e94urOdOwu6CU4EuNbxNQKnVgCpIIOKMb1Q4YMwD9FVoWukVZYmCv
PNQl+oC3J7Xqqe5ZhcWOQa2eFZk6QQs=
=wkZA
-----END PGP SIGNATURE-----

--oCLL87y0E6lcm2MM--
