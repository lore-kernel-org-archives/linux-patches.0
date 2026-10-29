Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793285098;
	b=s+dixC2kidzhXlCoBsOe0KrywF0aNtOfLW4xH72PVMcJR98LBj+WhMGdVlXlQ74gEe2z
	 ZXbUnkZYL8AySuFKkXQFxuyNx3e5V7tDd4AQ64X2+BZmreC8/KPnOuiFiCknkjL9EjkB+
	 i61XGm6D42cFNDSO9l7b9eqHB+V1YRfpFTWMW/kTVqRnW+5chl2smqH5qHDTVXKyUbsrP
	 h8j5lk8LJ2KhAARi+5yZ+SeShOrsyLXSqeC5IvNCxK/AtFG5I1KGCRv1pAxse42w7S5uX
	 4h9n+qt65BFV78c5DAh5/9ORcYwaUJ2yPM7i/a2yt04nezCb6mf7Tws10H1A+oevHeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793285098;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=Mjl+ShVIlCaGoshBGxSH8zD+Sbyo60ZzNSNREUds4Cc=;
	b=Hs41OtJA9O7dxvd2mkZS9U+PffYEWi5HsaKSNQgsu+h5jF+V6SC5qfkwugPjr6odtpYk
	 gP6rFV8tXmBZgvR6XO7MY4PwUMTjG7qc+EB7mYXw6RtGc2HGguncnlXTiPULxMisk37k5
	 m+/DMYc4Wqg1zhLU6ueeDDSxzqU6sfNdaIXtGNJ0OUq2XpubIQ3GNm+28shx9AmkTQlOl
	 QrKHYYRp42T5tOuNXV1prkD4UzJ9y+qSIvdQ++RaxLx1LGzwfdS2GGYeQeapdC/q0krhI
	 pRgB2I6fYro6eLzB2/LOmCnicNLsqvzjfFy+zvYlnEgQQLHE6paPPct1m2VBK3XaUZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoNyx8WY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 283E4606A32C;
	Thu, 29 Oct 2026 14:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hoNyx8WY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29DC31F031E5;
	Thu, 29 Oct 2026 14:44:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793285097;
	bh=Mjl+ShVIlCaGoshBGxSH8zD+Sbyo60ZzNSNREUds4Cc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=hoNyx8WY4+9zizzeohkQQ9oWfFSHuWY4H/EcNHlrJtsJj5e+Gw3yNiPvPUbBYlgEh
	 mk7cHe3t6TM19lpAjbM6oRkUpvNIvrMRBi0nJsaJdehyoIY2IE71iN+cmO48i9c7md
	 KYYQ5dmfydaVL3bOZ+WUIrvoftRxEIpWEvBkRRCPzwB1diIpmYPpOrtCZZ8g1Inv+L
	 1fxn/V1PIMX7Ejp63Rm7Nzdl85TI91nGdh/Dm+8VIvNdsBe851pa3ltQ1m5Bg7PxM/
	 3yQK8pvmdfXocM7y4i4fyxggHx75ZZ3h/0KpXuKFZ1X+OGHQWVmde8TLDiGYY0oLCP
	 WzH4N85mS25XQ==
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
Subject: Re: [RFC PATCH v2 00/13] KVM/VFIO: guest_memfd support for device
 MMIO resources
In-Reply-To: <CAEvNRgFb5zLkTph_9k3io=7UD6S-j3QPnjE3qVTvzeGZxEJSHg@mail.gmail.com>
References: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
 <CAEvNRgFb5zLkTph_9k3io=7UD6S-j3QPnjE3qVTvzeGZxEJSHg@mail.gmail.com>
Date: Thu, 29 Oct 2026 20:14:47 +0530
Message-ID: <yq5ay0bga7mo.fsf@kernel.org>
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
>> This series adds a guest_memfd device-resource framework for exposing PCI
>> BAR memory to guests. The intended use is confidential device assignment,
>> where KVM needs to coordinate private device mappings with shared access
>> through VFIO. The Arm CCA backend is provided separately; these patches
>> contain the guest_memfd, VFIO and IOMMUFD interfaces it uses.
>
> Thank you for this revision to guest_memfd + VFIO support!
>
>>
>> The guest_memfd framework and Arm CCA backend are available together at:
>>
>>   https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-gmem-backend
>>
>> Userspace creates a device-backed guest_memfd using the ordinary VFIO
>> device fd as resource_fd, with GUEST_MEMFD_FLAG_USE_RESOURCE and
>> GUEST_MEMFD_FLAG_INIT_SHARED.
>> The resource mapping superblock selects its
>> provider; get_pfn identifies PFN-backed memory. Eligible BAR intervals are
>> registered as guest_memfd memslots.
>
>> File offsets use the existing VFIO
>> region-offset namespace,
>
> Yes, this is great, thank you. I think we should have guest_memfd and
> VFIO share the same offset to PFN mapping.
>
>> allowing one guest_memfd to cover multiple BAR
>> intervals.
>
> Yes, this is an advantage I see of using guest_memfd to wrap VFIO too,
> instead of requiring separate memslots for each shared/private range.
>
>> The device-backed guest_memfd fd rejects mmap and fallocate;
>> shared guest faults obtain bare BAR PFNs from the provider instead of
>> resolving the memslot HVA or allocating folios.
>>
>> IOMMUFD resolves and pins the device's existing vDEVICE after its backend
>> validates the VM association. Its MMIO mutex coordinates conversion and
>> device state changes. VFIO supplies BAR PFNs, validates eligible ranges
>> and excludes dma-buf exports while a guest_memfd provider is attached.
>>
>> Without GUEST_MEMFD_FLAG_MMAP, attachment rejects existing VFIO BAR VMAs,
>> and new VFIO mmap calls. With the flag, existing and new BAR VMAs are
>> allowed through the VFIO fd. Attachment invalidates existing BAR mappings,
>> including huge mappings. Subsequent faults use base-page mappings so each
>> page's shared-range attributes are checked separately. Mapping the
>> PFN-backed guest_memfd fd remains disabled (We can decide on this later).
>>
>
> I saw your other email regarding how to handle read/write/faulting
> (mmap). I still think we should have all these be blocked on the wrapped
> VFIO fd and have it handled through guest_memfd.
>
> The gmem_device_host_accessible() function in this series has a comment
> that explains this, which is that the shared/private attribute is
> guarded by filemap_invalidate_lock() in guest_memfd, and so having
> providers call back into guest_memfd is probably going to cause locking
> issues. That's also what I figured when I was trying to implement the
> integration with the sample memory provider in [1].
>
> [1] https://lore.kernel.org/all/20261022-gmem-alternative-providers-v2-45-5dd1dc6c660a@google.com/
>

This series uses a trylock to avoid that deadlock.

static bool gmem_device_host_accessible(struct guest_memfd *gdev,
		u64 offset, u64 size)
{
...
	/*
	 * Keep guest_memfd attributes stable against conversion while checking
	 * host access. This check only reads attributes, so a shared lock lets
	 * other access checks run concurrently.
	 *
	 * VFIO callers hold memory_lock, but conversion takes the invalidate
	 * lock exclusively before taking memory_lock for writing.
	 * Waiting here could deadlock with conversion. Try the shared lock and
	 * deny access if it cannot be acquired.
	 */
	if (!filemap_invalidate_trylock_shared(inode->i_mapping))
		return false;
                ...
}


Isn't it much easier to have the provider gate PFN access using the
callback provided by guest_memfd when sharing the PFN, rather than
supporting every ioctl exposed by the provider fd through guest_memfd?

We should probably also get feedback from VFIO and VMM developers on
this. I wonder whether they would be comfortable switching to
guest_memfd as suggested here.


>
>> VFIO BAR read/write, ioeventfd and userspace mapping faults check the
>> requested range's guest_memfd attributes.
>>
>
> Thanks for calling out ioeventfd, this is one other backdoor to possibly
> access guest-private memory. To avoid calling back into guest_memfd to
> check shared/private status, I have these suggestions:
>
> 1. Treat the ioeventfd setup as yet another "mapping" alongside stage 2,
>    host userspace, IOMMU page tables. For IOMMU page tables, guest_memfd
>    will have to do mappings eagerly on conversion to shared since the
>    IOMMU cannot handle faults. We could also "zap" the eventfd-to-VFIO
>    connection on conversion to private and "map" the connection back on
>    conversion to shared.
>

I am not sure how scalable that is, since each new provider would
require another set of ioctls. Also requiring the VMM to use guest_memfd
for PCI BAR access in CoCo configurations and the VFIO fd in non-CoCo
configurations adds unnecessary complexity on the VMM side.


> 2. Take a shortcut for now and say that if the VFIO is wrapped by
>    guest_memfd, always block ioeventfd setup.
>

I am not sure that would work, because every CoCo configuration has some
BAR regions, such as the MSI-X table and PBA, that are emulated by the
VMM.


>
>> This series depends on:
>> * Ackerley Tng's "Allow guest_memfd to be created using a resource (pool)
>>   fd" RFC, which provides the tmpfs resource-provider API:
>>   https://lore.kernel.org/all/20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com/
>> * The IOMMUFD/TSM series, which provides the vIOMMU and vDEVICE interfaces:
>>   https://lore.kernel.org/all/20261008055955.4014342-1-aneesh.kumar@kernel.org/
>>
>
> For easier testing, is there a VFIO sample we could use? How about mdpy?
> Is mdpy representative enough for selftests?
>


All my tests use the full CoCo device-assignment flow with kvmtool.

-aneesh
