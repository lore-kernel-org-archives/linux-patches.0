Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F03A7F
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 03:19:35 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-68a42d06d02so1194549b3a.0
        for <patches@lists.linux.dev>; Mon, 21 Aug 2023 20:19:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692674374; x=1693279174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=QVaw4tiSyySSYVra+1OgfCW3zHmTwq5IUAn9t1HVRdk=;
        b=Fpq7Y1q+oBNXqPvgCaJhcGskS8L4ei/pGFeyFFYomGrlBqWDktl2gLAreGcdNTJlOh
         TWXbN1P57z7arZZGeH2pAsjU1rgj0kl4bbwvJwxI71SDnvsZBRW3JYeNbrUnDUeAf+73
         4P90KTHOwqkQhJAzNiAGiBT0OCMcGroUia7aty6eiy0PHY5K20ANnOhfVlkMRjA7AB5b
         PKr/NN+7rvCHkY9zj1WU+lUzoh6hfnQJHzHLz2vaA2HQzN+w4Hvk/OEwShD25tGB/jeV
         MXrTSjbRSFkEcdBHnv4elJbkoBHaR/2SxAo5Tsq/WWj3Z9tCCZ8sVMFDXZJ5J82mQioU
         fUXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692674374; x=1693279174;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QVaw4tiSyySSYVra+1OgfCW3zHmTwq5IUAn9t1HVRdk=;
        b=FsYWNd4WWy0DHCPHjKefpgHSJsckT2R9XsTpcKfkseNWwBB9GmZFs47sicUHAm1Lcv
         F3nIJbzg0uQ9b4qLjvQt9F5zZmsosesZcNbeN4f6bOzqoFYsbgB29hsY4Wi+twtcMq3x
         0V2cLKZ7GeMcQNhJLTxGj2qcrF8pyWxz4X8x4q+Y48Q7k/Liv79i11+8H6li/JIAa1If
         MZQ3j81A0Cs8T1E5yOk92cIoge2+5XLskbrsubdzjnO6vX+MJgwMuQu1b9vZgVpIM612
         5RaLwBxG5aaoTsFyigTFjxN/wOo8f6cjAv6EgXFDdscLvEFkbeq6uqOFgukBCHj+n4Yo
         szwQ==
X-Gm-Message-State: AOJu0YwT2nrCS9CR62KLq2I3DIOhcfgBktg1F0k1k+EUfidmSm7/4htQ
	wZqe1mjc2bUtn/ye7rxSkDg=
X-Google-Smtp-Source: AGHT+IFVaiYgPWbU5gb20xizv8xMU3ToF01RakEjSE9TDjJA72zl+lMGcxy4KhDTstAN7q5X+hkb2Q==
X-Received: by 2002:a05:6a21:6da6:b0:148:6a9e:143f with SMTP id wl38-20020a056a216da600b001486a9e143fmr6175549pzb.21.1692674374378;
        Mon, 21 Aug 2023 20:19:34 -0700 (PDT)
Received: from debian.me ([103.124.138.83])
        by smtp.gmail.com with ESMTPSA id a16-20020a170902b59000b001bba3650448sm7798614pls.258.2023.08.21.20.19.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Aug 2023 20:19:33 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 7AFE68BAEED1; Tue, 22 Aug 2023 10:19:31 +0700 (WIB)
Date: Tue, 22 Aug 2023 10:19:31 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.4 000/234] 6.4.12-rc1 review
Message-ID: <ZOQpQ873V3bfS4Vo@debian.me>
References: <20230821194128.754601642@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="5akErifBNQ1KWG90"
Content-Disposition: inline
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>


--5akErifBNQ1KWG90
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Aug 21, 2023 at 09:39:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.4.12 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--5akErifBNQ1KWG90
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZOQpPgAKCRD2uYlJVVFO
ozfoAQCmIpWl7OnaJSk2tWGfyHKJDKnfedmzdG2d+IFR087qFgD/R6Fqpk08fYro
1baG0megf+allZjl55cDYbZiUi70CAE=
=gi4j
-----END PGP SIGNATURE-----

--5akErifBNQ1KWG90--
