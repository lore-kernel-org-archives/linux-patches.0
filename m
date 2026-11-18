Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018930;
	b=ZMUFcmZ+9T8Qdi3ps8wR4y8tSzh1IYY9o15DfhPiVmiz8ypuRcyUAL6blasf7W3MOZg2
	 EFFmLopFeQLfWZqckDiEpbMBQBbji73fXsn+xwjEM120W34OWSYWaaA0eqCYwNbAvcY1J
	 kjIFaQKaqFOTHdpZRX9zzbsYSyTjxReUrlaV2yGuwM1IKq0F7tB/wWznZNXeYmAe6FNB6
	 5ohQkgpkM6qeA0SFd/uQULI5ax2odANlcn3l/VKbMOu47xwY5AC2QUdiobIC6/sga7uqa
	 6JB3gbfEY+6xGonfA1Gszxi/4F0h4r6uRSf0vFTTqBjmFxgAmjrOJexUkx1L6bi5lEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018930;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9Okn+uk+PImK9XskmSa757C9oNZxDXP5WQ4QaGMOzJk=;
	b=TaCZmFhBJzPK8jiJBLMTDIPhvZTYuSWY2zmREx8ivu4MBH1K1YYzkSeQL1XuXly/RgZ/
	 96BOt29r/k25OgFXiNJOMevtljBd+eM5B2Lz+15UPnA8xyDF2UA1DNe05Q5YhuHCjnE0c
	 swO2YDIZtgo+yL261mRjubPAtORu9A4hL9s9QPalxtu0uoYiB6tu8D/vqoT45I0CZSSeJ
	 1f8JMI8d5a7D4m5eItRU7CJVKi0mVscoPAhmRKW8Fw9t47GHW3wnQ4EWNZenybi3Cp0ND
	 zP0tl6jM1CK6+k/Jk8FtL6MeAC9RveoXJDQuE1N+wa3yIqIVQploDG+EwI04tC1v5cA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lRfjwl7p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C13606A320;
	Wed, 18 Nov 2026 16:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lRfjwl7p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48C911F000C7;
	Wed, 18 Nov 2026 16:22:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018929;
	bh=9Okn+uk+PImK9XskmSa757C9oNZxDXP5WQ4QaGMOzJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRfjwl7p2ElsfrPnM68WlVNYdvNS47hqVSuxA5v51uLPLJKX+Q5ScoKd8v+blIUzJ
	 VewwSI2xlUYcvOrNWfnsSf8/i4CD56ZEyLyA973JYey0HvB/6ZqsAF7jHjxi4y/ej/
	 5m1iwS8jxWKDbfAUPbnEp9KQhhOsh6RPw011qjEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1415/2651] wifi: mt76: mt7915: unregister thermal cooling device on hwmon failure
Date: Wed, 18 Nov 2026 15:44:15 +0100
Message-ID: <20261118150338.947989159@linuxfoundation.org>
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
index c8e389db63a77..df056e06d907d 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7915/init.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7915/init.c
@@ -248,7 +248,12 @@ static int mt7915_thermal_init(struct mt7915_phy *phy)
 
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



