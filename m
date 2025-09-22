Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4181D28D8E8
	for <patches@lists.linux.dev>; Mon, 22 Sep 2025 22:32:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758580331; cv=none; b=Cl7ri1pFASuy33zVqJDuXW/AZ3M42LFY2qImJJxHO4WOEeQHZiAnHhLbJ9N1SBnIRRZyaSUmoAhuGDp2ORnMd+lPE28X4nqTiTgiaaU6kHf2tqLBAc8PCyDcQohEC+t1dZ0hFuSRPWu5lwTOnam42+GwH0R23iDwQk2u6GsNqjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758580331; c=relaxed/simple;
	bh=tGsUKlZfH22Kkdt+rXlTfFHGLqAHCVSokUZMQlqwc6Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PyXAXqE6HmxwFCjLs4nSSCF3RzmVoGKkHBBMk15eSHIX3SMoMdKDNx6+k6rJKVpYS7v51j2xWX27XF8BpyadPofERX6PbOzjzGoTcQUvY3QrLhB2o0bqpuMYEiZG4xo3WWZons3Q95+e2mO7V121tL4zPwcKtq5XLYCh57Xu/9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=UK+JVoSS; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UK+JVoSS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758580329;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=WrM/zxhwv4klqtoRkgBDgOYK9tDXhnKZzT4SJVNV1Qg=;
	b=UK+JVoSSiaGzs8i/FRzgmTn3L7zvWMogsPAY3CCLSuovXG4qeLZ7tRpeah+ng25ZpLA3xn
	FnIYp704HPLdkelxrA/j/sXTcei2p38zN5kILVpccuVFAGe5KPatT2+JWHIVpBGL9/oxgU
	muCExxpt4kzT89q1UR+84Ai7cX/u4HU=
Received: from mail-io1-f69.google.com (mail-io1-f69.google.com
 [209.85.166.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-522-yWHJJv6DM6CgZRaBCpSckw-1; Mon, 22 Sep 2025 18:32:05 -0400
X-MC-Unique: yWHJJv6DM6CgZRaBCpSckw-1
X-Mimecast-MFC-AGG-ID: yWHJJv6DM6CgZRaBCpSckw_1758580325
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-8c24aa3f7f5so19171539f.3
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 15:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758580325; x=1759185125;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WrM/zxhwv4klqtoRkgBDgOYK9tDXhnKZzT4SJVNV1Qg=;
        b=SQOzd78Qa53+YQQ8cqJgR6sgR/4/QO2nJZ3KjY1PCzNouIdm9RIdoO4F9jgkRrWDfP
         BGrXTRaP22TMykBTXN1dQm6sK3NxBoM/AbTk34x2RJfqcwXAz91Gy2LgU0BFsBCkpSU2
         AijY3O7LHhj01pfk/N1M53zg7qfLEcheMir9gEXoMTYKSFo4aBpMLzaUw8EmB1cFv+VO
         D3Vco6Ng06bW3CT0zcrOEU12c0CwgCFwcVGjDHv7t8FEQFWLHzStZBzwdVCkEbUaEG2C
         EW0rjIdrO99oZQmpD+77PLPtFrZ8MpIvz52TYsCxh2EUgbrA9pfJD8arMqlJMbx0SdAC
         JUog==
X-Forwarded-Encrypted: i=1; AJvYcCXRC1nIIF6Cfr7z5WrcwGFoQWCrqjiUR55VfwdMcH7gUK2yg8MtAjLXT95wy0ERR/wb72OJjo8W@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5eJXISEZ0+DAYXtDG3ceplmkhulYAjrOOfVqELBq+3Vy+iLuS
	rb57oXTB2bqMax5nD5VVkp4zYzMU8lcvR5qP9+JpMGnsSr3qQOFwGVTH/KdQLuSdd5UNzRVnHwz
	V45AOsg0uNCeffKf5yCBy+YCxa1QhUuTcYNIGw4rWgNktLAetxgIiG0X+h/w=
X-Gm-Gg: ASbGnct7gTCAChmI6Agenf8TzRdVwoBdeO7TSKXaXEvD/rHQCa1lX1PWfDJHC+yyuSd
	Aa6Di6rLeqzUXu2jN6JdgAh/ZSibzuy/pgJZf1tPzRBLcfvYPyWHE/BFevMz+6e25HoCSMnqN2u
	3fkiY3FMWu0/dsSJt8B48eFteJkY4Ok2gl8kGXXH8jZskWX/vvpMFBeGSa3h83u1UMTx4gPiHDe
	SrD3+K3jsh22YQow7N4hhmEIjyrasRyv/+ojcMR41NtlInFansGtInAyUnuohkCeWVkWiZRli2q
	KgEFyP429DG246T4Ho9xRu/sN6nbT0aqS/qWiYEnMtc=
X-Received: by 2002:a05:6e02:164d:b0:400:7d06:dd6d with SMTP id e9e14a558f8ab-42581e09c50mr3117515ab.1.1758580325082;
        Mon, 22 Sep 2025 15:32:05 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFJEglC1l9HK0trhwS8TUhgMjco7KnQFggHDZoCeb4hUnb+WHFtfyngwGswerl1XqO2iXxTzA==
X-Received: by 2002:a05:6e02:164d:b0:400:7d06:dd6d with SMTP id e9e14a558f8ab-42581e09c50mr3117245ab.1.1758580324618;
        Mon, 22 Sep 2025 15:32:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-53d50aa460bsm6196930173.52.2025.09.22.15.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Sep 2025 15:32:03 -0700 (PDT)
Date: Mon, 22 Sep 2025 16:32:00 -0600
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
Message-ID: <20250922163200.14025a41.alex.williamson@redhat.com>
In-Reply-To: <20250718133259.GD2250220@nvidia.com>
References: <0-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<3-v1-74184c5043c6+195-pcie_switch_groups_jgg@nvidia.com>
	<20250701132905.67d29191.alex.williamson@redhat.com>
	<20250702010407.GB1051729@nvidia.com>
	<c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
	<20250717202744.GA2250220@nvidia.com>
	<2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
	<20250718133259.GD2250220@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: DY-ZEhr3L1XulTjJHKwzAL8goxYO7mRWa9TXPCw7hvI_1758580325
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 18 Jul 2025 10:32:59 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Thu, Jul 17, 2025 at 10:31:42PM -0400, Donald Dutile wrote:
>  
> > > > If no (optional) ACS P2P Egress control, and no other ACS control, then I read/decode
> > > > the spec to mean no p2p btwn functions is possible, b/c if it is possible, by spec,
> > > > it must have an ACS cap to control it; ergo, no ACS cap, no p2p capability/routing.  
> > > 
> > > Where did you see this? Linux has never worked this way, we have
> > > extensive ACS quirks specifically because we've assumed no ACS cap
> > > means P2P is possible and not controllable.
> > >   
> > e.g., Section 6.12.1.2 ACS Functions in SR-IOV, SIOV, and Multi-Function Devices
> >  ...
> >  ACS P2P Request Redirect: must be implemented by Functions that support peer-to-peer traffic with other Functions.
> >                            ^^^^
> > 
> > It's been noted/stated/admitted that MFDs have not followed the ACS
> > rules, and thus the quirks may/are needed.
> > 
> > Linux default code should not be opposite of the spec, i.e., if no
> > ACS, then P2P is possible, thus all fcns are part of an IOMMU group.
> > The spec states that ACS support must be provided if p2p traffic
> > with other functions is supported.  
> 
> Linux is definately the opposite of this.
> 
> Alex would you agree to reverse this logic for MFDs? If the MFD does
> not have ACS cap then the MFD does not do internal loopback P2P?
> 
> I think that solves all the MFD related problems.

Sorry, I'm way, way late to responding to this, but I interpret this to
mean that if a multifunction device implements an ACS capability, it
must implement ACS P2P RR if it supports P2P between functions.  If the
ACS capability does not implement ACS P2P RR then we can assume that the
device does not support P2P between functions, but if the device does
not implement an ACS capability at all, we cannot assume anything.

This is effectively why NIC vendors like Intel started implementing an
empty ACS capability, such that we can infer that there is no P2P
between functions.

I'm just catching up from some extended PTO, but this statement in the
cover of the new series is setting off red flags for me:

  For multi-function-devices, a PCIe topology like:

                    -- MFD 00:1f.0 ACS not supported
    Root 00:00.00 --|- MFD 00:1f.2 ACS not supported
                    |- MFD 00:1f.6 ACS = REQ_ACS_FLAGS

  Will group [1f.0, 1f.2] and 1f.6 gets a single device group. However from
  a spec perspective each device should get its own group, because ACS not
  supported can assume no loopback is possible by spec.

The ACS capability was only introduced in PCIe 2.0 and vendors have
only become more diligent about implementing it as it's become
important for device isolation and assignment.  IMO, we can't assume
anything at all about a multifunction device that does not implement
ACS.  Thanks,

Alex

