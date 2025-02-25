Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A623A18FDB9
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 17:08:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740503312; cv=none; b=BCShTOWpJox+qZ9gCPcoiO09PnQifLDCS/pQqVSQrmnj1SFuUZUkouCzaf8D3UEv5kDoSTqvxEMmgMYEmFmsGuYl1mn8wOWpHNwmw41RLBAJd/1VJlBAIB30fJ3NRNqPSKrkOTEnkCPxMntRuHarcqMG9zH2m4DcBOsIThOap5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740503312; c=relaxed/simple;
	bh=SS9kgyaImj6RHK5LJn7d2R6kJ3V1FoRJ0mFcyFKs1aQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bhvmZitxB+QFVdyo8BNlG811EkGctHUzfEe1NvjybagD55BcdeM6CjijyxZlY+7NtBSmENYvShUiaDFKE7cMDjq2T7WSTpfFNCAIiiXWkM5G2W6/QAAxj/L7oFEaO97zFR12CLksWWk3TVxC5DzIcRAs1ZRDp2AqKG/q06+5Yow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=O3iaL4uF; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="O3iaL4uF"
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2212222d4cdso177785ad.0
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 09:08:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740503309; x=1741108109; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1QM6kau2iQ4j6ZEaDdmG4fMZZFTf4UoSv3ypQuKbFJw=;
        b=O3iaL4uFDRGcCvSYZLuOo9PNbc+aHxAOh6dQaw1C1JydpznkroDD5+PW/6W+AESS3S
         dl3jKVs3bpEaXLgQPeuQQ3a1DDUzWqsIYcJbmp0e3aofNSwwUdh/5dzUeTbDnC6AryRY
         me3RnxqC715oJjOpRa3Vk+A7bDXjIfgNhxMqFHpQziU/g3JPyojQZGzd4GbM5obOwrVb
         H+XCqARg01thMY20aSeZGXg1Z98e1yrrKME5i3Wb+2ou1jOrhitf6dgTGTLkR3k2Zkbc
         2yLt4W4Izsuvg3QsJgo/Tv+FfLJMen2Ayql6SZ0i6PElJZw4qSMzvjQVfeYXCFO9jHxF
         P5gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740503309; x=1741108109;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1QM6kau2iQ4j6ZEaDdmG4fMZZFTf4UoSv3ypQuKbFJw=;
        b=cqHZfVrwGFfLXbtPjjxJjLB/aU24qxiTvntdkJdUN0xe6sypA88stuStkurKOdNAxV
         ka8K+NcEyKNDE6fwCBH1aOJ2TWwPj/fyQyWJomaKQFrPaYXHy3UirKlNGb3Ub3c3mTgz
         DgHxikxL/g6ws3MTTGBXnjflKB/mwLDitK+G5f47HRFRgZo/AxBbB+bAWEpS5bKtu7JU
         UjLx6xeP36Vk1Xg1sDHVEQHwiIhyQe3gXKQ0TBXWR5NaGN4k0LXFAbCWoi1vNnxaIzzj
         MPIzGmChupWYQ2ADmosyZzDh4ft0XDTLxpQJR1mhVTMaSE1LbG5rkl4vxKdavnPOpIkk
         58hw==
X-Forwarded-Encrypted: i=1; AJvYcCU3YjqXWWIYu4qPq4R0diVqRHGZvdwdcyNf7uU/ZBaS6rjjY1L05lw5Lxm5M+VMuh7YXC/wKSbG@lists.linux.dev
X-Gm-Message-State: AOJu0Yw80x3rNkQ10BNQFsRzljfou3fp5akxGhnvmiqDmTOYtAIp9lVo
	Fr1LwolLevthyYZJdj0cVEtBqx7vQD5HLxhlfyHPFcgiJzQ8QHUc89592yOaiQ==
X-Gm-Gg: ASbGnctv5NWQHzP2IPBpC8uTxhdL0KuAjRXpNKSFHtpU6tyg3FqcD4iOqXgOqoDnwIc
	YTkP9T4prpLEk3W5naNnIVpUaZBfnwt6xJUHeLDdduoub+/O3O6CvDeXeSAzqx/Yo6P/jcyxjzl
	QJ3OIzYqdk1qZmA6RL3zCBjZ5VsMd3BL3UOwXhhyf9jAOYR48YmJnGBzO7mgnaNCWIpZ4j69otx
	8ncqfgKce0o8h0qq3xZvp40898JkJNhH+sXFRqzbMY5m3YO+qPoNT3PYTSRQ95ZLmi4qSMh/lFD
	Dc2YfIwtQ9Dzs/kJui/WO6rDucqd6ljnstrVf/WIyjXsq5MX4TiSPyOv5WcvxIA=
X-Google-Smtp-Source: AGHT+IHxrabWDtym7s/ddOkqBHoBfq1ZqP6yAIbeWpN90fX7xeP+90KuPUzmekpH3adGkKddVDiEdg==
X-Received: by 2002:a17:902:ec90:b0:216:607d:c867 with SMTP id d9443c01a7336-22307aabb1cmr3599065ad.29.1740503308535;
        Tue, 25 Feb 2025 09:08:28 -0800 (PST)
Received: from google.com (169.224.198.35.bc.googleusercontent.com. [35.198.224.169])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7347a7f9ae8sm1757069b3a.120.2025.02.25.09.08.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 09:08:27 -0800 (PST)
Date: Tue, 25 Feb 2025 17:08:16 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, kevin.tian@intel.com, corbet@lwn.net,
	will@kernel.org, joro@8bytes.org, suravee.suthikulpanit@amd.com,
	robin.murphy@arm.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
	shuah@kernel.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
	smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 12/14] iommu/arm-smmu-v3: Introduce struct
 arm_smmu_vmaster
Message-ID: <Z735AMlhP29YEndU@google.com>
References: <cover.1740238876.git.nicolinc@nvidia.com>
 <be799951a817557ac093ac3e18d02a631306aa35.1740238876.git.nicolinc@nvidia.com>
 <Z7zYLBLZGKim-5UL@google.com>
 <Z7zlH74/orq9HF7Q@Asurada-Nvidia>
 <Z7zqdrQn7Q8yXfcn@google.com>
 <Z7zxsbJsOFp41Dzd@Asurada-Nvidia>
 <Z70EnQ5CXacc4ysT@Asurada-Nvidia>
 <20250225160225.GA593877@nvidia.com>
 <Z73yt4r0iDFwbty2@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z73yt4r0iDFwbty2@Asurada-Nvidia>

On Tue, Feb 25, 2025 at 08:41:27AM -0800, Nicolin Chen wrote:
> On Tue, Feb 25, 2025 at 12:02:25PM -0400, Jason Gunthorpe wrote:
> > On Mon, Feb 24, 2025 at 03:45:33PM -0800, Nicolin Chen wrote:
> > 
> > > --- a/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> > > +++ b/drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3-iommufd.c
> > > @@ -95,8 +95,6 @@ int arm_smmu_attach_prepare_vmaster(struct arm_smmu_attach_state *state,
> > >  
> > >  	iommu_group_mutex_assert(state->master->dev);
> > >  
> > > -	if (domain->type != IOMMU_DOMAIN_NESTED)
> > > -		return 0;
> > >  	nested_domain = to_smmu_nested_domain(domain);
> > >  
> > >  	/* Skip invalid vSTE */
> > > @@ -122,19 +120,9 @@ void arm_smmu_attach_commit_vmaster(struct arm_smmu_attach_state *state)
> > >  {
> > >  	struct arm_smmu_master *master = state->master;
> > >  
> > > -	mutex_lock(&master->smmu->streams_mutex);
> > > -	if (state->vmaster != master->vmaster) {
> > > -		kfree(master->vmaster);
> > > -		master->vmaster = state->vmaster;
> > > -	}
> > > -	mutex_unlock(&master->smmu->streams_mutex);
> > > -}
> > > -
> > > -void arm_smmu_master_clear_vmaster(struct arm_smmu_master *master)
> > > -{
> > >  	mutex_lock(&master->smmu->streams_mutex);
> > >  	kfree(master->vmaster);
> > > -	master->vmaster = NULL;
> > > +	master->vmaster = state->vmaster;
> > >  	mutex_unlock(&master->smmu->streams_mutex);
> > >  }
> > 
> > I'd leave the clear_vmaster just for clarity. Commit should not be
> > unpaired with prepare in the other functions.
> > 
> > It looks fine with this on top too
> > 
> > Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
> 
> Ack. I added it back and a #ifdef to the vmaster: 
> 
> +void arm_smmu_master_clear_vmaster(struct arm_smmu_master *master)
> +{
> +       struct arm_smmu_attach_state state = { .master = master };
> +
> +       arm_smmu_attach_commit_vmaster(&state);
> +}
> [...]
> @@ -824,6 +829,9 @@ struct arm_smmu_master {
>         struct arm_smmu_device          *smmu;
>         struct device                   *dev;
>         struct arm_smmu_stream          *streams;
> +#ifdef CONFIG_ARM_SMMU_V3_IOMMUFD
> +       struct arm_smmu_vmaster         *vmaster; /* use smmu->streams_mutex */
> +#endif
>         /* Locked by the iommu core using the group mutex */
>         struct arm_smmu_ctx_desc_cfg    cd_table;
>         unsigned int                    num_streams;
> @@ -972,6 +980,9 @@ struct arm_smmu_attach_state {
>         bool disable_ats;
>         ioasid_t ssid;
>         /* Resulting state */
> +#ifdef CONFIG_ARM_SMMU_V3_IOMMUFD
> +       struct arm_smmu_vmaster *vmaster;
> +#endif
>         bool ats_enabled;
>  };
> 

Umm.. I'm not too sure how I feel about these #ifdefs _between_ a struct
definition. Given that currently, the arm_smmu_v3.h file doesn't have
such `#ifdef CONFIG`s between structs. I'd say, in case
CONFIG_ARM_SMMU_V3_IOMMUFD is turned off, we can simply leave the
vmaster ptr NULL?


-Praan



