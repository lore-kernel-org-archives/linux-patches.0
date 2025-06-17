Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BB11EB2F;
	Tue, 17 Jun 2025 01:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750125580; cv=none; b=AP6pHWzscTdSY+xc8FOLIp1c94VqqdPzfcnRuL8GBwJYEhzOJgvLDCfupxmNdopj05IjLign5ASg9IQExnyp5lIYGII+r1yPl/nww9woAsDCh48/2r7RmSTIPBjVTuVcWurSI22m2wg7NNTaSmPSahsJyXyBXcwCzhFm8NliiNc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750125580; c=relaxed/simple;
	bh=+Coljb4R4UpMZYUnBt8a/U8959C/WB4Dycfl9OSu1vY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dd+VLWE/mBNE2fZwmhlzSj4Gj3TjW9FhoUltM2RV0IAUDqofilmz0BAN1cXcQAF4999f3qgIu6t/syJvhbUAg0LoFh0N1AoB7bjRFMiMta+oaJJ6sbFxIKvzC26iFYcipaWfugfzFKHasenrI8HlB1Nlzxklrn3788Mgw7LoU04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HyUyJdkf; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HyUyJdkf"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-235f9ea8d08so50446745ad.1;
        Mon, 16 Jun 2025 18:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750125578; x=1750730378; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1hX1AMDY5tzO+6pgqDEAwgTSbR/ALB7lMXeQZAvSn1M=;
        b=HyUyJdkfAPzQBH2APcOSTA27DIAZtIlF5Vswtenieg+B5s4IEnDNGksmKJ8g6KrQAd
         aKXcdNUtkQYZeK/8qPlSJXCp8OB//CUW6+EcabsIU36JyHtmcpzw/9VG4ytG6gBgP3eV
         UpySHGBwR60Dwelxd42Ifi90zfVpzt7Wu5VirdGBmh+lNDVawHKMKMPmQelIMLo7m8m1
         kzLr4P9rzMeZdIIm2M/1ZCYVs+ovrKICuTLyltAU2oeQ99ypUIA1AE9Xq60dQuiWAbcI
         R5M4pfUkVUU4Yg09zRPep5PI6ByX0N6L4o0eF7KY9Gm8oKa5ZYoqqm+TbCDElE8flOLW
         2HHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750125578; x=1750730378;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1hX1AMDY5tzO+6pgqDEAwgTSbR/ALB7lMXeQZAvSn1M=;
        b=c58AdebTYfPtI+mwwz47O46e7YRKPsAHZ2/Udz5w1yDc65D7Ixv9lm81tBAnXxsV0c
         yLsVtiaU0Zx4GzNz6CwLXZSaSe4CFkv0V9EOdC2/3+/1uDeRE6SD3pQw9/UeI0Pbzj6Q
         rN4DV/GE3pjyNX3L4WjPtPrsoyiqZ8DBLK5uGHBJsMYS9HVdCmBSTQVXeIL1Kq//Hq6+
         p88FypSWEvzGPR8ogCV0ais9T8h9sE3o1cvJ6yE7lUq1gVJCAHBdz09Iv7JbvfouVrIm
         FFICrM2KVmhY7tkPk/OJZZ9Er73Hc7T+ioGoznHagNY2+5J3Qf5UKe9lbMqlixaUuThD
         Ys9w==
X-Forwarded-Encrypted: i=1; AJvYcCV30HWCKcoIL6ZqTYAf5KHMHeXQzrt7K8a+O4Uz/w0Wml1ljz6LZpmkWz3vI4hPK5gFFT+fSg==@lists.linux.dev, AJvYcCWwr/e8AoU9xYH+rlCtMTVGCViM10ZT+IVJt8p3gucOXEk+gIBLFB1nS2LnjX0PhOFODW0tFQ==@lists.linux.dev, AJvYcCX0HLLwZWcPsXRC0uYGSKpltqlpXgdUpnwGSsiNFs8tP2bC44JOBzr8nXZFD1H8EVFOa7oauo4b8Q==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/B/sttEYyIQspaEEUpGS/pV7gV2eN42cfAHlNXZwLlyCFQKCS
	qZ2GpEGtSmq4PgiFN01TEOpIuYY2TiGPAARY382k4s2P5QmRmh3LLcAt
X-Gm-Gg: ASbGncuGafzzbUL91cV4u5UwjG8fsAdH1crtc5fBg892aV3aJNl1hlw5eug4qvoVOr0
	yFfo8Qu5fPWLzthpviG3Cl9/fhK65uqKFQ0sv9wJuY6GAWCWOslSt0u4zm5e+z+Ga1H9tlm/7Dm
	F2eLRLwzAQc+y64DPsg68d6CdrJnHZh3aNN/5J9RbYGP592gaLCyFeQcSNkTHy9sCWVJtNMjRUO
	cMGG/czERHEZnz31ckClP238VfS4tv5ZK0pSMxU9yH/ujqnaOfXR4GWqc2gCfrm5rPc+EOcpaDN
	NJZLLN7nTT7a37eAyimlQKQwJc5CvPZuY3Df/HAONXCysUTggRZ2WTIutlh79g==
X-Google-Smtp-Source: AGHT+IENVlr6sfypZBCSgv1TrxLQcdnU8woHB/y1+TMTtAT53FcBiiSN7tzD7G2ULV+Kckou8Pa6UQ==
X-Received: by 2002:a17:902:f551:b0:220:c4e8:3b9f with SMTP id d9443c01a7336-2366aeea034mr181020465ad.0.1750125578166;
        Mon, 16 Jun 2025 18:59:38 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2365dea9259sm68798855ad.157.2025.06.16.18.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Jun 2025 18:59:37 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id BD1934241812; Tue, 17 Jun 2025 08:59:34 +0700 (WIB)
Date: Tue, 17 Jun 2025 08:59:34 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>,
	Kevin Tian <kevin.tian@intel.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, llvm@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev
Subject: Re: [PATCH v3 02/15] genpt: Add Documentation/ files
Message-ID: <aFDMBt1J1w8I_A8U@archie.me>
References: <0-v3-a93aab628dbc+521-iommu_pt_jgg@nvidia.com>
 <2-v3-a93aab628dbc+521-iommu_pt_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="4/ywsSHr1lDelbCB"
Content-Disposition: inline
In-Reply-To: <2-v3-a93aab628dbc+521-iommu_pt_jgg@nvidia.com>


--4/ywsSHr1lDelbCB
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 16, 2025 at 03:06:05PM -0300, Jason Gunthorpe wrote:
> +The generic tests are intended to prove out the format functions and give
> +clearer failures to speed finding the problems. Once those pass then the=
 entire
                    to speed up finding...
> +kunit suite should be run.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--4/ywsSHr1lDelbCB
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaFDMAgAKCRD2uYlJVVFO
o5mNAP9EmUtcal7Izvqw7lP3O9S78LPihsJ1bErtgFPJlzLqWgEAlIEmVujduHqZ
WoGwLnF3VHBf8yd0JdamQ/i9qhWhagE=
=/KQE
-----END PGP SIGNATURE-----

--4/ywsSHr1lDelbCB--
