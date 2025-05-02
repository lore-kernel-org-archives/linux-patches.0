Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 325731E260D;
	Fri,  2 May 2025 07:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746171080; cv=none; b=eB5mRRU5XKStozOmcI0hW4/bbeTdtS0Zx5DAKwv4DzdZlULZf+faVNSg/zkhvdpKYBSxhB4z7HYz0njSqoVhtrabGk0T+Sr1hx8TlW+dd1Al/9NmqTo9t1GJhkuGhaGbEyuOk6U0UBd92AyxTyLvS3Wn9FJXxxMbjQU6rWx1iGU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746171080; c=relaxed/simple;
	bh=wtoQr0xWC7SiqYlR1iiTaHqZi3kSYO3Wq5NsfIXggRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nOuM6VMPkNvpBSzAV39jI1DiKGYPETAguNVEZ+dCNtrTClNZgtsKxAdt3CwM09yMItkk9gnfNYlVzXBbZlRB4NrCzBHulXVh+MFpqsaFCinzaIr/TjLVQu+Gtety7bc4CrbO+yK1WNHNcs1fRU57UUxMGGUapEWXjHoCB6tQ3x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ImJMIqFx; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ImJMIqFx"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-22435603572so20241515ad.1;
        Fri, 02 May 2025 00:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746171077; x=1746775877; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WhyG+qPql1C6VOEStks/G335oAHhX6Klfc0SAJXR260=;
        b=ImJMIqFxB6XXyj5SvhtkRy4WdTknlHmhnRNcLNLKaatE97G6SlROr/9ThSoRw8y3me
         vODALKytw7Xts6pIyzW9sLdUPECkPtVQi214OXbHbKgNjkld7fvuUtgqdIwDvFR1lHlJ
         fxcVSCXbqB8XmzJtRZ7XgEFbBnxNx7W8UuJkh0vjvIvsmgzpuAJTUeuC/QsQpLnqUIn0
         0UXRwxCYcqHIX/li4UUurw9OhHn24QePEAfxRA66Gi6sUfOGRB6h6WfRyaQX0nkqV5dV
         LVAD06JJrfazc/A31lEfB8dtYDMj8Ft1aXPt4NFciQROu1KUIDaE9i4UOLntAcjP1ZWh
         tqzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746171077; x=1746775877;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WhyG+qPql1C6VOEStks/G335oAHhX6Klfc0SAJXR260=;
        b=vI01HFVy9ONyhuwCICbA3h83G6W04StrZMc42ynU3KjBaC8nr4PGCxGUm/IR5QN2Vl
         mukGUVPENNGepajIDeX1Xv5kywzAelwt5HkrCYlYSJ2kSgYa0va346Sb7pEJCoF4bGiD
         jQoPn9OvhdJ9sfaXLSBIk8JnF9PKR6TrdnFN/uGV0Gditq5ox3+sADmYG2FYlwpEqkr4
         qH5GDVa4D0r9N9R3rWvmPJfKcMydMl+i5SE2QjRIpGRNo9Uc2hy/wB9AebuNnDOtDgm9
         iGznVL4dmg6H/r/s5ZTIPGH+s+3ClVbDZzZl8SDWnOeFWjP9xH1Y4j1LBea37Y0yDHCU
         Tdlg==
X-Forwarded-Encrypted: i=1; AJvYcCUn2mE3jo+ysPn/Jpz5YyuX910BRPKAa/PGZCqFtfIAQW7BDbLYl4dQ79NQMy11vzgt785q95mZlw==@lists.linux.dev, AJvYcCWa2jR8tvQ5pqbaFUrnNF8TfFE9oGDEI/mhlBkIv8AEpEAO35gJymVAynxgHBkwffTv8oV3SQ==@lists.linux.dev
X-Gm-Message-State: AOJu0Yyvnj8Quu8pGHBsSpxMl1EsT22+5DkE7Z5mbwEWzon2vRWGplXr
	ZEUPjBREjBTNcwJr5zuhBIDgX6moO2QzhvPVs08hE16fDD9CLZqK
X-Gm-Gg: ASbGncto6iT+ejQ4vF1n/AfT5JmBeJXLPtIAJE7NrnRmfkHMJTB9XnYIiUw0TV61bgv
	auz80ftliIoKoFHQUdmm64zSvZ4zMkxmSnXGKmrAcrl3L6GoiS+RCOh+gGR4uRdPJLkzQOtyJ7C
	PP7ykMvsqz/p2BjhLiBXjFWbFaALkkdWXP5tchOgiXagWZ5mGvqlnSu943NBax5hsWfh3QHBu8q
	jd6LUpD+Wpux5u7gwBDwIMEDaIjf6QAXdGWiw11RSvnmsPPeZV6njWVwbAjAMwFVXD7tgjnZPup
	LlHni58xAw7vKTJDPnhucmLEdqIGJcgRAbESE3nG
X-Google-Smtp-Source: AGHT+IH52a6BgPoPUu5N1D3Rb40EG6pjnTkV9nhRgxYGSZyv07U3fjSm8A6SXkBygATuXX2l4VA+sQ==
X-Received: by 2002:a17:903:2f91:b0:224:191d:8a87 with SMTP id d9443c01a7336-22e1034418bmr27532815ad.26.1746171077036;
        Fri, 02 May 2025 00:31:17 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-22e1522f7c8sm937775ad.228.2025.05.02.00.31.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 May 2025 00:31:15 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id B8C52420A6AB; Fri, 02 May 2025 14:31:13 +0700 (WIB)
Date: Fri, 2 May 2025 14:31:13 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	robin.murphy@arm.com, joro@8bytes.org, thierry.reding@gmail.com,
	vdumpa@nvidia.com, jonathanh@nvidia.com, shuah@kernel.org,
	jsnitsel@redhat.com, nathan@kernel.org, peterz@infradead.org,
	yi.l.liu@intel.com, mshavit@google.com, praan@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v3 16/23] Documentation: userspace-api: iommufd: Update
 vQUEUE
Message-ID: <aBR0wWzQablOklyW@archie.me>
References: <cover.1746139811.git.nicolinc@nvidia.com>
 <0beddeaaa4a8a7a45ce93ff21c543ae58be64908.1746139811.git.nicolinc@nvidia.com>
 <aBRA75V9l9WlI2Q3@archie.me>
 <aBRYVkOKfFGMb5Y+@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vde97DQHR/3Yogi4"
Content-Disposition: inline
In-Reply-To: <aBRYVkOKfFGMb5Y+@Asurada-Nvidia>


--vde97DQHR/3Yogi4
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2025 at 10:29:58PM -0700, Nicolin Chen wrote:
> On Fri, May 02, 2025 at 10:50:07AM +0700, Bagas Sanjaya wrote:
> > On Thu, May 01, 2025 at 04:01:22PM -0700, Nicolin Chen wrote:
> > > +- IOMMUFD_OBJ_VQUEUE, representing a hardware accelerated virtual qu=
eue, as a
> > > +  subset of IOMMU's virtualization features, for the IOMMU HW to dir=
ectly read
> > > +  or write the virtual queue memory owned by a guest OS. This HW-acc=
eleration
> > > +  allows VM to work with the IOMMU HW directly without a VM Exit, i.=
e. reducing
> > > +  overhead from the hypercalls. Along with this vQUEUE object, iommu=
fd provides
> > > +  user space an mmap interface for VMM to mmap a physical MMIO regio=
n from the
> > > +  host physical address space to the guest physical address space, a=
llowing the
> > > +  guest OS to control the allocated vQUEUE HW. Thus, when allocating=
 a vQUEUE,
> > > +  the VMM must request a pair of VMA info (vm_pgoff/size) for an mma=
p syscall.
> > > +  The length argument of an mmap syscall can be smaller than the giv=
en size for
> > > +  a partial mmap, but the addr argument of the mmap syscall should n=
ever offset
> > > +  from the returned vm_pgoff, which implies that an mmap will always=
 start from
> >=20
> > Did you mean never be offset from returned vm_pgoff?
>=20
> Yes. Will fix this.
>=20
> > > +  the beginning of the physical MMIO region.
> > > +
> >=20
> > Confused...
>=20
> Meaning that VMM should just use the given vm_pgoff as is, without
> adding any offset to the vm_pgoff.

Understood, thanks!
=20
--=20
An old man doll... just what I always wanted! - Clara

--vde97DQHR/3Yogi4
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaBR0wQAKCRD2uYlJVVFO
o2GmAQD6yTz+9Kdn/nHALYBCiSbtX+ewWJjZ0spXlFlQyWBmSgEA9HdlnssGmaCv
oibhf/yiDjC4MkNfQVDV7Jw5qTjhagQ=
=zmrU
-----END PGP SIGNATURE-----

--vde97DQHR/3Yogi4--
