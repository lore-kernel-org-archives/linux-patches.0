Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039981;
	b=nz8xZDCWhohukswlfwFxjG03fqQOLNzbjSQZnF7SVRPLyBBpGpT2zmlnR6mKg8qOHnxK
	 uu0O3RBU3AZL1IalSMacnYDW3aVlg921ZjhaaVhlePfRlC+KV+GkEHLowG3H+e+2hj/kT
	 aVhcWxv80/kzClpQqsBh+oFlp5xIRgrwoSs2I6U8bgZmJE8MZhsY8ZD5EBABbtApJM8cw
	 RhvyWRqHMi+Rt7eHl8VLFzUPdh+mPPbUd4l2a7Uc2AuN9Qg3dROeyd46sKh1LTm0+SLs5
	 2zNYZmN7exn4yHsUrYEOHt753kNZEZ061hX7wJq30fjF/djilHF3H3YowFOXPieHw1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039981;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GRKnp6pCS/xGLQyBq44yjZi2z3pVyCSXksVLtA2jaEQ=;
	b=E9eoyb8wO02FOyA7TO7VYRI97BWPLT+3PDrPrJ+52K6dxHkwq/bBEy4wkWxyFOnubYLz
	 ZeVrsf38F+p5Ku1J7uV5RR8Wn8mi4n9T3K2a9SEqkQa9roAG//yNf8RAIHZIkqLgnSXog
	 A2Nr1kPRW8j7KeXgyKbIWwbtRykJk71upXQhde7f010JbJtXzFLclsfjZBuLa4vreGSG1
	 XJV068N82GBxTAs6FHjeIMCDPaF2xwCMSI/O8Y/3f/KAhcUWArd8fPgwJAKW1xjPX0o5X
	 hpsfQAexNNnQBzMtlqpiaTiMQnzsEy1oH8VpbSbuwswtZIENEN1deNphElj2rKUNkpw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWwsEYKY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A11D606A31C;
	Wed, 18 Nov 2026 22:13:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pWwsEYKY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBB301F000C4;
	Wed, 18 Nov 2026 22:13:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039981;
	bh=GRKnp6pCS/xGLQyBq44yjZi2z3pVyCSXksVLtA2jaEQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pWwsEYKYjDU3dz52H5rUnJKf4Jh1cram0BKmOTy86LJZwzGaDAbA1WEH6q7nJALDC
	 8ZKjalbfhMyAsUOuznhnJUCRg9fvtP0ieqLCaQKE10/j49E6gJhPLkXqekkEOQ5x05
	 SfTjTv1mBLmbKpvqW73p8TWx3JJkIpalvg7WV+Tg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Bongio <jbongio@google.com>,
	Jacob Moroni <jmoroni@google.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2294/3318] RDMA/irdma: Use kvzalloc for lvl2 leafmem allocation
Date: Wed, 18 Nov 2026 15:48:36 +0100
Message-ID: <20261118150430.554339413@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 6fb3424b45331..3e06cbeca8a77 100644
--- a/drivers/infiniband/hw/irdma/pble.c
+++ b/drivers/infiniband/hw/irdma/pble.c
@@ -322,7 +322,7 @@ static void free_lvl2(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	if (root->addr)
 		irdma_prm_return_pbles(&pble_rsrc->pinfo, &root->chunkinfo);
 
-	kfree(lvl2->leafmem.va);
+	kvfree(lvl2->leafmem.va);
 	lvl2->leaf = NULL;
 }
 
@@ -350,7 +350,7 @@ static int get_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
 	lvl2->leaf_cnt = total;
 
 	lvl2->leafmem.size = (sizeof(*leaf) * total);
-	lvl2->leafmem.va = kzalloc(lvl2->leafmem.size, GFP_KERNEL);
+	lvl2->leafmem.va = kvzalloc(lvl2->leafmem.size, GFP_KERNEL);
 	if (!lvl2->leafmem.va)
 		return -ENOMEM;
 
@@ -359,7 +359,7 @@ static int get_lvl2_pble(struct irdma_hmc_pble_rsrc *pble_rsrc,
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



