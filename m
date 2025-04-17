Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC96F2566DE;
	Thu, 17 Apr 2025 18:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915804; cv=none; b=lObdOVfvCdI88e3TrZQS/N/2IiUGp4nz5ZVZRewvVyyhuJjBO9LLdfaiUj4gqDUtiO4u6nR2Ouzno8cD+S1setJIEGHcaBZc6TNEZNOM3ZO4IFGThY0J/to8DebHlgWijMtUdMysVSYazypnloYDoStZZkZUaKvGxu7ucDa8HU4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915804; c=relaxed/simple;
	bh=QNiY/afF4cKZeoeF2pIqN9O2Fk2JuyUIWkuu9lJRpjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fN8jAPfiwrHGb0Azn9oMUKHnWe8s8QkHWy6npI2cjAul9Qn1K+v3HErnpqfLwvIox3S60p+e/GIZ12+QP4JyIw7RFi7dZVBiVPBBu68HQQX7+2QHUvpl2m+KvkxIJH4iT3h1bz/XQeCAlTG7v+pvfktJ25nI6juC0t5TzCxVz1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HohrwHU1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HohrwHU1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6449C4CEF0;
	Thu, 17 Apr 2025 18:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915804;
	bh=QNiY/afF4cKZeoeF2pIqN9O2Fk2JuyUIWkuu9lJRpjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HohrwHU1VcKWfcmovJAinCXP7kCG11ann2kKCIXq3qm9m9EpReB1TbsPQ5V3+cJRH
	 yz37ZYYcnt9h04NIViopfKoUe+OR3/qtphqjhFQSq9Rb85BylrsGo6HnG2sPfyBk8r
	 zZiiKrJuygzAtSeuEN8Z+D877Ejt2tbABHP3JJiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Wang <sean.wang@mediatek.com>,
	Caleb Jorden <cjorden@gmail.com>,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 245/393] wifi: mt76: mt7925: fix the wrong simultaneous cap for MLO
Date: Thu, 17 Apr 2025 19:50:54 +0200
Message-ID: <20250417175117.447912743@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit 7dcea6fe33ee3d7cbb65baee0dd7adc76d1c9ddc upstream.

The mt7925 chip is only support a single radio, so the maximum
number of simultaneous should be 0.

Fixes: 86c051f2c418 ("wifi: mt76: mt7925: enabling MLO when the firmware supports it")
Cc: stable@vger.kernel.org
Co-developed-by: Sean Wang <sean.wang@mediatek.com>
Signed-off-by: Sean Wang <sean.wang@mediatek.com>
Tested-by: Caleb Jorden <cjorden@gmail.com>
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250305000851.493671-3-sean.wang@kernel.org
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/main.c b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
index 676882f3928e..dd886b39f550 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/main.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/main.c
@@ -256,7 +256,7 @@ int mt7925_init_mlo_caps(struct mt792x_phy *phy)
 
 	ext_capab[0].eml_capabilities = phy->eml_cap;
 	ext_capab[0].mld_capa_and_ops =
-		u16_encode_bits(1, IEEE80211_MLD_CAP_OP_MAX_SIMUL_LINKS);
+		u16_encode_bits(0, IEEE80211_MLD_CAP_OP_MAX_SIMUL_LINKS);
 
 	wiphy->flags |= WIPHY_FLAG_SUPPORTS_MLO;
 	wiphy->iftype_ext_capab = ext_capab;
-- 
2.49.0



