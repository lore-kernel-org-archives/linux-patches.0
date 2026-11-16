Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794843160;
	b=pgtjRd/PK936NH22j3DQXsatHfiN/w8RjuwMM8jkClj3q6GhwCdzhgHLV+Y5h499m9ol
	 WQWWt1LkIZME0Qu+zAQ603uXQirKpNxGAkBHL+Bj1l6gjA8UrVkT+M9GfPahdYNu62jSf
	 mHgtdW9uh6CpNXtrRxaQ8FPf/AAPaS8VrsfzhBO7EAiBYp5A1299M5J57tBW+HE293DLc
	 IcefaWV8FKeTch4mgiz0UtaiRfgNLB9oi0/Ll4u9OYpjNBrYPMmILA/DXo5aSsoByCcPR
	 QEiHRGdof9+AGNmVUONB4XmJNzj4RA06VAWEwrXnvp307RuCCCXaKN2lWAEb20H53fQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794843160;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Jj5m6gkNclPyoQQk/4BXK65xYrNPjI5avdyYMJJgjD8=;
	b=L1DwqIAbIo6TIWKqBlLeYJgH4aoNGnlcwtGEbENs1VNlRQWr3d8T9Z0y/eP5atYP0tH5
	 i6e19OumCzIJ2UR/GA1dymu9VCkFnXUtOnaqjFKZVXGsB0TNa7dRUfvqG+UlYVfqJtyBZ
	 Dnk7fK6hFNQR0YowI+aO3H6bNdW9IPFAGXH0fN42NgCP/e0Z291rw4i1DQe+PiVvZVwhd
	 9OlK7vEmmnk+KNPUmkacCZXt8hBC8EzKORWw2XaY69R+Gfc3Z+NLa1E+Fo3y3iPrRv1WV
	 HTrSD7UX4TYzbuvtzdOLkEYzK8TjweOo5B0cLXmNWKM90bQ+WuyiZ/UmosvUInTTkSA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jRNS6qMT;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42959606A337;
	Mon, 16 Nov 2026 15:32:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 42959606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=jRNS6qMT
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 981E61684;
	Mon, 16 Nov 2026 07:32:36 -0800 (PST)
Received: from [10.57.63.54] (unknown [10.57.63.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id F11FA3F763;
	Mon, 16 Nov 2026 07:32:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794843159; bh=43dgJFkp15JzcneMwI62MfsDly+SSUj435aeqqE9QFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jRNS6qMTC1i1b0ZGoCqXwbS6KBrk+Yh5SqMP1Ral6xS3Kl4b05yV/26O1O9OQPr/V
	 VKv8wWRTeAZ2qJ0AGAc5mdeJ1sNcv8KVpuqbRXV/JZl8UK6xrppLNhbKHBUqg37QLZ
	 28VI45Iu+Fte5YfxEwqeMoQxZGRjZaXXLp6Vp5Us=
Message-ID: <f2e47b68-1aee-4d17-8b63-e67075e7a42e@arm.com>
Date: Mon, 16 Nov 2026 15:32:25 +0000
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
Subject: Re: [PATCH v9 14/14] irqchip/gic-v3-its: Preallocate VPE L1 tables
To: Lorenzo Pieralisi <lpieralisi@kernel.org>,
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Marc Zyngier <maz@kernel.org>, linux-coco@lists.linux.dev,
 Andrew Morton <akpm@linux-foundation.org>, Baoquan He
 <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Pasha Tatashin <pasha.tatashin@soleen.com>,
 Pratyush Yadav <pratyush@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 =?UTF-8?Q?Christian_K=C3=B6nig?= <christian.koenig@amd.com>,
 Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Robin Murphy <robin.murphy@arm.com>, Sumit Semwal <sumit.semwal@linaro.org>,
 Suzuki K Poulose <suzuki.poulose@arm.com>, Thomas Gleixner
 <tglx@kernel.org>, Will Deacon <will@kernel.org>,
 Russell King <linux@armlinux.org.uk>,
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
 <20261104164555.3555725-15-aneesh.kumar@kernel.org>
 <86zevn1c9a.wl-maz@kernel.org> <yq5ah5huoteu.fsf@kernel.org>
 <87ld6x8zb7.wl-maz@kernel.org> <yq5apkw5xpnz.fsf@kernel.org>
 <avrgNBXDFMGL6dqO@red-moon>
From: Steven Price <steven.price@arm.com>
Content-Language: en-GB
In-Reply-To: <avrgNBXDFMGL6dqO@red-moon>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/11/2026 10:51, Lorenzo Pieralisi wrote:
> On Mon, Nov 16, 2026 at 11:51:04AM +0530, Aneesh Kumar K.V wrote:
>> Marc Zyngier <maz@kernel.org> writes:
>>
>>> On Fri, 06 Nov 2026 15:45:29 +0000,
>>> Aneesh Kumar K.V <aneesh.kumar@kernel.org> wrote:
>>>>
>>>> Marc Zyngier <maz@kernel.org> writes:
>>>>
>>>>> On Wed, 04 Nov 2026 16:45:55 +0000,
>>>>> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> wrote:
>>>>>>
>>>>>> VPE L1 tables are allocated from the CPU-starting callback, where sleeping is
>>>>>> not allowed.  Remove the page allocation from this atomic path.
>>>>>>
>>>>>> Use a blocking allocation for the boot CPU and record the resulting table
>>>>>> order.  Allocate a page of that order from the sleepable CPU hotplug prepare
>>>>>> stage for each secondary CPU.  Consume the preallocated page only when the CPU
>>>>>> cannot inherit an existing redistributor or ITS table.
>>>>>>
>>>>>> Reclaim unused preallocations after the CPU reaches the online state, and from
>>>>>> the prepare-state teardown when CPU bring-up aborts.
>>>>>
>>>>> No. The way to do it is to move the ITS probing out of the
>>>>> non-sleepable CPU hotplug path.
>>>>>
>>>>> I proposed a potential hack at [1] (which I find far more palatable
>>>>> than this proposal), but the real fix is to probe the ITSs as
>>>>> devices.
>>>>>
>>>>
>>>> Could you share a bit more detail on what you have in mind?
>>>>
>>>> Are you suggesting that we create a platform device for each ITS and
>>>> initialize it through the driver's probe callback, while the rest of the
>>>> GIC initialization stays in the existing early boot path?
>>>>
>>>> Would that mean the main GIC is operational during early boot, while
>>>> ITS-dependent features, such as MSI delivery and direct injection, become
>>>> available after the ITS devices probe?
>>>>
>>>> Is that the split you have in mind?
>>>
>>> Yes. Then once this is done, all the tables become normal DMA
>>> allocations, for which there should already be adequate support.
>>>
>>
>> Thanks for confirming. Can we handle the ITS platform-device conversion
>> and the switch to DMA allocations in a separate series?
>>
>> The existing VPE L1 allocation path calls set_memory_decrypted() from
>> the non-sleepable CPU-starting callback, even though
>> set_memory_decrypted() can sleep. This issue predates the shared-granule
>> allocator changes.
> 
> If I may ask, why does the existing code ends up calling set_memory_decrypt(),
> or reworded, why does the VPE L1 allocation path goes through the ITS specific
> allocation function rather than using alloc_pages() (as it was before
> b08e2f42e86b5) ?

Because it needs to be accessible to the GIC "hardware". In this case
the GIC is emulated by the hypervisor and the hypervisor for a realm can
only see the unprotected memory.

Now I agree this is a little academic in practise because Linux (as a
hypervisor) will not expose RVPEID - so allocate_vpe_l1_table() will
early out. IIUC this would only actually be relevant in the case of
nested virtualisation within a realm guest - which is a long way off if
it ever happens.

> Why did b08e2f42e86b5 patched allocate_vpe_l1_table() allocation and moved
> it to using its_alloc_pages() ?

In that commit I simply changed all the allocation paths which were
allocating memory to be visible to the GIC to use the new allocator. As
we "know" that the GIC can only access "decrypted" memory. Admittedly
that could easily change in the future - but my expectation is that it
will only change with the switch to GICv5.

Of course what I missed was that this specific allocation uses
GFP_ATOMIC and that set_memory_decrypted() can sleep. This wouldn't have
shown up on any testing because of the early exit:

        if (!gic_rdists->has_rvpeid)
                return 0;

Thanks,
Steve

> Thanks,
> Lorenzo
> 
>>
>> Since fixing this properly needs a broader ITS rework, can we handle
>> that separately and drop the preallocation patch from this series?
>>
>> -aneesh

