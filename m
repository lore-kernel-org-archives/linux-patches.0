Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024333;
	b=4qGtUmd/39TZvUXLfm5QbOlHaYXlm/iN5wrEEfnvHwWs2x9muk8DkYquXn/Fzo03hqmv
	 GfvE4bxdvQff1Nh/ygrtQtX8Y7q54wQPUroBvBfnGt1QUnGKipJrfjAdi32acfM8fhgnb
	 VvedIszOUKuKb4ncICRyRuH3tEUZ1X0x3uJQMyMqaRo7nd9D6S2UlGMliSIVKJaejYUqw
	 QgdNt5IRNKo2hQCNbL1f2NZLyE345xlXKF4+3zNReejARHKBseHTxVEEFLveoKipGOz4z
	 baAy9Q7hbvTl/uwYB6f0nfMvedpCFBgEqcuCd0/2OU9NTBAJTTaEBAvKHgtjuwUJN6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024333;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VGvUXaIEdWbPCgvKl5djLGY4vWYD6Z1v+ja7HGnbo5Y=;
	b=4GyYH+C7jVC/zkRURKZPfyEw54QvLiV6d8bM8EGmSf2nPhFQGGVwXL2nkreq1Dv5AbiH
	 lbxg/7xUcpWN72NEHLwwtGSxNjAyfEgcgRmofNdleDB/uYabp8H/T9SZqbLVMdWtyQHKi
	 w5w5ZLLDmq9unEW3k5HC8hW2BLklJx+8a8QPYB79guNm/krro9IRR1d5OwXfbe3BY4BL4
	 UXzyy/sJYyMQ8CG+qFSSTUvk2XsK3aL/ZaxASaFBKKHZNXyG8ZireJcVmVZ3yLckChH2m
	 rWuaFWZgik33K5g2ByPFwWK64Gbra6yJf5lGxvqNGIzrHZ1ZkUdkISLo8EWFhwdnFWw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EkpRS6Q+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 525E260A261E;
	Wed, 18 Nov 2026 17:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EkpRS6Q+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B751F000D0;
	Wed, 18 Nov 2026 17:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024333;
	bh=VGvUXaIEdWbPCgvKl5djLGY4vWYD6Z1v+ja7HGnbo5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EkpRS6Q+PrN6iFqYDtYIoAB/jAc/ofISWOWSAGHPwX+ENn6AnqTCNXH+25hleg+mH
	 oxUAvDMBrMMqSNKjaIpBTW7ULNdzNVPNEaxQsdK8AQ7WJePZZpkBqJJo7rJ0tnuVrS
	 D6o3gEXd+Z06WrNba7oSgqYHw4eA5q9qeOsPY0zQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beata Michalska <beata.michalska@arm.com>,
	Robin Murphy <robvin.murphy@arm.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0686/2151] rust: dma: allow drivers to tune max segment size
Date: Wed, 18 Nov 2026 15:40:21 +0100
Message-ID: <20261118150146.787893976@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Beata Michalska <beata.michalska@arm.com>

[ Upstream commit c71257394bc9c59ea727803f6e55e83fe63db74e ]

Make dma_set_max_seg_size() available to Rust so drivers can perform
standard DMA setup steps.

Signed-off-by: Beata Michalska <beata.michalska@arm.com>
Acked-by: Robin Murphy <robvin.murphy@arm.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Link: https://patch.msgid.link/20260128135320.689046-1-beata.michalska@arm.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Stable-dep-of: c15c5befd6d6 ("rust: scatterlist: honor the device's maximum segment size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/helpers/dma.c |  6 ++++++
 rust/kernel/dma.rs | 17 +++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/rust/helpers/dma.c b/rust/helpers/dma.c
index 2afa32c21c946..20413428a4960 100644
--- a/rust/helpers/dma.c
+++ b/rust/helpers/dma.c
@@ -40,3 +40,9 @@ size_t rust_helper_dma_max_mapping_size(struct device *dev)
 {
 	return dma_max_mapping_size(dev);
 }
+
+__rust_helper void rust_helper_dma_set_max_seg_size(struct device *dev,
+						    unsigned int size)
+{
+	dma_set_max_seg_size(dev, size);
+}
diff --git a/rust/kernel/dma.rs b/rust/kernel/dma.rs
index b6c73db358ced..6a9497bc69a7d 100644
--- a/rust/kernel/dma.rs
+++ b/rust/kernel/dma.rs
@@ -84,6 +84,23 @@ unsafe fn dma_set_mask_and_coherent(&self, mask: DmaMask) -> Result {
             bindings::dma_set_mask_and_coherent(self.as_ref().as_raw(), mask.value())
         })
     }
+
+    /// Set the maximum size of a single DMA segment the device may request.
+    ///
+    /// This method is usually called once from `probe()` as soon as the device capabilities are
+    /// known.
+    ///
+    /// # Safety
+    ///
+    /// This method must not be called concurrently with any DMA allocation or mapping primitives,
+    /// such as [`CoherentAllocation::alloc_attrs`].
+    unsafe fn dma_set_max_seg_size(&self, size: u32) {
+        // SAFETY:
+        // - By the type invariant of `device::Device`, `self.as_ref().as_raw()` is valid.
+        // - The safety requirement of this function guarantees that there are no concurrent calls
+        //   to DMA allocation and mapping primitives using this parameter.
+        unsafe { bindings::dma_set_max_seg_size(self.as_ref().as_raw(), size) }
+    }
 }
 
 /// A DMA mask that holds a bitmask with the lowest `n` bits set.
-- 
2.53.0



