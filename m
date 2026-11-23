Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795458576;
	b=cpgKYOBb7L6LDwQsBNVjZ33Q+ASOXspIgC6Tez2GUXwGLITBUNqSUGPr01pxQEGu24gL
	 IgH+PHdLXF+NEuJUg9PSi2kaN3SjE4aJx8j18KLjikREP376a0Ivfvai836CsiaUwbCGn
	 0Z3ucYs1o8hG7L0tKTMFQAbYauOFvLR7ljR+0RcYqwXbk4lIJIwOR+CGARyE3ZOf1SjBb
	 /Mrf3EgfVn4qxrInfhOdpcySdpMgTIqpv3B42kA6lJ1cFVXT0eh+Zp9w85PRdW0ApQ5uu
	 KBpgUqjAnwQnlWc5LQvMr9i1r2YSKIgiWWrgayEbCuC0tc5WiJLtBLP/82BKTX3DMdQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795458576;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=4/j1tVsYjuDomGfTOiRNEufIvsMjxkzCoGFkLJLsf4Q=;
	b=0a86eSRS5JeTfxVsJkCGHx5sNd0VeTCFOfNhWEOOBmQnVSvzv6vUpXkZBZG42SvgVbyy
	 aPJ1T+SQLPkOVuQr9TgXkgNAGdvP3U6XgKgbo4uvGBxv5yFxXl3G4GeFHP5TcFskVSGpw
	 YUoB8aXbMSKm49RDqoQ6YeFn1+Q5qNfCmFU8SYkGPVb6jKltJVdXYu0QC9JKN00aNh7kh
	 QDhp9ztY0NhEOLY+gnKWhvM7u9B+JN5evAv1rn/tmDtBFhrOfTGU3k+ut2pV7ybIzbKN4
	 7e+o1hgTXfWekIkU+nwlJt62xHqgMFGHWthCzIuJs5LsvLTiS19K74jkpdGsyXIG8aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ijpVlN8I;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A332606A327;
	Mon, 23 Nov 2026 18:29:36 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6A332606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=ijpVlN8I
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id B72C9143D;
	Mon, 23 Nov 2026 10:29:32 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8E3763F763;
	Mon, 23 Nov 2026 10:29:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795458575; bh=91rRqWnUFnt98sbMIZIWLen5dQtczci7+M9TkR+C2eQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ijpVlN8I1I3lz+oP0f/Ra6j/FKXUuG6yrg9sGG6aArSc3WgM6d06k0TeBcvheHnlB
	 +bg049yO3+3oRRTrxvdP291vcWCMxo9GAp2+PsBjvQ08/CJLOgCUEhOoOYk7V5y0sg
	 lWIn7leu+umSmLK0yR2G0mX6r/H/ZewmLWycrNRc=
Date: Mon, 23 Nov 2026 18:29:25 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
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
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <awSGBdS1AiFhJzZV@arm.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <20261123150041.GB179082@ziepe.ca>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261123150041.GB179082@ziepe.ca>

On Mon, Nov 23, 2026 at 11:00:41AM -0400, Jason Gunthorpe wrote:
> On Mon, Nov 23, 2026 at 11:05:23AM +0000, Catalin Marinas wrote:
> > > -	/*
> > > -	 * If set_memory_decrypted() fails then we don't know what state the
> > > -	 * page is in, so we can't free it. Instead we leak it.
> > > -	 * set_memory_decrypted() will already have WARNed.
> > > -	 */
> > > -	if (ret)
> > > +	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
> > > +				       PAGE_SIZE << order, &mem))
> > >  		return NULL;
> > >  
> > > -	return page;
> > > +	return mem.page;
> > 
> > This part is mostly fine but I do wonder why not make this alloc
> > function the same as buddy alloc_pages_node() - return a struct page
> > pointer.
> 
> I'd argue we shouldn't even be returning struct page here, do many
> places even use the struct page? What for?

I just suggested it for similarity with alloc_pages_node(). It can be
made better indeed.

> Exposing struct page to places that just want a kernel addr means they
> have to call page_address and we are back to the highmem weirdness.

dma-buf system heap needs struct page for scatterlist, so we need the
virt_to_page() conversion if we return a VA.

> > >  static void its_free_pages(void *addr, unsigned int order)
> > >  {
> > > -	/*
> > > -	 * If the memory cannot be encrypted again then we must leak the pages.
> > > -	 * set_memory_encrypted() will already have WARNed.
> > > -	 */
> > > -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
> > > +	struct cc_shared_layout layout;
> > > +	struct cc_shared_pages mem;
> > > +
> > > +	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
> > >  		return;
> > > -	free_pages((unsigned long)addr, order);
> > > +
> > > +	mem.page = virt_to_page(addr);
> > > +	mem.shared_size = layout.shared_size;
> > > +	free_cc_shared_pages(&mem);
> > >  }
> > 
> > Here it gets weird and I don't see why we can't have just a buddy-like
> > interface. The kernel-doc for alloc says that shared_size must be
> > retained for the corresponding free but without reading the source code,
> > you can't tell that cc_shared_calc_layout() gives you the same
> > shared_size populated by alloc. We have a similar pattern in dma-buf but
> > using the compound page order.
> 
> This makes sense, we should not be passing size to a free function,
> make a compount page/high order folio instead if the API is going to
> be struct page based.
> 
> > We can get rid of layout and mem structures (or at least not as
> > part of the API). Of course, this assumes that the shared granule size
> > remains constant for a guest's lifetime but I don't think that's a
> > problem.
> 
> It should be encoded in the struct page meta data, as the order.

I agree.

> > Was there a caller you had in mind that needs the common allocator to
> > share less than the whole buddy block?
> 
> If we want this it definitely needs to be a void * based API not
> struct page one though..

For whole-block sharing, either a VA or a folio works for me. If the
allocator takes an order, the requested size and the sharing granule are
both powers of two. Rounding up to the granule already gives a valid
buddy block size, so there’s no need for a separate shared_size.

-- 
Catalin
