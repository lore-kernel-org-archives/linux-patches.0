Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794469295;
	b=ROPOxrkLA8b1uhnWaTajV3YtN+BTSIpNsjlWgUzxq0s5vz8jmPdUzsgXDs5MbZKjW2CT
	 aNpIsPkpYotgit6DXbz+ctStZYVUHzZ+R9P2Gte3AedJthpWx5r/RxJ+d44puUfPmu53O
	 6eO6xpuS4OjQsq8w2VyxNDgUK1fvgmSkt0ozjiwQfLvE0jJQRotzXbroFfGLQHOrz0nn/
	 r7BlNV1EEOlMmpkIQ+eBt3mCkFVKw1lBpt7TJi1MZmvTQMeIATuGhfTjES6Keke8CEJj9
	 mXdn3+WIP49qCyOtsWqLbwunHA3217ZX4d75uMffz8V867Wt/fp+fpeM273Txa29GiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794469295;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=Y+HA+l8H/uwotuPQBERodQA3mhW1VFj6aj3cdgPu+Xg=;
	b=RI9fa2IsEXBKZfHDhomTblgIS/bSELcB2wSJ5wDPb5SKe3522a5/70W8CL/tLWZR57d8
	 88aZZOA4/II3IEgWzDO6W6LR4Pd77egGrK5y7qrR/kXd4amWeKg0/qmSyaHZ9gOwzuull
	 Q04uFGpnkfT1MwTR0il5+ea62qemiPGeRyCq0UnNkp/QeCUj7DV40OuTa0I0OnrqQ1onj
	 mIBSXFoGXY6sNzQ3Bp5oTXzpA1iDZ1rb2mLg0DfCMynRPMx4MEDLOyWkoQH4oxxsQu2CN
	 Hdpcgkf3lSymv6UbMWSUQxWJOrYI/pohgiHVAUx049jjQNHcyiDsNinQMheOXaP2MnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="ozo/5U21";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BE6B606A323;
	Thu, 12 Nov 2026 07:41:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ozo/5U21
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5641F00A05;
	Thu, 12 Nov 2026 07:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794469295;
	bh=Y+HA+l8H/uwotuPQBERodQA3mhW1VFj6aj3cdgPu+Xg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ozo/5U21IMcgcAgODzRhCGXZ2cDjPzS2i2YWsUBLNl4bUDWhR20Hp5XtcV2Z+Ky6V
	 EmR5TqbMIwUTlGUHqKcczOhJQ91OKILCIIImkCevZEZ0DTQRglp+NvZu6YYSGEbRZ3
	 VFDWClc5+5KQ4KyMK6o5YRsxRf1yCC9QLMhiBU7ehfkawjCnP8GtIGuokW8LCtLbvU
	 OLzr9S/7T3+/JtWqikrtB/P+P7p+Zd+P+U4LKQ4KHcSsu01gGtASlfsSrYSp7KrMA7
	 0qL/DsggIdWsl54YKQS7h6YFLFh5uH43V6MvU3FivN13ofi2waCxKEgwTEClAtLcKE
	 5olGRM+l+3wbQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kevin Tian <kevin.tian@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Alexey Kardashevskiy <aik@amd.com>,
	Xu Yilun <yilun.xu@linux.intel.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Steven Price <steven.price@arm.com>,
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v5 01/16] KVM: guest_memfd: Add a handle for provider PFNs
Date: Thu, 12 Nov 2026 13:11:05 +0530
Message-ID: <20261112074120.1570072-2-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
References: <20261112074120.1570072-1-aneesh.kumar@kernel.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an MMIO PFN flag, separate from KVM memory attributes.

Add struct guest_memfd_handle to hold a PFN, its attributes, the order
of the contiguous range and an optional folio reference. Later patches
use this handle for both folio and PFN providers.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 include/linux/guest_memfd.h | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/include/linux/guest_memfd.h b/include/linux/guest_memfd.h
index 3e2c0714ca33..659d7d4baa58 100644
--- a/include/linux/guest_memfd.h
+++ b/include/linux/guest_memfd.h
@@ -2,13 +2,30 @@
 #ifndef _LINUX_GUEST_MEMFD_H
 #define _LINUX_GUEST_MEMFD_H
 
+#include <linux/bits.h>
 #include <linux/types.h>
 
+#define GUEST_MEMFD_PFN_MMIO	BIT_ULL(0)
+
 struct file;
 struct folio;
 struct inode;
 struct mempolicy;
 
+/**
+ * struct guest_memfd_handle - PFN information and an optional folio reference
+ * @pfn: Physical frame number
+ * @pfn_attrs: GUEST_MEMFD_PFN_* memory type and permissions
+ * @max_order: Largest order of a contiguous range with the same PFN attributes
+ * @folio: Optional locked folio reference, managed by the core
+ */
+struct guest_memfd_handle {
+	unsigned long pfn;
+	u64 pfn_attrs;
+	int max_order;
+	struct folio *folio;
+};
+
 /**
  * struct guest_memfd_provider_operations - Operations for external memory providers
  * @attach: Attach to a resource file, perform filesystem-specific validation,
-- 
2.43.0

