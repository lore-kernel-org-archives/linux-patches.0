Received: from mail-ed1-f41.google.com (mail-ed1-f41.google.com [209.85.208.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD14CEA4
	for <patches@lists.linux.dev>; Wed, 12 Jun 2024 00:31:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718152270; cv=none; b=PT3cKUbj91UonWa+B6BWNAiNPNAvYFrtXOEK4t4DE0Qjpz+iPPqfYtzottc07vZYgAw6oibFHsUkjY8AHzaRHOLdxpd/hBwQRR/9tuUifGDpKJV3dhHCaMTrXBuJxXLjN6mnIJbW6Mw2hO1sU3oUdZpZersC6Q5fN2OmJSqjXp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718152270; c=relaxed/simple;
	bh=eDEh/Oen7DAJWK7uRkISNRf9YcAHO+uOwB2Trnusrys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fw4IRMyV5pHsBHPIBEOsoQ/onCYXR62MO8lQoD74AEjWnHSztQxr7r7ucuKFOmW5lhW+AR9kSbgqGWH0tZXL6oy8CDdarK6/ojetDXdbZ/yfemJZiFqFQEX0I+zuKTq73FYnDX4wpS3U+vC0f3qyoqc/iOJOH5aKO8vzqn3nXe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NsPxSc4W; arc=none smtp.client-ip=209.85.208.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NsPxSc4W"
Received: by mail-ed1-f41.google.com with SMTP id 4fb4d7f45d1cf-57a16f4b8bfso7937a12.0
        for <patches@lists.linux.dev>; Tue, 11 Jun 2024 17:31:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718152267; x=1718757067; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oP9KKIbLoya/+52h4fep3MAtzpYBaRZzspTiBl2594Y=;
        b=NsPxSc4WMR9YNLBT7yq0TKVwHRp6GRafeQkZJZtrzp4fcYrMlg3rJ/Y8gE1kln1Zu2
         3/sijW8H1T0IPyrpCfqgVg1i5XrR7el9w/LtjKU/P1rBSLWCKns60pywch9bea9y54Jf
         h747rDQjymhUEda8F3vM8RSYxxv803POaAHIeyCIbXL90QTGCsRrW6KZ9JFSICFmTSF7
         WAq1UCQ6IaSuwfPO9Zq6wTFInEpm+9tiZ1QShi1o+n4GvlUELZTJnBPoh0wf3zHhlOzs
         6dqGYw2G9uRl4mwyvhJaiT04BjydllbHSTMiBTK6V6DUmeMMziWlfDilO2vEay8+xdY2
         xEEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718152267; x=1718757067;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oP9KKIbLoya/+52h4fep3MAtzpYBaRZzspTiBl2594Y=;
        b=aCGyXATwF7fFVvlbPvSarctv6WKhal/8seHvE2Cl5eNYSqPKU8j2JPMAln0grkuDOf
         3hbRQFqQ7QQYy+0mmCzj4Z0iUyNz5tpsMP82XtZp/xI/sXMQwx+X35/2YKuYNbmgcoiy
         KederIWYFQzUwObFM8ZvtEsZ4TH3Wh2z1enkUfr1G/B6vjNd7rGJmd2BeLA4XhZX8y+p
         Dg3XsGe7RZQOBAfeDs8uICLOYbwj56Nq9w7lk1xZF2xbJohSHIlJzjEmsF3xH3/p/k9I
         yXXilT8g/pM4TPaL+7DShv6flkgtwDMnMX5tKYQl8ijOyMEWS6oLLxRJ2sO2fZ0/U3Ub
         B1pg==
X-Forwarded-Encrypted: i=1; AJvYcCVcKDSFW7kFU09TqYNzt4aNxFh92JKNp/RI3pONz9KOwC+lMD7AsMzH5S+TFP2GnhOUmKkIfKWlFpC0RuxBwRd7FT8VAGCbMA==
X-Gm-Message-State: AOJu0Yy9gVjfj0qBJwR6BBfIZzlHeVBcYTY6bWdmu2zqn+j/X5fDkqq8
	W2f+/xyUZCi0rxhmbUqb9e4FQKH0mpOaxRSpe4Dn4rsYv8mwreWJJ0UURCOCLWBDYgAuSUrNQ27
	UHdR+6MRJO7ypTm6goUtBGf51E7r5gwpn3ItG
X-Google-Smtp-Source: AGHT+IFhK3nW1s3vFpcSBj0EEbCcEV49HXRnLV+cBns1nx9+LAzI5Pcqddd/N6HdlI63NBcazatyNT9RnekZ/uQQocc=
X-Received: by 2002:a05:6402:1d17:b0:57c:57b3:6bb3 with SMTP id
 4fb4d7f45d1cf-57ca84b8036mr93464a12.6.1718152266688; Tue, 11 Jun 2024
 17:31:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com> <3-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <3-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
From: Daniel Mentz <danielmentz@google.com>
Date: Tue, 11 Jun 2024 17:30:53 -0700
Message-ID: <CAE2F3rBJxj=zFmtdGddMdPy9HXVP-cu+MtjaJhrJpjux_GZ6KQ@mail.gmail.com>
Subject: Re: [PATCH v2 03/10] iommu/arm-smmu-v3: Add arm_smmu_strtab_l1/2_idx()
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>, 
	linux-arm-kernel@lists.infradead.org, Robin Murphy <robin.murphy@arm.com>, 
	Will Deacon <will@kernel.org>, Michael Shavit <mshavit@google.com>, Nicolin Chen <nicolinc@nvidia.com>, 
	patches@lists.linux.dev, Ryan Roberts <ryan.roberts@arm.com>, 
	Mostafa Saleh <smostafa@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 10, 2024 at 5:31=E2=80=AFPM Jason Gunthorpe <jgg@nvidia.com> wr=
ote:
>                 dev_warn(smmu->dev,
> -                        "2-level strtab only covers %u/%u bits of SID\n"=
,
> -                        size, smmu->sid_bits);
> +                        "2-level strtab only covers %u/%u of SIDs\n",
> +                        cfg->num_l1_ents * STRTAB_NUM_L2_STES,
> +                        1 << smmu->sid_bits);

Does this mean it'll change from printing

"2-level strtab only covers 25/32 bits of SID"

to

"2-level strtab only covers 33554432/4294967296 of SIDs"?

I think that's less helpful. I would prefer printing the values in bits.

> +#define STRTAB_NUM_L2_STES (1 << STRTAB_SPLIT)
> +#define STRTAB_MAX_L1_ENTRIES (1 << 17)

Consider adding some extra white space to nicely align these #defines
with the rest of this .h file.
