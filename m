Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793392594;
	b=eBTWTefBzbLZx/cEkLbwARac/7lzzQmD0fG3Z8K+u/9komjM/6OZP1K59NsbgMzv454W
	 h3oxPDVsz9wS9xwxuiam33MPIIN4BtERXNA0yj2U+sirueTK4pvKZjC0krsa4Oyteo1mc
	 EEoFGY1/xp2829VgRtfxNrlys1u3fTp872EL7Psilfl3u9ZBHD385LozgCXG3bM8ODEOr
	 u/X/qycLxa3h6e+q89hExMaBLHmlHez/hTW4KfOo3Nw4XZGfMB7XYjyTzWQo0CALN2cgQ
	 J6KnAOKfIrNQYj3Wvg+4x68wGtomdFkq/S4I3RATLMN3Pn4yGcGAriJ8vLPri+Yaouw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793392594;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=mfTTVpEW/ASHSaJiK1tCpdlPNObyw7zCk6yXHFi2rhs=;
	b=abSMKjU7zmRpm2kwFMlARFLv0h//Vtz6j1rVPnfKpyUhsWZxbEZ+eksAaZTsHfX8eu+G
	 ML/YB/74eKRO6a81mqGEa7/ifaQNEUvcCo5WE8Qgx3kWTVXD7JPWO/H748KSXULOvDSo1
	 SK6x3iqhT6SR0u69C/qwXvNNnwAN1mvQLcLh9Oq8ztSeJSGht0qRBLhRQhnL0O3ic/MAa
	 ATzfhNcuHdL9dyym14E50KmQtEnhAXzBm+dJYs89ineiiJ5l+IhwdyOFJIHJYQk92O2Ds
	 G59356tArTsAxnx8+2eVLt3Idqspg9bUzxG4kbQosaHVwKQRBX2veZHXHs33OpjO+VA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ljr244FV;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.169
Received: from mail-qt1-f169.google.com (mail-qt1-f169.google.com [209.85.160.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6459606A31E
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 20:36:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D6459606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ljr244FV
Received: by mail-qt1-f169.google.com with SMTP id d75a77b69052e-537548b811aso8887251cf.3
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 13:36:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793392593; cv=none;
        d=google.com; s=arc-20260327;
        b=p5P+agWhktfNfcLs4+35edkPiD0r5pAr/LtaLMbVA5QAOJknuPz6N3pqCdScAQ7Rdi
         GORFRloLXf65dhv9UKGqsN1VIbmu4HoUuTD6EyV0S9qYUXwqsC4epRMUVRTKMfT1CDXH
         KWOfSxeqSh7QF8rbEY+5wSV6LON7bpWZg753xjdltzTQQf+DeaDeUCceSlZH6cChMUUZ
         XSF5bjc2LovuqRF5J0NjyVUDh6OCKwjCuBdTUd6hpBY7H87xqDwu5Psu722LXjPx0+C4
         nnzKXb7yn5WHPn77beK+izhSfUNR9j8l4pI0ImXciflsmVxH+Hq5i3QYD2lpUJsrDt/g
         yV9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=mfTTVpEW/ASHSaJiK1tCpdlPNObyw7zCk6yXHFi2rhs=;
        fh=UAPIE5sP40UNVbnovAJlZHQzwDcmjWAIQfh8HFYxmRU=;
        b=EXcPzZ+JGA2ySg/U2tqM8wFVzO4P5kpUq9bEIejVPI8+Qi3s4eyDN1EwIGAsUMyazr
         17OyclZ2WXQlePWE2v2Tu8RnYJl34H+4r5P3lR9GXat+rywbicmA8L93id4B44sTgSbU
         t28VtTftnEsRnjbpinRRKY0Ok0NzMYpSOSL3IJiQUkoz5UvIrOlDI09ZFX/Wxwk49jXy
         z1xQjcgSmKwK5RvZvHXhXCoH1nKN+Z1peTVXUy5Csp74SP2Cxtm13ME8QtAbvoopDhV6
         z50DodZr08qDWqg8ljsxFKiI8RiuUK33OdkfemzSLLX9m5dg+WhfzyQKJMfbAwqYom1Q
         lwQQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793392593; x=1793997393; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mfTTVpEW/ASHSaJiK1tCpdlPNObyw7zCk6yXHFi2rhs=;
        b=ljr244FV0zDSrXiNbVAoLqifPB+jMVzc3vG/uPfdJ/v7dwnOYDPORTqZ7+odEQTFkM
         byVn6cfObCUP7k+kuyNm0AL8vz8A1DAtylNqT8SF28zA2LRiJHRoCt4Pe6h/ojC1UVj+
         txk8Vu1gTudboVkDLXsSbGys65Y+cQhn3+S4H7CtrrJBza1+Eg7pFNLMfAxG5WRZ/ns0
         Eh+STO2r31N6svsTg6mP5PVDIn2biG0oVWsiYRfkLPjtJImTuiVublGTBhmuCGKBzrnu
         6SW6SIJuNJoLH6qOROxdh9dRd3R+aPbgcIHNJ85c8BfgjoEq46bzXFZwuyDLsl9L1e4N
         JQdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793392593; x=1793997393;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mfTTVpEW/ASHSaJiK1tCpdlPNObyw7zCk6yXHFi2rhs=;
        b=fNxdcpeDs48pc4/kQg9HcPJqJsl8wxy+Xn1vVAal4NCOQfi0/c3prFgU77ofoHMpF3
         COznnHNCzR3BOTJ+WA6KwUlepFYjNokP0j528Qv0fFt69h3WWs0wQyW/PHYkkxkdBgw5
         tGCLrgI08FHUYcST+e4dUq2XweSOj99z0Hv2wUJB18uACaAwIoQl2eWVd8sBf9EJB/fI
         jGKhKM+1sTr/BK17fnGhYV9iSPwnLK510MHU76+5N/y2FlWj+rtweDRy6kO6bOIlIPqL
         dNaJSuR9LsUt4adbPzPjW6y3HtomAgywxueUm0UEDNM49/cYF4fi/xDJUvUGtdgItw1f
         G57Q==
X-Forwarded-Encrypted: i=1; AKwUvBz+6c/wbEMUUjx7XUUG5W5iFBLS5+bx3R6cAq1SYrVnimp3fqRs11pkDd5GZRKlleGj6D+nbE1C@lists.linux.dev
X-Gm-Message-State: AFq9FYKBtcXyJIG/HP6zc6QFrjBU0v4KwW5EHdT9Ewjh2W0QItJ0O92n
	MULhjosH+ok1TlHbfokqJgjaru3vV5vIFj9ub651LpAIHPtPqB3886rTO4Lfo9+kmfEXzOVzVEz
	2byYU9GE9rnvq9xw2GxIBbgyirqZ7Avj5xICpHd7G
X-Gm-Gg: AYBFou0HeML4l2LSGiFQN7zsnY1FO6Lx82KHMhfJQ6QHHw750enuq4+ybxT3Tq8n8Fo
	sf0GBnNVouavFX6/YEV3x2fRnumE7JL9WFUB50Mgy7hVUJd+2RWWWJui8BuUI8fUkQklOxOSbb+
	oW9/io8BSEbJ97F04YTOUUH/2UcxFUlmO7XjmQ2AxDHcxZS/cl4EwQBFagxXqAsr1pE5fcLUU/3
	ohbNRfMMVh0IixyKZDhtvr47dWcyK2hXT5pAlDHoMXUdl9WLNAk2SA3+S8+HxJ6iX1FHEzO0VhW
	8zkLCpnogEgwkF/xuapqA96G7OEQXvcY9aqwgA/A2QVjWul1WnQUEcK4YbjTAzS+wY8qI7XuVUk
	njQqmQqGtIPYN+KLYkq1c+Z0OvahPvhT8hcbsC6SqlWkDNp8zs3vneyf/YBW1XLHGik7mwdVJe4
	/zfNxCj361trQyWYaIcTTM8g==
X-Received: by 2002:ac8:5c94:0:b0:532:af50:8d7d with SMTP id
 d75a77b69052e-542b6a6d6b2mr54363611cf.33.1793392587437; Fri, 30 Oct 2026
 13:36:27 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 30 Oct 2026 13:36:26 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261017073149.1303738-3-aneesh.kumar@kernel.org>
References: <20261017073149.1303738-1-aneesh.kumar@kernel.org> <20261017073149.1303738-3-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Fri, 30 Oct 2026 13:36:26 -0700
X-Gm-Features: AclHuK8zIRE7fPt_40jzHY6DMSgwjgRywbF83YSieVT16EbHUHdKI8X5dSRrGPc
Message-ID: <CAEvNRgEh3E7NBc5_3Wq66Fss-mAYT6+4FWP5+=Co6+OVfVnQQQ@mail.gmail.com>
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

"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:

>
> [...snip...]
>
> +static int kvm_gmem_device_convert(struct inode *inode, pgoff_t start,
> +		pgoff_t nr_pages, const struct guest_memfd_device_request *req,
> +		const struct kvm_memory_slot *slot)
> +{
> +	struct gmem_inode *gi = GMEM_I(inode);
> +	u64 attrs = req ? KVM_MEMORY_ATTRIBUTE_PRIVATE : 0;
> +	bool prepared = false;
> +	int ret;
> +
> +	MA_STATE(mas, &gi->attributes, start, start + nr_pages - 1);
> +
> +	filemap_invalidate_lock(inode->i_mapping);
> +	if (__kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs)) {
> +		ret = 0;
> +		goto out;
> +	}
> +
> +	if (req && !__kvm_gmem_range_has_attributes(inode, start, nr_pages, 0)) {
> +		ret = -EEXIST;
> +		goto out;
> +	}
> +
> +	ret = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
> +	if (ret)
> +		goto out;
> +
> +	kvm_gmem_invalidate_start(inode, start, start + nr_pages, KVM_FILTER_SHARED);
> +	if (req && READ_ONCE(gi->device.kvm->vm_dead))
> +		ret = -EIO;
> +	else
> +		ret = gi->provider_ops->prepare_conversion(gi->provider, req);
> +	if (!ret) {
> +		prepared = true;
> +		if (req)
> +			ret = kvm_gmem_device_make_private(inode, slot, req, nr_pages);

Is there a way to avoid making private from within the conversion flow?

kvm_gmem_device_map() below already does it as part of vcpu_run.

If we do the above, we'd be aligned with regular conversions, where
to-shared conversions eagerly update arch state (make_shared) but
to-private notifications to the firmware are done lazily.

> +		else
> +			ret = kvm_gmem_device_make_shared(inode, start, start + nr_pages);
> +	}
> +	if (!ret) {
> +		mas_store_prealloc(&mas, xa_mk_value(attrs));
> +		kvm_gmem_device_update_private(gi);
> +	} else {
> +		mas_destroy(&mas);
> +	}
> +
> +	kvm_gmem_invalidate_end(inode, start, start + nr_pages);
> +	if (prepared)
> +		gi->provider_ops->finish_conversion(gi->provider, req);
> +out:
> +	filemap_invalidate_unlock(inode->i_mapping);
> +	return ret;
> +}
> +
> +int kvm_gmem_device_map(struct kvm *kvm, u64 gpa, u64 size, u64 pa, u64 vdev_id)
> +{
> +	struct guest_memfd_device_request req = { gpa, pa, vdev_id };
> +	struct kvm_memory_slot *slot;
> +	gfn_t gfn = gpa >> PAGE_SHIFT;
> +	struct file *file;
> +	int ret;
> +
> +	if (!size)
> +		return -EINVAL;
> +
> +	if (!PAGE_ALIGNED(gpa | size | pa))
> +		return -EINVAL;
> +
> +	/* Caller holds SRCU across the pending architecture request. */
> +	slot = gfn_to_memslot(kvm, gfn);
> +	if (!slot || (slot->flags & KVM_MEMSLOT_INVALID))
> +		return -EINVAL;
> +
> +	if (!(slot->flags & KVM_MEMSLOT_GMEM_DEVICE))
> +		return -EINVAL;
> +
> +	if ((size >> PAGE_SHIFT) > slot->npages - (gfn - slot->base_gfn))
> +		return -EINVAL;
> +
> +	file = kvm_gmem_get_file(slot);
> +	if (!file)
> +		return -ENOENT;
> +	ret = kvm_gmem_device_convert(file_inode(file),
> +				      kvm_gmem_get_index(slot, gfn),
> +				      size >> PAGE_SHIFT, &req, slot);
> +	fput(file);
> +	return ret;
> +}
> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_device_map);
> +
>
> [...snip...]
>
