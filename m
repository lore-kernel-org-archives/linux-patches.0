Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4C674680
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:42:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBE6C433C7;
	Wed,  9 Aug 2023 11:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691581359;
	bh=oKCU0b80Fkxv+wtHtpr+aY9PazGyC3X6zg4+x5rW0UY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/Ttmi0qN6FL4IKJo3Q8GqtJ8/PQckrQskjDgAnHb3rOKNSz9yGeTJ4qgBJDr3KSa
	 skC24k1PHMKk7+vbN9WLiHODNlkLYYKq5Ppw26YKGk9BnezL2eUxs9nUJxqywjjGa0
	 vvs2oNqwXkWtnDRLdQLX/bNpwFCVpK3HbQXmtdN0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/201] mt76: mt7615: Fix fall-through warnings for Clang
Date: Wed,  9 Aug 2023 12:43:19 +0200
Message-ID: <20230809103650.484652885@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103643.799166053@linuxfoundation.org>
References: <20230809103643.799166053@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gustavo A. R. Silva <gustavoars@kernel.org>

[ Upstream commit f12758f6f929dbcd37abdb1d91d245539eca48f8 ]

In preparation to enable -Wimplicit-fallthrough for Clang, fix a
warning by replacing a /* fall through */ comment with the new
pseudo-keyword macro fallthrough; instead of letting the code fall
through to the next case.

Notice that Clang doesn't recognize /* fall through */ comments as
implicit fall-through markings.

Link: https://github.com/KSPP/linux/issues/115
Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Stable-dep-of: 421033deb915 ("wifi: mt76: mt7615: do not advertise 5 GHz on first phy of MT7615D (DBDC)")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
index 714d1ff69c560..48ce24f0f77b7 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -128,7 +128,7 @@ mt7615_eeprom_parse_hw_band_cap(struct mt7615_dev *dev)
 		break;
 	case MT_EE_DBDC:
 		dev->dbdc_support = true;
-		/* fall through */
+		fallthrough;
 	default:
 		dev->mphy.cap.has_2ghz = true;
 		dev->mphy.cap.has_5ghz = true;
-- 
2.40.1



