Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 644262FE32D
	for <patches@lists.linux.dev>; Tue,  1 Jul 2025 20:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751402622; cv=none; b=cZjyKyHzCA8MFEsYRzYKXBayPVYZk8a6odj7XKU9+XZemSqG6oU2DtR4RzgSwG9EEj4F6IlbzKNwlkVhVtxLwjT1sOol0IRC+fhGC8TDOnPSdIqBzYefWyX/49RtEn30XGOKQty98aoQfu3QkBZVLfTsA9pAkyI4oWqdXTGNzSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751402622; c=relaxed/simple;
	bh=t6w6HZ3d39NHLiwdzdaqKTFFJH+mBfnQBGoBzloEzXs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a4iaRgxentjFZqiSeH2DC47Ul4LPHfVQUT/3BRdiEZnsQqk4TSSQMvFUFq2ARLhTGSdeBIEKFEIsEPjLjEu5sgl4mSy6/EaN29xk1BnpPUm+fDZFVXiJ0PlVIx0uk7FRWsG7DJ9oaCHOVPR4qO4ThFrFj0SV7y1qe+/q93O/W5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o8XIm6An; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o8XIm6An"
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-235e389599fso326025ad.0
        for <patches@lists.linux.dev>; Tue, 01 Jul 2025 13:43:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1751402619; x=1752007419; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Gp4ARI8yx8eK5+ZYKJ4V0qAwq8T5VmfMZEWG24JsVtU=;
        b=o8XIm6AneMQ6KWGywadin08eKeSZhEt8Nb6TTPmb53MYuOwk3u9E2uPYDC0EczVhaR
         aRqg9PU4UBAI4umlVBju+MBzW4FBGXjljqy6Th3hMpMVrS0ybEvyxwY3tXDNGRhMaJHj
         5e34vdNh2S+Nsf11EASLhnKFzFhiaIz8D+Eco3BKauoTmhtykIEdavfS6qk67ZUa4Q8a
         4jzZSal0xeK/uWbnTibJmwvFDI7cDOjdzUzaJ7T+g/GIPT66qZuc1NRQoQ14klSe6Nso
         +UahBRH61wMX6MTXzcqrwPtRO6db4dK8PiRqh9wrLi27zHnZsdo6E9+ojR8yXqT/zBVL
         vqcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751402619; x=1752007419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Gp4ARI8yx8eK5+ZYKJ4V0qAwq8T5VmfMZEWG24JsVtU=;
        b=tqyXbB3rI3cb37tGOFqE8cqqRXpe/LEDD8hVDOICRNQOA/P8GyUbKeSlK0R0IeT+gV
         bdJHBJqP7S3qkmngiqA3lH+EXiyYOYDFAO/BrXgeSWhg1dKGSZqivIY9Xgq8lNj3L1Wb
         bbUB7PEEqDKb3/UU3/lPXR2ey1H8rvQKuYezw1iEe5VyfQYXi/fL62jW1yGXyAYLs2Dc
         WBO222AoTrHUPHtnPoEOUb64varDL16ngEaByNpW51M5n/IFiG0lv+FTKLqKbTB22snw
         i3JuaPJbMOBD5nv1SF3XJGgLvcdfW7tiSCPxpvN6m9ozijE+hA8P4+PNq2U67SzfAnv8
         JG/w==
X-Forwarded-Encrypted: i=1; AJvYcCVnzOGMs8fIWXcco1aNLPGAxf5ziducdwONmbXgGqD5VYBJfJQfcyQqxSSXLWWo1NSMIq1vr1T8@lists.linux.dev
X-Gm-Message-State: AOJu0YxlQuqzv8nadfN5p2Qyp7iOxXfwbW5THDfZkEfCZ/hF6QVbnpAv
	oqPOK8RuRpKeqmEGFnBrMDLIAEmAbb/3z75ul97eXYShRNj+pEDwnt37sadtM4NaWw==
X-Gm-Gg: ASbGncvwELhSfPXAq9dtqRUzYve9A/Gn1A6j2LqxkZX6e6l/rTXlnRpmS76pTo3FmGj
	yVq/HZJ4obHOKICPzmipLeuxYmh3l8jlIVpqtJxyeKszNoF/Th+0duEFoskKyxCKEBoHkb3uqQH
	G8/C5qIip8vupiyf33mkOGLbKnMpIlWvIHj3eROP8pIRvl/z2MAlTE+cFa37CUH0tH+Pkw/+eOB
	/bTIN3sA86mc6X+SBUzbMB4w9cN0pFO2dG4lSToeT4DUoBKWaK/o3ABKTpEK9yZRuWnGE75vKJM
	B/t6en1v4S47i5aDkCi/+L0TSynn4AdFIwsQeo9qV7q5Z5q+d4PSfog61S37A2On+T0osMsgUUK
	5X7zZcQIzLlGbD00LZEm8
X-Google-Smtp-Source: AGHT+IEgQNF03gTMPFMuZ5i4oqeFgT9l/mftJxCXd5iV8tzIDEl3pR9lFMVTJeBzdy2r/6gfVZ+O7w==
X-Received: by 2002:a17:902:e54e:b0:231:d0ef:e8ff with SMTP id d9443c01a7336-23c5ff29f9dmr4133295ad.8.1751402619181;
        Tue, 01 Jul 2025 13:43:39 -0700 (PDT)
Received: from google.com (232.98.126.34.bc.googleusercontent.com. [34.126.98.232])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af541bdeasm12778586b3a.53.2025.07.01.13.43.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Jul 2025 13:43:38 -0700 (PDT)
Date: Tue, 1 Jul 2025 20:43:30 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com,
	dwmw2@infradead.org, baolu.lu@linux.intel.com
Subject: Re: [PATCH v7 27/28] iommu/tegra241-cmdqv: Add user-space use support
Message-ID: <aGRIctg4T6cQECx4@google.com>
References: <cover.1750966133.git.nicolinc@nvidia.com>
 <539ee2ec112162abdba511574e2205a77b425059.1750966133.git.nicolinc@nvidia.com>
 <aGQGm1-i4M75b9Qp@google.com>
 <aGQ6KCI9OZEwHdxS@Asurada-Nvidia>
 <aGQ_F7Qx3scbbA-J@google.com>
 <aGRDtYRXFLoT+PrI@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aGRDtYRXFLoT+PrI@Asurada-Nvidia>

On Tue, Jul 01, 2025 at 01:23:17PM -0700, Nicolin Chen wrote:
> On Tue, Jul 01, 2025 at 08:03:35PM +0000, Pranjal Shrivastava wrote:
> > On Tue, Jul 01, 2025 at 12:42:32PM -0700, Nicolin Chen wrote:
> > > On Tue, Jul 01, 2025 at 04:02:35PM +0000, Pranjal Shrivastava wrote:
> > > > On Thu, Jun 26, 2025 at 12:34:58PM -0700, Nicolin Chen wrote:
> > > > > +/**
> > > > > + * struct tegra241_vintf_sid - Virtual Interface Stream ID Replacement
> > > > > + * @core: Embedded iommufd_vdevice structure, holding virtual Stream ID
> > > > > + * @vintf: Parent VINTF pointer
> > > > > + * @sid: Physical Stream ID
> > > > > + * @idx: Replacement index in the VINTF
> > > > > + */
> > > > > +struct tegra241_vintf_sid {
> > > > > +	struct iommufd_vdevice core;
> > > > > +	struct tegra241_vintf *vintf;
> > > > > +	u32 sid;
> > > > > +	u8 idx;
> > > > >  };
> > > > 
> > > > AFAIU, This seems to be a handle for sid -> vintf mapping.. it yes, then
> > > > I'm not sure if "Virtual Interface Stream ID Replacement" clarifies that?
> > > 
> > > No. It's for vSID to pSID mappings. I had it explained in commit log:
> > > 
> > 
> > I get that, it's for vSID -> pSID mapping which also "happens to" point
> > to the vintf.. all I wanted to say was that the description is unclear..
> > We could've described it as "Vintf SID map" or something, but I guess
> > it's fine the way it is too.. your call.
> 
> The "replace" word is borrowed from the "SID_REPLACE" HW register.
> 
> But I think it's okay to call it just "mapping", if that makes it
> clearer.
> 

Anything works. Maybe let it be as is.

> > > > > +static struct iommufd_viommu_ops tegra241_cmdqv_viommu_ops = {
> > > > > +	.destroy = tegra241_cmdqv_destroy_vintf_user,
> > > > > +	.alloc_domain_nested = arm_vsmmu_alloc_domain_nested,
> > > > > +	.cache_invalidate = arm_vsmmu_cache_invalidate,
> > > > 
> > > > I see that we currently use the main cmdq to issue these cache
> > > > invalidations (there's a FIXME in arm_vsmmu_cache_invalidate). I was
> > > > hoping for this series to change that but I'm assuming there's another
> > > > series coming for that?
> > > > 
> > > > Meanwhile, I guess it'd be good to call that out for folks who have
> > > > Grace and start trying out this feature.. I'm assuming they won't see
> > > > as much perf improvement with this series alone since we're still using
> > > > the main CMDQ in the upstream code?
> > > 
> > > VCMDQ only accelerates invalidation commands.
> > > 
> > 
> > I get that.. but I see we're using `arm_vsmmu_cache_invalidate` here
> > from arm-smmu-v3-iommufd.c which seems to issue all commands to
> > smmu->cmdq as of now (the code has a FIXME as well), per the code:
> > 
> > 	/* FIXME always uses the main cmdq rather than trying to group by type */
> >         ret = arm_smmu_cmdq_issue_cmdlist(smmu, &smmu->cmdq, last->cmd,
> > 					  cur - last, true);
> > 
> > I was hoping this FIXME to be addressed in this series..
> 
> Oh, that's not related.
> 
> The main goal of this series is to route all invalidation commands
> to the VCMDQ HW. And this is where Grace users can see perf gains
> mentioned in the cover letter or commit log, from eliminating the
> VM Exits at those most frequently used commands.
> 
> Any non-invalidation commands will just reuse what we have with the
> standard SMMU nesting. And even if we did something to that FIXME,
> there is no significant perf gain as it's going down the trapping
> pathway, i.e. the VM Exits are always there.
> 
> > > That is for non-invalidation commands that VCMDQ doesn't support,
> > > so they still have to go in the standard nesting pathway.
> > > 
> > > Let's add a line:
> > > 	/* for non-invalidation commands use */
> > 
> > Umm.. I was talking about the cache_invalidate op? I think there's some
> > misunderstanding here? What am I missing?
> 
> That line is exactly for cache_invalidate. All the non-invalidation
> commands will be sent to he arm_vsmmu_cache_invalidate() by VMM, as
> it means.
> 
> Or perhaps calling them "non-accelerated commands" would be nicer.

Uhh okay, so there'll be a separate driver in the VM issuing invalidation
commands directly to the CMDQV thus we don't see any of it's part here?

AND for non-invalidation commands, we trap out and the VMM ends up
calling the `cache_invalidate` op of the viommu?

Is that understanding correct?

> 
> Thanks
> Nicolin

Thanks
Praan
