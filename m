Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD69B3C8C7D;
	Tue, 12 May 2026 17:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607774; cv=none; b=A3O840bF098Lq70qq1N6YnyGOS8dg+JJoyTDssaXTBl2yohsE5v+hYqwnlqUe1iHTt0+Eg7ssVyKfDLM83KB+MixOEpMGx2DTO5acBKt/3L3hmtseZVtZMufTAytg/p5uHlcMgcCaX2AQjUS5BOQGazK00IfzI39LNShLIrb6O4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607774; c=relaxed/simple;
	bh=oDjnnW3cwCcqMFaI26hQmk0ol3wVF8XWIB99/MDSy8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5Ec3bgWhAMA6FLVYqGF5bbVe8BN3LVm2tcLBgax6FsT7bzWZPdoMWVYDlaguV2Wl6NUWfmA94sGp5QmllRcw4sqlotU454gzRJZZT189jEfU60Xorz1VcqRV4PfSDjQ1dbc0Ewm8Tp+2rmGexH26bhRbw8GLTFvxWbSCyt/QXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QFmLi0Zx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QFmLi0Zx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11D92C2BCB0;
	Tue, 12 May 2026 17:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607774;
	bh=oDjnnW3cwCcqMFaI26hQmk0ol3wVF8XWIB99/MDSy8s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QFmLi0ZxO15YGTZnRUtNU6kXoIhxcyjSDfgEQZyHrjwRohqWACd5WV6iWZQcSapX8
	 QK1i6ZQtgDmfUXen+N5lqLfGrh376JfhI8FQkZnuAj2IKyX6NPPTQspBzLtelJYmvN
	 0qar98QAp2/WMeOeDmCApSbrYo6KFwyIPNAjUnPI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Yen Hsieh <mingyen.hsieh@mediatek.com>,
	Felix Fietkau <nbd@nbd.name>
Subject: [PATCH 6.12 030/206] wifi: mt76: mt7925: fix incorrect length field in txpower command
Date: Tue, 12 May 2026 19:38:02 +0200
Message-ID: <20260512173933.467551349@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>

commit ccb186326bb6b7f20d77982f855568e7087ad0d7 upstream.

Set `tx_power_tlv->len` to `msg_len` instead of `sizeof(*tx_power_tlv)`
to ensure the correct message length is sent to firmware.

Cc: stable@vger.kernel.org
Fixes: c948b5da6bbe ("wifi: mt76: mt7925: add Mediatek Wi-Fi7 driver for mt7925 chips")
Signed-off-by: Ming Yen Hsieh <mingyen.hsieh@mediatek.com>
Link: https://patch.msgid.link/20250908072526.1833938-1-mingyen.hsieh@mediatek.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/mcu.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/mcu.c
@@ -3595,7 +3595,7 @@ mt7925_mcu_rate_txpower_band(struct mt76
 		memcpy(tx_power_tlv->alpha2, dev->alpha2, sizeof(dev->alpha2));
 		tx_power_tlv->n_chan = num_ch;
 		tx_power_tlv->tag = cpu_to_le16(0x1);
-		tx_power_tlv->len = cpu_to_le16(sizeof(*tx_power_tlv));
+		tx_power_tlv->len = cpu_to_le16(msg_len);
 
 		switch (band) {
 		case NL80211_BAND_2GHZ:


