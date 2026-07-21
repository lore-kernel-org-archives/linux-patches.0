Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA2B4C8FE4;
	Tue, 21 Jul 2026 15:57:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649480; cv=none; b=uVVnjXOm8U4digEmdXxMhDaEZwaRaZzjCO0DGXFfjbL5hgRTEyqczRfGsJwGXqm9nP+YC1r3ckWhJvlNAKtiGmshHcH80tlxjhK55iqsiuOHOQc2USg/YgsbKkSdxZNk51HGIiMnun+1zWnUE6zr6qOyRtCD9OmkemN585X91Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649480; c=relaxed/simple;
	bh=dT8swKfguf9lUw1hdoWEiRwOCYNFBrnVCmp8l/BnEa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lKn1QhYl3cSmvaa6dcs2e+DDNBZL56co7kTDItJViCIbgLM3hAQpNyRaIqpj/W9QIwn8Ab21A1spw1Z5+bGO5sBSnfX7WMRJ/ir4kHAEQBfnMj31T9qpbKrtF2y2UnrENaaZUxK/qtVB9xAftbL/aXQbOjZ9Hjc++/n7gqWxvCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VmBPtQca; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VmBPtQca"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D5BD1F000E9;
	Tue, 21 Jul 2026 15:57:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649479;
	bh=SXnx1Bdi2oS3KTLlVEGSYfRjHzSA7tPLW9jAZxEyKJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VmBPtQcaoCsNKjN2r9+vzq+kpBI9X7UzpOXypqgHMeMq0SU0e5dMpA7i25UplOSiv
	 6ZEb2pk8AyATw/xh7XtWph0vbotCvAEx3WY5qeR6wSAiCwtS6Qcv2o9sJi5n4zoy8U
	 wIAO42DEwcQ8v+2tx2vMKo6GWeWkjQsoPvITF29I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bjoern A. Zeeb" <bz@FreeBSD.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0592/2077] wifi: mt76: fix argument to ieee80211_is_first_frag()
Date: Tue, 21 Jul 2026 17:04:25 +0200
Message-ID: <20260721152606.774327236@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index dd09ef1bd0c25a..13c4e8abe28191 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1323,7 +1323,7 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 		 * All further fragments will be validated by mac80211 only.
 		 */
 		if (ieee80211_is_frag(hdr) &&
-		    !ieee80211_is_first_frag(hdr->frame_control))
+		    !ieee80211_is_first_frag(hdr->seq_ctrl))
 			return;
 	}
 
-- 
2.53.0



