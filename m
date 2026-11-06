Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979022;
	b=DilXxVzVf0gzWulX8Gk3GNEsDf/Bek64gMS2RdNMrR+G6GuvTlxYhNrK05kRBFDe1xz+
	 h7PbPs7cq1pV+htTCDVPESkh/HZUNLjb/uxXefPSzonJxDXYFG2zJ+dHVDjn65cUhc+fP
	 36/tPc1cpP1Y/+6MV/D80Y9GTA8YDAhJ3WYyk60q0UOfuqQoxPH5sjg5Awp4h+Wh8k028
	 Ln6NOKDcdP0b/Thby8eSlhzOUYTeTzayrJu1vkyR+EU/p9B3cgc9hbk31fxeBZSuadh9R
	 s17mmON4b341Lz++55k2Rs8ImBkX8hXz43g5NlwI/n2H5+vZr3vR1MhwMyTVDdxhCKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979022;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=6ajX4lfiph+VivXIsw2riYK43KZT3Do0cgXxc26s8IY=;
	b=euK2x3Itm+g1vihfqM9K9oqNA7S392+uN/nMds1LN1Q3EUuJcInPovZCI318ktVkI87g
	 E3DisGOEysPeScFcg8izKHmrmHwajn+H9h2Dz3s6rp51M4cKa7nvPqrTIL7LbNI59ZAEK
	 iK386wOxwl7dI8vhtkMj8JDDHmi4f5bBiUCHKH+PyzMQtKQ7/LTQULQ180rxTTnBt4Jfi
	 cijOLa8ylOHjz2xQWo4Vd0IV3bROU3+MiyAwUTWXqtCRH4McTWAGqUTBK5lWf+BZWrFdM
	 Vpqo48JYv5SMEDEGQwiT633S8xsegYGhJy18FXQiqu7TBl2NUrBVm8NQtqFdZikDFBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ZRYmaiq/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0499F606A32C;
	Fri,  6 Nov 2026 15:30:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZRYmaiq/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E4D1F0089F;
	Fri,  6 Nov 2026 15:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793979021;
	bh=6ajX4lfiph+VivXIsw2riYK43KZT3Do0cgXxc26s8IY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=ZRYmaiq/u/SQjBF4ufiS7XCsUtIWBR8hL8WYwn3u9em1LPif/YCL7ChpmRJhgOyIX
	 7IC3EXVPCAkmKpLit8fAZGhbU6zO4Vo41xdkh0y1FE4VLwuE7EJ30uktOPNCEggpHD
	 MbD1RX7dmUIkjT1awTBDV15avM4RN85WC1q1el5mr5tbkabk3V6dhoZUlfF40LSpgk
	 KGlR22lgb9rXJhGOGQUNnGEHkpSn3m9hgHzxauJLxhjdxnvoN5U5o3aZh72JhgeHUT
	 8BdOqsA5VITYBbXwdbZ6w5prD5p1MVjT+3jhhqFtkmeHdpWI1SXbbXixdwYl6O4EkL
	 ecOySiCRp0UYA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Suzuki K Poulose <suzuki.poulose@arm.com>,
	linux-coco@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Steven Price <steven.price@arm.com>,
	Sumit Semwal <sumit.semwal@linaro.org>,
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
Subject: Re: [PATCH v9 01/14] mm: Add an allocator for CoCo shared memory
In-Reply-To: <2e448ac1-7b4f-4d45-90db-dfe9dc5ad329@arm.com>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-2-aneesh.kumar@kernel.org>
 <2e448ac1-7b4f-4d45-90db-dfe9dc5ad329@arm.com>
Date: Fri, 06 Nov 2026 21:00:01 +0530
Message-ID: <yq5ald76ou4m.fsf@kernel.org>
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

Suzuki K Poulose <suzuki.poulose@arm.com> writes:

> On 04/11/2026 16:45, Aneesh Kumar K.V (Arm) wrote:
>> Confidential-computing guests may require memory shared with the host to
>> be aligned and transitioned in units larger than PAGE_SIZE. Several DMA
>> users need struct page-backed allocations satisfying these requirements.
>> Provide a common allocator instead of requiring each user to open-code
>> this sequence.
>> 
>> Add alloc_cc_shared_pages() and its node-aware variant. The allocator
>> rounds the requested size to the architecture's shared granule,
>> allocates suitably aligned contiguous pages and transitions the
>> complete range to shared state. It also preserves the caller's GFP
>> policy.
>> 
>> A private-to-shared transition may alter memory contents. Mask
>> __GFP_ZERO from the underlying allocation and when requested, clear the
>> complete transitioned range after cc_make_shared() succeeds.
>
> This is not true for pKVM though. It is the other way around. i.e,
> pages must be cleared before transition (e.g., from private to shared)
> to make sure the contents don't leak into the host.
>
> Do we need to handle such cases with a pre_conversion and 
> post_conversion hook ?
>

Patch 2 does something similar.

-aneesh
