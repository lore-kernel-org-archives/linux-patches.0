Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018965;
	b=JwRHNrky/+ieaNQmCfF2b5MizAUYl8tG2implvYsv6X5HZGbXU9Egsg5R+r9izABOTWC
	 7wG6oAK17C7FVm7qpzXWtWkpQC2lBIymd0auEre5VDxhyU9Xu4szzM1HB46X8CkZVQZfr
	 jqV2bkZC9AplwKfpXy9EWL3a/B+SX9DVfIs24KY/Ikm7NNcMd9AbxZx3noMs2wqvzxyIq
	 AruvuyqmKrnny5urBkNOxEK8udisOVYTKLisdfJfpvBq29ttwcfDpd1xg5SKkfpeQFFgl
	 sb9F63K68jRnPDpL4XjPWnZqWNevvnVb1G22mW2/yjSQiOIdSDdz7T9VV6sTMG5CWfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018965;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3PcwtOCoyb7VM2EOs3wMSDAUqEs4ekmsK3xBjBuglck=;
	b=4POvm7Ivmd2zy2c/i0KjdqmPHJkBbNMRanLY23Fm+/duksNuPzB9O/sMtUlPdRVju+pb
	 pNVO3W1RlPgi0AMWiM4ua2UzbZ6x6Uh6h7f8w2+rblsBiUnGe0t/CoGcynTrRuB6eXYKS
	 dssmlsZLdf+0PAji+TwHHTWimTpF17Dcwp2bVQv3mgJwKkyQClowgPFEgZb6dWWTcst47
	 iEw59cCfTLy3uy6YAcQVB3VBAvvZ6suiySJBF7kPJCq5SZ3HG0ZWuUR8LBXiOKniljuxm
	 b2lVDwR639kVhWiz9TWs3eAaTYhJoOJuQGWFr08Qjffp6p4wcRnrAY7ux+ixEwenu0g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HC3Mf7Jy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A026606A31C;
	Wed, 18 Nov 2026 16:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HC3Mf7Jy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600531F000C9;
	Wed, 18 Nov 2026 16:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018964;
	bh=3PcwtOCoyb7VM2EOs3wMSDAUqEs4ekmsK3xBjBuglck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HC3Mf7Jy9EEJvHH4BIp7bFFQuQtz7ejWKLq3aBLf3+tKrXFvbLRycmkVfjgzzBKuF
	 RzpdBknOdnJJFwoJXSSG/bFRdkx008hi4xS7LmfX3s2eAIzLbGpnsODyrrXoaFbpOG
	 RbuK8Tzfw/JwnS5ppZScL5ZyO5v1xD7zsTp1x0+Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Stella Liu <yu-ching.liu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1426/2651] wifi: mt76: mt7925: replace NAN DW end event with DW start
Date: Wed, 18 Nov 2026 15:44:26 +0100
Message-ID: <20261118150339.387826059@linuxfoundation.org>
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

[ Upstream commit ad393e4d799cc52e282003cba4a1f5ed1b01cfa3 ]

Handle the NAN DW start event instead of the DW end event for DW
notification. Queuing NDP action frames at the beginning of the DW
window, rather than after it ends, improves NDP handshake reliability.

Fixes: a5487a682406 ("wifi: mt76: mt7925: add NAN MCU helpers")
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Stella Liu <yu-ching.liu@mediatek.com>
Link: https://patch.msgid.link/20260824195227.12589-10-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c | 2 +-
 drivers/net/wireless/mediatek/mt76/mt7925/nan.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 1c69db94b73db..8194e7678131c 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -422,7 +422,7 @@ void mt7925_nan_mcu_event(struct mt792x_dev *dev, struct sk_buff *skb)
 		case NAN_UNI_EVENT_ID_DE_EVENT_IND:
 			mt7925_nan_mcu_handle_de_event(dev, tlv);
 			break;
-		case NAN_UNI_EVENT_REPORT_DW_END:
+		case NAN_UNI_EVENT_REPORT_DW_START:
 			mt7925_nan_handle_dw_ind(dev, tlv);
 			break;
 		default:
diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
index 31341c1df8f9b..4b424e0ece527 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.h
@@ -93,6 +93,7 @@ enum nan_uni_cmd_tag {
 
 enum nan_uni_event_tag {
 	NAN_UNI_EVENT_ID_DE_EVENT_IND		= 19,
+	NAN_UNI_EVENT_REPORT_DW_START		= 59,
 	NAN_UNI_EVENT_REPORT_DW_END		= 60,
 };
 
-- 
2.53.0



