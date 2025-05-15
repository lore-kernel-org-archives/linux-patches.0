Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987661F30A4;
	Thu, 15 May 2025 06:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747290067; cv=none; b=G6Mx2Pdng+TlYt3M13SeEkikY4+fIBEQ6qZtRCSxE8j9t9U1FyLQrkB3HddUmVMvfv5YadLzXHHoYZh4DihFvQMBC2srIyc+QmSZOD5B6ZzESTjRG5CTUe75JiJtgLQbgYo1kN/S4U3y91hm2Zh830QPTr4FnPnPXTKAVRJ6V2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747290067; c=relaxed/simple;
	bh=Y0utQwgG+0/00zaY4pvw7rTT02GtDjLu32klA2peLHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RlP9dpipO97e3JTKoazK6Z2j2WMSeHS0bZh6heXJ6JNfPE5lxW63COt2/iLb0xjeHkyN8E//2cDPSakxT+5CYP4m1Qoqi87vQU+CNG4U0W/yX+/JAzra/YPDjbmVkfeueqZ79EuI7m1K7dRbMVYN/4+/aV1fvRXwI90K1UGjfGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=j1GNEpLW; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="j1GNEpLW"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-74267c68c11so532576b3a.0;
        Wed, 14 May 2025 23:21:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747290065; x=1747894865; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=rX9E2fNDjY1FkX+1lQiyuuYgRxE42Kp5wv+1x2j0YrU=;
        b=j1GNEpLWWuVw2K1NmOGP1rKaEOGdOwOugXtmheIz97weQqmbrQIEksR421eh9zsnzY
         IL9XOhIMHFUdbEvliQNShJZ2sPEt2loYgF7kbEhXGrnH4S0WH2kSTlq2SjdfV5NqG7WQ
         7JGrRLIzyf/Fphhrzkqy00pkrC9uDotL69JVAW+bxz9dAHmn+mfkKJeuaCIdYLyA4HZW
         0GnCDRSEKI5Y4QQlSO8CF4IUu6hqQNsb+5FoIfMBX7eM29ePg6o6sKoJZGq1AyTcZsaf
         IfxQddZxIyq468rnKBhGdD089WJycNmb6dhDBIi8pQ9/KpzrgDTR6KToSjUzLDnJ+/uD
         xgbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747290065; x=1747894865;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rX9E2fNDjY1FkX+1lQiyuuYgRxE42Kp5wv+1x2j0YrU=;
        b=ujnV+by3GMGKVucWgWuUwa26kFfP6NLiLNpurQu1xhjkc8+d/AFOr6xhf+cNSSuyDd
         bbhkbMMpY49LM2ciu7ZTGcq/T70Pi1mn1zu6lWV2T+sREvO95MKgfsBh4LiBBVvuIlsd
         BqzjJKrshTQPB11WXSSwYz0ifRAI8LP4QwWJX+dvVo3HP2kkQc2Wd5GdNz1haAgrtJEM
         5HqwWdq9Hp3s7HOLl5VCc1vrc1RzCRG6/iuODlWswqmtWFTSAel/ib6nVJeQPPEBYbne
         xH43USTWBj1zSYd1Czy2rpEbJu9ou5TQxtmCS2sdde4hUhNXsVngSrOKtcmLTNX/bzaH
         hjIA==
X-Forwarded-Encrypted: i=1; AJvYcCUGdXbi8AJDVEIXD+eK+C3GFBB86xqYV6YufBybN0JE3Suo94r48AzYakx9CBeOXqPbUJ4KrQ==@lists.linux.dev, AJvYcCVHjdiOpKH9mIBbZg2qSBYy6HnmCkpP/5zyf3km8awb09mqBydQi2axCy4dgkJUCWbGWUuoccjTvw==@lists.linux.dev, AJvYcCWcMangC4XF1DDnEdBw+E9dEZrV67oq4AktD2XXzggQHDFTzt+kvJWdcyPrGOlEHZpZ/flfsw==@lists.linux.dev
X-Gm-Message-State: AOJu0YxHmyO2wvlYfm2KKDHEf+hLsWxQEmCx/h4+HstTYbByfbmqD+fS
	rzP15/Esh82z/w5BrTB3K2pICn3aZQcnqUZcI1TI1mRNr9uLVaTt
X-Gm-Gg: ASbGncsQOuA+LqxvSWyntv8Hriw1O3lkzryT1m4WC+i7n1b2TnZc/6rjTydaSIcHX7d
	2FW97E3KXk85DPZDI7IFDkpQX35i30sCrqXwHHdoc2RRUS8YFnHMY/Vh36rHW/J7u0Lx+o2mvDg
	HNzvmOvqpH1+OMbob5rFHGDNUAINX1FbnFrAtXgGkE9R9OmeWqTJ/gOuKRV5oir5jRcUxhCKEOB
	4nPtyd2eBQEKlRNIDewCvcR4y77b2YjsLEOAoKyybh2a3s3WY9lcn/HKxYsOsCi8u23v3E1KUHY
	bJhsrW8NdmtXmVBv6EC1xXombrME1GwqmVDbgpIhairyrqb9hiRxiSwWd2VtMA==
X-Google-Smtp-Source: AGHT+IGC9DxnW6VX8KRj7lnR0AoZt7AFYBd/MB5hYLPAc8e+rz+OD5MDD15P8NLcNibjdHchDrUuSg==
X-Received: by 2002:a05:6a00:1389:b0:736:8c0f:7758 with SMTP id d2e1a72fcca58-742984de2a5mr1750626b3a.10.1747290064582;
        Wed, 14 May 2025 23:21:04 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b234ab52345sm9796290a12.33.2025.05.14.23.21.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 May 2025 23:21:03 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 842B9409AAD9; Thu, 15 May 2025 13:21:00 +0700 (WIB)
Date: Thu, 15 May 2025 13:21:00 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>,
	Kevin Tian <kevin.tian@intel.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, llvm@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>, Alexey Kardashevskiy <aik@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 02/15] genpt: Add Documentation/ files
Message-ID: <aCWHzFZWzeO_9HYe@archie.me>
References: <0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com>
 <2-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com>
 <aBrHU-OGbfqk1DSq@archie.me>
 <20250513185310.GA451051@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="f31gHTPz9TUWOOq1"
Content-Disposition: inline
In-Reply-To: <20250513185310.GA451051@nvidia.com>


--f31gHTPz9TUWOOq1
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 13, 2025 at 03:53:10PM -0300, Jason Gunthorpe wrote:
> On Wed, May 07, 2025 at 09:37:07AM +0700, Bagas Sanjaya wrote:
> > On Mon, May 05, 2025 at 11:18:32AM -0300, Jason Gunthorpe wrote:
> > > +Since each compilation unit can only access one underlying format at=
 a time,
> > > +code that is intended to be generic across multiple formats has to c=
ompile
> > > +itself multiple times.
> > > +
> > > +In an implementation compilation unit the headers would normally be =
included as
> > > +follows::
> > > +
> > > +	#include <linux/generic_pt/common.h>
> > > +	#include "fmt/defs_amdv1.h"
> > > +	#include "pt_defs.h"
> > > +	#include "fmt/amdv1.h"
> > > +	#include "pt_common.h"
> > > +	#include "pt_iter.h"
> >=20
> > What do you mean by compiling generic code multiple times? Including
> > their headers at multiple places like above?
>=20
> How about like this:
>=20
> Instead the function pointers can end up at the higher level API (ie map/=
unmap,
> etc) and the per-format code can be directly inlined into the per-format
> compilation unit. For something like iommu each format will be compiled i=
nto a
> per-format iommu operations kernel module.
>=20
> For this to work the .c file for each compilation unit will include both =
the
> format headers and the generic code for the implementation. For instance =
in an
> implementation compilation unit the headers would normally be included as
> follows::
>=20
> 	#include <linux/generic_pt/common.h>
> 	#include "fmt/defs_amdv1.h"
> 	#include "pt_defs.h"
> 	#include "fmt/amdv1.h"
> 	#include "pt_common.h"
> 	#include "pt_iter.h"
> 	#include "iommut_pt.h"  /* The iommu implementation */
>=20
> iommu_pt.h includes definitions that will generate the operations functio=
ns for
> map/unmap/etc using the definitions provided by AMDv1. The resulting modu=
le
> will have exported symbols named like pt_iommu_amdv1_init().

Looks good.

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--f31gHTPz9TUWOOq1
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaCWHxQAKCRD2uYlJVVFO
o0FXAP4iCmmk84hht6kf2sEA0RKGTnBFYncYtLLZAzm6KR5/XQD+JRx9nw4yvScz
7ofsZTjk1W1XHG86xjzZZfrMX+rmDQQ=
=YGBK
-----END PGP SIGNATURE-----

--f31gHTPz9TUWOOq1--
