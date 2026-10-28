Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208838;
	b=Rifs35GR0d+VTnMbsnJeqxUiyNaDm7AA1TQFYR8LTGhz+2HZ/vzGr+yo4yqhJS1/pvWC
	 7SchksR8YJrXvhAOjf/OJmR4jrauqKPjmsGZsZAQ+5jvBRJNlHvSFKyGnmy4kIgOzml5C
	 y9drvKZ0rebt7fSXq4oGS10njIkzdU5HByHWN/ZVjuJBeNPf0x+nha93RQr8HWba3689A
	 qFcbdVVPtuNhcPPOKbEj6s+TyNMwvSG/69VuNqqSezlZoFMbMNyi2VjDZI9cLzsXJiWj3
	 NByJ/OpKXHJaCjke0anr4o2b4jZMNyd7I85uE0Rz+FcK3e43zjEPFqi6L2SVqC9iFLw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208838;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zTNrTVgD5dfGUU5rL5MINcBOnp7ara458N9hQfymwnQ=;
	b=Fijlf/kyBc3bS/9lvRw032wVKrhxrrKt5XTr8F+oGxOgX9RmqEvGkGKUta6k1THI+PTI
	 b53ZMocq+k8pl8383J0FUTRnnqK7ELGHhkg4bJLPFAaIcAzs0OdDpbZa53i5D83KzwtSP
	 wJwitGN4acgfL3hW2RYJGZbXWdrUO9M8JZKsuPPnEXHpJb9hFZHvrE4Dmo7bXaH8CEpJx
	 lE86wx4Nxxpx4jxBKrJ+cRhKBGnEeysqPnq/ha5Y6GAUPaF/axTT91SHtfXPr/Vxs6DEU
	 4P8rFF+NWh0d/DhQSPcvjwIys80qXogTVej0yche1vOXHsCz+wipx8xlz2aV1aIUJFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vPYr6ZYh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9379A606A31C;
	Wed, 28 Oct 2026 17:33:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vPYr6ZYh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9011F01825;
	Wed, 28 Oct 2026 17:33:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208838;
	bh=zTNrTVgD5dfGUU5rL5MINcBOnp7ara458N9hQfymwnQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vPYr6ZYh6tmAW4BGVTo6NJqZ77JZqBdsKv1hCPua2tbfqQKSfFOE/kgci4ldhxSUX
	 svF63qzhQFDyo25VEHlZ6OiwWDKuS3RKDFMh3PYwfslZN2DVmvdnXOzm4wFcJyH8TM
	 MFxb3CYoezTFT1Jnzj7F5FqMmVo69Btqktqbsqrs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andy Lutomirski <luto@kernel.org>,
	Borislav Betkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jann Horn <jannh@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Joerg Roedel <joro@8bytes.org>,
	Kevin Tian <kevin.tian@intel.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Michal Hocko <mhocko@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Robin Murohy <robin.murphy@arm.com>,
	Thomas Gleinxer <tglx@linutronix.de>,
	"Uladzislau Rezki (Sony)" <urezki@gmail.com>,
	Vasant Hegde <vasant.hegde@amd.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yi Lai <yi1.lai@intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Rahul Sharma <black.hawk@163.com>,
	Roman Demidov <roman.demidov.nn@gmail.com>
Subject: [PATCH 5.10 260/516] iommu: disable SVA when CONFIG_X86 is set
Date: Wed, 28 Oct 2026 17:56:52 +0100
Message-ID: <20261028170009.650776535@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

commit 72f98ef9a4be30d2a60136dd6faee376f780d06c upstream.

Patch series "Fix stale IOTLB entries for kernel address space", v7.

This proposes a fix for a security vulnerability related to IOMMU Shared
Virtual Addressing (SVA).  In an SVA context, an IOMMU can cache kernel
page table entries.  When a kernel page table page is freed and
reallocated for another purpose, the IOMMU might still hold stale,
incorrect entries.  This can be exploited to cause a use-after-free or
write-after-free condition, potentially leading to privilege escalation or
data corruption.

This solution introduces a deferred freeing mechanism for kernel page
table pages, which provides a safe window to notify the IOMMU to
invalidate its caches before the page is reused.


This patch (of 8):

In the IOMMU Shared Virtual Addressing (SVA) context, the IOMMU hardware
shares and walks the CPU's page tables.  The x86 architecture maps the
kernel's virtual address space into the upper portion of every process's
page table.  Consequently, in an SVA context, the IOMMU hardware can walk
and cache kernel page table entries.

The Linux kernel currently lacks a notification mechanism for kernel page
table changes, specifically when page table pages are freed and reused.
The IOMMU driver is only notified of changes to user virtual address
mappings.  This can cause the IOMMU's internal caches to retain stale
entries for kernel VA.

Use-After-Free (UAF) and Write-After-Free (WAF) conditions arise when
kernel page table pages are freed and later reallocated.  The IOMMU could
misinterpret the new data as valid page table entries.  The IOMMU might
then walk into attacker-controlled memory, leading to arbitrary physical
memory DMA access or privilege escalation.  This is also a
Write-After-Free issue, as the IOMMU will potentially continue to write
Accessed and Dirty bits to the freed memory while attempting to walk the
stale page tables.

Currently, SVA contexts are unprivileged and cannot access kernel
mappings.  However, the IOMMU will still walk kernel-only page tables all
the way down to the leaf entries, where it realizes the mapping is for the
kernel and errors out.  This means the IOMMU still caches these
intermediate page table entries, making the described vulnerability a real
concern.

Disable SVA on x86 architecture until the IOMMU can receive notification
to flush the paging cache before freeing the CPU kernel page table pages.

Link: https://lkml.kernel.org/r/20251022082635.2462433-1-baolu.lu@linux.intel.com
Link: https://lkml.kernel.org/r/20251022082635.2462433-2-baolu.lu@linux.intel.com
Fixes: 26b25a2b98e4 ("iommu: Bind process address spaces to devices")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Borislav Betkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@intel.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Jean-Philippe Brucker <jean-philippe@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Kevin Tian <kevin.tian@intel.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Robin Murohy <robin.murphy@arm.com>
Cc: Thomas Gleinxer <tglx@linutronix.de>
Cc: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
Cc: Vasant Hegde <vasant.hegde@amd.com>
Cc: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Will Deacon <will@kernel.org>
Cc: Yi Lai <yi1.lai@intel.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ The context change is due to the commit
  be51b1d6bbff ("iommu/sva: Refactoring iommu_sva_bind/unbind_device()")
  and the commit 757636ed2607 ("iommu: Rename iommu-sva-lib.{c,h}")
  in v6.2 which are irrelevant to the logic of this patch. ]
Signed-off-by: Rahul Sharma <black.hawk@163.com>
Signed-off-by: Roman Demidov <roman.demidov.nn@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/iommu.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/iommu/iommu.c
+++ b/drivers/iommu/iommu.c
@@ -2988,6 +2988,9 @@ iommu_sva_bind_device(struct device *dev
 	struct iommu_sva *handle = ERR_PTR(-EINVAL);
 	const struct iommu_ops *ops = dev->bus->iommu_ops;
 
+	if (IS_ENABLED(CONFIG_X86))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!ops || !ops->sva_bind)
 		return ERR_PTR(-ENODEV);
 


