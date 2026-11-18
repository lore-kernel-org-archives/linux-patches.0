Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032974;
	b=ibpNDEtq/2O9cVcao+fucaMMq7+4fHCPMwQf5ZT4yM8+FqZRAgGtTrRtcsCm4LrfOdsz
	 oywtEVufu+EjFpMdxABubbYfNuokJ5p55M1JyAM33VVW7gN2Dtf+qgMLFmql5xairge89
	 jim+mJ6ZbGbHiXx4cvG47hHDeIGwYEtVS76H0wX+Awig7oaQRoFU/V8OR6FSDFLOQ2gyz
	 9Y7WcMIPZG+ARcLyiI9umQMPiZDdllStbpuzP/T7ZXap89n54NoNTnhyEJXF/jWU07sy0
	 wdnfkm55vC/Awx4gWGR+BDgds+8iz5NxrauSgC89aN6yGNH+D5USoFEBtTMN/UOstoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bZakuzSZyHndi6u+igk1p6+iRad8l3kdcyE7mP2cpOs=;
	b=bVRXaO34hzakN0MONzYphbcoQp3UOYkxyiJdFNUzaIWSERZg1bTwqWFoQTwQH9Fvfi7H
	 jA01IofKRi6dnL3ta36BMPxpRQDSWeM129bD6ZogW81RFdv1vR+d77fOISqaoKumY8wVM
	 9tX4DKbB/gGDfgoGvO4J8mEvFYSRcrY1I7qOYRcSYniKdS/I1m+8zdXkvVVsUH01om/Nl
	 H6JbXsvRrLLOAR9xz9QDCB5Ti+CWPc74+rNHFvgKNypnAZ3HCUzoT+qxwLJ9RGBuVVBAb
	 132qNtLMs9fiqja/9cR2g2RAD3nQK+Ng/Mpl5XunfZySnkmKsPgCyzjKD9l1htKv2Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RcSw5up;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E337A606A320;
	Wed, 18 Nov 2026 20:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2RcSw5up
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 187821F000C4;
	Wed, 18 Nov 2026 20:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032973;
	bh=bZakuzSZyHndi6u+igk1p6+iRad8l3kdcyE7mP2cpOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2RcSw5uphFawbJV2jwFTA1mDWrA/1nQ9OMQhN3BLbR/A3twkJtxu4fi1zQAUOj8Kp
	 fXGW3uUhtfweM2hUBQ1cA5LAJ9PwMj9rrHN9qWtBoVx+Lbk7f0Eog457dxyTq8nS/s
	 N0KDtw3gY0l5Qoj1rQr75r/k+/AcDenceA261ud8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1561/1756] ALSA: pcmtest: Reject invalid fill_mode values
Date: Wed, 18 Nov 2026 16:01:28 +0100
Message-ID: <20261118150111.598730674@linuxfoundation.org>
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
index 25f21255b0651..3c85f90c0cc1e 100644
--- a/sound/drivers/pcmtest.c
+++ b/sound/drivers/pcmtest.c
@@ -71,13 +71,32 @@ static u8 playback_capture_test;
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



