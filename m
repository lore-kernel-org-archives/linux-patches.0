Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028051;
	b=owmL6SgusxUjzGdE5s/dgaNiBDTZqJ9hxmR0o+M8fTO6v/YHxWZeFxtNpsBJ3+MoA0Pa
	 xReZeCkh0G32xlvb4J3w080fjSiFq5G9u8/TrhO/zBsWOHKFWMkQmLNq9ztY8cRY+5AIl
	 Jf0DAdctTOKeINBdjlHFNCjPPNwumbZhLPMX2ldTt57lRxsEaq35XiYm7b8ke+oqVxgK7
	 HLMC2r/FXcLrfGQ8iFHxdAdKuifOcKiI2PBmSk6SZdEyLRXvIFvWduXoubufqOqcmnLbA
	 XLLTf/VyZoVlAW9xEpHcNjfqwNkS9NLqgpmchwPOWyTQRlU/VEyRLj0FRyv/Yec+Eag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028051;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qobOtx8TW47bu+TvMhHKqD/OIFl7ZmzXk9Y+K8CBy14=;
	b=2HqMRrtXGmpgCWV9igp4xc95iKJ1n22QkqBYISXMxmzuIUqE2/3/523JgaiVrjLe1aPT
	 1m44zk8I1hz8WGOil9TB4ldasKMeq5yMmK3aS9DY0XCiwH+lKbSybqotRiVLU90oXJvgD
	 i1KjpoeojBAiQAZ3YYmBejIBw/lVd/X6Z1eMtlXC2f1J01NmK3TtGRJF6BOrrG+kQ1PpU
	 hPzGAm9r+bFRkldZW+jTlmsSKJzOYWbd3GCdXL71ovm7uNUnHRaVEf7gGFyNAEkuA3wUV
	 2sq4hURVHoGgMtRCehXhfVh1KdgbM43rVqxhnAFkhro6RI0Xr1gZacdsHhaD00co2JA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRIsN3mS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4A74606A31C;
	Wed, 18 Nov 2026 18:54:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XRIsN3mS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 422DA1F000C4;
	Wed, 18 Nov 2026 18:54:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028050;
	bh=qobOtx8TW47bu+TvMhHKqD/OIFl7ZmzXk9Y+K8CBy14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XRIsN3mS83h3izqTa62Km0E2yu9YCkokIyt50MZK/8GClWNsHQNw1BbEN8dHkiD7r
	 0EpnH2m/G0hQiHy1hM1jPT6GPRtCTJ4tyWRziyEVqGqRZyAQHhLOW1wx1oLBhyIhKR
	 FSDtE6F8cnEmnBcI6Jx8EeX5OuW4SPNnoBcSqvZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 2008/2151] net: microchip: fdma: use little-endian types for descriptor fields
Date: Wed, 18 Nov 2026 16:02:23 +0100
Message-ID: <20261118150234.873205431@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit 9786c387b299bda5277eed98284a6f6fa7331fb9 ]

The FDMA engine reads and writes the DCB and DB descriptors in
little-endian byte order. So far the descriptors have only been produced
by the little-endian SoC itself, so plain u64 fields were fine. With the
PCIe FDMA path, the descriptors live in host memory and are written by
the host CPU, which may be big-endian.

Change the descriptor fields to __le64 and convert at the library
boundary: in __fdma_db_add() and __fdma_dcb_add() on write, and in the
fdma_db_*() accessors on read. The dataptr and nextptr callbacks keep
their u64 signatures, so their implementations are unchanged. Add
fdma_db_dataptr_get(), and convert the lan966x sites that read the
descriptor fields directly to use the accessors.

No functional change on little-endian hosts.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260928-lan966x-pci-fdma-v9-4-a17caf60f89a@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 573a6d4c7a21 ("net: microchip: fdma: fix DCB corruption under sustained load")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/microchip/fdma/fdma_api.c    | 21 ++++++++++++++-----
 .../net/ethernet/microchip/fdma/fdma_api.h    | 20 +++++++++++-------
 .../ethernet/microchip/lan966x/lan966x_fdma.c |  9 ++++----
 3 files changed, 34 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/microchip/fdma/fdma_api.c b/drivers/net/ethernet/microchip/fdma/fdma_api.c
index e78c3590da9e6..6dfe36f58d67a 100644
--- a/drivers/net/ethernet/microchip/fdma/fdma_api.c
+++ b/drivers/net/ethernet/microchip/fdma/fdma_api.c
@@ -12,10 +12,18 @@ static int __fdma_db_add(struct fdma *fdma, int dcb_idx, int db_idx, u64 status,
 				   int db_idx, u64 *dataptr))
 {
 	struct fdma_db *db = fdma_db_get(fdma, dcb_idx, db_idx);
+	u64 dataptr;
+	int err;
 
-	db->status = status;
+	db->status = cpu_to_le64(status);
 
-	return cb(fdma, dcb_idx, db_idx, &db->dataptr);
+	err = cb(fdma, dcb_idx, db_idx, &dataptr);
+	if (unlikely(err))
+		return err;
+
+	db->dataptr = cpu_to_le64(dataptr);
+
+	return 0;
 }
 
 /* Add a DB to a DCB, using the callback set in the fdma_ops struct. */
@@ -35,6 +43,7 @@ int __fdma_dcb_add(struct fdma *fdma, int dcb_idx, u64 info, u64 status,
 				u64 *dataptr))
 {
 	struct fdma_dcb *dcb = fdma_dcb_get(fdma, dcb_idx);
+	u64 nextptr;
 	int i, err;
 
 	for (i = 0; i < fdma->n_dbs; i++) {
@@ -43,14 +52,16 @@ int __fdma_dcb_add(struct fdma *fdma, int dcb_idx, u64 info, u64 status,
 			return err;
 	}
 
-	err = dcb_cb(fdma, dcb_idx, &fdma->last_dcb->nextptr);
+	err = dcb_cb(fdma, dcb_idx, &nextptr);
 	if (unlikely(err))
 		return err;
 
+	fdma->last_dcb->nextptr = cpu_to_le64(nextptr);
+
 	fdma->last_dcb = dcb;
 
-	dcb->nextptr = FDMA_DCB_INVALID_DATA;
-	dcb->info = info;
+	dcb->nextptr = cpu_to_le64(FDMA_DCB_INVALID_DATA);
+	dcb->info = cpu_to_le64(info);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/microchip/fdma/fdma_api.h b/drivers/net/ethernet/microchip/fdma/fdma_api.h
index d91affe8bd988..a1bd7b8a75c16 100644
--- a/drivers/net/ethernet/microchip/fdma/fdma_api.h
+++ b/drivers/net/ethernet/microchip/fdma/fdma_api.h
@@ -64,13 +64,13 @@
 struct fdma;
 
 struct fdma_db {
-	u64 dataptr;
-	u64 status;
+	__le64 dataptr;
+	__le64 status;
 };
 
 struct fdma_dcb {
-	u64 nextptr;
-	u64 info;
+	__le64 nextptr;
+	__le64 info;
 	struct fdma_db db[FDMA_DB_MAX];
 };
 
@@ -140,19 +140,25 @@ static inline bool fdma_dcb_is_reusable(struct fdma *fdma)
 /* Check if the FDMA has marked this DB as done. */
 static inline bool fdma_db_is_done(struct fdma_db *db)
 {
-	return db->status & FDMA_DCB_STATUS_DONE;
+	return le64_to_cpu(db->status) & FDMA_DCB_STATUS_DONE;
 }
 
 /* Get the length of a DB. */
 static inline int fdma_db_len_get(struct fdma_db *db)
 {
-	return FDMA_DCB_STATUS_BLOCKL(db->status);
+	return FDMA_DCB_STATUS_BLOCKL(le64_to_cpu(db->status));
+}
+
+/* Get the dataptr of a DB. */
+static inline u64 fdma_db_dataptr_get(struct fdma_db *db)
+{
+	return le64_to_cpu(db->dataptr);
 }
 
 /* Set the length of a DB. */
 static inline void fdma_dcb_len_set(struct fdma_dcb *dcb, u32 len)
 {
-	dcb->info = FDMA_DCB_INFO_DATAL(len);
+	dcb->info = cpu_to_le64(FDMA_DCB_INFO_DATAL(len));
 }
 
 /* Get a DB by index. */
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
index 4e9f347a1387c..e6638cf4f805b 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_fdma.c
@@ -406,8 +406,9 @@ static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 		return FDMA_ERROR;
 
 	dma_sync_single_for_cpu(lan966x->dev,
-				(dma_addr_t)db->dataptr + XDP_PACKET_HEADROOM,
-				FDMA_DCB_STATUS_BLOCKL(db->status),
+				(dma_addr_t)fdma_db_dataptr_get(db) +
+				XDP_PACKET_HEADROOM,
+				fdma_db_len_get(db),
 				DMA_FROM_DEVICE);
 
 	lan966x_ifh_get_src_port(page_address(page) + XDP_PACKET_HEADROOM,
@@ -419,7 +420,7 @@ static int lan966x_fdma_rx_check_frame(struct lan966x_rx *rx, u64 *src_port)
 	if (!lan966x_xdp_port_present(port))
 		return FDMA_PASS;
 
-	return lan966x_xdp_run(port, page, FDMA_DCB_STATUS_BLOCKL(db->status));
+	return lan966x_xdp_run(port, page, fdma_db_len_get(db));
 }
 
 static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
@@ -443,7 +444,7 @@ static struct sk_buff *lan966x_fdma_rx_get_frame(struct lan966x_rx *rx,
 	skb_mark_for_recycle(skb);
 
 	skb_reserve(skb, XDP_PACKET_HEADROOM);
-	skb_put(skb, FDMA_DCB_STATUS_BLOCKL(db->status));
+	skb_put(skb, fdma_db_len_get(db));
 
 	lan966x_ifh_get_timestamp(skb->data, &timestamp);
 
-- 
2.53.0



