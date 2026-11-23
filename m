Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795446045;
	b=lsrwJKkxf8ZQBynOdSLLTlgWGWNYdrGwZSnCqdm69j7oKh4V7saPUlGIIzrnIRoKga0S
	 jilC5P3PLBy5F55K8SaIKJt5YOVLXZkAIGz7K2HYhfiiMnnMrTI42Iau9DJANOyShVljU
	 9hVgtSsLL3mdDmwFhDoGKJznxZip4uCteZtXaC+Au/95Mu7qjbhlgs1LgugiyTyT7vLb6
	 S2fN3mMMb8AQblPPO4S0yme3S+Uz4tseC2hvTE9U3IOClLCUtl2WTnd7hWMx+ifANPTDq
	 sxOmrcfsmemF1LR9DfjjaRNNnb3i76zDJFNRfxD2CycOcSl9fYxU5QW0YZaFC+MsDKg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795446045;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=8YXzoVkoKKTn5S6189qRHpEA8zSaXUAPSQ685ax1F0I=;
	b=h4XvwA0dRapXBCt6RwrtKNCF+ozWI5z2hmS6SSadwPOaPzkXwoRnoSxNczjSds+CesJW
	 QvodYPIxre3AT5qwZUMASutDzfzOPptOYFt/BYMXgTaMc8jGQ9oLvKLcWrxDPMSt+mvGq
	 sFPMNj2DyP22of90v/Juo4I4llM6lzo5haKMykvXtN4tneQjclXglYZy107QZR83xhwJB
	 NmK0auoPTiU8RppZnN8WP6pT5hDfmXookVfewN11BeIdgT0HTVfC547xwOhAdfreE3od5
	 /iZE3/VyqiUqMZonXV7is+L3au7bJG6S37NMqm+f0CttPKjZRarp72dP0T8aAfzyqBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b="Js/hN7BF";
	arc=none smtp.remote-ip=209.85.219.43
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33ACC606A6A4
	for <patches@lists.linux.dev>; Mon, 23 Nov 2026 15:00:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33ACC606A6A4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=Js/hN7BF
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-9212a5a66f8so29539126d6.2
        for <patches@lists.linux.dev>; Mon, 23 Nov 2026 07:00:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795446044; x=1796050844; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8YXzoVkoKKTn5S6189qRHpEA8zSaXUAPSQ685ax1F0I=;
        b=Js/hN7BFiz+V59LU3g3qClRYtgCYYRyqOBkW49G+CeYW1aEcatOFKpUqNmDa6nwoLO
         EEbZijW6BaZXx7xFQ+7bBLUFNphUSNLLEct5ENjAr5bCyRwBr03momZfim1ZfRs7R6og
         IuK9n0r/YinKfN0nFoXlYdgmv3JMxrqeV/+rOki5A6zQ16unhdz3qvXlQtHAnyXaCKAw
         m15ayg/ihxXKoYaonVGoEZTjRJMfkV25c4wJHR9yhGd4A7pVyaHJkb/UtBalcU5uuOxE
         BqeYptVjjfg+ensmZldQmRMXh2aVA2slv7fdKgNyHhoTrDbMjjhC7R6NhJfv1zKy/aIf
         S95A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795446044; x=1796050844;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8YXzoVkoKKTn5S6189qRHpEA8zSaXUAPSQ685ax1F0I=;
        b=BVzEokqwOas/+Hjy+VrE+XSr2lEE/BsfA925fstsxToiMtCfPJasVvSjW4owO00uoa
         Rcjtpnv3yobkywyvsmOvPhxaEPG9jiD0DSbE8rB+dvJ2C74XCWtE6X4U4DDNWH9VH00f
         DGKII5hKaC7MVKLeIaBpK0oPMqmeFJ2FGgOaratJ7PJIf9ElG54uGY+14G06LnWtl4sO
         TkNtgYcE9064+N91iNaBtmb7sL/jr6Q1MC5mX3jJSIIvVFy5/JuWjN7iGDdY5eHay5m4
         K50te+eUKMJUbMA1FYgvw607P6D24eaCXrClHsrCfqaq676MiG4AkGawEto9s0DaruMm
         NhWA==
X-Forwarded-Encrypted: i=1; AL+hErEiN/J9IkQjtPEva3S+zR/+fZMnY3FslarocsistCPRNivGMLLKr6VokQAjE6s1lJ8zarync96o@lists.linux.dev
X-Gm-Message-State: APuU4Z8y2Y7CmnGVH5MdG9mOWpMVIReJ/6ICsAsLYWEt3lzMfK6yIxj1
	d5DUKkEtxs+3rTMruZdkj45RnaopMXDYTLPSh1lBQsdoQd6gfxi/TRTPUaxV6zaki8U=
X-Gm-Gg: AZFdTZeJ6yj8/Tzm44h1wpDIFgrg5V+98LIy+PGOIzKcRKHkNQwYX2TTUMf+eLb0ony
	pcoUZ+hGqSfWGvTI4zbm2v6wgeJJJR4WgPaICdwZPGCo8zxZXsZ7gjjK/hbLL7mM6JfB0WyIHAp
	WXngti7r591ux1zV1+cMeW/GEZYT1nm7fcTyN7lUqFvwEY9D0jK6XG6wcFF0NgFgvrUmxPjkiGW
	LIu3mv96ZFjOLQdLRawM9Hg6PxNwQf95Nwih+DUtS5yBALKgL70d8JnWR/E1HXWywCxRlg/PXa1
	Ambf0f4DpMiIfLk+DbpCoW+QMYnDfgwAMszzkfrS3EDnT3DTcPa8fqaXGk2jK7m/BJxyNy6f7Zb
	3Miy3xO/KOTSMfGnAz1rx+XhdRMP15pgov5HzQNc1mS7c0ObX8SLVWE7CxS0rjKbtaVc/80rcWZ
	juI4pDt6nc9CJOe6vmSrn1V0GFwwuggpwo3QG7wKApseREu/UrQchDc6+nC4K1cG/n9qOVRqP0W
	tVNCbsG5DR142KGtHLHau6i+Noa0HbPVAKtXRAGaP2c4+/XMUj4je9f05f39i062HablZzM41sn
	EhhztRhoRYXJwJdl7qnF04Yfhd/H7EhzdVgpDOk43SxYOl5vIg6mneYFjyc9XUbNKPxnBY08RP/
	0Od8=
X-Received: by 2002:a05:6214:4891:b0:921:27c2:3f89 with SMTP id 6a1803df08f44-92134a3715dmr207386236d6.17.1795446043629;
        Mon, 23 Nov 2026 07:00:43 -0800 (PST)
Received: from ziepe.ca (stjhnbsu6iw-159-2-142-59.dhcp-dynamic.fibreop.nb.bellaliant.net. [159.2.142.59])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a16754sm107600476d6.39.2026.11.23.07.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Nov 2026 07:00:42 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVVX7-00000000rK9-14j4;
	Mon, 23 Nov 2026 11:00:41 -0400
Date: Mon, 23 Nov 2026 11:00:41 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>, Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
	"T.J. Mercier" <tjmercier@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>, Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>, Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <20261123150041.GB179082@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
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
In-Reply-To: <awQd81MwZqi55gf8@arm.com>

On Mon, Nov 23, 2026 at 11:05:23AM +0000, Catalin Marinas wrote:
> > -	/*
> > -	 * If set_memory_decrypted() fails then we don't know what state the
> > -	 * page is in, so we can't free it. Instead we leak it.
> > -	 * set_memory_decrypted() will already have WARNed.
> > -	 */
> > -	if (ret)
> > +	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
> > +				       PAGE_SIZE << order, &mem))
> >  		return NULL;
> >  
> > -	return page;
> > +	return mem.page;
> 
> This part is mostly fine but I do wonder why not make this alloc
> function the same as buddy alloc_pages_node() - return a struct page
> pointer.

I'd argue we shouldn't even be returning struct page here, do many
places even use the struct page? What for?

Exposing struct page to places that just want a kernel addr means they
have to call page_address and we are back to the highmem weirdness.

> >  static void its_free_pages(void *addr, unsigned int order)
> >  {
> > -	/*
> > -	 * If the memory cannot be encrypted again then we must leak the pages.
> > -	 * set_memory_encrypted() will already have WARNed.
> > -	 */
> > -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
> > +	struct cc_shared_layout layout;
> > +	struct cc_shared_pages mem;
> > +
> > +	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
> >  		return;
> > -	free_pages((unsigned long)addr, order);
> > +
> > +	mem.page = virt_to_page(addr);
> > +	mem.shared_size = layout.shared_size;
> > +	free_cc_shared_pages(&mem);
> >  }
> 
> Here it gets weird and I don't see why we can't have just a buddy-like
> interface. The kernel-doc for alloc says that shared_size must be
> retained for the corresponding free but without reading the source code,
> you can't tell that cc_shared_calc_layout() gives you the same
> shared_size populated by alloc. We have a similar pattern in dma-buf but
> using the compound page order.

This makes sense, we should not be passing size to a free function,
make a compount page/high order folio instead if the API is going to
be struct page based.

> We can get rid of layout and mem structures (or at least not as
> part of the API). Of course, this assumes that the shared granule size
> remains constant for a guest's lifetime but I don't think that's a
> problem.

It should be encoded in the struct page meta data, as the order.

> Was there a caller you had in mind that needs the common allocator to
> share less than the whole buddy block?

If we want this it definitely needs to be a void * based API not
struct page one though..

Jason
