Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793518139;
	b=ZVX0KqF9/8rySpjRvapEpmmeN+ePYqYLVS89KoHvXgNda+EwUUyjY4tsgeCw6NP2wxCt
	 pWvqgrmvoo3yYS9yqJsjptN1b25/bPPWcrAULR/QzioU9QwMufPlfXkrVQvIaWKMTL4Mc
	 k3CGnDEn0Gb/QNN3UE0QwTFFFLnN2U6pJIfpj1Co4dJJLqGHYpiAvNgv4dGPZOFN6Y+ut
	 rbLR1xkpMnq/VFkfxsI9D8FVOKsHahwY0NtXebIshtMNdmcinKEsGE4ZJmBxtXRtAEf9T
	 cRXukCTt3XYMlCPzmufSNht1l8nmMZ93G0S/ol19igjY/LGoMh9pUoE6+bBX1VwEOrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793518139;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=ZEkTE9TgeFOprp8X/PqQu5dF595QKTp33C0W7LGmaFo=;
	b=fpN8Grzt2ZfCFC4oybytFQn7IyTR4wiFYtIKaRKvHhMA6QTjnGNE6aN61o1Epa/03Vvk
	 lMq50r424h8TyQCd8hTiji0CiZ/kq1yH8ukMM5sdThDkQk/ILgIs9dguQyB33seKC8WMq
	 AmBNAbDf3EGAj4Tlo27JPt0sYz90J+TqSkScCnsldRKZQx8uRyN5ejOHQbq8EREOQ6RrL
	 Aa3Xe0EknjT8T2sH18ZVJXUSyo2hEUEGYyVmT5tPKoUKlyxQkD54Xg4691LhtyX74QjbQ
	 i4UA3GhBFAFKqX6tp0j31ChqRulblFaJ1f136HPkKojwPWyuzQ2imAcAIgrei2tfprg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K8xgiLEf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8EA6606A324;
	Sun,  1 Nov 2026 07:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K8xgiLEf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 734D41F000C1;
	Sun,  1 Nov 2026 07:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793518138;
	bh=ZEkTE9TgeFOprp8X/PqQu5dF595QKTp33C0W7LGmaFo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=K8xgiLEfZj/gyEaaz2uZMZEtINC0VjibSRUzhyA0UtxtVj7GBaePTRNRR5fWz/W9l
	 xbPqnCcpLaOo0aRXU3RMM0zMN4VGVdy0m0nQmDoPizWSzBvPjHm9AkJpHifvSWqqVA
	 3G7EEBcuXL7pKNXHrvz/ow7TSqx7rpRsWv4eFNlxaGzKnkewO7xsNcu8elCrWHzfjo
	 eLhX7+EkulhuuyBzXYopkKEo5/fGiKchuInGtrXvWKoy/dUVy+Lb++wylvey4+ztZE
	 9G8ROFw68lG4BH3Zg1puVCJ4P6+9BpO4NxGFID+CzmVs+ykCBaiKornyJlcnjea3/t
	 x5PLjVjP9f2vg==
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
In-Reply-To: <CAEvNRgFEKqVZcNYCL0LpB6BTyBFe+ot1x1nFfEqOrSTsu134PQ@mail.gmail.com>
References: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
 <20261017073149.1303738-3-aneesh.kumar@kernel.org>
 <CAEvNRgEh3E7NBc5_3Wq66Fss-mAYT6+4FWP5+=Co6+OVfVnQQQ@mail.gmail.com>
 <CAEvNRgFEKqVZcNYCL0LpB6BTyBFe+ot1x1nFfEqOrSTsu134PQ@mail.gmail.com>
Date: Sun, 01 Nov 2026 12:58:48 +0530
Message-ID: <yq5a33tl9fin.fsf@kernel.org>
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

> Ackerley Tng <ackerleytng@google.com> writes:
>
>> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:
>>
>>>
>>> [...snip...]
>>>
>>> +static int kvm_gmem_device_convert(struct inode *inode, pgoff_t start,
>>> +		pgoff_t nr_pages, const struct guest_memfd_device_request *req,
>>> +		const struct kvm_memory_slot *slot)
>>> +{
>>> +	struct gmem_inode *gi = GMEM_I(inode);
>>> +	u64 attrs = req ? KVM_MEMORY_ATTRIBUTE_PRIVATE : 0;
>>> +	bool prepared = false;
>>> +	int ret;
>>> +
>>> +	MA_STATE(mas, &gi->attributes, start, start + nr_pages - 1);
>>> +
>>> +	filemap_invalidate_lock(inode->i_mapping);
>>> +	if (__kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs)) {
>>> +		ret = 0;
>>> +		goto out;
>>> +	}
>>> +
>>> +	if (req && !__kvm_gmem_range_has_attributes(inode, start, nr_pages, 0)) {
>>> +		ret = -EEXIST;
>>> +		goto out;
>>> +	}
>>> +
>>> +	ret = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>>> +	if (ret)
>>> +		goto out;
>>> +
>>> +	kvm_gmem_invalidate_start(inode, start, start + nr_pages, KVM_FILTER_SHARED);
>>> +	if (req && READ_ONCE(gi->device.kvm->vm_dead))
>>> +		ret = -EIO;
>>> +	else
>>> +		ret = gi->provider_ops->prepare_conversion(gi->provider, req);
>>> +	if (!ret) {
>>> +		prepared = true;
>>> +		if (req)
>>> +			ret = kvm_gmem_device_make_private(inode, slot, req, nr_pages);
>>
>> Is there a way to avoid making private from within the conversion flow?
>>
>> kvm_gmem_device_map() below already does it as part of vcpu_run.
>>
>> If we do the above, we'd be aligned with regular conversions, where
>> to-shared conversions eagerly update arch state (make_shared) but
>> to-private notifications to the firmware are done lazily.
>>
>
> I was a bit confused above. IIUC to handle
> RMI_EXIT_VDEV_VALIDATE_MAPPING, the conversion is not done from outside
> the kernel, instead it is done in the vcpu_run completion hook.
>

All of that has changed in the latest series.
kvm_complete_vdev_map_validate() now does the following. For the dependent
changes in other subsystems, you may want to fetch the Git branch
mentioned in the cover letter.

static void kvm_complete_vdev_map_validate(struct kvm_vcpu *vcpu)
{
	struct kvm *kvm = vcpu->kvm;
	struct realm_rec *rec = &vcpu->arch.rec;
	struct realm *realm = &kvm->arch.realm;
	struct kvm_memory_slot *slot;
	unsigned long start = rec->run->exit.dev_mem_base;
	unsigned long top = rec->run->exit.dev_mem_top;
	unsigned long rd = virt_to_phys(realm->rd);
	unsigned long rec_phys = virt_to_phys(rec->rec_page);
	int idx, ret;

	if (vcpu->run->cca_exit.response != KVM_ARM64_TIO_RESPONSE_APPROVE ||
	    top <= start || !PAGE_ALIGNED(start | top | rec->run->exit.dev_mem_pa) ||
	    !kvm_realm_is_private_address(realm, start) ||
	    !kvm_realm_is_private_address(realm, top - 1))
		goto reject;
	idx = srcu_read_lock(&kvm->srcu);
	slot = gfn_to_memslot(kvm, gpa_to_gfn(start));
	if (!slot || (slot->flags & KVM_MEMSLOT_INVALID) ||
	    !(slot->flags & KVM_MEMSLOT_GMEM_DEVICE) ||
	    gpa_to_gfn(top - 1) >= slot->base_gfn + slot->npages ||
	    slot->arch.device.vdev_id != rec->run->exit.vdev_id_1)
		goto out_reject;
	/* Userspace installs the mapping through guest_memfd before approval. */
	if (!kvm_gmem_range_has_attributes(slot, gpa_to_gfn(start),
					   gpa_to_gfn(top), KVM_MEMORY_ATTRIBUTE_PRIVATE))
		goto out_reject;
	while (start < top) {
		unsigned long next, rmi_ret;

		ret = rmi_rtt_dev_validate(rd, rec_phys, start, top, &next, &rmi_ret);
		if (ret || rmi_ret || next <= start || next > top)
			goto out_reject;
		start = next;
	}
	srcu_read_unlock(&kvm->srcu, idx);
	return;
out_reject:
	srcu_read_unlock(&kvm->srcu, idx);
reject:
	rec->run->enter.flags |= REC_ENTER_FLAG_DEV_MEM_RESPONSE;
}


-aneesh
