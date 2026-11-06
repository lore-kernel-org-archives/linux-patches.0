Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793979951;
	b=cmHwUTXFa2g8OX3Zcd8QWfCHvP8Q8vctzDmY1w+kKO0UZDC71KDh9E1IYcRcjfGhbhwd
	 yQi01ayzohLMYQSyykjlvZ/Ovp5B+y0M6RUWw5SlE5HW/0ZyJVvA2AyjqXWdE5JFjs5MO
	 ELINClAgEFoWKmbOQZzSd3HXUX6yY9chdzRXlDDwBDbULlQHBkWCnojQeinTXRMaPxd8c
	 RRLLmuxZI3UlOlk0qiWal6B7VHeRJE2U90hcZvamfWsGArm2eMxNaUvfXwl5L1BqLMtaD
	 Iq0Ag+ZL17XZawGZGpUOnnYoNiBCG1VUYX8a0rBmEZfS8dGRkgm0MFCIt+uKEYghfIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793979951;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=Sf7jpXPq+wp6SBfVuD5VhfW8K2K7PrL3pzRu30lk/Qs=;
	b=t27Nu6A4dSRstJ2ekZeqCVyEvHldmsoFWbvoTg7/G1cQWZGlYU1LJ20ysML27/six1kx
	 p8Z1G2xe7BkCvfOLYLaWEsdk7W5T+HtJFcMGWUhwvrwtdqyupVSJCE+DVZiKCQOAFRN+K
	 d7lgcsa39gU1hGl/rgR5bgxOiCVQ9LlmgUD3Vk/NcQDtFhAuXfkvKbsyqxpb/NQV+5WJF
	 zB0XxL8C7Jf8jIC10FnLpX+lLjTebst3AlGcfyI7punLCOse6ayCubasqmWdKZTp9JfH8
	 itDVk1eemmDQN7dB09x3WJ/oVB0PElknFKRSKQFx5i62ZB3bTZc2aBfBMxzRPw+QawQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHfHZnPS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F30606A329;
	Fri,  6 Nov 2026 15:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NHfHZnPS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC1B21F008A1;
	Fri,  6 Nov 2026 15:45:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793979950;
	bh=Sf7jpXPq+wp6SBfVuD5VhfW8K2K7PrL3pzRu30lk/Qs=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=NHfHZnPSDSHLthC28xmc7Tynk3g3EuBVtAtF3YePrjls2avEgiFGihXMqKalL6SYK
	 SeJfbKbhS1SHWhGP9tCN6jALT7jREvu0x9m17dhcE0oLL42alVk0H4Ve6UWnQsZ17V
	 pOd3zRki1UcQZ29EAFK0E5v9T4pzWtOa2Z1QlBdeIUapAvd2pzBNLlIfkVE6aLRurr
	 uq5rcOkbHr9280TJ3ts+7TSC30ovRao2lHyLtEiO9tHldNoUeF0owFJmmy9pFG8jCG
	 5cQRmxsKh588fJfaFewhWE1XgoaoMSVyjoOt6yV+WAzO5GfLn/FYQd7wPywABOqUIP
	 iCRRMFk+OTbyQ==
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
In-Reply-To: <86zevn1c9a.wl-maz@kernel.org>
References: <20261104164555.3555725-1-aneesh.kumar@kernel.org>
 <20261104164555.3555725-15-aneesh.kumar@kernel.org>
 <86zevn1c9a.wl-maz@kernel.org>
Date: Fri, 06 Nov 2026 21:15:29 +0530
Message-ID: <yq5ah5huoteu.fsf@kernel.org>
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

> On Wed, 04 Nov 2026 16:45:55 +0000,
> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>> 
>> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
>> not allowed.  Remove the page allocation from this atomic path.
>> 
>> Use a blocking allocation for the boot CPU and record the resulting table
>> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
>> stage for each secondary CPU.  Consume the preallocated page only when the CPU
>> cannot inherit an existing redistributor or ITS table.
>> 
>> Reclaim unused preallocations after the CPU reaches the online state, and from
>> the prepare-state teardown when CPU bring-up aborts.
>
> No. The way to do it is to move the ITS probing out of the
> non-sleepable CPU hotplug path.
>
> I proposed a potential hack at [1] (which I find far more palatable
> than this proposal), but the real fix is to probe the ITSs as
> devices.
>

Could you share a bit more detail on what you have in mind?

Are you suggesting that we create a platform device for each ITS and
initialize it through the driver's probe callback, while the rest of the
GIC initialization stays in the existing early boot path?

Would that mean the main GIC is operational during early boot, while
ITS-dependent features, such as MSI delivery and direct injection, become
available after the ITS devices probe?

Is that the split you have in mind?

-aneesh
