Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794217252;
	b=cw1Tw32ZSRhbduYODumsneFEbUQazAcNfeHjGCP2htClUqqxqxULPg5C9kkvlhQHKQ52
	 2DD30Rg+gVQYweAew1mIccfr6gCB9DWNvyX2PqwaebbAcmJs07gyp0pdTBT5sMbgnQvFs
	 byaE5pzDayFx2yvlqvVFsYFr/m6t+2sIkseRIegj+CympMax0xVFcHLGNoo75Jnq1k4pa
	 nCZNAhvYiVPj+9rL7gsQglP/dSxgYspHpxJvZuIXtwOkNSm7J01jScbh5QDVKj673/zJ8
	 9eA0f7EEwMTjWKBPTN/y/rSDlS0cOSwLK1J/E2eS6rV96wUSdjl+kYG0xaLQP1jILRw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794217252;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=XpJVqtXGRVn1elHP4O9yUrO0bCUpsQD5MQPAcM2JVcc=;
	b=ZY/myUhAOVFEk0PTM9VKukG9+R8uOimEdk7WboQWsJcc9MhwoxzSyBAVT5xNZ8VXK+r/
	 kPD0/OmYFO5MF4+EtjJQxsFKPGljHnDe3WEniMoxqnaNXJtNGacWYQzw9jTvtuNmfjCY4
	 duVUEsrnv4h/E5EYoUsW2RAYGx1luv1Hc/Zi19fM56j11MnJOFbziRf4dFSdf+KWVBv8d
	 SS8kDJRQ9bYU9GwtDV2619jfXg4bUKAkL87DcLqTmuGXQtJLNaWFqbDYmOGTXoe376qfy
	 Zzmf7NQwrBj53u1ril/zYA8syK6g+hTMXa0S4PbCEVaGoG+J9+sxDksDwNRtBnP2lOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZNTNv5wW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E232A606A321;
	Mon,  9 Nov 2026 09:40:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZNTNv5wW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF9571F008A2;
	Mon,  9 Nov 2026 09:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794217251;
	bh=XpJVqtXGRVn1elHP4O9yUrO0bCUpsQD5MQPAcM2JVcc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZNTNv5wWK7nnfG6wv+W63m5aMOEEQxK3zEw7kZDbgJn5GkjfXRY5IqWTe6BJv//Dx
	 +nTxT2goIpIgum8IyIueDmq2egm/eS3hGTHeMqEpZnLEZ1/SmQNWailBnF9JUGpMtW
	 VM/BCJeumeZOUYtxCHs/Br+l67VPe8sgz5Hla0sbbFPRhm5eosSPr+i4+YjM+RH7IF
	 47vTv5puXn46+KWDkI1zmxASoJauaFoikb2K3nS3NzQwdKBvJ/pIGxXBZUVV5yLrFF
	 6qc/3uD6Qf/qdyiH37ZFKYr0PqbLGU50aLqsdnkGoEHMLXQQfgRhCYAivcEas254YS
	 RURHpKrHNs5Jw==
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
Date: Mon, 09 Nov 2026 15:10:40 +0530
Message-ID: <yq5amrritk9z.fsf@kernel.org>
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
>   2. lookup_pfn_range() only feeds those hooks, so the device path
>      does not need it.
>   3. The host mmap and stage-2 need a device memory type.
>   4. In PFN mode, a conversion to private only updates the attributes,
>      and the guest fault maps the page later. CCA has to map device
>      memory at conversion, because the guest validates the mapping
>      before it touches it.
>   5. The device provider needs lock()/unlock(), the private range
>      summary and prepare_memory_region().
>   6. The provider gets the VM and the vDEVICE binding at attach.
>


Your KVM suggestion below prompted me to take a closer look at
eliminating the distinction between kvm_gmem_ram_pfn_backing_ops and
kvm_gmem_device_backing_ops. This appears to be doable.

> Would these changes to PFN mode be enough to drop the device table?
>
>   1. The arch hooks take the frame attributes. For RAM the arch does
>      the RMP work. For MMIO it skips it, or does the RMM work instead.
>

We discussed making get_pfn() and lookup_pfn_range() return PFN
attributes. We could define:

#define GUEST_MEMFD_PFN_READONLY	(1ULL << 0)
#define GUEST_MEMFD_PFN_MMIO	(1ULL << 1)
#define GUEST_MEMFD_PFN_NOEXEC	(1ULL << 2)

We can then use GUEST_MEMFD_PFN_MMIO to drive this. The attribute
conversion then becomes:

kvm_gmem_pfn_convert_attributes() {
          gmem_provider_lookup_pfn_range()
          ret = kvm_arch_gmem_convert(kvm, slot, gfn, pfn, nr_pages,
				    pfn_attrs, attrs);

}

For RAM PFNs, there should be nothing to convert because
lookup_pfn_range() will not find any pfns before they have been faulted-in?

>      
>   2. lookup_pfn_range() stays required. For vfio-pci it is the BAR
>      start plus the offset.
>   3. get_pfn() and lookup_pfn_range() report a memory type (MMIO) in
>      their attributes, next to read only. The core mmap and the KVM
>      fault path use it.
>   4. A conversion calls an arch hook in both directions, and the hook
>      can fail. CCA maps the private device range there.
>   5. lock()/unlock(), the private range summary and
>      prepare_memory_region() become optional ops for any PFN provider.
>      A provider that moves RAM between guests needs them too: it has
>      to order its moves with conversions and leave private pages
>      alone.
>
> I'm less sure about 6. Could KVM ask the provider for the vDEVICE when
> the memslot is created, passing the VM? The provider would then not
> need to keep a VM pointer.
>

We can pass that as an argument. This is also preferable because it
avoids storing a KVM reference without a clearly documented lifetime
rule.

-aneesh
