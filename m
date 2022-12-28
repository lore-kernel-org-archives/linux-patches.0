Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 590C51875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:00:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A36F1C433EF;
	Wed, 28 Dec 2022 16:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243204;
	bh=+jqpNmv6ivddBBhjLhidOySKtXIXi9qBnnElMSZklDU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WAweracoKLn55azCieeCp2ynsmSSMfyCspzfI/KZEYPPjwgMhbqUlPvIKAgbt3mVc
	 eQ92Zrl1DaPA7dnGChtOnLH13xCdlko/08oAuER4I5JeG4W4Be8vtFaoMfHP82Tr+M
	 chXdum98+LUBt/znbXM2CnwidQMP3ovnFbA2ZQZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Deren Wu <deren.wu@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0462/1146] wifi: mt76: mt7921: Add missing __packed annotation of struct mt7921_clc
Date: Wed, 28 Dec 2022 15:33:21 +0100
Message-Id: <20221228144342.731416226@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Deren Wu <deren.wu@mediatek.com>

[ Upstream commit e5c6bc6f19d8c293f86b347cddab54d5a3830b38 ]

Add __packed annotation to avoid potential CLC parsing error

Fixes: 23bdc5d8cadf ("wifi: mt76: mt7921: introduce Country Location Control support")
Signed-off-by: Deren Wu <deren.wu@mediatek.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
index 2babaeff72ba..d36b940c0a07 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
+++ b/drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h
@@ -171,7 +171,7 @@ struct mt7921_clc {
 	u8 type;
 	u8 rsv[8];
 	u8 data[];
-};
+} __packed;
 
 struct mt7921_phy {
 	struct mt76_phy *mt76;
-- 
2.35.1



