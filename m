Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9261F20125F
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 01:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758590267; cv=none; b=rHKKMUkvZwbzT0E9g9IWXjJ57ZY+TfzR40ViaH3Yq/nxLTNrRbs4YTbGxjCY7E6TBNeIc5t7jE7DJNSliHbUPU65x9Mht6aK746spHHk4lpGH1KSgOn+ZGgRM8NB36PPNYev3itTiBaILcOr4rDG0OwqBLzrzRFeQNHqR5W6Bjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758590267; c=relaxed/simple;
	bh=1/e3AyiZPS/c0G1aMUyRNLYzo4gjhYckdUnHLFkO2mw=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=q/HZHcP5RE+3wf/VGADJ8RcY/O2BsV/mS03pbopG4Y7+TgJNvKIHcNsDsAVVsHPo2TpJzICmrL5FdVzWdDXZWZgT2MuK/Tuy9T4U6FTd6HONpIbCXhuhZEOjc2IyIfJkxBLeLbdWp2HaUJ5R59dlSAUcYps2TrfYmq9byWFflPc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HZ/Ze1g0; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HZ/Ze1g0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758590264;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ut+zQ+Ol2AC0M60Dd4+aidn6RjiEypu7DiFVdYxlNks=;
	b=HZ/Ze1g04iJ6NHJjPogQ6qRBFSJ5sdtQlutcyb4PZ0aYyD1A18ZTPlHsDhBbE6eiGRXa/A
	3Hil2yXiIexgkxmRgRp+4MobAGmG+nkz16gN1Cr7x0RkOLnZZZ8HtmrdtwkN7eIRumSu4/
	0yZ7Bwx0Cgrb69ohrJehS+Qo3phMlbc=
Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com
 [209.85.160.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-635-3SSawipzNDilJDIO4my_hw-1; Mon, 22 Sep 2025 21:17:40 -0400
X-MC-Unique: 3SSawipzNDilJDIO4my_hw-1
X-Mimecast-MFC-AGG-ID: 3SSawipzNDilJDIO4my_hw_1758590260
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-327dd4d160dso1569101fac.0
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 18:17:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758590260; x=1759195060;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ut+zQ+Ol2AC0M60Dd4+aidn6RjiEypu7DiFVdYxlNks=;
        b=UeNd+wgFbw2UaXEfV16JWNs+hLqApMLYImPyixLSzNOfDEtQXiTUeMk2ZGJJSuMa15
         HEMyPcBitDJviWPUkZnCH7FAn/6FeQOwlHWlwqmc7qSur+LY8LjEc1AtVbSaO2VK2eL5
         01fWaOSW00BQ8VRFPZEO1yB/rVgGyc2ztTiijSbYvJMtTJCEWDfVMZ9cJrRZjUxbYtVT
         pTUKK2yxY25kvgmht+aupjDKAMTHp07C/tujTX47/p7PWg+ygSV5txCJplBWhu9WlWxX
         T20sv7kaNymwPsQjA0eVOQagoSN7ppLmElFu/VCz6kD8/A2ILv2Nl/q/HI+qQLrNnoDc
         VSlw==
X-Forwarded-Encrypted: i=1; AJvYcCXRs5De+NU4xlhjroTWeqml5+d2kfiFpXooyoSkp0oSjRhRVrj3LJ9HcWDJJZ6T1sZK7hyPVXST@lists.linux.dev
X-Gm-Message-State: AOJu0YylmKmcSX7/X6GcMVY2nJpTP+VfvDrN+1WcgGQJG7i50CFNLXg4
	CYBEZrfNAF2/Xe/UKqkTdBnIGbpqx94ApeCemeVIHyvTJbZx618ym+O4l4xPzn8kBIFTxXdHG1Z
	V41uTAJdwTvUo38VSGagGqtUAwvo3mOrQV5WGzDrLLiit99wewroBEkrJSMI=
X-Gm-Gg: ASbGncuVFDQSDfT3FTBPattd605X7AlZXOTS5Y1UMPx31eDpJxoso5DS0rj/6bwNrqe
	yD/wMfc4fvyrQI8/YYHFhncddt+TgiFHRLO2acRMKDBRS2pQbN0B2aWOePo/8KdgNF1YuoAZGtW
	q7oMRa1m+fWxj+F5swLqv0mw3of3Kyaw7lf1MfbALpipmN6x6PYC5SdDIxnpLHhHXPJG46uFyPH
	UdxJ3+OxzTKUUZB9y/OCtS2i6oM/VxRYmdWeEJcwRrpOTOCS21AhyvURSF+syijJc+UxZ3jC5U1
	KZPVgqLu3NhgXIhG/ydKYOKhDOmh8flxNFDgSm0uB28=
X-Received: by 2002:a05:6808:308d:b0:43d:3c37:a342 with SMTP id 5614622812f47-43f2d12e4d7mr161936b6e.0.1758590260141;
        Mon, 22 Sep 2025 18:17:40 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFq9zHgq75BiE7ApXBV1Yytp3xnXFPeZg11oR2JKDr/lqHrXhwW6Di8HRCOFBIdLqEvOuYtIw==
X-Received: by 2002:a05:6808:308d:b0:43d:3c37:a342 with SMTP id 5614622812f47-43f2d12e4d7mr161918b6e.0.1758590259726;
        Mon, 22 Sep 2025 18:17:39 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-43e20b45410sm3700113b6e.12.2025.09.22.18.17.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 18:17:39 -0700 (PDT)
Date: Mon, 22 Sep 2025 19:17:37 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Donald Dutile <ddutile@redhat.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Will Deacon
 <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250922191737.0df0dbed.alex.williamson@redhat.com>
In-Reply-To: <1845b412-e96d-438a-8c05-680ef70c04e6@redhat.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132905.67d29191.alex.williamson@redhat.com>
	<20250702010407.GB1051729@nvidia.com>
	<c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
	<20250717202744.GA2250220@nvidia.com>
	<2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
	<20250718133259.GD2250220@nvidia.com>
	<20250922163200.14025a41.alex.williamson@redhat.com>
	<20250922231541.GF1391379@nvidia.com>
	<1845b412-e96d-438a-8c05-680ef70c04e6@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XO9CbK1Rypk_08PrpxHRVgX-iWM7Tt9hW9jg-ceTeKU_1758590260
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 20:51:31 -0400
Donald Dutile <ddutile@redhat.com> wrote:

> On 9/22/25 7:15 PM, Jason Gunthorpe wrote:
> > On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:  
> >> The ACS capability was only introduced in PCIe 2.0 and vendors have
> >> only become more diligent about implementing it as it's become
> >> important for device isolation and assignment.  
> PCIe-2.0 spec-wise, was released in 2007, 18 years ago.
> If hw is on a 3-yr lifecycle, that's 6 generations (7th including this year releases, assuming
> gen-1 was 2007); assuming a 5yr hw cycle, that's 4 generations of hardware.
> 
> Maybe a more interesting date is when DC servers implemented device-assignment/SRIOV
> in full-scale, and then, determine number of hw generations from that point on as
> 'learning -> devel-changing' years.
> I recall we had in in 'enterprise' customers in 2010, which only shaves one generation
> from above counts.

I don't see the relevance of these timelines.  A vendor with their head
in the sand still has their head in the sand regardless of time
passing.  Device assignment has a heavy non-enterprise user base.

> > IDK about this, I have very new systems and they still not have ACS
> > flags according to this interpretation.
> >   
> >> IMO, we can't assume anything at all about a multifunction device
> >> that does not implement ACS.  
> > 
> > Yeah this is all true.
> > 
> > But we are already assuming. Today we assume MFDs without caps must
> > have internal loopback in some cases, and then in other cases we
> > assume they don't.
> > 
> > I've sent and people have tested various different rules - please tell
> > me what you can live with.
> > 
> > Assuming the MFD does not have internal loopback, while not entirely
> > satisfactory, is the one that gives the least practical breakage.
> > 
> > I think it most accurately reflects the majority of real hardware out
> > there.
> > 
> > We can quirk to fix the remainder.
> > 
> > This is the best plan I've got..
> > 
> > Jason
> >   
> 
> +1 to Jason's conclusions.
> We should design the quirk hook to add ACS hooks for MFDs that do
> not adhere to the spec., which should be the minority, and that's what
> quirks are suppose to handle -- the odd cases.

Sorry, I can't agree.  I think we're conflating lack of a specific ACS
p2p capability to imply lack of internal p2p with lack of an ACS
capability at all.  I don't believe we can infer anything from the
latter.  Thanks,

Alex

