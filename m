Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 948781774C
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C46C433CB;
	Wed,  9 Aug 2023 10:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578508;
	bh=3dEDVbdhzYppG5QtshsMYo3jqNivFQ9szDW09FHrRAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3NVS2ktMCpkyhVl1tH4ztuxvt+uCdfLUM1RHznqmqsGXvJfDLcEQVtzALfg/wboL
	 ke19s9RUc/4wvuuKe2oy6Tby9gD/1hb9iYKHcfJ/CHaR3fN2aIcHMoeldPtz3Xlm8Y
	 IKFVigxWFAJbhSTqDP/XPgHIF1aenOkMge9au4Wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rani Hod <rani.hod@gmail.com>,
	Paul Fertser <fercerpav@gmail.com>,
	Simon Horman <simon.horman@corigine.com>,
	Felix Fietkau <nbd@nbd.name>,
	Kalle Valo <kvalo@kernel.org>
Subject: [PATCH 6.1 085/127] wifi: mt76: mt7615: do not advertise 5 GHz on first phy of MT7615D (DBDC)
Date: Wed,  9 Aug 2023 12:41:12 +0200
Message-ID: <20230809103639.471391738@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.615294317@linuxfoundation.org>
References: <20230809103636.615294317@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Paul Fertser <fercerpav@gmail.com>

commit 421033deb91521aa6a9255e495cb106741a52275 upstream.

On DBDC devices the first (internal) phy is only capable of using
2.4 GHz band, and the 5 GHz band is exposed via a separate phy object,
so avoid the false advertising.

Reported-by: Rani Hod <rani.hod@gmail.com>
Closes: https://github.com/openwrt/openwrt/pull/12361
Fixes: 7660a1bd0c22 ("mt76: mt7615: register ext_phy if DBDC is detected")
Cc: stable@vger.kernel.org
Signed-off-by: Paul Fertser <fercerpav@gmail.com>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Acked-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230605073408.8699-1-fercerpav@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/eeprom.c
@@ -123,12 +123,12 @@ mt7615_eeprom_parse_hw_band_cap(struct m
 	case MT_EE_5GHZ:
 		dev->mphy.cap.has_5ghz = true;
 		break;
-	case MT_EE_2GHZ:
-		dev->mphy.cap.has_2ghz = true;
-		break;
 	case MT_EE_DBDC:
 		dev->dbdc_support = true;
 		fallthrough;
+	case MT_EE_2GHZ:
+		dev->mphy.cap.has_2ghz = true;
+		break;
 	default:
 		dev->mphy.cap.has_2ghz = true;
 		dev->mphy.cap.has_5ghz = true;


