Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039690;
	b=SfV2aNnIgXSHg3gYwy4Payy3DOd661gAjraXhbcsP8VGs+LrOxVGVZVkq1KvzBp/rIa7
	 I+G2HAPN6/Y1E4+rzIE4Yr3tL+DSktHxfvFIKYF8r77UjUsCYjT+7T4FFCfZoMiosnsPa
	 UeNH/po6ufb/mPLMD1/XaRSI+p+rRWwkwpYJCH8lVcFv9AigrX45MbELrXJlBZaLGyKfJ
	 w7ChiOh+QtqDq4eZEhI5gd71R+UMWELlRBcDPIlKfrCOFs+ZHGPr683BC2CJiGz+FUMPy
	 A7lkh2+WYtZBfocCgDh5nmURMXmGo13exf6AgeKiiHeyIS8sFviwY/iLqdhZJfu2fxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039690;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lCfkJrXK/gLmrVMSfywtJl8KyUJZVWMUeeboAb5Kb4g=;
	b=ZTIWO9l6q1pjEFqbXOl6GG+mv/FHP5UTDp7qHWxKn1KGAn9VnhWZGExN72C0j2JvEE5W
	 u+YNLSjf6k7ws+Q0VCShTiKSYfff2fHFWTSgRlHGtiFyu3iiY52H6o1JD6ZQMgbzRnEXm
	 jBoFsEKJlapgwT9gzzY3TKusEO6Yr9P4SXz/sLceTD0NDgJYkv6sm2eNSQutUFA5w4vrV
	 gj1CAhpN+ErZ3uxA3vhQhKUxQeAZ58g04PLwJnwLO8VRYC/FCgXV6vw+mpoIh15GlCfTU
	 LOHTcZxBI+uvxenL5Y4QT3pHkoLW1pKynN70qseYLPcw64QVM/0siOJjZSAggHaTusg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQF11sMe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5D2606A31C;
	Wed, 18 Nov 2026 22:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TQF11sMe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB7DB1F000C4;
	Wed, 18 Nov 2026 22:08:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039690;
	bh=lCfkJrXK/gLmrVMSfywtJl8KyUJZVWMUeeboAb5Kb4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TQF11sMeNyuHe3aqAaByM+/0lSsmoml2xLv/akSsjew97Q66PY/lWKtN3YfCkM+eO
	 6eVrIO+4/+mCTFSrMQw0tbpMnGTL5P3LspXjGiB5QAilYPhpfmFyC/YfJb2uCC8zd2
	 FnL5pZO8uv4eHtJFUZAWj6Pu+nSRCNuvzN4220ss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Yeh <justin.yeh@mediatek.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2183/3318] HID: i2c-hid: Unfollow the panel on shutdown
Date: Wed, 18 Nov 2026 15:46:45 +0100
Message-ID: <20261118150427.455628233@linuxfoundation.org>
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
index cbffeb7186a6f..9ad603bcaf596 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -1302,7 +1302,16 @@ void i2c_hid_core_shutdown(struct i2c_client *client)
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



