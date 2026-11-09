Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.43
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794262813;
	b=q75OKXJ02QYr3zs2Xg/L6PbxoB3uqEpXC9BLMDaDyi9SLAtHlG4q9U0BFgrCw6JSGNvB
	 hj7jLHmciH1CRenY+Mzy7zEEkxxW7HGiyG71SHBO4lU+0RSIs5GguL5nG3CabBb2BQyTx
	 +fTnHSBxdJCrQL9aoa7qkQH7vilV7xCbZJYuX6Ivc85u0O9nLdt9ZsK++tng0U5UAFS8V
	 kjZYi1xZh29JUmrHBhkDzu3KpIehPWHsE+f82dbTlf7yClnJQ3SDxGzEOq8OGmCY1kcD3
	 eyYkhsozY6SlSgSlnR6sY1aajMIb3K0o+SUdXkd1WrZr9PBNarmql0HW1XDnf4yMLOQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794262813;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=KfoXHxmDBEItkaa6hcxF0A8t0fZTG3DLVeoM83AlVUQ=;
	b=FgUecV/O9LCTGQ/gUcdwHHQ1UYcJMeXCwkjr8euu4snL1V4loFNQ9sARBY+jnx9+LYny
	 HLD6flS6grDIWT/vfH23QbcCSLGHmX9H4clz5+xZ65NxadPM6QWQeGxHZ1sFPbeBn894j
	 P9iA1Wg/wNOGN/9ZKOEGryuVzQaBmGImvNgNkw31khJ5GwpGVsjLY5q8JLGeRMI2sS4Bl
	 JlpnnhMfLRbn8GW1qe9bdadBPCp05OUv5Gp8xX19knU7bjz5QM135JDWPZPJ1+GZrC3f/
	 rDcDhyQGlf6AMbLRS/rNY9Xb9Tx45y5+kMEIS2sEcE181mAwoIgQwfS8ydjB9nheIJg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WKNV4H1x;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3286360A260B
	for <patches@lists.linux.dev>; Mon,  9 Nov 2026 22:20:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3286360A260B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=WKNV4H1x
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-91e98301805so14130446d6.1
        for <patches@lists.linux.dev>; Mon, 09 Nov 2026 14:20:13 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794262812; cv=none;
        d=google.com; s=arc-20260327;
        b=aIGyRjtcI6rP4cHaq/mo+Y9FTgLjq9OQWKxz5xy/OsERZAfWeadZr9QQosytBCJJb8
         QCrJ0huRBUVWtWxLYh790dXKtXdIFR2WKCin2fahKmHb8gHgcvEbIA1+PaV8ycqixppe
         Dzm5Ne9Du/XBhN/08diS070X+4mR6HnkPtgnh1QJFyfr+jYvbXlHEMSKZr9mGY3z3e9w
         nu+iy9PMJOZhNBAQj008JXJlxyTgI1DAq2v8ztJPBk30FKk7fVl+0bPvUPoixXr4hxb5
         DdHAJFzOVtAOROzX5aL57PzXEJp/LP+Ai34mGMC1EVZ72Fpc6VqV4gmEe9pEvjK/MtM/
         nLqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=KfoXHxmDBEItkaa6hcxF0A8t0fZTG3DLVeoM83AlVUQ=;
        fh=MA4mh5zol9w+Z++QpaKn8pJOwUbxKb2yZP8f0qY/Oeo=;
        b=byqcDIdDJb7XYoW2+9SqIVVzvRJIMa1j8bmL83VnO17MXj6YAEWgTUVuhEHi/QmG9R
         qszkXrPBZ7TROE+wT5LvEB3OR5jdb2jUQ3sfAosnenqeMV/O0Bc9PDFtG6+8FeU2m9j3
         l2RN8bshZoIQTlnK8dEoV3jaQ2IOboq9FVTK0D6ITd3p21IgLOAiS5O4d3X3bSU+z4oU
         nJTadGgO0ZUq7dRqihZny6zzJ1EAWf8aiMfdwzZ3Q67E70vSQLOQPOWo7GdBgkbsuNSh
         jZy6jfykWtIXh1syiFn6wJjYrkJgx/rXKULkRCxQk9SsccYdshQoP/Vsq4ESXLT3wakS
         0qSA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794262812; x=1794867612; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KfoXHxmDBEItkaa6hcxF0A8t0fZTG3DLVeoM83AlVUQ=;
        b=WKNV4H1x/tAD+zTkrybKKlp64hrXZod/25kQICYaVl6bVkQDQr8Tm6IE+YKcQIbiST
         KOJoixTwN9ykt+RCk3Md5tHCgTdIC568HgkfHpDB4Xn8HwUxcd2hoVJgbGHyWXUlxdkD
         59j6bRVN5HHHYA94CigNvelAoUUw1IkM0AGOIejgqbeauduJuOdZ5BOyc44AyL9OQvDT
         JStZOE83iIXm3H+QkV4q128JP1AJjPbeCDndRuu12wRBATzH6z4Z7wSFVhi3iySU5l7m
         PecoKqN3zKPQkwGVFvRnuy2JnnmHrDOFgYInLfWmKvpF0QcABSC9YiURY8T7ljEvYT1H
         Wi6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794262812; x=1794867612;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KfoXHxmDBEItkaa6hcxF0A8t0fZTG3DLVeoM83AlVUQ=;
        b=BXJUHUMnxIJ0B/kt5Ui6yNS9yupuLtpkV/DxhGWbxipN8OAnNVEkdJnCC05/6dlu7c
         90Z4iaWBhKx4RP/C4nlpAXfwZ+KvD/Jz54R9njQaj9Lv8LcO06Dpc8P2s9g3veMystfV
         UZDKB0cDa8YvdRK+J7ghAFhxJ5LktZiRl6ztpe5bmslbTDLP33JjMixZl5SwrVus0a6P
         sou2gjK56dPvMuAhGbjs4mfRkzS8Xw4+J0HMXQsWPsfu2LaRJEOhG6JlYx/Gh9VpjG3M
         9GuKa/I4v6MZvaPr0B1NZ4ygT+tN+VNk+4aH8PFHFJNXy9e6bAlj+uvAGqIbUQnlydNg
         UoYg==
X-Forwarded-Encrypted: i=1; AL+hErHFn0TO9ipALGZpWUCp6S5t7htiJRDEm/hkqKz3aXDgpDp2NYEPFxLCg5jehBMQ/wjHCMqsHfrJ@lists.linux.dev
X-Gm-Message-State: APuU4Z+26sSkbt5EsaKVMOOhorP8fYshgifMafmlABpzvHhT1Cs1AsNl
	mjOCloHhP+2OxYl5El8tzcbz2FmZVvEkNRsiU2TTRFkDf4Z+EZLW5T6gMAQoIsy0/ICvSvZjdQQ
	4BWNi7Yl+aoPNB42qJT3gpUdHPTF654O42SuznqPb
X-Gm-Gg: AYBFou2cHXGbGIrvNZBOaSvVXiM8T8vZzsz07pZV8sG57/8y/YunK0wL3KnRVHkvTnS
	wyo2ikw+MD4MqBMaOT/+rd+7SNGSlFG0XoDujEaLTwQa/Han8N08fgueijfTM8MpCIRT1VwoXhS
	dV560/jIoaZKQF517oBZ6DG3EHKn9Mhh+fkpYL5fLoNB/whfxP18D2n9FKKuEDwktH2ErAqjO9z
	j7t86Qr4TWpPvxaqi9gEIYLHpaC/XJ2bj/czOE9iB3NhxRVqxvvGDKzSFTxZss46r45mCcw0V+J
	laNp+U6lLLwOlnj/YGkPN8jg9Ezz30AV2NNbZLQjEdOXeloaRzyE8BN9xWrs5cCml/SmbbjgJgq
	bar3AhH/jUbNB2ZgRTZADPD3bx+U01jNJ1A4qs+N0S97eJS+qgTMwMoiLxVVUEptrx7o/mBOrdq
	r3t7nknDML+6R9ZqRP734mol4=
X-Received: by 2002:a05:6214:519a:b0:91e:a3a7:eabe with SMTP id
 6a1803df08f44-91eef7ed59dmr16998506d6.31.1794262811011; Mon, 09 Nov 2026
 14:20:11 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 9 Nov 2026 14:20:09 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <yq5apkwettbg.fsf@kernel.org>
References: <20261104150322.3516320-1-aneesh.kumar@kernel.org>
 <20261104150322.3516320-7-aneesh.kumar@kernel.org> <20261104183754.10457-1-griffoul@gmail.com>
 <yq5apkwettbg.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Mon, 9 Nov 2026 14:20:09 -0800
X-Gm-Features: AclHuK9yaZZX5RqlQUphUJAHyVgMZuWE0tyCGC8w_purOOnnuK3ITj8aYHc0AWs
Message-ID: <CAEvNRgFE5=u8Q+fCUxLT7M_gAjkgNddSVrM3axuTUxBScffcbQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 06/25] KVM: guest_memfd: Support device-backed PFN providers
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Fred Griffoul <griffoul@gmail.com>, 
	linux-coco@lists.linux.dev
Cc: Alex Williamson <alex@shazbot.org>, David Woodhouse <dwmw2@infradead.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	"Joerg Roedel (AMD)" <joro@8bytes.org>, Kevin Tian <kevin.tian@intel.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Robin Murphy <robin.murphy@arm.com>, 
	Sean Christopherson <seanjc@google.com>, Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, iommu@lists.linux.dev, kvm@vger.kernel.org, 
	patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

Aneesh Kumar K.V <aneesh.kumar@kernel.org> writes:

> Fred Griffoul <griffoul@gmail.com> writes:
>
>> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:
>>
>>> Device resources such as PCI BARs supply PFNs directly and cannot use
>>> the folio allocation path. Store the mapping owner and device ID in the
>>> core context during attach(), and use them when preparing device
>>> memslots. Keep device memory separate from ordinary PFN-backed RAM.
>>
>> The device rules you wrote down in api.rst and locking.rst helped a
>> lot. If I read v4 right, the device backing differs from the RAM PFN
>> backing in these places:
>>
>>   1. PFN mode calls RAM arch hooks: kvm_arch_gmem_make_shared() at
>>      conversion, kvm_arch_gmem_make_private() at fault, and
>>      kvm_arch_gmem_reclaim() on revoke and release. The device path
>>      has to skip them.
>>
>
> I would say that the VFIO provider expects the conversion to complete at
> conversion time, rather than being triggered by a fault.

guest_memfd currently does .gmem_make_shared() eagerly and
.gmem_make_private() lazily (at fault time).

Technically conversion time spans everything from guest exit to request
a conversion, including the guest_memfd conversion ioctl, then till the
vCPU run completion hook.

Can we move the mapping out of the conversion ioctl and into some
dedicated CCA-specific mapping ioctl, kind of like KVM_ARM_RMI_POPULATE
but doesn't actually perform writes, just does mapping?

The mapping ioctl should check the necessary prereqs, same for the
vcpu_run completion hook.

Here are some advantages I can think of:

1. Decouples mapping of VFIO addresses from guest_memfd and provide more
   understandable errors for userspace, since the mapping step has a
   clear and separate error (conversion is complicated enough with many
   failure points)

2. Better aligned conversions in general where marking private at the
   platform level is lazily performed. In this case, doing it outside of
   the conversions ioctl is not much lazier, but slightly :)

   Not quite mapping, but Suzuki did bring up that for regular memory
   (not VFIO), ARM CCA requires vCPU context for SMC_RMI_RTT_SET_RIPAS
   in .gmem_make_private(), hence that's done in the vcpu_run completion
   hook, so that's kind of lazier, relative to doing
   SMC_RMI_RTT_SET_RIPAS in the conversion ioctl.


> This is also
> required because, when an MMIO validation request completes, the guest
> expects the range to be mapped. The current flow is that the MMIO
> validation request exits to the VMM, which uses set_memory_attributes()
> to convert the range to private.
>
>>   2. lookup_pfn_range() only feeds those hooks, so the device path
>>      does not need it.
>>   3. The host mmap and stage-2 need a device memory type.
>>
>
>
> Do you mean this code? vm_page_prot is used for the host mapping created
> by mmap() on the guest_memfd, and its setup follows
> vfio_pci_core_mmap(). I think the only device-specific difference here
> should be pgprot_noncached(). Shouldn't the rest of the protection
> remain unchanged even for device PFNs?
>
>
> +	if (gmem_provider_is_device(gi)) {
> +		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +		vma->vm_page_prot = pgprot_decrypted(vma->vm_page_prot);
> +		vm_flags_set(vma, VM_IO | VM_PFNMAP | VM_DONTEXPAND | VM_DONTDUMP);
> +		vma->vm_ops = &kvm_gmem_device_vm_ops;
> +		return 0;
> +	}
> +
>

What do you think of just forwarding .mmap to VFIO to figure out? This
makes VFIO less special of a provider, since I imagine different
providers may want to have different page protections or VMA flags.

guest_memfd just enforces VM_PFNMAP for PFN-mode providers.

Here's my forwarding setup: [1]. In my proposed control/data-plane
split, the vfio_fd undergoes VFIO_DEVICE_BIND_IOMMUFD with
VFIO_DEVICE_BIND_FLAG_CTRL_ONLY to become eligible for attaching to
guest_memfd. Data plane for vfio-pci == BAR supports mmap, so in this
setup, the vfio_fd's .mmap() would always fail, and the gmem fd's
.mmap() would just let VFIO set up whatever it needs.

[1] https://lore.kernel.org/all/20261106-gmem-alternative-providers-v3-61-8484dde66a7e@google.com/

Wrt the page protections, in my setup gmem reports the cacheability so
the KVM MMU can use that information to set up the stage 2 mappings.

The provider can now set up different cacheabilities for userspace page
tables vs stage 2 page tables if it wants to.

(At least that's what I intended, given my limited knowledge of ARM)

>
> [...snip...]
>

Let me catch up on the rest later :)
