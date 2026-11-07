Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061857;
	b=Kp0Tr2Dt+l/z0MQpJEsLw+8j8S8Ffv1YbW3N1FxH5CivOIzkFeTnk+cFkh2ZslolgLw5
	 XUnj4LIALbtPM9bNFMe5Re3MJ20fTG2s/b0k+wPNQEV2BzxPjnNGKt6v/RpLDcqm/VVNj
	 bx5E4s0m6WKma8+EbKLqn2CvynD2y6zU8ZepV9aKXGKbuFmEwmMjowR5aqlQedsH3UahI
	 NOeInQNN61W06vwkotP3NN7by0E11AKh4CqQVtCMvVkK1IpFklD2ZHEBh89jGWdZgRTB/
	 wMPk/3ucvSoA1bEJLtquoG004bQjV0f+0ogiKfo9zUBqo6sVkCHmb6P2cvymNpQmA0w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061857;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L1xYteOfh9vjVBOi8Qn9J+8pHcUK0/+fr3rdSZWMw9g=;
	b=DUZtmexmYvrFyKYfgWb6GmpbGm/Jf9WrWFr9oFeEEI1zouXdSenOkO/4fYAcC1Y7dXW6
	 7rbs+b4apIVux2fZ+gBgX0bPV2BcIUq2c6g0cAZfMjrgx98A7fUE1PvlkCaC/kJuRuKbq
	 B0JwjijV9rTcWbvvhfwGrlOnnFtTOkR2NjuV6Om8HoZdvEiSVEW8K1iqVfNep41Kt5YGZ
	 eC0u9Vv+EQU2gO14HRNUX23O+QtDwTUC1b2Tu2nxQhnN3rfxnQbWLZRoGXal14oXWghpy
	 rUAis7CIoyVfmEHQFGpy4ilM32w9WFfLAN+xttSzou1qgIwgo/R5jYv+jY13wftZpHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=is1QrP7J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77005606A32C;
	Sat,  7 Nov 2026 14:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=is1QrP7J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E141F0089F;
	Sat,  7 Nov 2026 14:30:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061857;
	bh=L1xYteOfh9vjVBOi8Qn9J+8pHcUK0/+fr3rdSZWMw9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=is1QrP7JgSMCoCFPXe1DkGnFoFQSmAmIpHl1MU8oUrdOe+Sn0JeEuJl13XgfZ/KLH
	 erDIE/9Ki8MIweLY699XODYZYcXqhWvpWl6hNuPFSAqNSwu/1Iv9adYd/Mc1xKrAiy
	 v5WzvR7IhniwY8IUzxtMT/pJdIYUwC6WKlZ650lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0875/1536] wifi: mt76: mt7996: unlink TWT flow if the MCU rejects the agreement
Date: Sat,  7 Nov 2026 08:48:11 -0500
Message-ID: <20261107135022.123351546@linuxfoundation.org>
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
[ sashal: Changed the MCU helper argument from &msta->vif->deflink to msta->vif to match the existing interface. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mac.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
index 89d8a22e967c3..5b12f152b0acb 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mac.c
@@ -2654,8 +2654,10 @@ void mt7996_mac_add_twt_setup(struct ieee80211_hw *hw,
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



