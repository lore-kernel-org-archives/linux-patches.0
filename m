Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F9B636492C
	for <patches@lists.linux.dev>; Tue,  7 Jul 2026 11:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783425156; cv=none; b=f5GXM3r6Sp2w9zBL+E8hc1rmbu1s9lPqpOsrJDFxkVAFX9Ieu0zQTarOe2FWzG9m5tzn1qBG/vODo00neaeF1PHaNqmi2GLXNKmAr+0boPn3Jji2Vs0tXCbvV7HN4bSFm9tt6qCUPy2ClKoTd8cpRHA8cRpE6a3AHe+xiLwilKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783425156; c=relaxed/simple;
	bh=8zbnjzeZV7T4GeRDKSJpJT7HdFcjcjnriEr+9hvhyIY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Dh9oP6Q+u8xc4s+KFXGth8M+Bg8ZUuOjSurg+5z24H0xoqX8viMww6TeEz9HeFaW9lHIBS9BWvUPE3/LureLljKO4HiZFc7OaEig7mBXGp07ygLPjcv7S2cxoNqp/dWQ/5TsZ6VL/oSW+fBrgshbN09nS6U6h9Fa1sRdzUYZtz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Bhv7viPq; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Bhv7viPq"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-493b8d99342so26095e9.1
        for <patches@lists.linux.dev>; Tue, 07 Jul 2026 04:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783425152; x=1784029952; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cH1o0f7+Xgp89WLi95K+Rx7Uq4DeC7XdXtfbyGqV9hg=;
        b=Bhv7viPqnvOd1D3Ds+kktOSf2VIswrFpUgGDVqG6uEfh/akxFfbK/AD505j20vacJu
         e9gWKOr9xSQQ/svkYp5RErj3rN5RaL2zns7MUBBNsSVA5/15Pi4qUf0wdo9pP+T4/z64
         QQiqDPbECgPNh9eStzBYQuwE6oGYNxkLwhUvBDPFTcttJc70gxk+AEZTpRK66wfvfJOb
         qRLE5oSy87ji5omoTrdaD9Qtsf0oJj7olj5N+SUQ9nlI7IWaABfv4UV1DinTEX0FomFt
         dARUP/0u6eAnYVYrMJZKDPU8H1VqWk4R2Xif4FKDqx7MRlCKgubaKxxDyjScbZ1v0mcy
         ZjOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783425152; x=1784029952;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cH1o0f7+Xgp89WLi95K+Rx7Uq4DeC7XdXtfbyGqV9hg=;
        b=fz31BDYW0l6rtRaQNAD+t0qmI9dTVMV1RFPBZJjh59i4S3O5c+hBA30I+MEEciqIS/
         ke4u39nIooJX0gcHLYSoGPO6zpMHun3N8mjJTgdsVWoQw8PlSKBjnugHmcZJhTcnMb7T
         3z0lmmKvxVZ75fi0GZadl2ZhrtXaXuWAfJHnyWGKNtk59Pe31gtNwNjtlnpbysDNG8fI
         WecTwWVO1Lcb4emZ3X/9RAQQ7PMsh1DCKQ2a0sodUj7qXzeXprbbK3vO6yirk0eujUTo
         JaIYVsVW4egCsS4XSlZpw/wSAFHUz7Dpqoz7N9x8Zy7yj6KWOux0LPBiPLbiA+gu8vkM
         IxyQ==
X-Forwarded-Encrypted: i=1; AHgh+RoO4ck9V6lOtoAmGO8nrkX0pLn4PaDycbI5tBlWZdwxMwX3AhuzNZzVMJpiSbyZziUB7Vg334Kc@lists.linux.dev
X-Gm-Message-State: AOJu0YwH27vmZtQjGiGGNeRuflo9/N6EgE33wHa7LdJXLd0V6S9zxH2Z
	Fhjnufjr7IG9udUEnPCdRD+4lg8wfZ+iufM1sKWEtLedKSx1CriB6JwG4I2y+++jAg==
X-Gm-Gg: AfdE7ckLhv5Tp4zvDEvyb2hExsrcPzvFx+U/hqJiqldIBLl5Oy3l2VB5dZS4Mi3JOo4
	GGTdbvP+l3W98noZs/etX03DogXF52Qo24mykGjWbtk63iRsmE5+VxWS30miF18A/6RhMJ4Gjsy
	T4BxUP4evPCHTVqYUf4L2DEgCj57llyzcq6lkhKs/C99XCMi5Y6Znrvd/l0hXCY80c6hP8DKrxr
	qtfVJ5THnCXK052l39M6ou1HKSuPW0b1jzG18umkNYk5KI5rgqir0wLsYPYZQlUR786SUZiICQK
	APmKvQtqcvhIIzFI7A/yydBQZOLOfspKoNXKBeRI1zfn38mUJOsjcEy6KdodwgE9YUqsdrV6ECA
	YQiONXbT4zUvld/FTxbECISDU5AT/BDE3+W49akvr80tAFCgjyzL0xoB8D+4Z8Rl1O3IEBvzaUq
	HnNnnrG+a3p0dRVQaA/pj0qcjnWtR0Nm6olmMFClZDjdVU2X+6
X-Received: by 2002:a05:600c:1c0d:b0:492:203f:a378 with SMTP id 5b1f17b1804b1-493e121b8cdmr1175185e9.8.1783425151514;
        Tue, 07 Jul 2026 04:52:31 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0f40912sm47378305e9.4.2026.07.07.04.52.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2026 04:52:30 -0700 (PDT)
Date: Tue, 7 Jul 2026 11:52:25 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Pranjal Shrivastava <praan@google.com>,
	Samiullah Khawaja <skhawaja@google.com>
Subject: Re: [PATCH v2 5/8] iommu/arm-smmu-v3: Precompute the invalidation
 commands
Message-ID: <akzoeexW-4W70QdU@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>

On Mon, Jul 06, 2026 at 01:26:42PM -0300, Jason Gunthorpe wrote:
> Store the required cmd data in the tlbi and just copy it out when
> processing each item in the invs list. The cmd form only depends on
> if the instance supports RIL or not, otherwise it is always the same.
> 
> This avoids redundant calculations for each invs entry.

I do not understand how does this avoids redundant calculation?
This would be the case if the domain shares multiple SMMUs,
otherwise, a range TLB invalidation should be unique and can not be
reused.
And in that case I am not sure that would be noticeable with modern
CPUs/compilers.

Thanks,
Mostafa

> 
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c | 132 +++++++++++---------
>  drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h |  11 ++
>  2 files changed, 81 insertions(+), 62 deletions(-)
> 
> 2.43.0
> 
