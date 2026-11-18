Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031132;
	b=Q6gmROvR3LbYqi1rdcaSfcPmkJ77U3tODwTXNHe6lvYz+EyJ0jfnlNM9cQg12aEAhja9
	 mypDPaQxmh9WeGbeqi+VfQ0fD0YiELuEeAjS8w/quRBgmn7Y+B4AiD9cP7aDRpdK6pqxV
	 J9bebTkN3YKVR3TfmUoY+zL84sk4MLBUUs5DXS6lopgviVF/rjmaj0E6xzCsvFNT9lzLV
	 k6q6w3Z3b2t8GoQKAKpMQv1FxvpEyGbuWE+p4fJAWDMJ3ivQfyEKJXEtg246zHetRJeW1
	 heOZsZhwXAt32VYniF+3jA7pjb90Jj+gGgxb0BkINteYqhWoSTo8omeIqRvyAM8wKWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031132;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=E5GAgTjnNf3gbt44054uAo6S0xcMSYs/7n26Ssn1k6Y=;
	b=W4NDvvNour+SC83pz/n24GyUB5w56v4O1R8TAxST+Fy/aIzo9FstcxdgsbfwONf8qDCl
	 e5Bb87X14Dbxoj24w1+fc5AgsxWP0zIvskwDSySwYkdBf+gv0+TyqzaWtd9Bq+vOOUdKS
	 yqGqDDzg2WbQFkSbOsdMvpKJC4YYli4O6uCbJXhzf1D/6Nv2x/3TLRVvw6A/oNXlcPNY9
	 T+SXuV8o//X2PNLzQLRlSU84dtjzI9atmcskMa0HvcE5x5qOmPVZcbjueG/rhLTCNY9pp
	 lSioJ00XJ3d+fQy01IMH422UYtZ1N4EVDho4hVz4kPB+SQU59o7IHiXvskOPjQnixcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQkH6gNA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D6A8606A325;
	Wed, 18 Nov 2026 19:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fQkH6gNA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A07C81F000C4;
	Wed, 18 Nov 2026 19:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031132;
	bh=E5GAgTjnNf3gbt44054uAo6S0xcMSYs/7n26Ssn1k6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fQkH6gNAm3roHEVU3aU/g2EtG4ncEN3S85ELYAE4oS4CJ2eXLEw8YvuRu4lQ5DCQM
	 3zehyB8c1Ia7lJWeWwBxXmaveWiXfRpWgR+W+CbJRKYmPdA2nKi5t/mENAFL0U9shY
	 qlbz53izkusbSdsiO63jxkoE6L88w05TApCaHg2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0950/1756] wifi: mt76: mt7915: unregister thermal cooling device on hwmon failure
Date: Wed, 18 Nov 2026 15:51:17 +0100
Message-ID: <20261118150047.904850517@linuxfoundation.org>
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
index cd18540dc98ae..b7a5dcfd27848 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -215,7 +215,12 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 
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



