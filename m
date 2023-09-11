Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B96E1170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 13:55:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A5BFC433C9;
	Mon, 11 Sep 2023 13:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694440548;
	bh=Fk9J8vV0GWVR1rpem+YjoSi6Wb7zhGKdyMVvRjATeQw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzaClCLM8rayvnDwDUHykbYpljp4opuflOITzf4aRKmWtpqLfSKYeSvIxEPpsYWZt
	 r56Psr7UVACV9pf96ODeI6IsxL+XYgat351Qqk3B+POwcnsqytxD8nbJQtNePOSo21
	 Lz5jDMENwgE5nNonQ1vwLHDZDTLXdH/hLxI4/97A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ryder Lee <ryder.lee@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 100/739] wifi: mt76: mt7915: fix tlv length of mt7915_mcu_get_chan_mib_info
Date: Mon, 11 Sep 2023 15:38:19 +0200
Message-ID: <20230911134653.893959737@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ryder Lee <ryder.lee@mediatek.com>

[ Upstream commit 4f1875c288dfc1ccea81fc17fef1d30c9d8498b2 ]

Correct per-device TLV lengths to avoid invalid operation in firmware.
(  64.040375:28:STATS-E)statsGetSingleHWCounter: MIB counter index = 65472 not supported.
This happens on mt7916/mt7986.

Fixes: b0bfa00595be ("wifi: mt76: mt7915: improve accuracy of time_busy calculation")
Signed-off-by: Ryder Lee <ryder.lee@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
index a325066bf57e9..1a8611c6b684d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/mcu.c
@@ -3000,7 +3000,7 @@ int mt7915_mcu_get_chan_mib_info(struct mt7915_phy *phy, bool chan_switch)
 	}
 
 	ret = mt76_mcu_send_and_get_msg(&dev->mt76, MCU_EXT_CMD(GET_MIB_INFO),
-					req, sizeof(req), true, &skb);
+					req, len * sizeof(req[0]), true, &skb);
 	if (ret)
 		return ret;
 
-- 
2.40.1



