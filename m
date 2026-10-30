Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.44
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793395143;
	b=omn0ATOUYU1Bqd2BweQBagLjZ+88XYkjgNmzjDNWJKPdURfKK+MTEIRdmMl+r5vrN6WE
	 r/TbQIP0ww21ZiYxivKyW1nipMY7znrHqkEtIdvSgPEHT1xqaE5v7/svam1hoxNuBMxk4
	 fJMMlcFQeHHBbNjWo0CW0Qx9kybOVDNYCgUEpWHdiFOxFdbguRsWwZsIhn9ItoHAqr84W
	 1zbwrR1LqDoATc3uJ0A+OCsprjBGDDF0WI0PDMgYsdJOdyh6/wONROgN+0yb4qzk9bHSi
	 4FkRHR1KCiJp3IezGXEsfr9nN4ptCQxGtEFHGosmBwyW93yE3Kf4+eMvH7jxeChofHw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793395143;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=HU3pvitpwZLUJMJVILFp+Zu6v1bdImGs94yE/HOyndg=;
	b=g/7wF8KCnlEf47wGY1/Xhyx5cfA4ZYZjwo+TqRC6q/KV45sMSAmR6c6WzdM3ZC4eIcVK
	 V92JHXpj4PGKSLLsyBUyzAb0H5UyzUSOt/bY1ao/AQ9LGOlhCEWXAotR75aejbOYdmD6T
	 nbtzleYoauzbcg0wAdwWyZDms7pgxfmmzKcQdudZLto15MQcXALDnV8z3b6PRZhGz/q2X
	 eF+VFy332p1bMkynkmk8VkACoo7urzaWMJHtM9Vw6SKZtjK8RIskFXu9SoHDRaBaoQF5+
	 NypRhKE2sGwME9QNxSROufMwbalk7gcoPqY8CM+JRUG/s2gXAZyLYBxUW5JJfIhTRVg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dIB2Yomh;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.44
Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B567C606A31C
	for <patches@lists.linux.dev>; Fri, 30 Oct 2026 21:19:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B567C606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=dIB2Yomh
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-91b8306b9f8so19258896d6.3
        for <patches@lists.linux.dev>; Fri, 30 Oct 2026 14:19:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793395142; cv=none;
        d=google.com; s=arc-20260327;
        b=ATCT8rexseogu+vn+ib/qyQqPizm7m3+HQrGULjizLameN2lzVsUFhRKVTk24HKSUz
         ZqIBEnZUQ2EIiLXVgNW2iU5L4+sIkFNcpINm5+O8i38WxPL9J9b8nwxNYK+ADWYCB/fr
         yhHimsaEIvHALkhWvYsdZTGrfdML7BtKsGk8wJi8rqdAv4eAWSUhYbbcw7OSo9Bb1eMr
         lC/dg1xLIGYh70WRKaw0kLZEfoTcwkSI1YWmPmWjJCC3xbGpF2sOjfxPXbp+jS3PWECp
         p2j/577rEAof390ELtPe0S+H7d+0sTSIvhAaZuOHnvZ7MkAO+1me+9aDeF8z5IDoFIQ2
         ekcw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=HU3pvitpwZLUJMJVILFp+Zu6v1bdImGs94yE/HOyndg=;
        fh=mItfAq8kMhE944NXV2mU6+7rCo635gq43KQ5cDxQys0=;
        b=JZikPxXB8Zkg/sQP/J62TNAFfw09lTRs+KbUTQE6kTTsy99CyVAlKR6FyIH2HWYknO
         lgs8AVCAPJCMK3g6qrEb6VYP29N7kYSBWdgkaijN5AAu+T9hudD9TscSiBk7BOssXbDG
         BykYxIw/aMCnWnXaqSGH12nc2tYcqzCgtY6+oyoAAKJdPs5iYImy5Y4gGzMmvJsESr9i
         f7NdIVf5Sl9geQppicyS4WK8XAUv97mybS1pYnaNOjrH+nIzgO0oRz8Mn7xB5LmZClLL
         dI9YsfC2LvN5mRS2jmlqonCoBLq5fo3fGNanaP8tCyjve5lcXBDgKb2R0wdmIySfDCb6
         VS0w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793395142; x=1793999942; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HU3pvitpwZLUJMJVILFp+Zu6v1bdImGs94yE/HOyndg=;
        b=dIB2YomhttqFpyro1ApK4LTiU968266c5ZO4LOm/iRURcPtEckqyO4+blAdV9acpMW
         JZ92DvWKbO1BNZjpTb4O3aNi2knj6vKNYHh2FJYP/mTtMWGZcp1G47efjR6iXjVMbUTn
         ZWbEC3uiljE7a6U0YFeBft610grI94+ZQSqV2KDy9zu7IaQXQVPhKIJDfJJjsqIOezLS
         1cnGlzxUqbQD4gO5rhKNFFCNdIYQSeAoFfDarxO+dJgWRYvKWE9Tmt1/tEmFFsNVl4Ss
         2Lj4ykNzZQeu+zb2liSdeMYs3juBlhn14Jx0pvPnGLQ38i4vX4Ulz7hrdFIUnHOVDe0w
         qP5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793395142; x=1793999942;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HU3pvitpwZLUJMJVILFp+Zu6v1bdImGs94yE/HOyndg=;
        b=ouqUBSSUCu0/xtmOWwTc0j/IlVqXdOxsdgyg1ufUWdHxNyXwZc7hbjEs5luY+WFl9k
         YaEgQPMt+fMdKEkDvIfL2jn6Pi5NUZ6esONU2rcwUyiDpkrmbal9IrQpxoWqGKqCkyJu
         T07KXw6W+GxGbVktoxByUACiYR86DIUYzFhjEB8fnwvGLKL4+1v+hZgLSYWHA4vL8yJn
         P/NnR8Ua+7aZG16YiX6S+wpjpb1sDjCBSVJXqmi3/g3L0gVLGP+klr5S4bG+TbiaEs7P
         6feR44Ox507HbX4c41NF3UUGyiSWBrsjMqa2epGiJHQD59pLdzPTv514yDJrknmxvju2
         AEqA==
X-Forwarded-Encrypted: i=1; AKwUvBzkHrwEHM+AJKkeyVs2UrdbDQp9TxDxilQsoDamykkfpkVx79uYVtE0Far6PrnCO5BXAm7HnNs1@lists.linux.dev
X-Gm-Message-State: AFq9FYLO+zwtAy2ZCFPExxERbILSY5vMAVSY/7ph2byPB9fTx4D5ciz3
	brJvwcWZp8K8Z9wBJUjoyfzGqi5sSWszM1yuEa9cvDgUSHz/YOcoTj4FLHs1qucWwfk5mELGQGJ
	zsrE3a2mnMLjYdloKcrledjeWqS+Q/Gr6OC75POew
X-Gm-Gg: AYBFou3OtlE84fgb6E9BhQoDwHRBjMAfkGuZ2b2JPSZKx8o+N68hsO96KbBHbEiiOlJ
	sE3u5qUlEPTKOswQlgm5ONlNe2n9N38vY9ufxcbUIkOxSr39zhXLmIHXZTMICn3PQ9+xZhBBUnt
	t454rNO8PtuhaTVIVcljJ4CoNmhZeBVC6yRQ0WmMdaq0WHhtquoKZKy3yJpx7LBQ5jpK5cX4yuQ
	uLikYvC4xL9GbTVB0t5re1ixdNHEyaQ4cyb9ZWDz1thJp82V5+wObURZtIhfxHxSVXkUnk95kR6
	+bz+btC+sPkFjuoTWZfqrJHpR8uvqCmlHZ4nDrP07sY+wNeG5poPxQGXkAEnmdzW9sqzuGpo5g4
	DtmAkm9dH2sc3ed5FKFfWck8Kv/A/wZCtDzUKdKMz97iInGND1p2kDdrxTU6CiZzCuJ5ZCwe2Xn
	TxpARBzBkRGX1AHG2dUQPTrw==
X-Received: by 2002:a05:6214:240a:b0:91c:450d:8f34 with SMTP id
 6a1803df08f44-91ca4bce34emr58846786d6.46.1793395141110; Fri, 30 Oct 2026
 14:19:01 -0700 (PDT)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Fri, 30 Oct 2026 14:19:00 -0700
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <CAEvNRgEh3E7NBc5_3Wq66Fss-mAYT6+4FWP5+=Co6+OVfVnQQQ@mail.gmail.com>
References: <20261017073149.1303738-1-aneesh.kumar@kernel.org>
 <20261017073149.1303738-3-aneesh.kumar@kernel.org> <CAEvNRgEh3E7NBc5_3Wq66Fss-mAYT6+4FWP5+=Co6+OVfVnQQQ@mail.gmail.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Fri, 30 Oct 2026 14:19:00 -0700
X-Gm-Features: AclHuK8aNtmB7JK_qHjJeH9V34MC2DCp5vnYn4fAUI82UUtxS3pHz4MfNJXrVPA
Message-ID: <CAEvNRgFEKqVZcNYCL0LpB6BTyBFe+ot1x1nFfEqOrSTsu134PQ@mail.gmail.com>
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

> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:
>
>>
>> [...snip...]
>>
>> +static int kvm_gmem_device_convert(struct inode *inode, pgoff_t start,
>> +		pgoff_t nr_pages, const struct guest_memfd_device_request *req,
>> +		const struct kvm_memory_slot *slot)
>> +{
>> +	struct gmem_inode *gi = GMEM_I(inode);
>> +	u64 attrs = req ? KVM_MEMORY_ATTRIBUTE_PRIVATE : 0;
>> +	bool prepared = false;
>> +	int ret;
>> +
>> +	MA_STATE(mas, &gi->attributes, start, start + nr_pages - 1);
>> +
>> +	filemap_invalidate_lock(inode->i_mapping);
>> +	if (__kvm_gmem_range_has_attributes(inode, start, nr_pages, attrs)) {
>> +		ret = 0;
>> +		goto out;
>> +	}
>> +
>> +	if (req && !__kvm_gmem_range_has_attributes(inode, start, nr_pages, 0)) {
>> +		ret = -EEXIST;
>> +		goto out;
>> +	}
>> +
>> +	ret = kvm_gmem_mas_preallocate(&mas, attrs, start, nr_pages);
>> +	if (ret)
>> +		goto out;
>> +
>> +	kvm_gmem_invalidate_start(inode, start, start + nr_pages, KVM_FILTER_SHARED);
>> +	if (req && READ_ONCE(gi->device.kvm->vm_dead))
>> +		ret = -EIO;
>> +	else
>> +		ret = gi->provider_ops->prepare_conversion(gi->provider, req);
>> +	if (!ret) {
>> +		prepared = true;
>> +		if (req)
>> +			ret = kvm_gmem_device_make_private(inode, slot, req, nr_pages);
>
> Is there a way to avoid making private from within the conversion flow?
>
> kvm_gmem_device_map() below already does it as part of vcpu_run.
>
> If we do the above, we'd be aligned with regular conversions, where
> to-shared conversions eagerly update arch state (make_shared) but
> to-private notifications to the firmware are done lazily.
>

I was a bit confused above. IIUC to handle
RMI_EXIT_VDEV_VALIDATE_MAPPING, the conversion is not done from outside
the kernel, instead it is done in the vcpu_run completion hook.

Can we make the flow that userspace is required to do the conversion
request from userspace after an exit due to
RMI_EXIT_VDEV_VALIDATE_MAPPING, and then just do the delegate + map +
validate in the vcpu_run completion hook?


The rest are a little outside the guest_memfd field, but I'll make the
suggestion anyway.

It looks like delegate and map don't need the vcpu context, only
validate does, so validate has to be done in the vcpu_run completion
hook.

Delegate needs the host physical addresses, so we'd need to translate
the IPAs to PAs, could that be a VM ioctl? It could look up the memslots
and translate IPA to PA?

RMI_RTT_DEV_MAP also doesn't need the vcpu context, IIUC it does need
the VM context so it could be a VM ioctl too? If it looks up the
memslot, it'll also find the guest_memfd, where it can find the device
information.

I'm just thinking that the vcpu_run completion context is doing too
much, and there are so many possible errors that could be better
communicated to userspace if they're separate ioctls.

Or perhaps at least delegate + map could be one required ioctl call by
userspace before doing vcpu_run to continue after a
RMI_EXIT_VDEV_VALIDATE_MAPPING exit.

>> +		else
>> +			ret = kvm_gmem_device_make_shared(inode, start, start + nr_pages);
>> +	}
>> +	if (!ret) {
>> +		mas_store_prealloc(&mas, xa_mk_value(attrs));
>> +		kvm_gmem_device_update_private(gi);
>> +	} else {
>> +		mas_destroy(&mas);
>> +	}
>> +
>> +	kvm_gmem_invalidate_end(inode, start, start + nr_pages);
>> +	if (prepared)
>> +		gi->provider_ops->finish_conversion(gi->provider, req);
>> +out:
>> +	filemap_invalidate_unlock(inode->i_mapping);
>> +	return ret;
>> +}
>> +
>> +int kvm_gmem_device_map(struct kvm *kvm, u64 gpa, u64 size, u64 pa, u64 vdev_id)
>> +{
>> +	struct guest_memfd_device_request req = { gpa, pa, vdev_id };
>> +	struct kvm_memory_slot *slot;
>> +	gfn_t gfn = gpa >> PAGE_SHIFT;
>> +	struct file *file;
>> +	int ret;
>> +
>> +	if (!size)
>> +		return -EINVAL;
>> +
>> +	if (!PAGE_ALIGNED(gpa | size | pa))
>> +		return -EINVAL;
>> +
>> +	/* Caller holds SRCU across the pending architecture request. */
>> +	slot = gfn_to_memslot(kvm, gfn);
>> +	if (!slot || (slot->flags & KVM_MEMSLOT_INVALID))
>> +		return -EINVAL;
>> +
>> +	if (!(slot->flags & KVM_MEMSLOT_GMEM_DEVICE))
>> +		return -EINVAL;
>> +
>> +	if ((size >> PAGE_SHIFT) > slot->npages - (gfn - slot->base_gfn))
>> +		return -EINVAL;
>> +
>> +	file = kvm_gmem_get_file(slot);
>> +	if (!file)
>> +		return -ENOENT;
>> +	ret = kvm_gmem_device_convert(file_inode(file),
>> +				      kvm_gmem_get_index(slot, gfn),
>> +				      size >> PAGE_SHIFT, &req, slot);
>> +	fput(file);
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL_FOR_KVM_INTERNAL(kvm_gmem_device_map);
>> +
>>
>> [...snip...]
>>
