Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793817477;
	b=WCwQmK82uL9gWgnQutPgHCj7+3RbY4oWa2znP4JtTj67SO5/XJTXylmZqy3A+9PhZqXu
	 UZ5CNv3gwpl+onlhI12uYORfGOEB9VBxEdvzrKsHPIQnxhdWSEw/pO3sT4tcmTPQMYlDr
	 Z67dpDNWc5MG1RHlayAGoPgHw62/vMmWlmSdHs9cdJnWCNn2q4O+v+jC6np2x/u1i7/5K
	 vjviPnYF/1xwMx4Z8U1wEz1tPIHUWACDy4Mqjmsv3ar4UkYEb9p9Z74y4sJ9vtDsznG4M
	 gbKFR+HJSwE0D0yFJA2ld/ROR4265EK7HtuEKhkWIE2egBEYDlpULgvq+uKZ0EOMlLQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793817477;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zP0FWmOJm/guqpM9jttc05RQpe78thW+WHjsEUvp+/0=;
	b=rwWBLsIG0H5EhSuf5TzieDEXV3hatijnd/O7QYvEqJxjHW6oYw3YmgAOaUBdCqfy3Gpx
	 0AxkQuozYNaONH9QtR+MM0FdwOXLHzoox7hDOW/ejqQb7IgOh60l16qu3XVNLnaOualvc
	 qVasT1IasHdrilufzw93q5cQ5D8tjLre2qubSMk6pDSK5V/gxxTVhXESoQdL2pBM0gUor
	 +83REJ9C5sK49ZyGbKXZwoBB+BmyYfP4nMrrAdKNULTVVIh1i3vkDTFHn95IddglGOZQb
	 +xQ94hlO5xF7Tp+EfOUYbieHnUjN+Mm0wg+HSibP5iApOkJ+ZVmQwccBTeQ7StaO7aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=id58xR3y;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E644606A32F
	for <patches@lists.linux.dev>; Wed,  4 Nov 2026 18:37:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3E644606A32F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=id58xR3y
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4b467581b98so7647385e9.0
        for <patches@lists.linux.dev>; Wed, 04 Nov 2026 10:37:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793817476; x=1794422276; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zP0FWmOJm/guqpM9jttc05RQpe78thW+WHjsEUvp+/0=;
        b=id58xR3yXof1mgYZ/P5jHRLMSpf9YnAWZ5l0v6P0qr032vgjfhX0MCmf9beKiq8SnG
         Fs/36SndlYpSdjfcQj90HTont983Bn33aZ9gBsgKQ5juK3a1aoZ7dVEZtmpHczoygnuF
         aGPjvAog3VDTA4DBZG7CIaH5vDMUAO3TeBFe/BuxgsIuSQ588lbzeWGRXubKKQ1DUDK0
         P2fkSmzV1MBa2wsQSisua0yV+9hozRsTtv69yGmpCFHtWDAkwIx3jlpeJ7uBtTzZUoh6
         z6bdAA4YVN0BjWSvAQPuVjO3xQd0QF8NQsQfZphGg3C0946jWq7/f030ZPcimSa2QNJM
         dpFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793817476; x=1794422276;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=zP0FWmOJm/guqpM9jttc05RQpe78thW+WHjsEUvp+/0=;
        b=O2oTbllLhMTnwRkTagC/J6iUI5oeJ9Vinr9TqH1LkFqudfl9AZUWP3bGGsN6cC+1lx
         hMCpaVwdIR44iTnQqb9OSfvEDHQVWZIbdRtK655weAt/KTyVztqiFcm6OxzjQd9qrUAI
         0MweXkHRJLJ7R648ri8opmiZPepbvQ0KMqTaDbAYEdtejZ44W4nF6yP/UfR5yELEsvK9
         pXW9U8/aFrXtKIoU+gaRzgsh0+IEWqRyowE2OUSnBWndg8DTGijbebswZEaISlj9OhbN
         bm6JS/sY5uderEYguN09VFHKrbCXHVPaCva6Si7Btv4oBOsXlOwrqGpP6lED0+3O11yc
         0xeA==
X-Forwarded-Encrypted: i=1; AKwUvBw6s6a1e3rBMj5oX51pWpMYaukBTQJhEowErID20Uezx2pqmgRbFGQni6ICp3TNg/uiDI967N1S@lists.linux.dev
X-Gm-Message-State: APuU4Z8OmvKrUBwyTrZ+gBh7dgUfyY0G9KYWZxIMIzQ/DHw8Lg76G51H
	OsqebGTKMrZ+M5puwCPa6VKCZojb6lSKOXq8Q5PCZFQgV6fl6amD6keD
X-Gm-Gg: AYBFou37dpgu8+INCuTn/Mz693HlZ3VsDVYE5v7i4szXXh2jPckeWFmwPdBBwd+CRCy
	Wd7eQ4xYipqksW2T0igehDBjerlBzbmHDrcmsk3qfipVT2fgP746faJBaicgpMAPlOjAkeGtnFy
	2i+UcibLt8S42USxFWaMeeXOGsoHLsfwgj52G3GXMhUHW6tV6i8w/LLNX94uftHzvI4q0v6eUUn
	GieN/LbMuAlsTd65h+51NQbpCvkqICsPD4qGTACgFPY8Anf506vPL5hJIKB9HdUftGjiX2cygKn
	XTjKp1Dw3bqRx6902/cZ3hMv4sm3XKd7nV5/WJ9bZ3TGtXXYaJdpmr6NXSR0CRwx3mKuCxjMMG2
	z4vULOgsifr/0VJqxHX6kBsmglijBn5/KGPv+P0TBmIenIm+tPU7Q0brFLjQLiy+zCTB05BGXk8
	POVn664yeEPe6KeIdw4/h8lOzDQm5/KK0b07AktKBcYo01f3wSsl/sCXm1EVHbdHTqDmFpsmwNv
	c+3/o3XYWgtShoh3XRalp5TO9LvpPz9yXuuCcRaZ5Ydqz8O2gx5Gbi++fG/NW7eGe1OJQ5BkpWX
	ISaegWQKDRZKQ1EDuhanLLVaDkIKFG3Ymo9DHa49mqd8ZejdOKDR8UcB+k6PaVl9qtmoJG3Fnt3
	IVAHYewLBBtPFa2YoprhxMcB6g3WwD0f0ImAewLgbbmiiIPn5CNSC20//wUhPDD5ryQ==
X-Received: by 2002:a05:600c:8b85:b0:4a1:cd83:b23e with SMTP id 5b1f17b1804b1-4ac122897a8mr438143715e9.0.1793817475572;
        Wed, 04 Nov 2026 10:37:55 -0800 (PST)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b56fca22e1sm4198665e9.14.2026.11.04.10.37.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 04 Nov 2026 10:37:54 -0800 (PST)
From: Fred Griffoul <griffoul@gmail.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev
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
	Steven Price <steven.price@arm.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [RFC PATCH v4 06/25] KVM: guest_memfd: Support device-backed PFN providers
Date: Wed,  4 Nov 2026 18:37:54 +0000
Message-ID: <20261104183754.10457-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261104150322.3516320-7-aneesh.kumar@kernel.org>
References: <20261104150322.3516320-1-aneesh.kumar@kernel.org> <20261104150322.3516320-7-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:

> Device resources such as PCI BARs supply PFNs directly and cannot use
> the folio allocation path. Store the mapping owner and device ID in the
> core context during attach(), and use them when preparing device
> memslots. Keep device memory separate from ordinary PFN-backed RAM.

The device rules you wrote down in api.rst and locking.rst helped a
lot. If I read v4 right, the device backing differs from the RAM PFN
backing in these places:

  1. PFN mode calls RAM arch hooks: kvm_arch_gmem_make_shared() at
     conversion, kvm_arch_gmem_make_private() at fault, and
     kvm_arch_gmem_reclaim() on revoke and release. The device path
     has to skip them.
  2. lookup_pfn_range() only feeds those hooks, so the device path
     does not need it.
  3. The host mmap and stage-2 need a device memory type.
  4. In PFN mode, a conversion to private only updates the attributes,
     and the guest fault maps the page later. CCA has to map device
     memory at conversion, because the guest validates the mapping
     before it touches it.
  5. The device provider needs lock()/unlock(), the private range
     summary and prepare_memory_region().
  6. The provider gets the VM and the vDEVICE binding at attach.

Would these changes to PFN mode be enough to drop the device table?

  1. The arch hooks take the frame attributes. For RAM the arch does
     the RMP work. For MMIO it skips it, or does the RMM work instead.
  2. lookup_pfn_range() stays required. For vfio-pci it is the BAR
     start plus the offset.
  3. get_pfn() and lookup_pfn_range() report a memory type (MMIO) in
     their attributes, next to read only. The core mmap and the KVM
     fault path use it.
  4. A conversion calls an arch hook in both directions, and the hook
     can fail. CCA maps the private device range there.
  5. lock()/unlock(), the private range summary and
     prepare_memory_region() become optional ops for any PFN provider.
     A provider that moves RAM between guests needs them too: it has
     to order its moves with conversions and leave private pages
     alone.

I'm less sure about 6. Could KVM ask the provider for the vDEVICE when
the memslot is created, passing the VM? The provider would then not
need to keep a VM pointer.

Is there something in the device path that this would not cover?

Thanks,
Fred
