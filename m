Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214952;
	b=QcE0RK2Yox89yPkqE2xzihBD5mHrblMaBfFG0H5iFDoJ07WBe+DuU2gOV7zeICfRuyVa
	 ROZlfLwwADdcFb+xjbA7f8XFH6xy66mCewSUTl+Mw964I2hBRaqFDEhxbpMQb0syrvlMz
	 DVHNg3Pq44Iyvp+fkto6TDk+Z8x6VlaeYT/7gQc/iknYmnbQ2zlC9KhulzyQ66o8gc/VU
	 7oCD5Nbs3UA9nXcvbmprN3apHoiCvFIT8vttRnkXafZpbU3OpK/YFw+xHE/w7uclK5Xv2
	 dB3zZSZYK+IJt/GcGRLxHoTuvh9/QwDO8486w1rU2YLba8bvXlHzpTfD9UFh2iV+gtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214952;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=CmmHXN1LwzvY7XX7CGt3xbdYnkDNgIihArjagBeqZOw=;
	b=ooQgT/dpJgxJGL0XvTnEwZUieiWCJDGXlGyiugA3/J5PNsUAloZWIOnCpINfEFy18XbA
	 jxrGCZWXAMF9z1ThR87pfgPaXhDGZ4r2r37yzq+GB5+WzFdy3KW9IZXVOsd2jzh1DgeLW
	 wUoDwXBTquJqoJEYIaCnRU84jTpse8JDLJACR4qDpPyLjU8JJLPKiq0UOET2YoIXaJReO
	 zcU5bAY+gJDjUsxn4Mrc7Ohv9yuQdqttrCvqBpZu/g+rkI11WZzmzY3J/Gqf7xxStCB/S
	 WHNN6L/ZyVj9mrJZr+l1aFz+gOxifKY3EJhrXeZ59ee72bDHMDHmTMCDOMCudCU/QhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FD+hYFgn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76A26606A331;
	Wed, 28 Oct 2026 19:15:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FD+hYFgn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F2F1F031E4;
	Wed, 28 Oct 2026 19:15:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214952;
	bh=CmmHXN1LwzvY7XX7CGt3xbdYnkDNgIihArjagBeqZOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FD+hYFgnWNu+eV2eXMfDFmpyJkez4hXKR2z0GXnOgrI28D8IuEJVLfO15P+yTL6E0
	 zFzIqKey9X1vqgJi9VaLwS1Gl8qRrvJxLwys6sKYoawfgi7ghMNC7CyVcDu5m2kfnE
	 bMbj36xn+t85qEQpedoLC3H3GiYpEi6I2xru0Z4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmytro Maluka <dmaluka@chromium.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Kevin Tian <kevin.tian@intel.com>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1038/1887] iommu/vt-d: Clear Present bit before tearing down context entry
Date: Wed, 28 Oct 2026 17:52:14 +0100
Message-ID: <20261028170523.032678333@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lu Baolu <baolu.lu@linux.intel.com>

[ Upstream commit c1e4f1dccbe9d7656d1c6872ebeadb5992d0aaa2 ]

When tearing down a context entry, the current implementation zeros the
entire 128-bit entry using multiple 64-bit writes. This creates a window
where the hardware can fetch a "torn" entry — where some fields are
already zeroed while the 'Present' bit is still set — leading to
unpredictable behavior or spurious faults.

While x86 provides strong write ordering, the compiler may reorder writes
to the two 64-bit halves of the context entry. Even without compiler
reordering, the hardware fetch is not guaranteed to be atomic with
respect to multiple CPU writes.

Align with the "Guidance to Software for Invalidations" in the VT-d spec
(Section 6.5.3.3) by implementing the recommended ownership handshake:

1. Clear only the 'Present' (P) bit of the context entry first to
   signal the transition of ownership from hardware to software.
2. Use dma_wmb() to ensure the cleared bit is visible to the IOMMU.
3. Perform the required cache and context-cache invalidation to ensure
   hardware no longer has cached references to the entry.
4. Fully zero out the entry only after the invalidation is complete.

Also, add a dma_wmb() to context_set_present() to ensure the entry
is fully initialized before the 'Present' bit becomes visible.

Fixes: ba39592764ed2 ("Intel IOMMU: Intel IOMMU driver")
Reported-by: Dmytro Maluka <dmaluka@chromium.org>
Closes: https://lore.kernel.org/all/aTG7gc7I5wExai3S@google.com/
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Dmytro Maluka <dmaluka@chromium.org>
Reviewed-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Kevin Tian <kevin.tian@intel.com>
Link: https://lore.kernel.org/r/20260120061816.2132558-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel/iommu.c | 26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

diff --git a/drivers/iommu/intel/iommu.c b/drivers/iommu/intel/iommu.c
index 9ef81870b20cf..59c094bf9b3fe 100644
--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -169,7 +169,26 @@ static phys_addr_t root_entry_uctp(struct root_entry *re)
 
 static inline void context_set_present(struct context_entry *context)
 {
-	context->lo |= 1;
+	u64 val;
+
+	dma_wmb();
+	val = READ_ONCE(context->lo) | 1;
+	WRITE_ONCE(context->lo, val);
+}
+
+/*
+ * Clear the Present (P) bit (bit 0) of a context table entry. This initiates
+ * the transition of the entry's ownership from hardware to software. The
+ * caller is responsible for fulfilling the invalidation handshake recommended
+ * by the VT-d spec, Section 6.5.3.3 (Guidance to Software for Invalidations).
+ */
+static inline void context_clear_present(struct context_entry *context)
+{
+	u64 val;
+
+	val = READ_ONCE(context->lo) & GENMASK_ULL(63, 1);
+	WRITE_ONCE(context->lo, val);
+	dma_wmb();
 }
 
 static inline void context_set_fault_enable(struct context_entry *context)
@@ -2355,7 +2374,7 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 		did_old = context_domain_id(context);
 	}
 
-	context_clear_entry(context);
+	context_clear_present(context);
 	__iommu_flush_cache(iommu, context, sizeof(*context));
 	spin_unlock(&iommu->lock);
 	iommu->flush.flush_context(iommu,
@@ -2374,6 +2393,9 @@ static void domain_context_clear_one(struct device_domain_info *info, u8 bus, u8
 				 DMA_TLB_DSI_FLUSH);
 
 	__iommu_flush_dev_iotlb(info, 0, MAX_AGAW_PFN_WIDTH);
+
+	context_clear_entry(context);
+	__iommu_flush_cache(iommu, context, sizeof(*context));
 }
 
 static int domain_setup_first_level(struct intel_iommu *iommu,
-- 
2.53.0



