Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E4DD8121A
	for <patches@lists.linux.dev>; Mon, 29 Apr 2024 15:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714404662; cv=none; b=LK8htPutESM0T6/LS/D3roPGfMMXSq7V2ybWfL0BAq1PdrTlRQN6EExJ+FSd7BcxX2eJhGw6ds9jJ6PdbszOgQ1BlltYnvuzUfxeoQyeBksa8WWHOlx++4XK8jnHWTC5ekrJaM5FvaALjT+v7W44APWG4bA8Yq2T2fvI1hKNqB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714404662; c=relaxed/simple;
	bh=z+6MabEujZ69j8rVHxyJuJld9V0OSxOFcU0+Ot52psg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gpNayn+Obz5KFcKf84q7ol1VO/vGGGsTsEOd7HoJb1jJWmDYlvzO2m6UFelSGPNzR0k9i1dABmCxN33/VslIuR8C06aaoGeo2MpXNsemOS/gPAjJWlKbQTPsLccDYseWZuHaOIJJ3t7ZXivS8ZOgwue/x1YM23Lde2ehGhJcNTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HFNJWPnb; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HFNJWPnb"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-5727ce5b804so14089a12.0
        for <patches@lists.linux.dev>; Mon, 29 Apr 2024 08:31:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714404659; x=1715009459; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=hXy2cvdiGMrvoZj7Xpu05ERqWp4+NPfu+AZvmGys6gc=;
        b=HFNJWPnbEMAFUUn6rmVZEZFTFRxw2ZI/wxfut+gWx4pUsT0X8nNztzOMELR6i2ttPH
         ghQjjcaA2kFsE1pIcVxJj4s4+/utV6WzYDZEen4PgERZmUihdD8mc9Z8iCps9QC+Udu0
         GFvT1ztI9GeY/mjlIaRY2p74rhk2iNYbVnPju4bzJOo5aJwpxqnT1Zn2IEMNytXax2hg
         n5+lFJocCL6nncjHq9b3SkgmDU0EZOobaP96vrcYdHbClu8+3GTu/erQ9HRxDV2SwVT0
         Na+qSewB0fIQjK0ILQuiJnW+e2Yrr8Oxjyl1+20bsx+auEFTHRMpFCKAAuVa9+OjzHlN
         L7/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714404659; x=1715009459;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hXy2cvdiGMrvoZj7Xpu05ERqWp4+NPfu+AZvmGys6gc=;
        b=PQdV//72KIriOMTArdbnJe0np8wVDSMEUQuRoycVSJiA45Z3pfco+oEJiLUrnB5+iK
         s10rC74iZpKrHPPvUAu6AYxAoRlVVH5Pc0NtP5v5PXgJdD0JNnHYvjHFFLLEL+DQFNEU
         pAIGaO2GPVdraU/tcZZAho+o9WJdANaGbVkvzZQiJaDHFK9oI3cj8eNFzoEk3IxREmDr
         Ejo7ooQ4xOVjJeA2q3P688Rg5ucK1mu/P67PsREUA75COX7j2Tuwx+ywwWjtAJVWbCfr
         aKJWULte1gsVFpyjEu2/q0vXqdFUNEsAYnXrUtT/gsu5tHAjsKHZZOPQGxSxqdIH6HT+
         d7TQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1749MuRG8AA6xTTLIzYkduLhMsv0sM+FLkf2JLpHxBpX0okFnfhQN5zfuKVKyjoO1Xm6n6ecUhtILLE/XSq6Ww1MgukdxEg==
X-Gm-Message-State: AOJu0Yz3kLcJCdLc01rzXv11i4Nvthpm2DnyHRpV+BRM3qKtfMshx1Tc
	BTVYMWD1j1GiWhq2oMQ/4w1o1TmTxkETNWkDfVXBSAq3TW19Gd0Vsb26GEspCw==
X-Google-Smtp-Source: AGHT+IFcekjTLTMptGZMdOu9AnHk2TPbXqdTP08qJ4DKudaF+gxMfs43RHTCLPdtiNMQP+9/eR8G3Q==
X-Received: by 2002:aa7:d854:0:b0:572:554b:ec4f with SMTP id f20-20020aa7d854000000b00572554bec4fmr271687eds.3.1714404658606;
        Mon, 29 Apr 2024 08:30:58 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id bf7-20020a0560001cc700b003439d2a5f99sm29773568wrb.55.2024.04.29.08.30.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Apr 2024 08:30:57 -0700 (PDT)
Date: Mon, 29 Apr 2024 15:30:53 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v7 2/9] iommu/arm-smmu-v3: Make CD programming use
 arm_smmu_write_entry()
Message-ID: <Zi-9LZGgT-PdhFWM@google.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <2-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLdB6nVg9S65Q1G@google.com>
 <20240422132954.GB49823@nvidia.com>
 <Zi13eaOCQFdMO1ut@google.com>
 <20240429142905.GF941030@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240429142905.GF941030@nvidia.com>

On Mon, Apr 29, 2024 at 11:29:05AM -0300, Jason Gunthorpe wrote:
> On Sat, Apr 27, 2024 at 10:08:57PM +0000, Mostafa Saleh wrote:
> > > The issue is the old logic constructs the new CD by manipulating the
> > > existing CD in various ways "in place" that ends up creating CDs that
> > > don't meet the requirements for the new programmer. For instance EPD0
> > > will be set and the TTB0 will also be left programmed.
> > > 
> > 
> > I see, but what I don’t understand is why doesn't the function construct
> > the CD correctly, as from
> 
> Why? Because it never had to before. It made minimal edits to minimize
> the code.

I understand, my point was why don’t we introduce a new logic to construct it
correctly, instead of hacking the old one, as it is much easier to reason
about (at least from my point of view)

> 
> > 	} else if (cd == &quiet_cd) { /* (4) */
> > 		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
> > 			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
> > 		val |= CTXDESC_CD_0_TCR_EPD0;
> > 		// populate the rest of the CD correctly here.
> > 	}
> 
> What you are asking for is this:
> 
>         cd_live = !!(val & CTXDESC_CD_0_V);
>  
>         if (!cd) { /* (5) */
> +               memset(cdptr, 0, sizeof(*cdptr));
>                 val = 0;
>         } else if (cd == &quiet_cd) { /* (4) */
> +               val &= ~(CTXDESC_CD_0_TCR_T0SZ | CTXDESC_CD_0_TCR_TG0 |
> +                        CTXDESC_CD_0_TCR_IRGN0 | CTXDESC_CD_0_TCR_ORGN0 |
> +                        CTXDESC_CD_0_TCR_SH0);
>                 if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
>                         val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
>                 val |= CTXDESC_CD_0_TCR_EPD0;
> +               cdptr->data[1] &= ~cpu_to_le64(CTXDESC_CD_1_TTB0_MASK);
>         } else if (cd_live) { /* (3) */
>                 val &= ~CTXDESC_CD_0_ASID;
>                 val |= FIELD_PREP(CTXDESC_CD_0_ASID, cd->asid);
> 
> I think.. I've been staring at this a while now and I *think* it
> covers all the cases and we won't hit the WARN_ON?
> 

That’s similar to how I imagined it.

> So sure, lets do it that way, the code is all deleted anyhow ..
> 

I agree, if it's deleted anyway we shouldn't put much time, I haven't
looked at the SVA patch yet.

> > As I  don’t think the right approach is to populate the CD incorrectly
> > and then clear the parts not needed for EPD0.
> 
> It is very easy to see that such a simple algorithm will not trigger
> the WARN_ON. The above is somewhat trickier.
> 
> > Also, TTB0 is ignored anyway in that case, no?
> 
> Only by HW, there is a protective WARN_ON that will trigger in the
> programmer, that is what this is trying to avoid. For bisection.

Makes sense.

Thanks,
Mostafa
> Jason
