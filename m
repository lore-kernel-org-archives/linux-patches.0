Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795525676;
	b=pTDO4xPKCsPJgISJEBx/c9rAda9+mZ1Owz33VQezVsykgtrU10m92ocKaNmbamMUECI1
	 aZjTyjjf5Dxozlp0oK3TDWnWZfTrpqy8gmmt+aWrjcLUiZ2yXqNWt6tFm0J5j3HUDqaG+
	 zbZfT7V0ToRdEklzibWqrhjbq0/XMIkHyJ7WK1Z9G5f3G6XWLK92npPggP6LTHpKlNE3f
	 teUOuBeF18/bd1XiaWDZI9i76RSKEaiBeJ/hVjnDeYBrl3MRbL7wcNotC+totAqt8dmkJ
	 aQ5f2OG/tCWRl16u/NsSBZAHYaeTgxM6cS/TSpMQ9Gs4ZXVz2pFStRzYrLir+CvkSkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795525676;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=2Jqv6h2U/zwufJIWy6q7C5BzrR7eGEBWyzupif8ezko=;
	b=gFCr3cSAbcrp8h97V1HiMdN0GYMqMhzF8iiuo5+NomfnGnh20NgXyZrLsmrFsOTTElfh
	 t/mvfZRznhrVM7SoImIGWU9ynyTqWKfysvZun2LDhG3ENb8C2FYuOh5NVXqumsO+lnwnH
	 s2K12wtpuTWuXq+VR+r5UV6ib+XlDnOKzr4vmsW898x3Kif4+hUSfkb/EVRq8N/tez/7M
	 cO3YzVdW9JHS1Wjxud58slNNeMfbhuE/QOqzgox05lzgi+9Csjo8oW7udhLV4qd4ot6i+
	 RhJE43ZQLUkXSmrK2Sr17zn8ZQyeYWZNhLfVqy8/BAL3s2QrZTY9w4Bnu3h+Z6k9IYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=CJZp6cV7;
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 449E2606A31E
	for <patches@lists.linux.dev>; Tue, 24 Nov 2026 13:07:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 449E2606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=CJZp6cV7
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-9496577d4c4so518018485a.1
        for <patches@lists.linux.dev>; Tue, 24 Nov 2026 05:07:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795525675; x=1796130475; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=2Jqv6h2U/zwufJIWy6q7C5BzrR7eGEBWyzupif8ezko=;
        b=CJZp6cV77fzkUCXvgeGyc7n9vOvZov1aNWjYfoQB8lqfjpe7VVz2pKyasHC0M9bSo3
         qvoro/45R0bYQRTdO2OhOwP8IqZDTveCj+W0rKGqVuCBz/BgVUCJlNyD58G1GcYb3njP
         MhERoQBSZF9WEeWN1BrNcXyxnT9a2V9qA6Tztu/pOhGSXK2qaxtPyM7+o3gi7IQ5m8Vl
         zl9+/Rui9jQl3P++qkZI/CGbAH51e/eughhaB/kN3C/3tgk7TbjbUX+50M64WuaFgcYP
         wX9YibH8TLZgk0DjcQxRjLhIWJBK9Dfla9PQfVx96fqCzu0PbTcLTtuv2r94I2lv8Uf7
         UBLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795525675; x=1796130475;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=2Jqv6h2U/zwufJIWy6q7C5BzrR7eGEBWyzupif8ezko=;
        b=L2gXWmCgCkDeqo27g0Xq8b7mizqjCNMCqGV1EBlJQ/FO4NKQfjSROECWM83fyVA1KV
         H2jShQuG5n8+qbljNlVhI+swd7HY5i7/05V/xWlSHfseP9bXk5ZRKZ0Un52IE7RAk8WU
         IM8mz6ilcZysDsW5ZKwiSsSIxtZMD2gDk8ceJbOdvZcVgI6GStCtAcArlLsNFXdko0AO
         1pmgZJyrouA6eXpGLhnc9FaO6EDTUVL987st0W7ceb8fgE3Bq1KXFRZw3VksIP71aZx/
         ayM2sVzs0WV+CpkjqIG4nb4UqdxCn3RkMdPImCGk5ufnGWPB9HjDz/qJsJo/7ruXiClr
         lcKA==
X-Forwarded-Encrypted: i=1; AL+hErGb/R6KfFuzwuKwwyVVUeGuxRrly2pLPllsgF22n9c0hPkVVmpZH7r6oQGjK6/jUhtvqN5QaCjd@lists.linux.dev
X-Gm-Message-State: APuU4Z+pdi5JGmwLIKiO5sqgYuCY8CQCGimTgwgaXwODDiaJxVh8/4DY
	2OvOeYMtD3VlzOvCxFN91Dj9/yhsUw2gTgsdm/xzyucjD6qC8XHJzjXxj8EwCE1j43I=
X-Gm-Gg: AZFdTZfzrAGwWP6gb5Hhe/rDzlbeHiQuCX+GuNTDSNPM0hnGAKAKha+MaLQYW8UodtR
	sJ4yIp5IB2sv5Z5cZqPAHH5Iv4mnm+h7Fll25VxTkDGxTed45NofFa/F1YlHNbKYM7H5jPjVfss
	PnvjJx52DoHwCXdXlZK8OYoC6npB8ME62KR1TGkkZtpBXUBrzYjvY3sp4E1u+MRQi9hUHkqHS4T
	B5KpCl3+vqce4GylouLsX6KowMmLwOswgPsT3Xn0v9fSVPieOyDGUeyEpjAhv0cNHdcYK778u82
	1snHgaAWrtc0Asg7DKVTRGkBMqhTsmrISHRV8NO4Yzz5nUi2eDDkbEqxYo52FKFpbVSqn1nZODs
	/V0NoSiVICm49UWMZNrM32QlibTapnTbEgLG/1lRC8t8//xNWyEAqPwdo91UOKzOBosHcqqcV+1
	v2yC6oU4Xo7jJaBcrOLlKuo9mwjvm3fisD6Iy2rMuhg7qYXS6J+tkTo98LtVwCSIJ2g58XJ1JYh
	Jbqm690fCEX8KkDKxSFu+65O3/R3OyMiaBr4srs0cKMz3N3ZFP2gYGQpdUmYtiZ4O+SB4j9ciCC
	yxau2A==
X-Received: by 2002:a05:620a:2705:b0:949:8ee5:6faa with SMTP id af79cd13be357-949ba818db4mr2224332285a.4.1795525675010;
        Tue, 24 Nov 2026 05:07:55 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-949bb4219c4sm1034879485a.41.2026.11.24.05.07.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:07:54 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqFV-00000000OKe-3ac5;
	Tue, 24 Nov 2026 09:07:53 -0400
Date: Tue, 24 Nov 2026 09:07:53 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
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
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Dexuan Cui <decui@microsoft.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Andy Lutomirski <luto@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	dri-devel@lists.freedesktop.org, iommu@lists.linux.dev,
	linaro-mm-sig@lists.linaro.org,
	linux-arm-kernel@lists.infradead.org, linux-media@vger.kernel.org,
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <20261124130753.GD9566@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <20261123150041.GB179082@ziepe.ca>
 <awSGBdS1AiFhJzZV@arm.com>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <awSGBdS1AiFhJzZV@arm.com>

On Mon, Nov 23, 2026 at 06:29:25PM +0000, Catalin Marinas wrote:

> > Exposing struct page to places that just want a kernel addr means they
> > have to call page_address and we are back to the highmem weirdness.
> 
> dma-buf system heap needs struct page for scatterlist, so we need the
> virt_to_page() conversion if we return a VA.

Yeah, but if that is a one off I'd give it is own API..

> > > Was there a caller you had in mind that needs the common allocator to
> > > share less than the whole buddy block?
> > 
> > If we want this it definitely needs to be a void * based API not
> > struct page one though..
> 
> For whole-block sharing, either a VA or a folio works for me. If the
> allocator takes an order, the requested size and the sharing granule are
> both powers of two. Rounding up to the granule already gives a valid
> buddy block size, so there’s no need for a separate shared_size.

But you still will need the allocator to use the struct page metadata
for its own tracking information, so it shouldn't be exposed to the
caller..

Jason
