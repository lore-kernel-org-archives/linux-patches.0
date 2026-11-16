Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794823787;
	b=iAqocPwtWLLzX5ULxX5rfsySIfkohj6thoMUikcObLzu1QwKA845JkGVIKmrH2QZwLan
	 Is374umiUVLxNuYO5BZCQLdwWIZXmihr0UrxloENCf82K8+IgJ91ABfspxY28EOSclzzl
	 m01/CTZr+b8FGo1c1URRdhYwf5L/ijD2k+CW8sOgrqbburrxffBtqhST0sC1Rzp+I5g3U
	 vXF1BF2wzaQbij4GZbxwMu7eIzwnQLVx1hRUG303KifMvCfsPstLLLi/bxIuxSirh9r8k
	 UqbtVJjdZQO4aLtlyNCVT57L8l5QwCvblqcE39a1tCcxeurNs2l1Xqs5CuGhGcwpjCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794823787;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=koCbOd0tdqhrnAzypAwoIYt0Xseq42FLcbswCn/kURA=;
	b=Yit+x8nQHtlG4uQU1kDZ8YaO/9rHXpihOXenkvRkQner5HriD/V3WmUszwjlqgkkWWiR
	 IoZVy+Chr1WwXqXm5xeGXGfGNxfjcPenqwKII8Jf+JnIBZp1Mhw/Hmoz7T0q52qtPmJFe
	 ZDX8S5ZXdtCabg2q1zWgp0sw1My0KNEnuJ3t05+9RXz/Mu7YEfgorJ0amQa4k5gD8mxOU
	 Z1OWue6EupSyUC77rJ1PCIXU+aZAnWSOUwy9stwFDG2A8KZKtD7U8Kq4NWhzc1m9DA5kE
	 +W0rEC9YrXcyaPvPvmA9Z6LC2XCkchqCkteW4JBMHLHuErEh4eiaXmIO/lp8aB9i0oA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HEymC+HY;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56C02606A329
	for <patches@lists.linux.dev>; Mon, 16 Nov 2026 10:09:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 56C02606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=HEymC+HY
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A03211713;
	Mon, 16 Nov 2026 02:09:43 -0800 (PST)
Received: from [10.2.197.99] (ewhatever.cambridge.arm.com [10.2.197.99])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 726053F632;
	Mon, 16 Nov 2026 02:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794823786; bh=2ad7YSntj3N8mQFw+MdlSPpSYmiwoq+kfn6LiXSNNQs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HEymC+HY2cjrTWlk5Rrica1pXk+RwFDrHn67MHbsdlytf78F9T92did0jsY25RToE
	 sSptL9z9vRblTwNCeZdQbDIdCAcbDlQ2zYp18Tdyi36jH6aNLiGqDcEjfxLEaws769
	 jKj/QuiKH6fEL8kQv4xYSwiCkECe+c4s3EoSb1ZQ=
Message-ID: <0524abf4-2306-4046-aade-c23aa7d1e0e6@arm.com>
Date: Mon, 16 Nov 2026 10:09:35 +0000
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
Subject: Re: [PATCH v10 00/13] coco: guest: Add a shared-granule allocator for
 host-shared memory
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
 patches@lists.linux.dev, Alexey Kardashevskiy <aik@amd.com>,
 Michael Roth <michael.roth@amd.com>, pankaj.gupta@amd.com
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
Content-Language: en-US
From: Suzuki K Poulose <suzuki.poulose@arm.com>
In-Reply-To: <20261116091137.94252-1-aneesh.kumar@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Cc Michael Roth, Alexey, Pankaj Gupta

On 16/11/2026 09:11, Aneesh Kumar K.V (Arm) wrote:
> 
> This series tightens the alignment requirements for buffers that are shared
> between confidential-computing guests and the host, and adds a common
> allocator for host-shared memory.
> 
> When a guest runs with private memory, buffers shared with the hypervisor
> are not only accessed by the guest. They are also accessed by the host
> kernel, and the host may manage the corresponding shared/private state at a
> granularity larger than the guest page size.
> 
> Architectures such as Arm can detect incorrect accesses to Realm physical
> address space PFNs through GPC faults. However, relying on that as the only
> line of defence is fragile and can still lead to kernel crashes. The risk
> is especially visible for shared buffers that are later mmapped into
> userspace, such as guest_memfd or dma-buf backed allocations. Once
> userspace can access the mapping, the kernel cannot guarantee that
> applications will only touch the intended 4K region rather than the whole
> host page mapped into their address space. Those userspace addresses may
> also be passed back into the kernel and accessed through the linear map,
> resulting in a GPC fault.

IIUC, AMD SEV-SNP also has a similar requirement for other reasons, to
align the "shared" allocations within a guest (2MB ?, as mentioned by
David Kaplan at the LPC).

Michael, Alexey,

Please could you share your thoughts on this series ?

Suzuki
