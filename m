Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793626863;
	b=LrwMM2bi+h9l/9ZQLXYN3XaXCApjzi7Ha3vOZ5CqUZvVf6cvLKIdlrw6cKEg0Z1zpPxp
	 ysAu9fpr0vsbLhp6TA4mV6TloaB5W4xRsQeWF8xNhKZNKqA6VvNsL1YCTLcrDc8kjj8EZ
	 jhVB3nM1IWDBYdKbodDtE5rYkuya+2HShryLtDYRuCisqe+C4stRGNwg+H7wSZ8E4+7ZO
	 Co8PSn1XuS3nJc3VPC5P5p+7BrC3/7YL+lc5+yZO2B6kdP0DqTExDZYcGviB2Uhpd4/90
	 1/VPpC5vYFfiICkfJoA2FTbq8utMHtKxNPHnsEPipvzP/jJY00p0zYj4aDl7H8oPBQA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793626863;
	h=Received:DKIM-Signature:X-Mailer:From:To:Cc:Subject:In-Reply-To:
	 References:Date:Message-ID:MIME-Version:Content-Type;
	bh=pdjAuETj6QcMhvC8ZxVXiv5ojquYRwlbvdnRb3U3eDY=;
	b=D8vU7GVcP9UNqeTMFIBoSknAr1+q3O+yjXfp9Yf5X6gEBBMbAyvqNh0uKb79lnf6tMQG
	 RyOfipOjL1+abvSxIqLugXLHZz0WbmKKuJX8yfff3UZAN/GiHDtWTM7SRnJtmEBBN42gy
	 zM+9TwJ6bKh/EU5D6hs7csqyyYtdJqmNV7qG3oZYptJdjiZy9LluV6rk0waGfwLE2BoU7
	 IolNNhYzqT3eQs5XXLaJ8DgzKNkE6wCBsrND/+DBad6QHpoIoif0MdRk2y/YoFvrBaeD0
	 iGuotAM+4xhdR6X3fB6JwGrQtkf2F8h8bPe5cHRit9K4gd1QcW/4tGTC06SfKrAHMdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MMbEDOY0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF09C606A326;
	Mon,  2 Nov 2026 13:41:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=MMbEDOY0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7179B1F00A17;
	Mon,  2 Nov 2026 13:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793626862;
	bh=pdjAuETj6QcMhvC8ZxVXiv5ojquYRwlbvdnRb3U3eDY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=MMbEDOY0OmbpHnaLfTp/tGOscM0cLWYj9WB3bHalRtrnz7a2w4SfkqLrsfAOwGRuD
	 4oJ0lUy3uXOr3VbYF/H2MX5DRxGfx6PQTmhezc8gVNtrb24rpSEBGipbSngP+YXujI
	 ZicdHMN9ZeSpKUyPkyy+150wWID1ceyGaIEKMPUVNrgjNi9FPGz+xZF7iOslQSrcxR
	 qdGlZ1nzVjjxSlYUIVaT8pSP1dGtm86BdpL1GTZ3c7iio3i3Ag5JX9BSHccm+3APRy
	 vFWu3sDU3MKqgmvn3RGd5qXCNdkBalh2xKoumvjWpSC4Lg0U9A5IfO17qS5ha+U0OP
	 yRJYC3Auf4ePg==
X-Mailer: emacs 31.1 (via feedmail 11-beta-1 I)
From: Aneesh Kumar K.V <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: Ackerley Tng <ackerleytng@google.com>,
	Alex Williamson <alex@shazbot.org>,
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
Subject: Re: [RFC PATCH v3 00/13] KVM: guest_memfd: Add a common framework
 for device memory providers
In-Reply-To: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
References: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
Date: Mon, 02 Nov 2026 19:10:50 +0530
Message-ID: <yq5aa4nr5p25.fsf@kernel.org>
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

"Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org> writes:

> Confidential device assignment needs guest_memfd to manage device MMIO as
> well as RAM. Device resources such as PCI BARs supply PFNs directly, and
> their protected mappings need architecture-specific map and unmap
> operations.
>
> This series adds the common guest_memfd support needed by device memory
> providers. It builds on the resource-provider API [1] and the existing
> folio and RAM PFN backing support.
>
> The VFIO provider, IOMMUFD integration and Arm CCA implementation are
> available together at:
>
>   https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-gmem-backend
>

An updated series is available at:

  https://git.gitlab.arm.com/linux-arm/linux-cca.git cca/topics/cca-da-gmem-backend-v4

Most details remain unchanged. The VFIO/PCI code has received cleanups
and updates, as summarized in the cover letter[1]. I will rebase the full
series onto 7.4-rc1 before reposting it. If you would like to review v4
before then, let me know and I can repost it.

[1]
https://git.gitlab.arm.com/linux-arm/linux-cca/-/blob/cca/topics/cca-da-gmem-backend-v4/cover.letter.gmem_vfio?ref_type=heads

-aneesh
