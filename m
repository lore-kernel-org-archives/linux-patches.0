Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793800972;
	b=roHg6M4MQSA2N/H5bK5oulfxRc8nGrfjhjPKXBUsLMo5EinjaIJQwTR8L5s5ROZuRUhD
	 oaYCAdpkB/1ow4KJsFhVI6/IraVY5Xzch7Gh4eOdU2TzBvefn8SmA3cuf+9F232As/6qL
	 lIhsGL2ETvR6/7TkB4m1B654LWg25IqSqs4VFgLz34KTVDRzpqeOr9Ps2czYVyuQ2xgLE
	 Kj1MzrOms/fW4jn2oRzoT0Q0a5msgaJqjNyyXgF0hQqZBRF8W+Y+WO0wBAU3BFrvFFSm9
	 tbn4PLDo3YfkrvJ4WqAkjvmUXoYA5uNPbzdvOnNfzYGGiIhQVk7N6nSxYHdum/AvLjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793800972;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=p1t0XcRRp1uMVDh1EBUHkAU5r0BAD30gdP7oa2ssEps=;
	b=DTUCOI90OFsd10YKXETbEZRIibzSoREVkuwq+OTvgX1EMKrAtDZdUWxj6LuIRFEUt1U5
	 FAzudFIDVopfLeR+VOEcP8uI22QnjxELtsucGxTHOAXuNN0ML2+aWtGscZgyI1z6QTwSr
	 hU67r9vj9tlRM8iaGycNTUsJRsIQ8H1Hm/iS+QsqZLSDVFG00yLKuVjLxT5UtsuEoW6aV
	 3UOVZxHbpcmwJe40AP+8dHP+uHmluEGxf6ag6zyoGkveZ/SBToPId06FA2/YAFj9KG9cK
	 Xodm/ntaSiUVCeoWbcx5ntwHo8xP1jqvCTq5Z+5tuOcbCO6xskyk08csNzWjmjYNR2A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="C5HXHYT/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E374606A326;
	Wed,  4 Nov 2026 14:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=C5HXHYT/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2AB1F00A02;
	Wed,  4 Nov 2026 14:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793800971;
	bh=p1t0XcRRp1uMVDh1EBUHkAU5r0BAD30gdP7oa2ssEps=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=C5HXHYT/oKFLRoX6O0NeJ3VHnhU6UIcl5iX0mNecPKLfoDtWRDh88e3yxAHD4YpVg
	 sIIZ13Mkev8qZk12GaC6xsWb4OGKFaQ4KIHqvyRgi/hDR9I4HJue8L0XKprGAd//35
	 XxhVpW8a6t1Y6XqHKqqfG00NK0hzfX8x8dn9fYxjO0Nrew3DZ8ObEoz4BOGJ9HDHXg
	 3/3OnFCi3LwWbpw0Ob++1VqYZE/ZlbAMbaEf3cFEqQ4mNHTAhlKAjWnSsdcrlv0twy
	 Dr80Gh7r7qYsPtTUJy04MMXp5Xaa8CvGFxFsVEEgowhEKGMe136+lpI8efO1YBpQCK
	 Ge1JTw4xfCP4Q==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>, linux-coco@lists.linux.dev
Cc: Alex Williamson <alex@shazbot.org>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Sean Christopherson <seanjc@google.com>,
	Will Deacon <will@kernel.org>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>, iommu@lists.linux.dev,
	kvm@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [RFC PATCH v3 06/13] KVM: guest_memfd: Support device-backed
 PFN providers
In-Reply-To: <CAEvNRgEL5SuPBwGqwrUzD3Gb1iUonhvM488-3khHpQk8OkWr+A@mail.gmail.com>
References: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
 <20261101071928.2462549-7-aneesh.kumar@kernel.org>
 <CAEvNRgEL5SuPBwGqwrUzD3Gb1iUonhvM488-3khHpQk8OkWr+A@mail.gmail.com>
Date: Wed, 04 Nov 2026 19:32:42 +0530
Message-ID: <yq5aik2c8zjx.fsf@kernel.org>
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

Ackerley Tng <ackerleytng@google.com> writes:

> "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:
>
>> Device resources such as PCI BARs supply PFNs directly and cannot use
>> the folio allocation path. Store the mapping owner and device ID in the
>> core context during attach(), and use them when preparing device
>> memslots. Keep device memory separate from ordinary PFN-backed RAM.
>>
>
> I'm really hoping that device providers are just another kind of PFN
> providers and not special in some way.
>
> Please give me some time to prototype so I can see what can't be
> achieved.
>

Please take a look at the cca/topics/cca-da-gmem-backend-v4 branch in:

https://git.gitlab.arm.com/linux-arm/linux-cca.git

It documents the differences in detail.

-aneesh
