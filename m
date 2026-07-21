Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A8E47126D;
	Tue, 21 Jul 2026 17:55:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656504; cv=none; b=ZWAA21mBLKxP7VURLGyci1WXWxDiTfdtL6JxU6iDSOXrg4ENWbWrWJaxB0oZGztd6VEsdsmsNIG0i3eRCFhCUDyOFYV7voX/AUlDx3cfqVsteUdd9R0js3YK16M0VMf6YYiYPtRnOSoOwwDnYFLbsY8nSP794a+qxGZoZ3xKibo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656504; c=relaxed/simple;
	bh=K0wtO9gmFto31EBE6kvRP33L8BIQ+VoFoE4fw2IBWgc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cXskxluHLBIesuV9iArkAY54gR7HSGbqBTqiKqVOU1TUGoLo7d6+acIiLdB2R25UMaN2ecvVAJABntToswgmzy7D+TRuVihv4pmiSP60TUqvSGLNDX7GbWVtfPqqsvdbIUgwz2g1vXuTfu39eEPLxDrCQncc18VRy7Jk7M884h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bH8zhEUB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bH8zhEUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A375D1F00A3A;
	Tue, 21 Jul 2026 17:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656503;
	bh=GvzSzKwGsvWbFvbfcud943yY1iBJwnoVUa6FEjbtqRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bH8zhEUBe1n1niwljHqITTGwhXlL8wldPJ2EsGvGuRRe5e/h4FIT4+/kpyp35UMgs
	 qilIH4+oucLdW7QLli5RmtaSXa3g11bKEe5qX3HGe1bTJoi9ncZgAIv2yX41jrD7Y/
	 s/gu9uIVOTLO0psTA1EbGUkE4emlFfeEQW39UyFU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Bjoern A. Zeeb" <bz@FreeBSD.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0411/1611] wifi: mt76: fix argument to ieee80211_is_first_frag()
Date: Tue, 21 Jul 2026 17:08:47 +0200
Message-ID: <20260721152524.496938382@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index f6a642fd29d2dd..7348ac5cf7e608 100644
--- a/drivers/net/wireless/mediatek/mt76/mac80211.c
+++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
@@ -1316,7 +1316,7 @@ mt76_check_ccmp_pn(struct sk_buff *skb)
 		 * All further fragments will be validated by mac80211 only.
 		 */
 		if (ieee80211_is_frag(hdr) &&
-		    !ieee80211_is_first_frag(hdr->frame_control))
+		    !ieee80211_is_first_frag(hdr->seq_ctrl))
 			return;
 	}
 
-- 
2.53.0



