Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793976128;
	b=o8Ws7yQJ7H4TaoEXR3Ak6DaSCROxx9ejPBItqUMj1mHca4TPFQYsZJE7ci5JvaPbmIMS
	 vYg1BpW3EcUEgtdxygnkHzJp0SlFHD9XOLTE3Qv1WZ6T2USBsQfN7o9ftN51mzIXWv6VL
	 3kzHvSN0lc281+SgctIvzEKGgADxPLRAQrQX8jdWbHl9gAe0GnfabXkmnbmQS0BXzBKZE
	 rZkGjVYb/9K4SV7AJmnmlwwZ31zT0c8yFYM9HcK2tD/CqXsMyhEpegvq6zi4uJF2jaOFl
	 NwTt9+anQyjOdP6oJ9SAdlSmgvPTYI6HVNqMHlXKSDKIN7db7A+QrpMOty9Iaexqg8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793976128;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=dPrT1d3tfAdRZHoFdKvhwwCCJALbTuZcl0ma0HWZQHQ=;
	b=VyGodivQrvBPd9TSRKbU6matx8c1uoehl52VWRv0PIEZstRWUoAYRK4+zLKzmyYL8dJm
	 29ARuQQZ64QRf053wfdR3E+FZm+Qs/9+yjhzsK5K77pTlfR4p9v1FHcbqq51+t/I29rcc
	 8B27Gkrd2p0oReCmqMhZZO9slfsSW1NWQAaItanOv95pZc5QtTcDFohpIWH3iSAfZSMdF
	 rzLbyyQLEM453yIlw9Jj7/fLzqVO4yy/PdoQCF+yWeuDwhO9Qi836ytCBqflZ3b3QFifL
	 ozceQGrvumiMwJnaOPdj54OVMAZflXZzXw9PY7DODu5l7I9jC9NXoM+b/ScQQNjVV3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b="B/mbpzSL";
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 838EC606A32E;
	Fri,  6 Nov 2026 14:42:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 838EC606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=B/mbpzSL
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BFBD31682;
	Fri,  6 Nov 2026 06:42:03 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C297A3F673;
	Fri,  6 Nov 2026 06:41:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793976126; bh=RROBsGVNy+Oakstf6DXz+xH01uQZXz9GOkcgQ0meiw4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B/mbpzSLUIxkLsvdYEgUGs2NsLPfEoaHIS2u4uoKA+TM6l8BAPmmaFFiWCiMC/+zG
	 RnZu7A5UIYQ7u/AWqfgGaXvhX9c5DxYbnRdfhdakUjLrptQLm8mu5OPAnNzPX6lE/G
	 B3q1sAgPLmHroCXLRJ29Lu6hp0qwTMoNkNoh4n1Q=
Message-ID: <2e448ac1-7b4f-4d45-90db-dfe9dc5ad329@arm.com>
Date: Fri, 6 Nov 2026 14:41:57 +0000
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 01/14] mm: Add an allocator for CoCo shared memory
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
 linux-coco@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Marc Zyngier <maz@kernel.org>, Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Steven Price <steven.price@arm.com>,
 Sumit Semwal <sumit.semwal@linaro.org>, Thomas Gleixner <tglx@kernel.org>,
 Will Deacon <will@kernel.org>, Russell King <linux@armlinux.org.uk>,
 Benjamin Gaignard <benjamin.gaignard@collabora.com>,
 Brian Starkey <Brian.Starkey@arm.com>, John Stultz <jstultz@google.com>,
 Mark Rutland <mark.rutland@arm.com>, Radu Rendec <radu@rendec.net>,
 "T.J. Mercier" <tjmercier@google.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani
 <ritesh.list@gmail.com>, Shrikanth Hegde <sshegde@linux.ibm.com>,
 Alexander Gordeev <agordeev@linux.ibm.com>,
 Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
 Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
 Christian Borntraeger <borntraeger@linux.ibm.com>,
 Sven Schnelle <svens@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, "H . Peter Anvin" <hpa@zytor.com>,
 Kiryl Shutsemau <kas@kernel.org>, Rick Edgecombe
 <rick.p.edgecombe@intel.com>, "K . Y . Srinivasan" <kys@microsoft.com>,
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>,
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>,
 Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
 linaro-mm-sig@lists.linaro.org, linux-arm-kernel@lists.infradead.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org, kvmarm@lists.linux.dev,
 patches@lists.linux.dev
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-2-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261104164555.3555725-2-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/11/2026 16:45, Aneesh Kumar K.V (Arm) wrote:
> Confidential-computing guests may require memory shared with the host to
> be aligned and transitioned in units larger than PAGE_SIZE. Several DMA
> users need struct page-backed allocations satisfying these requirements.
> Provide a common allocator instead of requiring each user to open-code
> this sequence.
> 
> Add alloc_cc_shared_pages() and its node-aware variant. The allocator
> rounds the requested size to the architecture's shared granule,
> allocates suitably aligned contiguous pages and transitions the
> complete range to shared state. It also preserves the caller's GFP
> policy.
> 
> A private-to-shared transition may alter memory contents. Mask
> __GFP_ZERO from the underlying allocation and when requested, clear the
> complete transitioned range after cc_make_shared() succeeds.

This is not true for pKVM though. It is the other way around. i.e,
pages must be cleared before transition (e.g., from private to shared)
to make sure the contents don't leak into the host.

Do we need to handle such cases with a pre_conversion and 
post_conversion hook ?

Cheers
Suzuki

