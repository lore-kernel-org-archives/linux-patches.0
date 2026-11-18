Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021972;
	b=CIX1YAmXEFmkw8luMTqmDD6yBLSE6g+IaIckYcm2MV0Q8tY96ClmfJyTGVtBCdW0c1Mn
	 Xfikk/e9aAPPOrqltYxqgZUxLpAV7K6q4FtvHrW3mGBmAYDorWWPFqpRz/lTbo04orvMG
	 XAHDzbbMNEknndf+NAmgapyi/P7sI2nMYTw16mbE+WFPYioDwh8kCQyYSvz4LktxEtpAG
	 vd/B72msMQ7JIrHe2GmMW+JEWKSczH+Ma7kt5gCOZt5FMp9zLw28MReZRF7vq2g/J++fc
	 ihtt3vIRXEk11inpAM3wxHEp3bpKW7JEesDcoIsAArkDu1gXvtotRIIPu8Gyhk/D3bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021972;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CwdCny8aoJoAzOj/YU5MRh/fzHUpoS6ov4D/GqPsQjw=;
	b=45dXL5Lw1oIxqG7IzDjDSfe/nSsZajm/SVc3djaLqpnxlhx3KBbQw/nF4/MlZwrkzznX
	 WMMdOhVgK8qmImaltvC9ya+VzijpsV8wUKbEqcZEfESt7CJGhbuhXIrLA4UjF4zHFAD7l
	 4Js/IxdZSBc/n5FapsliOScuzT2EnDQyDhLcKO9c7lrWFUYYBdXtGuZ0V3nLHPbjPj+sY
	 Y6ogpUPVFMNBIz2UOUr8F68YaQfjqc4NC7RhDZ2SCKTmVt1nU5tGtpVyobAsMbAio0iXP
	 19wp3+0YuN3d0Sb80KBn/AEhqKHcC4JoZcAuAFjoNDAzuKOaTNcnwLYEX4WPeq0h23Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKFgQHg8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A388E606A31C;
	Wed, 18 Nov 2026 17:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gKFgQHg8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03E2A1F000C4;
	Wed, 18 Nov 2026 17:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021972;
	bh=CwdCny8aoJoAzOj/YU5MRh/fzHUpoS6ov4D/GqPsQjw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gKFgQHg8CkpPRXdsFrSZq0NWFGKIaFCxFNBIDwv9rnOwq9A1GavyO8c4iT0exuX9W
	 kYCzGZuANYrMIdatD+3dQcprvlMrisbMsYIZl4Gv5xLcpcpWf5HC5nbaSTX/Jlq40f
	 sDiFsumhlNnV+1HgmczNiYJEWSMyIzRnkxBwZuP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Deng <18983559317@163.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2456/2651] net: atlantic: Unregister before clearing RXNFC rules
Date: Wed, 18 Nov 2026 16:01:36 +0100
Message-ID: <20261118150413.495196290@linuxfoundation.org>
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

From: Binbin Deng <18983559317@163.com>

[ Upstream commit 13b364c765e69db1f8446399d8db0b331c23b50c ]

aq_pci_remove() clears the driver's RXNFC rule list before unregistering
the netdevice.  Until unregister_netdev() returns, ethtool operations can
still call aq_get_rxnfc_rule(), aq_get_rxnfc_all_rules(),
aq_add_rxnfc_rule(), or aq_del_rxnfc_rule().  Those paths traverse the
same unlocked hlist that aq_clear_rxnfc_all_rules() is mutating and
freeing.

The race is reachable by issuing RXNFC ethtool commands concurrently with
PCI device removal or driver unbind.  A reader can dereference a node that
has just been freed, and two writers can corrupt the list or free the same
rule more than once, causing KASAN reports, list corruption, or a kernel
panic.

Reverse the removal order: unregister the netdevice first, then clear the
RXNFC rules.  After unregister_netdev() returns, ethtool can no longer
enter the driver, while the PCI device is still available for the
rule-clearing routine to issue hardware commands.

Found during a static-analysis-assisted audit: candidate sites were
surfaced by a Coccinelle rule, and the reader/writer paths were
confirmed by LLM-assisted (GLM-5.3) code inspection.  The issue was
not observed at runtime; it is identified by code inspection only.

Fixes: 8d0bcb012f57 ("net: aquantia: add infrastructure for ntuple rules")
Signed-off-by: Binbin Deng <18983559317@163.com>
Link: https://patch.msgid.link/20261020022630.515209-1-18983559317@163.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
index 005d6ef4fc36f..881727c3aa0af 100644
--- a/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
+++ b/drivers/net/ethernet/aquantia/atlantic/aq_pci_func.c
@@ -344,9 +344,9 @@ static void aq_pci_remove(struct pci_dev *pdev)
 	struct aq_nic_s *self = pci_get_drvdata(pdev);
 
 	if (self->ndev) {
-		aq_clear_rxnfc_all_rules(self);
 		if (self->ndev->reg_state == NETREG_REGISTERED)
 			unregister_netdev(self->ndev);
+		aq_clear_rxnfc_all_rules(self);
 
 #if IS_ENABLED(CONFIG_MACSEC)
 		aq_macsec_free(self);
-- 
2.53.0



