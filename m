Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=217.140.110.172
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795432472;
	b=hqxsHjEevTtG9sBRopr0K8+0QESTWPBRRdz0FXJTgl50CGdaYWyIoO1Lm6nsmadiNukd
	 WJzr2Dda7rVaAEndtk5AA8YUe9qDOKYRgtE/p4hh++xEad2EKSsi+80M8jwAixTLD28hp
	 6fIo+Thv+pF0WLmNLBauKLOoZ0IpXj/3i7/JR+3CUeO62ld/M2w+hOlvZP2A612GNB6sY
	 YZIV3a4ISBTwR2KYi8MyvJdnZOZCNz1aXKmonofKDnpRXqH+Cxatl+hgvxiEUvLNnJsaa
	 uAIRCObtBw6vtK05CznzQDdD/QETfTCigJxdi5hTTlhDbm44uKaJxgN4OSHqGk9+ZYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795432472;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To:X-TUID;
	bh=M8BgEwiMtUwRuCgZnUVMTSSA8VV5wT5wVfxb83hMYt4=;
	b=EV74lQf3zKxK/qECQzMEstG8iVszZHQuuZ1jnKzeeODsbjzRjZyps18+O0YyH56tq0Tp
	 /OHfAKzZ/oMECkX5y33aUWmKhnU9K0eTI9e517WNf/ninFhurCC1jb6sl85C7fdYbl3jq
	 /qdJs4HtsnDFdhUq/eXrYAJrlmy6M741Zm9hPZOuCgAZkTl0zraMua6sQhr2FyD1SR8Da
	 MbwiwoCuvIqYzn3BY8Lz5jr7BKQsCBhRhlepyOhdbv/HnrwlsIHxYqoIDueGdXdIcfgIE
	 xQu+N8kZuN2w1YGWf7ldBlIKDo5wloPgz5gZuw9vNBlagaPZoNbERkqvnXV0IfS+wAQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=arm.com;
	spf=pass smtp.mailfrom=arm.com;
	dkim=pass header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cUtfC1HA;
	arc=none smtp.remote-ip=217.140.110.172
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BD2F606A31E;
	Mon, 23 Nov 2026 11:14:32 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BD2F606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=cUtfC1HA
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7CE821476;
	Mon, 23 Nov 2026 03:14:28 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1BA2F3F882;
	Mon, 23 Nov 2026 03:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1795432471; bh=4UDMjdKhEafTSrkfoMvLUzagh+R4A1yL+W6+zxTSE3g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cUtfC1HA2CZBX5GdLcjS9Fv5iD/xcSaWNNdEjaMRUj8xf0cmPTKcKav27v+CAPLkC
	 w1bkGxtfk5N0ExzhPBYejU8PO0+4gtg8l1F7GJM4V1zbhqzbrPWAA1+BjvltqwmxMn
	 LE7OlN/w/0fHifp9euPk5nQuLJbtKZlIitJWjJvE=
Date: Mon, 23 Nov 2026 11:14:21 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
Cc: linux-coco@lists.linux.dev, Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Joerg Roedel <joro@8bytes.org>,
	Marc Zyngier <maz@kernel.org>,
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
Subject: Re: [PATCH v10 01/13] mm: Add an allocator for CoCo shared memory
Message-ID: <awQgDYK2Bq0QGpNU@arm.com>
References: <20261116091137.94252-1-aneesh.kumar@kernel.org>
 <20261116091137.94252-2-aneesh.kumar@kernel.org>
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
In-Reply-To: <20261116091137.94252-2-aneesh.kumar@kernel.org>
X-TUID: 696EyIiS0JVf

On Mon, Nov 16, 2026 at 02:41:24PM +0530, Aneesh Kumar K.V (Arm) wrote:
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 3e626e45d432..5ce879ea2ef4 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -28553,6 +28553,8 @@ F:	drivers/pci/tsm/
>  F:	drivers/virt/coco/guest/
>  F:	drivers/virt/coco/tsm-core.c
>  F:	include/linux/*tsm*.h
> +F:	include/linux/cc_shared.h
> +F:	mm/cc_shared.c

Would it make sense to put these under a separate CoCo memory sharing
and encryption entry? It should also cover include/linux/mem_encrypt.h
and include/linux/cc_platform.h. Both are shared interfaces with no
specific MAINTAINERS entry.

I don’t mind who maintains the entry but I’d list both linux-coco and
linux-mm. We can leave include/linux/set_memory.h out for now since
most of that header deals with page permissions and cacheability.

-- 
Catalin
