Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793282931;
	b=5MEqeTfUetTKsNdT77XgyQQgCSRtaBTcpeszgponvHQ1mtrKtUS0OhdB2I9xWjTNsudu
	 KayEsswGYB7XGdFPSUr9SwJ9WEMv5VEVc+L483ZYhiMlIz0aelFPw82UgkXfY7SVzhpWN
	 63FrJGCzfWuQUXub6UF9Rnpelbv4BpwgaD1sENZHBnXpH0P8pa/6saDRsxyXBMSh0n/cO
	 5Ok83GLzFgcEX8QEyHyurjkNdXxKxGp8uiCo2WfNaHAi+9BylSXU9zrtJ03Dat8bn9Nxq
	 AQVgQIEvfAolKewSzx7+Tg42o5+Qgmrq+kzGoI+CIZIEYCvVtaX2vUIytwjlBVBQ7Wg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793282931;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=H7Sot6fFV/mqoa6U1RpNz1ThNjxhsXi7WSqRiEBh7pk=;
	b=EIuSdeQUsHhE7bgJzlI9yrhkMz5IERBI0C5Zos2BTiQENhFdpF7Wn4vBihHogMvvHCpi
	 2ISf6+UMuAwlQpbbG8qABFLHsZXNidyjMyAgBT0D3Ur1qjUbv7KnStNz94wZ9iJOCU4Jd
	 FUcM8WWQ9qUgTFFPHDUmP08lV3SZ3rRedCiShX7Wc18DmjzRp7mxxQ2+X4q9Nan8vLNJa
	 RJLlwI5j66wpd9mDTucWtiKj1Sy1Pp5TJYUDw8/JQnGQTDOs1vmJoBkiH8Ykm3enep/q8
	 p7z67Mxb7QsBAT5yDCv8GC+jUwTcCjSK3psOSH+PqSFc1wO4gEdjTFv8HevjgSab4CA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UKPeO9+2;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.52
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8836606A31E
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 14:08:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8836606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=UKPeO9+2
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-91c7a706b1fso10437396d6.1
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 07:08:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793282930; cv=none;
        d=google.com; s=arc-20260327;
        b=aisNo6VAotWXu6Mi2W2umGfY6h7tD6vLRsIU/b5n10l7xTrQBCBnogeQ/1miBvHB5c
         N6qaBNNqaPwUdffKBxF5e9rskQ9/Z6faTkKUfTMN8tZ0tW0CRc8whckdwcgLlCLyotp9
         TEOzXjv95lwJmqN04215SO46/so0JcDEeHy3RgRi9sUbKkmlwEF1x9tSx/4jiGzI840L
         kM8UQNClGO3+Ep2jHM9iDaV7wAZ64RAzKS/HlRTTMH0PSzoGRFleaYzm6S0YtYauUkNq
         oun90vukVMZ6d0vBGKN/7QQq8aLP/ugwEa3ACSbwgQHNRBfamRI9MnhBDjE6W+x7WyCs
         kSqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=H7Sot6fFV/mqoa6U1RpNz1ThNjxhsXi7WSqRiEBh7pk=;
        fh=xWM+ZidqsnmY24j/49pvxZlisOG7zD/Lu9ou1X8EgBE=;
        b=gABDzqaYFJPiulocki3qLADFZFa+qmaH5SxigPesM9wLBiTq2FK7JzrDVQmSBkx2/r
         PHcyz79RkywKmziWUjMc2pqgPugEJm+vPOSF8QGGlLANYEaUkFOYTVeJSel+nq35bQBJ
         ObvEL+JUL1RWwXcz67rLHoyeK4kPB2KEg2pH1vYof4vPLizLmGRrxa0b3/TqPD3LZFhv
         8dPg6Q6rPzITYxcVZAwmfqWuU3xz2TJnmI54OrwSQFCQNzwzjf6pn+1bjsBDHUPHD4+A
         WH0tNiUt9VJTPXWOB/5eQaK+RnItMdtGbQ4sJLl9IIdaqRp0bOC5FHyTEyTlMcRa3iPP
         quTw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793282930; x=1793887730; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H7Sot6fFV/mqoa6U1RpNz1ThNjxhsXi7WSqRiEBh7pk=;
        b=UKPeO9+2qc7xiP4MPR/7cBIz6CgSwDcTHk45ktToipsszvxPHPiYYVGrSoRIEsYOKU
         yYIUyssYdajaP0O1EwL1yGuyxeVszaFRgMqvjX8eBPT2JHtAkbYe1rFqa9KXjCcpw2x8
         R9BCKatTJWQ12u7STYp8MgIywDsCnxTKlDdYyy1ssXR5RPPDLFnmI0vS/ZFO5xwr+Tke
         9YedEadMsVQhl6mRgcIi7Al38f4wOuA/sJooJuiTpoZzzXvlHcdvIuCrjORUBK/zV5He
         KHxVsz8eHJZenkpFoIjQesAuAmJvnc3UG00g2gASZwaQIgUE/h+ufl5rsYsl+gy7OEbW
         IoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793282930; x=1793887730;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=H7Sot6fFV/mqoa6U1RpNz1ThNjxhsXi7WSqRiEBh7pk=;
        b=bYiEkdMfibbj7f7YnkWaEcjxRHOGxzjBmoNu2flsR7SfrZSEi/cNxebf+r9tEKxMC9
         7HAOdHOwMwKjIQWvic/7mWEqmUrfLQNgzM/WeT3tXCC1DMvM41XvgJbAYm8A9ilUaNTd
         i2YxNUndpMYe4eNa/KH+p1bVL+ulR5EwiXp1Vc4UF/f4TaDvc7QDulS+71t/ZGGUGuBj
         cASGtz9Py8SU/kiASsM/YaStHHEdKZ9JxW+xgVgNLFY0YH0QVbtwienMntaIrTGqYuvX
         CVXTo7ujvJhC2kxbhzgluP+4rYzvuNyTW9I8+CDxTNoWCvMsnEvUuKiBlU4hxhIjhJXj
         ++5g==
X-Forwarded-Encrypted: i=1; AKwUvByCOEMn9feFgdyiA70q2WeXZwdYugxe+JlaACDEHe1UvyQ4zIeCyp4GUlwZazP8RmjQalL/3UQc@lists.linux.dev
X-Gm-Message-State: AFq9FYLwmfdDmvfl0vDQUgN/AXEXsgeci3qceOT7E47HJwWpm9BnvrmP
	9pmfKlZKZ1qAW6uKXzzOPlEdQeD0NaJz/Y0X432EL61ME2GXj0ORaDxws7Kz1hYriXX5ePQyUJ1
	UKvx/yugpZHMd+HpqUUGwwF+BB21xLdjGiKFap5e8
X-Gm-Gg: AYBFou3O3OxopUW4/pC/JxkBStAsxm+/nrowYvqngw7Ec9fcpQh+GcxWCdHyT93Edu2
	oUWAi/jiOYQld9RiT0gsXBGHexsh9NgrO+DeM4C7y4qlvdDj9Y6u0S+fTkIgGZQop0JX4tlt2Rs
	ncTFEcyrNckQb3mmZxM1IVZZLv0UBuqUcH5qbLlBpZl0v0AQ4yh5jguzo8ctdQGFSXdp/p4Um1d
	1/fAp/KnUY+jH0Zn3Ub9JqgnYLx4vHRbrdfdReNVCnCiHrGBHlmG+WQ5uSe0kstP8//FyhjLW5D
	qLEY7iV5wxEdWNTkdTLDXc5DyM6W/MLudun7aP15Z+8pY+RL/bZcjWN4Ox1u7wqpn66jR6bO5M1
	tL63wITOPbRJdCPFddlQjFGnj3q67n/f99NIqGDizJx3M/4oflez1U9erTbkyVvzVew==
X-Received: by 2002:ad4:5dc3:0:b0:917:9703:48b5 with SMTP id
 6a1803df08f44-91c90742c32mr40775726d6.26.1793282928607; Thu, 29 Oct 2026
 07:08:48 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 29 Oct 2026 07:08:47 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
References: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Thu, 29 Oct 2026 07:08:47 -0700
X-Gm-Features: AclHuK_fk7ikZ1Ry_rR0lNw1rkr7m6j782yki2DT2D_WNr6A4h89KzpbSsJWlnU
Message-ID: <CAEvNRgFb5zLkTph_9k3io=7UD6S-j3QPnjE3qVTvzeGZxEJSHg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 00/13] KVM/VFIO: guest_memfd support for device
 MMIO resources
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>, linux-coco@lists.linux.dev
Cc: Alex Williamson <alex@shazbot.org>, David Woodhouse <dwmw2@infradead.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
	Kevin Tian <kevin.tian@intel.com>, Paolo Bonzini <pbonzini@redhat.com>, 
	Robin Murphy <robin.murphy@arm.com>, Sean Christopherson <seanjc@google.com>, Will Deacon <will@kernel.org>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Fred Griffoul <griffoul@gmail.com>, iommu@lists.linux.dev, 
	kvm@vger.kernel.org, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:

> This series adds a guest_memfd device-resource framework for exposing PCI
> BAR memory to guests. The intended use is confidential device assignment,
> where KVM needs to coordinate private device mappings with shared access
> through VFIO. The Arm CCA backend is provided separately; these patches
> contain the guest_memfd, VFIO and IOMMUFD interfaces it uses.

Thank you for this revision to guest_memfd + VFIO support!

>
> The guest_memfd framework and Arm CCA backend are available together at:
>
>   https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-gmem-backend
>
> Userspace creates a device-backed guest_memfd using the ordinary VFIO
> device fd as resource_fd, with GUEST_MEMFD_FLAG_USE_RESOURCE and
> GUEST_MEMFD_FLAG_INIT_SHARED.
> The resource mapping superblock selects its
> provider; get_pfn identifies PFN-backed memory. Eligible BAR intervals are
> registered as guest_memfd memslots.

> File offsets use the existing VFIO
> region-offset namespace,

Yes, this is great, thank you. I think we should have guest_memfd and
VFIO share the same offset to PFN mapping.

> allowing one guest_memfd to cover multiple BAR
> intervals.

Yes, this is an advantage I see of using guest_memfd to wrap VFIO too,
instead of requiring separate memslots for each shared/private range.

> The device-backed guest_memfd fd rejects mmap and fallocate;
> shared guest faults obtain bare BAR PFNs from the provider instead of
> resolving the memslot HVA or allocating folios.
>
> IOMMUFD resolves and pins the device's existing vDEVICE after its backend
> validates the VM association. Its MMIO mutex coordinates conversion and
> device state changes. VFIO supplies BAR PFNs, validates eligible ranges
> and excludes dma-buf exports while a guest_memfd provider is attached.
>
> Without GUEST_MEMFD_FLAG_MMAP, attachment rejects existing VFIO BAR VMAs,
> and new VFIO mmap calls. With the flag, existing and new BAR VMAs are
> allowed through the VFIO fd. Attachment invalidates existing BAR mappings,
> including huge mappings. Subsequent faults use base-page mappings so each
> page's shared-range attributes are checked separately. Mapping the
> PFN-backed guest_memfd fd remains disabled (We can decide on this later).
>

I saw your other email regarding how to handle read/write/faulting
(mmap). I still think we should have all these be blocked on the wrapped
VFIO fd and have it handled through guest_memfd.

The gmem_device_host_accessible() function in this series has a comment
that explains this, which is that the shared/private attribute is
guarded by filemap_invalidate_lock() in guest_memfd, and so having
providers call back into guest_memfd is probably going to cause locking
issues. That's also what I figured when I was trying to implement the
integration with the sample memory provider in [1].

[1] https://lore.kernel.org/all/20261022-gmem-alternative-providers-v2-45-5dd1dc6c660a@google.com/

> VFIO BAR read/write, ioeventfd and userspace mapping faults check the
> requested range's guest_memfd attributes.
>

Thanks for calling out ioeventfd, this is one other backdoor to possibly
access guest-private memory. To avoid calling back into guest_memfd to
check shared/private status, I have these suggestions:

1. Treat the ioeventfd setup as yet another "mapping" alongside stage 2,
   host userspace, IOMMU page tables. For IOMMU page tables, guest_memfd
   will have to do mappings eagerly on conversion to shared since the
   IOMMU cannot handle faults. We could also "zap" the eventfd-to-VFIO
   connection on conversion to private and "map" the connection back on
   conversion to shared.
2. Take a shortcut for now and say that if the VFIO is wrapped by
   guest_memfd, always block ioeventfd setup.

> This series depends on:
> * Ackerley Tng's "Allow guest_memfd to be created using a resource (pool)
>   fd" RFC, which provides the tmpfs resource-provider API:
>   https://lore.kernel.org/all/20260925-gmem-tmpfs-backend-v1-0-d36159822d18@google.com/
> * The IOMMUFD/TSM series, which provides the vIOMMU and vDEVICE interfaces:
>   https://lore.kernel.org/all/20261008055955.4014342-1-aneesh.kumar@kernel.org/
>

For easier testing, is there a VFIO sample we could use? How about mdpy?
Is mdpy representative enough for selftests?

>
> [...snip...]
>
