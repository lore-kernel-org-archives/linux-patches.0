Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795431936;
	b=HpD9vU7dAVnhSDHe1669hm+G0hl4Z5hdkranDlUec6eajlA2FQbLLwh0x/iNb4S+hlIq
	 1I1npKg8DZCgNh8AZ4WrSDPYw5hzw9IvnkXwcAIabh16m4AQtoqsKcX0ECruYdE3FZgKf
	 U32Pf+r27WqI2l5QPB3hzBv64H7mmp+UuKe6LWJV6b42IhvJB2nz74eoQwFptXGNzRo9z
	 7N4EQTulfcBtCVByhz8HqaHUFH57HI8wO3zaX1C94RW/t7PsX6paaZ2IZgnK6Qs279xl4
	 Cp3PR4+9d5Kfk8egb0HfeNwY2TQG5LWN5d1mMlhZuFsU/x6bE5TbP6Jc4URhrwMW7VQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795431936;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=y+pXRncvtOc4nB9TtW4KG6FLyRulzoczl3trVZwKBJI=;
	b=gKcdcbLrWHqGEd7xqEF/g38O5TEvhEC9iwDwBx/By1vTQlS22oj7k8NWCiuxRkmk1Ch9
	 MPx0EQCBGbYQwMvr6cihp3rHeVG0s74yMDCgCXg8nAAcysVDLEANjbsW7lImeZuXS2avE
	 oHWxdHNNvYi+3fzGNXVy3lHnUvxzRS6qtgGd+5L9jQptPCTBaHHH5uYu358WFFahxlJMz
	 YdHgmaB+ZnAD/6+gBGc15QwRiDNVey52sU/Wfdkpz+seRrcW0cHSKRjrONkfcvHfRT7rQ
	 n7dtR8hKjSnMPK0kZd3ZfE9/lj12CW3k4wDItMCyVgZwdCVOqum95xW2tHfJrEgcZBg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KvhrT8NK;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B0680606A31E;
	Mon, 23 Nov 2026 11:05:35 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B0680606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=KvhrT8NK
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 218E3143D;
	Mon, 23 Nov 2026 03:05:32 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A83273F882;
	Mon, 23 Nov 2026 03:05:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795431935; bh=kCUeWgNlDSox1V+xXIV0FoQklIwe01iQtQShkTSpFns=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KvhrT8NKkwfUQlN/JVYJ5xdBVy5POFXKjhsTfodMnif/DZoxUXBTRSE+v99DKNllE
	 5d1fBxUVR51g74P9by/+O7T3jZUmuCzToT2ynvCd+snaLJQPIjfE7jA9gHVgHouzT3
	 DFYSeENRGheUkSn0CCeE9f0MsFw+W0BZ+uXNA9WQ=
Date: Mon, 23 Nov 2026 11:05:23 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
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
Message-ID: <awQd81MwZqi55gf8@arm.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
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
In-Reply-To: <20261116091137.94252-5-aneesh.kumar@kernel.org>

Hi Aneesh,

I'm replying on this patch rather than on the one introducing the API. I
think it's more obvious here why I think we can make things simpler.

On Mon, Nov 16, 2026 at 02:41:27PM +0530, Aneesh Kumar K.V (Arm) wrote:
>  static struct page *its_alloc_pages_node(int node, gfp_t gfp,
>  					 unsigned int order)
>  {
> -	struct page *page;
> -	int ret = 0;
> +	struct cc_shared_pages mem;
>  
>  	if (node == NUMA_NO_NODE)
>  		node = numa_mem_id();
>  
> -	page = alloc_pages_node(node, gfp | gfp_flags_quirk, order);
> -
> -	if (!page)
> -		return NULL;
> -
> -	ret = set_memory_decrypted((unsigned long)page_address(page),
> -				   1 << order);
> -	/*
> -	 * If set_memory_decrypted() fails then we don't know what state the
> -	 * page is in, so we can't free it. Instead we leak it.
> -	 * set_memory_decrypted() will already have WARNed.
> -	 */
> -	if (ret)
> +	if (alloc_cc_shared_pages_node(node, gfp | gfp_flags_quirk,
> +				       PAGE_SIZE << order, &mem))
>  		return NULL;
>  
> -	return page;
> +	return mem.page;

This part is mostly fine but I do wonder why not make this alloc
function the same as buddy alloc_pages_node() - return a struct page
pointer.

>  static void its_free_pages(void *addr, unsigned int order)
>  {
> -	/*
> -	 * If the memory cannot be encrypted again then we must leak the pages.
> -	 * set_memory_encrypted() will already have WARNed.
> -	 */
> -	if (set_memory_encrypted((unsigned long)addr, 1 << order))
> +	struct cc_shared_layout layout;
> +	struct cc_shared_pages mem;
> +
> +	if (WARN_ON(cc_shared_calc_layout(PAGE_SIZE << order, &layout)))
>  		return;
> -	free_pages((unsigned long)addr, order);
> +
> +	mem.page = virt_to_page(addr);
> +	mem.shared_size = layout.shared_size;
> +	free_cc_shared_pages(&mem);
>  }

Here it gets weird and I don't see why we can't have just a buddy-like
interface. The kernel-doc for alloc says that shared_size must be
retained for the corresponding free but without reading the source code,
you can't tell that cc_shared_calc_layout() gives you the same
shared_size populated by alloc. We have a similar pattern in dma-buf but
using the compound page order.

What's wrong with a simpler API:

struct page *alloc_cc_shared_pages_node(int nid, gfp_t gfp, unsigned int order);
struct page *alloc_cc_shared_pages(gfp_t gfp, unsigned int order);
void free_cc_shared_pages(struct page *page, unsigned int order);

Both alloc and free take the original request order and perform the
round up internally without exposing the details to the caller. Alloc
shares the whole resulting buddy block and free makes the same block
private before releasing it. We can document that free takes the
original requested order and releases the whole allocation. Partial
frees aren't supported.

We can get rid of layout and mem structures (or at least not as
part of the API). Of course, this assumes that the shared granule size
remains constant for a guest's lifetime but I don't think that's a
problem.

> @@ -278,7 +267,8 @@ static void *itt_alloc_pool(int node, int size)
>  		if (!page)
>  			break;
>  
> -		gen_pool_add(itt_pool, (unsigned long)page_address(page), PAGE_SIZE, node);
> +		gen_pool_add(itt_pool, (unsigned long)page_address(page),
> +			     cc_shared_granule_size(), node);

Here we can introduce:

unsigned int cc_shared_page_order(unsigned int order);

and just use (PAGE_SIZE << cc_shared_page_order(0)) for gen_pool_add().

Was there a caller you had in mind that needs the common allocator to
share less than the whole buddy block?

-- 
Catalin
