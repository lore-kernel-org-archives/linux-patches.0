Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047806;
	b=VxEIVjFZI1rYuCAC3jfa4sQS3ogZZQq5h5RVtp02HVbd2TTT9BHLy9FqfV0acQ/YvVJx
	 blKFAzZSpVhe1RoNGCTKh+0zCQkakaOUTg3YuRQKnGt9DPrJBc4g7WbxdcYuYPmeqxb6W
	 RmCDcnNO+hyo+2HebqbjJOMQiYMvLUYSXZG9KfAg/TqHUCcsLyyGuKHLo62FVxLeUXHB6
	 xv0RHcil+TaVIMDLC4qNX4PhqckE363hUw2HdUgTy3KAG62CeZjKmYx+t6Kv64BJQAIsA
	 NR2IaIvNj39MsAbERUsXz2gyGOVSyVbqOF3joRC9ZW+MZ7E7et6AWWlqnMUqGC0wFgA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8F4kNzUftnkPrhtmDmapq90LEjXqcq62BTt2u7g7+SA=;
	b=HIRWNWSHBnquihSyUbp68MUm1v78CBsiAxTMgRFXzOfjtFRWvrtVBoej5Uik6Z0KcAax
	 627bwz1O/kK40YcttZ96y+wJp2zHl8/pJVntf7BE1Wbw++8xOzUHKmJNHyPsIHDhMCJpp
	 cJ+GMOvIsg075hiNT7Uz4p1NEhOxWSQTglrgfrbd2O05WNRSBJurqNXL5nzBXEk135HBv
	 ev5njt0X4E25zyXD14eME/8WWlPOtCF2+zIe92MUXWZWzSq3FDp1hfQGGqvaMVXXWmiZt
	 ZgUJeC/ArhOgRcU5O6KD1hSOgyiGsPRCX7ZNjqPoTJP0kDktp7HD7h0mTg/+k8ezYsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="NQxNt/KE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A85E606A325;
	Thu, 19 Nov 2026 00:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NQxNt/KE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA9F1F000C4;
	Thu, 19 Nov 2026 00:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047806;
	bh=8F4kNzUftnkPrhtmDmapq90LEjXqcq62BTt2u7g7+SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NQxNt/KE8/HJFMIOuISncOEKGARzxYetDTCa4SCYvkOP7fIVJgkcgTiG6gf25vZ/g
	 Ja67WK7v0Fw0F8IX41kBE3/3JISaPR7kaGuL4rEl8rAEUJovxwCGAmQhhdN0qmfZ6d
	 fsjGVzc0Fdjsxl+R9bxv50wTcdOqoBa7jQARTKTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1768/2857] staging: rtl8723bs: move rtw_recv_indicatepkt to rtw_recv.c
Date: Wed, 18 Nov 2026 15:46:42 +0100
Message-ID: <20261118150304.942981011@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

From: Michael Straube <straube.linux@gmail.com>

[ Upstream commit f97151eb17dcdc8d7a27e05f2ec8c55bbb16c7a9 ]

Move the function rtw_recv_indicatepkt from os_dep/recv_linux.c to
core/rtw_recv.c to reduce code in the os_dep directory.

Signed-off-by: Michael Straube <straube.linux@gmail.com>
Reviewed-by: Hans de Goede <hansg@kernel.org>
Link: https://lore.kernel.org/r/20250822135418.118115-3-straube.linux@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: baa84b1bb164 ("staging: rtl8723bs: disable SDIO function on block size failure")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_recv.c     | 37 +++++++++++++++++++
 .../staging/rtl8723bs/include/recv_osdep.h    |  1 -
 drivers/staging/rtl8723bs/os_dep/recv_linux.c | 37 -------------------
 3 files changed, 37 insertions(+), 38 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_recv.c b/drivers/staging/rtl8723bs/core/rtw_recv.c
index 9004c3952a655..88612ed1cd5b4 100644
--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -1741,6 +1741,43 @@ static void recv_indicatepkts_pkt_loss_cnt(struct debug_priv *pdbgpriv, u64 prev
 
 }
 
+static int rtw_recv_indicatepkt(struct adapter *padapter, union recv_frame *precv_frame)
+{
+	struct recv_priv *precvpriv;
+	struct __queue	*pfree_recv_queue;
+	struct sk_buff *skb;
+	struct rx_pkt_attrib *pattrib = &precv_frame->u.hdr.attrib;
+
+	precvpriv = &(padapter->recvpriv);
+	pfree_recv_queue = &(precvpriv->free_recv_queue);
+
+	skb = precv_frame->u.hdr.pkt;
+	if (!skb)
+		goto _recv_indicatepkt_drop;
+
+	skb->data = precv_frame->u.hdr.rx_data;
+
+	skb_set_tail_pointer(skb, precv_frame->u.hdr.len);
+
+	skb->len = precv_frame->u.hdr.len;
+
+	rtw_os_recv_indicate_pkt(padapter, skb, pattrib);
+
+	/* pointers to NULL before rtw_free_recvframe() */
+	precv_frame->u.hdr.pkt = NULL;
+
+	rtw_free_recvframe(precv_frame, pfree_recv_queue);
+
+	return _SUCCESS;
+
+_recv_indicatepkt_drop:
+
+	/* enqueue back to free_recv_queue */
+	rtw_free_recvframe(precv_frame, pfree_recv_queue);
+
+	return _FAIL;
+}
+
 static int recv_indicatepkts_in_order(struct adapter *padapter, struct recv_reorder_ctrl *preorder_ctrl, int bforced)
 {
 	struct list_head	*phead, *plist;
diff --git a/drivers/staging/rtl8723bs/include/recv_osdep.h b/drivers/staging/rtl8723bs/include/recv_osdep.h
index ea0b58aa0ba05..f31c87b21206b 100644
--- a/drivers/staging/rtl8723bs/include/recv_osdep.h
+++ b/drivers/staging/rtl8723bs/include/recv_osdep.h
@@ -13,7 +13,6 @@ extern void _rtw_free_recv_priv(struct recv_priv *precvpriv);
 
 
 extern s32  rtw_recv_entry(union recv_frame *precv_frame);
-extern int rtw_recv_indicatepkt(struct adapter *adapter, union recv_frame *precv_frame);
 extern void rtw_recv_returnpacket(struct net_device *cnxt, struct sk_buff *preturnedpkt);
 
 extern void rtw_handle_tkip_mic_err(struct adapter *padapter, u8 bgroup);
diff --git a/drivers/staging/rtl8723bs/os_dep/recv_linux.c b/drivers/staging/rtl8723bs/os_dep/recv_linux.c
index ccabbb4a815b7..ca8f548ab15de 100644
--- a/drivers/staging/rtl8723bs/os_dep/recv_linux.c
+++ b/drivers/staging/rtl8723bs/os_dep/recv_linux.c
@@ -183,40 +183,3 @@ void rtw_handle_tkip_mic_err(struct adapter *padapter, u8 bgroup)
 	memset(&wrqu, 0x00, sizeof(wrqu));
 	wrqu.data.length = sizeof(ev);
 }
-
-int rtw_recv_indicatepkt(struct adapter *padapter, union recv_frame *precv_frame)
-{
-	struct recv_priv *precvpriv;
-	struct __queue	*pfree_recv_queue;
-	struct sk_buff *skb;
-	struct rx_pkt_attrib *pattrib = &precv_frame->u.hdr.attrib;
-
-	precvpriv = &(padapter->recvpriv);
-	pfree_recv_queue = &(precvpriv->free_recv_queue);
-
-	skb = precv_frame->u.hdr.pkt;
-	if (!skb)
-		goto _recv_indicatepkt_drop;
-
-	skb->data = precv_frame->u.hdr.rx_data;
-
-	skb_set_tail_pointer(skb, precv_frame->u.hdr.len);
-
-	skb->len = precv_frame->u.hdr.len;
-
-	rtw_os_recv_indicate_pkt(padapter, skb, pattrib);
-
-	/* pointers to NULL before rtw_free_recvframe() */
-	precv_frame->u.hdr.pkt = NULL;
-
-	rtw_free_recvframe(precv_frame, pfree_recv_queue);
-
-	return _SUCCESS;
-
-_recv_indicatepkt_drop:
-
-	/* enqueue back to free_recv_queue */
-	rtw_free_recvframe(precv_frame, pfree_recv_queue);
-
-	return _FAIL;
-}
-- 
2.53.0



