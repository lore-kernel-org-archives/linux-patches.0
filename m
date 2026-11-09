Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794205534;
	b=0G+WAGFjMAIWfKBjf1p3/hBI/KbtKRJJiViOwF+m6AiDkB5vlz7zViWLWU5wy8NC5m1I
	 XDIak0CjiWNySjHbkGcl2tEm630XHFrEv1tdCAbeL5xKzoVu5Ls5h16C1cyJCvoRnJbRz
	 Ewdn2a0ljlHRpk4QRwWTWuNSOu5e8xXd6XJ5rUtQ3hBBUkc+Y6CxyCuNjfcEuwKnesfbk
	 qbDUZoEr75m5zLK7rWBnOblhjEBvbxBi00FyaK72G3M4xe1AOJiXXVjxG7z2LcmhPAJx2
	 dR7ADu+5zVn4L840D3M5W69HjwJIG6nwNeys6rd+I4v3e6QB1ORcFBGVbB/MGGOPWDA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794205534;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=SS8g3kngP0h1kM7qHXzzyWAS56jyqJKHO8SoAqpqAok=;
	b=zFXhg0P7NC6ZgwKB3cOWAwmD9aPs1cnSMvS2KS0yEHjk6w6aO47Gdmx+/DenedY5Cbdu
	 qBIWYvLACzNV2Q+I5mkPSCNIrHqIrD45YTE5yiUH7MRlRxnl2q8b63CIFaEbV/SZo6rrO
	 vlk7kMb3q5cDgVTuWYEDrXaIlL/siMx5jJIYwfzQ21U5oN5qGrDHNoZE8H1QM0lzt4z5g
	 Pf+sLraTGcpBgxAYuSRwrk8u3ODzYlzeH51F1wHJ1CKql2/0pB3LSMGnyRIWQPHnK4fgc
	 Q0P3Ga+cI3V1TaHzOd19OaokVtW1lF1AsDOocV5Dt4LZK7ysq8L8L+pn9kmgJvN48RQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NezfhAJh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38931606A321;
	Mon,  9 Nov 2026 06:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NezfhAJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E2CB1F0089F;
	Mon,  9 Nov 2026 06:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794205533;
	bh=SS8g3kngP0h1kM7qHXzzyWAS56jyqJKHO8SoAqpqAok=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=NezfhAJhcuPPoZ5uDTjRITe2eGcHJUAF5PkX47h8ZfDi9I8nlGl23SpePXGMr4eDw
	 v/X+YIDRs7qPt1WDa8fYRIzhloB9Mri6WJ7Tz1Kj40V3APso4rkyTkSiozfm0a7zop
	 /6BsP7wvJvwN/afUvHrgLWz6PpX3AOr4qSwzusu2pxN0TlQYoRsfKSLJlkrD1vprS4
	 kmDNfgFP1e/eoIqCuH+f0oLKvedP9Y6lx3Fd2SRQW7x9p95G4QYqlRhlN5Ba0WukxO
	 bV4Dj3zd/TCFJiucR2yNV5VKSH5wtgM68SzqeJBOo+ewtOENF+3vlSzl7ivKgF/6LL
	 ZdFY4/eYqlfig==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Fred Griffoul <griffoul@gmail.com>, linux-coco@lists.linux.dev
Cc: Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
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
In-Reply-To: <20261104183754.10457-1-griffoul@gmail.com>
References: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
 <20261104150322.3516320-7-aneesh.kumar@kernel.org>
 <20261104183754.10457-1-griffoul@gmail.com>
Date: Mon, 09 Nov 2026 11:55:23 +0530
Message-ID: <yq5apkwettbg.fsf@kernel.org>
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

Fred Griffoul <griffoul@gmail.com> writes:

> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:
>
>> Device resources such as PCI BARs supply PFNs directly and cannot use
>> the folio allocation path. Store the mapping owner and device ID in the
>> core context during attach(), and use them when preparing device
>> memslots. Keep device memory separate from ordinary PFN-backed RAM.
>
> The device rules you wrote down in api.rst and locking.rst helped a
> lot. If I read v4 right, the device backing differs from the RAM PFN
> backing in these places:
>
>   1. PFN mode calls RAM arch hooks: kvm_arch_gmem_make_shared() at
>      conversion, kvm_arch_gmem_make_private() at fault, and
>      kvm_arch_gmem_reclaim() on revoke and release. The device path
>      has to skip them.
>

I would say that the VFIO provider expects the conversion to complete at
conversion time, rather than being triggered by a fault. This is also
required because, when an MMIO validation request completes, the guest
expects the range to be mapped. The current flow is that the MMIO
validation request exits to the VMM, which uses set_memory_attributes()
to convert the range to private.

>   2. lookup_pfn_range() only feeds those hooks, so the device path
>      does not need it.
>   3. The host mmap and stage-2 need a device memory type.
>


Do you mean this code? vm_page_prot is used for the host mapping created
by mmap() on the guest_memfd, and its setup follows
vfio_pci_core_mmap(). I think the only device-specific difference here
should be pgprot_noncached(). Shouldn't the rest of the protection
remain unchanged even for device PFNs?


+	if (gmem_provider_is_device(gi)) {
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
+		vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
+		vma->vm_ops = &kvm_gmem_device_vm_ops;
+		return 0;
+	}
+


For stage-2, the architecture-specific fault handler should handle this.


>   4. In PFN mode, a conversion to private only updates the attributes,
>      and the guest fault maps the page later. CCA has to map device
>      memory at conversion, because the guest validates the mapping
>      before it touches it.
>

correct 

>   5. The device provider needs lock()/unlock(), the private range
>      summary and prepare_memory_region().'
>

The TSM checks that there are no private pages before issuing the unlock
request.

>   6. The provider gets the VM and the vDEVICE binding at attach.
>
> Would these changes to PFN mode be enough to drop the device table?
>
>   1. The arch hooks take the frame attributes. For RAM the arch does
>      the RMP work. For MMIO it skips it, or does the RMM work instead.
>

IIUC, this is what the patch already does. Or are you suggesting
something else?

static int kvm_gmem_convert_attributes(struct inode *inode, pgoff_t start,
		pgoff_t end, u64 attrs)
{
	const struct kvm_gmem_backing_ops *ops = GMEM_I(inode)->backing_ops;

	if (ops->convert_attributes)
		return ops->convert_attributes(inode, start, end, attrs);

	return 0;
}



>   2. lookup_pfn_range() stays required. For vfio-pci it is the BAR
>      start plus the offset.
>

I have to admit that I did not understand the need for lookup_pfn_range.
It was called from the reclaim path, but we did not have reclaim
support.

>   3. get_pfn() and lookup_pfn_range() report a memory type (MMIO) in
>      their attributes, next to read only. The core mmap and the KVM
>      fault path use it.
>

Yes, this should work.

>   4. A conversion calls an arch hook in both directions, and the hook
>      can fail. CCA maps the private device range there.
>

As kvm_gmem_convert_attributes() already does in the current patch?

>   5. lock()/unlock(), the private range summary and
>      prepare_memory_region() become optional ops for any PFN provider.
>      A provider that moves RAM between guests needs them too: it has
>      to order its moves with conversions and leave private pages
>      alone.
>

Isn't that what the patch already does?

static void gmem_provider_lock(struct gmem_inode *gi)
{
	if (gi->provider_ops && gi->provider_ops->lock)
		gi->provider_ops->lock(gi->provider);
}

static void gmem_provider_unlock(struct gmem_inode *gi)
{
	if (gi->provider_ops && gi->provider_ops->unlock)
		gi->provider_ops->unlock(gi->provider);
}

if (gi->provider_ops->prepare_memory_region) {
	u32 flags = slot->flags & (KVM_MEM_LOG_DIRTY_PAGES | KVM_MEM_READONLY);

	ret = gi->provider_ops->prepare_memory_region(gi->provider, offset,
						      size, flags);
	if (ret) {
		fput(file);
		return ret;
	}
}



>
> I'm less sure about 6. Could KVM ask the provider for the vDEVICE when
> the memslot is created, passing the VM? The provider would then not
> need to keep a VM pointer.
>

OK, so you don't want struct gmem_inode to contain struct
guest_memfd_device, or is the concern limited to struct kvm? I'll check
whether we can move it out.

-aneesh
