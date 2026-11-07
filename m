Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063196;
	b=WKVv/nOpC4NvQUuajlW+Mm6lhlmL4R+uHPxA9bLa5s0gdTD/dcNY0L+HdXmNpQq9P5z2
	 m07r1e9O/VuJu7pECH1JRIhSzEh13nnAjuip3n3398wcuiErFEzVqCpElapa79WIeXf7h
	 HoHpGlXErSQkJytpV3g4Xa7aB+mG5q692YvZ5Lx2vxh9eCjW5OyLyszsQ7/GuNHs3bU27
	 jI/NHyggwFjAhaDuo4IUMu8GrlfcUA5jGr8ygtUyE0m26opBB9y1koOvUYiBvSVfymFAG
	 haYE/kMSgg8ZhJmFNe9ZKDkn9Elay8HECjKd+gzGXgq1Tf3jL/YUpLd7D+rgPRYvr/g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063196;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=huFobG5Mt1Sk0htsVjHo6JFahhm/GeuKgPZvR/DGQBk=;
	b=sxKLgcstz1m46l1azxhs5VIbB/qfoZCHJEFBZhLQzoPBTWpu+H9Z2re2C/OJ2ewt600s
	 lU1+1eHyIw2AzLbY2btfuaJTB1F1c3MMlmXJvSLuYJHsamTYZ+6nJJ0+eEtebTVSCqrJM
	 TwkH2EilW+XRxRj13hshohVocl86vH0L3mau/lWP/hkmp/6tL5PIe9M3KXG4a4k20GvGN
	 X++UYyjgXyq4s7F04z+VINMf+CnOSJCAO83Maw1P8pL7dIXxk9wVSTjWc/AFmDrzRGSfj
	 bUZ545IYE3Zqesn6cjpfleniUKaHZCQsWOcf8794hzyZ+NzCwZDSc1+4c6eiLehs5Vw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="YEl/apP2";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59C3E606EE86;
	Sat,  7 Nov 2026 14:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YEl/apP2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA031F0089F;
	Sat,  7 Nov 2026 14:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063196;
	bh=huFobG5Mt1Sk0htsVjHo6JFahhm/GeuKgPZvR/DGQBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YEl/apP2S64K+/gHXyT7KxYGa76LvWc5OQQQDyEM3aknF5gKqH3ADbI2D22MYSnxD
	 RzD5eAWpxBivKXUVMS8W3pcCC6+sdWZHKM7fyOhCLSyuMs3WlatjRvzVpW9Qrv8oI4
	 q3MTscMWliTZRkUn3P16djP8TewKarQoOnT7fRFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 411/869] wifi: rtw89: fix IE length passed to cfg80211_find_ie() in WoW AKM
Date: Sat,  7 Nov 2026 08:51:33 -0500
Message-ID: <20261107134907.272901289@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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
index 90046d6f620ef..144c4c2801bdb 100644
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



