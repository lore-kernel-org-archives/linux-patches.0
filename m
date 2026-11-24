Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.175
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795527984;
	b=aseoiZK5vFJjOq+F9XDKkMuneHallh9k89rjLwI5CX9o9jEdQh9YTAe8XIrAn01bDRQR
	 LvzkMFook95mtFWB9QTGdgvZEdYWP9L8UvwBjKs69xQWd5NMpicJi8MoLXZYQp5h783uM
	 De75F0Xn+cjcVuTRvHfHAIXCqWh/21hcqCsaYacmQEJYzppuDT/+AGkJgvOX9eis2X8Vx
	 YLhJa3VJMDn5qVo9acuiDJa5SCoQ7EJn7xRAyoHja/xJNRQr9XEPUu78mbgGz4nuJ3/Br
	 Oq8N9fLK9MDLjVPqoAr0v8W/fqkj8noYNIQZ4o+5WVPAub+XaOAYHFyuvFRX5ANKGiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795527984;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=Zc7zKgD/SDYnIbkY4MVpBd0Jo9DiJTva6Dv7og4GVfM=;
	b=BeCnedElMt0zg7IioI6GixmV++co7KMc687C27acJsgspWqm4+qFBKy0oBUkCccMlcaM
	 3IguOPK2tKUe+taMKlBGPg/rx57ki9dclEKuXNDv/FjwVEWNdYRZqsVQndzT6NWgeaNgG
	 E11DIJ+tfgh/l4ev7GDhIqzhGNYQIg6WnKnJ6+IlGeBHZcW40D9aSdGlj1FxDGNAa3vam
	 70RQtT5IlDRlj/uroIHdDD7kael4SHN/9rx2Fczkbq2MHrA9B0NJLUrqzQ1qXQsf0afYY
	 ZK7rrpcj1gsSw0kvIDgUfWIfpSExEiYdl9Vn/pjbEeGyIOrn0oPOCmsIZJUh8Bk7Z8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=EqnpeJwx;
	arc=none smtp.remote-ip=209.85.160.175
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DBD606A338
	for <patches@lists.linux.dev>; Tue, 24 Nov 2026 13:46:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 08DBD606A338
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=EqnpeJwx
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-55d2f5f1e26so51198931cf.3
        for <patches@lists.linux.dev>; Tue, 24 Nov 2026 05:46:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795527983; x=1796132783; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zc7zKgD/SDYnIbkY4MVpBd0Jo9DiJTva6Dv7og4GVfM=;
        b=EqnpeJwx4IAAp9mfsj00WoR29F/1+r5796MPouaebQUygK4aVUnRa6eVS7qXcaT4ks
         Cy1SozoWyb/dvImEqPhS5piGTnA+NT7OFO3eWko2Zh3shjWND6NUhDZZUGTo4his9VU8
         qU/Hj+sBdzclTaKlXDb/qa1g/+8nQCAFYVADWucUf30k7kyCTDmxc9cAiv3P9rg615By
         dIEnYe6/1/C2VpeNnzi0ixjLPEc3Tyfb17hPezkZxync20ieZ/j49+DFoLdPHOqp2D7J
         ORJcbgEnXNTXIZifTIp3/jwUYHap6o0pF353gcrfEyNfbXCqGnTLL65RNrBC4/EEmmoW
         pXeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795527983; x=1796132783;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zc7zKgD/SDYnIbkY4MVpBd0Jo9DiJTva6Dv7og4GVfM=;
        b=hsvyejnGNcBYEY50xL/WJUFYAFET7UPCSrvuVDsVZbvaOVgHePJMGWZv1eWz3rHhZp
         TTkqW3WjLgIPc7ngltsaKz4tQ2luQlt4enUVK5OKKuTxKyTA4bCwp4VzMopuntBTvNS3
         sWge0nOuNm1kGg+/9P9QMU6zsPQMXh2LNS1yODqm/HCcn7xBOf4NfUNsAx0x95O31ue7
         R6DyDvSEN5hXmIoOoL1qcJcz7Y3M6lr6yh4gd2ntkPtsL2ptz5oBZznuRSAhIx+W8GAV
         rQEYzKM0jshaqOtQEli7LQO2SWmA5wOBz0AsKoqaSEP6PIwuJjDjfChXjYaAqeykxTs6
         2Dug==
X-Forwarded-Encrypted: i=1; AL+hErH1qEiZF4owdxbDufredXwEP/7iVWPHq/Rk/fR49w6rJdDqbECcVLmVMFUaMlLCMui4t7L3EKya@lists.linux.dev
X-Gm-Message-State: APuU4Z9Rx8bUGz2LohqEjzzL2ODHEkrLHRGCJFEOLhgMRJ7yzOSv/tQP
	YhAN1Zbh9Vs2/EW/cZnkr7FjXa3olrpZ8H6QS40V+ALpPCd5LXfRUkd76u4F42bIijU=
X-Gm-Gg: AZFdTZfnY/jhDuvotinGsIzqeZP6bsgwjlBunOmZ+/H/YiL0ddfBzpaCmiTZWWi0KeY
	bfQDtOZx2vs23gAueoHAClzrBl+OpiY8caONElvxNwuzPtvfxOqHTUpd1ZVa2h652bsen8ez20N
	i1p8aepr+W019y09i26vLb1jjkcTfyFFq9q8LNGb+tUQ9X54TnSLfCILfO0VGruQsDQYVIVmg8f
	Wt8ap84RmV4cI+2UUaH0dWd89jZh46OZKk7rI1708EUp2UCe4TImemSS5xYb+mBmq88hUhai24v
	ASEOOGjckfLSGxi7hIQVJ3hmDp3k5v98J/HNKy7C/wxP+0+HDLnW27nEHtlNcgD+5AaDZC+Y1sM
	0SbhVoeI9BD+YZETII7iqSV03wzeaCcwNZN6an8RxSnJodUEK2s2k5UMbC6gS/ZtYAp2P0gULoy
	XmZRTK7A6yZoNkRPrLV8hne5gxv5iS0s+UMovJvxzUQr3Fn9AqFTVlf/TnHE0/TWCV4khdzEv3Y
	TsxsfpbM8NC4L8Hyn+mu1Kz1QpFqpzBKRqZm+FLJtypeQPUWWFsuQW7XlMeHEXKVOp5hdyGGjnd
	Ep9Tjg==
X-Received: by 2002:a05:622a:120c:b0:535:a5f9:752e with SMTP id d75a77b69052e-55d76aed568mr264410241cf.77.1795527982900;
        Tue, 24 Nov 2026 05:46:22 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-55d78451407sm128368371cf.2.2026.11.24.05.46.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 05:46:22 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xVqqj-00000000QIG-3EJB;
	Tue, 24 Nov 2026 09:46:21 -0400
Date: Tue, 24 Nov 2026 09:46:21 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linux-coco@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian K?nig <christian.koenig@amd.com>,
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
	linux-mm@kvack.org, kvmarm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH v10 04/13] irqchip/gic-v3-its: Allocate shared tables
 using CoCo shared memory allocator
Message-ID: <20261124134621.GI9566@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <yq5aa4mybbmv.fsf@kernel.org>
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
In-Reply-To: <yq5aa4mybbmv.fsf@kernel.org>

On Tue, Nov 24, 2026 at 07:00:00PM +0530, Aneesh Kumar K.V wrote:

> Taking Jason's feedback into account, we could have the allocator
> request compound pages and recover the actual allocation order with
> compound_order(). That would avoid passing an order to free:
> 
> void *alloc_cc_shared_node(int nid, gfp_t gfp, unsigned int order);
> void *alloc_cc_shared(gfp_t gfp, unsigned int order);
> void free_cc_shared(void *addr);

It probably shouldn't be order here, that is hard to use. Just size_t
len

And round up internally

If we ever want to do some kind of slab sharing scheme then the API is
already set up for it.

> As you noted, dma-buf would need virt_to_page() to obtain the pages for
> its scatterlist.

I think that is fine, other places working with kalloc/vmap already do
that.

Jason
