Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793747565;
	b=raGe2K+IrU3gyz3kFiN5lerVzXhpqFapAoeLVgL01Q6hGMu9+vqnRGHaSfss5KoOkysQ
	 LYM7wckgqm/igQCpGNcpVPzrVmbuGk74tr4+Jo1xED/EkgpY76ZDKMlXDCPppWGc+fVY9
	 HPxL3co35GzBgOZeYmsNWYG3cTlYBd3aKQU7IUDJ1eHeq5fgfiSnhKgC8AV/TTk1VLTOT
	 IUjxlC1sDEfWEq/3h0tMgG9LStthmWHIu2OhbO+xh2AnXp8w+NmHb/6boH0u/s70lmkR1
	 9CqQlIeakYi1FCMeF+2ohEDip7WilTm3AfPn8woqFI8JegEOipEmRYh+B9SqnOKKIWQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793747565;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:In-Reply-To:References:MIME-Version:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=ryvB2JGWPuZAAGR2GMJJClI5Kf6c0Mg6JzyuuAdWS2w=;
	b=yQe7/5nf8WFVCOtkRHmpUL3JMWMk5SzpgVqoVGYNhMN5rZkeTom6qmxcrP90fZ/sYwu9
	 GTY0IfXAMrkJ4cnF2IqOabjT/Y1DB1G5ALXiy+kxkZ+YXAl/c++73xbTIw2bvu2DG3qki
	 SXS97MDTXiqGU7epQPxLc2Cp9IqJthcrIlQkuAU0iHRKSSCKxemRuEu8UeRWzY3kQV7Sy
	 /42NMit5h5AF1cjsHxLgJ9uRDD0a2mCcmHXEfax2nOfHwM5K59ozcp05mLp79F2dPYZSn
	 azGedU7Q++Z2tKx4dJ1tZ8mn2CLWXBLS/bZ4b5k+J2oYifsA+h0NUW1OqoCwihbd82Q==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Vh6WmtpO;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.219.46
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 260D2606A328
	for <patches@lists.linux.dev>; Tue,  3 Nov 2026 23:12:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 260D2606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Vh6WmtpO
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-91c11468b5fso1738496d6.0
        for <patches@lists.linux.dev>; Tue, 03 Nov 2026 15:12:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793747564; cv=none;
        d=google.com; s=arc-20260327;
        b=Fy0+ica5NfNB4wHWM3cXalBzuCtCX0ODZy5/B5xNdBJEnB3f1eZZ7KlzATWIgnnrVZ
         vq0khH9+tEIYpC1Oa8XO3VsGYTnrP+mY+Db397wvYRj7WKiKXjC0Ph4KEcO3gtQDkWGO
         Bgge+SlrZ1+POpEhrP74c3n9VLHmxcmjWv8xpBPtPiPbktC5WWaA7rCAFoPC9cE0qvYq
         VXAD4Yr0Yw9lTCSWzwE73Ojp70DuTlIMgWy+l16xGFqEj/zBTqFu/dTygBlTl6K2eOIu
         CPiZhLvXPTC/Nd1DiFMV664Q7uHgaMBSk0YmRsYYcBxwYhBIUquCZ6y59rH0UUYOvahN
         31TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:mime-version:references:in-reply-to
         :from:dkim-signature;
        bh=ryvB2JGWPuZAAGR2GMJJClI5Kf6c0Mg6JzyuuAdWS2w=;
        fh=17hSv4g7oRaLHDzK+0kQ4SvQwv8bYybTCrktF1JJ+u4=;
        b=Dul0nsc9r4AWb5KZWH1VAoN0tKwaxUc6kaGnKeHKESNYB3qa74r6TuuyCO+e59wYQ5
         lLjbwbtfAeRwKbRnNHdWuAo6Ne2Lezlwm+mB6VJSzCUNMMsUh4MvOhoHAM5qvrljqUkb
         amrFdMhFYGZh7QBR38z1qUsFsPfU5XyRxV11yc3+Q/k/7XqrvIgXGr7FZ59ChR1Qq2s6
         d7OzT+EI/h3czEZCo5arRgCEr+kMROYTR1koQDw0JfCW/UQa2mnmgYAvtzT9Jo740/Lb
         PBQtIElKReUB50qG1UHmAu5tO3CM90qgCXQ3rEFq4hnf7Khua9PSG7TNUi0/dTAY2GgM
         /5PQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793747564; x=1794352364; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ryvB2JGWPuZAAGR2GMJJClI5Kf6c0Mg6JzyuuAdWS2w=;
        b=Vh6WmtpO4DFRjhgk2OSHe9dfcoVHHEJ7JDMGmG6L3flBWzxlr2j3LzAkLlFGiUWl4T
         LKZNwvNvdkAIB1vC7EVA44H/ocUACItm9cQJIJoiPEwu/3AwZmrdHw6M8d5cbQrbaYAi
         zqI4ddKdNpEIsKjwu6IH9pB0T5EzTvVpWnrUTA5WzcDxjgmXaGg7KSgC1EyjiBdAnt9n
         1Op3RlmiXsNu04BHVvg7dSGnbBz2D3XbowBOQJV6qfmMQzBncXwnlZdRC+oLc5erVqmg
         nBgJLpuYCtIELgxRVtnMctsbelnQh7hZIMawU3AUy+3Tl3ncF9x9Xt9wumFqBzLS1rYQ
         a7YA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793747564; x=1794352364;
        h=content-type:cc:to:subject:message-id:date:mime-version:references
         :in-reply-to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ryvB2JGWPuZAAGR2GMJJClI5Kf6c0Mg6JzyuuAdWS2w=;
        b=yuSG6PHOBG/NkMetoDdg28fUfrMiyCF/UdmXnQRYZXo+9A49RLuz+ecb4GOwMnNneH
         zA/iv/XFSx5SptUk8VVajvzM4qg0v0eh1iAVfhB5fE25ctowpgcjqw+IRVIK65Fl+d8L
         MuRMjErPzM8RTO4VrNVt5wTwcvjjyF1TNYn4uLsiZh4doOi+5L5UVuA+nwpSyp9D8mav
         K09oxkNWilKzlQMyBChoWAanOKX6EEvtW4ajbqbevq2YJGDNNY1YEswaM1XmD3N6nPHX
         Hm4gIhnwEESJSADu2kaNZdP7JCX9H4qUP36NgLytTUWin3znEO3KJUlykdKXzvniqcgC
         Wjlg==
X-Forwarded-Encrypted: i=1; AKwUvBwsMGYOjE6rbtJi6BfrVi1S0CxY9jRnR3uf2y1tgoaZmtVnsS5xrPqXDVSG8sukP1JB7AirrQwn@lists.linux.dev
X-Gm-Message-State: APuU4Z/qAaGsVIToYlpovR9zMU4JcAcwYU0M8MvZmLBqSqJjenXJ4Nem
	8Jgd3h2K30N6xK41ISHpwrHu4Za20AtKzgbYAQJi15+CEyoiPmOpunWZRWAx49nb0r3TLN4NcOO
	RD8sLsCVaZstJOAsEthvN6Lo1FjkO8MIiePhlp7dF
X-Gm-Gg: AYBFou0Ry3OarGIlY49Jzgko5uTaYqHswtMTFGF5lZVTHM5BVpO9UIMGDzmJaFzpmKN
	bB6+TUX/8gBz4X/KBHvjDNWDrHcBwztKeU3yyRMCcBgzz5A/dOHNY13cbfSSWrbMotTfFKQCCmO
	nFhJEmINsG+AmZ/p+QDX0WkLlujKEs35c1SibyCWacFxqPmo+Shpj+HEeIw8fpoPOh8v1nQ9GCw
	cxojKfEkOUmsPBuNRHEVmpUyIjyUsp6p/Fnav5Bp5uZ5lWg6+84F7Rlqv72MP9mRDhHUeCSRdaU
	8Fksa+PtgljPkf8BGdRNhhUcWPSH49I6etQalGjJwMGO/y8vP3YeHQHHqZ/IiMkyL14CUJbQHsM
	N5Gix8wDv212mmwx9c1jSfRZUbBSHDrs5cTTOXF9AJJ5Xkk4DEd6ZcPmZCVgxeh3QL+JIR/6ap8
	vVkKGX1ZE/ZRRwLrxrp4QzCMw=
X-Received: by 2002:a05:6214:570d:b0:91b:832d:ce5a with SMTP id
 6a1803df08f44-91ca4b833acmr247908926d6.48.1793747563253; Tue, 03 Nov 2026
 15:12:43 -0800 (PST)
Received: from 176938342045 named unknown by gmailapi.google.com with
 HTTPREST; Tue, 3 Nov 2026 15:12:42 -0800
From: Ackerley Tng <ackerleytng@google.com>
In-Reply-To: <20261101071928.2462549-7-aneesh.kumar@kernel.org>
References: <20261101071928.2462549-1-aneesh.kumar@kernel.org> <20261101071928.2462549-7-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Date: Tue, 3 Nov 2026 15:12:42 -0800
X-Gm-Features: AclHuK-a6U90XRQ86I28YCLgetKuFVa0CnGLyQ5k0MglUtI4Y2OMEO9n6VKxkJo
Message-ID: <CAEvNRgEL5SuPBwGqwrUzD3Gb1iUonhvM488-3khHpQk8OkWr+A@mail.gmail.com>
Subject: Re: [RFC PATCH v3 06/13] KVM: guest_memfd: Support device-backed PFN providers
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

> Device resources such as PCI BARs supply PFNs directly and cannot use
> the folio allocation path. Store the mapping owner and device ID in the
> core context during attach(), and use them when preparing device
> memslots. Keep device memory separate from ordinary PFN-backed RAM.
>

I'm really hoping that device providers are just another kind of PFN
providers and not special in some way.

Please give me some time to prototype so I can see what can't be
achieved.

> Require device providers to use PFN_MODE and INIT_SHARED with
> architecture support for protected device mappings. Device providers
> require get_pfn(), but not the lookup_pfn_range() callback.
>
> Mark device memslots as guest_memfd-only and pass their device binding
> to the architecture. Resolve guest PFN lookup through get_pfn() for
> either shared or private attributes; the architecture decides how to
> establish mappings. Include both mapping types in generic invalidation,
> using the memslot binding to select the architecture unmap path. Host
> userspace access still requires shared attributes.
>
> Skip RAM population and PFN reclamation for device MMIO, which has no
> RAM pages to initialize or reclaim.
>
> Keep mmap, fallocate and attribute changes on device-backed guest_memfd
> files disabled until device mapping and conversion support is added.
>
>
> [...snip...]
>
