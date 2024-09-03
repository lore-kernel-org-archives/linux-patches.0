Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4DB21DAC4D
	for <patches@lists.linux.dev>; Tue,  3 Sep 2024 08:34:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725352465; cv=none; b=kBntPJ/9pFyj7YTeQ4lwXl/mzm3cZh577pHPm54MghBjzr+9Cvz7NJBV20e/3++eHVMjcSlyJ2Eq7vu1KFRQPCsbI3EFtZCoNgGQtxjecVIpjZyntADsBun2BiZ6qjKVYF0J7Bu7JO396z5FuyPDMx2iNIbc7NeJpAjZwjJyMxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725352465; c=relaxed/simple;
	bh=Ooaq7ri1Yl3eVP7lha8lZRj8WwdjRH3fBUHtV8sPBAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Cq2tV66TPpEzMvFRNFWVC3R8UvUFmr0k5SpUsJTQjTmu55mkHnkL8uzYNgNb2uxG3mwZJrQ8B3BPnUc0xXT8jMf+40MQOTZWQ8kHsMJa9zMfeuTjWndtJHk68Y22RtIVJ+2DqwrUeLnCNVv3sUADQI63nO1E0kjMzxR0HbSTxtY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EeSe6CW7; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EeSe6CW7"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5c2443b2581so20740a12.0
        for <patches@lists.linux.dev>; Tue, 03 Sep 2024 01:34:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1725352462; x=1725957262; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0x4pAN9v3PKcJSMJc9wNdVW/9mRtNQg8cuL1zQPTZck=;
        b=EeSe6CW70jF9xDrEWrvDEpbaNfDKIQ4ECCZDGIXlEakzvHhXQKLnAye4xF5kQ+oPv0
         C5IUIc51yISZx2VfEnXHO7GhWOuPPx0iRDLXH4BAs/yYeUWaBVZmbCXFql1wkqCijF09
         nOR2b7LQSskINmiOsn3gAxPBvpJxMGM1kp8kP8YeRZq9I+YWUPFSYqabmoZG8BAvFVDm
         fiPNgacXGEeWX9mESet6oeCyWuWOIivRlExj3WZX9UwUp1PksfQ+q1vppsoXy9TBRdLC
         xacM86M+KcssqDItpCKVsiGW1B7qqPrTWQDFuIdy0olM78z0FGy6aTOo+1tSFui5C88u
         hEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725352462; x=1725957262;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0x4pAN9v3PKcJSMJc9wNdVW/9mRtNQg8cuL1zQPTZck=;
        b=GxoTzTe4SdRnDbTqm/qYOG8YzS1IFIYyFwQjCCHwnjICDI94kuyA4BnsM12470wYi1
         pFDUIZL4y3zsin9icEtPe9vW8Wyro7WItcfsz2BsOEF8jZ370EyXvIJykNIhcmb1cMym
         fNGj2B8MdmvdtxyQqrF3PBvaYHp6mBLPJUoITOhSxWPe/L+GwYIivw7vHFqSNWejUtxA
         /H9rsATFIy9QFzjF53ddbMv2dQB2JoA13F7DJ91DK2PoZHESr544N7FDl0gC/28W5HZi
         P1+xO/uVT/XVu74neqKwLlehRaNafO+dGejkWGaKivXAUyJspvC2k+jMnM2me/vLQGnG
         6yvA==
X-Forwarded-Encrypted: i=1; AJvYcCXvEs4JkpF/2uBpUZri3qPS02JUj7S+4BKcoQucAoU7UEX8Rc7600dAG6/sxO1qdixQU/t/Rfi8@lists.linux.dev
X-Gm-Message-State: AOJu0YyyxWup1ecgsHO/yxhniGzBXzg9obm7KRLjLeWLGo+XhahoruND
	077n3aB8uyGaFxfjZ7qsCdxDSmqCi5vHC8FV5UAQqjAbY9rUSX7M6ykCk1i0Fg==
X-Google-Smtp-Source: AGHT+IHojl3Oq9t0TVbNRBXWCRNq0mfrK+8JmhduosaFNh97XMJFm2HeZ0fHsdevV1+0F28pRpzQOw==
X-Received: by 2002:a05:6402:2687:b0:5aa:19b1:ffc7 with SMTP id 4fb4d7f45d1cf-5c244360b96mr412535a12.2.1725352461558;
        Tue, 03 Sep 2024 01:34:21 -0700 (PDT)
Received: from google.com (109.36.187.35.bc.googleusercontent.com. [35.187.36.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-374baae211bsm9667974f8f.66.2024.09.03.01.34.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Sep 2024 01:34:21 -0700 (PDT)
Date: Tue, 3 Sep 2024 08:34:17 +0000
From: Mostafa Saleh <smostafa@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: acpica-devel@lists.linux.dev, Hanjun Guo <guohanjun@huawei.com>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>, kvm@vger.kernel.org,
	Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Robert Moore <robert.moore@intel.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sudeep Holla <sudeep.holla@arm.com>, Will Deacon <will@kernel.org>,
	Alex Williamson <alex.williamson@redhat.com>,
	Eric Auger <eric.auger@redhat.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Moritz Fischer <mdf@kernel.org>,
	Michael Shavit <mshavit@google.com>,
	Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
	Shameerali Kolothum Thodi <shameerali.kolothum.thodi@huawei.com>
Subject: Re: [PATCH v2 6/8] iommu/arm-smmu-v3: Support IOMMU_GET_HW_INFO via
 struct arm_smmu_hw_info
Message-ID: <ZtbKCb9FTt5gjERf@google.com>
References: <0-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <6-v2-621370057090+91fec-smmuv3_nesting_jgg@nvidia.com>
 <ZtHj_X6Gt91TlUZG@google.com>
 <20240830171602.GX3773488@nvidia.com>
 <ZtWPRDsQ-VV-6juL@google.com>
 <20240903001654.GE3773488@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240903001654.GE3773488@nvidia.com>

On Mon, Sep 02, 2024 at 09:16:54PM -0300, Jason Gunthorpe wrote:
> On Mon, Sep 02, 2024 at 10:11:16AM +0000, Mostafa Saleh wrote:
> 
> > > What is the harm? Does exposing IDR data to userspace in any way
> > > compromise the security or integrity of the system?
> > > 
> > > I think no - how could it?
> > 
> > I don’t see a clear harm or exploit with exposing IDRs, but IMHO we
> > should deal with userspace with the least privilege principle and
> > only expose what user space cares about (with sanitised IDRs or
> > through another mechanism)
> 
> If the information is harmless then why hide it? We expose all kinds
> of stuff to userspace, like most of the PCI config space for
> instance. I think we need a reason. 
> 
> Any sanitization in the kernel will complicate everything because we
> will get it wrong.
> 
> Let's not make things complicated without reasons. Intel and AMD are
> exposing their IDR equivalents in this manner as well.
> 
> > For example, KVM doesn’t allow reading reading the CPU system
> > registers to know if SVE(or other features) is supported but hides
> > that by a CAP in KVM_CHECK_EXTENSION
> 
> Do you know why?
> 

I am not really sure, but I believe it’s a useful abstraction

> > > As the comments says, the VMM should not just blindly forward this to
> > > a guest!
> > 
> > I don't think the kernel should trust userspace.
> 
> There is no trust. If the VMM blindly forwards the IDRS then the VMM
> will find its VM's have issues. It is a functional bug, just as if the
> VMM puts random garbage in its vIDRS.
> 
> The onl purpose of this interface is to provide information about the
> physical hardware to the VMM.
> 
> > > The VMM needs to make its own IDR to reflect its own vSMMU
> > > capabilities. It can refer to the kernel IDR if it needs to.
> > > 
> > > So, if the kernel is going to limit it, what criteria would you
> > > propose the kernel use?
> > 
> > I agree that the VMM would create a virtual IDR for guest, but that
> > doesn't have to be directly based on the physical one (same as CPU).
> 
> No one said it should be. In fact the comment explicitly says not to
> do that.
> 
> The VMM is expected to read out of the physical IDR any information
> that effects data structures that are under direct guest control.
> 
> For instance anything that effects the CD on downwards. So page sizes,
> IAS limits, etc etc etc. Anything that effects assigned invalidation
> queues. Anything that impacts errata the VM needs to be aware of.
> 
> If you sanitize it then you will hide information that someone will
> need at some point, then we have go an unsanitize it, then add feature
> flags.. It is a pain.

I don’t have a very strong opinion to sanitise the IDRs (specifically
many of those are documented anyway per IP), but at least we should have
some clear requirement for what userspace needs, I am just concerned
that userspace can misuse some of the features leading to a strange UAPI.

Thanks,
Mostafa

> 
> Jason
