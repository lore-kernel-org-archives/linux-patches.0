Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23BB91C2DDA
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 09:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725269401; cv=none; b=ljicAfbJbMbVQFGGkaoS5ht8kOWtTjC1YKush/6DXiJF14++UOVGKvF5ZhGO8XlFUv3MvZN2g0ntuRPHjE6I0DAGR7gmgW/MgtWzbgzrW52Ra9bP/kVinEAVG6sTdAMjMGXX5tJWAnhM1Z9KeC88xC9dguU6tl1kTlxfaetmIew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725269401; c=relaxed/simple;
	bh=B1qmeunmzRW7j1S/b5dM9pv6wNVyxv2E53BOHoVet/M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aJ1K84BZK8ARSVoLqxFCk3PqgVIWlrLTrhtwU9iqzvvGWChb2HmDbWxi+sX2KusmHSJiH2WAZZuayBRT3toPVzjtpiTeXcoCLmgLPRCrNgwEasY0U0GCq60zM6MG250YhsD7Uif4RP55fBmiEXZGDo9vGlPFZ+K6HYB2+oKKxbA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=y9M49Ctp; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="y9M49Ctp"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5c2460e885dso10167a12.0
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 02:29:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725269398; x=1725874198; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VJE54eIljBo+04QQocBk6CxFcwFwa7n+6hpWhqzR/Xc=;
        b=y9M49CtpgC2bHPPtjwcnBJc9wiArXISlJ21iSN0RbL3/ot7eEFpowl2Q6KhQ+Q+5c4
         Ey9dzAUuW8Ov1gnpdJWNZ6aeQ6H8bGNt0gMbJ4ZJFsuwJHH4YZXqNzNjboxY2PGmCeze
         IiRLbIoecLYhgWw8Hl24R9XiZv3pqcIFEqwwR0Drg8ns14gRp8MFSfldq0BcX3PuyzUR
         1CKGb+uzzognOIVITOP8JZAhW8W0N06qTVa6jptx/9lcHps+SJEpCzvYbfwph2AXRcz2
         rOlgxC7lD8hO92xso597AzwmTzG3Hldt6wSdj6hiNeUI0KrcVUMYfusRDg73s1kjZv+U
         PqLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725269398; x=1725874198;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VJE54eIljBo+04QQocBk6CxFcwFwa7n+6hpWhqzR/Xc=;
        b=u95QFpQxqxooZHFIXGyQuMgGnW/k6h0/3OP5GKkcjn18xcwu1Lp40CgX6hjIuYQSsm
         tm4AnZr8LqVlq3UTeJeKd2cadeqIHcL2YKFcO38BeWeLjNOfrcS2AcNQb02+42rS6dAN
         42bwSkRAluECN+sEgCI4J/wh3zOSOI1pw+O7yYFQ6wpzjy/TNg46lKaXTYD4DqAQEbjG
         Nd5as7Lt7xCO+xR/xmDSUXyGgelHZ4HyQPtkF3py14SZpk6C6p+3PUxCi4mxESlhMV19
         V3KcZ7wUY6lykCWYTxrcKawNYMsGVUqwOe9R8KZytSBl3An2A8R0gIFdaODXsdJKY57D
         DB8g==
X-Forwarded-Encrypted: i=1; AJvYcCWShyZJu6IcvfLn7yA9bzgNbCF79OU+UsIpTwvVc1e6+vNYd+qSP99kf2FC2qYAQjcKxE3GEhzK@lists.linux.dev
X-Gm-Message-State: AOJu0YzAA/h+iWAKasTMcifguQg5wjOUIf40PaCbBie8JuvDMFJKMVu2
	rrXuk40bxavNf4HnkaNnJwQParOxF3NxCxtJM3fU2vRhH8wgdq+IH3Ln266KMQ==
X-Google-Smtp-Source: AGHT+IHjBDWncMa0JFzAVRBZvunVV3/xf27Bk1UBfEqTh/oBWIS4ZrnlqS4ID0HplL23Cxhn09935A==
X-Received: by 2002:a05:6402:51c8:b0:5c2:62c8:30a with SMTP id 4fb4d7f45d1cf-5c262c80401mr55276a12.1.1725269398075;
        Mon, 02 Sep 2024 02:29:58 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989021960sm532554566b.79.2024.09.02.02.29.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Sep 2024 02:29:57 -0700 (PDT)
Date: Mon, 2 Sep 2024 09:29:53 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <ZtWFkR0eSRM4ogJL@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <2-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHhdj6RAKACBCUG@google.com>
 <20240830164019.GU3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240830164019.GU3773488@nvidia.com>

On Fri, Aug 30, 2024 at 01:40:19PM -0300, Jason Gunthorpe wrote:
> On Fri, Aug 30, 2024 at 03:12:54PM +0000, Mostafa Saleh wrote:
> > > +	/*
> > > +	 * If for some reason the HW does not support DMA coherency then using
> > > +	 * S2FWB won't work. This will also disable nesting support.
> > > +	 */
> > > +	if (FIELD_GET(IDR3_FWB, reg) &&
> > > +	    (smmu->features & ARM_SMMU_FEAT_COHERENCY))
> > > +		smmu->features |= ARM_SMMU_FEAT_S2FWB;
> > I think that’s for the SMMU coherency which in theory is not related to the
> > master which FWB overrides, so this check is not correct.
> 
> Yes, I agree, in theory.
> 
> However the driver today already links them together:
> 
> 	case IOMMU_CAP_CACHE_COHERENCY:
> 		/* Assume that a coherent TCU implies coherent TBUs */
> 		return master->smmu->features & ARM_SMMU_FEAT_COHERENCY;
> 
> So this hunk was a continuation of that design.
> 
> > What I meant in the previous thread that we should set FWB only for coherent
> > masters as (in attach s2):
> > 	if (smmu->features & ARM_SMMU_FEAT_S2FWB && dev_is_dma_coherent(master->dev)
> > 		// set S2FWB in STE
> 
> I think as I explained in that thread, it is not really correct
> either. There is no reason to block using S2FWB for non-coherent
> masters that are not used with VFIO. The page table will still place
> the correct memattr according to the IOMMU_CACHE flag, S2FWB just
> slightly changes the encoding.

It’s not just the encoding that changes, as
- Without FWB, stage-2 combine attributes
- While with FWB, it overrides them.

So a cacheable mapping in stage-2 can lead to a non-cacheable
(or with different cachableitiy attributes) transaction based on the
input. I am not sure though if there is such case in the kernel.

Also, that logic doesn't only apply to VFIO, but also for stage-2
only SMMUs that use stage-2 for kernel DMA.

> 
> For VFIO, non-coherent masters need to be blocked from VFIO entirely
> and should never get even be allowed to get here.
> 
> If anything should be changed then it would be the above
> IOMMU_CAP_CACHE_COHERENCY test, and I don't know if
> dev_is_dma_coherent() would be correct there, or if it should do some
> ACPI inspection or what.

I agree, I believe that this assumption is not accurate, I am not sure
what is the right approach here, but in concept I think we shouldn’t
enable FWB for non-coherent devices (using dev_is_dma_coherent() or
other check)

Thanks,
Mostafa
> 
> So let's drop the above hunk, it already happens implicitly because
> VFIO checks it via IOMMU_CAP_CACHE_COHERENCY and it makes more sense
> to put the assumption in one place.
> 
> Thanks,
> Jason
