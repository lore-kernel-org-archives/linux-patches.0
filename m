Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F388E15ECCC
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 02:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758595835; cv=none; b=L0kxts4VG4CQqzaUlInRmiiEfwvrhM1iOmnSsdQx4HuSGoeP/ZfOnSKjzuWQ8NcbNawJMt19V1lXhl0yH69966qcSlrYKWlflDGnBeoY6wHmTHDc4EORhYmeMaUUOe5jVn++Ga0MQ2d5p7nK6SEwjcQ8+E92xzKcfmL0hZ/XEe8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758595835; c=relaxed/simple;
	bh=B5UZq78SmLPBLQDonRYWTTxpdHcXfRxob/mh8nqKjbE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bROHd+SjFiiGDivFQi2zmcV3hNWBIKCLC168ALNBCCYPo42QFvSmcL71wYjPNk2brD4IFv0G3yra5FZ5BONJpMu9uE8wkE9wt05PLxDKOSSM7bQEpuUBARxlPAabFn4KxekjM8Apl2ZDHZ+Ufmt47Xn2ZgSfqo/EFbnmcUTvqxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ChbSJ9sF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ChbSJ9sF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758595832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4udPH4/1Y13/H09/59iHoIfRmw8jUmZ5GDbzFDDZnRs=;
	b=ChbSJ9sF+HwlVoZMGImXtdxuK2N2VvTLcbg1x87mrT1+tr+1wltYQXLM5O1owei/LBCHUV
	LJRaVbRie2Tg3WE8Cd/TD1K20ZqyDNMt/odcQKGdqi0AmloI65edSRQRb3b0hfBLIppQU7
	KruJADcLKeJM0tfw4wzPkui+QYFl1Z0=
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com
 [209.85.166.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-184-Be8Tse0GPRyVUvXvJ0Kvnw-1; Mon, 22 Sep 2025 22:50:31 -0400
X-MC-Unique: Be8Tse0GPRyVUvXvJ0Kvnw-1
X-Mimecast-MFC-AGG-ID: Be8Tse0GPRyVUvXvJ0Kvnw_1758595831
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-42571642af9so6647505ab.0
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 19:50:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758595830; x=1759200630;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4udPH4/1Y13/H09/59iHoIfRmw8jUmZ5GDbzFDDZnRs=;
        b=H7+DG4sKvk/Xnl5cA45ghS1hFUDN84Eq1d1EOKn6NzP+FkfIs+j+f8OwVVjk7NGTZ+
         04FwbPHVwo/8qLpAb9MGYhToHmxNwPtLU8IRTS3z5MvrR/pfrwWslUa4w/n4yD6Y/E69
         dgBw57HoUWQra7r/GPlG6uk/EkVSfxI/gFM7ElQRV72bz1BFp6SoD6HjS8Y1sFKXwi2V
         i0yiRs+vdolW+kQ6MW0IORToF/1AZcOg49H8Pe5BdLNyvinhSpWNMYDyRzVKGiTjqD4S
         Uu49qGpedIcrvV6j7ZkcQEmFGGjS6kTttnvvSSXHbmSMNstFMIFPZKdyx1QJ7suis2B9
         kfOQ==
X-Forwarded-Encrypted: i=1; AJvYcCVHdB0E7ZzXKnLVycM53pOahFGI7c4LL79tWrO8gOYq0BSZORL3FLTkgTBPBVg16K1NhCwzydUn@lists.linux.dev
X-Gm-Message-State: AOJu0YxcnN8OOjAgLQx9J0FJrWpZW7WZ64SS5aKVeL1AQKfv9Wq3UdCu
	EhadPF5VemBX6N33G10JHZHPPMCgmNy+VobT6xHF+B34qVWObnoRO2S69jIoVz2KF/taadvWejG
	SQ7cwk3HZ0/g6JQjEKSdkgUh7Ar4rWRZI+psWMbkyJUPWuG8D2HeZ9UXrLhI=
X-Gm-Gg: ASbGnctenaH8T68SFwLWU9TqKUjqb/V6qlW+tIZPaZx2huEyjH0lPeM3fMiEjazGGZx
	bCt7WWYMnGJobyX+LuhaAncT14mRmlrHPocEDy8irUogQpXZtbb5PCucUEGUnlo9tGMvjKGI8yS
	I83zv2GbIdlEnqpI5/dncGPW2/sdD6I6cMO099KXYCn0L2in91Beus4Sw/YyCfCkZSp8onSA6Ij
	TGEvC2sLj5fY/B4ROKMS2kkvOa0sIEGYDHqJoXgM/ITBmRf1kDxpqNXibw4p8x/5VY6xz3AWk4h
	c4l8yBs4A7+cgUfcpAPKtrV7WJySsxAf/GgsFNXqvr0=
X-Received: by 2002:a05:6e02:164d:b0:424:2357:d5e with SMTP id e9e14a558f8ab-42581ea6a8emr6488165ab.4.1758595830491;
        Mon, 22 Sep 2025 19:50:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHoQrJ13c3z3iAGYF/0szcdLw1mCi6EExZIWeSbCSUNM58sLO+eFzEGXdLrV3LqCv/AG2p4nA==
X-Received: by 2002:a05:6e02:164d:b0:424:2357:d5e with SMTP id e9e14a558f8ab-42581ea6a8emr6488055ab.4.1758595829980;
        Mon, 22 Sep 2025 19:50:29 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d401eea19sm6445439173.34.2025.09.22.19.50.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 19:50:29 -0700 (PDT)
Date: Mon, 22 Sep 2025 20:50:27 -0600
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
Message-ID: <20250922205027.229614fa.alex.williamson@redhat.com>
In-Reply-To: <066e288e-8421-4daf-ae62-f24e54f8be68@redhat.com>
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
	<20250922191029.7a000d64.alex.williamson@redhat.com>
	<066e288e-8421-4daf-ae62-f24e54f8be68@redhat.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: N-3IWp9xhX9YvYr7N0jJo8KPNlLY7xP6QfFBOPzgKpM_1758595831
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 22:26:26 -0400
Donald Dutile <ddutile@redhat.com> wrote:

> On 9/22/25 9:10 PM, Alex Williamson wrote:
> > On Mon, 22 Sep 2025 20:15:41 -0300
> > Jason Gunthorpe <jgg@nvidia.com> wrote:
> >   
> >> On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:  
> >>> The ACS capability was only introduced in PCIe 2.0 and vendors have
> >>> only become more diligent about implementing it as it's become
> >>> important for device isolation and assignment.  
> >>
> >> IDK about this, I have very new systems and they still not have ACS
> >> flags according to this interpretation.  
> > 
> > But how can we assume that lack of a non-required capability means
> > anything at all??
> >     
> ok, I'll bite on the the dumb answer...
> lots of non-support is represented by lack of a control structure.
> ... should we assume there are hidden VFs b/c there is a lack of a vf cap structure?
> ... <insert your favorite dumb answer here> :-)

This is not how an additive specification works.  We start with a base
specification.  We add capabilities to describe features of the device.
If a device doesn't support an SR-IOV capability, it doesn't support
VFs.  But likewise we cannot add an optional capability and
retroactively declare that anything that does not support this
capability must have some specific behavior.

That's not what the spec is doing.  We're misinterpreting it.  The
sections of the spec you're quoting are saying that if a MFD function
supports ACS it must support this specific p2p set of capability and
control bits unless the device does not support internal p2p.

> I can certainly see why a hw vendor would -not- put a control structure
> into a piece of hw that is not needed, as the spec states.
> For every piece of hw one creates, one has to invest resources to verify
> it is working correctly, and if verification is done correctly, verify it
> doesn't cause unexpected errors.  I've seen this resource req back in
> my HDL days (developers design w/HDL; hw verification engineers are the
> QE equivalent to sw, verifying the hw does and does not do what it is spec'd).

As previously noted, an "empty" ACS capability serves this purpose with
minimal verification.

> Penalizing a hw vendor for following the spec, and saving resources,
> seems wrong to me, to require them to quirk their spec-correct device.

IMO, we're clearly conflating the implementation of the ACS p2p
capability bits with the implementation of the ACS extended capability
itself.

> I suspect section 6.12.1.2 was written by hw vendors, looking to reduce
> their hw design & verification efforts.  If written by sw vendors, it
> would have likely required 'empty ACS' structs as you have mentioned in other thread(s).

We've had NIC vendors implement an empty ACS capability to convey the
fact that the device does not support internal p2p.  There is precedent
for the interpretation I'm describing.

> >>> IMO, we can't assume anything at all about a multifunction device
> >>> that does not implement ACS.  
> >>
> >> Yeah this is all true.
> >>
> >> But we are already assuming. Today we assume MFDs without caps must
> >> have internal loopback in some cases, and then in other cases we
> >> assume they don't.  
> > 
> > Where?  Is this in reference to our handling of multi-function
> > endpoints vs whether downstream switch ports are represented as
> > multi-function vs multi-slot?
> > 
> > I believe we consider multifunction endpoints and root ports to lack
> > isolation if they do not expose an ACS capability and an "empty" ACS
> > capability on a multifunction endpoint is sufficient to declare that
> > the device does not support internal p2p.  Everything else is quirks.
> >   
> >> I've sent and people have tested various different rules - please tell
> >> me what you can live with.  
> > 
> > I think this interpretation that lack of an ACS capability implies
> > anything is wrong.  Lack of a specific p2p capability within an ACS
> > capability does imply lack of p2p support.
> >   
> >> Assuming the MFD does not have internal loopback, while not entirely
> >> satisfactory, is the one that gives the least practical breakage.  
> > 
> > Seems like it's fixing one gap and opening another.  I don't see that we
> > can implement ingress and egress isolation without breakage.  We may
> > need an opt-in to continue egress only isolation.
> >   
> >> I think it most accurately reflects the majority of real hardware out
> >> there.
> >>
> >> We can quirk to fix the remainder.
> >>
> >> This is the best plan I've got..  
> > 
> > And hardware vendors are going to volunteer that they lack p2p
> > isolation and we need to add a quirk to reduce the isolation... the
> > dynamics are not in our favor.  Hardware vendors have no incentive to
> > do the right thing.  Thanks,
> >   
> I gave an example above why hw vendors have every incentive not to
> add an ACS structure if they don't need it. Not doing so, when they
> can do p2p, is a clear PCIe spec violation.  Punishing the correct
> implementations for the incorrect ones is not appropriate, and is
> further incentive to continue to be incorrect.
> 
> Don't we have the hooks with kernel cmdline disable_acs_redir &
> config_acs params to solve the insecure cases that may (would) be
> found, so breaking the isolation is relatively easy to fix vs adding
> quirks as is done today for proper spec interpretation?

Are we going to expect users to opt-in to securing their system?  This
is just doubling down on an incorrect spec interpretation.  Lack of an
optional extended capability cannot convey anything about the p2p
capabilities of the device <full stop>.  Thanks,

Alex

