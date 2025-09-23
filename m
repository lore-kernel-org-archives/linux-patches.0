Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10AF1DDA09
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 01:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758589840; cv=none; b=fHd5no7ypWBK83RpHB+3/rf4hRnR3LbZzayURx7Q+O0rPAhaTWt/8jJvR7S6fTZIwQCIqXtQ359Q/w4UKPnWWqT8fnPh+FOBFpViSC2+gvsx7hC1jsZ1wp9K9tYRJSadIJOY3Nx0Z5lT6W35M7gnrXA+Q6+AwHBaDYOdggaN4vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758589840; c=relaxed/simple;
	bh=9rAyCAp0JWycHOc8mJx4dBKJhDcA9CLu0OXu8TULZ0w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z/Ogc+hBsFAYn08ksJchikOrrSwWcv3hglTJgXUWQyqJRkaSXCtLoWikIz3nJ/kRlk6rKtBwojni9bDPkklCdTLbwS50+jM+9V0FZA7xcAVDr4a9aK5/D3qpf8/gaHNHpOTeTp+Ww49BQIMbn8eaPJrMVpUURGIV18oCQah2yyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Eh9Jo5bU; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Eh9Jo5bU"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758589837;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MMdCl+IiTEZQdjIFjdJwfIpOIRvy1QynTRS3PoYFQjM=;
	b=Eh9Jo5bU2j4bVFxCZcw/+TtxkejqlVfGi2T/E/u0pgbFiZAGHImKWTn/S6vuPp+NNkXgj7
	JaikKhguCTVZ+ApiIz6Gk+Hiq8ktELlqvpuCYiw2H0aj7gHtHEo8bnm/Q4VSSicLeDnLWD
	H4t0NXx1sBaJ/EzNHI93xS8sb7iRoA4=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-Zs-2KFqeM6WlcLPVG4yFIQ-1; Mon, 22 Sep 2025 21:10:32 -0400
X-MC-Unique: Zs-2KFqeM6WlcLPVG4yFIQ-1
X-Mimecast-MFC-AGG-ID: Zs-2KFqeM6WlcLPVG4yFIQ_1758589832
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42571642af9so6490565ab.0
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 18:10:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758589832; x=1759194632;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MMdCl+IiTEZQdjIFjdJwfIpOIRvy1QynTRS3PoYFQjM=;
        b=qiOwsCtQgU0YgK7PlrFh8nEOVE+8peh7K7I+1U2kJk+38mY2gZ2UZfZmGTjAmRr42/
         h4k1KmAtRLb5SCJgr+20wtf/OJ3zqxHdMA4zSGb43sAGGyjllU9OXsN0xDrosRVhtUsc
         2d3bci3OmuWBiiyQF/bQPqO2Wxr/P0KQe4Yi8DCnTQT8xokyN+p4KumAPP95egCForsC
         1ukjhbzbdfRD06Ln//M8Hk4XfljvRnnuvJJNIF9EWC2QcO5mKIjnC1xl39qDlHreZO3+
         QE+KbwBAo+n+eiC6lp+jcMbQvRQqo7DJCCzURcubJLBars87tee7gTZi5/8yTQn0yBfr
         a4NA==
X-Forwarded-Encrypted: i=1; AJvYcCWByaumAqQ2T9YTL0/SKSCC8WTLNrjq/BbnFmPhH4S4F9X3ivqdMtTUWl8/PjVZnY1B3RSl2iWt@lists.linux.dev
X-Gm-Message-State: AOJu0YxD6Eui8cEhmEGjGnKK/xjNkzcHdNpretQJXOHoxbnXgrIZfOh9
	EhtpXYeKSiVJvgJ33WxK7rtJArVC0Eaiv8snrZgpPIFyBdQDMylLXyfjX1m1pgkW3/W2JWNBjHK
	Va4HeiqT1IRL84HrUBLXIeNr4Xx/iah/zsCT8tHkxKV5q6y7c464lArR6gqo=
X-Gm-Gg: ASbGncuzW03YbelD2+ley0awZO17CaSSKXcmDtaqQQ2ZWyOS1Cyr64lQyKlbjxnDPRn
	cvTaj8diMHCUrrAJFLG2BJmwNDR0JLSsD6dK9sch5rqn5J7pIV3SFBlc/rYelKaa2TMjP230FVj
	A4FpeAOayplbgavioiRrHnq0pxFysJ6AjW3UbVQXthwcp98KlKrPr1JK3/MDuZ/0UinZaRAZaDr
	Zh3BrSpgUFXW/8j6l/lij6O8ri2GUQOKb9OkbcFevHDhvC+FUbPQUIC18HnQXUp40kZSrWODWWD
	KAzTFN0VvWXCvd5gGZ5Jw/BREGvR6T5B7enzRe/k6AQ=
X-Received: by 2002:a05:6e02:1062:b0:425:84b6:a7de with SMTP id e9e14a558f8ab-42584b6aa30mr980565ab.0.1758589831771;
        Mon, 22 Sep 2025 18:10:31 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEjujwsV4+PvdiPV9xPzzt8xVXDXwwoMNeGQllr4EYycFAIvL2pedut8GhHoH/nZ1k7CtN0Ig==
X-Received: by 2002:a05:6e02:1062:b0:425:84b6:a7de with SMTP id e9e14a558f8ab-42584b6aa30mr980355ab.0.1758589831423;
        Mon, 22 Sep 2025 18:10:31 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-56221c6f374sm865008173.55.2025.09.22.18.10.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 18:10:30 -0700 (PDT)
Date: Mon, 22 Sep 2025 19:10:29 -0600
From: Alex Williamson <alex.williamson@redhat.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Donald Dutile <ddutile@redhat.com>, Bjorn Helgaas <bhelgaas@google.com>,
 iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
 linux-pci@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>, Will Deacon
 <will@kernel.org>, Lu Baolu <baolu.lu@linux.intel.com>,
 galshalom@nvidia.com, Joerg Roedel <jroedel@suse.de>, Kevin Tian
 <kevin.tian@intel.com>, kvm@vger.kernel.org, maorg@nvidia.com,
 patches@lists.linux.dev, tdave@nvidia.com, Tony Zhu <tony.zhu@intel.com>
Subject: Re: [PATCH 03/11] iommu: Compute iommu_groups properly for PCIe
 switches
Message-ID: <20250922191029.7a000d64.alex.williamson@redhat.com>
In-Reply-To: <20250922231541.GF1391379@nvidia.com>
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
Organization: Red Hat
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: eBECIpAQ-Ofl1A0X08xdFXW6DDOrfE2DyaT1fRO8r28_1758589832
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 22 Sep 2025 20:15:41 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Sep 22, 2025 at 04:32:00PM -0600, Alex Williamson wrote:
> > The ACS capability was only introduced in PCIe 2.0 and vendors have
> > only become more diligent about implementing it as it's become
> > important for device isolation and assignment.    
> 
> IDK about this, I have very new systems and they still not have ACS
> flags according to this interpretation.

But how can we assume that lack of a non-required capability means
anything at all??
 
> > IMO, we can't assume anything at all about a multifunction device
> > that does not implement ACS.  
> 
> Yeah this is all true. 
> 
> But we are already assuming. Today we assume MFDs without caps must
> have internal loopback in some cases, and then in other cases we
> assume they don't.

Where?  Is this in reference to our handling of multi-function
endpoints vs whether downstream switch ports are represented as
multi-function vs multi-slot?

I believe we consider multifunction endpoints and root ports to lack
isolation if they do not expose an ACS capability and an "empty" ACS
capability on a multifunction endpoint is sufficient to declare that
the device does not support internal p2p.  Everything else is quirks.

> I've sent and people have tested various different rules - please tell
> me what you can live with.

I think this interpretation that lack of an ACS capability implies
anything is wrong.  Lack of a specific p2p capability within an ACS
capability does imply lack of p2p support.

> Assuming the MFD does not have internal loopback, while not entirely
> satisfactory, is the one that gives the least practical breakage.

Seems like it's fixing one gap and opening another.  I don't see that we
can implement ingress and egress isolation without breakage.  We may
need an opt-in to continue egress only isolation.

> I think it most accurately reflects the majority of real hardware out
> there.
> 
> We can quirk to fix the remainder.
> 
> This is the best plan I've got..

And hardware vendors are going to volunteer that they lack p2p
isolation and we need to add a quirk to reduce the isolation... the
dynamics are not in our favor.  Hardware vendors have no incentive to
do the right thing.  Thanks,

Alex

