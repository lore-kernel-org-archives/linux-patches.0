Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041011;
	b=VWQs2oaul2ud6z8G0VG586o8D6+iL4/+jSPZ5PInNdtKyqV84KXtI/1C6fuwJqrIa+Ut
	 VzUsOqOVnihq5LKyEY44psed6iR8eM+4m94bgJaIcvmqE2BYVuTHAylL6S6qldHEo/pVm
	 usqklGNimOJGCKfXdQXBnbJOqRzX34Ayx25iLXKwO48FNsUFT0E12LFWzugeqxOBHQ02d
	 DnHxvyJYiyYG49a39blT1Bx0jtav6rtLcX9CwWtc6z6wwqVSagJ4ybRXbotvVUEIXpUo2
	 9mgGLA8BBWrd7IHQKl+y2w76jGwkO90l78tcmHfxc4U6+AmUc465PewEK9x0A9aFSSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041011;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dyyQMxH7IyhDzF2IfLw8Sqqh7DECKyys3+UkEq745gs=;
	b=gOrJEHjAQp05G8WF94RJV8c2XWiaWwCEoMSGfQqQdqov1jIFhma9qocoPPnvsWHGHe5P
	 vnXTFn4gCEeBy+j91i87hzhDzl210mMTPfm3rNBhDqimS8BnBNuIj8n8872bvVa37s/Up
	 4rJ917RGd4P5wq3LHckjUhOA38NPK1uQHMelePPeI/N7BK5e8lhFb28LA0ycvOgV6BqEY
	 QFpnuKtkLkAAUdg3SFOtxEQvIWEYJFraQ/S9OCqmddDxldSGQgkB9mjXxwDUo6MMK1xib
	 XD357LRWrwoeY0WakDCmercVtjV4D/ed7dcBEyNlV6SAB+ixKWI3UvMi95BiwSs+lDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEXU0JfN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69E060A2603;
	Wed, 18 Nov 2026 22:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DEXU0JfN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9051F000C7;
	Wed, 18 Nov 2026 22:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041011;
	bh=dyyQMxH7IyhDzF2IfLw8Sqqh7DECKyys3+UkEq745gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DEXU0JfNfiZj5UMfoLhcq1IPtG4rootK8zKZdrTcmxtCv0/zak/b3O7HCLON7TV8p
	 mgbf3exZpwnR8IdyQyb9k7a+HdXc2Sk4egKj5evYbvTuz5JlffJwTZJ5CNhvvcDlGq
	 URiQqsAPLJ95c5O2o0/NgdvdZieZkqu3QKtP90NE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Fietkau <nbd@nbd.name>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2660/3318] wifi: mt76: mt7915: unregister thermal cooling device on hwmon failure
Date: Wed, 18 Nov 2026 15:54:42 +0100
Message-ID: <20261118150440.830752816@linuxfoundation.org>
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
index 8d7d828e28206..3279b459be4c7 100644
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



