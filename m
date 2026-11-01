Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793516619;
	b=XA+aPVIJOtb/KP0v8qe3FbtVq2SD3CMR32D60lQBjXP/sR7rc0zSPgguF1hCRn22yGei
	 qZ5RslQDy8shWNEmLMtuzvUeb6aFX5SSA3DfsRPN1FqfDxBHrOv/Wos7nFtwcfME0mH/O
	 FbIEvu3Vz5LwcmKR/Vrx+Ug1ClWLr00maxsbIIcwo7OcI3T+yBc+PsR831crqnRxId13z
	 E2KnxOt0A1oRvRsofHAALJl/+nnXtM66IdICNyL4/GP4CwSMozwoPvdtzmBIOz2+gcX0m
	 spT+vuMQtEl6FuDpSC9oVLH6/uamCIYTkOaCdTEdmi0z4ZS9rCWAANxDb3xSPIvzi2g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793516619;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=aBPW+if3xv2lqj7+6aGESHtQB9tLz+SKlXoVbeeuHIQ=;
	b=z+XR5TlNcJf3OulfDnPKxpjNarn/jD/G1kkoiUQ1ihdOWsDcQeDxEGt1uCLY4aySAHd7
	 0TBkfaPgWkAEQ6oAK6Yl0zMb9wo9cINoBX6mGIrReCt4krj6f6wKy7ciK0IGBTTxWCwyC
	 1EaNVcyKkbz2JsYX1wIq/zXtDLDWdGSwSY+ajBDQQTanRqJign7sozvJVm/AGQ0IeP+ZZ
	 ATSOPS3L40E7+EBS19Ks1m1OQS0W22ihW0riEergz0p2LDsiee2Q/XEh5lJrjZwNKkno/
	 SrOMKDMHOpTxVyxzByOAJATYRodNido2T/K+f/bDbaywaBlrZGPqRzdb/rgxwqASecw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fXICk8Dv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE131606A324;
	Sun,  1 Nov 2026 07:03:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fXICk8Dv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226661F000C1;
	Sun,  1 Nov 2026 07:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793516618;
	bh=aBPW+if3xv2lqj7+6aGESHtQB9tLz+SKlXoVbeeuHIQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=fXICk8DvsdDAguqgDH5cWG31mUlCM3VSL8AmHsZsgeJPMYv+PU9RUOGZvib9mAgdd
	 dMZ9bBMxgqPIFTzJo31A3qfLVUJrg6O7P1uGSMf9sRo8G1NP/Iqpqg2352qgRpuBQn
	 U+R9f+eu55EjwrjLyO6BDp6UoQo0eBdQzDaBk78ev+gYBL8SYUH3HcmMzniKLIMqAz
	 CPWIVNE6qOcKXHeLDCFcxB4YWT2ThtrduI5zBZGnc23rgEisa0f3hiLoG8yAatMkHY
	 FoFJ7Hla8A1/3lc4kgtW5ahSYYHKQNzJlW5QMF6Al2NtROWmlxW/xhI599k3KoLXFY
	 AmkEcbHOftl0g==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>, linux-coco@lists.linux.dev
Cc: Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Will Deacon <will@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [RFC PATCH v2 02/13] KVM: guest_memfd: Support private/shared
 conversion of device memory
In-Reply-To: <CAEvNRgEh3E7NBc5_3Wq66Fss-mAYT6+4FWP5+=Co6+OVfVnQQQ@mail.gmail.com>
References: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
 <20261017073149.1303738-3-aneesh.kumar@kernel.org>
 <CAEvNRgEh3E7NBc5_3Wq66Fss-mAYT6+4FWP5+=Co6+OVfVnQQQ@mail.gmail.com>
Date: Sun, 01 Nov 2026 12:33:28 +0530
Message-ID: <yq5a5wyh9gov.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Ackerley Tng <ackerleytng@google.com> writes:

> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:
>
>>
>> [...snip...]
>>
>> +static int kvm_gmem_device_convert(struct inode *inode, pgoff_t start,
>> +		pgoff_t nr_pages, const struct guest_memfd_device_request *req,
>> +		const struct kvm_memory_slot *slot)
>> +{
>> +	struct gmem_inode *gi = GMEM_I(inode);
>> +	u64 attrs = req ? KVM_MEMORY_ATTRIBUTE_PRIVATE : 0;
>> +	bool prepared = false;
>> +	int ret;
>> +
>> +	MA_STATE(mas, &gi->attributes, start, start + nr_pages - 1);
>> +
>> +	filemap_invalidate_lock(inode->i_mapping);
>> +	if (__kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs)) {
>> +		ret = 0;
>> +		goto out;
>> +	}
>> +
>> +	if (req && !__kvm_gmem_range_has_attributes(inode, start, nr_pages, 0)) {
>> +		ret = -EEXIST;
>> +		goto out;
>> +	}
>> +
>> +	ret = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>> +	if (ret)
>> +		goto out;
>> +
>> +	kvm_gmem_invalidate_start(inode, start, start + nr_pages, KVM_FILTER_SHARED);
>> +	if (req && READ_ONCE(gi->device.kvm->vm_dead))
>> +		ret = -EIO;
>> +	else
>> +		ret = gi->provider_ops->prepare_conversion(gi->provider, req);
>> +	if (!ret) {
>> +		prepared = true;
>> +		if (req)
>> +			ret = kvm_gmem_device_make_private(inode, slot, req, nr_pages);
>
> Is there a way to avoid making private from within the conversion flow?
>
> kvm_gmem_device_map() below already does it as part of vcpu_run.
>
> If we do the above, we'd be aligned with regular conversions, where
> to-shared conversions eagerly update arch state (make_shared) but
> to-private notifications to the firmware are done lazily.
>

For the TDISP flow, the vdev must be mapped before the guest can issue
evidence accept. The flow I am currently trying to follow is: the guest
requests validation of the MMIO range, triggering a VM exit; VFIO
validates the range and then converts it to private via
kvm_gmem_set_attributes_ioctl().

In my new series, I have added a backend operation that abstracts this
across folios, RAM PFNs, and device PFNs.

-aneesh
