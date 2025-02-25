Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 375FB1A238E
	for <patches@lists.linux.dev>; Tue, 25 Feb 2025 16:47:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740502080; cv=none; b=Q9bE/bwZpuLjKXuuRcJsJ7zog1WvstYI5TIVJQcA0dHlbJ8b24qasAc9jYnJGLxrLGFFo7E1tUEmvnNUS/uf5MqQwqzAYdDZdY3e7gDR6R1RczMHCALcQ3xZiPlA6C6Pn64+95tikgxpsrXPxPuJ4zDvieL7qUN2XZvTFvsaBJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740502080; c=relaxed/simple;
	bh=6iPgSZh+iO33nHQzseddwrKUrNhaFUNY8ua+PPksf0A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DhoHKXlN4Gr0WhPzvGEGMgSXbbYz2Q3MZJ234h8Ajji8KxpYMkQDm4Egtflzx+ns7x1QYMht3X6epB9elGTYA7yYcsgmdcGTa7U3LrYrc3gtoxgGsl5eH3a/RTKwDWAQ5UMs4Au7eGgxLkm3OJujsNnkSWFCF64JwXJKXzs01QE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mw8O0HKE; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mw8O0HKE"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-220e0575f5bso216665ad.0
        for <patches@lists.linux.dev>; Tue, 25 Feb 2025 08:47:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1740502078; x=1741106878; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=6TXPG1g3tHBq7F0JV2QmBmMxnoyZNN73F2qMEQ/D5jc=;
        b=mw8O0HKEMX6YHbpThlLM4B6yNPpkW0gkHJTEj8Nl1TtaNvOqk2ZHn5dP5L/zk4TCa9
         /AAQwlVTJTFBqjP1EQsDQSZwlpdc2iBZ4KIundajGYQ9KnebMYoJL/AemFvEVcSwyGa6
         qymr7yriJ+hUQNmxpfD0BqhFKdu85w0muEsmP+geUGdCvFp+oQwjw0iM0HKR1v8ipYTP
         8YygV/TbTUEgYGLygy+P8+RzGp9Wb7Keu9Dk6lRB0s7rO/QGKbh+JUQBJg3F6jzbz1nV
         J1yhN6QTVFMDLcE43nwkDiOjh7yp/CcLaLSvR+O81DBThPLU2NK2MGzUFm12EM4DOLJB
         6Yaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740502078; x=1741106878;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6TXPG1g3tHBq7F0JV2QmBmMxnoyZNN73F2qMEQ/D5jc=;
        b=FR68BREZS3VPTFfk8B3T2+SYmfUsMgvPQzGWRNWP89q9IhyeG6zU30UcDpi/eOOqlB
         zjO2fv/sbkgolxnCwwy/uCOWkwUMXWFcddpRgjNBRZRBJVimjsks+nvLVFA7UqZJByaq
         GjZTOmk6Vm9G2E9VbPgrURM+xU2miM+IhHPrOo7u6AL0aryY1u1WCt55hvFnn4rYXq00
         fqq6Jc8lNIn2nehblwLrW0kZHlI+2a4c43khQMtb1wSWlUjRBEy4L6lQJP4r7VxnOb+5
         onSX0hANzJOnYonwyYi+3jr6/c4pwDraEiScFh29jgzI+ZoPvxZMi2joC8PtRuK4I47m
         +sOw==
X-Forwarded-Encrypted: i=1; AJvYcCUr/i1JdR5W43yFoHRGATZvgn3S9QRFbbnb5G9/siKa737Jmbq6Xgc5Z+5MuPFC8HxjAF1Os5l+@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0+TpvepF6RjYsDKykwxsmbp6HkYOZC9jyRI/cTTLCAtM3i7r1
	x7l0Kn90BuLbDRqNXO40CXSgS9Qh1seNBCS+BxsvDwPEcoSo2pVcspmtKGc4Hg==
X-Gm-Gg: ASbGncujjs1ziVMw9aF/JMcAIVRzrV5o5pZONosV4MhjO4LfIyqBZQ9wmDIrJApD3Mu
	o9wvOb2avLeCJFUujUSq1sJqsx7Kizf2hHaUoA6oZFNjz03gLPTbOcJ/mtjUddpy0i70WGQSvpE
	3emWswjo0UtxIKLrCYV7GLwqhoe2X1C8VsrT+w+/geUcOhd98iF7www9MF5wG8lz5H2M7rx5Fb6
	eQXAJZM6HV536GYA2feaNXuLIriwTbOA0oEwgWXCNjCcAG1dHwVHdzDvXjLCzcE2SZW4wwpeLvt
	KPgfx86uUgZLZ+/2xMh9uEbUazS4pWyzPwPFuT/ZZUqRjgte5inz3RXJgsCk2gA=
X-Google-Smtp-Source: AGHT+IFvXw+OvC4N/IKxwnR5Ayk0dG/Aagp8HSvp5fGkA6z7Brsy0CGy7v+QNECgYTSPzGrZqtSVWw==
X-Received: by 2002:a17:902:ce91:b0:21f:465d:c588 with SMTP id d9443c01a7336-22307a60c47mr3818095ad.14.1740502078043;
        Tue, 25 Feb 2025 08:47:58 -0800 (PST)
Received: from google.com (169.224.198.35.bc.googleusercontent.com. [35.198.224.169])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2230a095f02sm16558235ad.152.2025.02.25.08.47.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Feb 2025 08:47:57 -0800 (PST)
Date: Tue, 25 Feb 2025 16:47:47 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	joro@8bytes.org, suravee.suthikulpanit@amd.com,
	robin.murphy@arm.com, dwmw2@infradead.org, baolu.lu@linux.intel.com,
	shuah@kernel.org, linux-kernel@vger.kernel.org,
	iommu@lists.linux.dev, linux-arm-kernel@lists.infradead.org,
	linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org,
	eric.auger@redhat.com, jean-philippe@linaro.org, mdf@kernel.org,
	mshavit@google.com, shameerali.kolothum.thodi@huawei.com,
	smostafa@google.com, ddutile@redhat.com, yi.l.liu@intel.com,
	patches@lists.linux.dev
Subject: Re: [PATCH v7 13/14] iommu/arm-smmu-v3: Report events that belong to
 devices attached to vIOMMU
Message-ID: <Z730M3XptvDRObBp@google.com>
References: <cover.1740238876.git.nicolinc@nvidia.com>
 <b1930038cf828dc13c080e2b46b3003a8c98ef24.1740238876.git.nicolinc@nvidia.com>
 <Z7zmErar4YvQSSxw@google.com>
 <Z7zrHn3tPBD5chv1@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Z7zrHn3tPBD5chv1@Asurada-Nvidia>

On Mon, Feb 24, 2025 at 01:56:46PM -0800, Nicolin Chen wrote:
> On Mon, Feb 24, 2025 at 09:35:14PM +0000, Pranjal Shrivastava wrote:
> > On Sat, Feb 22, 2025 at 07:54:10AM -0800, Nicolin Chen wrote:
> > > +int arm_vmaster_report_event(struct arm_smmu_vmaster *vmaster, u64 *evt)
> > > +{
> > > +	struct iommu_vevent_arm_smmuv3 vevt;
> > > +	int i;
> > > +
> > > +	lockdep_assert_held(&vmaster->vsmmu->smmu->streams_mutex);
> > > +
> > > +	vevt.evt[0] = cpu_to_le64((evt[0] & ~EVTQ_0_SID) |
> > > +				  FIELD_PREP(EVTQ_0_SID, vmaster->vsid));
> > > +	for (i = 1; i < EVTQ_ENT_DWORDS; i++)
> > > +		vevt.evt[i] = cpu_to_le64(evt[i]);
> > 
> > Just thinking out loud here:
> > I understand the goal here is to "emulate" an IOMMU. But I'm just
> > wondering if we could report struct events instead of the raw event?
> > 
> > For example, can't we have something like arm_smmu_event here with the
> > sid changed to vsid? 
> > 
> > Are we taking the raw event since we want to keep the `u64 event_data[]`
> > field within `struct iommufd_vevent` generic to all architectures?
> 
> The ABIs for vSMMU are defined in the HW languange, e.g. cmd, ste.
> Thus, here evt in raw too.
> 

Ack. Makes sense.

> > > -	ret = iommu_report_device_fault(master->dev, &fault_evt);
> > > +	if (event->stall) {
> > > +		ret = iommu_report_device_fault(master->dev, &fault_evt);
> > > +	} else {
> > > +		if (master->vmaster && !event->s2)
> > > +			ret = arm_vmaster_report_event(master->vmaster, evt);
> > > +		else
> > > +			ret = -EFAULT; /* Unhandled events should be pinned */
> > > +	}
> > 
> > Nit:
> > I don't see the `arm_smmu_handle_event` being called elsewhere, is there
> > a reason to return -EFAULT instead of -EOPNOTSUPP here?
> > 
> > I think the current behavior here is to return -EOPNOTSUPP if (!event->stall).
> > Whereas, what we're doing here is:
> > 	if (event->stall) {
> > 	...
> > 	/* do legacy stuff */
> > 	...
> > 	}
> > 
> > 	else {
> > 		if (master->vmaster && !event->s2)
> > 			arm_vmaster_report_event(vmaster, evt);
> > 		else
> > 			ret = -EFAULT
> > 	}
> > 
> > 	mutex_unlock(&smmu->streams_mutex);
> > 	return ret;
> > 
> > Thus, we end up returning -EFAULT instead of -EOPNOTSUPP in case
> > event->stall == false. I agree that we aren't really checking the return
> > value in the evtq_thread handler, but I'm wondering if we should ensure
> > that we end up retaining the same behaviour as we have right now?
> 
> Oh, it looks like -EOPNOTSUPP should be returned here. Will fix.
> 

With the fix to return `-EOPNOTSUPP`:

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
