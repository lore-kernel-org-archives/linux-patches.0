Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794917275;
	b=E2k5uxFRXYGiBZVg6pLUmoSbloSjgcIW5WTeOaQn8dQH3EoIeF9UoFf6aJy741OSAe7k
	 O6Jl+n9KEcfC9DKV22OY1hLwx1W3ZorwueLiXRRZK/gY4VWEJHIQAWrYYmWs2cXAW+QSs
	 gavs7PrFnD8E8L+oeYktd0UwS5KQDsS1UApn3hNU+qzF9jDFqQMLusSxPlsHU31IrPImw
	 34kJ3ETFG/kShpio3v2NWQWwfRWFljRS4C41sXnB5ZToG1O9FCAIHUVrN4madbh7dEtGE
	 +RUJkhwNKiQNgaOVv1O1Zgw5ZFvfuh3rEdFAKiZwuy5g8RjTtA74x3MEC3FJQOiKrFA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794917275;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=s/GxyM3xQ3jHfxh/01l7Pa4ILI1xRNFU3MUIalnJ/Ic=;
	b=t/wdNSO/0dn13vmTEsOevq5Og5fixQLbqT2kWVcze7dsAQA3Tt3YWbeq8G79UIZYk83e
	 BAaj/qLloPem+q/1+x0Xu44ucCJkKtDq+pwJhRou+F20KAffOCD5EGTzjpbHoCrNVd8Kn
	 VAwFnqHya4NtoJsIE74Uf38nOho5//saZZ8QZ3ZiqFW4XH1W8JiJTDprrb4wGK1HvgZyA
	 Onm+UMXMUugq8lGGJBrJbJsqVehaA9gZv/wodG9O5ocYLiaZHQ6x4ZplS9ta98qNY6tF7
	 C2mDHq3MpT3N1weDUy1k3ffo0dUU1NFQx2nJZCMlZ/XjCo9b2At6esfPOeb4btBrerg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TYjgvtoN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA192606A33D;
	Tue, 17 Nov 2026 12:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=TYjgvtoN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568641F00934;
	Tue, 17 Nov 2026 12:07:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794917275;
	bh=s/GxyM3xQ3jHfxh/01l7Pa4ILI1xRNFU3MUIalnJ/Ic=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=TYjgvtoNuQZfGkR/SgqLaJ5HoTzQ3ZEBdzd/+euHF+gqzHqfw9aoVgzXdgQ+dIJuk
	 uGrTDvInZqzbx0XvBdevqb/w0aOKtbE/d1/S1Hufvhq+QeUVQcQlTiRvVGlr1EfA3h
	 e+IQj9nh2dI/1foUD7Ho193uxD7s3+11q3hcayoip/FuKx4ODfCsC/lOw6CbyzuApi
	 OPk/igYER2aoVVLOL5wduIqtTcSVxEfCBxVygpdtTbz/6YB4P8ZWXbqDTvoZdukb8h
	 ebah/4xrrgRrreD/h9x3OsMl2NuftMm7xJgS+TXAeEowpt+h3psMuf2GiMNxLfdVPQ
	 A2CmscMuHGmnA==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Fuad Tabba <fuad.tabba@linux.dev>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?Q?K=C3=B6nig?= <christian.koenig@amd.com>,
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
	kvmarm@lists.linux.dev, patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v10 02/13] mm: Zero memory during shared memory transitions
In-Reply-To: <CA+EHjTywWTaKLtM6OPF_0ETv29-m8JsHdvF3BeW9Xa=h713eEg@mail.gmail.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-3-aneesh.kumar@kernel.org>
 <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
 <yq5ah5hgyj1p.fsf@kernel.org> <20261116140259.GL2532299@ziepe.ca>
 <CA+EHjTywWTaKLtM6OPF_0ETv29-m8JsHdvF3BeW9Xa=h713eEg@mail.gmail.com>
Date: Tue, 17 Nov 2026 17:37:07 +0530
Message-ID: <yq5a7biby844.fsf@kernel.org>
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

Fuad Tabba <fuad.tabba@linux.dev> writes:

> Hi Jason, Aneesh,
>
> On Mon, 16 Nov 2026 14:02:59 +0000, Jason Gunthorpe <jgg@ziepe.ca> wrote:
> [...]
>> Just like you are wrapping set_memory_decrypted() in an allocator API
>> the user that wants to have the no-change sharing needs its own
>> special API too.
>
> That works. A separate API can cover no-change sharing when a user
> needs it, so I'm fine with set_memory_decrypted() zeroing.
>
> Aneesh, the pKVM hunk does need cache maintenance after the memset(),
> which I have in the Cc: stable patch I posted earlier today [1].
>

I will add that, along with the relevant comments.

Thanks,
-aneesh
