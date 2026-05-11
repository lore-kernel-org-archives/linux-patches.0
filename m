Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9DF93D8135
	for <patches@lists.linux.dev>; Mon, 11 May 2026 10:34:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778495659; cv=none; b=nHhwENZDHJ5v4pejqko/zZ65/3ApOzHNv5LmBRfwzMHeC1o4DlhCYcZ33H21jNlKL6kH8FwXalxIgGtMty0f1is21MLpC46/i6dA65ZnEZeUWUUZb35CZEjRnYtnigccPycW8FbSRn0yiQ2Dy+z61akDrFCUYaInRaV3D7FvuFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778495659; c=relaxed/simple;
	bh=OBjJ4qWY2VNba0vgmOYHWkVFmsOhC9ZRZRJDpBNdUpM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UfcpNPxb07lY05mA84kfIZ4XPvgceDln+R0jsyYyjKVR+ZEmByjVYX+myOhR2NJxmziPR2z3WPRGbYALtBKX8A70IcGbYGqolFrizyAwOGyXFfJkkg7uYqtjnGsdfgt3mfPzbhb/OgYkwaP5UyhT+vhk5wyJUgZBTIGqJwcSAAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=HH5zERF1; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="HH5zERF1"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ba180a022dso2285ad.1
        for <patches@lists.linux.dev>; Mon, 11 May 2026 03:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778495657; x=1779100457; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+1RmAL1G6V7aOO8kOtNRCIE/n9eFhH+hpo5Ze/Bw3SM=;
        b=HH5zERF1ypgVNOE5MbIYGzi3dcvB0iZ59VX6D60pAZx4b//sf0zfKF3Q0VMciMpMRA
         erE8ns52gY5hAOMBgzpwiX9xRkfsOXIf+ULguhQIyI//BeVuCusrOWB5unYondJyZwB2
         BocjEof6XHRXeo8qVfYX8FQodn/xSQ/3alCKU9zxzUv66ytUxGdDAhwefwPRxhPYW2mx
         YyU2cCpTO3J+tN5ZMnBE3f9aozDf+YmNBXw/g/UqNNp+DUtnjADXJyc+4Am5eckLvRyt
         vzJzaaMQkdFTQj+4NN0+9RRAUzVs0m4V2HOLLejP2oOeo+JC7WTTFNbQQQWrR1uHZXiM
         gKxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778495657; x=1779100457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+1RmAL1G6V7aOO8kOtNRCIE/n9eFhH+hpo5Ze/Bw3SM=;
        b=U/MysQV9RNlR+y9LS01c5le3zqWooBKjsh7YNRKRh4dPThHWBh9FiChBIsLhqAA1vs
         ZVVoq7EYGD/9fabAZrsjSem2IwzXw22ijugDWrK5TLl5TXWXAnbnNR62vS6iwIYGrtjK
         vqB/oGu4ty6ZTSepIyWwotCl0o4FPUtasHSyyG/Uz9xhBE+d8HieK7wBAxpe59peuI9Y
         If3k++frSZzlQkm3ClpGFBzLJ7ZgMeo30XEZ9VDg2Xl38ek/J5hGidbHDzPevdZzYGae
         T7ioEKJdhlEThxfFY2d5fwjDpp6CnAHNWkplIpE4PI/PhV5tr3EqLfvUeuH11UyeKsI8
         Mm/Q==
X-Forwarded-Encrypted: i=1; AFNElJ/2XBvQYJ1sffZSjZUNMODWxMvQxx/r8dQtqN4Yw1G9R2JiKcLhSHoOaRSdeUkBiC4JytUNKjmY@lists.linux.dev
X-Gm-Message-State: AOJu0YwsuK90G9wpl2nmqJBmpexJssWG6bBP6RZwI+cA5qa0eCHbPzKW
	eZthuTqCmItG+WXU62wLu+5+EQ1OZSFruySaz7HDwFzRwXLYph5LPOYCyER+psIuqg==
X-Gm-Gg: Acq92OH89jxgM3pADiMY6Ub5kqcwC67lCT/5uhJRKkILcRlv5h8OrFF+UqWFexCSZg/
	/u/ZcpMMm+Qv7slPVtOKoGm1EpWp4gbzixzZKZEpQoTZx8x2qo3k/n79A69g75vn5amRcTOciNF
	Xa5K/U968EcJXNSJI57Sh8ba5t7kQ2Ay7DClt5U1RodLONbAIaBTF1pI/oZLrvBHlI+yLUukcEg
	k14MnYbI1c9sGgdZGAFPKH4ViDArqh1fcjbwCLIZcbOnMF1AYqQj0fkHJ/ngy99fUUIP2Yi/1UQ
	XirAjclLq3oVFOS3hEDBU0+0mJIYNdftDp3vfvoWAk6HKPTho2y3qJZy8gM/fnCf34BadOdnEd5
	8xaN/h46nf9YGbGkU7y6w/aPNj+l1DHrbUz2LkM/aSuMAecXN4S29LQtShQwPRDfWW7+wbCzwHI
	Cgtl68fnIu2mgkO2f8ATJb4FpI6PDpFHmgpWisPP4nDA/njnDQBxEr3GCR5tL5gZjjNaRE
X-Received: by 2002:a17:903:1c3:b0:2a7:6c4e:5914 with SMTP id d9443c01a7336-2bc746fc88cmr4737145ad.6.1778495656102;
        Mon, 11 May 2026 03:34:16 -0700 (PDT)
Received: from google.com (44.234.124.34.bc.googleusercontent.com. [34.124.234.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-367d63e03f6sm7798313a91.12.2026.05.11.03.34.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 May 2026 03:34:15 -0700 (PDT)
Date: Mon, 11 May 2026 10:34:09 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, Jonathan Hunter <jonathanh@nvidia.com>,
	Joerg Roedel <joro@8bytes.org>,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	Robin Murphy <robin.murphy@arm.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Krishna Reddy <vdumpa@nvidia.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH 7/9] iommu/arm-smmu-v3: Directly encode CMDQ_OP_ATC_INV
Message-ID: <agGwoYJD3s2T00fX@google.com>
References: <0-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <7-v1-b7dc0a0d4aa0+3723d-smmu_no_cmdq_ent_jgg@nvidia.com>
 <af3NH0cihPUQ8PST@google.com>
 <20260509165401.GL9254@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260509165401.GL9254@nvidia.com>

On Sat, May 09, 2026 at 01:54:01PM -0300, Jason Gunthorpe wrote:
> On Fri, May 08, 2026 at 11:46:39AM +0000, Pranjal Shrivastava wrote:
> > On Fri, May 01, 2026 at 11:29:16AM -0300, Jason Gunthorpe wrote:
> > > Add a new command make function and convert all the places using
> > > ATC_INV.
> > > 
> > > Split out full invalidation to directly make the cmd instead of
> > > overloading size=0 to mean full invalidation.
> > > 
> > > Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> > > ---
> > 
> > Nit: I guess it's worth mentioning that we remove CMDQ_ATC_0_GLOBAL as
> > we don't set ent->atc.global = true anywhere in the driver anymore.
> 
> I added this:
> 
> In section "3.9.1 ATS Interface" of F.b the specification says:
> 
>   When the SMMU returns an ATS Translation Completion for a request that
>   had a PASID, the Global bit of the Translation Completion Data Entry
>   must be zero.
> 
> Even though it faithfully forwards the G bit through to the ATS
> invalidation command there is no way to create G mappings so there is
> never any need to send a G invalidation. Thus don't expose global in the
> new helpers and leave CMDQ_ATC_0_GLOBAL unused.

Ack. Sounds good. Should also add that the only other place we might need
G=1 is for a full ATC wipe. However, we don't since the PCIe Spec 10.3.8,
mentions issuing an invalidation without a PASID prefix (SSV=0) already
forces the device to invalidate all ATC entries for any PASID at all 
addresses, e.g. arm_smmu_atc_inv_master(master, IOMMU_NO_PASID).

Although the comment in arm_smmu_enable_ats should suffice too.

Thanks,
Praan
