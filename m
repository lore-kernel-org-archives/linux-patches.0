Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793731023;
	b=RQWomfW9lABy1I+oLdgGdij8wYAqkJAIXdyPratilhDD5LwZbQGB84Y1ojj8ufzXcCzW
	 B/jd9jmRwxV7mZt8r9kHIEhpCV2mTv2CgA7vS1ADGfFtTqkhmmPX3PP5RDsZhCaEDs6za
	 agh95NbsMgYi3BVKrANyPIyWBgrGdUILLGJlv0oYTOUjGj5kW2un9KJKupY1woh5SDUMF
	 crfNi0s2MMLwLbao6iwOKcZX45H/BOm/vBfhrDDCwifgCnWrLqpSU1HZHV7WZ3m66uLmK
	 9QYDEyOghodpqAwtuvKP6cyZa1hdBAM+abBzHiESEVuazJgrnmJBKKeysZ90HPBVFkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793731023;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MtYqIPmCoO6r7ieWdDjT3mJHSPCz3ZeRLZvBXwBPxaI=;
	b=zy/n5O6240lGiV0fox6/K96S7OLPNIx39/V00QmrYFVxq8LOUo2kA9lllLryg+PxG61m
	 xJCJ7hjXy5f3yvqUkIeHCuG/Ce0hzmfmyn9XxF8SUAKLXknsbJyKpr4l1FrTpf0JWDs7O
	 M6mPV7b5eqHtN8Xzo4DEyh4R9cEoMYY+MgYfzbBXsEwE1nYC2Ux+swONNy/1pvJ/cfb+S
	 zR0WIRE8lFjqHgGSkLywC2nvK8pYyt9V2//NOdyLmI7eFN/+yvc5Gl360pggMYJEIq42I
	 LMujwTmmyiDCqemvMQbIqP+K8wE32ESYGww1O4Wq0ybPocUE8WtYzOf1y+ezEAhghEg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=otCiMlty;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B22B9606A326
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 18:37:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B22B9606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=otCiMlty
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a5b2be99a8so29167165e9.2
        for <patches@lists.linux.dev>; Tue, 03 Nov 2026 10:37:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793731021; x=1794335821; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MtYqIPmCoO6r7ieWdDjT3mJHSPCz3ZeRLZvBXwBPxaI=;
        b=otCiMlty4cQJqNIUbrLyItvDj08/Gw4KeYPqne/UyeKRDY+g5SDKadzQ7uhTHDyxj9
         guQdKMfSsoeiGVFUgg24JJYfQ9ec43Ca/FEAH9zfNso1bUK/f3Cv+FTYx/ZkwkREa/Bm
         XkPn9ZIj446bqIPa25WDQya97CbHcCB1OjnYAH4vfnvem8AkXAymgQneAYaEGniZTKue
         AwGIRieIOz3il1WWbwAU52cqX/e5m2oOLgYtNIoiQrWIFooBdHfspaeg/F/dfOBKgC4P
         dJgqJm0ISSlTnAKrPrt/Zex0XDrHndCRGScMV+L4ifKwwkt8T9lVV/yYFY01Uf4cAm3e
         Phyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793731021; x=1794335821;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=MtYqIPmCoO6r7ieWdDjT3mJHSPCz3ZeRLZvBXwBPxaI=;
        b=A3qu5TO9Y2pi23yt/XSUIqzCQl2+zginx7W94CwjdY8IhcYA2QnMbp9Mp7WJSCpmtl
         MoqPuSsX9UVhPpAoZAUZ4rtHGcD9C7AOnE+JmdiMYbfMuVXxDox7b0e1YMAPhu+Ly28m
         4loROItZ2+BdUGVYu8malIVr9+csPv5SfZI9DzD+cGybpHaoc/TRv3kSLA66i28Pmz/n
         91Qs0DtMmx7CukwpsITM+0r2IefgGZz7r2MjFlacMKN+vC77uuqiE2+CwM8oYsVzYfnB
         IJ8N4yZn0PDezyo5whvqOaVWsx22Hu6J3RYHnmsnrxy6f+fdBcn5Rx2sllwgGv7M6Q4m
         lPEg==
X-Forwarded-Encrypted: i=1; AKwUvBz3F2iiAWfFNYuhKePsEDggyx6kULelm0nPEJMsN0pckJXQXaIsdaKkJW9bkdaQ7CqH4PSF7jDa@lists.linux.dev
X-Gm-Message-State: APuU4Z/3fThzO7CuJ257SL1P4IS74JuHyhsEN1S1gJalaE6WJt6UpMpq
	X4o4A7yTSpmzzEsCBSAPwuUreSnYORSbHj4oNw5ZI/383c4MA7oJJ4lS
X-Gm-Gg: AYBFou3OCrjPrxSI/BVC1NJnHM9jhiI5Ql+sswCy1xUhVmcRGo/bB3AZ6LxH7ZgcnTg
	kCcHyGrv5In8yeGuS4NrecuYbORRvK40Irz3RxE73FcoucvwFiCy40EeJAPm5u82tj9YShCv5UZ
	K/83CP97yqMsWjKkjbBH2xDYDei3DbvOgR+p+TG94xRCxP6KnUX0gUB1wPfzYboXvRwBeonxDlv
	sO29E0xGCJxChD3XmlyLPniXlhlbWqvvu14t9T1GoRDHNb+mt9QPjxiNt5HdJsOw56uXL2aLdFx
	pRrVSNPt2drlwBO2d3WHCis9mLV8nqjOFK72Tz++jjhaVEhSh7sMTjIW5hpG27q9gcNxB6/EaFm
	CsQzoSeAtDx95Qvy33jUGLKCdz0Oi0CetwdFgOlzwS9BSREW7omezyaK4nFDXOvLUs4PfcJlxY7
	JG/8PQrYImcGV2a9gQYWJ5LyQduOlE1sQTmveq3NW8IJZoNTlN8KU5s2NgWk4V1rtURl+xjimnr
	fKbP91yHZA3tvXCqmHpzf4KwlIql77xPHR+0+JaEdJMtoHyKT3SR80pnSQQ5oflgoEylrELmDp+
	bKsddrtb6mccllcBiaTjhJluOyXzC9zLzg1e3gJ3uHw1EFTBhQ647E7F+W2p0Yrd9a8C1wKA851
	a/flLACOwo+DJVG9/LACI6hlsUETblsThsD0zjxoH9skpLAmBTWSS1TUu7A55c57YlQ8jY/kBJb
	kGIg9COIryLmM=
X-Received: by 2002:a05:600c:470d:b0:4a2:191f:7cb8 with SMTP id 5b1f17b1804b1-4ac1899378bmr308379315e9.17.1793731020767;
        Tue, 03 Nov 2026 10:37:00 -0800 (PST)
Received: from dev-dsk-fgriffo-1c-93421965.eu-west-1.amazon.com (54-240-197-234.amazon.com. [54.240.197.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71b78a1dsm25588404f8f.24.2026.11.03.10.36.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 03 Nov 2026 10:37:00 -0800 (PST)
From: Fred Griffoul <griffoul@gmail.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev
Cc: Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
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
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [RFC PATCH v3 00/13] KVM: guest_memfd: Add a common framework for device memory providers
Date: Tue,  3 Nov 2026 18:36:59 +0000
Message-ID: <20261103183659.82433-1-griffoul@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
References: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
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

> This series adds the common guest_memfd support needed by device memory
> providers. It builds on the resource-provider API [1] and the existing
> folio and RAM PFN backing support.

Hi Aneesh,

We both build on Ackerley's PFN mode [1], so here is where my export
series [2] stands and what I think it would take for the two to fit.

The export lets iommufd map a guest_memfd file without pinning it:
iommufd looks up the frame behind each shared page, and guest_memfd
calls back on every change, so the IOMMU mapping follows conversions,
punch holes and provider revokes. In the next version, the lookup
only uses lookup_pfn_range(), since it runs outside the invalidate
lock, and frames carry attributes (read only for now), which Ackerley
has offered to take into his PFN mode series.

Your patches 01-05 fit well with this: the backing ops table is the
internal provider table Ackerley's base left as a TODO, and the export
hooks stay in the common paths you keep. I tried my series on top of
yours and the conflicts are mechanical.

For device memory, I see three things to align:

1) lookup_pfn_range(). 06/13 makes it optional for device providers,
   but it is the only lookup that works outside KVM's fault path. The
   export needs it, and 07/13 would benefit too, instead of calling
   get_pfn() page by page to find contiguous runs. For vfio-pci it is
   the same BAR start plus offset as get_pfn(). Could it stay
   mandatory for all PFN mode providers?

2) The memory type. The IOMMU needs to know a frame is MMIO, and a
   prefetchable BAR may want write combining, which the fixed
   noncached mapping does not allow. A frame attribute, next to read
   only, would carry it to KVM, the VMM mapping and the export.

3) vfio-pci for ordinary VMs. Today a device provider needs a realm
   (kvm_arch_gmem_device_supported()) and gets the VM and an RMM
   binding at attach. vfio-pci is probably what will make the case for
   PFN mode upstream, and that is easier if it first works as a plain
   provider for any VM, x86 included, shared pages only, with the
   realm parts (private conversion, binding, lock()/unlock()) on top.
   It would also bring back P2P: vfio-pci refuses to attach while a
   dma-buf of the device exists, and with the export iommufd can map
   the shared BAR pages through guest_memfd instead.

I'd be glad to see v4 posted, or I can wait for 7.4-rc1. I'll reply
to a couple of patches separately.

Thanks,
Fred

[1] https://lore.kernel.org/all/20261022-gmem-alternative-providers-v2-0-5dd1dc6c660a@google.com/
[2] https://lore.kernel.org/all/20261027154649.91571-1-griffoul@gmail.com/
