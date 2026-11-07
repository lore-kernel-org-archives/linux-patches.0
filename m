Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064521;
	b=y98R9f9Vn7YwzJExoQB1nQXJs5l+JY4N8HK3Ca8ykLVVINx+xtDTosu0R6cDY02isUqT
	 r6DjdeSDMzF/JI4Z8LTzUOXo4IdRnbPu3lQ4pl5zetGGe3VXXskJdo0AOECG4oEgoC/fb
	 Y7WbZsRTXJi3N5S9zawV+852/N57XHQ90qx4mut6cnRMh4baf0FZgFzlMRReegp2x9dUd
	 6mkWVNFZpsf8f4DfR0YhVhX0yuMDc1uciTNo7Fp4LSdtjrRPdjV73kN0TyDEHAFm/0Kcb
	 BCGw/qcOy2qRlX1Px705iS4eYSgdtSUAXWu+7gisRZFGwivxfMlYkeYVNx+tw9XaXHw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064521;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=H3o3zvlNmh+8tahJiFiLENqpZ9uy6FpVEruHcDyVF6s=;
	b=3Ifd2IL8TB8epIx+dMwvL8UJ6OA3qdZ23IkLWt6ttUa7mgdRnIaTLygQOlyZPr+kdGSa
	 Ubg7mOqvkI88vYc13M+FO/n9jxgvzecR/N3iJUl5no/wtlRbO2ey6NG2+ogVIjcS2qJh3
	 zhUb/hXa7t1A/plRG4SWmh1QsYgmZyfg8Id6lZycfTOZEh+mBUTVASmf7cgnFMm0ws4Cq
	 PfCg6/VbdjQzHCBAPDoQbGA6htx6lVoDtc0nVcvs9n87NQJeKbiU5OiIc5jX5j/SkpOB4
	 BOjU6Vhb1UTTqD8W4gu6kinddYzNc4+8OENntCk1DrC8n2YCtlZY+72IxxtEDtab53w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fctwYl4+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCC8606A33B;
	Sat,  7 Nov 2026 15:15:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fctwYl4+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CAAA1F0089F;
	Sat,  7 Nov 2026 15:15:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064520;
	bh=H3o3zvlNmh+8tahJiFiLENqpZ9uy6FpVEruHcDyVF6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fctwYl4+N4gBjBCktpw+NgzOZJZIjAGmMH5sXfhLrhTIIQCZ+uhvDxjhhw+NWl1XD
	 tWhcGeibt8JLbQU7/0obUGi1flnHFd1yn9iAfq3s+/jtHpHSvUDvi+6ct2zKWgMNst
	 Xi+baSrtYCHJvd2IpneJ0r2ir2YpvHPBnw2AZP8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0552/1257] wifi: rtw89: fix IE length passed to cfg80211_find_ie() in WoW AKM
Date: Sat,  7 Nov 2026 08:47:28 -0500
Message-ID: <20261107134954.635443627@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Tristan Madani <tristan@talencesecurity.com>

[ Upstream commit 6c17c57d45ef1652d80f79a9834597b25412fd26 ]

__rtw89_wow_parse_akm() computes a pointer to the IE area from an
association request frame:

    ies = mgmt->u.assoc_req.variable;

but then passes skb->len as the IE data length to cfg80211_find_ie().
Since skb->len covers the entire frame including the 28-byte management
header and fixed fields, cfg80211_find_ie() may read past the end of the
actual IE data.

Fix by computing the correct IE data length as skb->len minus the
header offset, and validating the minimum frame length before parsing.

Fixes: 92790c4e50d2 ("wifi: rtw89: wow: parsing Auth Key Management from associate request")
Cc: stable@vger.kernel.org
Signed-off-by: Tristan Madani <tristan@talencesecurity.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20261007161721.261452-3-tristmd@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/wow.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/wow.c b/drivers/net/wireless/realtek/rtw89/wow.c
index 2dfa24c54e7d7..178c59692b13f 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -16,10 +16,14 @@ void __rtw89_wow_parse_akm(struct rtw89_dev *rtwdev, struct sk_buff *skb)
 {
 	struct ieee80211_mgmt *mgmt = (struct ieee80211_mgmt *)skb->data;
 	struct rtw89_wow_param *rtw_wow = &rtwdev->wow;
+	size_t hdr_len = offsetof(struct ieee80211_mgmt, u.assoc_req.variable);
 	const u8 *rsn, *ies = mgmt->u.assoc_req.variable;
 	struct rtw89_rsn_ie *rsn_ie;
 
-	rsn = cfg80211_find_ie(WLAN_EID_RSN, ies, skb->len);
+	if (skb->len < hdr_len)
+		return;
+
+	rsn = cfg80211_find_ie(WLAN_EID_RSN, ies, skb->len - hdr_len);
 	if (!rsn)
 		return;
 
-- 
2.53.0



