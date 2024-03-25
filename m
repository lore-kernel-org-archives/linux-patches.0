Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B096F6D1B9
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 21:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711400627; cv=none; b=HM7htW+HWm9b67XcqffQNum89Q/6babDNaYKae0Oyx+/UDi/9musbDCfEqRLSwL4QKeu2rPW42sQZUDZtRSMJeaqkg4Fe4tBtdww2aK9zyKe/ejerDFhse93xw1z14+fwZJE9bofwuZxLRZsApLYp2kvRC1cXJL//sgdiZIg3DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711400627; c=relaxed/simple;
	bh=c1hsXdYXAwWd4MtQ0JM3L/CsibjgS1iOIiH9/n2Y44I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N7XV7TBZUPQ/XrKRPEq83Ohhkv9e5fw/dgycAMulVqLYVFhpQtBkoj9Zvb7Eb7DfUdcGFsR3Zf62c/Epoj6ZYW+Oudfd93qhYjd55w5Vgvfkrx6X58BnhwMrmGRIXxExp4UipmsxHRmcmq+CPzZ90tUMNpG6cQvwUNJc74Ay2dY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ijN0JrvM; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ijN0JrvM"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-413f8c8192eso8005e9.0
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 14:03:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711400624; x=1712005424; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=bcD+ThylKWBeK1pFgeUXtbzb20ubBjDRON+dHDVGbm4=;
        b=ijN0JrvMCXqtF6bTgQxxC6yYTqW+qcMbPoJi6YbYFHKn76Vr+FocoL8VWBaSz8Cwfd
         Fqe2UssRpQG+Fq1/utI9VRJQvjeZa2u3ntzLyhgenNUvo01cULOJ2XK2Xj2vkdPHFLws
         e0OZ1fdutAz6msWvNmSR0gUDOYAKtDdzaEI0wmBfn2Z8J4u1Z1iZuIlvqVP0NLJ+C8Ss
         4jW3Q6SRIt84nuH27G67fjrTIvDJGWbv7BwQtgyXzIfjQl3e3BR/4l3srqrPU1ptSgEe
         GHuRXGD4PWlMrHhCpdgv1M2jSNaOfMqA5TrVZjaCnyxUZ9cy6djPdEoynmd4eBMEs4NY
         lbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711400624; x=1712005424;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bcD+ThylKWBeK1pFgeUXtbzb20ubBjDRON+dHDVGbm4=;
        b=aFqiKNRPI8zCpwtWsRelxtpIP40UYCU/GkvoEboHMAL6RS+6/nOH81u91lnK9LqGN5
         +jTXbpsGjqkun7TOUx1jmGy1pYy2GGzzZEclYcU4+T5Jn5aM4oNqf9gLu1s9eKrftI7/
         6FK4V2wZmtWvuXQJh1CEkJ5O7LEfqBQHTKfe0UoGM3vEMI2Y3Eo/jWA0mkFxKqXdpWWj
         F/tAdHitx6+Vvtz44Xlz0JomnMab2cJhyZ2tWeBvQQCvgp3e6hQb0HOsGqCVzwH3PaGL
         7qObe0Af0+55mWxgub2MoKyMadH01+4GgtBqq9oiBcTXgGZCHg69MDs9QI2SLpHkmGnw
         0bMA==
X-Forwarded-Encrypted: i=1; AJvYcCUr4Ma/e4lCgMBKWuaXhjjdMDEhIuw4lzw8c+JMiRfNZPtBOICzOz5yemkeDFtUIWIuC8UuGRhXiMGvkTRCR+/RQrkudYjwAA==
X-Gm-Message-State: AOJu0YyYH3vPsYCFCeMa8sH4E9dOtgUuwTXGCimtt0tNzgjMHGKoqCy5
	Q5DRJIwqKH/55dFaOZV9zell+fVcXOW+/6LS0tNEYvcjICT8TpGI8bPqvEAIbQ==
X-Google-Smtp-Source: AGHT+IE8bq+/EOr7ov/7oWXRJDiAkAOcph0QnpAxY5NATw2gVPzFQC4cJ1LoaRQhs8st+Vghtn0L9w==
X-Received: by 2002:a05:600c:3793:b0:414:7f46:95f with SMTP id o19-20020a05600c379300b004147f46095fmr15514wmr.5.1711400623924;
        Mon, 25 Mar 2024 14:03:43 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id u9-20020a05600c19c900b0041489d50c26sm3870053wmq.27.2024.03.25.14.03.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 14:03:43 -0700 (PDT)
Date: Mon, 25 Mar 2024 21:03:39 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v5 08/27] iommu/arm-smmu-v3: Move allocation of the
 cdtable into arm_smmu_get_cd_ptr()
Message-ID: <ZgHmq-VYUuy3T-_0@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <8-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf3W3lo8dXZuKbgm@google.com>
 <20240325142128.GC110546@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240325142128.GC110546@nvidia.com>

On Mon, Mar 25, 2024 at 11:21:28AM -0300, Jason Gunthorpe wrote:
> On Fri, Mar 22, 2024 at 07:07:10PM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Mon, Mar 04, 2024 at 07:43:56PM -0400, Jason Gunthorpe wrote:
> > > No reason to force callers to do two steps. Make arm_smmu_get_cd_ptr()
> > > able to return an entry in all cases except OOM
> >
> > I believe the current code is more clear, as it is explicit about which path
> > is expected to allocate.
> 
> I think we had this allocate vs no allocate discussion before on
> something else..
> 
> It would be good to make *full* allocate/noallocate variants of
> get_cd_ptr() and the cases that must never allocate call the no
> allocate variation. There are some issues with GFP_KERNEL/ATOMIC that
> are a bit hard to understand as well.
> 
> This is a bigger issue than just the cd_table, as even the leafs
> should not allocate.
> 
> > As there are many callers for arm_smmu_get_cd_ptr() directly and indirectly,
> > and it read-modify-writes the cdtable, it would be a pain to debug not
> > knowing which one could allocate, and this patch only abstracts one
> > allocating call, so it is not much code less.
> 
> > For example, (again I don’t know much about SVA) I think there might be a
> > race condition as follows:
> > arm_smmu_attach_dev
> > 	arm_smmu_domain_finalise() => set domain stage
> > 	[....]
> > 	arm_smmu_get_cd_ptr() => RMW master->cd_table
> > 
> > arm_smmu_sva_set_dev_pasid
> > 	__arm_smmu_sva_bind
> > 		Check stage is valid
> > 		[...]
> > 		arm_smmu_write_ctx_desc
> > 			arm_smmu_get_cd_ptr => RMW master->cd_table
> > 
> > If this path is true though, I guess the in current code, we would need some
> > barriers in arm_smmu_get_cd_ptr(), arm_smmu_get_cd_ptr()
> 
> Both of those functions are called under the group mutex held by the
> core code.
> 
> The only valid condition to change the CD table backing memory is when
> the group mutex is held. We now have iommu_group_mutex_assert() so an
> alloc/noalloc split can call that test on the alloc side which is
> motivation enough to do it, IMHO.
> 
> I will split the function and sort it all out, but I will still
> integrate the cd_table allocation into the allocating version of
> get_cd_ptr().

I prefer that, as it makes it clear which paths expect to allocate
and which not.

> Thanks,
> Jason

Thanks,
Mostafa
