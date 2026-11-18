Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027889;
	b=h4TJkT08897DUbaMomiA5wgeKCDCbYBEN3SjkWr+UZKv6ZD/4ynTFfcNpeRWPlKOW84L
	 Z1iEq9Y5OnhSmAGxylvP1CFSkA5UqLXsujIhunnLAm3yKZIwdSsBpwhJS/4TThHSVHef4
	 JyZ2o7qxGGX4tu8tFWpAS+o9QuzEqfEr+n4eKmwBl5bORF93Pbq8Y3ZtSa2Xo52BL85lo
	 dRK5KgepZq4T3SrKY7quxPFx3qQJF8roDhKDQKEOzgSxQRg9bircKvSaf9XUtuOoG+tTu
	 Zza1P1aMy13sUI9w3SfekXh1VSP4NzTsNxPXHkGJ41Z2VJkca0SIJK+ucabhWYr4Q6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027889;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XYGE68kp1NHvjklsc+0vGyDo6S1EYqEMvTHjRcFPp24=;
	b=3IeZ/0p07QIkitGCTCr0MuiV0anfnQ5BBMUmiXcsFm40seKuipc2eIuCOzxya7sz/9Ni
	 +Kd7vlEccoXmTfyis2ESy3QWmsKmxc8sT+2nKQHjvS/dRLMWFEiF9nRPaUtJaDo5uVWwm
	 ITtn82GO2yBCszDJtXfMO0CgvAWIAgEWVXHdc7K8z9BWs0YpE4kUcUJyfpGWGifs0RLuW
	 lqtYUCI7OGDCPLCXZOH2I1uMRBTED+VAqqbUi6mX9fv3QPtLaa7vPTMXel2OrMXlS4LGH
	 TsD5eWJsgnLpndfgjjietu80HJ/7+j1CIsj3gUwHE22tb5Wz3GYjTgZnvYO/wva/j2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=07i40brR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77370606A31C;
	Wed, 18 Nov 2026 18:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=07i40brR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA6DE1F000C4;
	Wed, 18 Nov 2026 18:51:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027889;
	bh=XYGE68kp1NHvjklsc+0vGyDo6S1EYqEMvTHjRcFPp24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=07i40brRileASQgfP9Z22zUFldryi/7xJ5/gl5jVqrzpXXhjLKtS+Ux+gFXJfQ2R3
	 tssEO6k8POuEKpQ9273tPi0Ced4PJeZOZT9ShOVRInna+VA68b4e+JOFKrt1ERcGKj
	 7+GLhh5Z/E6RA5m+z8jFC8zdttc4WhimjeUbzKPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1948/2151] ALSA: pcmtest: Reject invalid fill_mode values
Date: Wed, 18 Nov 2026 16:01:23 +0100
Message-ID: <20261118150232.726652143@linuxfoundation.org>
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
index 651a79c3f5786..5a016267ed8a4 100644
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



