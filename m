Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF6407E
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 02:40:00 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so10718525pjd.5
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 18:40:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wny72aPReRMnCd0XeW2CGKHfoxhgRZf/niDzIS7HIgw=;
        b=gvwqRB/LB6onoVmMSOgniy1P3V78tygXvZsXL9aS1YUTqPKdvrbGyHZLh+Gl3HiN9q
         7rldTqoKcXP8q53NKDikwI7acQTxJcPdVFL97twHOP7TowYYTsWfDXrkdUdwA2dNyIcI
         Qicwf6Aa2IqNFT9IYM1EnWDCT/9J327669kv72RVXIsjSDM+fddzXcdRDBUhp0JNCZq0
         4oobvNd/IMextn6OrDRV5Z7GjWKbYFeqae0tiq5TZy1YbbUf0xCe4edfnhrWvNWhlNMB
         sC+SG1ihYQQ6DxXMX3y1LG70f2F24LQ4BP+Ki1kgQBYUI65qXg8+JEjQrQ7H9kcPEOGJ
         3dFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wny72aPReRMnCd0XeW2CGKHfoxhgRZf/niDzIS7HIgw=;
        b=OHiIzjU2OOHWG14LofFyJEkVBuiqniAtC1qb1ZoLrX59LfDZuDIZX8QW4mnAHgXkTj
         cfor0wXwpvtTRYfDkjPVZWQdOeknwFPLPt4jMOE/tiV5V5ax4NlcuUH5ooZEJ+DwnPTK
         F2fzDUZOUHhsri2ScQicn3Skd4r19pfnAbFATBRxJ+vH1DeCWOeFqTO723BVyRb4LIpP
         LWG+23fUECIA0J7HXv6vEQBkgwicpwwYNjUMa0trfgBNOxj6b11ZVsyqjdYVTRXMkgUi
         syiTLcnRIsqH0JJ/hCYP3bj9E1cmwvtFp93v4dDPMdFPz1J2fREOlIey6fR4PC+ejpGH
         9m0w==
X-Gm-Message-State: ANoB5pmNL7res/wvRYIUhijQR6MW0QDCTEbTVJ7IxcQXRr0Mv3eyIDvY
	g5UJwL+foE+u2AgxiHDeeAo=
X-Google-Smtp-Source: AA0mqf5kAXoy+VUHSK32qiFpAkFGSdd6KsTYnWzXlk2u6Dg4ThI58wlhv2zF4gUEobM85yJoJonAuA==
X-Received: by 2002:a17:902:d650:b0:189:f86:f00 with SMTP id y16-20020a170902d65000b001890f860f00mr41234131plh.16.1671504000279;
        Mon, 19 Dec 2022 18:40:00 -0800 (PST)
Received: from debian.me (subs03-180-214-233-73.three.co.id. [180.214.233.73])
        by smtp.gmail.com with ESMTPSA id jh19-20020a170903329300b001869efb722csm7914388plb.215.2022.12.19.18.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Dec 2022 18:39:59 -0800 (PST)
Received: by debian.me (Postfix, from userid 1000)
	id 000021013F6; Tue, 20 Dec 2022 09:39:55 +0700 (WIB)
Date: Tue, 20 Dec 2022 09:39:55 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/17] 5.15.85-rc1 review
Message-ID: <Y6Ege+tgN/m7CDkc@debian.me>
References: <20221219182940.739981110@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="Rrk8ZYsz6jCGEj0V"
Content-Disposition: inline
In-Reply-To: <20221219182940.739981110@linuxfoundation.org>


--Rrk8ZYsz6jCGEj0V
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 19, 2022 at 08:24:46PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.85 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
powerpc (ps3_defconfig, GCC 12.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--Rrk8ZYsz6jCGEj0V
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEARYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCY6EgcQAKCRD2uYlJVVFO
oxZPAQDwlWNKOn75ziDIolWJ5XWOsr4sf3kYt8TYiNxbKzPKHgD/XefvnqTXWM6X
0ATr5wznDHThjrbX/8n19Gaalz7n3ww=
=QFob
-----END PGP SIGNATURE-----

--Rrk8ZYsz6jCGEj0V--
