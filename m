Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215862;
	b=eEjfgSuyedw36Oc7WeclDLdJ9ldRK4fxijCRRGDDpdOEuI45KiHG6SxqMUUU7Y/py04C
	 T/uObgjSoZop3cM4n2yBA7W9RQXDbgyAzzBDzCpDr/ikMAJVl0D1JIXixvaMlGAJ3ETrt
	 jjHaJ72aAyL8YZ+bKAL0S4ZSjuYz3Xa2jD6//i3UKb4CSfCOc+riP8OI7bK2G0Z2siBPE
	 0mOW5yH+/BQ8xffzDJkUxOHZuea6sOeAas2Z8qQt6Cz03Fptskpbe7uSJA98GlrPGLTmG
	 PZI0++q3ax8//E9laCOEYgtjePeqytIfkV1xBdk1+TZUVkQj7N4a4IIpg9ycUrx4U5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215862;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0/ICduoDEjCf3M3Plc06LBP7iq/nKEx65QAZ07c3KTs=;
	b=EKTVAAc1u9GJ3EdkPe2YWvTQeRB44EjqGbpJ5pwD7A8zMx7fByk6ATt+LSeLj7ctznPa
	 5YpdnKmx/sz01jhezRlom4qMj59jlNbaz9xJWmUsSa3e7nKUE6RkHy1yD7fBhGri1Lza8
	 ekvyRnOpZQgxZbtqHw0nvoeYZI6uo8hT1WwFOd9yEhZaZKm+HyvbsVKDOH5DCKvbfcTmW
	 R8DR6UrJHRBP5VkQ3O/CDCZzygfhEk3ArCj21jD7u+4FLFJt8aXEuhOfxubs2gqNjI6Qa
	 /QhB7Dp1SRxdKrVjO7YlKF0bUEMl6gu3ag2tbZvd+NWKZYp6QGOx0KKwxMR7sJGAOcA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VNBDmQxe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F76606A31A;
	Wed, 28 Oct 2026 19:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VNBDmQxe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F42271F01825;
	Wed, 28 Oct 2026 19:31:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215861;
	bh=0/ICduoDEjCf3M3Plc06LBP7iq/nKEx65QAZ07c3KTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VNBDmQxe0B7HSUASRo/3Q6hIJUdRHsNQtaJafzLFFSsROglPKBJJOxc9HmUol7XZY
	 NnUVzy3pbfysVnIIC9tWhl6AT0CsLeJvkwvNVNR/Tj+XzHEGQHG4JvxJrkfstV4f1l
	 AgPzWYDZr2LdNzTprAn2MTkecql+knQiHDxDsbMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1321/1887] octeontx2-af: npc: Fix size of entry2cntr_map
Date: Wed, 28 Oct 2026 17:56:57 +0100
Message-ID: <20261028170529.489752203@linuxfoundation.org>
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

From: Ratheesh Kannoth <rkannoth@marvell.com>

[ Upstream commit f9cd6fabe0e7c7f6fc30c6c192c7ed72aba37232 ]

KASAN prints below splat. This is caused by allocating counter for
reserved mcam entry for cpt 2nd pass entry. But mcam->entry2cntr_map
is not allocated for reserved entries.

BUG: KASAN: slab-out-of-bounds in npc_map_mcam_entry_and_cntr+0xb0/0x1a0
Write of size 2 at addr ffff0001033e7ffe by task kworker/0:1/14

CPU: 0 PID: 14 Comm: kworker/0:1 Not tainted 6.1.67 #1
Hardware name: Marvell CN106XX board (DT)
Workqueue: events work_for_cpu_fn
Call trace:
 dump_backtrace.part.0+0xe4/0xf0
 show_stack+0x18/0x30
 dump_stack_lvl+0x88/0xb4
 print_report+0x154/0x458
 kasan_report+0xb8/0x194
 __asan_store2+0x7c/0xa0
 npc_map_mcam_entry_and_cntr+0xb0/0x1a0
 rvu_mbox_handler_npc_mcam_write_entry+0x268/0x280
 npc_install_flow+0x840/0xfe0
 rvu_npc_install_cpt_pass2_entry+0x138/0x190
 rvu_nix_init+0x148c/0x2880
 rvu_probe+0x1800/0x30b0
 local_pci_probe+0x78/0xe0
 work_for_cpu_fn+0x30/0x50
 process_one_work+0x4cc/0x97c
 worker_thread+0x360/0x630
 kthread+0x1a0/0x1b0
 ret_from_fork+0x10/0x20

Fixes: 55307fcb9258 ("octeontx2-af: Add mbox messages to install and delete MCAM rules")
Cc: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Link: https://patch.msgid.link/20260610022344.969774-1-rkannoth@marvell.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/marvell/octeontx2/af/rvu_npc.c   | 40 +++++++------------
 1 file changed, 15 insertions(+), 25 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
index ed1b66ea0aeff..c8146e3afb1b8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_npc.c
@@ -1934,7 +1934,7 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	/* Alloc memory for MCAM entry to counter mapping and for tracking
 	 * counter's reference count.
 	 */
-	mcam->entry2cntr_map = devm_kcalloc(rvu->dev, mcam->bmap_entries,
+	mcam->entry2cntr_map = devm_kcalloc(rvu->dev, mcam->total_entries,
 					    sizeof(u16), GFP_KERNEL);
 	if (!mcam->entry2cntr_map)
 		goto free_mem;
@@ -1950,10 +1950,11 @@ static int npc_mcam_rsrcs_init(struct rvu *rvu, int blkaddr)
 	if (!mcam->entry2target_pffunc)
 		goto free_mem;
 
-	for (index = 0; index < mcam->bmap_entries; index++) {
+	for (index = 0; index < mcam->bmap_entries; index++)
 		mcam->entry2pfvf_map[index] = NPC_MCAM_INVALID_MAP;
+
+	for (index = 0; index < mcam->total_entries; index++)
 		mcam->entry2cntr_map[index] = NPC_MCAM_INVALID_MAP;
-	}
 
 	for (cntr = 0; cntr < mcam->counters.max; cntr++)
 		mcam->cntr2pfvf_map[cntr] = NPC_MCAM_INVALID_MAP;
@@ -3040,7 +3041,7 @@ int rvu_mbox_handler_npc_mcam_free_counter(struct rvu *rvu,
 		struct npc_mcam_oper_counter_req *req, struct msg_rsp *rsp)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u16 index, entry = 0;
+	u16 index;
 	int blkaddr, err;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -3058,20 +3059,16 @@ int rvu_mbox_handler_npc_mcam_free_counter(struct rvu *rvu,
 	mcam->cntr2pfvf_map[req->cntr] = NPC_MCAM_INVALID_MAP;
 	rvu_free_rsrc(&mcam->counters, req->cntr);
 
-	/* Disable all MCAM entry's stats which are using this counter */
-	while (entry < mcam->bmap_entries) {
+	/* Disable all MCAM entry's stats which are using this counter.
+	 * Scan the full MCAM index range: AF-reserved rules (e.g. CPT pass-2)
+	 */
+	for (index = 0; index < mcam->total_entries; index++) {
 		if (!mcam->cntr_refcnt[req->cntr])
 			break;
-
-		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
-		if (index >= mcam->bmap_entries)
-			break;
-		entry = index + 1;
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
-
-		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
-					      index, req->cntr);
+		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr, index,
+					      req->cntr);
 	}
 
 	mutex_unlock(&mcam->lock);
@@ -3082,7 +3079,7 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
 		struct npc_mcam_unmap_counter_req *req, struct msg_rsp *rsp)
 {
 	struct npc_mcam *mcam = &rvu->hw->mcam;
-	u16 index, entry = 0;
+	u16 index;
 	int blkaddr, rc;
 
 	blkaddr = rvu_get_blkaddr(rvu, BLKTYPE_NPC, 0);
@@ -3105,20 +3102,13 @@ int rvu_mbox_handler_npc_mcam_unmap_counter(struct rvu *rvu,
 	}
 
 	/* Disable all MCAM entry's stats which are using this counter */
-	while (entry < mcam->bmap_entries) {
+	for (index = 0; index < mcam->total_entries; index++) {
 		if (!mcam->cntr_refcnt[req->cntr])
 			break;
-
-		index = find_next_bit(mcam->bmap, mcam->bmap_entries, entry);
-		if (index >= mcam->bmap_entries)
-			break;
-		entry = index + 1;
-
 		if (mcam->entry2cntr_map[index] != req->cntr)
 			continue;
-
-		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr,
-					      index, req->cntr);
+		npc_unmap_mcam_entry_and_cntr(rvu, mcam, blkaddr, index,
+					      req->cntr);
 	}
 exit:
 	mutex_unlock(&mcam->lock);
-- 
2.53.0



