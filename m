Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D381917E90E;
	Mon, 27 May 2024 19:07:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836829; cv=none; b=bWjzojJiqqHOk4SZ2ZN4A42KmbtSKuyhS5vcMcXxr5FPJ2dT8g62fMcSZw18UNRK5XPoph8ZXfy2UYD68jKIgZa0IX23iJ5RUgNyF//iUZK/Z7DKp5NqL7MFiv8GXWC+Hs9x7DOXB968EqL3ygZrc181rQ0SBXHCpEol5QGlSRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836829; c=relaxed/simple;
	bh=PQQEnlEZaHqJMDtAuLCkqcQOgItp3QeboKpZs0pna1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAPkmYcUBOnHUwdEJgKSRZoqelsfP9uv1CFjwUhDWi7XtmIg0HhZc2F/tutxNYy3jaRxRgL8ddgmiw2sSTmdIL7XRo8P7nR2p2cVyZ1Z2706DuSTSaTY/x3PpxZtXL8f/hzPUj+fscuY91Wv1dIX8sSQfdAGO0nSoWHbT12afpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K5Ce+Hzd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K5Ce+Hzd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6764DC2BBFC;
	Mon, 27 May 2024 19:07:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836829;
	bh=PQQEnlEZaHqJMDtAuLCkqcQOgItp3QeboKpZs0pna1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K5Ce+HzdeKjaNqjhQ8ThyrDuwtAt/+wsN1Qaivvxe037KmBJacxji2V9i7v7ppCb5
	 8eJ1No2NLCGS8aUt29+P+QpitjpSQBilB1OYM5p1SgoVdbjxIYoda+MAPvV+AlOcey
	 KKuHK83Wh1qKWgohqulpGWMi2+/pRuaeRfPVrYUY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 204/427] wifi: mt76: connac: use muar idx 0xe for non-mt799x as well
Date: Mon, 27 May 2024 20:54:11 +0200
Message-ID: <20240527185621.372491672@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit 64bfcdbe025699d3d81ec11af24bd4895c0f6ddd ]

This is expected by the firmware of older chipsets as well, though it may
not have been as strongly required as on mt799x

Fixes: 098428c400ff ("wifi: mt76: connac: set correct muar_idx for mt799x chipsets")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
index 990738a23eee5..fb8bd50eb7de8 100644
--- a/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt76_connac_mcu.c
@@ -283,7 +283,7 @@ __mt76_connac_mcu_alloc_sta_req(struct mt76_dev *dev, struct mt76_vif *mvif,
 	};
 	struct sk_buff *skb;
 
-	if (is_mt799x(dev) && wcid && !wcid->sta)
+	if (wcid && !wcid->sta)
 		hdr.muar_idx = 0xe;
 
 	mt76_connac_mcu_get_wlan_idx(dev, wcid, &hdr.wlan_idx_lo,
-- 
2.43.0



