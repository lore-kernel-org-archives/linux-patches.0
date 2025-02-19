Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C371DE3DB
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 10:34:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739961297; cv=none; b=IVdAvxGv9Bx8RXx2+WUNBRqDmkBD+cZGLkc3xQwJQuM1FbxNPFamezmnB+EP7Fre216+7/GGMbsrn0M+1EKaa7w4sg1jAbtzAoEB/o+vlWpYUDh6s2kRplV5Zd2hNstKAJBeYbzg5DFUHLqL86kfKMdnXXMbvgGNSm7N210famw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739961297; c=relaxed/simple;
	bh=b7MSguhkEYIFV9r/YVvQjRqC1zbG88lRpiyyvxT4IwQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VAqZ74nJDkHo57+0A26E9NjmT1P+I+Itm7cTT64HED0zQGNj2EzdbnKKflwAh6/LRYF+Fo4Di2cgzOxWiwCeEyLHlN/1iYpjaz5NliYzRfBjfNQeDNYbXlWp5YqupoY3d/iDSkKPlDnTYLyj5p5WX0kn78QprhqFQy/OWW7s2qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=g0mM46w4; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="g0mM46w4"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-43948021a45so66159135e9.1
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 02:34:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739961293; x=1740566093; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iddD4f+K68MybEewTke97XkRD+irdrfZMT0WwBhvQBA=;
        b=g0mM46w4qxD1m3gl7w+ua41Efmi2uXXkpUts38/ZNP8GFFkQCip5qCin38Mu45IH8y
         +GnecEYD22naeG2FY6DcSXxILhJodqq6TAdZpEqUTnYFI0ON3ikTdWwX7f/6Erg3YH4U
         bE8d2Qis5tNABM/YaTqrgh/6+5IbCK6svy4ZJ5wPeVPg+ErPdE47z/BHAKHdoLBiNHW8
         0icVpZ+T3frWC7mq+ljXGaWUGT6pMAQoR7cKMF8Ik5hlFNmdfU47GLNyO0BPhzS7mtPk
         oaUlHhWziireoQrZIFjkJ/UF0KPWbd2zZrirxw5VQO5HDRhmQUOg9U2nmdVJx1t3QuAG
         +RDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739961293; x=1740566093;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iddD4f+K68MybEewTke97XkRD+irdrfZMT0WwBhvQBA=;
        b=PyBm/I/lXHrWsyTxoDBGr1CeJ853xulm9e7fUq1cHeEu+E3Txmba4FdCe0ISWZFG31
         LfdXCO6TB3Qo9pno25ulbkL362nfRzJ51lTkLKTRdOBEI5m5KkQbgygryZJqHzl4CEiR
         X2ehrdar91GXzlGEacYFvmMIwHKu6uvcJHEziEVPbUuzDkov8+dmhGn3zuGJMUaX9zqj
         45OoOpy1TEZ1eD/si1BQJoi9FY8UK3JaWcrSjjWriWmv5r6MELi1BUxJjU6iHKu8uK8y
         EMPwz2pHzv1N7Vn1h7Ix5X+TTNgvB2nlH025eC+xEzCgTRKqa3SBZZ4i/e/HJG2xm4a2
         iLcQ==
X-Forwarded-Encrypted: i=1; AJvYcCUUJL5gvWdrlfFZYqFV1Is3bbj5fdpBBUUsWHlZEo45B6bOW7Uld+aqoyth/ZN7Oj08sdX0qUhH@lists.linux.dev
X-Gm-Message-State: AOJu0YzIWZWaxOs23m45gkTPlv5a7GOIE8p6W8IOAb2uvC2T6o5Ix9mh
	/IYaSYiPL0/dB46kWmAJx9CuTXym13lYuOl9qLmzLEDtbXLIoUpTn9o5gZH1sBQ=
X-Gm-Gg: ASbGncvxVJ9HdPKsyLHsYjrs2EmzxFR8OHmMh/zQzijtpCAdb8eCH7wx6PXRBEBKmRA
	NPOxsZu+eB7Wbnu7miFtVRHInPQr2vynH96De5WVOwpiJzOsdwusNRuXXiE4c7fCMc4bY2lKA4R
	01A4O32dHWlOYfL3T13zFPPTgqS9xWv4E+9zg+4ZM760cx41VdR6rE3LgVHca+s4Eab96SPMOVI
	ZBJ/ImJD/MM+nNWTQkxTfw8+WedHqH7vOYdTB13UThN933dEoPqCSl16xZDajXfVgg0UYVze5nn
	fAU4LH38w9BQ2Q==
X-Google-Smtp-Source: AGHT+IGdvjDwC1Yg0UDGPC2/1cHd3XcCUaxjKylFQQPONcj1mC0xAaoqTWK5SwfaEl1+gWgif5i+lQ==
X-Received: by 2002:a05:600c:3b09:b0:439:9225:2f76 with SMTP id 5b1f17b1804b1-43999da7d97mr29641305e9.18.1739961293450;
        Wed, 19 Feb 2025 02:34:53 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4395a04f208sm207312815e9.6.2025.02.19.02.34.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 02:34:53 -0800 (PST)
Date: Wed, 19 Feb 2025 10:35:18 +0000
From: Jean-Philippe Brucker <jean-philippe@linaro.org>
To: Yu Zhang <zhangyu1@linux.microsoft.com>
Cc: jacob.pan@linux.microsoft.com,
	Easwar Hariharan <eahariha@linux.microsoft.com>,
	"zhangyu1@microsoft.com" <zhangyu1@microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	Joerg Roedel <joro@8bytes.org>, Robin Murphy <robin.murphy@arm.com>,
	virtualization@lists.linux.dev, Will Deacon <will@kernel.org>,
	Eric Auger <eric.auger@redhat.com>, patches@lists.linux.dev
Subject: Re: [PATCH 3/5] iommu/virtio: Move to domain_alloc_paging()
Message-ID: <20250219103518.GA513544@myrica>
References: <0-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
 <20250212233053.GV3754072@nvidia.com>
 <67ad876d.170a0220.3c21dc.85ceSMTPIN_ADDED_BROKEN@mx.google.com>
 <20250213094601.GA243081@myrica>
 <5irmuy6xwrjsrdjy7tmfzlnotxqdoqagjdsdtqjrrit673zaka@r43nyvc5gcyf>
 <20250213180919.GC243081@myrica>
 <cu7lznx5bxnqoavt3ri4dtzwt7lu3loitn7a344rbnmahpnc6h@2e2dknchxjmd>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cu7lznx5bxnqoavt3ri4dtzwt7lu3loitn7a344rbnmahpnc6h@2e2dknchxjmd>

On Wed, Feb 19, 2025 at 05:39:19PM +0800, Yu Zhang wrote:
> On Thu, Feb 13, 2025 at 06:09:19PM +0000, Jean-Philippe Brucker wrote:
> > On Fri, Feb 14, 2025 at 01:03:43AM +0800, Yu Zhang wrote:
> > > On Thu, Feb 13, 2025 at 09:46:01AM +0000, Jean-Philippe Brucker wrote:
> > > > Hi Jacob,
> > > > 
> > > > On Wed, Feb 12, 2025 at 09:47:23PM -0800, Jacob Pan wrote:
> > > > > Our code and backend support are still in the early stages, that is why
> > > > > I am attempting to convert virtio-iommu driver to iommu_pt. Not sure if
> > > > > anyone has done the QEMU part to support VIRTIO_IOMMU_F_ATTACH_TABLE?
> > > > > @Jean @Eric Do you know?
> > > > 
> > > > As far as I know Tina worked on this most recently:
> > > > https://github.com/TinaZhangZW/qemu/commits/virtio-iommu/vt-d-pgtable/
> > > > https://lore.kernel.org/all/20231106071226.9656-1-tina.zhang@intel.com/
> > > 
> > > Thanks a lot for this information, Jean.
> > > IIUC, these patches were trying to add VT-d IO page table support in
> > > virtio-iommu, but it is not based on Jason's generic PT [1]. Just wondering,
> > > does anyone have plan to do the incorporation? 
> > 
> > I'm not aware of anyone working on this at the moment. Something you will
> > need for a portable pviommu is a library that manages PASID tables rather
> > than page tables [1], because the Arm SMMUv3 arch only support assigning
> > PASID tables to the guest. Alternatively you could implement opaque PASID
> > table allocation via host calls, letting the guest allocate GPA space and
> > the host manage the PASID table, but that idea didn't seem very popular at
> > the time.
> 
> Thank you, Jean. Just had a study of the spec. For ARM SMMUv3, letting
> the guest manage the PASID table, and then assigning it directly to the
> backend in ATTACH_TABLE request looks quite resonable. But for VT-d,
> my understanding is the PASID table shall be managed by host. By "that
> idea didn't seem very popular", do you mean that people also want the 
> ATTCH_TABLE request for VT-d also assign the PASID table(an virtual one
> managed by the guest). If yes, why? 

No, the proposal for managing the PASID table in the host was done before
the VT-d architecture added Scalable mode, so at the time they also had to
assign whole PASID tables to the guest and weren't keen on managing it in
the host. I believe in revision 3 (2018) the architecture added support
for Scalable mode and the ability to manage PASID tables in the host.

Nowadays it wouldn't make sense for a pvIOMMU to manage the VT-d PASID
tables in the guest, because as I understand it there is no demand for
supporting the legacy mode address translation of VT-d.

Thanks,
Jean
