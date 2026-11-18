Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021844;
	b=m+Bx+41natfm5OzbOklO3darLxLnoQoe5bROCV2XpgJEYFrOeuJZSG9O4/radxJtkHAz
	 oOyI9CHGZpu8Sl3EH7z5Ea8Dgi92XNsN6mfddpPjWMAfhU/bO0SC2YpK//yCuyLVA13Xh
	 jyPZzHDgoshEr/OTN+9tZokeErB5+hiBirtOyuhm/KSLfEjIEfEBdotSEQ/0sfA5laCXY
	 HTKRakk1nHGuE4X/SNMnHgkN/6jQhihamQTAmAZOeNS7eNdYiCKxo/lPQLNri5LM5IKwU
	 AYE8uVW5DAgBRjYsMhv8a0jDQpyrzRvNJftle/C79Tv8OtgjF3x3C6+uuBU+5umtThg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021844;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=1XFf6QLTMptKEPuPDUI6CzfzGtTIiMi3hro1PeZXcC8=;
	b=KUiXLaDQoXY6vHmTgwL1NtHwrUhFM4Zjlcs94Q0kArhZUV/vPGOPpXYfHfa53E7pPLuf
	 dsW4DuFw+xG2+PI6dpZHPt3Luo/WB6hD8l/yXsg3lvxBjaU9akLh+5jE1DhElVdOC8UCT
	 GRR1N8Z77ojJjJXmodTkd8BSPe/Hfgsc4vOfKaZ44X/mzIyM5Q7i+6a8bfJCmF3dvBOL/
	 KdTZj9zq/EaRGheTke2EGx6of9LiKa+KB0TFLYCWhjTFC31CvgBdjxLrpOS2+Kstg2Um+
	 ZY7D2B/oz35Ski+/gH1YlRc9OHi3z5FTTe2Srj/xaBUEPg2AHbClKHWkn2pWUxf56Vg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBpj3KR4;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9B14606A31C;
	Wed, 18 Nov 2026 17:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rBpj3KR4
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1B921F000C4;
	Wed, 18 Nov 2026 17:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021844;
	bh=1XFf6QLTMptKEPuPDUI6CzfzGtTIiMi3hro1PeZXcC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBpj3KR4G5w/3QmjixoOAUJ/9rFLAA617s/7j2AsP216XWhMfIpig7tyxust+Ss1N
	 9yptI/RCO+Qkjd0cP+S7R8IMuVteU+bMxlMxL379bXjoERNxbEhAep2ENNo+FWM0e+
	 LMo2oABxw9TPaWo3X+YCv3zvr0IXA9+u9PH68xss=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2410/2651] ALSA: pcmtest: Reject invalid fill_mode values
Date: Wed, 18 Nov 2026 16:00:50 +0100
Message-ID: <20261118150412.069860425@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 5deb9c57ba93d28a52871a96f3d8794d2cbed035 ]

The fill_block() function handles only fill_mode 0 (random) and 1
(pattern). With any other value it writes nothing and does not move the
buffer position. A capture stream then gets no data, and a read fails
with -EIO after the timeout. Nothing in the kernel log says why.

Check the value in a set callback, so a bad value is rejected both when
the module is loaded and when the parameter is written.

Fixes: 315a3d57c64c ("ALSA: Implement the new Virtual PCM Test Driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261026031655.2699561-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/drivers/pcmtest.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/sound/drivers/pcmtest.c b/sound/drivers/pcmtest.c
index c5b24c05b3562..b3d5218e89db6 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -72,13 +72,32 @@ static u8 playback_capture_test;
 static u8 ioctl_reset_test;
 static struct dentry *driver_debug_dir;
 
+static int fill_mode_set(const char *val, const struct kernel_param *kp)
+{
+	short mode;
+	int err;
+
+	err = kstrtos16(val, 0, &mode);
+	if (err)
+		return err;
+	if (mode != FILL_MODE_RAND && mode != FILL_MODE_PAT)
+		return -EINVAL;
+	fill_mode = mode;
+	return 0;
+}
+
+static const struct kernel_param_ops fill_mode_ops = {
+	.set = fill_mode_set,
+	.get = param_get_short,
+};
+
 module_param(index, int, 0444);
 MODULE_PARM_DESC(index, "Index value for pcmtest soundcard");
 module_param(id, charp, 0444);
 MODULE_PARM_DESC(id, "ID string for pcmtest soundcard");
 module_param(enable, bool, 0444);
 MODULE_PARM_DESC(enable, "Enable pcmtest soundcard.");
-module_param(fill_mode, short, 0600);
+module_param_cb(fill_mode, &fill_mode_ops, &fill_mode, 0600);
 MODULE_PARM_DESC(fill_mode, "Buffer fill mode: rand(0) or pattern(1)");
 module_param(inject_delay, int, 0600);
 MODULE_PARM_DESC(inject_delay, "Inject delays during playback/capture (in jiffies)");
-- 
2.53.0



