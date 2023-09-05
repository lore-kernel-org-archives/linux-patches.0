Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480E2363
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 04:43:35 +0000 (UTC)
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-564b8e60ce9so917680a12.2
        for <patches@lists.linux.dev>; Mon, 04 Sep 2023 21:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693889015; x=1694493815; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=J0V2FgytkL6qM48rXQ4oVsdXH0Mo9LDUYeEyaMnuyp8=;
        b=ZsOJ/3Njiuw2lg2aGHqidd9mj8jOuyDvDmELhQY8T/fHCqv8z06UhXYGvuxC/5vRcT
         bfWkrG0fQd/iydE7IoZlbOlzGyZYkbs8ksYAA/9a//RVjWcWtH2o8+NZBHJcfgIgPDxJ
         B6fQovcXnKghEFK14HXstK4AHPI46RkszFAAOpIco8rucKbweG6rPM+LhZU41igOH9j1
         YwR8V/Pip22nRAeJsFu0ZXjIF17y15FLrxfc88NdJ1ZB/PNX00/hEc1zOzZe5z9u2pAZ
         DxgD1H0DxmWKOuxIkKoII+Ij5qwUCBicMYh2FZnV5me+4NBtR9jx86xx058Jl+OeW6yG
         tUog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693889015; x=1694493815;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J0V2FgytkL6qM48rXQ4oVsdXH0Mo9LDUYeEyaMnuyp8=;
        b=ADXO6p4Tk4Ruat+0vPgkV5HBQ2WNaHP8ebAP1vJk5hPJw90jDYxzvNBv2cxBLYpbO5
         mVtlbE0DiGFevZWO+yb1Xc6tS3+sr8pjBPLh+/LqGyHeMyfxBoHvQ71Y+vJStPB3yMhN
         1p5E3hJI3xFcxJUcKb2/MpLYnvQpp+EEI/gmj2Bi8rLykRl9oT4oLGlcVF+wxKoQ2WEC
         jxDTQV42vLx1WPHyWEXZ9edEsP2aasSoDmZLu5ubad5z1mpiqXFqwGh/EQTw2Xzzl+V/
         LcgCqo1jyljTTSfMfklYCCRUNzqBd8ooZDQiQPkJb4Ka35GhNbhZGju4SNjI1Kc/onFi
         7DoA==
X-Gm-Message-State: AOJu0YyZTcGrbbyzTdYbv5NMLuItYjlQaCYxiTLNUjJefU6bgt+DQZRj
	Hdkm45cf9X2p69JUS1MmtrU=
X-Google-Smtp-Source: AGHT+IEnU+MIeffFTI+Kg7b5FgdzaHIO67u2BytPQHqVVH4istZfGmO7HzXkoOlBjNODUrLKv9bTZw==
X-Received: by 2002:a05:6a20:9183:b0:13d:bf07:7444 with SMTP id v3-20020a056a20918300b0013dbf077444mr11402794pzd.0.1693889015324;
        Mon, 04 Sep 2023 21:43:35 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id jd5-20020a170903260500b001bb8895848bsm8343417plb.71.2023.09.04.21.43.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Sep 2023 21:43:34 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id AE2B180E14C8; Tue,  5 Sep 2023 11:43:31 +0700 (WIB)
Date: Tue, 5 Sep 2023 11:43:31 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 00/34] 6.5.2-rc1 review
Message-ID: <ZPax8-wQGxLMxvoE@debian.me>
References: <20230904182948.594404081@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="qNCG87IULPT+hZbQ"
Content-Disposition: inline
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>


--qNCG87IULPT+hZbQ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Sep 04, 2023 at 07:29:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--qNCG87IULPT+hZbQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZPax7QAKCRD2uYlJVVFO
oybNAP9b3aeerA2Jw6GE3bfYmmvJe3AZQr3cxuCDeO2GjA3oogEAlqQ+B3O+QO7L
PZQSgZb1Syhhsw2JsbO4jDiA9ry2RwU=
=pT0D
-----END PGP SIGNATURE-----

--qNCG87IULPT+hZbQ--
