Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CB191DF74C
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 11:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739966224; cv=none; b=kJ2nJj2YVmn7LM+zGzCGDumVHfgog1VaPCuPMd0xWmkKxdbe7+x3UNYY4qUXYC+0vCA+7ACWt8afUY/DwvpVXqIoBbSTl0HMes3pnya8Gr8NeiDL2fvpIlvcjs14hMeh7E9wSno697kLxG8rHcvRUarWKTOJxox0zvxzZFaqU1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739966224; c=relaxed/simple;
	bh=6RY7FVDmjzHQ80JIOPX5CPjs33fql1if6bYOaBzH3d0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M1YpDbqMtvYiaPuT3kYxYRQ3/T3Rg32jew26p9rekwh2nSV8sFnI+IFvoR7zevsUuE36bNStsfEq691iwOGi5y8dk6GYpTrhRi1OyDreQvK7n3ZRwTxrMX6sAiIgg+sf7IJiYD9fZpQ233bFoiiW6aGTrr8gB3QZHGmyEMXFHlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Xgm36uwd; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Xgm36uwd"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43932b9b09aso72508135e9.3
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 03:57:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1739966221; x=1740571021; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=okn6O09si7kBE/1dHlS71dUjErVE7LOWp8T65eAQeJw=;
        b=Xgm36uwd7v2jZTnU75gAClvZKmN/nODOiQQ/igenn2mQ6j2bIw3vyWryR8r6x3WQlt
         2YKSVzdnVsKvJsJDLctimnUdnCVWa2sPIkxD/eflOo66AUEPVoX/PehoU15enIZZv8dP
         7Sqt/bskrnG7Tj4irxn7C62AzzT6/0OMfE82PUA9xWG1fd1zU3qIyD52oyLQzokKrMsp
         PvHRGFi/goOkZghTwJanF5DMHSA76o0GpXdUgma0abLllqkbQkKQESS9dkOzswxLtLpJ
         9ZnT88OA3MOKAWlPHqnGutpkGLPCKXRZuUlz+GLy3T7/JmO6Y7iH//qx6Shd/PW8THGB
         CswQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739966221; x=1740571021;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=okn6O09si7kBE/1dHlS71dUjErVE7LOWp8T65eAQeJw=;
        b=ovAA5lEIcHJj0LsgiwCPl8zuyV/DYdCm1Q2GnBz08AicfR3bpJ6bSQQ5q3xHi8Btkm
         aK3Mk1DKYMAyavaRYidZcPwFN8w5hy4uYGeb5BUVFRt7SqtV12Xx+V5Cli2fDll2cmj4
         yXWDdoRX4ZKzjSUPtPGHNkECaX8rYEimF0vQbMQVbHy6VLTVqKwVCl1QlBqEAO5PGlm+
         iPPFA4dLEl2Sw/O0HlghiEbo+Udw+UN9RLzA8vjrUSdfBwn4QltITUsxvfrowFERaN5C
         /gBViDWmiyyW0bylOt5/2d+P5Zov/BHKh2ltis7zQkQb1p6cyATG/MTdiovN61s0O1UB
         Lo/A==
X-Forwarded-Encrypted: i=1; AJvYcCVakRc0UbszglQPQ0Z2c8YhfaKZA3esiM/yPYgolpsM83WnkMK2ddzsi7Qhbk5yWjzYNaEwC/6e@lists.linux.dev
X-Gm-Message-State: AOJu0YwePg5URXXNuJI2+ukQGIZldt0j/pDpmmECzD7nwmk2UDsZ1zed
	kvtmjvukqAnX7FIp6ABnH2JowLQAel6hBe5xrbJoBrb2QZwB28Ep/8VT2Bc97zw=
X-Gm-Gg: ASbGncuIXd7ElVIt9qNSaMitRDMnTHuxGMZEaU4fuoLuBuNf8nQnyhdF6IEHZYjhZcz
	Kvk3qy6+yzQdZcc0uT1KXWCUMH+/8Kc1OVvua8JLtGqiulhCzBO2vF1UZ4WdtkjDQclFiVtUTZH
	9XgdLsn/0IGt1ZrJe0E9EACrROvLm4nixMMphZLsiJMe4N+/Bg7lXbefrDXJAFMGPz/NQ8X/r5O
	JZ7Dc/tc2/fpqeF8+/uylPGf/UKhKrJCYnMhwy5LxdhFx+n1wbYjN636Tbp2bu45jqD7f1N6l3J
	lTxTLm69Gr6XxA==
X-Google-Smtp-Source: AGHT+IHSWNh//eVPg2Iw3nDUVl0/mWY9Z+uXIwGFBr+HZ53WHNcQN3v6J5LnzFUh/oHgFMghQ7chOw==
X-Received: by 2002:a05:600c:19c7:b0:439:9b80:ca6f with SMTP id 5b1f17b1804b1-4399b80ccd1mr24399735e9.5.1739966220791;
        Wed, 19 Feb 2025 03:57:00 -0800 (PST)
Received: from myrica ([2.221.137.100])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43984924201sm88322405e9.6.2025.02.19.03.56.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2025 03:57:00 -0800 (PST)
Date: Wed, 19 Feb 2025 11:57:25 +0000
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
Message-ID: <20250219115725.GB513544@myrica>
References: <3-v1-91eed9c8014a+53a37-iommu_virtio_domains_jgg@nvidia.com>
 <20250212112235.714b0a14@DESKTOP-0403QTC.>
 <20250212233053.GV3754072@nvidia.com>
 <67ad876d.170a0220.3c21dc.85ceSMTPIN_ADDED_BROKEN@mx.google.com>
 <20250213094601.GA243081@myrica>
 <5irmuy6xwrjsrdjy7tmfzlnotxqdoqagjdsdtqjrrit673zaka@r43nyvc5gcyf>
 <20250213180919.GC243081@myrica>
 <cu7lznx5bxnqoavt3ri4dtzwt7lu3loitn7a344rbnmahpnc6h@2e2dknchxjmd>
 <20250219103518.GA513544@myrica>
 <jdyb4bxo5miiybkjbmnkszlcx5vwik7lqa5kgx4ptsage6tlu7@axsub4six2uu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <jdyb4bxo5miiybkjbmnkszlcx5vwik7lqa5kgx4ptsage6tlu7@axsub4six2uu>

On Wed, Feb 19, 2025 at 07:11:43PM +0800, Yu Zhang wrote:
> On Wed, Feb 19, 2025 at 10:35:18AM +0000, Jean-Philippe Brucker wrote:
> > On Wed, Feb 19, 2025 at 05:39:19PM +0800, Yu Zhang wrote:
> > > On Thu, Feb 13, 2025 at 06:09:19PM +0000, Jean-Philippe Brucker wrote:
> > > > On Fri, Feb 14, 2025 at 01:03:43AM +0800, Yu Zhang wrote:
> > > > > On Thu, Feb 13, 2025 at 09:46:01AM +0000, Jean-Philippe Brucker wrote:
> > > > > > Hi Jacob,
> > > > > > 
> > > > > > On Wed, Feb 12, 2025 at 09:47:23PM -0800, Jacob Pan wrote:
> > > > > > > Our code and backend support are still in the early stages, that is why
> > > > > > > I am attempting to convert virtio-iommu driver to iommu_pt. Not sure if
> > > > > > > anyone has done the QEMU part to support VIRTIO_IOMMU_F_ATTACH_TABLE?
> > > > > > > @Jean @Eric Do you know?
> > > > > > 
> > > > > > As far as I know Tina worked on this most recently:
> > > > > > https://github.com/TinaZhangZW/qemu/commits/virtio-iommu/vt-d-pgtable/
> > > > > > https://lore.kernel.org/all/20231106071226.9656-1-tina.zhang@intel.com/
> > > > > 
> > > > > Thanks a lot for this information, Jean.
> > > > > IIUC, these patches were trying to add VT-d IO page table support in
> > > > > virtio-iommu, but it is not based on Jason's generic PT [1]. Just wondering,
> > > > > does anyone have plan to do the incorporation? 
> > > > 
> > > > I'm not aware of anyone working on this at the moment. Something you will
> > > > need for a portable pviommu is a library that manages PASID tables rather
> > > > than page tables [1], because the Arm SMMUv3 arch only support assigning
> > > > PASID tables to the guest. Alternatively you could implement opaque PASID
> > > > table allocation via host calls, letting the guest allocate GPA space and
> > > > the host manage the PASID table, but that idea didn't seem very popular at
> > > > the time.
> > > 
> > > Thank you, Jean. Just had a study of the spec. For ARM SMMUv3, letting
> > > the guest manage the PASID table, and then assigning it directly to the
> > > backend in ATTACH_TABLE request looks quite resonable. But for VT-d,
> > > my understanding is the PASID table shall be managed by host. By "that
> > > idea didn't seem very popular", do you mean that people also want the 
> > > ATTCH_TABLE request for VT-d also assign the PASID table(an virtual one
> > > managed by the guest). If yes, why? 
> > 
> > No, the proposal for managing the PASID table in the host was done before
> > the VT-d architecture added Scalable mode, so at the time they also had to
> > assign whole PASID tables to the guest and weren't keen on managing it in
> > the host. I believe in revision 3 (2018) the architecture added support
> > for Scalable mode and the ability to manage PASID tables in the host.
> > 
> > Nowadays it wouldn't make sense for a pvIOMMU to manage the VT-d PASID
> > tables in the guest, because as I understand it there is no demand for
> > supporting the legacy mode address translation of VT-d.
> 
> Thanks, Jean. Yeah, my understanding is that old revisions of VT-d looks
> more like the ARM SMMUv3. But with scalable mode introduced, there's no
> need for a pvIOMMU to allocate a guest version PASID table on VT-d.
> 
> So my question becomes: why do we need a library that manages PASID
> tables in the guest? To also support AMD IOMMU besides ARM SMMUv3(
> I saw your spec proposed both ATTACH_TABLE request for AMD GCR3 table
> and ATTACH_TABLE request for AMD page table, but don't know which one
> is more preferred in practice)?

I don't know either, but given that the parts about AMD and RISC-V in the
proposal haven't received feedback they will definitely change, and it's a
question for AMD and RISC-V people.

Thanks,
Jean
