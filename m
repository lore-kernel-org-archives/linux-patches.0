Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 320071527B4;
	Mon, 28 Apr 2025 14:31:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745850696; cv=none; b=KYoEjqQTBFvLxM1ILEuCKr9/vMcH9iLUifHHA1tiJb7SN4NakON1tcWU6GzxXd/eukcg3eMlvCwrpWTtAQ+2HxuH7dRIf90ZAfPx813IIRtimr9jZEWacRfgdQ8B978/uYPdqwI3a0IdK+KAdWsYGVAEf+yzkElxKNaKVOlEkt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745850696; c=relaxed/simple;
	bh=NHhnqNyU+X9x0PgjbHhqdTx3NWTApQzLscPiWXWZPWU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iKiC2T/lnivqLBk/y06xLGq6xL2y0PUE/2DwfRslvApsEMNzPE77w8rpzFenNLWpo4ARyqQ49SaUeg5/4koh2yzEwH7gM8lR/duFytXDFY/0JhK7lEj3cmua5igEeB73ShF5dRGUqiUmqz5TYkuNQ2zvNX/HuPHymqxycj0rqmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ix8/YilV; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ix8/YilV"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-736ad42dfd6so4136924b3a.3;
        Mon, 28 Apr 2025 07:31:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1745850694; x=1746455494; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EGHvgmXuRyhO4FY9ie5ulcZe9dpbfqVfa/omQpTJU54=;
        b=ix8/YilViF968+Bz7Pw1Mn3t8tEJyK/jK2oOXqEdSwFvGx7pwcNSW8vq2MtuuGrQ1+
         i0CnfC11R//zls8iBwkkLiZHCXadDaSkaYTpJk/7aiO25XFtWjkXGe0dqhaLQYDp5yyh
         if9fRw+hlEsXyw0ykO4poWs+WEbxUCx0hn4X2mhqqsxSZZYHsdgJAbbaCChgQr8HCkvO
         DsyHBq7yb39fQ7Zre0HCi666gNFenka0FIJumaAYm/g8SXbi79ZgJqffnF5kfVGpUb/V
         G03Q9Y2YdfHmKsRYII3bl1BdkrYqfmadBCu0O2HhEvM2NETau53mF03R/ZaOf8XesNZ/
         7chA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745850694; x=1746455494;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EGHvgmXuRyhO4FY9ie5ulcZe9dpbfqVfa/omQpTJU54=;
        b=SauPEwsRv9x1jNh/eLEPJn47i6+AHXjIP+euUMW2k4WL6agvlZs/HjTptGiCTdgV2T
         1pGFv1ALZ0AG9AtGVpUlB1C/Ci+3IZtopyamIxsBjO8KvOdImL/6z9ZvWrwZ1Bruvbjk
         wWwZ6PJpJ+OoYI+FyE83qp+ZfTkqJWG2eq7yAit3ahJwdgFSLHuy1yw7tVxoHuMd5Z7n
         Kp2mOy0K0RdRA/U88lEheek6yCvQXOAdarh7nEAflGLSSWdH6Zid962sZEZOCCFL4DlX
         XfT1WNLnKeFHKOr8yH9I8Nj9J31hefiQ8BiAdGoVFRxKXS7G9e6ywO/2XqlxX6zOsNyw
         itRQ==
X-Forwarded-Encrypted: i=1; AJvYcCUHn+Ax1rOnORg2MM3dWEsG3n5M/HQ8AfV9WIi40JvdjQjzXaLgDksHyvCTjNC55YAvmIcpKhsJzg==@lists.linux.dev, AJvYcCUOA0U9OW4Da6tLgp+L6iEe2bLyGnYvWtQm+G+e+K1kA+a21L6oeG6AVc3Svyfc9i1S1KCtPQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+fwspE97fMlpl+UYLPLyeNh4BR+szweEoutmY6ZC2osYN9bV+
	jd4HQg2PO8wNepm1BNe9oYDXehgtVc7STHn2zWCrDT/Jj3pRlSbv
X-Gm-Gg: ASbGncvY8U/dqeqVWYcLlPJydnC+XhVc/Fh31zzYzg8zlJvTQKr9bJqnGqSNrBXzL1B
	bETkhYMj2KPAyzTOYuo2uBaVvOSAuZFUL4dGVk7q86yRh7vQi2NOd0bgWE7EmXisfD+V+MnGTIk
	tXO/rOa4G8G7njJiZJtrwcCUH1IfX8y50Ag0oOqeh/bUgcb2nhCZerRNMk91br+MbcwmSfygC2h
	ZzQjKZZTpN+kU5EWISbBP7aXdNUQ+TMe6u8JIGO/BQJQQj8aLv/T2czBPxR1GyCjvslaIgqjD+w
	gayLUZA2zHhVcIlbgd8cd0V5DxSwL7SP7Blu/0G9
X-Google-Smtp-Source: AGHT+IGZk7PlsdCZr/j/ecR8nUYCM0KRmxVw7bgRrpwVPA2oV8otwvEl5YVA/3glGzlDDrcVC80bqA==
X-Received: by 2002:a05:6a00:114a:b0:736:a540:c9ad with SMTP id d2e1a72fcca58-73fd9047c3fmr18100251b3a.20.1745850694197;
        Mon, 28 Apr 2025 07:31:34 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-73e25a6a995sm8016677b3a.112.2025.04.28.07.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Apr 2025 07:31:33 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 6E52850790E2; Mon, 28 Apr 2025 21:31:31 +0700 (WIB)
Date: Mon, 28 Apr 2025 21:31:31 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com,
	kevin.tian@intel.com, corbet@lwn.net, will@kernel.org
Cc: robin.murphy@arm.com, joro@8bytes.org, thierry.reding@gmail.com,
	vdumpa@nvidia.com, jonathanh@nvidia.com, shuah@kernel.org,
	jsnitsel@redhat.com, nathan@kernel.org, peterz@infradead.org,
	yi.l.liu@intel.com, mshavit@google.com, praan@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 15/22] Documentation: userspace-api: iommufd: Update
 vCMDQ
Message-ID: <aA-RQwyTS1m4CuPw@archie.me>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <820dfdee121292fe4cf891feb86f82ceea521e22.1745646960.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vD4TXIxpca4CWbLZ"
Content-Disposition: inline
In-Reply-To: <820dfdee121292fe4cf891feb86f82ceea521e22.1745646960.git.nicolinc@nvidia.com>


--vD4TXIxpca4CWbLZ
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 25, 2025 at 10:58:10PM -0700, Nicolin Chen wrote:
> +- IOMMUFD_OBJ_VCMDQ, representing a hardware queue as a subset of a vIOM=
MU's
> +  virtualization feature for a VM to directly execute guest-issued comma=
nds to
> +  invalidate HW cache entries holding the mappings or translations of a =
guest-
> +  owned stage-1 page table. Along with this queue object, iommufd provid=
es the
> +  user space an mmap interface for VMM to mmap a physical MMIO region fr=
om the
> +  host physical address space to a guest physical address space, to excl=
usively
> +  control the allocated vCMDQ HW. Thus, when allocating a vCMDQ, the VMM=
 must
> +  request a pair of VMA info (vm_pgoff/size) for a later mmap call. The =
length
> +  argument of an mmap call could be smaller than the given size for a pa=
ritial
> +  mmap, but the given vm_pgoff (as the addr argument of the mmap call) s=
hould
"... partial mmap, ..."
> +  never be offsetted, which also implies that the mmap will always start=
 from
> +  the beginning of the physical MMIO region.
> +
=20
Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--vD4TXIxpca4CWbLZ
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaA+RQwAKCRD2uYlJVVFO
o1eFAQCh6j1PsCslXzfPWuS46AzQ1o7ZR1WP481iUjIyZLhY3QEAixFoHFuftiEx
UNcaIuEJ2lZEhZxTyJA7ccrRXFyIfQo=
=VsW/
-----END PGP SIGNATURE-----

--vD4TXIxpca4CWbLZ--
