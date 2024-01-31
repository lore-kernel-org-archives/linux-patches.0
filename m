Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA497F488
	for <patches@lists.linux.dev>; Wed, 31 Jan 2024 14:34:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706711671; cv=none; b=QglqktGg9rEnQgE7PWRvsJce3tm4OCj2XD8mHpZyioy9CJ9E//S6QjS3Arbkq+xaS6j0Sh+wX40Szet/kGdkWBDLrWEFN98ZthkZeWjuJpve/1eQuR6BmWq27hwfP0PFvTE5xgT4n72dMqHMBXe23YFESqz9W6GgZZjd4d03HTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706711671; c=relaxed/simple;
	bh=xjCEbBRhazJUQAffaemogB93qHXvZg8m+6w7ABq49A0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i6FDDeXCFLi31s50cghHKfNU+7sQF8I/uVVuaEu9GvfDpNa0lJ+7ypXzT0eDDg1IAInBjCVphL7rYPZbdJQOgUxK27gI1y/FG3PWkUBXsXknjg2Wq0LeYIOAj/tJZUayx2HRl+kyNOiLz75hCHwHBUcdQUzosMn8cnsp/5IDtLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4I0gElCc; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4I0gElCc"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-40ef9382752so56635e9.0
        for <patches@lists.linux.dev>; Wed, 31 Jan 2024 06:34:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1706711668; x=1707316468; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=JpjaYX2Bm7BNypekCmj2qKyZLKhzYmWDn0owCWw8KnY=;
        b=4I0gElCc6yf34+lbec6q+apCiIVv1nsRN9yIYUX+DtO9OgXkthaj64JZ1NDpPlQkfQ
         n9T1K07lwAfgSnW3zlrzHjktIVRd+gIE4LjozzrptExcpIE7HjhUFgxj46mXEuKJF8rg
         YxKrBKp2vch67tagKOaEeujVzrt2ZjyErKbhg1s4CtsKhaz6uL9IKEurJpB5aH4geBuY
         +C+YAdKBQpjQpYu434fSxGafRjH/VZ5rOIze+2RCAKVj9iBlFXvvm0DLH+m5F9wzzzjo
         DGMQSxeXfyrM11QjzJ8yqArH8ep9obzUYTL878qJmGz4IiYDw/s8Mog8syxq7qaxvtOi
         IIvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706711668; x=1707316468;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=JpjaYX2Bm7BNypekCmj2qKyZLKhzYmWDn0owCWw8KnY=;
        b=QXNU0X3xUin7nE44tGRHvdpF9Ns0oYovnOlaz7AGFZf+s4TsNj3S2Q1pmKIyFz5F7c
         QKRV/ITMBNMgPeGNNiF/I8NS+z9y34Lf4h6OKat7fCVrP7ijdXmAnfck9p0zNP/YZD0p
         UZ5GKfmQB4p5jzSgeQ1euK4ELP9AAhSQtagtSKl+TN0ssBD0GYAnAi8XF4a668ac+Zru
         Xl3IOH40pXWXk5azuq3CpCR0j8sjLBCaS5UaagUXrWMU7gHxJGCAox8ilGzRlpx0l++y
         fxl5dJ1lix3fiQOpRwMAnMJlD9TJPgmkT4vz4inRIzwSeamSLSRpiSDGGoYFJNlZ3aFM
         1h0w==
X-Gm-Message-State: AOJu0YxCcm+6ONuI8KOkobyKAwVnEz6wT3uQt30hYhOsv7/HkceKMUud
	Lh5u8PZ03KPo+B3esrXFUFYsyS5OyKCB+LI5s3K8kEv7hMNVk5qS5gJvaA9qzw==
X-Google-Smtp-Source: AGHT+IETjNsaUhQTAF5CrEhZRptSbgf41YUIA1YCZ/JVABMZSk9VjGL6JUdJ/nYWV9+NkjbN/0k0gw==
X-Received: by 2002:a05:600c:1e13:b0:40e:fa92:e52d with SMTP id ay19-20020a05600c1e1300b0040efa92e52dmr364828wmb.2.1706711667643;
        Wed, 31 Jan 2024 06:34:27 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWtjp2le7tqdnQyn1m9w13bXZBXt0N1qZjohCANaKQVKdhp/0Qr+3dpXDfscX6MIVA/sU7CtDePEANPYuVz1Xqldh0OVkKtotYbMRVRXGnSYxLelJETB8Q0fbE4PPKy9j8gccBh1QhRFU4Kc0JN1Ccme5WNHnoQTc2/G1w4Xs7seR0pWPvHzP+ZuyLh+lLVSSG7BLzwGfXlhEmLraOavME+b1k0+1EFXJbh+kokxwYgVkxBO/nBpsf7TzPkTDk7lukdio56ch42mb6jbDDs229rEmSZSfCPcHY6VF+hjKTwg5yBs6Jt5TEceFLPqxJidRokMCRGN126g7xEIJGDQ3NBzX6SpsyFXVMk8OFgA28D7Y+dWHIcZMBU
Received: from google.com (185.83.140.34.bc.googleusercontent.com. [34.140.83.185])
        by smtp.gmail.com with ESMTPSA id u13-20020a05600c00cd00b0040f02114906sm1753035wmm.16.2024.01.31.06.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 31 Jan 2024 06:34:27 -0800 (PST)
Date: Wed, 31 Jan 2024 14:34:23 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	Moritz Fischer <mdf@kernel.org>,
	Moritz Fischer <moritzf@google.com>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v4 01/16] iommu/arm-smmu-v3: Make STE programming
 independent of the callers
Message-ID: <Zbpab0NoE2mKBnUc@google.com>
References: <0-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <1-v4-c93b774edcc4+42d2b-smmuv3_newapi_p1_jgg@nvidia.com>
 <Zbl7RQwOGPebvv_0@google.com>
 <20240130235611.GF1455070@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240130235611.GF1455070@nvidia.com>

On Tue, Jan 30, 2024 at 07:56:11PM -0400, Jason Gunthorpe wrote:
> On Tue, Jan 30, 2024 at 10:42:13PM +0000, Mostafa Saleh wrote:
> 
> > On Thu, Jan 25, 2024 at 07:57:11PM -0400, Jason Gunthorpe wrote:
> > > As the comment in arm_smmu_write_strtab_ent() explains, this routine has
> > > been limited to only work correctly in certain scenarios that the caller
> > > must ensure. Generally the caller must put the STE into ABORT or BYPASS
> > > before attempting to program it to something else.
> > > 
> > > The iommu core APIs would ideally expect the driver to do a hitless change
> > > of iommu_domain in a number of cases:
> > > 
> > >  - RESV_DIRECT support wants IDENTITY -> DMA -> IDENTITY to be hitless
> > >    for the RESV ranges
> > > 
> > >  - PASID upgrade has IDENTIY on the RID with no PASID then a PASID paging
> > >    domain installed. The RID should not be impacted
> > > 
> > >  - PASID downgrade has IDENTIY on the RID and all PASID's removed.
> > >    The RID should not be impacted
> > > 
> > >  - RID does PAGING -> BLOCKING with active PASID, PASID's should not be
> > >    impacted
> > > 
> > >  - NESTING -> NESTING for carrying all the above hitless cases in a VM
> > >    into the hypervisor. To comprehensively emulate the HW in a VM we should
> > >    assume the VM OS is running logic like this and expecting hitless updates
> > >    to be relayed to real HW.
> > 
> > From my understanding, some of these cases are not implemented (at this point).
> > However, from what I see, most of these cases are related to switching from/to
> > identity, which the current driver would have to block in between, is my
> > understanding correct?
> 
> Basically
> 
> > As for NESTING -> NESTING,  how is that achieved? (and why?)
> 
> Through iommufd and it is necessary to reflect hitless transition from
> the VM to the real HW. See VFIO_DEVICE_ATTACH_IOMMUFD_PT
> 
> > AFAICT, VFIO will do BLOCKING in between any transition, and that domain
> > should never change while the a device is assigned to a VM.
> 
> It ultimately calls iommufd_device_replace() which avoids that. Old
> vfio type1 users will force a blocking, but type1 will never support
> nesting so it isn't relevant.
>
Thanks, I will check those.
> > > diff --git a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > index 0ffb1cf17e0b2e..690742e8f173eb 100644
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c
> > > @@ -48,6 +48,22 @@ enum arm_smmu_msi_index {
> > >  	ARM_SMMU_MAX_MSIS,
> > >  };
> > >  
> > > +struct arm_smmu_entry_writer_ops;
> > > +struct arm_smmu_entry_writer {
> > > +	const struct arm_smmu_entry_writer_ops *ops;
> > > +	struct arm_smmu_master *master;
> > 
> > I see only master->smmu is used, is there a reason why we have this
> > struct instead?
> 
> The CD patches in part 2 requires the master because the CD entry
> memory is shared across multiple CDs so we iterate the SID list inside
> the update. The STE is the opposite, each STE has its own memory so we
> iterate the SID list outside the update.
> 
> > > +struct arm_smmu_entry_writer_ops {
> > > +	unsigned int num_entry_qwords;
> > > +	__le64 v_bit;
> > > +	void (*get_used)(struct arm_smmu_entry_writer *writer, const __le64 *entry,
> > > +			 __le64 *used);
> > 
> > *writer is not used in this series, I think it would make more sense if
> > it's added in the patch that introduce using it.
> 
> Ah, I guess, I think it is used in the test bench.
>  
> > > +	void (*sync)(struct arm_smmu_entry_writer *writer);
> > > +};
> > > +
> > > +#define NUM_ENTRY_QWORDS (sizeof(struct arm_smmu_ste) / sizeof(u64))
> > > +
> > 
> > Isn't that just STRTAB_STE_DWORDS, also it makes more sense to not tie
> > this to the struct but with the actual hardware description that would
> > never change (but the struct can change)
> 
> The struct and the HW description are the same. The struct size cannot
> change. Broadly in the series STRTAB_STE_DWORDS is being dis-favoured
> for sizeof(struct arm_smmu_ste) now that we have the struct.
> 
> After part 3 there are only two references left to that constant, so I
> will likely change part 3 to remove it.

But arm_smmu_ste is defined based on STRTAB_STE_DWORDS. And this macro would
never change as it is tied to the HW. However, in the future we can update
“struct arm_smmu_ste” to hold a refcount for some reason,
then sizeof(struct arm_smmu_ste) is not the size of the STE in the hardware.
IMHO, any reference to the HW STE should be done using the macro.

> > > +/*
> > > + * Figure out if we can do a hitless update of entry to become target. Returns a
> > > + * bit mask where 1 indicates that qword needs to be set disruptively.
> > > + * unused_update is an intermediate value of entry that has unused bits set to
> > > + * their new values.
> > > + */
> > > +static u8 arm_smmu_entry_qword_diff(struct arm_smmu_entry_writer *writer,
> > > +				    const __le64 *entry, const __le64 *target,
> > > +				    __le64 *unused_update)
> > > +{
> > > +	__le64 target_used[NUM_ENTRY_QWORDS] = {};
> > > +	__le64 cur_used[NUM_ENTRY_QWORDS] = {};
> > > +	u8 used_qword_diff = 0;
> > > +	unsigned int i;
> > > +
> > > +	writer->ops->get_used(writer, entry, cur_used);
> > > +	writer->ops->get_used(writer, target, target_used);
> > > +
> > > +	for (i = 0; i != writer->ops->num_entry_qwords; i++) {
> > > +		/*
> > > +		 * Check that masks are up to date, the make functions are not
> > > +		 * allowed to set a bit to 1 if the used function doesn't say it
> > > +		 * is used.
> > > +		 */
> > > +		WARN_ON_ONCE(target[i] & ~target_used[i]);
> > > +
> > 
> > I think this should be a BUG. As we don't know the consequence for such change,
> > and this should never happen in a non-development kernel.
> 
> Guidance from Linus is to never use BUG, always use WARN_ON and try to
> recover. If people are running in a high-sensitivity production
> environment they should set the warn on panic feature to ensure any
> kernel self-detection of corruption triggers a halt.
> 
> > > +/*
> > > + * Update the STE/CD to the target configuration. The transition from the
> > > + * current entry to the target entry takes place over multiple steps that
> > > + * attempts to make the transition hitless if possible. This function takes care
> > > + * not to create a situation where the HW can perceive a corrupted entry. HW is
> > > + * only required to have a 64 bit atomicity with stores from the CPU, while
> > > + * entries are many 64 bit values big.
> > > + *
> > > + * The difference between the current value and the target value is analyzed to
> > > + * determine which of three updates are required - disruptive, hitless or no
> > > + * change.
> > > + *
> > > + * In the most general disruptive case we can make any update in three steps:
> > > + *  - Disrupting the entry (V=0)
> > > + *  - Fill now unused qwords, execpt qword 0 which contains V
> > > + *  - Make qword 0 have the final value and valid (V=1) with a single 64
> > > + *    bit store
> > > + *
> > > + * However this disrupts the HW while it is happening. There are several
> > > + * interesting cases where a STE/CD can be updated without disturbing the HW
> > > + * because only a small number of bits are changing (S1DSS, CONFIG, etc) or
> > > + * because the used bits don't intersect. We can detect this by calculating how
> > > + * many 64 bit values need update after adjusting the unused bits and skip the
> > > + * V=0 process. This relies on the IGNORED behavior described in the
> > > + * specification.
> > > + */
> > > +static void arm_smmu_write_entry(struct arm_smmu_entry_writer *writer,
> > > +				 __le64 *entry, const __le64 *target)
> > > +{
> > > +	unsigned int num_entry_qwords = writer->ops->num_entry_qwords;
> > > +	__le64 unused_update[NUM_ENTRY_QWORDS];
> > > +	u8 used_qword_diff;
> > > +
> > > +	used_qword_diff =
> > > +		arm_smmu_entry_qword_diff(writer, entry, target, unused_update);
> > > +	if (hweight8(used_qword_diff) > 1) {
> > > +		/*
> > > +		 * At least two qwords need their inuse bits to be changed. This
> > > +		 * requires a breaking update, zero the V bit, write all qwords
> > > +		 * but 0, then set qword 0
> > > +		 */
> > > +		unused_update[0] = entry[0] & (~writer->ops->v_bit);
> > > +		entry_set(writer, entry, unused_update, 0, 1);
> > > +		entry_set(writer, entry, target, 1, num_entry_qwords - 1);
> > > +		entry_set(writer, entry, target, 0, 1);
> > > +	} else if (hweight8(used_qword_diff) == 1) {
> > > +		/*
> > > +		 * Only one qword needs its used bits to be changed. This is a
> > > +		 * hitless update, update all bits the current STE is ignoring
> > > +		 * to their new values, then update a single "critical qword" to
> > > +		 * change the STE and finally 0 out any bits that are now unused
> > > +		 * in the target configuration.
> > > +		 */
> > > +		unsigned int critical_qword_index = ffs(used_qword_diff) - 1;
> > > +
> > > +		/*
> > > +		 * Skip writing unused bits in the critical qword since we'll be
> > > +		 * writing it in the next step anyways. This can save a sync
> > > +		 * when the only change is in that qword.
> > > +		 */
> > > +		unused_update[critical_qword_index] =
> > > +			entry[critical_qword_index];
> > > +		entry_set(writer, entry, unused_update, 0, num_entry_qwords);
> > > +		entry_set(writer, entry, target, critical_qword_index, 1);
> > > +		entry_set(writer, entry, target, 0, num_entry_qwords);
> > 
> > The STE is updated in 3 steps.
> > 1) Update all bits from target (except the changed qword)
> > 2) Update the changed qword
> > 3) Remove the bits that are not used by the target STE.
> > 
> > In most cases we would issue a sync for 1) and 3) although the hardware ignores
> > the updates, that seems necessary, am I missing something?
> 
> "seems [un]necessary", right?
Yes, that's a typo.

> All syncs are necessary because the way the SMMU HW is permitted to
> cache on a qword by qword basis.
> 
> Eg with no sync after step 1 the HW cache could have:
> 
>   QW0 Not present
>   QW1 Step 0 (Current)
> 
> And then instantly after step 2 updates DW0, but before it does the
> sync, the HW is permited to read. Then it would have:
> 
>   QW0 Step 2
>   QW1 Step 0 (Current)
> 
> Which is illegal. The HW is allowed to observe a mix of Step[n] and
> Step[n+1] only. Never a mix of Step[n-1] and Step[n+1].
> 
> The sync provides a barrier that prevents this. HW can never observe
> the critical qword of step 2 without also observing only new values of
> step 1.
> 
> The same argument is for step 3 -> next step 1 on a future update.

I see, thanks for the explanation.

Thanks,
Mostafa
