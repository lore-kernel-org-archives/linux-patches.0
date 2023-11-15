Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A81141A87
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:36:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NoXZpr8h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9ADFC433C9;
	Wed, 15 Nov 2023 19:36:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076975;
	bh=lAv+zZUYlsIkVchETUIWjUnEZI9rMZvXmO03++338rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NoXZpr8hVLmupXo0FHCwJmhwvLVWr5+1eDz6MGs/vVSScZX3V+AnBNWlOoerrhdjL
	 G7zXsgnbGFsbtJAFRrGD8OxYI1rtefPX41XylfJ9RC8VnwlIxP8iNQm2ZIJdSNy/Vb
	 m7uWOI5Gj6bXgXBGSqx+LY0ksWrI79vYrEPsvsfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Howard Hsu <howard-yh.hsu@mediatek.com>,
	Shayne Chen <shayne.chen@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/603] wifi: mt76: mt7996: fix beamform mcu cmd configuration
Date: Wed, 15 Nov 2023 14:10:29 -0500
Message-ID: <20231115191618.941184024@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Howard Hsu <howard-yh.hsu@mediatek.com>

[ Upstream commit d40fd59b7267d2e7722d3edf3935a9a9f03c0115 ]

The bf_num field represents how many bands can support beamform, so set
the value to 3, and bf_bitmap represents the bitmap of bf_num.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Signed-off-by: Howard Hsu <howard-yh.hsu@mediatek.com>
Signed-off-by: Shayne Chen <shayne.chen@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/mcu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
index 4a30db49ef33f..4ed1643818980 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/mcu.c
@@ -3307,8 +3307,8 @@ int mt7996_mcu_set_txbf(struct mt7996_dev *dev, u8 action)
 
 		tlv = mt7996_mcu_add_uni_tlv(skb, action, sizeof(*req_mod_en));
 		req_mod_en = (struct bf_mod_en_ctrl *)tlv;
-		req_mod_en->bf_num = 2;
-		req_mod_en->bf_bitmap = GENMASK(0, 0);
+		req_mod_en->bf_num = 3;
+		req_mod_en->bf_bitmap = GENMASK(2, 0);
 		break;
 	}
 	default:
-- 
2.42.0



