Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D24156251
	for <patches@lists.linux.dev>; Tue, 11 Jun 2024 23:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718149994; cv=none; b=GiPtxOcvTFetT2xflv6IC3g5yJlilQRZ0UnNQQ2aTrEelQif2ab1irl3OKflv7BunPi9T5BiFHPruMRRB9O3qHezxMTX8+hJFSu7hzumYATvwm6BIOZFzf8XBTbkMH3qDRGflIC1GjbEYIB9tu9SL0Sbk3jDOn1TgQqX3BQnNxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718149994; c=relaxed/simple;
	bh=pemv/5FNKSumJ1rxPujIu+it0aZrw4DbBltq4WoBshg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L0DfmE6ocfA/085RR9YktPGbYsV4Z1SawDrmxHszGcWh5v1zHA/jkUDSIq7XJTgH+jJmk8bF6EyEe0KTxkH29KTAZoarv6ktF2BxRO2O5zgkKal5SqD3FsakPAGaSSdZOxlzyy1OQHpv8RIV5lsT+zylvrpSLEneYLbda1zOpMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eaeEiFQi; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eaeEiFQi"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-57c8bd6b655so7242a12.0
        for <patches@lists.linux.dev>; Tue, 11 Jun 2024 16:53:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1718149991; x=1718754791; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=58zmXA/KdzT+Cx9urdttdUUCUSFh5Abqv4bxEUOPq4Y=;
        b=eaeEiFQikJCPqbxv0XdyAjMZC1d3Js8czdeu0ElkWoHxyz/N/6ZO1DDmiprwcGNiEB
         /VVxvZRPmZtddzSbXTCNz/NGkDNN3QF4nLv6CjKFTOv5yK4YV8syU9MGMchHVhv/WNzt
         p73VdDX0DJkcudQNvWkJU2NHcs0c48XSty9B7hJveMgKWR0iq0K4Cf/Afw6ndC9o51zH
         Qo/peKv7krbJS78cmgejyGaDATP4MWnDPoF4S6O7Gt04xfFZjMuAK7OP7gmyBo6wTGtK
         /arIv++SHnknBQ8DD0pL0aifQR+pWRXOaY7w7U7tRiARZWOKeaLPWFk/0RZnKp4a39w6
         ytYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718149991; x=1718754791;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=58zmXA/KdzT+Cx9urdttdUUCUSFh5Abqv4bxEUOPq4Y=;
        b=foabFxFcQ3c/4DNa7WlfDpWKIfGSk5P8feApTs+1jLRAwnrhnes9XzSsBGyVjj6jOo
         KvKzwBvPjFYXm2X6/cuGTCyUTnzGAX0xF4EoCozCt/6MQ8w7VFPTrf+jaAawpNfRrynd
         aQB156jlZ3vcM2TFtvQSrXoqQmNluJpSJ7e0vxDKScbG6RcLrG9uz16sRD0JfYfKlcJQ
         D7rH1unmNXa8JGjL48iTkQUsQ5Pcq8dU1cCD2X3OVNmr90/B8WucRAgxtF0GkLg4F1ab
         xulb+JI8QFSPp7x7jfM4KO5FwbhZGZL5gUFTExDlW67hiExurrwgUS9y7tO642fDzrEy
         4e6w==
X-Forwarded-Encrypted: i=1; AJvYcCWBqxz8KEtY/itPS/j5kUWqvacNqiRJupXzpX84TD40c5tX2AHPGeH5U3IW94gzdJ6AnutAaKQYOqvG0XtWw3gtLA1/LyBquw==
X-Gm-Message-State: AOJu0YzH7kJDn4qUhZiCd1pxMcxmbun1l1fMm06sipIvs69cpluTX2yD
	4EBpi8qtFa6fEMbIsfApuEAqQat61Lc9M3yhEnMdfZXsoQpeIqjSiTl0M6LRhDSaWu5EWvcFRF+
	iq55n0Y271klSVhvReTTT46/EQ0xfUM1cvTXX
X-Google-Smtp-Source: AGHT+IG8iqGhBXuOWXWp1HYbMjzEKwJQSI7M7nzTL7KWVKYCUP0yfo0w/O49ZrqCtC0EsaBUVauags/8KIrU4h5BWzM=
X-Received: by 2002:a05:6402:4310:b0:57c:ab3f:d203 with SMTP id
 4fb4d7f45d1cf-57cab3fd21cmr36682a12.0.1718149990562; Tue, 11 Jun 2024
 16:53:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <0-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com> <1-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
In-Reply-To: <1-v2-318ed5f6983b+198f-smmuv3_tidy_jgg@nvidia.com>
From: Daniel Mentz <danielmentz@google.com>
Date: Tue, 11 Jun 2024 16:52:57 -0700
Message-ID: <CAE2F3rBeE8gpjF-oU=g9i81bhrpeBiSNmVQ0tk+5BFk-LDMFow@mail.gmail.com>
Subject: Re: [PATCH v2 01/10] iommu/arm-smmu-v3: Do not zero the strtab twice
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
> +       cfg->l1_desc =3D devm_kcalloc(smmu->dev, cfg->num_l1_ents,
> +                                   sizeof(*cfg->l1_desc), GFP_KERNEL);
> +       if (!cfg->l1_desc) {
> +               dev_err(smmu->dev,
> +                       "failed to allocate l1 stream table (%zu bytes)\n=
",
> +                       cfg->num_l1_ents * sizeof(*cfg->l1_desc));

The error message "failed to allocate l1 stream table (%zu bytes)\n"
is identical to the one a few lines above that's printed if
dmam_alloc_coherent fails. This might make it difficult to determine
the origin of this message if someone sees it in a log file. Also,
it's not technically an SMMUv3 l1 stream table but rather some
internal data structure.

I thought there was a guideline around not printing error messages on
certain allocation failures because there'll be a generic OOM message
that'll get printed. Also, this driver never prints an error message
when devm_kcalloc or devm_kzalloc fails, only on dmam_alloc_coherent
failures.

Just nitpicking here. Looks good to me, otherwise.
