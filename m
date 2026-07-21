Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 634AC46EC8E;
	Tue, 21 Jul 2026 19:26:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662014; cv=none; b=RpbY5IErovJm/diPF8j45ImyDK/VWXOsKQAF1BTg81HpoAMNgkktCayHIXdP1HMJmJGEBwbT+2ehLMDcQXFUf8aR3liYPHt4TOzzTuBeM4auHdVsfvMYCgtxUgzUSaQLXd+WKyV1/7jSih7NHgXB7znjIilnutlKRE0S2Ks4c2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662014; c=relaxed/simple;
	bh=jdht1TIWQIkAMsc69DHase3cHtfo1mp8khg2E4Mx5Zs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VeAsf9rL03YsxCiNFLVfkXJp6Zwjq3MKVvh70+ks4LaUV/CkxbyfGDfyv+C0mh9at0hd6sznNU5vL29TST5betsIBwAdQeySrtcibwctNqZHvx4to2Fagn11a1ypbhFwizuyAMkDNTYUZQ3OfRQeqaDME6Bo/HgxblR5rXlCB0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LKXtxgGq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LKXtxgGq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A41141F000E9;
	Tue, 21 Jul 2026 19:26:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662011;
	bh=e7D9gE8QI3tjNxKOi2ganyEkwtd7aeLVlQaPdfgSbK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LKXtxgGqZRSLGJCr1wJV2NH+HDPl7PAkGWqFC7yOMuC0SYKXbvOUEQMfXTctamKGo
	 cdXs1prCzhPw2Vix77PvtZYVkn+MjWhM0MSG2ef+LZ7Yck4tMIyW5Kq6t3mc/5OVIf
	 mDQUDEfr3yXOHfKPXTlyWyE/2PY9l2c+LyfLRm+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bjoern A. Zeeb" <bz@FreeBSD.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0284/1276] wifi: mt76: fix argument to ieee80211_is_first_frag()
Date: Tue, 21 Jul 2026 17:12:07 +0200
Message-ID: <20260721152452.435549777@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjoern A. Zeeb <bz@FreeBSD.org>

[ Upstream commit 5832743279da8c6ae72f715bad2f7141eca6f4b8 ]

ieee80211_is_first_frag() operates on the seq_ctrl not the frame_control
header field. Pass the correct one in; otherwise the results may vary.

Sponsored by: The FreeBSD Foundation
Fixes: 30ce7f4456ae4 ("mt76: validate rx CCMP PN")
Link: https://cgit.freebsd.org/src/commit/sys/contrib/dev/mediatek/mt76/mac80211.c?id=c67fd35e58c6ee1e19877a7fe5998885683abedc
Signed-off-by: Bjoern A. Zeeb <bz@FreeBSD.org>
Link: https://patch.msgid.link/83s4psnr-popo-8789-757o-npr2n9n7rs2o@SerrOFQ.bet
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
index 5373f8c419b045..e538bb36a73095 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1188,7 +1188,7 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 		 * All further fragments will be validated by mac80211 only.
 		 */
 		if (ieee80211_is_frag(hdr) &&
-		    !ieee80211_is_first_frag(hdr->frame_control))
+		    !ieee80211_is_first_frag(hdr->seq_ctrl))
 			return;
 	}
 
-- 
2.53.0



