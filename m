Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019054;
	b=hrDblHg+JO/yqBFI6WHHZyZMg72oDG0XcFM2RMnxfogAqqPsxv+CmmJn0kXRXRKM8LQ+
	 nSYTEIN6uq6sJdSD6EFqORFUjk6hrLGxCTH0CEl4moNFDP/+D1WmpHCRcsj4nz76fr4TQ
	 +q+DpeOX0sa64i7Qveb0vVa+sJCMn9xIgs2vjEdnBdtiCaOyP/G3q/5FsU/DzGaitjoKZ
	 jHpuS7qv+sA1WS+y2n7Cz/8Asz3f0mjSwpD03rCADjGZm+0gw8xZsmBMrzTOBRgc4ZV1l
	 /1DzPhtPR3RyLQccoEEwWxn2I1hxSV0QdhFZ2QhdfzTPI/AAtDkdjtz9Lt5YQ7PFtcg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019054;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8mY2/s/KR4u8a+666IMr7RJMcFjK+kUdI5yZoGILABk=;
	b=LjsMY5ruzIKN5WR/ePIQY2mWcoPtg+41NmPjYb8uPDyADamrfHJ0CfsqXviooLU3F9kC
	 QSIIi3DLb2p1Ngw16mPYhyX1ZJCHG/TZyCpq6CNYJLxfmJOtSF4D/waCOqReWaOFpBaGk
	 ArcQbVSIaYeDA+OC+iPyWNsI4b6ec0JHmMmiqKK58F96rHM6REoY3EcAZZJ7COmtLgRCT
	 D3cCHufXrFtX8nrUp0WttAquUM9PV52BN5JbQ+P5GD3Gqrcz+JZEHHuZypW8Z+VIZRkh0
	 cAPZWAXVT/GIswU3jyBstfL/fXcpfP8SZ/cnLfdHBzcOM3JGGBu1cVTngJ9rdEnzWWg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKEqkhtS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D898606A31C;
	Wed, 18 Nov 2026 16:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RKEqkhtS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F34821F000C6;
	Wed, 18 Nov 2026 16:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019054;
	bh=8mY2/s/KR4u8a+666IMr7RJMcFjK+kUdI5yZoGILABk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RKEqkhtSOxtwfNOCWAkaXVU1WaxP7hcVsm7uW12efb1W7PPd1vP6VIeBv6Q2hvNzn
	 HJlT58GJCjHQkBscZVbVR8GduFufuDkRmKEKlBpWV0pnOfi8zVu1uBe1lVeGLrCD5b
	 mqCbolewi2BZSJ1oUb0whDvKYaLrZk79MiE4HvNI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ethan Tidmore <ethantidmore06@gmail.com>,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1459/2651] wifi: mt76: mt7925: Remove useless condition
Date: Wed, 18 Nov 2026 15:44:59 +0100
Message-ID: <20261118150340.559334425@linuxfoundation.org>
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

From: Ethan Tidmore <ethantidmore06@gmail.com>

[ Upstream commit 8db0381351fe6af82f81693d5085790e291b2f17 ]

The condition (master_pref > NAN_MAX_MASTER_PREFERENCE) will always be
false because the variable 'master_pref' is of type u8 and the macro
'NAN_MAX_MASTER_PREFERENCE' is equal to 255.

Fixes: a5487a6824068 ("wifi: mt76: mt7925: add NAN MCU helpers")
Signed-off-by: Ethan Tidmore <ethantidmore06@gmail.com>
Link: https://patch.msgid.link/20260818015440.875703-1-ethantidmore06@gmail.com
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7925/nan.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
index 1adef4d52f655..ce2571832c08f 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7925/nan.c
@@ -91,9 +91,6 @@ mt7925_nan_mp_tlv(struct sk_buff *skb, u8 master_pref)
 
 	mp_tlv = (struct mt7925_nan_master_preference_tlv *)tlv;
 
-	if (master_pref > NAN_MAX_MASTER_PREFERENCE)
-		return 0;
-
 	mp_tlv->master_preference = master_pref;
 
 	return 0;
-- 
2.53.0



