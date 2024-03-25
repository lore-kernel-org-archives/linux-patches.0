Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7578D5BAC1
	for <patches@lists.linux.dev>; Mon, 25 Mar 2024 21:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711400573; cv=none; b=E1oAhRj/unxDt1jmqmlVu041E+NfwQdJIAuJvG0mLZP8B9mgFoHBXReZXK7t8kLBpcBhaf+5yDZGzQW9m+2QeySbdPxW8GJPKCX09MmQW0jc39X/J1Mrn94fMnwkBwfvBFsAuCmAUFh9o6P+M/Zn4VTiuRU0HyKdV3VbjN4Htx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711400573; c=relaxed/simple;
	bh=OywY4I5adWwnLh/laC1ARj9udrQ7qWNwu/pccoMaJr4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ECc0H9MUwW2ShXlPOGGudBBO2K8qh+ZHTYUieU68W+zkHBXgAcf6pJ+mNcDuWtwKmjYrdohhGAbrPM+NlbBeprSmjaB6MnPJLaijHo+kNcrVbs36KMYv/2EDN1ptwdSZkp0TBG7v4l00sFa15emHYvKZ33INc5LhSkPipioodeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=l2zfUYzf; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="l2zfUYzf"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4148c09ec6bso5995e9.1
        for <patches@lists.linux.dev>; Mon, 25 Mar 2024 14:02:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1711400570; x=1712005370; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=oyHdM1HjPu6vtjBVJtvhQHjyUmlH2Ts1yIlCV25UwhM=;
        b=l2zfUYzfl7iF7j084Vr3YBVyEFRb7174vHbU9isip/GdbLLDZL5XhzBVXT+7KS2mee
         ik6yXuQKgBvTh6M/qE6/D7/CoUSzCJ6dxPYG3RcjgEgcZBW0sY3ZdioFKgxK9y8NPLXD
         TQeyb/xxJZE3WVymkDaGCVMazWMdzsdP5h6iJIvF1/U5yWGsMhDP2RA8I5ovSKrLlyzA
         N5EwrtDwRNLJ4db+L0agW6Oi5U4QpRnsNjJ8PCHUHD2Xhw0C/5fuRQG5buK6SZx3vXXc
         EVlqMGIixCZQGT0Y45mxTg4GZwm56vlfK8WswRuh4K4PeA/fToYqFfi4xauJX9bw33wv
         34FA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1711400570; x=1712005370;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oyHdM1HjPu6vtjBVJtvhQHjyUmlH2Ts1yIlCV25UwhM=;
        b=kxUOoQD5tNZUDWvTGPmAqjIqoeO2WWVI8L8zWtkcLIeH8udfuiuU2qss+TLiaKcxy6
         Ae/VFM7FG+FQ4swJ3VB0Qfr1kURDe1TgqISnBBbpoWxDBOLgnJ3FmhoWEJhH8p93JdtO
         R+wblKQDBR7kqaDXdO4EiB2Hu81qf3zZgRWOmbdmbZjyQ5yiZJzHa67fI2nUP7S35SKy
         V8SsVtZwGCay63g5fvxTkkukhdmcgVtmXGRSSZOfLhKJwKiSZnUltWMBUYlahwr3Q6q6
         fWrhVMGDoAmmrmt9WYsROCmQTKtPaXJUSW4iURQg1hae2HSOMrpCfUvfVTU5vsn84ksY
         3QBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUG9ufGOOr731JVPqMPv2DEyn9ujq7PeUFQhJLSKq6lQ7G/d0a4j47vj/ox6e9qHPIOKduxjX2dwydNXS/SxcctMK6JBeGwLw==
X-Gm-Message-State: AOJu0Yy8qdG+dOUgUAxm1B4grpMGyUOydn+p5tt1ICWRP4CyvvFasyoo
	fBbJjuZ/VJNzT6xTyZQyW3k5VL5WD74QkE2NKvU7Ut3Ie+cAtrSIhROP0PSDSbjqKbqk9U9F9ka
	HEw==
X-Google-Smtp-Source: AGHT+IExHgJARivp8cbPHRh0LgG8TmwrsgCGNCGfSSnbswUEv2qNKtbvjuG8qARXLbCe3yOUY0kalg==
X-Received: by 2002:a05:600c:1c27:b0:414:fb8:5105 with SMTP id j39-20020a05600c1c2700b004140fb85105mr16711wms.3.1711400569712;
        Mon, 25 Mar 2024 14:02:49 -0700 (PDT)
Received: from google.com (180.232.140.34.bc.googleusercontent.com. [34.140.232.180])
        by smtp.gmail.com with ESMTPSA id y17-20020adff151000000b0033e43756d11sm10353238wro.85.2024.03.25.14.02.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Mar 2024 14:02:49 -0700 (PDT)
Date: Mon, 25 Mar 2024 21:02:45 +0000
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
Subject: Re: [PATCH v5 06/27] iommu/arm-smmu-v3: Consolidate clearing a CD
 table entry
Message-ID: <ZgHmdXZ3ntMMSDtQ@google.com>
References: <0-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <6-v5-9a37e0c884ce+31e3-smmuv3_newapi_p2_jgg@nvidia.com>
 <Zf3PoRy_q7dC_SA9@google.com>
 <20240325141433.GB110546@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240325141433.GB110546@nvidia.com>

On Mon, Mar 25, 2024 at 11:14:33AM -0300, Jason Gunthorpe wrote:
> On Fri, Mar 22, 2024 at 06:36:17PM +0000, Mostafa Saleh wrote:
> > > +void arm_smmu_clear_cd(struct arm_smmu_master *master, ioasid_t ssid)
> > > +{
> > > +	struct arm_smmu_cd target = {};
> > > +	struct arm_smmu_cd *cdptr;
> > > +
> > > +	if (!master->cd_table.cdtab)
> > > +		return;
> > > +	cdptr = arm_smmu_get_cd_ptr(master, ssid);
> > > +	if (WARN_ON(!cdptr))
> > > +		return;
> > 
> > I don’t understand the SVA code enough, but AFAICT, arm_smmu_sva_set_dev_pasid
> > can allocate the L2 CD table through arm_smmu_write_ctx_desc. 
> 
> Yes
> 
> > And if it failed
> > before allocating the CD table, then remove_dev_pasid would be
> > called, 
> 
> If it fails the core code should not call remove_dev_pasid() on a
> domain that was never attached. There is an obscure error unwinding
> issue in the core code Yi is looking to fix regarding multi-device
> PASID groups, but it is not a driver issue..
> 

I see, thanks for clarifying.

> > which warns here, the previous code would tolerate that, but that
> > might regress on systems with panic_on_warn, so I am not sure if
> > that is necessary.
> 
> Right, if it does hit it signals there is some error unwinding bug in
> the core code that should be resolved.
> 
> > Otherwise, Reviewed-by: Mostafa Saleh <smostafa@google.com>
> 
> Thanks,
> Jason

Thanks,
Mostafa
