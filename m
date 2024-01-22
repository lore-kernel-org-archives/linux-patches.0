Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFF4614D42C;
	Tue, 23 Jan 2024 00:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969288; cv=none; b=Y8H8qF0y8g+uRzcmn2+Ggi6PWyRCDdm6IVOQmGMfO6RzUEJ4t7qDPUusTa2vHtdlsHd5r7KJTdJ2glkVQ+FNUCtzV+QtAq6sHljnY8w5fNzrtjRPxeM9i2PRuszPyN8iTQRxq5SWGe41mWVEQagwWeQY3mUJiWbzSE5EThuUdYs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969288; c=relaxed/simple;
	bh=uAQCxwDWmZgAzVU+u7NLxQYyglvhp9W0A/jPy6T9YhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uC3nosVyFJvQIRg12E/kLOkzhS2E2ohQJmskU6LEBVaE/6MaMU4TFiQdDy1sFt7ZjB9rrsFEcRO5TE9ZdmnZLuEqb10/VdchyawFW5oWjm46wg5rdlOYmNEMn8rIlZ+33LbvRX5LZ0sPdJMZIA2vSTQPKU971n2UFVYh9YMCwSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RVsWViEw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RVsWViEw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75768C433F1;
	Tue, 23 Jan 2024 00:21:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969287;
	bh=uAQCxwDWmZgAzVU+u7NLxQYyglvhp9W0A/jPy6T9YhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RVsWViEwQNAP2xjD9DRuBuenV5WWOWibYmalEQUG28Iu1/5TtsHCHhP35OoiP9Jrl
	 pnmhLen/4of51Fi/w2XaXLHeSptooOvd8HjVWLR20Bysh6Oy5Ej0MbN0Ph4zbWYoTn
	 /AGOJyuVzhiXwoVf+NbqVYnmRasoICLqjWB2YV5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Marangi <ansuelsmth@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 147/641] wifi: mt76: fix typo in mt76_get_of_eeprom_from_nvmem function
Date: Mon, 22 Jan 2024 15:50:51 -0800
Message-ID: <20240122235822.643246395@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

[ Upstream commit c33e5f4cbb9f961e66473a9ace077c4d1f29a5bb ]

Fix typo in mt76_get_of_eeprom_from_nvmem where eeprom was misspelled as
epprom.

Fixes: 5bef3a406c6e ("wifi: mt76: add support for providing eeprom in nvmem cells")
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/eeprom.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/eeprom.c b/drivers/net/wireless/mediatek/mt76/eeprom.c
index 7725dd6763ef..be55c7e0aff1 100644
--- a/drivers/net/wireless/mediatek/mt76/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/eeprom.c
@@ -106,7 +106,7 @@ static int mt76_get_of_epprom_from_mtd(struct mt76_dev *dev, void *eep, int offs
 #endif
 }
 
-static int mt76_get_of_epprom_from_nvmem(struct mt76_dev *dev, void *eep, int len)
+static int mt76_get_of_eeprom_from_nvmem(struct mt76_dev *dev, void *eep, int len)
 {
 	struct device_node *np = dev->dev->of_node;
 	struct nvmem_cell *cell;
@@ -153,7 +153,7 @@ int mt76_get_of_eeprom(struct mt76_dev *dev, void *eep, int offset, int len)
 	if (!ret)
 		return 0;
 
-	return mt76_get_of_epprom_from_nvmem(dev, eep, len);
+	return mt76_get_of_eeprom_from_nvmem(dev, eep, len);
 }
 EXPORT_SYMBOL_GPL(mt76_get_of_eeprom);
 
-- 
2.43.0



