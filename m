Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DA073EBF35;
	Wed, 20 May 2026 17:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297617; cv=none; b=OzBhorvtrKWGQzDOED0sucNpo2eFvZbLiEZK/V43AdnrSzC+sKQwMOFV012roiGBNrW26qJqAdvmk3Ut8kXJxsCsEh6yC0/BElHMNm/THZ6tavvnaXkRoFtssN7yPBVmkQ8/CYK9Y1pEhR6fFhJXnr/UAjEZ8xeHRdywgjWRD74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297617; c=relaxed/simple;
	bh=6a/fegO4+0o6zYv92lLi0kOWRd8q/DBvXGMSuCjF6LY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BsWKa/zcFJLwAV121BlGDMEFnl6VJnVpmyLkR2NIoygN7diqtVetDBCLQAxNfWpbkXqUtPVuyaAHyabyYbjSAJO9C6cPguzX39LC/i33KekOSNFfSZ2YvPBtjU4xRchDNyLqQBxqIKLmxoXy42iV3dQ1lzpX7tT80fxUKXozpLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ia89CZ7Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ia89CZ7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E1D81F000E9;
	Wed, 20 May 2026 17:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297616;
	bh=n+m969KkFvqGpPTQhoOymVGQag84uH02jM0nBLvEvT4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ia89CZ7QYnvQAYKSMXSHbJWdknr5B1hOQdHb+koZxUMZDVoeKajbxmtBLBur/VaWb
	 rPnPno9Dsh2EiaDueFgpdzceGKIn2AXcBrhV7x7acvKBZX4xQCI2fQesBgWQv0CyyO
	 ow9SSsIN7tGq5WBL/jqiZJKCsfOwPaOlWOvVIMC0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 100/957] wifi: mt76: mt7996: Add missing CHANCTX_STA_CSA property
Date: Wed, 20 May 2026 18:09:43 +0200
Message-ID: <20260520162136.728254427@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index ba769e6de76d2..817acfad31d06 100644
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



