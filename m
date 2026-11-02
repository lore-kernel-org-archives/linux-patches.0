Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793646873;
	b=cWejiu5+vQuJfh+8TD45UGH/kqMIdlgEcXuFIWe06aokoimGIsBy7bQdbxrP5LH9Vs/K
	 3sw6jzWvk4sDEJUqcvkyuf3CEZvkIpwjIuY+Eaw8UaCuuWjpmdezFmXO8e+SNqh36yPq1
	 RghpmaEdXSZIjSuyc1oNd6gbzC2ypRI8ivhfZWFUs8ncmPV3LMa1XMYXw7PSzEFemagHr
	 Q7+YU9RnnSjx8/dQvSgKeTHFMvDn6GVtprSBV8oTtxVJXpD7uJYkeAZAtxMdUVG7mR8Be
	 rBq3Z/QosciTuue4a9DjOSthQBPkUIKjDJQO5kbJgrN+qXeGAglJYfiHcN4WarBeu8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793646873;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=f/8JsTWJfPX9TqH25ivWK4glEwM0abcyTEJa6hCd5AM=;
	b=2ON3CxaP3LpjLlvVDqE/lavl3O0AMu3cLjoswiAj133B3FV4rOVxcOAHIjqjZOvsveed
	 V+5CsLXPpRDa0yrGKTxQbGLaGIgLJySF2TrqC+R469c3DniRjAw+H3NUZURGzRTR1Sg8x
	 ol8MH+4hxwmxaYMrNc19jzXs358J991tFf5BFdc7kLW2WQfnRO09sHKl1MCjDN4hRT8/e
	 xGeTMaqonOzC1lj1qNSd3pMzGO8pZ9gTdAOwfQC8Y0AHW9+aYvzyp9+NYAjcpl2NTt6Z8
	 02oScvC6nphpijfyF9SDlCmxq9+4o5dbAaO0D6rCVoql0XWE2uipOhdpBL06SBW/+eA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=resnulli.us;
	spf=pass smtp.mailfrom=resnulli.us;
	dkim=pass header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=t4YhYIRD;
	arc=none smtp.remote-ip=209.85.221.44
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01907606A326
	for <patches@lists.linux.dev>; Mon,  2 Nov 2026 19:14:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 01907606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=resnulli.us
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=resnulli.us
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=resnulli.us header.i=@resnulli.us header.a=rsa-sha256 header.s=google header.b=t4YhYIRD
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-48e20edd106so2619929f8f.1
        for <patches@lists.linux.dev>; Mon, 02 Nov 2026 11:14:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli.us; s=google; t=1793646870; x=1794251670; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=f/8JsTWJfPX9TqH25ivWK4glEwM0abcyTEJa6hCd5AM=;
        b=t4YhYIRDB4p0gZDDLuVMHjuWo26V5a6vZ6lMU6GkAgEoThHcSf7duTimZG+sbijLzc
         Bg5O2uFMI3UKa00VeKDZViy43/GHP+u3TfrjMJLhQw9bB/D1Q/TVzTo8aGQCkW8xMl9j
         0CHQDyeDyWC9ZcV3CN9/nb6Tgtr1sHWRZWJvMfEYGrVV+2yZsoqAUIR6iALG9PDcPZVx
         X9hvENCmLxRwx7nJIG22ZB5ssRG1Nsk2Qg4QGdVsyEh5UiS8ZaTMrEep0j6eVsnwVBBt
         2g9m01r/WmrOLmNVKirJ+h1SdGaKa/iAgR0hGcKDR4auRahSQaeynMDuLZ4t8YxwL3xx
         39fw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793646870; x=1794251670;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f/8JsTWJfPX9TqH25ivWK4glEwM0abcyTEJa6hCd5AM=;
        b=qkSAz3d20UMHkNsLdKt1WjPYUKM5jrX51/jdRx7QvqIFzxYbtZOmKnzj/pjWIwqo+W
         lLmDmVZJeDQoJ/3HWzTAssaJM8VziyBcJ4s20vfQRmMF077rt0SIgC2uSTjdihTtvOw/
         QRnnISBKkhBNiha0XDPoZmw3QbrsQ0u9RxXdWShd5vya3bWaTUujhHAHSh09e+yQFCkV
         cd7oipu0u5A+M5z+g2dOtPzmuXqS9CDeO3OM9AvWwmlajiUHAFGjH3+PJAqbEFlqQ3Ck
         L0mmyojaK/3+avCRuZnvDAUlpOzpdL88t4LYwbPDG4I3ed7R45ZmyTm2k2NMvsPgvcgF
         Z6gg==
X-Forwarded-Encrypted: i=1; AKwUvBzUNBYfSOnnup+GOKszEmSNWj3c9gOf9RMPT8/UV2gKK7V/BVJsvgKgH1KQGarJQ3MndZMDE+cT@lists.linux.dev
X-Gm-Message-State: APuU4Z9Ti6g1Z/Rr1w0WlXY/DL0LxRhfegCKlJzBoFQLLkHnizCjAHvm
	YG5CG65nJWVZh2l/8rJZSmcttvv//h31CKcBjW9SQ3eOXD7MGFLBJHTcbhPt3Ahhg/I=
X-Gm-Gg: AYBFou1Y3E207GD2TgWOgZRQTBPswh3y0XRvN7gzE/icV4lv/FWvjd3cLtY7S+F8t9u
	iXUB1ZoBhnuwWDosFq44hHuOSLDq7nAKcFlGs4DxUB89Mp0Yt2Ts7D+KwwIRO69WTKuN48ILwZ2
	tgRlRYopjNVz1cd4uPPEPdqDEV70mUtFs27ya1TLolo+Ci4ia0vyAr9GKDN1/fPeH28Xifpuv6/
	ayuJVQ4QWg5g23fiWAG1gKSU/2/p7d6ixZyOoDez5bI0V4lO6MWBqS9XiX9cSDxH69wjMvEt3pA
	Ifn+ufTTQ73ylwIedVelW/V/cWxmJxro4UsvXqgyNsZXdBcjC55RAFsqcpRIGyaA9P0JMDkiXAG
	/gJnkXkMPA6rEm9gyMqwdM15m+9upYkiVainAAwRGQTWzV3ls+4OQL0SyI6BULt+JfIUSoxaybd
	5rZ4pbH0NY7mFLTyOr8D8nnyurG+Lt4Jr2tejtcMgrjvxXQ+ECfA8lhHk4pkyUYk/8AD0dGsIWc
	OOfB31KV3Y12I6u7q6Cg9DFbVPEpuynt6OwE9P3Qn3SdDSBkSptXBB4Y2wqC/9Ysqv6P03inJ0G
	wAKvi9EKHVsJ/RqwVMXFF0BCJ3F4eLdLQW+v/Jzk
X-Received: by 2002:a05:6000:719:b0:48d:fbf4:895d with SMTP id ffacd0b85a97d-48e6e2e7552mr24042751f8f.19.1793646869833;
        Mon, 02 Nov 2026 11:14:29 -0800 (PST)
Received: from localhost ([140.209.217.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e71a4d3e9sm24075066f8f.6.2026.11.02.11.14.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2026 11:14:29 -0800 (PST)
Date: Mon, 2 Nov 2026 20:14:25 +0100
From: Jiri Pirko <jiri@resnulli.us>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Kevin Tian <kevin.tian@intel.com>, 
	Alexey Kardashevskiy <aik@amd.com>, Xu Yilun <yilun.xu@linux.intel.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Suzuki K Poulose <suzuki.poulose@arm.com>, 
	Steven Price <steven.price@arm.com>, Kiryl Shutsemau <kas@kernel.org>, 
	Rick Edgecombe <rick.p.edgecombe@intel.com>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Jonathan Cameron <jic23@kernel.org>, Jason Gunthorpe <jgg@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Ashish Kalra <ashish.kalra@amd.com>, 
	Tom Lendacky <thomas.lendacky@amd.com>, John Allen <john.allen@amd.com>, Will Deacon <will@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, patches@lists.linux.dev
Subject: Re: [RFC PATCH v1 02/11] attestation: Filter evidence objects per
 instance
Message-ID: <aujfoITbvtx-TY8Z@FV6GYCPJ69>
References: <20261028152618.1356860-1-aneesh.kumar@kernel.org>
 <20261028152618.1356860-3-aneesh.kumar@kernel.org>
 <auSe3YzgKX-lu27G@FV6GYCPJ69>
 <yq5aecd69ykw.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq5aecd69ykw.fsf@kernel.org>

Sat, Oct 31, 2026 at 07:24:47AM +0100, aneesh.kumar@kernel.org wrote:
>Jiri Pirko <jiri@resnulli.us> writes:
>
>> Wed, Oct 28, 2026 at 04:26:09PM +0100, aneesh.kumar@kernel.org wrote:
>>>Allow an attestation instance to expose only the evidence objects its
>>>device supports. Add an optional evidence_object_supported() callback
>>>and use it both when building DEVICE_GET capabilities and when checking
>>>EVIDENCE_GET requests.
>>>
>>>The following PCI/TSM patch uses one attestation implementation for
>>>devices that support different evidence objects. Its list includes
>>>certificate slots 0-7, SPDM VCA, measurements, and a TDISP interface
>>>report. Each device must expose only the objects it supports, for
>>>example:
>>>
>>>  Instance                  Supported evidence objects
>>>  ------------------------  ------------------------------------------
>>>  Host link using slot zero Certificate slot 0
>>>  CCA guest device          Certificate slot 0, VCA, measurements,
>>>                            TDISP interface report
>>>  Host PF0 after discovery  Certificate slots reported populated by SPDM
>>>
>>>PCI/TSM checks the TSM driver's evidence_types bitmap or, after SPDM
>>>discovery on a host PF0, the populated-slot bitmap. The preceding patch
>>>controls whether EVIDENCE_GET is enabled; this patch controls which
>>>objects that operation can retrieve.
>>
>> For SPDM slots, I think it would make sense to distinguish supported
>> slot addresses from discovered population. DEVICE_GET describes fixed
>> object tuples, formats and limits; SPDM_GET reports the populated
>> slots and their certificate digests. An empty supported slot
>> returns -ENOENT.
>>
>> Fixed differences between backend instances can be selected before
>> publication. Please do not make the capability set follow a
>> populated-slot bitmap that can change during the instance lifetime.
>>
>> [..]
>
>
>We still need to filter objects such as measurements and the interface
>report based on the backend instance. Are you suggesting that we do this
>in attestation_evidence_object_find()? 
>
>supported = attestation_evidence_object_find(att, blob_class, has_instance,
>					     instance, format);
>if (!supported || !attestation_representation_in(supported, representation)) {
>	kfree(objects);
>	return -EOPNOTSUPP;
>}
>
>So the backend will have some way to indicate which objects it supports,
>such as the TSM driver's evidence_types bitmap, with the host setting it
>to indicate support for only CERT_CHAIN[0-7]?

Yes, that is what I meant. DEVICE_GET and
attestation_evidence_object_find() should apply the same per-instance
support filter. Using the TSM driver's evidence_types bitmap to select
the provider's supported-object descriptions is fine.

That handles backend differences such as support for measurements and
the interface report. For a host backend supporting all eight slot
addresses, the supported set can contain CERT_CHAIN[0-7].

My concern was only using the populated-slot bitmap for this filtering.
The supported set should be fixed before publication; current slot
population is separate state reported by SPDM_GET.

A request for an unsupported object returns -EOPNOTSUPP. A request for
a supported certificate slot that is currently empty returns -ENOENT.
