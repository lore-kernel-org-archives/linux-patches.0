Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018955;
	b=ANvpkDFmL14yP+asb50WUTxbk2rMk599FAMystliqCHWI/n1EnIlx4KzCGOGGdw8uwMG
	 Q3PcKgfUcPlc9muZ3KCtcYE78FKYZmGZ7ehDkCspdUmfFtb3khiW2xb1njGKJMRZlOP3G
	 fZRS2IKJhiiUwP9Hv5j74ehh2sliI3u0ApVrmFbmEKoE2C80FFxf+/rlj2tVPixDKf1WT
	 iVY88pdH0yOZ7TrA092F9lDNDd4keaiNiBFaoOfLIYLKp03wqjU2aoHWG5vHBLrq4wuzQ
	 9PMpE2YB8kfueNYdTO78vY3ytFV6HBypvwbRMGNstDbBmVm3YdYq/2Ls/9PaOXQnKqQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018955;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Bwo/uy6CEEz3jBAEuQi1l2X+lGN37Wtu3wXnugMmPb8=;
	b=NccqYlFGU5lFNoNy1rBitWI+tvS7ardpNev60o+H41ui3LyXJmLcIbcYdeZmPbKfAY8r
	 +6SvU1JcmZSlK9ncKMJ7T6I0voZXdoyCRwa9jrUSOF7iP66fRnjfwKTEsDmRWV75rN6G+
	 zYzpe0A5jKuWSB0km05MdaIy3fJfkvC4ogFPhzy0VBpr1oRqp8CqVzCUJvFFOGXEymmI/
	 v4L0B6YZEXH2Nz3YAly70t57wpDCENcqrOfx1ip6KJwjevRjmS3G12mBu47UzAFocOwA6
	 STdpDnCsEoJ4lFeSJavqgKGLzP8fPO7tp1XEW9ipOIldXULLjNk8NRtLp+7fqfAjTnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thYAAPyY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7106606A31C;
	Wed, 18 Nov 2026 16:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=thYAAPyY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3931F000C4;
	Wed, 18 Nov 2026 16:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018954;
	bh=Bwo/uy6CEEz3jBAEuQi1l2X+lGN37Wtu3wXnugMmPb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thYAAPyYhmrqGLn3pfr/gMb/PhSUnmkaQfpSOUhG46HfXHTzdnTQaRdXAmBooG9fr
	 /8BaeQlhjCrX+QnyXSbMOos//7AAS5QTV1OA/pw/8TljMl7sqKflccmAqQjKoVTM8R
	 uqc62P2KBwnA9JktlmEKxmvKsYhXEVVl5l7hJGW4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1423/2651] wifi: mt76: mt7925: drop deferred NAN local schedule update handling
Date: Wed, 18 Nov 2026 15:44:23 +0100
Message-ID: <20261118150339.281199046@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Stella Liu <yu-ching.liu@mediatek.com>

[ Upstream commit 851b8f026ac10afa978f8d8af3eb2af4a4930c92 ]

The deferred NAN local schedule update path in
mt7925_nan_local_sched_changed() is removed for now; it will be
implemented separately. Drop the now set-but-unused ret variable
along with it.

Fixes: 0f3605e4f8de ("wifi: mt76: mt7925: wire up NAN operations")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-7-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c | 15 +--------------
 1 file changed, 1 insertion(+), 14 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index c3a9a592dddf3..2be2251aeadb6 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -602,15 +602,12 @@ void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 {
 	struct mt7925_nan_common_hdr *hdr;
 	struct mt76_dev *mdev;
-	bool deferred;
 	struct sk_buff *skb;
-	int ret = -ENOMEM;
 
 	if (!dev || !vif)
 		return;
 
 	mdev = &dev->mt76;
-	deferred = vif->cfg.nan_sched.deferred;
 
 	mt792x_mutex_acquire(dev);
 
@@ -627,19 +624,9 @@ void mt7925_nan_local_sched_changed(struct mt792x_dev *dev,
 		goto out;
 	}
 
-	ret = mt76_mcu_skb_send_msg(mdev, skb,
-				    MCU_UNI_CMD(NAN), true);
+	mt76_mcu_skb_send_msg(mdev, skb, MCU_UNI_CMD(NAN), true);
 out:
 	mt792x_mutex_release(dev);
-
-	if (deferred) {
-		if (ret)
-			dev_err(mdev->dev,
-				"NAN: local schedule update failed: %d\n",
-				ret);
-
-		ieee80211_nan_sched_update_done(vif);
-	}
 }
 
 static int mt7925_nan_peer_rec_tlv(struct sk_buff *skb,
-- 
2.53.0



