Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B0E13264F4;
	Sat, 12 Sep 2026 13:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789221091; cv=none; b=VwhZ4w1oAq8boCCXWezg6J2tgpn7t28/Iue99UlvXhiGOnKdODEoECy6etnrpd6XZfyTa/Ksf6j2m2yjoQvEVX7jGzFfNpBF7i0ZDc/pcRoOn+wKTIMU0HcSuRAcy/7n9ov0gYqephj8V4gPpOBlAMNKpyYNcyoB9Cles7peO/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789221091; c=relaxed/simple;
	bh=DmEpjlniHltQjeOdyZ/nfoWGJYskKLCWBZEpS9r1Utw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ta1LRHyE7Abg7laHZVEYjYCqVVWj2y2VFayzDksVm8k+2U9j4NPffCKSPhjHrla9wH296S4g4H+4CM8PLE4EvIev/fG6DCXfpqx1u4qoDCi2FuWOZ5X36zs9MX5TMJ/xyzqzhlI8426GgdCCJA582ObwVZabuha3Np+inCA+wao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NGg/FaVo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NGg/FaVo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44C451F000FF;
	Sat, 12 Sep 2026 13:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789221090;
	bh=BPwWnNq/Z3Z+xJoWN9w9P3GQoB2YocfcYNV4ZAyFalA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NGg/FaVo8bz7IQnKqXfN5ltGfboSEGU1QsOaZhcAmHpy/XPE/UtB58LsoVzWYfSa5
	 yxD+xwccRKmXXudoW52EvnaJUS8aXJOMTXtCI2AQQsDV1q1dNys1+Co0ISUxQhLmu5
	 N2Pu0mQ9ASBlxCEq6vmLmsBLyP4YaJ3A9IgHFV0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laxman Acharya Padhya <acharyalaxman8848@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0313/1424] wifi: mt76: mt7996: validate default EEPROM firmware size
Date: Sat, 12 Sep 2026 08:45:45 +0200
Message-ID: <20260912065614.293028740@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 544b6c6f1ea32..8cc1d7ae4d988 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7996/eeprom.c
@@ -43,6 +43,12 @@ mt7996_eeprom_load_default(struct mt7996_dev *dev)
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



