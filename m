Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214918;
	b=seGuI12Kieq8McPFNQWPLeVlQzInFv2KkfKXxlusRx8+qJ/vyPZAYS3ywQfHcyBzq/9E
	 jVxRBHni3ZHX5MyT67eBWTWyJ3QQfHu6NQZiP3r0SkUliQWBgy5DY//Ee5gW2oX9o9tQe
	 RgPFgaojV+Fh3crZIoOYJHMo4yiEN+qu+pQ+d81keV0pyI4d1O0EH32g5LdZ1gEs6rSUJ
	 BW7q0loe9wK3EoVrcu23pxfA7mZORl2HB0r1O+MyyUdtMFXKyPIVQdz81NIWYDvzvC5XD
	 elMvEndz99Znwx/Xd4f3sz7ogZlZSfef+GrwCzAp2OLlLgr8etAEw1IBMiJj+Tu2iGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214918;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=hPEOdps2AWdteLnO5JZBuUUzr3RPGYppnH3mRbZa4II=;
	b=p3oc4RMBMzUKQpruosxz0+VfS1go1TDh880YRPakNmB/CZwE6eKObkmUtF42lDXnX43h
	 awuB7m4Xq3C+9aYfSxcLRuVYRRAJpT+yZ/X/kMn78LL1+YrC+IJw9qkeQF+F/jNmWjIuR
	 ETYLMIUlt1zHzgZ/HCxa+5Z7bEBKCSfbsZvRbADHoIKmby7EeDuttvZWsxsEeVgwTIpg7
	 8+EfBnCsaZr3RHuuZuyv1MKgoHJxfm+BV7WjyG+c+lZoCMb9eV824AzwB8AS1Mf66giay
	 BXpctCfR6eO/MY3pSdA99JgZblXkSYgDMFEETBUf7aPLl2KoVr0Xa0DffH8TEXC39zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywEUfVHs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22A8606A31A;
	Wed, 28 Oct 2026 19:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ywEUfVHs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45C551F01825;
	Wed, 28 Oct 2026 19:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214917;
	bh=hPEOdps2AWdteLnO5JZBuUUzr3RPGYppnH3mRbZa4II=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ywEUfVHsZfQqppucoO3ihcavHGLNevCCkzVQRn/odJVO+zYcuKJKQUW+N1mwzhwyJ
	 0eDc3Gp2gnd34kyhV7H6zFDwtrHyBqkWMoUrzBevAoU+yxSa3CTYqVAgT0Sg92hd89
	 gKLP0x3TT8hDRQ+NDUkHqMOm0dp5LNRDSu4t67FI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Dmytro Maluka <dmaluka@chromium.org>,
	Samiullah Khawaja <skhawaja@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1027/1887] iommu/vt-d: Clear Present bit before tearing down PASID entry
Date: Wed, 28 Oct 2026 17:52:03 +0100
Message-ID: <20261028170522.786683310@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit 75ed00055c059dedc47b5daaaa2f8a7a019138ff ]

The Intel VT-d Scalable Mode PASID table entry consists of 512 bits (64
bytes). When tearing down an entry, the current implementation zeros the
entire 64-byte structure immediately using multiple 64-bit writes.

Since the IOMMU hardware may fetch these 64 bytes using multiple
internal transactions (e.g., four 128-bit bursts), updating or zeroing
the entire entry while it is active (P=1) risks a "torn" read. If a
hardware fetch occurs simultaneously with the CPU zeroing the entry, the
hardware could observe an inconsistent state, leading to unpredictable
behavior or spurious faults.

Follow the "Guidance to Software for Invalidations" in the VT-d spec
(Section 6.5.3.3) by implementing the recommended ownership handshake:

1. Clear only the 'Present' (P) bit of the PASID entry.
2. Use a dma_wmb() to ensure the cleared bit is visible to hardware
   before proceeding.
3. Execute the required invalidation sequence (PASID cache, IOTLB, and
   Device-TLB flush) to ensure the hardware has released all cached
   references.
4. Only after the flushes are complete, zero out the remaining fields
   of the PASID entry.

Also, add a dma_wmb() in pasid_set_present() to ensure that all other
fields of the PASID entry are visible to the hardware before the Present
bit is set.

Fixes: 0bbeb01a4faf ("iommu/vt-d: Manage scalalble mode PASID tables")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Dmytro Maluka <dmaluka@chromium.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260120061816.2132558-2-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/pasid.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/pasid.c b/drivers/iommu/intel/pasid.c
index 178ca6fadb736..e0647142c6af1 100644
--- a/drivers/iommu/intel/pasid.c
+++ b/drivers/iommu/intel/pasid.c
@@ -262,7 +262,7 @@ intel_pasid_clear_entry(struct device *dev, u32 pasid, bool fault_ignore)
 	if (WARN_ON(!pe))
 		return;
 
-	if (fault_ignore && pasid_pte_is_present(pe))
+	if (fault_ignore)
 		pasid_clear_entry_with_fpd(pe);
 	else
 		pasid_clear_entry(pe);
@@ -358,9 +358,23 @@ static inline void pasid_set_wpe(struct pasid_entry *pe)
  */
 static inline void pasid_set_present(struct pasid_entry *pe)
 {
+	dma_wmb();
 	pasid_set_bits(&pe->val[0], 1 << 0, 1);
 }
 
+/*
+ * Clear the Present (P) bit (bit 0) of a scalable-mode PASID table entry.
+ * This initiates the transition of the entry's ownership from hardware
+ * to software. The caller is responsible for fulfilling the invalidation
+ * handshake recommended by the VT-d spec, Section 6.5.3.3 (Guidance to
+ * Software for Invalidations).
+ */
+static inline void pasid_clear_present(struct pasid_entry *pe)
+{
+	pasid_set_bits(&pe->val[0], 1 << 0, 0);
+	dma_wmb();
+}
+
 /*
  * Setup Page Walk Snoop bit (Bit 87) of a scalable mode PASID
  * entry.
@@ -470,7 +484,7 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 
 	did = pasid_get_domain_id(pte);
 	pgtt = pasid_pte_get_pgtt(pte);
-	intel_pasid_clear_entry(dev, pasid, fault_ignore);
+	pasid_clear_present(pte);
 	spin_unlock(&iommu->lock);
 
 	if (!ecap_coherent(iommu->ecap))
@@ -486,6 +500,10 @@ void intel_pasid_tear_down_entry(struct intel_iommu *iommu, struct device *dev,
 	/* Device IOTLB doesn't need to be flushed in caching mode. */
 	if (!cap_caching_mode(iommu->cap))
 		devtlb_invalidation_with_pasid(iommu, dev, pasid);
+
+	intel_pasid_clear_entry(dev, pasid, fault_ignore);
+	if (!ecap_coherent(iommu->ecap))
+		clflush_cache_range(pte, sizeof(*pte));
 }
 
 /*
-- 
2.53.0



