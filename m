Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794837786;
	b=RdApuvYeKyLERUrmH3bw1Db6RUw90z9ESnEyaDUu5hPyCKh/AdPCTGnOahVfZWIDPG+R
	 hdpklu5HfkZro5Z/KNYnyBxbKSYHzQJXm2BrIf4smIE4yCMlMbxJ+LTXIbtbQZPbn+Pyf
	 Kn/z+G8M+G4j5zeMT2VyZrx8U8+4UEb1NWgLm4K4Yl+oAbw56kAyVfuvGwczJKM8ZDpeT
	 b9TwM2CNhDBo5sQnfi9CWOnasqL6fwahsP0E2UNB5WXVusLITnjdeCaHKFsJRohaT5Zgg
	 g9+gnWrimOeMEbJ4Kqz7YyWeOI9srA79Vr9wOjXiCKkKm0MZ9B611aNhXewqxuPD4IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794837786;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=8htNjDuwhthg5uXuXp42Sb+r8eU4x+ykq7/WcmWSjZg=;
	b=JzCnKZ/lObzNRZT1Ufqeq8F9UiATyHTAHHoGx5iCxw0C0kg3qbtcof4ZR9CM05q6jpkx
	 79lY+bd98T80UQkmvtXRXTr/kxWIjD3t7M2YSkmLJRKNK+p5BLWxtaUDY+p4GjQkuFMS7
	 6hFbUZc7eHTGkclzTEHFj/zHxTob+APUiwVuWLgwy2MHZqabd3zL+6T0vWNXh2E0WkLo2
	 JD2055rXKVwfoD+2q6oZxpFQeQV6amT0usd2+bDzu6596/nuFjOQtpppQepDqOYtESJWG
	 6yGgQGtUOglXAls/ofnhBoiL4BLXULgwLAl8+5Xd4xG/igF6DJ6JJ3xs7ejAAAXKmWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=D2UELt21;
	arc=none smtp.remote-ip=74.125.224.54
Received: from mail-yx1-f54.google.com (mail-yx1-f54.google.com [74.125.224.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFA8606A882
	for <patches@lists.linux.dev>; Mon, 16 Nov 2026 14:03:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7FFA8606A882
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=D2UELt21
Received: by mail-yx1-f54.google.com with SMTP id 956f58d0204a3-67db23d8892so1451377d50.2
        for <patches@lists.linux.dev>; Mon, 16 Nov 2026 06:03:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1794837784; x=1795442584; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=8htNjDuwhthg5uXuXp42Sb+r8eU4x+ykq7/WcmWSjZg=;
        b=D2UELt21I5ILCf8AXZAEuvMOfdZHdngeN2nZtUV2REtiuku1ygCCWC6sVC3onou0Br
         oQgvOxRZoTp8D+NGU7iMNdRkGD4GMudxuOM/qxLAN4HNvJCIqEjV8HCQ2tkEVxb8WMIn
         zUVhOr2skKLmaXE2OTvAnaAOV+JYUASTo8JnfRIvZajeR5h5yR1NdJ0hVlJETdKPkeWs
         PnweAQuMZJlxO1Lnh93SDU6l7IMrJvOymCajsQnP3W1vR6mFbkdvoVyTaARMsLcD+qRe
         eXwOcTOOJcfy7OR8PE+10MxMUYK2z1syHo+Xc5Wmz1EjSA3zd2lR40x0KfD/5kCYGCVd
         AxeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794837784; x=1795442584;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8htNjDuwhthg5uXuXp42Sb+r8eU4x+ykq7/WcmWSjZg=;
        b=LqOKEE+6sjLoLKXxJrEiegJ3Dk7d0uofun2Z4GE8qFOuxVp89BsEOkzDGKgZeIc80a
         n4BfY4dbeI4yfxnx+TZClsO35G5qOtNdxbJxTy7/qJvEiE8XTnvpZGZUPUMZvu7Hdi04
         0IKyfPq97l6g8EeU//YegxfWREKYTRUt8jXgChpGluyUHYi7k/8Zf52RbJMxCLvaHVzL
         8dvUM2NRZwoiokw4PYVHFVDRE7bxtj4zGMk9a0Qbf92iNvrDMhZ+QqDko3EdSqTlM1JG
         sO0dSMgBVMLKTJSlQe+oOF7zMHQrzQGTbNeMI7gqyMtgm2Hd3qldQhKyb/7OKcNi6CwI
         8IGA==
X-Forwarded-Encrypted: i=1; AL+hErFi/iSobKkZyFOqdF5ZXaiDvMpP6nxPl6r4e1KffoPAnC1Da0XmJHwrvMVAQA9HgYVIIXq6Q9Z3@lists.linux.dev
X-Gm-Message-State: APuU4Z+bNpN6TmWwlw3W18zA1fggEBRWbDygG6IdmhpcNRXQ4oYzf3Af
	N3ctYg+nbpnq0DYzup31BFmuQ+WSFY8oTgYg/BNn1GDt1zlqUsvJaho7Ngc3rOyqkBE=
X-Gm-Gg: AZFdTZeZh8U37Pm1YLAw8zL8D2EHg1jUsU/oYs3ts7So/km61LwOhjAwJjYauBCmrWx
	xUqQ0V/a1n2DO8CjCf5Kf986YFr0WY0m4C4lflGVrDm4AMEpXIdh+jst1o/qphNQ2Hxttt6MkVv
	rmud44Oy7tTG9LDk8jiwZcqB5pCQ2vqIyU3ydRy9N7oW+WGrPnLIc4N+nsBALz2muLPUdCxfGYl
	MWrlb3shtAFA/rYk/uyKSx3EHHYnV0rPOPdVE7EVMCbrANuMizJ0kWO0DlBiI8yNEUn+0DML+Yt
	SfgnVJq10WDLVvWJ4Lx/S+90e5KISFgGoGpRps2WpsvNMn71CF50HJ99chkD9d4aRcUT8sqBP/Z
	l2rj1u1DIvqiNL6cNq9wS5ljxWMybLWD5dy8jgHKx12Uvgca0QN/LxMzMWtoqRygA8hJ5AkGQS2
	/ofVAJg7/xCdz9NaCJqPfWbw/g8u+zIVnAb94LUsuDm/WPAMzeMhyfH/Evqrfj6RmgOq0ltBdLK
	EQVM8pqh+EKNOQyynfwVbIf319Y9PCIsMaI5clyVTyPsfyKkpon0y0Z9mxzvuXAreZian2wxA6e
	ory7Zf+GZ29texrgNAfarewt8+Y=
X-Received: by 2002:a53:ccc7:0:b0:67b:f935:8639 with SMTP id 956f58d0204a3-67d89787ecdmr4996887d50.63.1794837784278;
        Mon, 16 Nov 2026 06:03:04 -0800 (PST)
Received: from ziepe.ca ([142.166.156.71])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-9494c8b889csm858426085a.32.2026.11.16.06.02.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Nov 2026 06:03:00 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xSxIR-00000009Q2N-0sq0;
	Mon, 16 Nov 2026 10:02:59 -0400
Date: Mon, 16 Nov 2026 10:02:59 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Fuad Tabba <fuad.tabba@linux.dev>, linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
	Joerg Roedel <joro@8bytes.org>, Marc Zyngier <maz@kernel.org>,
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
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev,
	Vincent Donnefort <vdonnefort@google.com>
Subject: Re: [PATCH v10 02/13] mm: Zero memory during shared memory
 transitions
Message-ID: <20261116140259.GL2532299@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-3-aneesh.kumar@kernel.org>
 <CA+EHjTw7QzzkQYKV3jyvW5mqZQMenTfm=kus9i87tYqACDOv0Q@mail.gmail.com>
 <yq5ah5hgyj1p.fsf@kernel.org>
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
In-Reply-To: <yq5ah5hgyj1p.fsf@kernel.org>

On Mon, Nov 16, 2026 at 07:28:42PM +0530, Aneesh Kumar K.V wrote:
> Fuad Tabba <fuad.tabba@linux.dev> writes:
> 
> > Hi Aneesh,
> >
> > On Mon, 16 Nov 2026 at 09:12, Aneesh Kumar K.V (Arm)
> > <aneesh.kumar@kernel.org> wrote:
> > [...]
> >> Keep allocations on platforms without memory encryption on the ordinary page
> >> allocator path so the original GFP constraints, including __GFP_ZERO, remain
> >> intact. Remove post-transition memset() calls that are now redundant and
> >> explicitly clear allocations on paths where no transition occurs.
> >>
> >> This intentionally makes every private-to-shared transition destructive;
> >> callers can no longer use set_memory_decrypted() to preserve existing contents.
> >
> > pKVM shares memory in place, and a guest has to be able to share
> > memory it has already set up, as Vincent pointed out [1]. That was one
> > of the primary reasons for in-place conversion in guest_memfd.
> >
> > Cheers,
> > /fuad
> >
> > [1] https://lore.kernel.org/all/avro44jUWOARFzul@google.com/
> 
> 
> Thanks for catching this. We discussed it before, but I reached the
> opposite conclusion:
> 
> https://lore.kernel.org/all/yq5a5wzw2ree.fsf@kernel.org
> 
> My mistake. How do you suggest we handle this? We want to avoid zeroing
> pages multiple times with different CoCo configurations. For example, to
> allocate a zeroed page, we currently do:
> 
> alloc_pages(__GFP_ZERO)
> set_memory_decrypted()
> memset(0, PAGE_SIZE)

Just like you are wrapping set_memory_decrypted() in an allocator API
the user that wants to have the no-change sharing needs its own
special API too.

Then you can bury a special implementation for pkvm there.

Where is this special user in the kernel anyhow?

Jason
