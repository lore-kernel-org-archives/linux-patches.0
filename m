Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016140;
	b=J9ZZYqfJlaK/0biLEcWodgyFvBuGG0u65+1PvGEUHOdIn1aeg19ZwPYU5fDC/KY3rSBB
	 LdQT+QLObQ6tAkORj28DeX+aZMWQvfnbHxsb2DwqoLmiFf27YmQfxOwSDK8XXWsRahz5d
	 D38+nGK7thfPKE3mB3dlu03GY69MwpY99ogvR35TL5CnTxmZiWPo11pLb2hiU25y7yrZp
	 XrUL2asYcSiVgLzyhIz2BkHTsz++JW8JXsABdvRimtUlVNv+A0aL7+NnCrWRRrM5BXc3d
	 hFaqZq8u5+WbatrIjstQZQ52yNYegqZ0mBWIDdnvi94h/1ahlTfx5LmBUJpHBjw3vyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OIExqzOxJNHPCfp46qZCTSKvSsxSXi65U4y4Zq56tcU=;
	b=DoxgzNxnycQSdPggRDA632A4mDi3l6QQAuyyqtFAYxrks3X9BwpKq5WgNi0GUTHZOtjk
	 hCxHbHCn+AaqglUurriOfsPsy9n3WrGyOnw974TNmo9tFeDaK4ZTc99YX4NRlr8CpfN6c
	 Yk31DVcfh0tva6PpqfiL5G7VMeQjUJDVcr/38/BzjHiTjR1hqK+nvwDWzNpCCAI2Fagfz
	 Ai3iz+8F6o17xalaMY2pDRATlEa3OwVLRIJgq9x+u6TrHwTBammTaPp1ocrCwz/RUMI1c
	 rAVMElBgPOAFWeOAEnGNEACzm/8USpX/MWzkXbiHTPZZVqmkY8hrUCAuPnGzEazLRmg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBiT3S1S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A44E4606A330;
	Wed, 18 Nov 2026 15:35:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HBiT3S1S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF03D1F000C4;
	Wed, 18 Nov 2026 15:35:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016140;
	bh=OIExqzOxJNHPCfp46qZCTSKvSsxSXi65U4y4Zq56tcU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HBiT3S1SkDF9Mq5YqyMPogWWnqjiUZ0wriQsDk9wod1g0grbwuy8xKLrMGqLzbXFq
	 BtJI3bHPikFfktj0b+Mw/DUDjElCm5SC27ayGKZPnEu/LB2ipAEJ4QR33h1L5DMYcV
	 WiAwO86JV2Vi45tEaqCq1hkQSNZkJGDGfN7XgxMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Yeh <justin.yeh@mediatek.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0421/2651] HID: i2c-hid: Unfollow the panel on shutdown
Date: Wed, 18 Nov 2026 15:27:41 +0100
Message-ID: <20261118150302.989395127@linuxfoundation.org>
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

From: Justin Yeh <justin.yeh@mediatek.com>

[ Upstream commit 59fc35a1edbfa5405122d749cf8843da131fd796 ]

i2c_hid_core_shutdown() sends SET_POWER(SLEEP) even for panel followers,
but nothing in device_shutdown() guarantees whether the panel, and hence
our own power, is still on by the time we get there.

Do what i2c_hid_core_remove() does and just unfollow the panel.
drm_panel_remove_follower() calls panel_unpreparing() only while the
panel is still prepared, which powers us down properly; if it is already
unprepared no transfer is attempted at all. On MT8196 the panel is
unprepared long before us, so this also drops the ~2s i2c bus timeout
from every reboot.

Fixes: 96a37bfd232a ("HID: i2c-hid: Support being a panel follower")
Suggested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Justin Yeh <justin.yeh@mediatek.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/i2c-hid/i2c-hid-core.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/i2c-hid/i2c-hid-core.c b/drivers/hid/i2c-hid/i2c-hid-core.c
index a61fd1de52030..a8a9854854f52 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -1357,7 +1357,16 @@ void i2c_hid_core_shutdown(struct i2c_client *client)
 {
 	struct i2c_hid *ihid = i2c_get_clientdata(client);
 
-	i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
+	/*
+	 * Like in i2c_hid_core_remove(): if we're a follower, the act of
+	 * unfollowing will cause us to be powered down. Otherwise we need to
+	 * manually do it.
+	 */
+	if (ihid->is_panel_follower)
+		drm_panel_remove_follower(&ihid->panel_follower);
+	else
+		i2c_hid_set_power(ihid, I2C_HID_PWR_SLEEP);
+
 	free_irq(client->irq, ihid);
 
 	i2c_hid_core_shutdown_tail(ihid);
-- 
2.53.0



