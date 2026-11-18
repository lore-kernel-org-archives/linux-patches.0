Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023538;
	b=kuqifgTaMyX+FpFzmnHhUPWUYeR8Kdq1Yhmv4dbhiPgnnzI+Nj107PDxQ0eLUPVytEhX
	 6wPLTTnbXYxFQ3WS1uHjsS/devc/lcmsu/X3/GL5fTeajwg94TpginVkBl+XMiY1MDHuQ
	 ONS7yqnz1jxV2dyoM+EsqQJevygjln5+gi0moatxhYEljW4KnVEDTDNHig5zTRXWizJOW
	 ZlUf86KTVh4kCBHufDHRzY7Is50fnocZY+w01SuaikyzmbMkLvyZ7OlbZtUYxu4NFuIY6
	 KmVwzgTTcpY46EaEWaDIUJjUjizseeVBQNeyrT6njsBO16PZQIbqm6kaJuVByX5R7IA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023538;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bLsz65wrvXaNXg5F8W+NoXvYoLSx/ZY8rTivIn7aWTo=;
	b=pXHFNtvsJ9CW8SLslN8dsZSyIH/7hXTnbMlVE1Vxj7k+RLw4hoZvmsvuvGa2NqfZA965
	 N2p3a+vbdUa+QSeCTeDp4vGl+xcqO3fxcRmbukOFVMybgnocyqchL9HtWwteIndutK2xa
	 3ORot1at34CNrqt3ELpry6jphljZuTj83eun6Yya3UYQgbHKZSkFDqE1S4UTIMsbuPUpN
	 GSMhXMdA/N/bafG/LUnwybgjB+W+fLsCHcT90fL6EaHUVipC2ayXVxBNe7MxhaAt9UheP
	 PnrhufA3RcXEHodPhK6uQEkbt4MupQgPtEpofmElzUyD4EPCxDMUsAkPYqeHVRk1vGw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNnYu6Rh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF25B606A330;
	Wed, 18 Nov 2026 17:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tNnYu6Rh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54D8A1F000C4;
	Wed, 18 Nov 2026 17:38:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023537;
	bh=bLsz65wrvXaNXg5F8W+NoXvYoLSx/ZY8rTivIn7aWTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tNnYu6RhOeawwxGQT0cZ+0YwKnd/DrJF+m/uwmq7/etd/Uo0jZah28Na5Jrdy3d8+
	 5spXWxpDVW+DKkiPic1UmdMhf41KxE930RM6JfsUABddLigmfCiBB8BTdHj84eEyYp
	 zTL12r1e63Wc66YMydW2loWTND6VeK5BzJB58FRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Yeh <justin.yeh@mediatek.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0405/2151] HID: i2c-hid: Unfollow the panel on shutdown
Date: Wed, 18 Nov 2026 15:35:40 +0100
Message-ID: <20261118150136.812705308@linuxfoundation.org>
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
index 62b3dd0390a7c..4f0b461566958 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -1355,7 +1355,16 @@ void i2c_hid_core_shutdown(struct i2c_client *client)
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



