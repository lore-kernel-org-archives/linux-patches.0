Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4F507C
	for <patches@lists.linux.dev>; Tue,  9 May 2023 02:07:47 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ab05018381so49713145ad.2
        for <patches@lists.linux.dev>; Mon, 08 May 2023 19:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683598067; x=1686190067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wWdXLC6ETOY0c2W6fA8rFsR/hDq8/E4z6dhUGEDMr7o=;
        b=P8cOBJSh8RIMgjYp5kMULSFbvLCMXFEeESwc4yX8s/K71W/NEptjVyNWCoDrGMARwV
         UGEyWi/NVpLKh1wdTdiSk4bOuOOUZoRo612kR/xwOHovE9dJpzmirgVstHy4cJu0IoiE
         +l/poZw1eXmMkzj5s71FVEdkMJpIOitJLzwqtgvfDV3OaDMFbvvXKGuYpL2oRMNcNgxv
         +CnMyLxlQxKjlkSk6Bxo01hls+WmB4z4LKFZNlxNOfpOey+oMHYiE0fotGbTuztD4kyQ
         CZgx3isXIUji0h6PyLfzlMGyWzfevJltIPcFrtQOuLPPNEpHs7BWy7/hQW2pvVDu9nHI
         1Sdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683598067; x=1686190067;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wWdXLC6ETOY0c2W6fA8rFsR/hDq8/E4z6dhUGEDMr7o=;
        b=DE2p9aBq6U30Dby5K5Btk20xE12utm4Zkcdd2tlNpSVNfohsYjN5ygIGseho183ONw
         qCeBkk09qXWUE0phFAwIiZ4IgtHnGAY2ZZpaftGvHf1lTdnfNxabcHOBg4uusJiNCdGo
         VV+VN6spyGBe8B8zgpdKC9ITuarPaeOiTEl2YqP9/ryaeQpipaPoDz1NmoyvQ6itXAjB
         cCk1Cr/tYAgrrApBelA99pFvDcbTB/aPiIu7Pn0Qv9uFm3LtyZsYK1AdEJw8T96xIEX8
         a3jNEk1KW//J9FjA8O68HH0rtqcOIktkc2ZU9IqrgO2ZL7abe66fJH1zPRjCNoqgB3vU
         Zp1Q==
X-Gm-Message-State: AC+VfDyQSz2UOMrJkUTIOswTfaqx01Mx1m6U10EYjJxYw3xLADjBWcF3
	uEkN3T9QDcmR7cmYPOFi+yQ=
X-Google-Smtp-Source: ACHHUZ5ov1MWFkTimLGYY7iJ4/3pwiCCd/C8wOZ8IHQMfE/fw93gh0XgiWaK4cO2uIphN/6sDYY9QQ==
X-Received: by 2002:a17:902:e84d:b0:1ab:eee:c609 with SMTP id t13-20020a170902e84d00b001ab0eeec609mr15653688plg.40.1683598066911;
        Mon, 08 May 2023 19:07:46 -0700 (PDT)
Received: from debian.me (subs02-180-214-232-7.three.co.id. [180.214.232.7])
        by smtp.gmail.com with ESMTPSA id g11-20020a1709026b4b00b001a0567811fbsm163189plt.127.2023.05.08.19.07.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 19:07:46 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 6E18910687E; Tue,  9 May 2023 09:07:43 +0700 (WIB)
Date: Tue, 9 May 2023 09:07:43 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/371] 5.15.111-rc1 review
Message-ID: <ZFmq773MnSAEzJKs@debian.me>
References: <20230508094811.912279944@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="9eO2jvA1Niv8Y0I3"
Content-Disposition: inline
In-Reply-To: <20230508094811.912279944@linuxfoundation.org>


--9eO2jvA1Niv8Y0I3
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 08, 2023 at 11:43:21AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.111 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully built bindeb-pkgs for my computer (Acer Aspire E15, Intel
Core i3 Haswell) and booted. No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--9eO2jvA1Niv8Y0I3
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZFmq6wAKCRD2uYlJVVFO
o4tjAQDBripPkSqMUmOsrdQre23VDXgOsTsH/lus9MTweGflxAD9G6RDIYHdLNZg
GSaLdMkdOqY0W2JYbcgAPJeWE6tqyAE=
=hK5p
-----END PGP SIGNATURE-----

--9eO2jvA1Niv8Y0I3--
