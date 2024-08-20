Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0455615C147
	for <patches@lists.linux.dev>; Tue, 20 Aug 2024 19:53:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724183582; cv=none; b=KOkAYoZOR7nnev0VNcO2h/UQjhHNlV06AWpm+odqYAE4JC3WLtMGL+ixrzXv5PuMmyhW6ODy3UTJhs5u/1fMlRrDuWAFF5MisTS5TJwg9YSUaM1JH+PwImEAsrVm7LLphRtAsMeZjcS6ISZcUrQlMEHWe7wBDkYiG1Tt4+8NqyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724183582; c=relaxed/simple;
	bh=f2EDYJYaLCiAoxFHTZr78tEIJO4+g6e/klYwcujCItM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fPAPHaaxWDad9iyRnvgwzBSO/oT2PB/GdFT5tvVkI5vqPywW9V9AWNAodPkxLZcxZDon0H0oBntH7Nu7zWlOWf1Q8oNOpBEVDbNEv5FvAB8unNhNIYV0mxUukrEQuMQz3PPcjDpJOS87KkgSy2aJ76cO86ICd1Q+o3uBQt0nLBg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M59SPv75; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M59SPv75"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-428e12f6e56so15155e9.0
        for <patches@lists.linux.dev>; Tue, 20 Aug 2024 12:53:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1724183579; x=1724788379; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yp4vfYpCGOdYBS/m6HmbaB98zMN6C60AGpKXCWzp5n0=;
        b=M59SPv75VJ4cuxFAj1LBtKbLzZPUb2N6KD90Z02uWfyU/uRBAuMxtvNPiYs8vBDeYM
         5YQijTQkKlNCGG1FBtuKa68GlylMtwOjaYFXokx+0Im72HetE/VSE2y+M+yFqctBXFwy
         IzgXU7BcK4Xec5Q7lnhbvBpjaM7AJee+W6rcRQf6hJfrZcdFiDD0Kd9kElcWg8sCPz2V
         Xg0J2hsGNThrRdUHFGh2fx+O6IdIDVoEX8SH94pu+4CTIb5BKLhmMDajOYr/xL3kCo07
         J1d9NT347MmxijtwlPgxPgCGenX4Ng7/d1dqkImhv61D3aRSSUXsqJEhSW3N1z5CJimT
         2m2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724183579; x=1724788379;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yp4vfYpCGOdYBS/m6HmbaB98zMN6C60AGpKXCWzp5n0=;
        b=WmN56hExWscHSEWuwXYUY98YAyZ3szp+HDD5SDhQqEcUQhzWPBxEI3pB3usrP4bcM5
         gkBckNUJgHNqA1Pd3o0IUpiUvWJP66m1vMSk7sSSyW73OntBqniYJquj2zldE9JBIjs2
         3GXiD9zqt9wxFzsmd7zcasWsLvqDiqZIX3KWi8gv36cCN5hgv9j7mnRufuQyKR1UABmp
         N78IDUWV4IdJbGz+j0CR0Un3wILC8jP7FU5toqk4ePYzjcVP3vPrRqVxgYXBzMpilP4e
         BrYNi/IrS+zXT3thMMCebj6Q5R32CsXwEiX6a98246XC1L7U8TUQ56uoU0kwMCu0YBje
         X3dA==
X-Forwarded-Encrypted: i=1; AJvYcCVDkoZ+4M+FBQ33RKp03MDwBbHhKPL1BotUAiMScUwk2a8njs0lpdfXyzQnOInY1CuMWpEDfT/+@lists.linux.dev
X-Gm-Message-State: AOJu0YyuwAysYZgeaIexZanLxvxauPSZOE7aWignPnf/DVq4LqUQFcED
	kKtOZZIWHktH8JH1Z3hfiYUOyS7rznWRxz70OXF4+hi34CrvKg/EFaZgvJ42PQ==
X-Google-Smtp-Source: AGHT+IEIPDf3d+uDL/Y/8Kxr91qxpv+48637k6O2srNTmFhDwf9KvmOeUX+rRg1Oapmp/C3vcKZSsw==
X-Received: by 2002:a05:600c:1f07:b0:424:898b:522b with SMTP id 5b1f17b1804b1-42ab78c1aa8mr1113155e9.1.1724183578856;
        Tue, 20 Aug 2024 12:52:58 -0700 (PDT)
Received: from google.com (203.75.199.104.bc.googleusercontent.com. [104.199.75.203])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-371898b89bdsm13811059f8f.112.2024.08.20.12.52.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Aug 2024 12:52:58 -0700 (PDT)
Date: Tue, 20 Aug 2024 19:52:53 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev,
	Alex Williamson <alex.williamson@redhat.com>,
	Hanjun Guo <guohanjun@huawei.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>,
	kvm@vger.kernel.org, Len Brown <lenb@kernel.org>,
	linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH 2/8] iommu/arm-smmu-v3: Use S2FWB when available
Message-ID: <ZsT0Fd5FHS47gm0-@google.com>
References: <0-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <2-v1-54e734311a7f+14f72-smmuv3_nesting_jgg@nvidia.com>
 <ZsRUDaFLd85O8u4Z@google.com>
 <20240820120102.GB3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240820120102.GB3773488@nvidia.com>

On Tue, Aug 20, 2024 at 09:01:02AM -0300, Jason Gunthorpe wrote:
> On Tue, Aug 20, 2024 at 08:30:05AM +0000, Mostafa Saleh wrote:
> > Hi Jason,
> > 
> > On Tue, Aug 06, 2024 at 08:41:15PM -0300, Jason Gunthorpe wrote:
> > > Force Write Back (FWB) changes how the S2 IOPTE's MemAttr field
> > > works. When S2FWB is supported and enabled the IOPTE will force cachable
> > > access to IOMMU_CACHE memory and deny cachable access otherwise.
> > > 
> > > This is not especially meaningful for simple S2 domains, it apparently
> > > doesn't even force PCI no-snoop access to be coherent.
> > > 
> > > However, when used with a nested S1, FWB has the effect of preventing the
> > > guest from choosing a MemAttr that would cause ordinary DMA to bypass the
> > > cache. Consistent with KVM we wish to deny the guest the ability to become
> > > incoherent with cached memory the hypervisor believes is cachable so we
> > > don't have to flush it.
> > > 
> > > Turn on S2FWB whenever the SMMU supports it and use it for all S2
> > > mappings.
> > 
> > I have been looking into this recently from the KVM side as it will
> > use FWB for the CPU stage-2 unconditionally for guests(if supported),
> > however that breaks for non-coherent devices when assigned, and
> > limiting assigned devices to be coherent seems too restrictive.
> 
> kvm's CPU S2 doesn't care about non-DMA-coherent devices though? That
> concept is only relevant to the SMMU.
> 

Why not? That would be a problem if a device is not dma coherent,
and the VM knows that and maps it’s DMA memory as non cacheable.
But it would be overridden by FWB in stage-2 to be cacheable,
it would lead to coherency issues.

> The issue on the KVM side is you can't put device MMIO into the CPU S2
> using S2FWB and Normal Cachable, it will break the MMIO programming
> model. That isn't "coherency" though.> 
> It has to be Normal-NC, which this patch does:
> 
> https://lore.kernel.org/r/20240224150546.368-4-ankita@nvidia.com

Yes, that also breaks (although I think this is an easier problem to
solve)

> 
> > But for SMMUv3, S2FWB is per stream, can’t we just use it if the master
> > is DMA coherent?
> 
> Sure, that seems to be a weird corner. Lets add this:
> 
> @@ -4575,7 +4575,12 @@ static int arm_smmu_device_hw_probe(struct arm_smmu_device *smmu)
>  
>         /* IDR3 */
>         reg = readl_relaxed(smmu->base + ARM_SMMU_IDR3);
> -       if (FIELD_GET(IDR3_FWB, reg))
> +       /*
> +        * If for some reason the HW does not support DMA coherency then using
> +        * S2FWB won't work. This will also disable nesting support.
> +        */
> +       if (FIELD_GET(IDR3_FWB, reg) &&
> +           (smmu->features & ARM_SMMU_FEAT_COHERENCY))
>                 smmu->features |= ARM_SMMU_FEAT_S2FWB;
>         if (FIELD_GET(IDR3_RIL, reg))
>                 smmu->features |= ARM_SMMU_FEAT_RANGE_INV;
> 
> IMHO it would be weird to make HW that has S2FWB but not coherency,
> but sure let's check it.
> 
What I mean is the master itself not the SMMU (the SID basically),
so in that case the STE shouldn’t have FWB enabled.

> Also bear in mind VFIO won't run unless ARM_SMMU_FEAT_COHERENCY is set
> so we won't even get a chance to ask for a S2 domain.

Oh, I think that is only for the SMMU, not for the master, the
SMMU can be coherent (for pte, ste …) but the master can still be
non coherent. Looking at how VFIO uses it, that seems to be a bug?

Thanks,
Mostafa

> 
> Jason
