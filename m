Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=74.125.224.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795710700;
	b=fYn7O/JNSUYfoXcBjd++jbGO2ZeZmCC28iI1CNjRlkXqJ/tvzJ177rKBYl9PqNhWJzKw
	 DgMnVutqwzZuhc01E6ZB7lg92ezd+IIPUVYXqCn4xnMwhegYzp7RbywUYcFsH+neFfwRb
	 HtvOE6asMql0zmiR2OVTOOKLxefh1rqgbI92lRw4h7zT2/PIRoRrkpNojrletAk9iQCLz
	 G3nzTXs7zYi/HI3byjLBYTzjHOHJz/vgLCn8kXl7xyA/w3+w7IisfYCTu+iqZbxdXX/Z4
	 JK3YhgkDdCGk81Ajh4KeUVMIWMSMBWveo78u6BC0Y7j36Hgy8PRuhB5glaFJ8zxVHGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795710700;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Received:Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=mKMGXbvF/sfX9s9vl5jaq/5p/tKCIj66clg+e7onQEc=;
	b=4JkDdE/g+iZlQAHTIU+d8pgZcmISAJVBVUJjxGceuq9a/Qcbl+JOrncowGFPzyps3Flk
	 G0rcnv+6WG0bdcD8VHcU64u2kU0efXJlgRTVGyd2zPMTa88BZ9M7MSXTPEE3IzfkeQswA
	 KWflqw8xlz5qCDn3Za1SISzhUGii/SD0g7T/rOBKPiA8mLgiYOZZg4ZfQBsgb/QvQr6CW
	 bQVc0T1j0rwbpV4cZ0J3AViIEWk/il50DndR51qGcgQtmgavd4sFDPNA9YCgzI0pvjY1a
	 vlU7tuhY15ZzCewuOYvY4oc/GzyRC6vVt++dHRgMeDGp56NBJU/g4Er40uYGomcUGTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=ziepe.ca;
	spf=pass smtp.mailfrom=ziepe.ca;
	dkim=pass header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=USPS9Ylb;
	arc=none smtp.remote-ip=74.125.224.41
Received: from mail-yx1-f41.google.com (mail-yx1-f41.google.com [74.125.224.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54FFA606A31C
	for <patches@lists.linux.dev>; Thu, 26 Nov 2026 16:31:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 54FFA606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.a=rsa-sha256 header.s=google header.b=USPS9Ylb
Received: by mail-yx1-f41.google.com with SMTP id 956f58d0204a3-67da564d9f2so9495819d50.1
        for <patches@lists.linux.dev>; Thu, 26 Nov 2026 08:31:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1795710699; x=1796315499; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mKMGXbvF/sfX9s9vl5jaq/5p/tKCIj66clg+e7onQEc=;
        b=USPS9YlbJy5Ee1rwwfQWEP3Ve8SszpGtAS0zjskI9LSW4enHGz0fXGUdGEm+LK2972
         q5LEmzTswauSlTatatKd33PcPM9u4+158FxDRvHWjqXyxYoASoS6c6YPM4TnF9urJ9MT
         IgmM4Gx6HK1qbaace+7wbEhWbBvqwSlSxnTJ/VhiO+YuRflew2gVqOgI0AOLx5oHFA3P
         V9PfQ5ful+N5KDidIg9e490r6aQNC1G82sTszz84kN1NtqcivRgxNpkmynhWJh5GO0a3
         EiyKr0vW8w7uPEpUkoyVl8SOBLtSmxlEIxgA7DktcODzrb+DhrdQZ/UOwSfE2AoNrqVd
         veMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795710699; x=1796315499;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mKMGXbvF/sfX9s9vl5jaq/5p/tKCIj66clg+e7onQEc=;
        b=ukWVrUmNnJEaNxdABa72cQ0U9cWZ3nT/gErjv7P7aaekOtVDRoWf0HvwKy/9GKKb2r
         w1L37C/Yh0gARpmLsCKw+GddPWdq9gWC7YQJB184ipztYLkI+ozl5VFz102vptK0z8yL
         fs9vkE1Wk0u0cJBtpaZpekCXcNVhCdgZ0I6YG+La39fbVdNGMW7zgy1CTlnIl/PpyA2J
         RU1qtKRLVGidYVOgmnUxM2OPmqYNsYPNjckfq8uAWH0eTjKkXq3V7d1te45rXx4Xc5I+
         KDD6QvfkAc8uk+nrjApl4t+Khc7bzc7I7JDPR2Roowt/z64BL0NzZxb5ZnfzLI1Rxneu
         dCwA==
X-Forwarded-Encrypted: i=1; AL+hErEwvLB/XafnUmjCBn1VoKDFzdCY2fp6qSnY/aDN746qSJY747/M+jSha5/nQfMUsDLIpudG50j9@lists.linux.dev
X-Gm-Message-State: APuU4Z/WPTC1Y7gKSp3zfm409tOXCqnFWXWLy7B4m7eklHWCpx5a4ikW
	oYupu9bkMdslB0dGSEtjqqBQi9+4pDLFor2PSH24+5GvctTJC5eux24JyADim1knL8A=
X-Gm-Gg: AZFdTZfYbe174ep7DxEvIjn3fu7MfLaFq2l7iJxgPX57qvFJmkkD8+H2qu/8OprvyLs
	fTLSgj5wTBLuTfAFB+lh756F17L91e9QllCcl/K0TkeVBo2VAWNDgyX0WBYBkFGyAEQui//QAif
	gJCDWdVHLecbdWPlJqxT3K0ycwqr1OXhbjKNeXksLZ84AIymz4ENByYS1o2Q3dFowGuarzZFHw6
	5SB5nQBeEgFrhTSaMPidvBZWSjXNfg86E/AmqIITji0AveZ1ltvfWtzLKBwH0zrrnhTccrzlP6d
	UOx1MeTxmjRz7iqf3r1m9Ni1kOr+lq28EEob/NXdEYZbEQMFVyV85ebTwHdnSMF+/jg7lQOiYac
	JMz/Ec473PSLTGrBEtxEzsn+9ER9P0MoZRW0h/kWVZsETeEXHQO7+c42icjo8ukZGfoCdbqr5BI
	zFpYpNvWJAnp54b4kivdX61YGD3KCixrPymvjy8enPtG9diekoMNa078y8EdMGUjP5MqGUOkAVp
	qaUH4IW46d7pPVT939uPwtkMlxjpc+fPcZPQx/d+CHOrkzhGDlJR9fNoDskb9uFeXd2DAdl5+sY
	gvkJJA==
X-Received: by 2002:a05:690e:13cb:b0:66f:c1be:a64f with SMTP id 956f58d0204a3-67df4444c30mr10219064d50.65.1795710699306;
        Thu, 26 Nov 2026 08:31:39 -0800 (PST)
Received: from ziepe.ca ([142.177.118.84])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a15b99sm192865986d6.38.2026.11.26.08.31.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 08:31:38 -0800 (PST)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1xWcNl-00000004WQW-3ltS;
	Thu, 26 Nov 2026 12:31:37 -0400
Date: Thu, 26 Nov 2026 12:31:37 -0400
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	linux-coco@lists.linux.dev,
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
Message-ID: <20261126163137.GQ246011@ziepe.ca>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-5-aneesh.kumar@kernel.org>
 <awQd81MwZqi55gf8@arm.com>
 <yq5aa4mybbmv.fsf@kernel.org>
 <20261124134621.GI9566@ziepe.ca>
 <awhVoDXluqpncgcd@arm.com>
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
In-Reply-To: <awhVoDXluqpncgcd@arm.com>

On Thu, Nov 26, 2026 at 03:52:00PM +0000, Catalin Marinas wrote:
> On Tue, Nov 24, 2026 at 09:46:21AM -0400, Jason Gunthorpe wrote:
> > On Tue, Nov 24, 2026 at 07:00:00PM +0530, Aneesh Kumar K.V wrote:
> > 
> > > Taking Jason's feedback into account, we could have the allocator
> > > request compound pages and recover the actual allocation order with
> > > compound_order(). That would avoid passing an order to free:
> > > 
> > > void *alloc_cc_shared_node(int nid, gfp_t gfp, unsigned int order);
> > > void *alloc_cc_shared(gfp_t gfp, unsigned int order);
> > > void free_cc_shared(void *addr);
> > 
> > It probably shouldn't be order here, that is hard to use. Just size_t
> > len
> > 
> > And round up internally
> 
> Minor point in favour of keeping the '_pages' naming and order is that
> it makes it more obvious what alignment is returned for code that needs
> it like the ITS. Otherwise we can just document it, I don't have a
> strong opinion either way (only that it's simpler than what was proposed
> earlier).

All our allocators return things aligned to their size, does ITS need
higher alignment than that?

Jason
