Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793217320;
	b=PftDP0EGKGTwqVchkvIu/JJMCf5hSnC00Z41z0LQ6PkAkF1YQkZyYViqXedRQKQZcuAX
	 Hs4F4SEJsrZxY9CeXdD5HUnOxGNskYIwcr/BBYbMqLSvEtMyqmKQ67aOPZ6u/0W2pC/mg
	 e5TSUm9MkETfUYreVaxFSQft7FUtjqCgWpr4jsKeW3cZfcLHnEV7oewT6nNHhmczV99/L
	 0/WbVBuR2GOifPlM9U4jjbKq+aYi1RaQQo33S2Gh6WPxtjs/bWhRiKf4O7AY32GNeeCF2
	 iGLW1HS5gg5WeR6b9qdm+ObfuSK1zzGffu1jbJy5dMSXMhQ52ehyWDEE2y8l4GZ0Z3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793217320;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=LeXyVHEKEyw7vDbL06vctJBTx2JflpziXQdvxL5GTu8=;
	b=mTXJMDpPN8XuG7T+ZSKlMxx2NKx2XbtnzKiKS2hchid+rsfwAAiQyzFRz4RNPdog47ta
	 9yL3tE6cbMShgnTWVOMb9WxIeuwW7MDr92ble38Zc9Ey4L0UhAfUjhu9P5h5TxzANevW1
	 vDmqCVW5qoLOM/GmVjnIJDQ/J1OKxKdiN0f+TqjoaCOBoIoGBp7/M6eOX5BS+NGkTD9nJ
	 Zoge7e8dkjy5IiQFjwnHIY43bWaCAsFtr+9QfxYigPmX9UA+cw6Id1JpoG2FKcUQNmSFY
	 x7AbkPbNJ3OxLqbRpoTIu1FAkZ1wTOro85VJAAC6iHYz6P8Nv6NKpDijPqYWepXVCuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9B0xz3W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 237FB606A31A;
	Wed, 28 Oct 2026 19:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L9B0xz3W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 737F71F01825;
	Wed, 28 Oct 2026 19:55:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793217320;
	bh=LeXyVHEKEyw7vDbL06vctJBTx2JflpziXQdvxL5GTu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L9B0xz3Wdnij8jfw1wmMursxrvABy3nimRaDFY17iA8Q3hBJV71JMr9nwS65JaSHr
	 RXWyhUmkRX9W+BNbaqDe9Ocv2hpn+j0nG+QWXHqe4YOAj9F2oOSeF9orF7y5ChukMn
	 c14TEITz9HF8ScpSOIrPBF3S1UnydX8v/5JxJ9Zg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Lijo Lazar <lijo.lazar@amd.com>,
	Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1862/1887] drm/amdgpu: replace PASID IDR with XArray
Date: Wed, 28 Oct 2026 18:05:58 +0100
Message-ID: <20261028170541.824702593@linuxfoundation.org>
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

From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>

[ Upstream commit 3c863ff920b45fa7a9b7d4cb932f466488a87a58 ]

Replace the PASID IDR + spinlock with XArray as noted in the TODO
left by commit ea56aa262570 ("drm/amdgpu: fix the idr allocation
flags").

The IDR conversion still has an IRQ safety issue:
amdgpu_pasid_free() can be called from hardirq context via the fence
signal path, but amdgpu_pasid_idr_lock is taken with plain spin_lock()
in process context, creating a potential deadlock:

     CPU0
     ----
     spin_lock(&amdgpu_pasid_idr_lock)   // process context, IRQs on
     <Interrupt>
       spin_lock(&amdgpu_pasid_idr_lock) // deadlock

   The hardirq call chain is:

     sdma_v6_0_process_trap_irq
      -> amdgpu_fence_process
       -> dma_fence_signal
        -> drm_sched_job_done
         -> dma_fence_signal
          -> amdgpu_pasid_free_cb
           -> amdgpu_pasid_free

Use XArray with XA_FLAGS_LOCK_IRQ (all xa operations use IRQ-safe
locking internally) and XA_FLAGS_ALLOC1 (zero is not a valid PASID).
Both xa_alloc_cyclic() and xa_erase() then handle locking
consistently, fixing the IRQ safety issue and removing the need for
an explicit spinlock.

v8: squash in irq safe fix

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Lijo Lazar <lijo.lazar@amd.com>
Fixes: ea56aa262570 ("drm/amdgpu: fix the idr allocation flags")
Fixes: 8f1de51f49be ("drm/amdgpu: prevent immediate PASID reuse case")
Signed-off-by: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c | 39 ++++++++++++-------------
 1 file changed, 19 insertions(+), 20 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
index e526a2824d1ff..bef38e03d6bed 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c
@@ -22,7 +22,7 @@
  */
 #include "amdgpu_ids.h"
 
-#include <linux/idr.h>
+#include <linux/xarray.h>
 #include <linux/dma-fence-array.h>
 
 
@@ -40,8 +40,8 @@
  * VMs are looked up from the PASID per amdgpu_device.
  */
 
-static DEFINE_IDR(amdgpu_pasid_idr);
-static DEFINE_SPINLOCK(amdgpu_pasid_idr_lock);
+static DEFINE_XARRAY_FLAGS(amdgpu_pasid_xa, XA_FLAGS_LOCK_IRQ | XA_FLAGS_ALLOC1);
+static u32 amdgpu_pasid_xa_next;
 
 /* Helper to free pasid from a fence callback */
 struct amdgpu_pasid_cb {
@@ -62,36 +62,37 @@ struct amdgpu_pasid_cb {
  */
 int amdgpu_pasid_alloc(unsigned int bits)
 {
-	int pasid;
+	u32 pasid;
+	int r;
 
 	if (bits == 0)
 		return -EINVAL;
 
-	spin_lock(&amdgpu_pasid_idr_lock);
-	/* TODO: Need to replace the idr with an xarry, and then
-	 * handle the internal locking with ATOMIC safe paths.
-	 */
-	pasid = idr_alloc_cyclic(&amdgpu_pasid_idr, NULL, 1,
-				 1U << bits, GFP_ATOMIC);
-	spin_unlock(&amdgpu_pasid_idr_lock);
-
-	if (pasid >= 0)
-		trace_amdgpu_pasid_allocated(pasid);
+	r = xa_alloc_cyclic_irq(&amdgpu_pasid_xa, &pasid, xa_mk_value(0),
+			    XA_LIMIT(1, (1U << bits) - 1),
+			    &amdgpu_pasid_xa_next, GFP_KERNEL);
+	if (r < 0)
+		return r;
 
+	trace_amdgpu_pasid_allocated(pasid);
 	return pasid;
 }
 
 /**
  * amdgpu_pasid_free - Free a PASID
  * @pasid: PASID to free
+ *
+ * Called in IRQ context.
  */
 void amdgpu_pasid_free(u32 pasid)
 {
+	unsigned long flags;
+
 	trace_amdgpu_pasid_freed(pasid);
 
-	spin_lock(&amdgpu_pasid_idr_lock);
-	idr_remove(&amdgpu_pasid_idr, pasid);
-	spin_unlock(&amdgpu_pasid_idr_lock);
+	xa_lock_irqsave(&amdgpu_pasid_xa, flags);
+	__xa_erase(&amdgpu_pasid_xa, pasid);
+	xa_unlock_irqrestore(&amdgpu_pasid_xa, flags);
 }
 
 static void amdgpu_pasid_free_cb(struct dma_fence *fence,
@@ -599,7 +600,5 @@ void amdgpu_vmid_mgr_fini(struct amdgpu_device *adev)
  */
 void amdgpu_pasid_mgr_cleanup(void)
 {
-	spin_lock(&amdgpu_pasid_idr_lock);
-	idr_destroy(&amdgpu_pasid_idr);
-	spin_unlock(&amdgpu_pasid_idr_lock);
+	xa_destroy(&amdgpu_pasid_xa);
 }
-- 
2.53.0



