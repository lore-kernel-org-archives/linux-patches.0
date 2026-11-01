Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793517661;
	b=B7iPNd2i/tkK3UqVewz9rpaHA0DXsB8pFEDZpCbJsMnNe3klDeLLxxBytXA7SePdLbZZ
	 OTw74RG2fPKT84Z5/MCrNoy4PZ8WcFPrvKxqGGApaexR1lHOgASrpd4fGmxKgJLaqielN
	 6Z56ERCkubLhKQMUlMqcRZEUXew03+uJfU+RZpHT/DxO9pPh1ySqe/Zs7+kzGC0ggzhhJ
	 8+TXYc0FA6bseAmtQGNBGw9OfcFZ16K7oDOw7SiPhLeCy0RMISxXQaVX77JBI4xWoZCXg
	 a6QXVHH2ZyZIDMRsOcuqp+XQEP8gAwaVwoTgkyAZwF0/AtxvhcW83OKW0SqPTFqVdNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793517661;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=u1laEzhqisY7pHnGKooi8T+fUD4JLukk8Z0xutpnDl4=;
	b=ct/5ld9D3qQu3BHOeeFpGNlY6RgEpiZZO+pyTMLV4ZSmqGK+jg9NCIscWdQFJU5PVWiM
	 SqsrbYh80PilYbvhwLJwcynRUfj9TODTbLEYtmk7ukdYsjm/XnYU/f79Le2AHIcNP0ZlI
	 PySSa5BJ+cVHVSQx/YAXi/j5z8qyHwfcujY8gtIGJ2WlOirS8qtwEftqu0OFJDj1sONmf
	 XFDO4THWPEOsMAKxZyC1mX+9CDO/agZtLFxtdddMsDCg3SjWwHBS8tzrkfESp+32mTb5k
	 gbbXF88FRq820t77xIDFnI7PjbolMT8jm8iSvlRBPl1y5nKxV1uhGrWTSSVf8Y71ksQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m31iUhtL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABB92606A324;
	Sun,  1 Nov 2026 07:21:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m31iUhtL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 590BD1F00A02;
	Sun,  1 Nov 2026 07:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793517660;
	bh=u1laEzhqisY7pHnGKooi8T+fUD4JLukk8Z0xutpnDl4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m31iUhtLwfx9ui1wywLA1l9wNDrbK9zteSv9ze8CvgQdqkOU91SjNJ3ysdjkAJSma
	 mp5xZrhBPjWWf707mYGHZOyVj/5lJJkkOIG2dKmsZ4jPUwIouD0B+1/cWFirO+dQsW
	 2WZ92LWqs16oFl9eym/WXaB5CaqYQZd7byYuhVV6Z801SlQQPMC45eTupTGq/dwYMJ
	 SXX6rnn/lGFy6feWbCgFGYk0WvruZ6fRXrOhJkrSQfCVqf0SBSrc5QpeNATwRfsYIh
	 Nh2YEcQ8dbXnKbGcyIqF+GAUAzeL3pOKgKjuBw0TllJlB1iv8dFx6ufPAiljoeRukO
	 Cs3R6Pyy9C+DQ==
From: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>
To: linux-coco@lists.linux.dev
Cc: "Aneesh Kumar K.V (Arm)" <aneesh.kumar@kernel.org>,
	Ackerley Tng <ackerleytng@google.com>,
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
	Fred Griffoul <griffoul@gmail.com>,
	iommu@lists.linux.dev,
	kvm@vger.kernel.org,
	patches@lists.linux.dev
Subject: [RFC PATCH v3 10/13] KVM: guest_memfd: Support range revocation of device mappings
Date: Sun,  1 Nov 2026 12:49:24 +0530
Message-ID: <20261101071928.2462549-11-aneesh.kumar@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
References: <20261101071928.2462549-1-aneesh.kumar@kernel.org>
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

Give device backing a revoke operation that removes host and both shared
and private guest translations under provider exclusion, without reclaiming
MMIO PFNs or changing attributes. Keep fallocate and hole punching
unsupported for device memory.

Range revocation does not exclude new faults after returning. Providers
must preserve the underlying resource and call without provider locks held,
since inode exclusion precedes provider exclusion. Private attributes
continue to describe ownership until explicitly changed or the file closes.

Signed-off-by: Aneesh Kumar K.V (Arm) <aneesh.kumar@kernel.org>
---
 virt/kvm/guest_memfd.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 1322576350b8..cfb7f34c0180 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -559,6 +559,18 @@ static int kvm_gmem_ram_pfn_revoke(struct inode *inode, pgoff_t start, pgoff_t e
 	return 0;
 }
 
+static int kvm_gmem_device_revoke(struct inode *inode, pgoff_t start, pgoff_t end,
+		const unsigned long *pfn, bool put_pfn_range)
+{
+	/*
+	 * Common invalidation handles shared and private guest mappings. Only
+	 * host userspace mappings need to be unmapped here; MMIO has no RAM
+	 * pages to reclaim or provider allocations to release.
+	 */
+	unmap_mapping_pages(inode->i_mapping, start, end - start, true);
+	return 0;
+}
+
 static int __kvm_gmem_revoke(struct inode *inode, pgoff_t start,
 			      size_t nr_pages, const unsigned long *pfn,
 			      bool put_pfn_range)
@@ -622,7 +634,11 @@ static long kvm_gmem_punch_hole(struct inode *inode, loff_t offset, loff_t len)
  *
  * Must be called before accessing memory contents. Keeping the mapping from
  * @start to @pfn constant is the responsibility of the caller.
- * .put_pfn_range() will not be called.
+ * .put_pfn_range() will not be called. For device memory, this revokes host
+ * and both shared and private guest mappings under provider exclusion, without
+ * changing attributes or releasing BAR PFNs. Call without provider locks held:
+ * inode exclusion precedes provider exclusion. This does not exclude new faults
+ * after returning; the provider must preserve the backing resource.
  *
  * Return: 0 on success, or a negative error code on failure.
  */
@@ -1185,6 +1201,7 @@ static const struct kvm_gmem_backing_ops kvm_gmem_ram_pfn_backing_ops = {
 };
 
 static const struct kvm_gmem_backing_ops kvm_gmem_device_backing_ops = {
+	.revoke = kvm_gmem_device_revoke,
 	.prepare_attributes = kvm_gmem_pfn_prepare_attributes,
 	.make_private = kvm_gmem_device_make_private,
 	.make_shared = kvm_gmem_noop_conversion,
-- 
2.43.0

