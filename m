Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035657;
	b=j6ALsQWSURHiZQmhjadUTyzIpIC5MeRhzAMBHZLnUwxXYTB/KdjtPAATscUP2/eo7iN6
	 cu1DrLDl9vxjpHmGP2jivgB9Wr9CmCqwWNojzLC+KL6JSkjBD5tvozdyV53M3Y8b7fHTS
	 KWtaVZf0fmqqxMLOHSHRsTUgB8m8E3g9q1OTTaoOvDjpcfYXUsYsmcl6iT069yxkxAUeq
	 8l9VkNsXvsEdvOg43ZBAJfVgYbgcoLP+s+ZrsDcuBQ7izlkQ/eCN1bBadLQ+qZkepKtp7
	 nLP/dcA8wEvC6awzIKBwinlSfYrCeJwkLGZaRi2i8annxE/jEJg+WS9YgSLHrovTmQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/8jArKHE43nyETgpEgT22GM9Xii2kTFapMSo2Jb2ovo=;
	b=xSykFpKpQ/BQtDIxigL6yA3lJW52DlYZJUrlCuEWyDBlwl33yGiPcESxKIN+UJY6Mr6b
	 W3PxriB0lm2EXBmieMlyAJvD3ZgBDGHhiW717d+5DY8iL7uPpXh6Hpd5mNg2BkSrAycKD
	 sTIf5B6wIaoZEzbTtnixefG0sZqWSL7QlPNrtEWQstvRKOYkqJrm4LO/4+nwlXkwjAj8B
	 QrX3vlV/Blq6T5J2Nl0Yi505lMrLYdullPDA5pU9udNFbv8ipNmNNvy/JVjAoXIdLBEo8
	 thhIAsIrocrfhGfY5IdwWiU0NYZWD7rIG7I9Kw6+DzQzjO/54JN7AnPUon/3UMriXdQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="xn/y+xJu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3369606A31C;
	Wed, 18 Nov 2026 21:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xn/y+xJu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166691F000C4;
	Wed, 18 Nov 2026 21:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035656;
	bh=/8jArKHE43nyETgpEgT22GM9Xii2kTFapMSo2Jb2ovo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xn/y+xJubEe2WGYPR1FOWvLNzZXyDe0QTpPI6zz/b6L3GVPu1OHAdARWXlz5RBPhp
	 H+OC6lZ1q0UA37IKDDh+yrjt+9ooY9lZUhLUoZhV2EAH3Hfe/FMcMlJyk+qicqaD95
	 iKKs+obuygD40vEMGQShixvyU81pzp/XlNPeTW0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0780/3318] wifi: mt76: mt7996: unlink TWT flow if the MCU rejects the agreement
Date: Wed, 18 Nov 2026 15:23:22 +0100
Message-ID: <20261118150342.222444519@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

[ Upstream commit 022f5f8b7a0580da50fcbc34da853d03d4321fe2 ]

mt7996_mac_add_twt_setup() links a new flow into dev->twt_list before
asking the MCU to add the agreement, but exits without unlinking the flow
if the request fails. The flow-ID and table masks are only committed
after MCU success, so the still-linked flow is invisible to the
mask-gated teardown paths.

If the station retries the setup, the same slot is cleared and its
embedded list node reinitialized while it is still linked, corrupting
dev->twt_list. If the station disassociates instead, teardown skips the
flow and station storage can be freed while the node remains linked. A
later scheduling or debugfs twt_stats walk can then dereference the
freed flow, resulting in a use-after-free.

Unlink the flow when the MCU rejects the agreement. This restores the
list to its pre-request state while leaving the unchanged mask and
agreement accounting untouched.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260729173632.14387-3-enderaoelyther@gmail.com/
Assisted-by: Codex:gpt-5.6-sol
Assisted-by: Kimi:K3
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20260825112620.97568-1-enderaoelyther@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
[ sashal: Adapted mt7996_mcu_twt_agrt_update() to pass msta->vif instead of &msta->vif->deflink. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 14c84219ef750..42e75e7416ed4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2551,8 +2551,10 @@ void mt7996_mac_add_twt_setup(struct ieee80211_hw *hw,
 	}
 	flow->tsf = le64_to_cpu(twt_agrt->twt);
 
-	if (mt7996_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD))
+	if (mt7996_mcu_twt_agrt_update(dev, msta->vif, flow, MCU_TWT_AGRT_ADD)) {
+		list_del(&flow->list);
 		goto unlock;
+	}
 
 	setup_cmd = TWT_SETUP_CMD_ACCEPT;
 	dev->twt.table_mask |= BIT(table_id);
-- 
2.53.0



