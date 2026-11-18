Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039233;
	b=cPHaV0DdnMwZ4NCZdav8CkMJHe1J8Ke9fUn+ad/vZhOhFe6nbL3LAiZajnqAo0FsXjN0
	 0oLv77k57TYgjt3vF3G1PMamGH6TJU3aokNFFOnmGxGTTcRpgY7go10SnEidHhaTcr7Am
	 pgDzGn1qxOccWjqB5Eg93OpjcA2+Wi/Hc/EWExmuMa4z3h7SsFW5Q05ozjZI/FRF6Tvnh
	 B26izW0GPDhGP+Zk7C7cXIdHOMzp5G/AlTWO3ISyrFKEEEcMtdGeKD3XTXxOyf6uSVWe7
	 ZW0PsVufw01Ewu1fJJ0OMP4nSlgw55fY70y8IUmDuG+hx5SqI6zI9+mfCAJ6eQB8uAg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039233;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xDtDONmtPN6CmXnd0C50ZavEys2Kt4fClxodT5641j0=;
	b=2r+EggPnL7koAmlfSBjaxtjZWfyYS7X9YztxNdYczGAdLaUKcw1BYC8Rk8nKr7GqPrku
	 fJw6r6Pe2YIq0DFB4ddGnQpctKUYnTknLE55Vtnd4Gu61CN5XBPyBrE8+hKCWEFu7DCvm
	 tpb2+9YM8wAkb612r7tyds7fUvDGFdRgVLOKk848bUM3fdAtGV04NWBsewW5aeDf4Y8IW
	 n66Iazc6YZKprsvksTMx7BJ+43OpGGiKCSNC/h/jIZLGiJDd79yxrvgtVgQf0PKv/oLLj
	 UUwpsYOL9XEyr5oifTmUu/3Q5PFU/tfzuXg5AXtUwibF6QjcOs/vvDRKl/cSVHklZnQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWStKGWx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD966606A325;
	Wed, 18 Nov 2026 22:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mWStKGWx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC081F000C4;
	Wed, 18 Nov 2026 22:00:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039233;
	bh=xDtDONmtPN6CmXnd0C50ZavEys2Kt4fClxodT5641j0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mWStKGWxJKRXJqgKzEjfMatGIKG+ifoDxZWBxl8jQ1lZFVAWJR/MH8PtQBO1oS6p5
	 nzFVQizVDde4IVp2ZuMOQ7NljFXe0UCrECaiApL7A93o21v+imbp/hNDRVUcK9D4pT
	 /0ZAQ7LfMzErgqgJUo6a1h/XE7xkyk6s2wKZrDa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Straube <straube.linux@gmail.com>,
	Hans de Goede <hansg@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2027/3318] staging: rtl8723bs: move rtw_recv_indicatepkt to rtw_recv.c
Date: Wed, 18 Nov 2026 15:44:09 +0100
Message-ID: <20261118150422.850478619@linuxfoundation.org>
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
index e2f4417dab5ba..7330a9c2447a3 100644
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
index b2baba97c06fe..e00b06f0b6e04 100644
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



