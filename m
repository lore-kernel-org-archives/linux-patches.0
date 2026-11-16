Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794810085;
	b=x/ozySgMZknV4vKeYq5TtYujcgvHo3y45nhZWzizCwUKpJOg1lNg8AQuREmw0IIUjWy3
	 JABvK81nhQXtRCcm0Zus4MCQXCl2Ly9NBuEmaxhdRcHKJZ77Vn95trBEuF7bCuedy5KAP
	 CKnPphzO4FLP+s4u2sqdEL89yamV4j7uACAdquEiDkkWxIhCxOnZuTMHmwCE/1X3AQ9bn
	 hpngZ7EbFF70UeyuUIFyvSLq5l5NEo06FbRpalW2P9X6nfuaslOqgiWOnr3vUEvwTzsXZ
	 v4Wym4b35ri5Y7jojdLPPfOhgR8/tR/qenHsRT7E3HBG9Pdeu8d6qgiXWpgZbrbCi8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794810085;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=ZGtf5qEhwHANt9S2IldNkWh18GQwYTwsu6dC3M4N+D0=;
	b=URspDJ3Qvm9xYrreL7Qmz7Zvl399M4w0Nsokh/x0s9B+5SryKrB5KqTTXI84Y6FkQTF+
	 A1J19vR58U1p7AYXwH865zwVafytwXqskmy/bnxfYDWuPsKqcyaU6+qw4mIyU3bkId7Dd
	 Yckqt1rtpYFBDl5U34BO9NL5EFgz5+gpBhRZr7qc8WHN2AR2fqOkS9OAFu1IUplJsvpi3
	 ScxCmjRlahVpNjY8AWAHEdcyWYtx9RgPL+ZGTBAeBv/XYyeYKrYDLN6tor0WV6raNyjQ5
	 CH1cwQvkRsenwseBiNhhTRc9gTxwgNW24Q1U7aT50CAFl6h13qlPeIZE+DqGuLaulIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUA9dup0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A8F0606A31C;
	Mon, 16 Nov 2026 06:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=GUA9dup0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BBD01F000C4;
	Mon, 16 Nov 2026 06:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794810085;
	bh=ZGtf5qEhwHANt9S2IldNkWh18GQwYTwsu6dC3M4N+D0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=GUA9dup0fJoWa6DD08lCGejGIeihAF7ZTATO3ZR3GPC9cXgSEgzzlNqI3pfVyB+Hi
	 qgCm0/gPhdYZphvuSbKs+NCpccVb1MGhx1DwDVRPU4MBuP6cl5DOGzk0ZieQOKFUXx
	 HBIrWCyjk6fX/0OhKhYhW+ksoU8o+0btHpkKE1PIVjv1lAVmfS1vX0fOyWs6baK0nD
	 AtaKkLIVR99DkhAuobP0HpDKOgFbhS11Ma/wyrhb4BcdfV2PeCJwKwso2a3p5N7nGU
	 Y7QTRkaB25YaqZHggv2zPj0b/6uLh0Kl3D/sWZOvcPqGSpmLlm/YIThrsBaw7FT7Ly
	 gr4xBUww9w8ug==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Marc Zyngier <maz@kernel.org>
Cc: linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Joerg Roedel <joro@8bytes.org>,
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
Subject: Re: [PATCH v9 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
In-Reply-To: <87ld6x8zb7.wl-maz@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-15-aneesh.kumar@kernel.org>
 <86zevn1c9a.wl-maz@kernel.org> <yq5ah5huoteu.fsf@kernel.org>
 <87ld6x8zb7.wl-maz@kernel.org>
Date: Mon, 16 Nov 2026 11:51:04 +0530
Message-ID: <yq5apkw5xpnz.fsf@kernel.org>
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

Marc Zyngier <maz@kernel.org> writes:

> On Fri, 06 Nov 2026 15:45:29 +0000,
> Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
>> 
>> Marc Zyngier <maz@kernel.org> writes:
>> 
>> > On Wed, 04 Nov 2026 16:45:55 +0000,
>> > "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>> >> 
>> >> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
>> >> not allowed.  Remove the page allocation from this atomic path.
>> >> 
>> >> Use a blocking allocation for the boot CPU and record the resulting table
>> >> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
>> >> stage for each secondary CPU.  Consume the preallocated page only when the CPU
>> >> cannot inherit an existing redistributor or ITS table.
>> >> 
>> >> Reclaim unused preallocations after the CPU reaches the online state, and from
>> >> the prepare-state teardown when CPU bring-up aborts.
>> >
>> > No. The way to do it is to move the ITS probing out of the
>> > non-sleepable CPU hotplug path.
>> >
>> > I proposed a potential hack at [1] (which I find far more palatable
>> > than this proposal), but the real fix is to probe the ITSs as
>> > devices.
>> >
>> 
>> Could you share a bit more detail on what you have in mind?
>> 
>> Are you suggesting that we create a platform device for each ITS and
>> initialize it through the driver's probe callback, while the rest of the
>> GIC initialization stays in the existing early boot path?
>> 
>> Would that mean the main GIC is operational during early boot, while
>> ITS-dependent features, such as MSI delivery and direct injection, become
>> available after the ITS devices probe?
>> 
>> Is that the split you have in mind?
>
> Yes. Then once this is done, all the tables become normal DMA
> allocations, for which there should already be adequate support.
>

Thanks for confirming. Can we handle the ITS platform-device conversion
and the switch to DMA allocations in a separate series?

The existing VPE L1 allocation path calls set_memory_decrypted() from
the non-sleepable CPU-starting callback, even though
set_memory_decrypted() can sleep. This issue predates the shared-granule
allocator changes.

Since fixing this properly needs a broader ITS rework, can we handle
that separately and drop the preallocation patch from this series?

-aneesh
