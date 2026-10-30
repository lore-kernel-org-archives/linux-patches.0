Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.180
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793400299;
	b=H//etXp2GttDXvjiI70hnjQKEEtzCB+kDRZd1xAYhQJOA8XATuyUELpbABRvzLomqIlV
	 Dm8yFGCejSzKjcUk2NnnKpCAgxHSjGmuQuJ29/rKqSSlTSBEE+TppitfBJFXu3W3U9W5Y
	 84Z2Vm/CeLRDicUBOLSlHBExt6GDhhk1xA2mtEzhmDy2HpirqpjEDgAVJq9h1I6Mp3hFV
	 LcH49DEc+2OG+n1Nu2q9h7Y9G+9059a053PGBcHd+7+evYkyLjAVPcHjxlA8BrmrAQ6kh
	 /7y2BWjMbavBE6PRLAOXnKWYL+cmf+frpkyckWZ8CzoAFLr+Vccp81Ek/NUByQW5TIQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793400299;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=NYbItPhQApEJbZKga/APWqgHEBqrEwP9FLrG/rlKxD8=;
	b=LoccafT+6InQqxafIuXCyGp+ABFvgQPZguaG4dNUpEdtKhRAerrMGlUf8bRP5ER77Lki
	 9gLO86BsGLDN6VkZPBugJpUmVMyVbLssMi/3F8g59t1vpBg//95j4hLtfVdlkL8RwziBy
	 4XgN6ue131M7xbQB5Ee8BhnOE0wcOSQeSZcK+kznug8D0B3Ryw67oHUsJ8oKOU8izLu/J
	 iwW19X1JfC3cJ+gHd0QjhA+BdHjBgPB0VLHnYv4XBvOGDxAY4wYb9KJ4rm4115IwUJ/Q1
	 NMAhB0un+4GU7/GyMuTqCfZgrxeg/MR2Ea9FAieAQa7CVhWBBsJg71pkrC0pA5o7nvQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AQlexJGn;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.222.180
Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7FCE606A31F
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 22:44:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D7FCE606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=AQlexJGn
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-93f30660e69so91703285a.0
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 15:44:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793400298; cv=none;
        d=google.com; s=arc-20260327;
        b=YHO1ocac2Anfq6S/wLr4WQq+rBt2K54tzv3+FNmkzdiGzj5A8AkmtAGpW3JiA5bKeM
         GYOKXIfXdgZXwvU0FzV/4RNTkeN4soYf279/v+c0SQuAh3LNNLWLJF+vS3LQIpo4+st3
         gZSZgXiRppW5uI1rLYkaFCWOUskO13vCpS1tOZOyCId4sBGr1Vw+NyoMM3jHGmRz7kKb
         CW+oyU54P202W8HzBDZVgl5g80/qx1dTbBXEVey6WYC47ooEq3eHkYAjf2FoOKdzs8GO
         WpqOy0YVR3PiVjY0whZ7tfijyDCcWoIhU+5niXrqN8OTLfS9mezfh1LsITvkK0IYpOk5
         JUbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=NYbItPhQApEJbZKga/APWqgHEBqrEwP9FLrG/rlKxD8=;
        fh=+ciU4vHRZww9jZLAWHZFzUjMz3fjncYOQnLobt82eXo=;
        b=FU2XYsN7rbx3ciRvu4pu/arAB/GPuLJJkvlwXElczr71rCLilIWT7PUDdjLne4nkVg
         d/mK0s+eXlLyr5D2q7B7hIwqIYRjo4b4dxY4G65II/EWUA0HhSIzSdyI12eicPHt5hy9
         /DaWLXYvbLX10yPgxIUQrQdIwa9NzHzf3XnFZQU0aY2getiLlNH3aBlShoJxDe//3dJP
         ibiVbtPVMkV4utbFhKWjL+l9jHDPDVLSxyjoOAHnqAn3noaeU1wfGiL9ll3wKgitWyuz
         JyyqNksh+5fvTdovnwXfYbIp46X8567HQKRZvWwEBkv1WnesCvXNiqCT2gnfPkK1goWu
         1ywQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793400298; x=1794005098; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NYbItPhQApEJbZKga/APWqgHEBqrEwP9FLrG/rlKxD8=;
        b=AQlexJGnqwgyK/J4WlzIYgsBi6ad2vrDlfymYN+RjMFh+nTd+esYMCCyX2jg16e0sD
         JDRfhf3391NK7UA/tTzJeBNOOz4QzeH9eYj5jK4ZVEWqooiZUUm3vdGYfT4KX+sR5cV2
         CUseiC5PmwDrKnURHzkqVaUxgQNIj+eMY6lWV5kEcgeGM4eFU2v68RiodxidZxf4u1m0
         rywaBQdgrwOfeL1IMjiIEWdkgteyAFFToGwcqz+ZXydYkEkPyMtWMU3LZeSDwJMYvQBw
         ytoBWbVlMN/hWeyMeK6kqGVSipM0Ar+c5MsFst5GuQINqeCh02iVqUcj2YlKs9LP+9oQ
         Tqtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793400298; x=1794005098;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=NYbItPhQApEJbZKga/APWqgHEBqrEwP9FLrG/rlKxD8=;
        b=R6nOBEoyekTAJLMRP+GMyvVQXVsm2eQOHkH/SWPNeWMtj+aaY9sa/7aZqXW9dWZfv7
         yIqOXaRyE1yLOWxs1yXBW8t3VSHhIa/CGWV/I8y3VylzMwRntzke3/jpebGhPj/ggCpr
         Ozc8mhM4bXWOyHhQtfbmcEzj8prvjbMwHVeB+sF+a/vAmAxq5QpjHZX/vcHc7vUgW5MP
         V7PmBMSisLQQBkZpSQ53UGRDKOcg1mdxyqhpoCP4X5QoJiMxCp7pooyZx3zUHCcEvrIf
         xdiNuR7wytVfuxGw9WD9772owdei2Z9rTbmZNN8HbUuY2hb+ged/d7GCwob4R8lwKf8a
         wUSA==
X-Forwarded-Encrypted: i=1; AKwUvBwTPlYA/OJ5yPyjITmzniplrrvcL3djo8uBJE/EQJzZGTwQlaavhIpg92F4hexkWntGMId3LXZb@lists.linux.dev
X-Gm-Message-State: AFq9FYJfDrwY2YZgUjz92QWfkuczsdfYeikOOUaFOKyc3Hb5ieQpzLWQ
	PXcRiMhvDvttVw1Ib+A8CNlWaJ9nd28g3RWjK2VUuZphmnCDrFxiZykLXTvcbaDXofkDQLtDynY
	yGrEMagDZ1vzWVOH50yLV6cLHo4TghgPW9xEUuETs
X-Gm-Gg: AYBFou1z7MXWACF/JixiYY7t6N3zJ4HbCPdvSkJsrUY8uLtc+CW6jbY291xqKozB1+l
	YM8xXtmt6lZi3fOJJn+MbAJovNz0nF1qJUooQNK3+vH0vW73FEJ2up2qwZLP09mTjx+IDvNhIwo
	TV1xygThZA7qFTerzhadfVegllV1gdgCTCVUN0+y1d5KrsTHjqq1ZIxVhCg9yaAQCLRCxceGQNF
	JpcG4fS4OIE1DvPQ65YpLXtwXj7QtemZSfnjX3zEzRKXb+d38VEMdO8S+M+ZPPt7rDx4n8IeFf0
	9czBP8YghIHskUxNiHezHW91DFezNtMzX56108Xr5JT0D1HRu/20n4EWnpPGZCVM/QE1erRwoBU
	urkI1CHPwRIB0tHB6/QVTrxfUw1Lo0bkTN6eOHiaMxwjuFootiBTDgRQwX0AKVaO5bJBkWesjL1
	6zdhop5KyhFsrXxUHWHiSi6nw=
X-Received: by 2002:a05:620a:4594:b0:93e:c12c:4409 with SMTP id
 af79cd13be357-944217cece5mr652996085a.69.1793400297298; Fri, 30 Oct 2026
 15:44:57 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 30 Oct 2026 15:44:56 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgFEKqVZcNYCL0LpB6BTyBFe+ot1x1nFfEqOrSTsu134PQ@mail.gmail.com>
References: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
 <20261017073149.1303738-3-aneesh.kumar@kernel.org> <CAEvNRgEh3E7NBc5_3Wq66Fss-mAYT6+4FWP5+=Co6+OVfVnQQQ@mail.gmail.com>
 <CAEvNRgFEKqVZcNYCL0LpB6BTyBFe+ot1x1nFfEqOrSTsu134PQ@mail.gmail.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Fri, 30 Oct 2026 15:44:56 -0700
X-Gm-Features: AclHuK9AHtuqcVSSdHgG8WAhHla8voZ5Eh8lYfAwHP3Alygt10O_4piQhjU1tlA
Message-ID: <CAEvNRgH5TH8MDaRQaVczv4m6fJZKVmf=MtKzhmHs_px8+r=8bA@mail.gmail.com>
Subject: Re: [RFC PATCH v2 02/13] KVM: guest_memfd: Support private/shared
 conversion of device memory
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

Ackerley Tng <ackerleytng@google.com> writes:

>
> [...snip...]
>
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
> Can we make the flow that userspace is required to do the conversion
> request from userspace after an exit due to
> RMI_EXIT_VDEV_VALIDATE_MAPPING, and then just do the delegate + map +
> validate in the vcpu_run completion hook?
>
>
> The rest are a little outside the guest_memfd field, but I'll make the
> suggestion anyway.
>
> It looks like delegate and map don't need the vcpu context, only
> validate does, so validate has to be done in the vcpu_run completion
> hook.
>
> Delegate needs the host physical addresses, so we'd need to translate
> the IPAs to PAs, could that be a VM ioctl? It could look up the memslots
> and translate IPA to PA?
>
> RMI_RTT_DEV_MAP also doesn't need the vcpu context, IIUC it does need
> the VM context so it could be a VM ioctl too? If it looks up the
> memslot, it'll also find the guest_memfd, where it can find the device
> information.
>
> I'm just thinking that the vcpu_run completion context is doing too
> much, and there are so many possible errors that could be better
> communicated to userspace if they're separate ioctls.
>
> Or perhaps at least delegate + map could be one required ioctl call by
> userspace before doing vcpu_run to continue after a
> RMI_EXIT_VDEV_VALIDATE_MAPPING exit.
>

The delegate+map actually seems really similar to the
KVM_ARM_RMI_POPULATE ioctl. KVM_ARM_RMI_POPULATE already calls into gmem
using kvm_gmem_populate(), which can do delegate+map, can that be
reused/extended as part of RMI_EXIT_VDEV_VALIDATE_MAPPING handling?

>>>
>>> [...snip...]
>>>
