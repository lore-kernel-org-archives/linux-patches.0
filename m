Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794333383;
	b=ZHMZTlEMvQSfyLn6Kyicb3L/Cmcno1iCHT/3OGiOYWQmdDKPgp9/RneMeT3hWlkWa/74
	 l9yV/w1+EJTPExtwOj5npLdq1XyuY1ZZB/L+GXKsT5yDYCRpJ8Pzg/rNBbTgS5OAyUI6R
	 VijFIUxIniPVlzRscfdBdyTsz1jY9hRIKQMiXbszbfwaXvutjEAO6E6aUTq/TUkgyDrWR
	 32wEx59GNjzKT4ZZuSSBy1HaJflmqPju5Jlw23VhqIDl5o2CeHN3XMvgJOzOlwP1+WLFt
	 wlJkJSK19aFKTRPUXl8LQwUO1VxP6lTVKxStge8/tB1EDHjQtCJWB74kgCZEhltlNQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794333383;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=MAQdXJ3jkoXr+7gO8H3oCVVTJDGIVHZdTHCjd7fxod0=;
	b=Sta3ymrawii9GHaYWmywjTiLCGpVgNRvFexDx4vilqzyUqRhsx2VfxiJSDd9j3kr8Vkj
	 Znn3w5XZzOedpJa+cWJTXHQVaKPcF1eIAHG4hN7ISot3V5GRIcXiU2oqthssTgTRpA7+9
	 mSqY3fHLfY/klk0KXiTKsqzgA2M0inf9dyqHtEwcIyvEpvD8FUf5cCzmDyt+RQCa8vrDh
	 D0mKlJk+0cA5XpKSao1BDgFBGio6mr5UrraXbXsBAYdLG87MwRYkS3s2ljYAJHEkKAs6P
	 9wwAMIHyK1IXBGrLZbcZmTcDFvI1pn/K83byKgq/kvIen19+ITTN+o49Esl1UE5Ub+w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJoVqVg5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7B1606A225;
	Tue, 10 Nov 2026 17:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FJoVqVg5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313E51F008A1;
	Tue, 10 Nov 2026 17:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794333383;
	bh=MAQdXJ3jkoXr+7gO8H3oCVVTJDGIVHZdTHCjd7fxod0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=FJoVqVg5QhoC9pxAWZKCF5rDJDlbwfkktHzFlvfseZn8HX8ZZFSIFwG6sCEMu9m9e
	 5luoSzkUnm5rhCNaXiK8qVx+yXuJ98B/ufegASe7JC/hdxyUXsRjIF0luRSAn4AkmL
	 tOAb8ReZ2e/F/ydpeQX7jLkmVWtzx6G5Ww8ZW0uY166ErHZv6Boc4KjmDKJ37l9Pph
	 V6KOrEppor4uU8qiX9PSCc25vXfMiioxfvmdR5NnN1STRwMBthgWjZM9UTizTNlPEA
	 p0V0KDa72WxTObkhuU++yktMXo8FQE3lIvvUZLYm/nd9QYBCBVYFFJ4bVMKLxYqEU7
	 p73PZwM3A/5KA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>,
	Fred Griffoul <griffoul@gmail.com>, linux-coco@lists.linux.dev
Cc: Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [RFC PATCH v4 06/25] KVM: guest_memfd: Support device-backed
 PFN providers
In-Reply-To: <CAEvNRgFE5=u8Q+fCUxLT7M_gAjkgNddSVrM3axuTUxBScffcbQ@mail.gmail.com>
References: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
 <20261104150322.3516320-7-aneesh.kumar@kernel.org>
 <20261104183754.10457-1-griffoul@gmail.com> <yq5apkwettbg.fsf@kernel.org>
 <CAEvNRgFE5=u8Q+fCUxLT7M_gAjkgNddSVrM3axuTUxBScffcbQ@mail.gmail.com>
Date: Tue, 10 Nov 2026 23:26:13 +0530
Message-ID: <yq5acxsctvsy.fsf@kernel.org>
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

> Aneesh Kumar K.V <aneesh.kumar@kernel.org> writes:
>
>> Fred Griffoul <griffoul@gmail.com> writes:
>>
>>> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:
>>>
>>>> Device resources such as PCI BARs supply PFNs directly and cannot use
>>>> the folio allocation path. Store the mapping owner and device ID in the
>>>> core context during attach(), and use them when preparing device
>>>> memslots. Keep device memory separate from ordinary PFN-backed RAM.
>>>
>>> The device rules you wrote down in api.rst and locking.rst helped a
>>> lot. If I read v4 right, the device backing differs from the RAM PFN
>>> backing in these places:
>>>
>>>   1. PFN mode calls RAM arch hooks: kvm_arch_gmem_make_shared() at
>>>      conversion, kvm_arch_gmem_make_private() at fault, and
>>>      kvm_arch_gmem_reclaim() on revoke and release. The device path
>>>      has to skip them.
>>>
>>
>> I would say that the VFIO provider expects the conversion to complete at
>> conversion time, rather than being triggered by a fault.
>
> guest_memfd currently does .gmem_make_shared() eagerly and
> .gmem_make_private() lazily (at fault time).
>
> Technically conversion time spans everything from guest exit to request
> a conversion, including the guest_memfd conversion ioctl, then till the
> vCPU run completion hook.
>
> Can we move the mapping out of the conversion ioctl and into some
> dedicated CCA-specific mapping ioctl, kind of like KVM_ARM_RMI_POPULATE
> but doesn't actually perform writes, just does mapping?
>
> The mapping ioctl should check the necessary prereqs, same for the
> vcpu_run completion hook.
>
> Here are some advantages I can think of:
>
> 1. Decouples mapping of VFIO addresses from guest_memfd and provide more
>    understandable errors for userspace, since the mapping step has a
>    clear and separate error (conversion is complicated enough with many
>    failure points)
>
> 2. Better aligned conversions in general where marking private at the
>    platform level is lazily performed. In this case, doing it outside of
>    the conversions ioctl is not much lazier, but slightly :)
>
>    Not quite mapping, but Suzuki did bring up that for regular memory
>    (not VFIO), ARM CCA requires vCPU context for SMC_RMI_RTT_SET_RIPAS
>    in .gmem_make_private(), hence that's done in the vcpu_run completion
>    hook, so that's kind of lazier, relative to doing
>    SMC_RMI_RTT_SET_RIPAS in the conversion ioctl.
>


Is there a reason why setting private attributes must not create new KVM
mappings? Is it because a guest_memfd can be bound to multiple VMs, and a
set_memory_attributes() operation should not affect the stage-2 mappings of
other VMs?

But yes, we can move the mapping to a separate operation. I am trying to
make device memory behave more like normal guest memory in this respect.
With VFIO passthrough, normal guest memory requires a private mapping
before the guest accesses it because a device can start DMA to the region
without any prior guest access. I currently use KVM's prefault path for
this and can extend it to handle device MMIO regions.

For an MMIO validation request, VMM would set the guest_memfd range's
memory attributes to private, prefault the protected IPA range and then
approve the request. Prefaulting would perform DEV_MAP.

This means that we need to track private device mappings as part of the
Realm. MMIO validation requires the device PFNs to be mapped already;
that work cannot be deferred until a subsequent guest fault. Before
issuing DEV_VALIDATE, the MMIO validation completion path would need to
check both the Realm's private mapping state and the guest_memfd memory
attributes.


>
>
>> This is also
>> required because, when an MMIO validation request completes, the guest
>> expects the range to be mapped. The current flow is that the MMIO
>> validation request exits to the VMM, which uses set_memory_attributes()
>> to convert the range to private.
>>
>>>   2. lookup_pfn_range() only feeds those hooks, so the device path
>>>      does not need it.
>>>   3. The host mmap and stage-2 need a device memory type.
>>>
>>
>>
>> Do you mean this code? vm_page_prot is used for the host mapping created
>> by mmap() on the guest_memfd, and its setup follows
>> vfio_pci_core_mmap(). I think the only device-specific difference here
>> should be pgprot_noncached(). Shouldn't the rest of the protection
>> remain unchanged even for device PFNs?
>>
>>
>> +	if (gmem_provider_is_device(gi)) {
>> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
>> +		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
>> +		vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
>> +		vma->vm_ops = &kvm_gmem_device_vm_ops;
>> +		return 0;
>> +	}
>> +
>>
>
> What do you think of just forwarding .mmap to VFIO to figure out? This
> makes VFIO less special of a provider, since I imagine different
> providers may want to have different page protections or VMA flags.
>
> guest_memfd just enforces VM_PFNMAP for PFN-mode providers.
>

I have reworked the patch set to drop backing_ops and consolidate
everything under provider ops. The generic guest_memfd path now contains
only provider callbacks; the folio, shmem, RAM PFN, and device PFN
differences are handled by those callbacks.

We might still want the generic code to apply:

	pgprot_noncached(vma->vm_page_prot)

These prot bits are exposed to VMM mappings, and if the attribute is not
reflected in vma->vm_page_prot, mprotect() may set the PTE protection bits
incorrectly.

I will send a v5 of the reworked patch series soon.

-aneesh
