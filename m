Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029658;
	b=PL/CyF1aBFIglBVLz5nF6wvJLC/EP5lWpH6wbBUprsZlG5+Y+d2Jy2MToOiePzqd6HKx
	 a1DOXJonebb+IzIOunzzrw5ybjfADFaWK+E7HOVJGa7UlAJKTBa1idz7vi22l9n1dYsMC
	 vYY33HUukLqwBOk063S5dTZMSYwmdlCsjR9O9zyS8wrSMJz4+HYTgFUw6i6JLYTF197VK
	 ad1+BAqq4szsDiiCuSQn7c/w25v7GBz5YJUHQy34+zOVj6nPXMSSFCV3piHZjLHbHkJUO
	 AKgMASPxqlRqwgDjpgDj474Fl+5HJTLp22eRttfLdsnyXwcj8auefLtgrkUSNNu3btQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029658;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wSRGIKvx/6+ehigMf3cYMYO9lTj66YOvgLzohRJTyvM=;
	b=ssv8+RYAF2zXmLJYwBkyGzSQhWGuZY664mIe9BND8eotY12eyE0TNT0O7hNlCrANYPjJ
	 JGuWZfOJEi4wgDBR3/OpX71ynoDM4rsv1etr8cCloQuUw4jzP8lonawPXW3eOrRamINzg
	 JCen35fB6JcdLaW+nhbdIllmqJPKmheIi7ZRrw3iJd9FDNr4kGzoKQuv1R9mIyyffSNEZ
	 GtH285iFCQA4FbzPd1q7AK/KHILJkUyUJ57nDTrpbwJ1elKSgjGcYXcknVIYTu4mZCLsz
	 MObLaqqOomg6hDOAVzjOiW/aKc7pw88fUFvJg/c79cKi/hMoYGvBIQxGzhHlI7CFQIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SV24PGW2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16CAB606A31C;
	Wed, 18 Nov 2026 19:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SV24PGW2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A4A01F000C4;
	Wed, 18 Nov 2026 19:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029657;
	bh=wSRGIKvx/6+ehigMf3cYMYO9lTj66YOvgLzohRJTyvM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SV24PGW2eHKengPvTdHzqb6n3iQnMRtYw88nMMEyEb+Uvhmfej7gjXVfo9zSmqLmJ
	 dBDbw76xpL/Zryp/iTy14jo6fS7C6/xpiip2yiGwfpg5WswZz2QGfTKC+CNdsE8q6B
	 tf7hfkHMYKVb4xb8WNBMF0zUfo3LLWzqi7gqHcL4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Justin Yeh <justin.yeh@mediatek.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0373/1756] HID: i2c-hid: Unfollow the panel on shutdown
Date: Wed, 18 Nov 2026 15:41:40 +0100
Message-ID: <20261118150023.330438572@linuxfoundation.org>
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
index 42212ef2aa0f8..3819612817010 100644
--- a/drivers/hid/i2c-hid/i2c-hid-core.c
+++ b/drivers/hid/i2c-hid/i2c-hid-core.c
@@ -1333,7 +1333,16 @@ void i2c_hid_core_shutdown(struct i2c_client *client)
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



