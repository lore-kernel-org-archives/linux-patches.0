Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38CCCECC
	for <patches@lists.linux.dev>; Sat, 27 Apr 2024 22:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714257242; cv=none; b=UUNzv5zseMy2yFoLK9oOFrJVDRR+0lpcDiygau3ST38DXU49qilJ4cQp/8Xene8tgqvxy0iXlJq4vNjZw1JhokMz3yuQeVh6eHAij/Du2PI5ZSSbcvlI/YeUSlkS5Swczi9vasWZrNUrubXFlAEPlgUDn4NGUZBzREmFk+1Rg3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714257242; c=relaxed/simple;
	bh=faGX1VOEOHks2i/UTFRkr48rAy4HZ/lma5mgX01V0xQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AkBR5LksjsBzeN46XVD0RWxCGc8kmi4a+NDYlYJoa4DVGVAMuICJjwk+qoPPTyabq9No7p4wTXreE34jd/oiDwKEQbQW3gOBimPQSCCX/TJbahJHxJ13HNVCLLtbCa6jSISwWVzEOfJPKkti5z22Mu8lI/19Zeiw7Ml2OC2S+zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XC3cMG5z; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XC3cMG5z"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-41a428374b9so31345e9.1
        for <patches@lists.linux.dev>; Sat, 27 Apr 2024 15:34:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1714257239; x=1714862039; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=V/i8u7CaJgG+Eq6v0eYBH4Z15Kbb3B5gzHjqYZDCiHg=;
        b=XC3cMG5za9k4NkLSysp6cMq7m98fW4fdTGFJc+V+tBb/fGWR8QQwAI6CZNFLwsWmnw
         tMP+Hvk8stqLJPDBqJoDlDHWoimNBF8QaUBo9DvY3xmEhy+kWhEYPc7Lyw3MKN4rlksJ
         zlYQa8gJci22FMR3E9lYgSmw7a+d6R/44zfSpieQtXkplF1aoKwlOj2uQh9CYOtPYffy
         2UEanRGbMHFvpu3m+EJ1t60P+DKM3/vOv2AI1gGHrFCdid4IaBRrmbYXY8o8mVDnhhTC
         QqjWtyr8pPogN4CR0kySqiIGJojLENo6MAllcpzfP3ZEPAMyTgG0x876vR1MkBHVleOn
         Vv+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714257239; x=1714862039;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=V/i8u7CaJgG+Eq6v0eYBH4Z15Kbb3B5gzHjqYZDCiHg=;
        b=eyw9MKCyYxLG8F7oNhYayUFMB1VLF0DJA0FyOzgGOte791ij9HfytmJKxcgJdUKK+S
         UwPgGyshqGyQUlSFZuBqP3RYIYyJpqs+U+IiecyZ+LyaKyEoQAqGZuP1LxVMCCgB+aSn
         3wEWm6BDCFPmbstIWV4Si4MTeQPtHZN0nqS25ZkFGxM4XRWU+z6tqTA7qXGHhooJA23W
         xt2nGP8P3WG3Z7WLKcZUqvzjDC5ZlZO+7qwP1Eni8M+xaHDr5mcfiNTnfD+ARn9EkHAf
         6Uwj781i5SKCCWT6ShMjG0pTcqSM3+L/SCMjwi4q4wkCY3i3SRdkj4r8XqS7gI8QBk+8
         PkGQ==
X-Forwarded-Encrypted: i=1; AJvYcCUYJcpRtMeEca85keNn7RoW+4TAmtPEo9ILQsakW2J8cJu/u2soqd0g1fpNepZMkP5NTEtWA8jjepvebecyiF3SvWShgz9Vig==
X-Gm-Message-State: AOJu0YylUiPRFW76Ve0j+zZnwvGiKHyn0S3pkgaYrLOS0bHlzEQ49tAo
	O/4c5iDSLxCFT9GzC5GR9+ZceT1PgkIhhVP6skDdpY0CN0kyceaYxatDFpdNLA==
X-Google-Smtp-Source: AGHT+IEipR/v+Af76x/mX+4qD42v1PKzqBQ4TbxCJAuxAMJx1QDtSRh/JXJyyC1j2l74SUgrGFb+8w==
X-Received: by 2002:a05:600c:470a:b0:41b:ff4e:c8a4 with SMTP id v10-20020a05600c470a00b0041bff4ec8a4mr46926wmo.0.1714257239313;
        Sat, 27 Apr 2024 15:33:59 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id d10-20020a5d4f8a000000b0034cc78572f0sm1193183wru.102.2024.04.27.15.33.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Apr 2024 15:33:58 -0700 (PDT)
Date: Sat, 27 Apr 2024 22:33:55 +0000
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
Subject: Re: [PATCH v7 9/9] iommu/arm-smmu-v3: Add unit tests for
 arm_smmu_write_entry
Message-ID: <Zi19U2MufT9W3Jxe@google.com>
References: <0-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <9-v7-cb149db3a320+3b5-smmuv3_newapi_p2_jgg@nvidia.com>
 <ZiLhJKBLdr_YqL_y@google.com>
 <20240422142429.GE49823@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240422142429.GE49823@nvidia.com>

On Mon, Apr 22, 2024 at 11:24:29AM -0300, Jason Gunthorpe wrote:
> On Fri, Apr 19, 2024 at 09:24:52PM +0000, Mostafa Saleh wrote:
> > > +static void arm_smmu_test_make_sva_release_cd(struct arm_smmu_cd *cd,
> > > +					      unsigned int asid)
> > > +{
> > > +	struct arm_smmu_master master = {
> > > +		.smmu = &smmu,
> > > +	};
> > > +
> > > +	arm_smmu_make_sva_cd(cd, &master, NULL, asid);
> > > +}
> > > +
> > 
> > The test doesn’t build with SVA disabled, it fails with:
> > aarch64-linux-gnu-ld: Unexpected GOT/PLT entries detected!
> > aarch64-linux-gnu-ld: Unexpected run-time procedure linkages detected!
> > aarch64-linux-gnu-ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: in function `arm_smmu_test_make_sva_release_cd':
> > .../linux/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:409:(.text+0x17c): undefined reference to `arm_smmu_make_sva_cd'
> > aarch64-linux-gnu-ld: drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.o: in function `arm_smmu_test_make_sva_cd':
> > .../linux/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-test.c:399:(.text+0x230): undefined reference to `arm_smmu_make_sva_cd'
> > 
> > I belive this check should be guarded under SVA.
> 
> Ugh yes, 0-day just hit this too.
> 
> I'm just going to do this:
> 
>  config ARM_SMMU_V3_KUNIT_TEST
>         bool "KUnit tests for arm-smmu-v3 driver"  if !KUNIT_ALL_TESTS
>         depends on KUNIT
> +       depends on ARM_SMMU_V3_SVA
>         default KUNIT_ALL_TESTS
>         help
>           Enable this option to unit-test arm-smmu-v3 driver functions.
> 
> 
> Instead of adding #ifdefs.  No reason not to test the whole driver?
> 

Sounds good, I guess that option will be only used for development.

Thanks,
Mostafa

> > > @@ -980,7 +968,7 @@ void arm_smmu_tlb_inv_asid(struct arm_smmu_device *smmu, u16 asid)
> > >   * would be nice if this was complete according to the spec, but minimally it
> > >   * has to capture the bits this driver uses.
> > >   */
> > > -static void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> > > +void arm_smmu_get_ste_used(const __le64 *ent, __le64 *used_bits)
> > 
> > IMO we should not export all these low level functions unconditionally.
> > KUNIT already defines “VISIBLE_IF_KUNIT” which sets symbols to be static
> > if CONFIG_KUNIT is not enabled. Or maybe even guard it for this test
> > like what btrfs does with “EXPORT_FOR_TESTS”
> 
> Sure, that doesn't look like too much trouble long term.
> 
> Thanks,
> Jason
