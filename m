Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 682383F788A;
	Sat, 12 Sep 2026 11:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789213087; cv=none; b=j+K1aPbwV0vvBfJp2WW3j8VQhSaZc0lkXMm5JqeVId+zLwdNKHt3TiOOsxpDMA4vrnbqGCNnRkGXOEBdy9XSFB2far5dSVrCAyiX6toMgmoLNVRhld3x1QBNVp0PE/X/RiZf4NRH4UbiYL0KX8UZK5CU7hMb5dw1Wxfd9f/+JYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789213087; c=relaxed/simple;
	bh=NdPoOkwrlMUaFh/7YTR88OspGDXE0Tj3CCQEYLSJQs8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gir7a4ZMriAf7IcmYrDfTb+hw41v79oF7NSktXPwNldBuhp+9pxA4u35HQQPrZjRoqZTBnMSWbDJtMGpTidtDiybB5j4HnZRbojBZM10YN2bdse7/0iQ4/iiY6HyuySCBRSkokOdc8FpV+myWySnlK3FFSyMmF+f26z9nUIFCiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sLwceR5H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sLwceR5H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 229661F00893;
	Sat, 12 Sep 2026 11:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789213086;
	bh=H7EsXcIE2OkmWykzuAm7sOd2HAQfsqeuAzuiWSzWo20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sLwceR5HRENrXIONr3KUSYfpP+HEIwYtb5OoV6SOzqks8d5JH0GT3bHlmy2U1I9bP
	 PYn99QW9NJcBX6xJhPpylOTJqfEwb9GtVs38UZw7Lzmw6kqBQE1HvH1ZSQ8iN1Ty3d
	 CWDnvnuwdvo9geL2+3phja7muxWL+8mzTnyLyB9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0008/1376] wifi: mt76: mt7996: validate default EEPROM firmware size
Date: Sat, 12 Sep 2026 08:40:34 +0200
Message-ID: <20260912065607.735767294@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>

[ Upstream commit 653c6e289b13cc6942f3e8f8e3c568e70fa42d1f ]

The default EEPROM firmware is parsed and copied as a full EEPROM
without checking its length. A truncated file can make the driver
read beyond the firmware buffer during variant validation or the
fallback copy.

Reject files shorter than MT7996_EEPROM_SIZE before parsing or
copying the firmware.

Fixes: 98686cd21624 ("wifi: mt76: mt7996: add driver for MediaTek Wi-Fi 7 (802.11be) devices")
Cc: stable@vger.kernel.org
Signed-off-by: Laxman Acharya Padhya <acharyalaxman8848@gmail.com>
Link: https://patch.msgid.link/20260713115412.67095-1-acharyalaxman8848@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
index 4c4ab0d4065d2..a14d1d2849b64 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
@@ -51,6 +51,12 @@ mt7996_eeprom_load_default(struct mt7996_dev *dev)
 		goto out;
 	}
 
+	if (fw->size < MT7996_EEPROM_SIZE) {
+		dev_err(dev->mt76.dev, "Invalid default bin size\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	memcpy(eeprom, fw->data, MT7996_EEPROM_SIZE);
 	dev->flash_mode = true;
 
-- 
2.53.0



