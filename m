Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025771;
	b=NbRthejNJj+opNYV7GG8aBuqQm6IhR+oOuwwVvfP1ZGmz6uYZZkHgZJOX+WpPqOcDG57
	 FoNoKe8uPVjwymh7pLKig08oFUqFUXsrky9EK2TjwfdUYdVPNxamQQ5Js9d5DhpC+g3qr
	 9BzY770svkNW30JE3ysuxvcOMY+3n4ExOKlM7LTAcYwM7GLwLDbwShv2+NJDoUwT5txWJ
	 FRvfZjEcHoiO1vvx/9ryqiiqdSEaQchExgD1D47zjah7up1pGHWGV24OIXuZ6TETeaDYi
	 5q5X6l3be4m19kGVEoZERyK+Z1WVLmGW5IbCnyLLdPpgtwwHjIThAyEhxPdZLfoivFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5CDKj9nW88SK2YQa+DVqDHAxbhLd586lJa6HWUEEsfg=;
	b=KzoA9tyyvaM4spwyxdp3b00roz11uMXMlLeLiLufhCu5PqHCFsN8EWjGltE+vaQ2hJC1
	 wXHLu1MmMHzYdo6+zrVp4SjSmOQKvnBXTinV9HX1sQEj4nyJuD5+C/EFZR2ArBlrNqZ8H
	 1kI0bNJxb+sR8f+QwNl/Jk+HGaZbXdMFkJm15Q9bVf25djSz2Oqv7z62PS669ggLAdkb7
	 9sBQUMUfR4gyEQsXk1xccVeAlJWS7vVshMi+Zc1xtest6FdGpFAIhEy4laL5MGqsPO2b7
	 3rZxjqb4eMi9P35pkyyh/X6AoTsX7J8MC9hld5eQF7WgG33m4z5magBDZ1iJzmcYCSQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3oIdMxG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F12A2606A334;
	Wed, 18 Nov 2026 18:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t3oIdMxG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F1AB1F000C4;
	Wed, 18 Nov 2026 18:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025770;
	bh=5CDKj9nW88SK2YQa+DVqDHAxbhLd586lJa6HWUEEsfg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t3oIdMxG+nzzlorNXlLqEsV6peGWYJjTxJDYhioMqJ9JeO7KqTFyj0+o0FzW2DId/
	 N7vdTwt+sZb9dSIZZo8Okuj0HzwDz5FPmCTtfM5AyI9D/GZC8yuKrlhyD3UW4+7RHH
	 djacm7kRVOC3UOL0C8D0QyGobU2aw3vdBft6js5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1195/2151] wifi: mt76: mt7915: check default EEPROM firmware size before copying
Date: Wed, 18 Nov 2026 15:48:50 +0100
Message-ID: <20261118150205.745323546@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



