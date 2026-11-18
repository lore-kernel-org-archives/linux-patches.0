Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035651;
	b=HTf61TAK8KKFU6ZNKFm70lV+Kj3jOTzW7FWddt0ireHrbttpov76cTJVF0o6jkdwkoR9
	 EaLGozxl9S/NpJPDz+FqHHXbJhqkS5svOIAIrFsUg6sYgzgAq9qBLnFFNBBgkGWiDOYDN
	 kU2akBP21veCNp2AJg5NT8Fp1elLYpNN+NrcAVZRV7xqksx5isqa/t3ElTabFbDMQxttD
	 5pOV+QPu8BhACTVM56B8LQf/mcRVXR7AXh+TZVYCS7FNVyPXMKaOXXC6zVUqFcZZHHL1N
	 gRO+Vn2bS9Yn4BwZF4Mke8uQoOk59gY3Ko5s6RxwWY2eLsMJaKPuv6NK3r6OzifSt8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035651;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IJMre7IR/i700Atgjw0ELAA3C5QyOgye5jsb5jWklt8=;
	b=lyJZ3tWXjlZEHqXhACRFJGwnxPOOpA/BsKG2Cmr7f/c5BOXsuuEtA9L7j1LomwQmrHTv
	 qruq42Q9heUI2mxIF79DGaswCJsYg9qepf4mEUZQFo8urH7AAlM0Tw0ieMwoz+Vd4WCYv
	 JdNXLCuCG0dmT8SSu0c5WwF2ijxhaexeIGddGtdC2+NHxXtzDrs29f16WvXXuyE9IVtrt
	 PwxzQ2sBBP0Jbm/A9xj04PZ2XhFW1UiMir8/2jaZRQ0ZARUZOW4Tcd50PKBiUy/LzpZc9
	 xY7BGegYL5ZzAxj1+jh3qQ2/7BkrXck0vra0KNBlCwKHO/H/S9zn0xBrBDlLmecbc/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPbPsE0i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F08B3606A31C;
	Wed, 18 Nov 2026 21:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPbPsE0i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DAA01F000C5;
	Wed, 18 Nov 2026 21:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035650;
	bh=IJMre7IR/i700Atgjw0ELAA3C5QyOgye5jsb5jWklt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPbPsE0iMpzsx+J49DcJ5cJ2JsEz9CzVmv05TuaNVfLGy7j6mWYcjeTf1SfNSGEP/
	 x+Ekhq0nd2LawHXYWBsZnFaYI1aJ7bMbTS1TGmxZYvVDzYygYEJLj7m+NJVboSzLJl
	 hKE9FUGHdRxK20FNm+uJQiG8pvCNPzwnYfxgrj8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Khasar Munkh-Erdene <02khasar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0778/3318] staging: rtl8723bs: fix spacing around operators in rtw_recv.c
Date: Wed, 18 Nov 2026 15:23:20 +0100
Message-ID: <20261118150342.148476405@linuxfoundation.org>
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

From: Khasar Munkh-Erdene <02khasar@gmail.com>

[ Upstream commit 393b267e6f04a11d4b18b7dc1423fa59f173f72b ]

Fix coding style issues by adding missing spaces around binary and
ternary operators, as reported by checkpatch.pl.

Signed-off-by: Khasar Munkh-Erdene <02khasar@gmail.com>
Link: https://patch.msgid.link/20260225032909.72799-1-02khasar@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: 495cb31c791b ("staging: rtl8723bs: fix protected RX frame validation in decrypt path")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_recv.c | 82 +++++++++++------------
 1 file changed, 41 insertions(+), 41 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_recv.c b/drivers/staging/rtl8723bs/core/rtw_recv.c
index 0eadc23a7d543..0697eeb9b3364 100644
--- a/drivers/staging/rtl8723bs/core/rtw_recv.c
+++ b/drivers/staging/rtl8723bs/core/rtw_recv.c
@@ -333,13 +333,13 @@ static signed int recvframe_chkmic(struct adapter *adapter,  union recv_frame *p
 				mickey = &stainfo->dot11tkiprxmickey.skey[0];
 			}
 
-			datalen = precvframe->u.hdr.len-prxattrib->hdrlen-prxattrib->iv_len-prxattrib->icv_len-8;/* icv_len included the mic code */
+			datalen = precvframe->u.hdr.len - prxattrib->hdrlen - prxattrib->iv_len - prxattrib->icv_len - 8;/* icv_len included the mic code */
 			pframe = precvframe->u.hdr.rx_data;
-			payload = pframe+prxattrib->hdrlen+prxattrib->iv_len;
+			payload = pframe + prxattrib->hdrlen + prxattrib->iv_len;
 
 			rtw_seccalctkipmic(mickey, pframe, payload, datalen, &miccode[0], (unsigned char)prxattrib->priority); /* care the length of the data */
 
-			pframemic = payload+datalen;
+			pframemic = payload + datalen;
 
 			bmic_err = false;
 
@@ -387,9 +387,9 @@ static union recv_frame *decryptor(struct adapter *padapter, union recv_frame *p
 	u32  res = _SUCCESS;
 
 	if (prxattrib->encrypt > 0) {
-		u8 *iv = precv_frame->u.hdr.rx_data+prxattrib->hdrlen;
+		u8 *iv = precv_frame->u.hdr.rx_data + prxattrib->hdrlen;
 
-		prxattrib->key_index = (((iv[3])>>6)&0x3);
+		prxattrib->key_index = (((iv[3]) >> 6) & 0x3);
 
 		if (prxattrib->key_index > WEP_KEYS) {
 			switch (prxattrib->encrypt) {
@@ -511,7 +511,7 @@ static signed int recv_decache(union recv_frame *precv_frame, u8 bretry, struct
 {
 	signed int tid = precv_frame->u.hdr.attrib.priority;
 
-	u16 seq_ctrl = ((precv_frame->u.hdr.attrib.seq_num&0xffff) << 4) |
+	u16 seq_ctrl = ((precv_frame->u.hdr.attrib.seq_num & 0xffff) << 4) |
 		(precv_frame->u.hdr.attrib.frag_num & 0xf);
 
 	if (tid > 15)
@@ -575,29 +575,29 @@ static void process_wmmps_data(struct adapter *padapter, union recv_frame *precv
 	if (!psta->qos_option)
 		return;
 
-	if (!(psta->qos_info&0xf))
+	if (!(psta->qos_info & 0xf))
 		return;
 
-	if (psta->state&WIFI_SLEEP_STATE) {
+	if (psta->state & WIFI_SLEEP_STATE) {
 		u8 wmmps_ac = 0;
 
 		switch (pattrib->priority) {
 		case 1:
 		case 2:
-			wmmps_ac = psta->uapsd_bk&BIT(1);
+			wmmps_ac = psta->uapsd_bk & BIT(1);
 			break;
 		case 4:
 		case 5:
-			wmmps_ac = psta->uapsd_vi&BIT(1);
+			wmmps_ac = psta->uapsd_vi & BIT(1);
 			break;
 		case 6:
 		case 7:
-			wmmps_ac = psta->uapsd_vo&BIT(1);
+			wmmps_ac = psta->uapsd_vo & BIT(1);
 			break;
 		case 0:
 		case 3:
 		default:
-			wmmps_ac = psta->uapsd_be&BIT(1);
+			wmmps_ac = psta->uapsd_be & BIT(1);
 			break;
 		}
 
@@ -922,20 +922,20 @@ static signed int validate_recv_ctrl_frame(struct adapter *padapter, union recv_
 		switch (pattrib->priority) {
 		case 1:
 		case 2:
-			wmmps_ac = psta->uapsd_bk&BIT(0);
+			wmmps_ac = psta->uapsd_bk & BIT(0);
 			break;
 		case 4:
 		case 5:
-			wmmps_ac = psta->uapsd_vi&BIT(0);
+			wmmps_ac = psta->uapsd_vi & BIT(0);
 			break;
 		case 6:
 		case 7:
-			wmmps_ac = psta->uapsd_vo&BIT(0);
+			wmmps_ac = psta->uapsd_vo & BIT(0);
 			break;
 		case 0:
 		case 3:
 		default:
-			wmmps_ac = psta->uapsd_be&BIT(0);
+			wmmps_ac = psta->uapsd_be & BIT(0);
 			break;
 		}
 
@@ -947,7 +947,7 @@ static signed int validate_recv_ctrl_frame(struct adapter *padapter, union recv_
 			psta->state ^= WIFI_STA_ALIVE_CHK_STATE;
 		}
 
-		if ((psta->state&WIFI_SLEEP_STATE) && (pstapriv->sta_dz_bitmap&BIT(psta->aid))) {
+		if ((psta->state & WIFI_SLEEP_STATE) && (pstapriv->sta_dz_bitmap & BIT(psta->aid))) {
 			struct list_head	*xmitframe_plist, *xmitframe_phead;
 			struct xmit_frame *pxmitframe = NULL;
 			struct xmit_priv *pxmitpriv = &padapter->xmitpriv;
@@ -991,7 +991,7 @@ static signed int validate_recv_ctrl_frame(struct adapter *padapter, union recv_
 				/* spin_unlock_bh(&psta->sleep_q.lock); */
 				spin_unlock_bh(&pxmitpriv->lock);
 
-				if (pstapriv->tim_bitmap&BIT(psta->aid)) {
+				if (pstapriv->tim_bitmap & BIT(psta->aid)) {
 					if (psta->sleepq_len == 0) {
 						/* issue nulldata with More data bit = 0 to indicate we have no buffered packets */
 						issue_nulldata_in_interrupt(padapter, psta->hwaddr);
@@ -1373,9 +1373,9 @@ static signed int validate_80211w_mgmt(struct adapter *adapter, union recv_frame
 				goto validate_80211w_fail;
 			precv_frame = decryptor(adapter, precv_frame);
 			/* save actual management data frame body */
-			memcpy(mgmt_DATA, ptr+pattrib->hdrlen+pattrib->iv_len, data_len);
+			memcpy(mgmt_DATA, ptr + pattrib->hdrlen + pattrib->iv_len, data_len);
 			/* overwrite the iv field */
-			memcpy(ptr+pattrib->hdrlen, mgmt_DATA, data_len);
+			memcpy(ptr + pattrib->hdrlen, mgmt_DATA, data_len);
 			/* remove the iv and icv length */
 			pattrib->pkt_len = pattrib->pkt_len - pattrib->iv_len - pattrib->icv_len;
 			kfree(mgmt_DATA);
@@ -1431,7 +1431,7 @@ static signed int validate_recv_frame(struct adapter *adapter, union recv_frame
 	struct rx_pkt_attrib *pattrib = &precv_frame->u.hdr.attrib;
 
 	u8 *ptr = precv_frame->u.hdr.rx_data;
-	u8  ver = (unsigned char) (*ptr)&0x3;
+	u8  ver = (unsigned char) (*ptr) & 0x3;
 
 	/* add version chk */
 	if (ver != 0) {
@@ -1469,7 +1469,7 @@ static signed int validate_recv_frame(struct adapter *adapter, union recv_frame
 		retval = _FAIL; /*  only data frame return _SUCCESS */
 		break;
 	case WIFI_DATA_TYPE: /* data */
-		pattrib->qos = (subtype & BIT(7)) ? 1:0;
+		pattrib->qos = (subtype & BIT(7)) ? 1 : 0;
 		retval = validate_recv_data_frame(adapter, precv_frame);
 		if (retval == _FAIL) {
 			struct recv_priv *precvpriv = &adapter->recvpriv;
@@ -1514,8 +1514,8 @@ static signed int wlanhdr_to_ethhdr(union recv_frame *precvframe)
 	if (pattrib->encrypt)
 		recvframe_pull_tail(precvframe, pattrib->icv_len);
 
-	psnap = (struct ieee80211_snap_hdr	*)(ptr+pattrib->hdrlen + pattrib->iv_len);
-	psnap_type = ptr+pattrib->hdrlen + pattrib->iv_len+SNAP_SIZE;
+	psnap = (struct ieee80211_snap_hdr	*)(ptr + pattrib->hdrlen + pattrib->iv_len);
+	psnap_type = ptr + pattrib->hdrlen + pattrib->iv_len + SNAP_SIZE;
 	/* convert hdr + possible LLC headers into Ethernet header */
 	/* eth_type = (psnap_type[0] << 8) | psnap_type[1]; */
 	if ((!memcmp(psnap, rfc1042_header, SNAP_SIZE) &&
@@ -1529,37 +1529,37 @@ static signed int wlanhdr_to_ethhdr(union recv_frame *precvframe)
 		/* Leave Ethernet header part of hdr and full payload */
 		bsnaphdr = false;
 
-	rmv_len = pattrib->hdrlen + pattrib->iv_len + (bsnaphdr?SNAP_SIZE:0);
+	rmv_len = pattrib->hdrlen + pattrib->iv_len + (bsnaphdr ? SNAP_SIZE : 0);
 	len = precvframe->u.hdr.len - rmv_len;
 
-	memcpy(&be_tmp, ptr+rmv_len, 2);
+	memcpy(&be_tmp, ptr + rmv_len, 2);
 	eth_type = ntohs(be_tmp); /* pattrib->ether_type */
 	pattrib->eth_type = eth_type;
 
 	if ((check_fwstate(pmlmepriv, WIFI_MP_STATE) == true)) {
 		ptr += rmv_len;
 		*ptr = 0x87;
-		*(ptr+1) = 0x12;
+		*(ptr + 1) = 0x12;
 
 		eth_type = 0x8712;
 		/*  append rx status for mp test packets */
-		ptr = recvframe_pull(precvframe, (rmv_len-sizeof(struct ethhdr)+2)-24);
+		ptr = recvframe_pull(precvframe, (rmv_len - sizeof(struct ethhdr) + 2) - 24);
 		if (!ptr)
 			return _FAIL;
 		memcpy(ptr, get_rxmem(precvframe), 24);
 		ptr += 24;
 	} else {
-		ptr = recvframe_pull(precvframe, (rmv_len-sizeof(struct ethhdr) + (bsnaphdr?2:0)));
+		ptr = recvframe_pull(precvframe, (rmv_len - sizeof(struct ethhdr) + (bsnaphdr ? 2 : 0)));
 		if (!ptr)
 			return _FAIL;
 	}
 
 	memcpy(ptr, pattrib->dst, ETH_ALEN);
-	memcpy(ptr+ETH_ALEN, pattrib->src, ETH_ALEN);
+	memcpy(ptr + ETH_ALEN, pattrib->src, ETH_ALEN);
 
 	if (!bsnaphdr) {
 		be_tmp = htons(len);
-		memcpy(ptr+12, &be_tmp, 2);
+		memcpy(ptr + 12, &be_tmp, 2);
 	}
 
 	return _SUCCESS;
@@ -1610,7 +1610,7 @@ static int amsdu_to_msdu(struct adapter *padapter, union recv_frame *prframe)
 		pdata += nSubframe_Length;
 		a_len -= nSubframe_Length;
 		if (a_len != 0) {
-			padding_len = 4 - ((nSubframe_Length + ETH_HLEN) & (4-1));
+			padding_len = 4 - ((nSubframe_Length + ETH_HLEN) & (4 - 1));
 			if (padding_len == 4)
 				padding_len = 0;
 
@@ -1842,7 +1842,7 @@ static int recv_indicatepkt_reorder(struct adapter *padapter, union recv_frame *
 
 			rtw_recv_indicatepkt(padapter, prframe);
 
-			preorder_ctrl->indicate_seq = (preorder_ctrl->indicate_seq + 1)%4096;
+			preorder_ctrl->indicate_seq = (preorder_ctrl->indicate_seq + 1) % 4096;
 
 			return _SUCCESS;
 		}
@@ -1852,7 +1852,7 @@ static int recv_indicatepkt_reorder(struct adapter *padapter, union recv_frame *
 
 			retval = amsdu_to_msdu(padapter, prframe);
 
-			preorder_ctrl->indicate_seq = (preorder_ctrl->indicate_seq + 1)%4096;
+			preorder_ctrl->indicate_seq = (preorder_ctrl->indicate_seq + 1) % 4096;
 
 			if (retval != _SUCCESS) {
 			}
@@ -2047,7 +2047,7 @@ static int recv_func(struct adapter *padapter, union recv_frame *rframe)
 			!psecuritypriv->busetkipkey) {
 			rtw_enqueue_recvframe(rframe, &padapter->recvpriv.uc_swdec_pending_queue);
 
-			if (recvpriv->free_recvframe_cnt < NR_RECVFRAME/4) {
+			if (recvpriv->free_recvframe_cnt < NR_RECVFRAME / 4) {
 				/* to prevent from recvframe starvation, get recvframe from uc_swdec_pending_queue to free_recvframe_cnt  */
 				rframe = rtw_alloc_recvframe(&padapter->recvpriv.uc_swdec_pending_queue);
 				if (rframe)
@@ -2136,19 +2136,19 @@ static void rtw_signal_stat_timer_hdl(struct timer_list *t)
 		}
 
 		/* update value of signal_strength, rssi, signal_qual */
-		tmp_s = (avg_signal_strength+(_alpha-1)*recvpriv->signal_strength);
+		tmp_s = (avg_signal_strength + (_alpha - 1) * recvpriv->signal_strength);
 		if (tmp_s % _alpha)
-			tmp_s = tmp_s/_alpha + 1;
+			tmp_s = tmp_s / _alpha + 1;
 		else
-			tmp_s = tmp_s/_alpha;
+			tmp_s = tmp_s / _alpha;
 		if (tmp_s > 100)
 			tmp_s = 100;
 
-		tmp_q = (avg_signal_qual+(_alpha-1)*recvpriv->signal_qual);
+		tmp_q = (avg_signal_qual + (_alpha - 1) * recvpriv->signal_qual);
 		if (tmp_q % _alpha)
-			tmp_q = tmp_q/_alpha + 1;
+			tmp_q = tmp_q / _alpha + 1;
 		else
-			tmp_q = tmp_q/_alpha;
+			tmp_q = tmp_q / _alpha;
 		if (tmp_q > 100)
 			tmp_q = 100;
 
-- 
2.53.0



