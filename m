Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829462;
	b=lU5m2jVJIJvA+SXy0Uq5G4eAnpCYytw8NECLK2mXpn5fpVrk7cLE2iuJJODzOS5dgjTw
	 qU++R2WWpuwbJtj5LJ+R7J4JVFXgU8pTxO2uKOHMy+slXWXcr/LQ2242C8m8UZuYctXPZ
	 WgAR+QK4oto786EysLTECBF6pi1m8ujLNnnvFd6SLCIDlGYIy3XhiIfwLZaxMdDSrbCqc
	 7NohASs5L0E8YGPYRszoL0IxgQ9C7Vz/Hzqa1ond9IhwSdyY8x9LUR0PI0+aI1SEAG5Cf
	 iBQB0h8odgD6/JxNEx7tqVm5Xue2wDLvccJgbKv9tAp6dpBTa5Ay80xnVG5ve+9diMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ixAUn6QdUxL5eGLVKI4h7gMIa+OV+NzxG/kR+PADT0g=;
	b=dBcKqGXuTlYEI9RfJ3T9L+4f8Zo8A64Gg3/KUJg703nYKxhmKvk/oDitpoKUdtuC7TZs
	 yjL4hPSBSLTUaiRvLz2kSrk1YPyciWXKS0o6tp9X+ZqyQkRTf6YZFA/jsBUe3wkZBXYTw
	 GHHeIuEM8biuLPnE/pPhP+TF7MVl8avOwwog6QDZccsEZDXHPxK2Q4jyg7g6qaaT7Jd6I
	 Cx9HOCUzyDECrjnOG+tcfINbpwf0Kq0fJDL7NvHngXI9S9+7KjVyqeZVROVXPtmi+Yopq
	 c6d01NKArmEe/soTINKdHoqx6+y8Rx4jnZYExyUVB12OTj+FW9lS6sD/ggFJhQ3BrTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7YibwwW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4843F606A86A;
	Wed,  4 Nov 2026 21:57:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=G7YibwwW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD7501F00A17;
	Wed,  4 Nov 2026 21:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829462;
	bh=ixAUn6QdUxL5eGLVKI4h7gMIa+OV+NzxG/kR+PADT0g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G7YibwwW1ObRrJmRKYJuPmDSUY6j/3YGYVEHxnBzqiE0Kq/ntc7GOdKmJUxR+HnaD
	 89jn2Wqgr711oQZ3TO6QV+HmMF/NBXoNtNi90xiiMqErx3EozMgq5/QfLCc0GAKjRz
	 Z3VS6Me3RGjHkebeNZ4tz46AUHEeaKmbganKpxMw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chin-Yen Lee <timlee@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0091/1005] wifi: rtw89: wow: add QoS control field to WoWLAN ARP response for MLO
Date: Wed,  4 Nov 2026 15:57:04 -0500
Message-ID: <20261104211046.175742895@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 03a963f4aeda538acad50806e94ef25d95b78743 ]

Some MLO APs expect WoWLAN ARP response frames to be transmitted as
QoS data frames and may discard frames that do not contain a QoS
Control field.

Add a QoS Control field and use the QoS Data subtype when generating
WoWLAN ARP responses for MLD vifs. Keep the existing frame format
unchanged for non-MLO connections.

This allows WoWLAN ARP responses to be accepted by MLO APs while
preserving compatibility with legacy APs.

Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260625061545.44808-10-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/fw.c | 31 +++++++++++++++++++------
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/fw.c b/drivers/net/wireless/realtek/rtw89/fw.c
index c6533a085c7fe..299526220380f 100644
--- a/drivers/net/wireless/realtek/rtw89/fw.c
+++ b/drivers/net/wireless/realtek/rtw89/fw.c
@@ -2701,6 +2701,7 @@ static struct sk_buff *rtw89_sa_query_get(struct rtw89_dev *rtwdev,
 static struct sk_buff *rtw89_arp_response_get(struct rtw89_dev *rtwdev,
 					      struct rtw89_vif_link *rtwvif_link)
 {
+	struct ieee80211_vif *vif = rtwvif_to_vif(rtwvif_link->rtwvif);
 	struct rtw89_vif *rtwvif = rtwvif_link->rtwvif;
 	u8 sec_hdr_len = rtw89_wow_get_sec_hdr_len(rtwdev);
 	struct rtw89_wow_param *rtw_wow = &rtwdev->wow;
@@ -2708,26 +2709,42 @@ static struct sk_buff *rtw89_arp_response_get(struct rtw89_dev *rtwdev,
 	struct rtw89_arp_rsp *arp_skb;
 	struct arphdr *arp_hdr;
 	struct sk_buff *skb;
-	__le16 fc;
+	bool with_qos;
+	u16 fc;
 
-	skb = dev_alloc_skb(sizeof(*hdr) + sec_hdr_len + sizeof(*arp_skb));
+	with_qos = ieee80211_vif_is_mld(vif);
+
+	rtw89_debug(rtwdev, RTW89_DBG_WOW, "[arp_reply] with qos field: %s\n",
+		    str_yes_no(with_qos));
+
+	skb = dev_alloc_skb(sizeof(*hdr) + sec_hdr_len + sizeof(*arp_skb) +
+			    (with_qos ? 2 : 0));
 	if (!skb)
 		return NULL;
 
 	hdr = skb_put_zero(skb, sizeof(*hdr));
 
+	fc = IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS;
+
 	if (rtw_wow->ptk_alg)
-		fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS |
-				 IEEE80211_FCTL_PROTECTED);
+		fc |= IEEE80211_FCTL_PROTECTED;
+
+	if (with_qos)
+		fc |= IEEE80211_STYPE_QOS_DATA;
 	else
-		fc = cpu_to_le16(IEEE80211_FTYPE_DATA | IEEE80211_FCTL_TODS);
+		fc |= IEEE80211_STYPE_DATA;
+
+	hdr->frame_control = cpu_to_le16(fc);
 
-	hdr->frame_control = fc;
 	ether_addr_copy(hdr->addr1, rtwvif_link->bssid);
 	ether_addr_copy(hdr->addr2, rtwvif_link->mac_addr);
 	ether_addr_copy(hdr->addr3, rtwvif_link->bssid);
 
-	skb_put_zero(skb, sec_hdr_len);
+	if (with_qos)
+		skb_put_zero(skb, sizeof(__le16));
+
+	if (sec_hdr_len)
+		skb_put_zero(skb, sec_hdr_len);
 
 	arp_skb = skb_put_zero(skb, sizeof(*arp_skb));
 	memcpy(arp_skb->llc_hdr, rfc1042_header, sizeof(rfc1042_header));
-- 
2.53.0



