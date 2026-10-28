Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214618;
	b=U2R8eJCK+Y9U57SHFJsdrsQRuUEHU46ZjPsikjow+3EFy+FAVZqzo4sUL8DRwQ1yhLrt
	 lQg5r9kK/Yl+Q7FUOCQ34PUiQrkFkygqoHszr4qREtpDra9RfenR9QDqpWrG+1NYJibI7
	 NOxQZcgFjNh94UpeoAO1ji3fATG9U/JLfHsigC2YjQY5z5IyF1lQ7nL2NAgfHr0ibG+C1
	 ZdEJAK+YdWtaoSIYskO3Hd24uSrmOmMIp3wrp6JVfqaIah2sT33Je+UA6YdEGtVRhltN3
	 P0lZVieov87qVQr4c0K+/okBKiypXRCRSD4Rr5Xgzl3SKn75KOEruSSJk0GF25Ft91g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214618;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kHclo0oLN1wuUcZ7bgJ8akHwJy3/XpaVxlzgRr1EXUU=;
	b=nbDgg+tqByevkrpcS9qYdrX3IORxthsX7t13ZX3gVY1pDY7YCfeWpX8LrKKxlLM3dQlv
	 C93Zw2NrHBN+KYU0p3QbW1guuG+DcS0Jj3JjroRayt1JzSepVNJS4K1zoRHAfvC9JQ6td
	 gNWsDpE+1OnRIWR4p/9lszyvTpk76Vz76eauGyDRZTbQo4qHq8ka5OKsmpIrKSElCPhlG
	 hVYbl/kN3/cijmZkRzKPO3+Ed7fi1lsy+KANaUiOr5gs9QiWrJH6xFlEee7tqbNwTBz6w
	 mYVAcDrCEMbF0f+9Tz4aTcJPWxUy8E56KHzfNP47lRPbuaGb00fL/dOfMCFdqFtYzJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFur2f6U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69D61606A320;
	Wed, 28 Oct 2026 19:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GFur2f6U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB9CD1F01825;
	Wed, 28 Oct 2026 19:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214618;
	bh=kHclo0oLN1wuUcZ7bgJ8akHwJy3/XpaVxlzgRr1EXUU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GFur2f6U8DE+i/N6TRf7olCK4rdYP+4vE4jxASKIpAGO1cl3qoVRwmPpAHyC4l2HR
	 Zazhg3CKRjaBHZMzFghwO6RfYxHXor5/20Dk0qGs3MhgryRqFxowR49mGH+ZORPqLy
	 fRgsLadLSh+DTqscSuL0O0id6B6cE6naqLrpLRG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Nguyen <congnt264@gmail.com>,
	Dan Carpenter <error27@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0922/1887] staging: rtl8723bs: fix xmit_frame/xmit_buf leaks on mgnt-frame error paths
Date: Wed, 28 Oct 2026 17:50:18 +0100
Message-ID: <20261028170520.396930030@linuxfoundation.org>
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

From: Cong Nguyen <congnt264@gmail.com>

[ Upstream commit 41b8209376dffbd7b0b85c8bc4697d9166ac62ef ]

issue_beacon(), issue_probersp() and issue_asocrsp() obtain a management
xmit_frame together with its xmit_buf from the driver's fixed-size
management-TX pools via alloc_mgtxmitframe(). On the normal path the frame
is handed to dump_mgntframe(), which transfers ownership and eventually
returns both objects to their pools (the frame and, for beacons, the buf
in rtl8723bs_mgnt_xmit(); other bufs via the pending-xmitbuf/TX-completion
path).

Several error/edge paths return early after a successful
alloc_mgtxmitframe() but before dump_mgntframe(), so ownership is never
transferred and neither object is freed:

  - issue_beacon(): beacon larger than 512 bytes
  - issue_probersp(): cur_network->ie_length > MAX_IE_SZ
  - issue_probersp(): kzalloc() of the SSID scratch buffer fails
  - issue_asocrsp(): pkt_type is neither ASSOCRSP nor REASSOCRSP

Because alloc_mgtxmitframe() removes the frame and buf from their free
lists (list_del_init) without placing them on any pending list, an
orphaned pair is on no list and referenced by nobody, so it is only
reclaimed at driver teardown. Repeated hits progressively exhaust the
management-TX pools until alloc_mgtxmitframe() returns NULL and the
interface can no longer send beacons or probe/assoc responses.

Free the frame and buffer on these paths, matching the existing correct
error handling in issue_assocreq().

Fixes: 554c0a3abf21 ("staging: Add rtl8723bs sdio wifi driver")
Signed-off-by: Cong Nguyen <congnt264@gmail.com>
Reviewed-by: Dan Carpenter <error27@gmail.com>
Link: https://patch.msgid.link/20260715111710.295052-1-congnt264@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/rtl8723bs/core/rtw_mlme_ext.c | 22 ++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
index 78c9425cd5f44..32fd3cd0a5f77 100644
--- a/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
+++ b/drivers/staging/rtl8723bs/core/rtw_mlme_ext.c
@@ -2261,8 +2261,11 @@ void issue_beacon(struct adapter *padapter, int timeout_ms)
 
 	spin_unlock_bh(&pmlmepriv->bcn_update_lock);
 
-	if ((pattrib->pktlen + TXDESC_SIZE) > 512)
+	if ((pattrib->pktlen + TXDESC_SIZE) > 512) {
+		rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+		rtw_free_xmitframe(pxmitpriv, pmgntframe);
 		return;
+	}
 
 	pattrib->last_txcmdsz = pattrib->pktlen;
 
@@ -2325,8 +2328,11 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 	pframe += pattrib->hdrlen;
 
 
-	if (cur_network->ie_length > MAX_IE_SZ)
+	if (cur_network->ie_length > MAX_IE_SZ) {
+		rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+		rtw_free_xmitframe(pxmitpriv, pmgntframe);
 		return;
+	}
 
 	if ((pmlmeinfo->state&0x03) == WIFI_FW_AP_STATE) {
 		pwps_ie = rtw_get_wps_ie(cur_network->ies+_FIXED_IE_LENGTH_, cur_network->ie_length-_FIXED_IE_LENGTH_, NULL, &wps_ielen);
@@ -2373,8 +2379,11 @@ void issue_probersp(struct adapter *padapter, unsigned char *da, u8 is_valid_p2p
 			u8 *ies = pmgntframe->buf_addr+TXDESC_OFFSET+sizeof(struct ieee80211_hdr_3addr);
 
 			buf = rtw_zmalloc(MAX_IE_SZ);
-			if (!buf)
+			if (!buf) {
+				rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+				rtw_free_xmitframe(pxmitpriv, pmgntframe);
 				return;
+			}
 
 			ssid_ie = rtw_get_ie(ies+_FIXED_IE_LENGTH_, WLAN_EID_SSID, &ssid_ielen,
 				(pframe-ies)-_FIXED_IE_LENGTH_);
@@ -2767,10 +2776,13 @@ void issue_asocrsp(struct adapter *padapter, unsigned short status, struct sta_i
 
 	SetSeqNum(pwlanhdr, pmlmeext->mgnt_seq);
 	pmlmeext->mgnt_seq++;
-	if ((pkt_type == WIFI_ASSOCRSP) || (pkt_type == WIFI_REASSOCRSP))
+	if ((pkt_type == WIFI_ASSOCRSP) || (pkt_type == WIFI_REASSOCRSP)) {
 		SetFrameSubType(pwlanhdr, pkt_type);
-	else
+	} else {
+		rtw_free_xmitbuf(pxmitpriv, pmgntframe->pxmitbuf);
+		rtw_free_xmitframe(pxmitpriv, pmgntframe);
 		return;
+	}
 
 	pattrib->hdrlen = sizeof(struct ieee80211_hdr_3addr);
 	pattrib->pktlen += pattrib->hdrlen;
-- 
2.53.0



