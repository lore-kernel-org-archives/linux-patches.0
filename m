Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C698234D4FE;
	Wed, 20 May 2026 16:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294735; cv=none; b=SBryJo11EqDGhL+LhD8LrWo+tDTufjypRC2cBBcclrLq8/H3rxrmi+JRtDe+pTOtJGLLs7nMgaFp/z3JDu/YraAW3LqIw8Zq/c/gmT6YroH8btqFz+lNXZwtganvog0c0dMR+cJ0IiydiXDO/tvREBXKTixZywPe0uB4/PswnOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294735; c=relaxed/simple;
	bh=Co0cf/9uWfs0E8bR0WCoMFm+1iC2vb52OBUjJEsHE7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iPjVlVeL0MBb7jVcEe6V9ZIkI1EqD5t6NCBv0cS0BoLKoDCVmXbvwwTHVC5cEuLwUKpYW6CgQ/dagDSe52xgUXRRdNUfCxnWG6YWwtmiCZI9tGDmO0Pdasr2ERUxp2pase9D/5IZ5Mbgz7iJFSbm7uzCNYJc5YDQ1ene4pXAr4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUErtpoJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUErtpoJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 376B91F00893;
	Wed, 20 May 2026 16:32:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294734;
	bh=P4Yd0duwn3J/u++M9fif39qGgRGwwcnBKt30+rOS74w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yUErtpoJzvpfppjuAbQZaQ3S540YYEMEmM+ADyS02sE4ribYuUGB6MWiwjEh4C8Sa
	 1XvxtG9+YBUTp14bO4OlcbxjtF9/l9j08yQt9ExOS5vyLyl5hTffw/D7taYkf6hjDl
	 vx0k0fFLngTRRB6xJ7UrR5O7ZkkDPJmqZrwK6gIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0125/1146] wifi: mt76: mt7996: Add missing CHANCTX_STA_CSA property
Date: Wed, 20 May 2026 18:06:15 +0200
Message-ID: <20260520162151.157778323@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Bianconi <lorenzo@kernel.org>

[ Upstream commit c0a47ffc4caaf5161955add553322112c3a211b0 ]

Enable missing CHANCTX_STA_CSA property required for MLO.

Fixes: f5160304d57c ("wifi: mt76: mt7996: Enable MLO support for client interfaces")
Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://patch.msgid.link/20250928-mt7996_chanctx_sta_csa-v1-1-82e455185990@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/init.c b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
index 6a0c199ce3622..ca671dabf00ab 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/init.c
@@ -536,6 +536,7 @@ mt7996_init_wiphy(struct ieee80211_hw *hw, struct mtk_wed_device *wed)
 	ieee80211_hw_set(hw, SUPPORTS_RX_DECAP_OFFLOAD);
 	ieee80211_hw_set(hw, NO_VIRTUAL_MONITOR);
 	ieee80211_hw_set(hw, SUPPORTS_MULTI_BSSID);
+	ieee80211_hw_set(hw, CHANCTX_STA_CSA);
 
 	hw->max_tx_fragments = 4;
 
-- 
2.53.0



