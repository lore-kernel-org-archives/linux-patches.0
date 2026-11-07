Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062241;
	b=sbkRGKMGJIdavuoDrWJHk0ZaUx4QqYqA3eFG1dR4Ed6NF6eRsK1otXlJHHmofNDIKIDJ
	 WB5xlT4J9mKe1E1Zt/OmHsaQqcNkwG71679784A9JW3en2T0z42eETDHrVRyeSsvgHnJx
	 3PcW/YI5GlvwkYtGK6fLbbl1UwE0I0O6izuVN5KNGYYMTkvmhisyPBAHWB4uHEBsSrjNT
	 fL3e+v9+56WZ0IqgIWNDfj6YWbM1x3K/sbhAsUQH/932pR6iKy7Sq+mheOyIqhW5iXaA5
	 WKLnA3RHWKKRZSPSSGT4FWEwK5Own0jEtTOqvaFIejILynAzg5tGHX/BXgt5Z61/oEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062241;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xephxa9Cufr0x8IEAuW6m/Ii3Vdck3Qr78mOtrFKCMI=;
	b=HmIDwXQEcBUI8YkSTLXWFmdieju0utrYpbH67iPEA+uvfMrg2ASGbR00Du7/u/7/BVxu
	 fVEzxaJJkMu0/WkZL6KdYVPN6Ing6wx5XDNPgNr8B41kSreftPkURSjW8KVcENcs/RTDL
	 xOcu9uxY8YZQ+U+0IvRRPSskSE+wU8l9tfUbuVQQCLAxUt203JjbCpDxCVf5K2z3M6mJ6
	 jgGtqXhPPPhOx7q9zXi5V8D6A6aAgIWV9AATKKcKeOBm2QIjZ1SO9e4lxAfgDm9HO/CUk
	 OKBwa7DuKPcIiOWEZghhilIJCqROg30vmj3sWqq7nfN18DqQ1R9JlDCKwOvtLcX1aPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQDB4mU3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84FAC606D827;
	Sat,  7 Nov 2026 14:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OQDB4mU3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E86F41F008A1;
	Sat,  7 Nov 2026 14:37:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062241;
	bh=Xephxa9Cufr0x8IEAuW6m/Ii3Vdck3Qr78mOtrFKCMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OQDB4mU3VXStwDJHsptScPSRQbzGs1ufZtgY4rCTC4MCbjopuiz5j+ygVzgzb0g/S
	 MRSVK6ZESLz5ewtVtGnmLXK4NIl92ZZawnUf+QvImMeuHeRuCp8DngCledH6BX8epH
	 UgvA3aB3BfulaJrCzz1D1oP1xG2pwyx8DdsSPVcg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tristan Madani <tristan@talencesecurity.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1189/1536] wifi: rtw89: fix IE length passed to cfg80211_find_ie() in WoW AKM
Date: Sat,  7 Nov 2026 08:53:25 -0500
Message-ID: <20261107135031.142452352@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 38181035ef8ea..dcc7a542efa94 100644
--- a/drivers/net/wireless/realtek/rtw89/wow.c
+++ b/drivers/net/wireless/realtek/rtw89/wow.c
@@ -16,10 +16,14 @@ void rtw89_wow_parse_akm(struct rtw89_dev *rtwdev, struct sk_buff *skb)
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



