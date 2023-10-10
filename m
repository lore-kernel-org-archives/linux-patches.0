Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD3662591
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 05:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fOy7B80D"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1c8a1541233so14148035ad.1
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 22:53:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696917213; x=1697522013; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=wfaCoodsVu7yZCYoYj9RudTaxQcfa8byTewGj6h2eNk=;
        b=fOy7B80D7JPir5Iia1TzKSklM4urkN0lAZQ2HWvGmgS83uyQBDD13DG5X81uM8Bbv9
         09qTD55LnT5P7qblgpYbpyvVG7dWX4ZiUBYmEJE5W63i27kvTvysMABmi/D/7RPMIJGF
         w7LRguLsLixpgshEw2z/lVSCg9oxfP23J7vSunnZviaoFtctHyOKotHgyh77coFspshg
         SWfLXjtgpHiN94tRdLdDAq1TYka8r3vuZ936xLdyoE86KonQXxn381aOghZd6iubibQ7
         axw9oWkboJyezAOdE5v9XXPUEvu1UR+X+NBPFoF5+Z9h0/LpxdS4A5/EJ5k+pzw3pIhn
         4Cng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696917213; x=1697522013;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wfaCoodsVu7yZCYoYj9RudTaxQcfa8byTewGj6h2eNk=;
        b=nJp/rfuXjtHq1x+M+rSfVglxIjwFEQYO3Q4WWOZtlqzd+c2FRPHG5l/i2KpfiKLhug
         m3L3XTuWVQ9AkN3GmhUSceunjEpEcp/HaJb2pq/3G18v1xJFYL9sBVgakBTHNYurTEgO
         7rF0Q0UEhb72jA57k819NdfEQ3YnNmi7LwWLEdVLwWsepw6dBF71Zmn+hQ/awyJFOl6r
         UhqNd4mEEcRPAL6JxlE+WybqYPD0gffXiD0Ib4DHAwC7LAceoZbhbsyouIXwAOLcM6wF
         JyEjl+yxNaUtaIoWaDffhpgUFhcO0B+d4Uz3hna78N+0PW5fznGHDjraIklPOo6lgwub
         lZ6w==
X-Gm-Message-State: AOJu0Yw5yVBrwytKRm6I47em2InCnn8U4teHTPQiMgBfrptOTYjkm6bX
	WrAXVfxl3vTsL9T69R1IuE8=
X-Google-Smtp-Source: AGHT+IEigtFwOymrwH6Yg8ON3n5dI4KocGorIBqftErLJBr7G1D/uGzvKWtM/Yc9wNUmDdGbbss6gA==
X-Received: by 2002:a17:902:c24c:b0:1c3:ea2a:9058 with SMTP id 12-20020a170902c24c00b001c3ea2a9058mr13388668plg.65.1696917212959;
        Mon, 09 Oct 2023 22:53:32 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id l3-20020a170903244300b001c73f3a9b88sm10686340pls.110.2023.10.09.22.53.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Oct 2023 22:53:32 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id E13DF8154D9A; Tue, 10 Oct 2023 12:53:28 +0700 (WIB)
Date: Tue, 10 Oct 2023 12:53:28 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.1 000/162] 6.1.57-rc1 review
Message-ID: <ZSTm2EJ6RIQGJH3m@debian.me>
References: <20231009130122.946357448@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="B5/N2J/Pr/nfSCYq"
Content-Disposition: inline
In-Reply-To: <20231009130122.946357448@linuxfoundation.org>


--B5/N2J/Pr/nfSCYq
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 09, 2023 at 02:59:41PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.57 release.
> There are 162 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--B5/N2J/Pr/nfSCYq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZSTm0QAKCRD2uYlJVVFO
o6emAQDNApQG/SZmeJZarDbPBuGLFvJSpM3hlIMG6o7JNG7qUAD/cn91yQ+3PVeP
HZlyWhX9OJx07zlXpXCMHpATkUzW6Q8=
=OUoF
-----END PGP SIGNATURE-----

--B5/N2J/Pr/nfSCYq--
