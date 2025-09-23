Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53122323F59
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 12:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758632290; cv=none; b=u2ICmGrOUWUJ/syEDIFqkHsMGrnrrd/VrvCli4qXXw4cm+x41TquJK+aXtkBDSH1L3gcQHs3gf3VPT8AEvJjGywFSFyJJqOoHrHOBs2HzExnWtpnhtUpFsPPSnrCiy0A8Pdf9bHkpQqY2bjr5MtV9PrPJXS4vBCnIwrtPPg7HyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758632290; c=relaxed/simple;
	bh=A2IMMdRVOaoGx4CmZT7VA864qaSMJOoHUZNtkeMI/VU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fR3J9PQCIsxhniQsH/zbL0eo+AHo4dYuDgF95L6rWQXJulc2dB1ScJpAwc6FcpTx9v4dzObyMFd4rjSWDOOn4BN9JpCESd+c/9PLc5EuM5HiguY6f75GMwZ7PWywVXV+gusrQQMoHu4a9ut0LfOIiGGxObiuKKdy2pyVduey2hY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RunkEksx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RunkEksx"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1758632287;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5Tq8eV1TAeYiGLz8ruZSC4SaM9je4JKLFfQxF5hcnMA=;
	b=RunkEksxs9/0cxA3/8usOFHtRjhv0+aYpxdKUYNRRG+JD1AF0yYkHfeZgZqsTtdy2SUchT
	C4z2fLRvhtHig/s8zVK3wVyYA/cb6s5i1Pu306Tf8GDa4zVSRDSK96rcSU3kpTNA8qRRm/
	uvCsqLQGQHRiOwwqTccaIcYUtCSTvBg=
Received: from mail-il1-f197.google.com (mail-il1-f197.google.com
 [209.85.166.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-435-8ABCYdr_PmizWjJ8iRuHEA-1; Tue, 23 Sep 2025 08:58:05 -0400
X-MC-Unique: 8ABCYdr_PmizWjJ8iRuHEA-1
X-Mimecast-MFC-AGG-ID: 8ABCYdr_PmizWjJ8iRuHEA_1758632285
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4257e5a8f1fso2567665ab.1
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 05:58:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758632285; x=1759237085;
        h=content-transfer-encoding:mime-version:organization:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Tq8eV1TAeYiGLz8ruZSC4SaM9je4JKLFfQxF5hcnMA=;
        b=SjnUvol3y6dSvyvmTyM0lpqLkVjGXRP2pK8p4OPAiUOzGzgzIRNMsMErIfuXW7nT1P
         w5ulJchmF7gd09dmFVISvuwJGmqfhjq0ZCRXcEOzfQqqBeW2UI8x7DMsFcunrdb3Ar5H
         xqN8XuxO0PJLpBPHUH/QRQEfaaizqXwRXwEgYJCFhE+H1hGB/qValBKwz4TzLymRyyng
         iAY6Eus43zWrq+DvlokBqNidqLOQkbLeuwwWqiWxcwjdpI4dctpcj+Wm+w0+pyJItR9i
         /XeAseoTKliEggqVlX0dsc7O410LUO5OGdmNEaKpPQyBExWxsN+iF7OhCfgjb05fko6A
         SdlQ==
X-Forwarded-Encrypted: i=1; AJvYcCXwRzypnwMC/fnTlDHrCmceOqO78UTKqGiLVBL9VHW7ldOEDENo1Gpup0aueVkx9KK2SCrqTiC5@lists.linux.dev
X-Gm-Message-State: AOJu0Yyf4badeo57seaZmmYJvrnWybYNr26ZmPsTwlrHtlfaqHmFXKvA
	947Ef04fS13qaWRX033Ah/00Qk6HGQZydKap8DRQ3YPP5OKs6QQGUdXPRpgXtkOcJ2/eNvLXNeA
	Ccox3k3RJvbQ+2mSBU0mgjCzvh9TtT9+aUkebE9CHls9GpaLafVRtjh0WDeQ=
X-Gm-Gg: ASbGncstJLkSLOO1r8P4sxLBKpKajwf2PFaRNhgiJ5pULAXTiGTt/iHe8YSpIGYHukU
	M1qyoKiancqYX8oK6UGsacil9nZIujWYtTA9CNTSTmCTTfsGxzoKZLQJ7VoPrioVqlt3cTx2vt4
	MCZr6LepSc7IsIQ4GsgMK7wYAeT/lnXHUAPQ3/WkkI4iqd9e/bKYevVDtpqvWMzvWQWMhqUYm2G
	v1iKZxK5iKiH9BZqhgR+5mWwnWYcXWsBpxcuWWBBzhi7PuTmhFmmc80NYkFpg5Z7zE2czmfz8ae
	XkENOZ5fsg0a7SDVUZf4aqkWyDo/ZAz4B+FGksfaWes=
X-Received: by 2002:a05:6602:3fc4:b0:897:42c1:bcd3 with SMTP id ca18e2360f4ac-8e20e8ff164mr163411039f.5.1758632284969;
        Tue, 23 Sep 2025 05:58:04 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGWbkj/uISty5Vh6ighMEa8imB4zODbgJ/1fX320gi/1h2UE0ETTQaM30bBEliykOTPs5/KCA==
X-Received: by 2002:a05:6602:3fc4:b0:897:42c1:bcd3 with SMTP id ca18e2360f4ac-8e20e8ff164mr163408639f.5.1758632284492;
        Tue, 23 Sep 2025 05:58:04 -0700 (PDT)
Received: from redhat.com ([38.15.36.11])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-8d7f8f481bfsm138390739f.24.2025.09.23.05.58.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 05:58:03 -0700 (PDT)
Date: Tue, 23 Sep 2025 06:58:01 -0600
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
Message-ID: <20250923065801.3c6a23e4.alex.williamson@redhat.com>
In-Reply-To: <20250923123218.GI1391379@nvidia.com>
References: <20250702010407.GB1051729@nvidia.com>
	<c05104a1-7c8e-4ce9-bfa3-bcbc8c9e0ef5@redhat.com>
	<20250717202744.GA2250220@nvidia.com>
	<2cb00715-bfa8-427a-a785-fa36667f91f9@redhat.com>
	<20250718133259.GD2250220@nvidia.com>
	<20250922163200.14025a41.alex.williamson@redhat.com>
	<20250922231541.GF1391379@nvidia.com>
	<20250922191029.7a000d64.alex.williamson@redhat.com>
	<066e288e-8421-4daf-ae62-f24e54f8be68@redhat.com>
	<20250922205027.229614fa.alex.williamson@redhat.com>
	<20250923123218.GI1391379@nvidia.com>
Organization: Red Hat
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: JIJVZWIcZrjL2rXTjY3XecJC4vFQ9hofS9aKeykjmLQ_1758632285
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 23 Sep 2025 09:32:18 -0300
Jason Gunthorpe <jgg@nvidia.com> wrote:

> On Mon, Sep 22, 2025 at 08:50:27PM -0600, Alex Williamson wrote:
> > That's not what the spec is doing.  We're misinterpreting it.  The
> > sections of the spec you're quoting are saying that if a MFD function
> > supports ACS it must support this specific p2p set of capability and
> > control bits unless the device does not support internal p2p.  
> 
> Bjorn raised that too, but it doesn't actually say that. The wording
> is meaningfully different from the preceeding section that does
> explicitly say the language only applies if the ACS cap is present.

What then is a "Multi-Function Device ACS Function".  I think we need
to take context from the parent and previous sections to understand
this applies to functions implementing the ACS extended capability.

> IMHO, from a spec perspective, prior to this language, internal MFD
> loopback was *undefined*.
> 
> You are advocating for a very pessimistic position that undefined must
> mean the worst interpretation for everyone. It doesn't, undefined
> means we don't know.

Right, we don't know if p2p is implemented, we're implementing a
security related feature, therefore we assume the worst case and allow
for quirks in instances where the vendor can vouch that p2p is not
possible.

> A big part of the argument here is that in the modern world the HW
> community has aligned that MFDs should not have internal loopback
> because it harms virtualization.
> 
> We are here a decade later and we can choose to require quirks on
> devices that choose to implement internal loopback, because they are
> certainly now the minority of HW.

This seems like optimistic speculation.

> > We've had NIC vendors implement an empty ACS capability to convey the
> > fact that the device does not support internal p2p.  There is precedent
> > for the interpretation I'm describing.  
> 
> IMHO it just shows Linux has the power to convince device vendors to
> do things.

And now we're effectively punishing vendors that have gone to this
effort to expose isolation by hand waving that it should exist by now...
 
> > Are we going to expect users to opt-in to securing their system?  
> 
> Since the grouping isn't working right today we are already
> effectively doing this.
> 
> All this is arguing that the burden shifts from people with modern
> systems to people with ancient systems.

AIUI there's a narrow case of downstream switch ports implemented as
separate slots that is misrepresented.  This should be fixed.  There's
also an effort here to consider both egress traffic (as done today) as
well as ingress traffic (new).  IMO this will inevitably cause
regressions and users may need to opt-in to make their grouping less
secure for previous compatibility.

Requiring users to opt-in to secure their system is fundamentally
different from requiring users to opt-in to a reduced isolation
paradigm.  Thanks,

Alex

