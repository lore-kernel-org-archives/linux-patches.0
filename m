Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527024;
	b=kRFKMj0CqlV1BiTyXRyogBikLYBydgSDHbUaHZWiHqMn7xXxBORPwl8jeptbLqD2tUiv
	 OWDgBRAhC0RxGz9Q+mkYUWNJ/uMAJnoDyxkgwXJN8oRLN8aAB8YZCALRAPvHVzchz0ZNp
	 mqdS/3cIj49kU6ncui5xcOqukfuNYRLzhw6VV1VCu+kA9IR6PvpaHwNtOQl/M5kUFS3jd
	 0L7vvzyBA5X8WGgPwcYjMh+0uawk4nvTflnXyvHLz23MPnEp7McyF733VjQyolV+zS7a5
	 7qubxFYw8Mz6ZytaOgEaXL6i+axdnF1mrSOok5p9xeKosfpeqQASCvHNHaiiLIiV6DA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527024;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=5dHp9HTARdoHtxKAu6nPHPSzmPEU1mRqVl5Dy4Gq+ko=;
	b=NuI2ESHs8C8X4SnNnVkNtSo/3bYap701aUypGHzxvzrNletSSbBIJe6emmn0kA4RpVoK
	 ykBIQ5ARjXOOMR3y8qHbjleXA9YaHR6G0I4HxX3ljggnBzb+oCNyEQTmjfNQAfJ3tSvGd
	 z79dfnrsemr22bfRPz5/LeqVk2TZqY+zkboq598mNdzV7/18Ye1gQWJ5f88QkWkXDqN71
	 wWuymAdc/tbbxkAIa0GTS2b9o3K/n2glLFqPappKLzUWZaekxxEA4R6MFOM1i2QV8ECQn
	 1eFyW3y1MTumBQy1qH1xTGKNHExoaFG2c58oVjG0K4QmQxRTvAAHLhFFhWl7vsK5+Lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCqxzAJj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5B0606A331;
	Tue, 24 Nov 2026 13:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=jCqxzAJj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1429B1F000C6;
	Tue, 24 Nov 2026 13:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795527024;
	bh=5dHp9HTARdoHtxKAu6nPHPSzmPEU1mRqVl5Dy4Gq+ko=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=jCqxzAJjVpIJjwovRyqxRWcIP/1B3dGdfwKBWeMKdR8HKyUrkxtLFRbPDJMQLyrXb
	 owAqj3PB6cKHqac2gb0IwSUnm6Jz149LTaGXvIacdGk2W381ux3zvZoZXbN+neKPF3
	 1PHEsfLA8kEDrjmujBkqVkHmbA0E8gDIOIkjgM6J5C2vcD1lMEU6JiYCBpy8r5CFJo
	 cdhDHzPASzOI9GYVDMxu8Q3IH3tHuhugE5hCwGZ29K+jacyTfw/E4MwfT2i06O/AFL
	 R4B/E6tiODpZWkUSH2LaCdCMjaXBhI2MO9cxeHkKmawVLpMcJRxhf31tfzXIRXcjR3
	 N/DAqTlKmk0CQ==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian K?nig <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Will Deacon <will@kernel.org>,
	Russell King <linux@armlinux.org.uk>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Brian Starkey <Brian.Starkey@arm.com>,
	John Stultz <jstultz@google.com>,
	Mark Rutland <mark.rutland@arm.com>,
	Radu Rendec <radu@rendec.net>,
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
	Sven Schnelle <svens@linux.ibm.com>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H . Peter Anvin" <hpa@zytor.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	"K . Y . Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>,
	Dexuan Cui <decui@microsoft.com>,
	Long Li <longli@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
In-Reply-To: <awQd81MwZqi55gf8@arm.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
Date: Tue, 24 Nov 2026 19:00:00 +0530
Message-ID: <yq5aa4mybbmv.fsf@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Catalin Marinas <catalin.marinas@arm.com> writes:

> Hi Aneesh,
>
> I'm replying on this patch rather than on the one introducing the API. I
> think it's more obvious here why I think we can make things simpler.
>
> On Mon, Nov 16, 2026 at 02:41:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
>>  static struct page *its_alloc_pages_node(int node, gfp_t gfp,
>>  					 unsigned int order)
>>  {
>> -	struct page *page;
>> -	int ret = 0;
>> +	struct cc_shared_pages mem;
>>  
>>  	if (node == NUMA_NO_NODE)
>>  		node = numa_mem_id();
>>  
>> -	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
>> -
>> -	if (!page)
>> -		return NULL;
>> -
>> -	ret = set_memory_decrypted((unsigned long)page_address(page),
>> -				   1 << order);
>> -	/*
>> -	 * If set_memory_decrypted() fails then we don't know what state the
>> -	 * page is in, so we can't free it. Instead we leak it.
>> -	 * set_memory_decrypted() will already have WARNed.
>> -	 */
>> -	if (ret)
>> +	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
>> +				       PAGE_SIZE << order, &mem))
>>  		return NULL;
>>  
>> -	return page;
>> +	return mem.page;
>
> This part is mostly fine but I do wonder why not make this alloc
> function the same as buddy alloc_pages_node() - return a struct page
> pointer.
>
>>  static void its_free_pages(void *addr, unsigned int order)
>>  {
>> -	/*
>> -	 * If the memory cannot be encrypted again then we must leak the pages.
>> -	 * set_memory_encrypted() will already have WARNed.
>> -	 */
>> -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
>> +	struct cc_shared_layout layout;
>> +	struct cc_shared_pages mem;
>> +
>> +	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
>>  		return;
>> -	free_pages((unsigned long)addr, order);
>> +
>> +	mem.page = virt_to_page(addr);
>> +	mem.shared_size = layout.shared_size;
>> +	free_cc_shared_pages(&mem);
>>  }
>
> Here it gets weird and I don't see why we can't have just a buddy-like
> interface. The kernel-doc for alloc says that shared_size must be
> retained for the corresponding free but without reading the source code,
> you can't tell that cc_shared_calc_layout() gives you the same
> shared_size populated by alloc. We have a similar pattern in dma-buf but
> using the compound page order.
>
> What's wrong with a simpler API:
>
> struct page *alloc_cc_shared_pages_node(int nid, gfp_t gfp, unsigned int order);
> struct page *alloc_cc_shared_pages(gfp_t gfp, unsigned int order);
> void free_cc_shared_pages(struct page *page, unsigned int order);
>
> Both alloc and free take the original request order and perform the
> round up internally without exposing the details to the caller. Alloc
> shares the whole resulting buddy block and free makes the same block
> private before releasing it. We can document that free takes the
> original requested order and releases the whole allocation. Partial
> frees aren't supported.
>
> We can get rid of layout and mem structures (or at least not as
> part of the API). Of course, this assumes that the shared granule size
> remains constant for a guest's lifetime but I don't think that's a
> problem.
>
>> @@ -278,7 +267,8 @@ static void *itt_alloc_pool(int node, int size)
>>  		if (!page)
>>  			break;
>>  
>> -		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
>> +		gen_pool_add(itt_pool, (unsigned long)page_address(page),
>> +			     cc_shared_granule_size(), node);
>
> Here we can introduce:
>
> unsigned int cc_shared_page_order(unsigned int order);
>
> and just use (PAGE_SIZE << cc_shared_page_order(0)) for gen_pool_add().
>
> Was there a caller you had in mind that needs the common allocator to
> share less than the whole buddy block?
>

No, I don't have a caller that needs to share less than the whole buddy
block.

Taking Jason's feedback into account, we could have the allocator
request compound pages and recover the actual allocation order with
compound_order(). That would avoid passing an order to free:

void *alloc_cc_shared_node(int nid, gfp_t gfp, unsigned int order);
void *alloc_cc_shared(gfp_t gfp, unsigned int order);
void free_cc_shared(void *addr);

Alloc would round up internally and share the entire buddy block; free
would recover its order, make the whole block private, and release it.

As you noted, dma-buf would need virt_to_page() to obtain the pages for
its scatterlist.

-aneesh
