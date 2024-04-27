Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8C4E1465A5
	for <patches@lists.linux.dev>; Sat, 27 Apr 2024 22:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714255745; cv=none; b=V8oAkgwRzFEgPAZBupnVT/4YKVVXW/XvYlVVbjdJfQYBKSm0qZvLb6IwctZZoT85PPit1dJREACsjGjN4xt6GP44HFlELel5dhhBPjui6t3SBz6PA0uLE2D2b+4rIv6iIP0aVs2tMh38fymLLWpzRTSxf/K4qLMgnAOHjMDTVoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714255745; c=relaxed/simple;
	bh=42fsxH7GUR3Bze1RaNrOUs/Q0k9/UGiGaNo83orjt+4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ei70wLBJz8bySDY6J3mkEdBb1ZrVWO6gBh3y5hUaapjVHa3AuGRXK+Wq+jY3+7Ri1d/5lGQx9otGWweJkt0KcaHQePSMaPF0XGe5ssYaPDw6/o54et7jhj1nKLRKtzACoEhUjTzK2y0jLVI8Vi+WPP9KY4YMfXvW1g5K85FpeWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dAmPvS6I; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dAmPvS6I"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-41bff91ecdcso6345e9.1
        for <patches@lists.linux.dev>; Sat, 27 Apr 2024 15:09:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714255742; x=1714860542; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=IjiDbuXHarP9n+vhk+qWFDAAqkupGkyD4XgrRp0FO9A=;
        b=dAmPvS6IU5WVCbSMB6IFJ88Epmj9QIpoGJCN7YMM07/kxTAXTKZvb50QjZLXC6CGWw
         1QgIFUtUvW9Y81Hpjd5EtKvbIRZzNzqCg/mTSBHwUdn4mYGjaHsYzsPEooqNIUv4fj+k
         VOQLgLf7C3P/tF/vxOuk9ZKQAOSPF/NNFxANJ2Aey/FaZCSzB+bLK+aDfojWhzAIbWx6
         HwekRF+HVFbaCT3rTQa7uWn0I6TPEUlcL652YAip/o0xp7N7PSgUeXa9JMkyIjm+/GSQ
         oAiZVU1s0LP+Z0DlQk3fSg1lJTp34eW0KfDo3z97d0OkqWjtn0AH4Vj63tN8hkVFsUwB
         EUMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714255742; x=1714860542;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjiDbuXHarP9n+vhk+qWFDAAqkupGkyD4XgrRp0FO9A=;
        b=D25xvnYnNgFN6VRMdyoNQwDV3fdxZdVrD9h2Wqet7xApDLQozGrer81BoYOxmj44d+
         zm+i8tZvYWiQhpT5qCda34GEjdqVfF/W8kylJ89armmBv6VgAQw9a0pKnWnoUeYVwRWf
         rfIu5z1t5eYG9LHFGn8ccQ/Srvh9GyQwZ8BoUd26K2s5rbIrvoN4+jPJLw8Hy8DPq2E6
         VggTygz2/iPISSzdJeaF/HcudJG998o1RGg9F8Tq6EkjmMhzTwYXGAFWpHB7e0ZUQygF
         abGGTOAE7DIQ2hOHmNthlOVf5TWfnwCkAy5S+/Y4DKaFLv6V0ouaOtWE39V4hY4NPATh
         us4g==
X-Forwarded-Encrypted: i=1; AJvYcCU/Uu2FNZftzWdtN5y/fK07BMOCSDaGq9xccRMzfv2dFLTJZFAi3rLQp+lBivNGk4kWYkjSpK3ZYk4U7mALp2q1gjuz5ghw1g==
X-Gm-Message-State: AOJu0YxlNlAXEIChM1zR8OkaD9rcwbgRY4MHxeBiakGulnp5raErpipc
	4cvaVxdS50dPVLpDTLhuANWbOqUrrTLGphr1FZSLIh9X1s6bG7KXmZet5jrKLw==
X-Google-Smtp-Source: AGHT+IGdLxrQL/1wmNg8qE5Pi+BZEbw1bE3ruIZ5/MRd6vKqHT1Bi72nrkBHFenVKJBReBB9CLJgYA==
X-Received: by 2002:a05:600c:3b22:b0:41b:4c6a:de7a with SMTP id m34-20020a05600c3b2200b0041b4c6ade7amr143020wms.3.1714255742226;
        Sat, 27 Apr 2024 15:09:02 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id d24-20020adfa418000000b0034ca8cdc594sm2257873wra.76.2024.04.27.15.09.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Apr 2024 15:09:01 -0700 (PDT)
Date: Sat, 27 Apr 2024 22:08:57 +0000
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
Message-ID: <Zi13eaOCQFdMO1ut@google.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <2-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLdB6nVg9S65Q1G@google.com>
 <20240422132954.GB49823@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240422132954.GB49823@nvidia.com>

On Mon, Apr 22, 2024 at 10:29:54AM -0300, Jason Gunthorpe wrote:
> On Fri, Apr 19, 2024 at 09:07:19PM +0000, Mostafa Saleh wrote:
> > > -	cdptr = arm_smmu_get_cd_ptr(master, ssid);
> > > -	if (!cdptr)
> > > +	cd_table_entry = arm_smmu_get_cd_ptr(master, ssid);
> > > +	if (!cd_table_entry)
> > >  		return -ENOMEM;
> > >  
> > > +	target = *cd_table_entry;
> > 
> > As this changes the logic where all CD manipulation is not on the actual
> > CD, I believe a comment would be helpful here.
> 
> This is all deleted in a few patches, doesn't seem worth it to
> me. These steps exist only for bisection.
> 
> > > @@ -1299,18 +1357,14 @@ int arm_smmu_write_ctx_desc(struct arm_smmu_master *master, int ssid,
> > >  		if (cd_table->stall_enabled)
> > >  			val |= CTXDESC_CD_0_S;
> > >  	}
> > > -
> > > +	cdptr->data[0] = cpu_to_le64(val);
> > >  	/*
> > > -	 * The SMMU accesses 64-bit values atomically. See IHI0070Ca 3.21.3
> > > -	 * "Configuration structures and configuration invalidation completion"
> > > -	 *
> > > -	 *   The size of single-copy atomic reads made by the SMMU is
> > > -	 *   IMPLEMENTATION DEFINED but must be at least 64 bits. Any single
> > > -	 *   field within an aligned 64-bit span of a structure can be altered
> > > -	 *   without first making the structure invalid.
> > > +	 * Since the above is updating the CD entry based on the current value
> > > +	 * without zeroing unused bits it needs fixing before being passed to
> > > +	 * the programming logic.
> > >  	 */
> > > -	WRITE_ONCE(cdptr->data[0], cpu_to_le64(val));
> > > -	arm_smmu_sync_cd(master, ssid, true);
> > > +	arm_smmu_clean_cd_entry(&target);
> > 
> > I am not sure I understand the logic here, is that only needed for entry[0]
> > As I see the other entries are set and not reused.
> 
> I'm not sure what you are asking?
> 
> The issue is the old logic constructs the new CD by manipulating the
> existing CD in various ways "in place" that ends up creating CDs that
> don't meet the requirements for the new programmer. For instance EPD0
> will be set and the TTB0 will also be left programmed.
> 

I see, but what I don’t understand is why doesn't the function construct
the CD correctly, as from
	} else if (cd == &quiet_cd) { /* (4) */
		if (!(smmu->features & ARM_SMMU_FEAT_STALL_FORCE))
			val &= ~(CTXDESC_CD_0_S | CTXDESC_CD_0_R);
		val |= CTXDESC_CD_0_TCR_EPD0;
		// populate the rest of the CD correctly here.
	}

As I  don’t think the right approach is to populate the CD incorrectly
and then clear the parts not needed for EPD0.
Also, TTB0 is ignored anyway in that case, no?

Thanks,
Mostafa

> > If so, I think it’d be better to make that clear, also as used_bits
> > are always 0xff for all cases, I believe the EPD0 logic should be
> > integrated in populating the CD so it is correct by construction, as
> > this looks like a hack to me.
> 
> Yes, this is what happens, in a few more steps. We have to go and
> build the missing make functions first.
> 
> There is a bit of a circular problem here: the new scheme expects that
> the CD is only programmed by the new scheme and follows the rules - eg
> no unused bits set. While the old scheme doesn't follow the rules.
> 
> So this patch makes the old scheme follow the rules and be compatible
> with the new scheme then we go place by place and convert to the new
> scheme. Then we remove the old scheme entirely. Look at the "Move the
> CD generation for SVA into a function" patch.
> 
> Yes, this is a minimal hack to let the next few patches work out
> correctly without breaking bisection.
> 
> How about a new commit message:
> 
> iommu/arm-smmu-v3: Make CD programming use arm_smmu_write_entry()
> 
> CD table entries and STE's have the same essential programming sequence,
> just with different types. Use the new ops indirection to link CD
> programming to the common writer.
> 
> In a few more patches all CD writers will call an appropriate make
> function and then directly call arm_smmu_write_cd_entry().
> arm_smmu_write_ctx_desc() will be removed.
> 
> Until then lightly tweak arm_smmu_write_ctx_desc() to also use the new
> programmer by using the same logic as right now to build the target CD on
> the stack, sanitizing it to meet the used rules, and then using the
> writer.
> 
> This is necessary because the writer expects that the currently programmed
> CD follows the used rules. Next patches add new make functions and new
> direct calls to arm_smmu_write_cd_entry() which will require this.
> 
> Jason
