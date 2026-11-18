Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040992;
	b=AvP7+DVet/6nNcBnix59V/7uXZCOp5PMtJzvVk8zqFVyVB+stvNvzsI9O8CfRulIUm5/
	 alDR4goUzpm4SoIKigLFg2RZAMXZ/3UpQfiwGDj2lIignhpy4JPCpIxgccf0RKi/QNP4I
	 H90KUyqiV+y207L78OJeAaoNC4gVlfeNLqMwyAob7Ze2XTCSVuvGf8pyuDFiv4dptpi7t
	 rfNfLXkV7E888WjvL315rkY9SsVQxqDtUAPhuLIBcDy+9FCFcqv+s2FOo58Fip+is1kPj
	 gJMlRMc1ydBW7a6Gc+2NRpbpb+nuZmv5VbRIYA9eXzt4bpTDH6s2gEAbVxP0/s5+TDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040992;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iw3bziydaqgoMy+2fmrtCP3qiXyI8ZuvnEN0MaOOv6U=;
	b=5j4scmfTyckgJNSbT1vkmQOvqkqVKsLB5SZFwUVKFANSxYEKTlf0eGTYBwNzcSPHRWXP
	 JLtISeOVjP+eRcJlIDnSRsdYxcbVRroc7QfiVKLE9jjmzf1RiLk0oCLGRh5bAL/YWCFKH
	 Fl8ThfMBy6ck/W3Aqb8c5ZTGyZlOYTEgbI60ZYw4Qk1riqvJWCWNGPr4jiTq3Zz3KfdFz
	 a4aSs3PE7k47OK8WaG+NptznH/enNNsqZnxHgERTVH0aZPYuy2DHlVZMACzM7Q5vRHb4v
	 mR3rZGElPFr5zgyfqYRwZCway82mR5mzcreIcri4E8f4I6l7jUzC0miXaRkt2kP7tIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="TI/QR9Xd";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 342F3606A325;
	Wed, 18 Nov 2026 22:29:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TI/QR9Xd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E2F01F000C4;
	Wed, 18 Nov 2026 22:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040992;
	bh=iw3bziydaqgoMy+2fmrtCP3qiXyI8ZuvnEN0MaOOv6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TI/QR9Xd7LTgecQHOspFhxc9aO/TScktdrPo9nKlUPN3HvU0dwRrBuNqCQpICDCmR
	 kMrURTd4Wr4wMhj7JKXZAIzhrKAekkY38O/B2RUvfPRbNWN808vGVtAFhPC+limw2S
	 s5S3dlkCgFeUHwQj6dc+Z8i4yw6Fxf+wDskJJ1NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2654/3318] wifi: mt76: mt7915: check default EEPROM firmware size before copying
Date: Wed, 18 Nov 2026 15:54:36 +0100
Message-ID: <20261118150440.663236054@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index cf9fe6b533fc2..db6b601174e70 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/eeprom.c
@@ -100,6 +100,12 @@ mt7915_eeprom_load_default(struct mt7915_dev *dev)
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



