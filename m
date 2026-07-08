Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C273ED3CC
	for <patches@lists.linux.dev>; Wed,  8 Jul 2026 09:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783501261; cv=none; b=YcwSfR1JLHE/tO7layJeMfc/AxNs+APqlKN5C5PkbmhIQwxl2xccV33NHdygwfVKIPFfkZtJ6zKBbUz4qYDAwzhSm2w55T7i8Sw43oAs9x87h1CdcN3hXlvmOry4s0G8b4gbhRb9Sgcd1fEt3tZ0hT1el3RF+kK/mU++IrZP/T0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783501261; c=relaxed/simple;
	bh=mqXxmLVItLLxTPE7v7NU8HoWE7R1G2xKWlke5C9C/JM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sn345LCS6F9g/a6297OmIPTwUNWw3VZ89J00FTaeTVKBW5ByCNbGpIg9oGTD/upBnbKwDut4VMBJY2LhTbQXsZgFj3h4pTJD63qPd2qN70Q8YDzBmtAws/XGcOFOfQUdNn0KaHTXKAdy7Ra9764DpwKXj0VfU/KAlBAraH6o4qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cbdXK6l9; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cbdXK6l9"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-493b8d99342so31005e9.1
        for <patches@lists.linux.dev>; Wed, 08 Jul 2026 02:00:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783501255; x=1784106055; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QiQMvuBEKbz3IC4tovbH4hMkKdurz1w/2IHV/DGw0uw=;
        b=cbdXK6l9XaIv1GTHbtIdzjKM1qu2m+0cx64m4yVeXECP8lN4KXK6pzfRJAa+wnPh6B
         WesM5CoZaKZdxP1wZQz5Pl9V8+Rucs9CGWfTu1HxDzQ/0pA2azuQixi71tkz950LTopV
         Ka8djjzAaqftC00O3G8QeLlbEfVRFcMhOlLugK++bMsK39/RSQOF7NWY/ruoGpwoDGBw
         jiiNY8dItj5g3WBzGouUR6HbttWaSzGiasWgDER9Ro87EpLtim4lxRrRmTYsFxQnd/cZ
         PvAtdxRJA1XZgBIpmKhFE4nK6Gw2bkXpXsSg1TUnOxD52i2Ctpl/zSVrkJMzkzJxsyhA
         7bpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783501255; x=1784106055;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QiQMvuBEKbz3IC4tovbH4hMkKdurz1w/2IHV/DGw0uw=;
        b=oG63PtjWxswF6xhmgdMhi0Nq9Nbm6c6iBO4Y/IT6AiYkNOAQ+jCNahL0OtB1n0J68n
         fEj0ziJZ0bB1oYzvA7HTMEudTjZhFPHp5CV2DgrJgaJXDM1nPXvHnIgYRGVIb4IPRlJT
         YjU1GiQrz+zRIprJw82LwRU58ZBNgtvNG5ShvpHNS1IJk2sVviAsYf7TPfuxNfqE46J6
         dFyuzq/vYzIjGmHBkLkAFYKkMUEepB33OUUoGruwSZGM4ADMptFH9f7Wu3hdaFdB/QK3
         g2wg2q3AeKTbjdg6OALyPxo9Awme9z7HJL34z/NpmrMfTO79Ro5RAi/jqxd1CDUBkwZS
         fXbw==
X-Forwarded-Encrypted: i=1; AHgh+RrgtF3qcCpi7HiW4lEbZ21UCOROtALS6kzEgSfsrMMTaW5DK+MzUtnBB8cwhrLXueRdn0l/vhx8@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+2iRjt4/gr/JvmcyVJFrtNphRJrkU31ijwKpRCoFnPcHYKk6B
	+cibOhIIbWKvqFZuhPE7/ObQ7eck8rvQOI4glxO/x25LpAGphjn4/3jD1qNkq4kZqg==
X-Gm-Gg: AfdE7cmVWP4R0ymB0Yr/MwKZzVGU6+F7bIM3Duwo04GtO/q8rhIDr/QtdHbFjz/sLaO
	xml6+duOHb81pGb94VOjBE9PogsA6jcFiANTQ5AIE71nbSSEW+cMj6RWlNCNiY5mm5b3oPS1TpN
	tCO2pGxWhi4m6+OwNAtPOA7xsZPRg70bzGI9uDbbAo6CcVSpGNJPzdW3Bbj3algnAZ6qG2/FNIl
	tQzGdxqmFixPdr5QKlLdsugsBQ5Q7Lr060AFLDo53R7h5Ep/1GgAyTlxxCH4om5qF8Fq5XB0ujn
	1U3WK1t2Ir1vgdWVgZJSugks8XJhaOn4xUwLkT18ox2XxSU/3ibNx29752oAO03r6IA8bjSwQ/F
	ouQqqJbmLPfArM7RVnH7prmn4/P5HRNzGRuxrZswt5sXpUYYS3Fo9a333PgL4zUcaDwSP+GANfY
	KYoyfdjF10HZsWITjcpzhTccKA3wzOdH4zPMjxCQTZ6GBlzzyK
X-Received: by 2002:a05:600c:591a:b0:493:caa7:4fd2 with SMTP id 5b1f17b1804b1-493e121b946mr1933975e9.6.1783501254766;
        Wed, 08 Jul 2026 02:00:54 -0700 (PDT)
Received: from google.com (220.60.76.34.bc.googleusercontent.com. [34.76.60.220])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493e0f41014sm120832345e9.6.2026.07.08.02.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2026 02:00:53 -0700 (PDT)
Date: Wed, 8 Jul 2026 09:00:50 +0000
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
Message-ID: <ak4Rwnr39HuP053s@google.com>
References: <0-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <5-v2-43074a57a53a+fb95-smmu_tlbi_jgg@nvidia.com>
 <akzoeexW-4W70QdU@google.com>
 <20260707145812.GK220801@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260707145812.GK220801@nvidia.com>

On Tue, Jul 07, 2026 at 11:58:12AM -0300, Jason Gunthorpe wrote:
> On Tue, Jul 07, 2026 at 11:52:25AM +0000, Mostafa Saleh wrote:
> > On Mon, Jul 06, 2026 at 01:26:42PM -0300, Jason Gunthorpe wrote:
> > > Store the required cmd data in the tlbi and just copy it out when
> > > processing each item in the invs list. The cmd form only depends on
> > > if the instance supports RIL or not, otherwise it is always the same.
> > > 
> > > This avoids redundant calculations for each invs entry.
> > 
> > I do not understand how does this avoids redundant calculation?
> > This would be the case if the domain shares multiple SMMUs,
> > otherwise, a range TLB invalidation should be unique and can not be
> > reused.
> 
> Right, if there are multiple SMMUs for the domain then currently it
> recomputes the range for every one.
> 
> At the moment I think we can't have multiple SMMUs per domain but
> Nioclin has a patch series changing that

Yes, it is not possible at the moment, I think it makes sense to have
it in this series, but a comment would be helpful as it is not clear
from just reading the code.

However, as I mentioned I am not sure if that actually helps on a real
system, is that something that you noticed during perf or based on the
code?

Thanks,
Mostafa

> 
> Jason
