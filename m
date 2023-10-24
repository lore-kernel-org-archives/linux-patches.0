Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325281863
	for <patches@lists.linux.dev>; Tue, 24 Oct 2023 02:49:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QRhHP3ty"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-27d1fa1c787so2568956a91.3
        for <patches@lists.linux.dev>; Mon, 23 Oct 2023 19:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1698115749; x=1698720549; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fVsLY+T+frlNzIkA4CFr7Weie77YHu/MtNXkFtXeImU=;
        b=QRhHP3tyg/VN3BOwI/G/v+74ypVI8+iAkm0Au1rAW4iZOAgZnkSzqPB1EWQ7fj50ij
         LBw94uPT/DqeyMTUKv2DGZ46sW7yZaB1hSfMjz0grK3x7UcfYOocQWUkNbcLmk766RQR
         WDZCVK0h6/HvAWh0mbPNgt4WjL5t/mbwb88F6vPbplytG+EJaFVUW1B8n5PrSSAAdLJP
         E0uZBSKnW2C9TsV/zM7E1w1oQWmuevyRyya7Bhy00pN6vdvlpugvs5W1vesNopcL1AI+
         mTLcW5uaf1o0W8oG2i4jxnPcl9zqJSdcwQqcbHDs8QHGFYpoPbAm+TLCuIUIsLC17u/+
         O7WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698115749; x=1698720549;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fVsLY+T+frlNzIkA4CFr7Weie77YHu/MtNXkFtXeImU=;
        b=gNdnKU27XOnWRB8CR5HLHkxGRZUSq4IJ5iR26r0vAbe4B3mF4u4K2e4cUEN8AymvEy
         ZqgOXwrFJzsWusUqHQATS3MxjT6UBgATcfrhrDdvFZEs7/0Npe/dkColi3Od4fbqhCAe
         iPj25+1zm/wnUaECwXBp5JwFH7fgj5uzWWM9JT9a19IGDL5BYUNrzV4x4JDqvED76NYk
         lwxUvRaCWyOtutAMjx2BEhRaOhLhgIHNK114DezW6847yzT84gJjNB93VSgt3jTpCTxY
         HdcfYTJq6Wra7O3ZtEQP/JXYA4nNyNtdvHc/t7fy/XGWeyTOgccBSsx4OAEom+8YJ4Rt
         Opzw==
X-Gm-Message-State: AOJu0YyPNE32Mvdni9+1+ye9xPL5RFPqf4FES2yjpkgePBSWc/hZEw/S
	dgkJ49ifOih3qrhz/bZ+WDk=
X-Google-Smtp-Source: AGHT+IHLyzVPkA4hnl2AdL6IpBmZ0xApdXiqnfPpjWULmzyQMg0qxYpVuIJg/DFvlgCmtqTBjbguHQ==
X-Received: by 2002:a17:90a:df95:b0:27d:4249:4040 with SMTP id p21-20020a17090adf9500b0027d42494040mr7884810pjv.43.1698115749277;
        Mon, 23 Oct 2023 19:49:09 -0700 (PDT)
Received: from debian.me ([103.131.18.64])
        by smtp.gmail.com with ESMTPSA id jh10-20020a170903328a00b001c736370245sm6628325plb.54.2023.10.23.19.49.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 19:49:08 -0700 (PDT)
Received: by debian.me (Postfix, from userid 1000)
	id 0E98B835CB47; Tue, 24 Oct 2023 09:49:05 +0700 (WIB)
Date: Tue, 24 Oct 2023 09:49:05 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org, akpm@linux-foundation.org,
	linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
	lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
	f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Subject: Re: [PATCH 6.5 000/241] 6.5.9-rc1 review
Message-ID: <ZTcwoURTiNuvTLqt@debian.me>
References: <20231023104833.832874523@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="EqdcrD72/hPiNIlf"
Content-Disposition: inline
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>


--EqdcrD72/hPiNIlf
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 23, 2023 at 12:53:06PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.9 release.
> There are 241 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>=20

Successfully compiled and installed bindeb-pkgs on my computer (Acer
Aspire E15, Intel Core i3 Haswell). No noticeable regressions.

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

--=20
An old man doll... just what I always wanted! - Clara

--EqdcrD72/hPiNIlf
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCZTcwnAAKCRD2uYlJVVFO
o+0WAP94eZENF6MiUrUvOeoXW+781DqNKWbD30r5KyXqRDt3JAD/WFw3zpBi1C0Z
oUkb7VrL1V55aHO7O2u1ceyQv9EzXgM=
=E6zm
-----END PGP SIGNATURE-----

--EqdcrD72/hPiNIlf--
