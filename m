Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018924;
	b=m2rHn9KQIR6pIXILsWBNannQX1xw6d8Isep18gUWZnY1bDmg/EyO1gOjz6pvtimOp6UG
	 KUSPCCL+vVsSoYI+DV9Oaqa3BDTqITc7G+ACk+4r+8zTOqNQfUKx//BMOtCtjnQQPicqk
	 +MGuWTDI8AUO9bMX228IlNIzNT1CxtTrNbn0PGxdxMi6tysqLrTvME0ngiXMfwmzE3faF
	 JfE5bpgdziH1HDPzzmzOCx0h/jtOKI0iVfZoYLcy1+x4a8zy/pbQCtMR/ESisJHRksXm7
	 dxsVuvGePjr6/ruDwahyp2j2rTcEtfxpn21fKjtn4IvQz+CRDiCw9A+w4LoclfYtrlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018924;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=LS1UZy8O/lQIjpSamMGygCu0ew83eo/qu4e0+tSI44s=;
	b=cFY8vKVHqYiMldROhho84WLApvbX7bDpwgnUHrle7LOkU754R22zK+WYtRlooDZ4eWFg
	 a3DVuHqrIISdBKolgB17fDKdBNlH4Xtbq5r4inrs7oZ/z7jOQ+WjUEg1ab6pgrVp3kaBQ
	 cHpYjfo1qWvAHpjys5op39kQo2gqbCROKmF+7T8rIxsR6w8IS69r/ZzKPY6XPa4rTX7xY
	 OHexNLHP5XEWKl3Zvhc767EnYbGZ33zM+mRyEPIbgQKLsyMZ+cycYrXiWmbl9binQ3tIL
	 q8UI/BuBGzX6q3p95lngn1Zg/81zEBZ8uX+o6gE6hY3C40BLrZ3uptUvihxXIleHF8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DjleGqII;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6267F606A320;
	Wed, 18 Nov 2026 16:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DjleGqII
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A851F000C6;
	Wed, 18 Nov 2026 16:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018924;
	bh=LS1UZy8O/lQIjpSamMGygCu0ew83eo/qu4e0+tSI44s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjleGqIIpHn7C7WzpCqgdnSVbAqz04b7IH42whaJUS8t6NxijqyQoqRrTqZVrYfao
	 xDIJdAojSvT6m/Wb6xVB1/lyaltc1RcyBBx7fclaElPg7AXHsJvJVqqJfznWgbrcTm
	 qVoVJdDKz9yNuFdZaeWSaoYlfYhvq/JB7TXToHmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1413/2651] wifi: mt76: mt7915: check default EEPROM firmware size before copying
Date: Wed, 18 Nov 2026 15:44:13 +0100
Message-ID: <20261118150338.871683387@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index fe7b29ebc0bfb..145d14a1012de 100644
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



