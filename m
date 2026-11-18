Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016828;
	b=hOatUNGPYInwdK7mrrH/Mt9ztlVva1WyghOI3+XRhcGQXUGnM1fdLlSUJBnPBThJDYVk
	 ckYAy87I4zGYu2oaDwbiUrzhs1/sQRGdzcgiGnXmj2MzzwmE9F7HzWQ6Js6dZ5YtVTBKC
	 TGfl+127UOf9t10pjahlFLAXPMKRXTXcAbcBvki7HVIh537Ybh1Kyt4TB7493cr8Bzt3G
	 j2N3EKZMDS9LU77C+MUhV+KP4cGGbF0viR8CuhFJwSEKpPZxnHy29cMwY/i2V1HZRgoQc
	 f9dLyuAuCFmFHkpAUUaAP9hHdHzHgKNf3weMYsaspy5ha5xSSMLtUsy0KmdtWJJ1I9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016828;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ybAu67Zw7tLzveTzuHqIqpwGkQaK0c9ZFymSIWeIVw8=;
	b=CBKWK4Gd1wpifRopkoJIOip+OYdDrKbbGtFjv7F7u3qOezsjgCiPPrjvjvS10E0VgpbR
	 qjnImyJiXZYG5Zy8DKJj0LgkzZ3lBbo4lSbmfQAmwwerlxkfXuMZ75vhTtp3Y+TodGaHZ
	 Z3bpY+N4S+xm4fs8z4bVZaLc1HQxfCoEuDh6o8lhQZIJma8rQEmLsr6rKhQyGoeoj8bcX
	 LFgyEQbbnka8HHUP+WBCI3Nx5C8SXbVD9fwpX/9mKQyVwW7u3El5QVKKd0BuUJB7aF5SA
	 /FZ4CN+rc9JJRASJLzATVOhojGdC1+56hdPvQmuMmmSAgwtCuX/nO5vsqeg65ghvEGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HaXOdKcX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1AC8606A31C;
	Wed, 18 Nov 2026 15:47:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HaXOdKcX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03CB21F000C4;
	Wed, 18 Nov 2026 15:47:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016828;
	bh=ybAu67Zw7tLzveTzuHqIqpwGkQaK0c9ZFymSIWeIVw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HaXOdKcXtEafe0Cv4t8dWvJBe9vj3tQ9AssXyjFd5jSpVn6RAIuhmXQMeDrE6dqET
	 B2wxzFnBAUwecYknoUqL90NSgozlfPFhNckQ4wxDPLF6oX+MMGtuBFJtCYWdzvSsgM
	 cgLF51hcXfBV2zm+Hsw0C5SGOV6y9lxex4nMs/Yw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Bongio <jbongio@google.com>,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0667/2651] RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
Date: Wed, 18 Nov 2026 15:31:47 +0100
Message-ID: <20261118150311.887268107@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Bongio <jbongio@google.com>

[ Upstream commit 9c40f13a63a4b87177de3e8c318af25068fc6ab4 ]

During VM live migration or when registering large memory regions
(e.g., guest memory >= 256 GB backed by 4 KiB pages), get_lvl2_pble()
calculates total leaves exceeding ~131,072. The memory required for
lvl2->leafmem.va exceeds 4 MiB (sizeof(*leaf) * total > 5.24 MiB).

Because kzalloc() requires physically contiguous pages, requests larger
than MAX_PAGE_ORDER (4 MiB on x86_64) fail and trigger a warning:

  WARNING: CPU: 123 PID: 119906 at mm/page_alloc.c:5997 __alloc_frozen_pages_noprof+0x50c/0x1050
  Call Trace:
   <TASK>
   alloc_frozen_pages_noprof+0xc0/0x240
   ___kmalloc_large_node+0x3d/0xd0
   __kmalloc_large_node_noprof+0x1b/0x90
   __kmalloc_noprof+0x254/0x660
   get_lvl1_lvl2_pble+0xbc/0x270 [irdma]
   irdma_get_pble+0x44/0xc0 [irdma]
   irdma_setup_pbles+0x46/0x1d0 [irdma]
   irdma_reg_user_mr_type_mem+0x41/0x230 [irdma]
   irdma_reg_user_mr+0x194/0x1c0 [irdma]
   ib_uverbs_reg_mr+0x1b0/0x2c0 [ib_uverbs]

The leafmem array is purely host software tracking structures (struct
irdma_pble_info) and does not require physically contiguous memory.

Switch the allocation from kzalloc() to kvzalloc() and free it with
kvfree() so that requests exceeding MAX_PAGE_ORDER fall back to
virtually contiguous memory via vmalloc.

Fixes: e8c4dbc2fcac ("RDMA/irdma: Add PBLE resource manager")
Assisted-by: LLM
Signed-off-by: Jeremy Bongio <jbongio@google.com>
Link: https://patch.msgid.link/20260916173203.2555458-1-jbongio@google.com
Tested-by: Jacob Moroni <jmoroni@google.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/irdma/pble.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/irdma/pble.c b/drivers/infiniband/hw/irdma/pble.c
index 14318af97d581..0c2c5e96a05a4 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -330,7 +330,7 @@ static void free_lvl2(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	if (root->addr)
 		irdma_prm_return_pbles(&pble_rsrc->pinfo, &root->chunkinfo);
 
-	kfree(lvl2->leafmem.va);
+	kvfree(lvl2->leafmem.va);
 	lvl2->leaf = NULL;
 }
 
@@ -358,7 +358,7 @@ static int get_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	lvl2->leaf_cnt = total;
 
 	lvl2->leafmem.size = (sizeof(*leaf) * total);
-	lvl2->leafmem.va = kzalloc(lvl2->leafmem.size, GFP_KERNEL);
+	lvl2->leafmem.va = kvzalloc(lvl2->leafmem.size, GFP_KERNEL);
 	if (!lvl2->leafmem.va)
 		return -ENOMEM;
 
@@ -367,7 +367,7 @@ static int get_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	ret_code = irdma_prm_get_pbles(&pble_rsrc->pinfo, &root->chunkinfo,
 				       total << 3, &root->addr, &fpm_addr);
 	if (ret_code) {
-		kfree(lvl2->leafmem.va);
+		kvfree(lvl2->leafmem.va);
 		lvl2->leaf = NULL;
 		return -ENOMEM;
 	}
-- 
2.53.0



