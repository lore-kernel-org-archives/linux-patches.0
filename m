Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043350;
	b=KDwh0s61/BYjatzXJP5RKcYFy2nkk6BQnzRi7t8vhgKVMpmjZzAgXgIUXGbWXPk/sDUm
	 Z7gE2rYsVfYv1mcURBH/ugoIcuUbeJz7UMkltnODhC423rQNg736+Ahv9kOod/0MrRDBf
	 KpGOFYZ+EgEms2sQsdx1k0ysTsoxhSH4Uodk7H+e4t31uSR7OIQTidl83GQ9tSyo2mPvg
	 wpwHZ5k8iPKC1My9admGK8A0O4PqZUUO6eSeB52YNGvsC1gLVXk40N0HUF2KrvI5pREGg
	 Og8QdZkmOOTw9O7JqP2Uj6ZxtTzGmhIME+XTEIGrfJQcwe07+klbapklZs6AlT8ukSg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043350;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=P88aNMiMNt07pjdVmygx7F9D9XQfJ60L4pJ73aKi6PI=;
	b=1thXOXkRRWoAsOD7oxlSSi6P+gLMgYdjYQmCGqHD8iNf5mxbxcknwIXYdjz5xfuJq/1x
	 uIuadPbHeDPG5NxvRFrbK9YVYlxTdzdkQHrRjiuw/m7vgHXLxMdYGrkaC4NLtD+MoJ4Uo
	 2Hye/LYM8v6AGEVjJ1vARF19jc/g6ZFO7PjVY8d8buZKaWoRM2ufR6zWFGnVzdMUfeJEL
	 wM/toTg/fqVM+24C6gJPoFS2m/3NA6hf4Vc50pic0DJqV/6jN/MzUrRDPqzzht1mESiN3
	 lvMGmXp/kh+Oc2NQKkGn8Rx9GEg/BdYjG1uXUYWmbaGpGKyvgRpFQKtuLGuOPnxtZ6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uf8bGU6O;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 19FA0606A320;
	Wed, 18 Nov 2026 23:09:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uf8bGU6O
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 681441F000C7;
	Wed, 18 Nov 2026 23:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043350;
	bh=P88aNMiMNt07pjdVmygx7F9D9XQfJ60L4pJ73aKi6PI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uf8bGU6OEti0KY0UTnonVsFER1D1EH/7y/mjJOP+vS3ua3d2rfr8dImpwJgVXEt+r
	 oX5/Qm8lwiFViLqEDUJNu4qTtpTgPS35gUD8+g54qB05vMBrAX3FlhewxpnjkKw+ft
	 DrMhOq1cDlfjeJNIkKiAdnrdlr7ysrnuqXdWRYSM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ahmed Naseef <naseefkm@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0178/2857] wifi: mt76: mt7603: add 0x7592 EEPROM chip ID
Date: Wed, 18 Nov 2026 15:20:12 +0100
Message-ID: <20261118150207.761680941@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ahmed Naseef <naseefkm@gmail.com>

[ Upstream commit d16447d7470502e998d82e806ca7ed49d1baa853 ]

Some EcoNet based routers ship an on-flash EEPROM whose chip-id is
0x7592 instead of the expected 0x7603. The device probes as PCI
14c3:7603 and the hardware MT_HW_CHIPID register reports 0x7603,
independent of the EEPROM value.

This is seen across multiple EcoNet EN751221 and EN7528 based devices
(for example the Genexis Platinum 4410).

Signed-off-by: Ahmed Naseef <naseefkm@gmail.com>
Link: https://patch.msgid.link/20260719082530.3879831-1-naseefkm@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
index d951cb81df833..7d316212ac59b 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7603/eeprom.c
@@ -142,6 +142,7 @@ static int mt7603_check_eeprom(struct mt76_dev *dev)
 	case 0x7628:
 	case 0x7603:
 	case 0x7600:
+	case 0x7592:
 		return 0;
 	default:
 		return -EINVAL;
-- 
2.53.0



