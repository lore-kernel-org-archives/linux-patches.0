Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031126;
	b=oRl9nR9ZOTqnUJFYuMdq24nOHsdpckz4n4zP/yYBksHkPa4JHxKhI9um60fqTr6BteF5
	 +rmf5sUqJ0xOqe8sVwqpN0p/PSDoNBUz+inrDlnHK0OtJhxfM94hMDjfxENh4h3vl1JBX
	 AaBCmuM3JDIIMQgnI0xzKoB1GufDzCpMhugjsiHg3HU8TBpAASn5ddSVEsHLfAl3JJ7x6
	 +9PQXxExhrV7vFyW1HUPPGNSQ9XLt6ntCjrcTC04l9KDdUIlqHQzWaCWO6JdIFoVRhZgj
	 18wRNNEF/YXVQMCXg7xdOFoIdNHlwwpQ4P5hFQieyfKjvIDg753+18EP7otU0EWwa+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031126;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JjjgR6LGYpJFbOX7BZrpi5O+FGxBDkEndEHCy+qnsGU=;
	b=cq6mPcqERSZPPcwkzX8/GEh+GvA6G+uC1ioOUf/Sq7Xp8fbO2llTKvaUwVj35lVlTwqe
	 Z5rgxDbPHQChsgfFwv22xqa/We21aycBWc4kX/WrsOu3drhb8AEa9OgV8V09w+6TarIXz
	 SkTya3vXfNuYWFvmMmAmMSEmJx7JKaYpecnA5cGqGj6SpgHHvRTRDUdbw6Se6ym1Rua2m
	 Tl/qTxDDhRaxMGgAGMqnmISP6yxin6LvN0aMmXPnCrKW8Q9Hl5WsXalW7XrtTCi1/4iL/
	 UHT5hAKbel4aAafPD5tUzxWwsn8LbaVsCI9OpNfSvK7+VHuUFLQ1sjX/s/MOTVGAX6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXAYfbk9;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D847F606A31C;
	Wed, 18 Nov 2026 19:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gXAYfbk9
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21EF31F000CE;
	Wed, 18 Nov 2026 19:45:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031126;
	bh=JjjgR6LGYpJFbOX7BZrpi5O+FGxBDkEndEHCy+qnsGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gXAYfbk9Y8D+zwT+VG+Njy+cvFOu9RU5ZtFBIUmGeDCwEUZuw0C/eCwe4aX30FvN7
	 LRcd7Ch3ZmHTu9gVx5g20Fi2k2n4hNCJ6FAVOYyb8CpZsKys/EdjW+DnpP1/vQpG4v
	 EuHB/VCWEA1/d8iMzbgKMKWhqQmZOkIjxLcLqCGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0948/1756] wifi: mt76: mt7915: check default EEPROM firmware size before copying
Date: Wed, 18 Nov 2026 15:51:15 +0100
Message-ID: <20261118150047.816492206@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Felix Fietkau <nbd@nbd.name>

[ Upstream commit bce4aef211b3941af9ca297162406fc84f22ed5d ]

mt7915_eeprom_load_default() copied mt7915_eeprom_size() bytes from the
firmware blob after only checking that it was non-NULL. A truncated
default bin caused an out-of-bounds read past the firmware buffer into
the EEPROM image. Reject a blob smaller than the EEPROM size.

Fixes: beed8bea8d74 ("mt76: mt7915: add mt7916 calibrated data support")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
index 14c0770229bc5..c636b082f0334 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -111,6 +111,12 @@ mt7915_eeprom_load_default(struct mt7915_dev *dev)
 		goto out;
 	}
 
+	if (fw->size < mt7915_eeprom_size(dev)) {
+		dev_err(dev->mt76.dev, "Invalid default bin size\n");
+		ret = -EINVAL;
+		goto out;
+	}
+
 	memcpy(eeprom, fw->data, mt7915_eeprom_size(dev));
 	dev->flash_mode = true;
 
-- 
2.53.0



