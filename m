Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025790;
	b=5XQI6K5fQPbXGHGy5I85EnKqej6OF2i9bVpige1WY4M/R1nF5zQmEufq+inveywZEWg4
	 JJES2KceSLQt32iJr5hP2TzU8fwKxSRF0U+h1wNqDY2f2Khp6yQTq4tau8WpsFnm8zjYS
	 cTBd5cqa9FCUTE8mli9sR5/4wscXyxIIewYoVRm4LPF3KNuWMEjgydMFwgsfiCO9nC7YQ
	 8KbD/iQGY9Khb8ZWmVXIFFmMO++7tjpdPmnIHGt642IrACIqpf74wzscl92dciT2v2yPw
	 NhYnM8mOWsg9oF+KMzJGabWv1hsppD9ylHb+HYlxLMTdiryyuzcHdxbA3c+MCzR4S9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025790;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=besuXutXUKHXLomkafXUnAOj+TDlF/D+NCwUvLSOG7o=;
	b=kI51Br1bTSXljqfriK8Jt/kDbRqplCb/qzM/Mbkep0bmiIyCgYf+1Ri4QdUZLB/wk7/r
	 ZW+AdPSITwBNAzjgUbDQeAmnmpHd3g/kfpGAgl4S8gQSd6hDCLOLNCEUynhsAGzJxsoLK
	 jT++Oo4e5emr0ydaYgkAbxRcGJZC/DlUcdeqvushYk3LQBKAU96ersH2CZxXxVXkfpx6y
	 veXc68iI9y24NCkFgU8LPwOeyIRflfNZcxcY5PNZ7DuaxNhyGx0W+SPi1shk5f/NCfAnk
	 A5zFw0KZqPdiDrzGNDjO0mQhiXKKEn8TBBWg+JhpDIT/ES8HDSo2uZDqXK2F8bgJNRw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJnNPbLa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3CE6606A331;
	Wed, 18 Nov 2026 18:16:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OJnNPbLa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE3C1F000C4;
	Wed, 18 Nov 2026 18:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025790;
	bh=besuXutXUKHXLomkafXUnAOj+TDlF/D+NCwUvLSOG7o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJnNPbLanAvh4sLDahE1pNGAQB8KT1DdKcFcnX2LqVzB8BQvIvh8x86uX2GHuoR4E
	 6BspBZPs8Wtj5DVUkqeJFhL3iOVPd4YutMSrlaZdmacmfQDBOrdKMVZotx6wzataVJ
	 lGF69J0vkkQ6hFKhjmkNXV4ZPq0bdfFIVoa2C5Vc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1197/2151] wifi: mt76: mt7915: unregister thermal cooling device on hwmon failure
Date: Wed, 18 Nov 2026 15:48:52 +0100
Message-ID: <20261118150205.815001935@linuxfoundation.org>
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

[ Upstream commit b8286bc7fe520e7117e7b6e1a1fd4c0df439aa3a ]

mt7915_thermal_init() registered the thermal cooling device and its sysfs
link, then returned the hwmon registration error without undoing them.
The cooling device (not devm-managed) and the link then leaked, and its
callbacks referenced the freed phy. Unregister the cooling device before
returning the error.

Fixes: 0ae3ff568451 ("mt76: mt7915: fix hwmon temp sensor mem use-after-free")
Signed-off-by: Felix Fietkau <nbd@nbd.name>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/mediatek/mt76/mt7915/init.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7915/init.c b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
index 75fc990f2dd78..6d182460d5119 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -218,7 +218,12 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 
 	hwmon = devm_hwmon_device_register_with_groups(&wiphy->dev, name, phy,
 						       mt7915_hwmon_groups);
-	return PTR_ERR_OR_ZERO(hwmon);
+	if (IS_ERR(hwmon)) {
+		mt7915_unregister_thermal(phy);
+		return PTR_ERR(hwmon);
+	}
+
+	return 0;
 }
 
 static void mt7915_led_set_config(struct led_classdev *led_cdev,
-- 
2.53.0



