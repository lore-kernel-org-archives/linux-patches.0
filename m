Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207465;
	b=w8Q4wUSqRy+1BMuQqJFQeQNiL5j1eUA3MjhFSnX6YTIGaPgqJGnYU9E+J2SJtfBUVp0E
	 1MsAbJDWJVE80QPXK6+FDbAUON+pODy5Du7v7ewNj8vjpc/ZUxrerJM1ljYwIR4ZZ8xRj
	 BXyTBHJqVQbbKgIHRgV0ayWng6D1VkNMGKYY+p8d75wlRtRKb0L69I2O4MBmrb2MyAkBi
	 RKqZuSTriJpnXToxhiiAbxsEodXPY/LuMSPr+oHut6YkSaEkVPlAJBHpHtN5ZVezIGBSo
	 9oGhHVxpbRHh+mhCye4YANV2IHN/iJIrrig0kGehyLEFYN2PQ3uiHcMLpNodIi0gm+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207465;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=aK5dZws8oiGpj32A0V6is0VBJ4XQWdiv2kIYP/PGbIw=;
	b=eA5t448jdwi8KE6/498fWJ7xJAuAuciOHxEL3daumkNmemle/gdrDiLCcJ6hHIe5rymH
	 ZnpCyORnjgEdUQ4gIRaaWYbwtIj5lsI5lwaGpYWhxG7pz/PTzuz7Bf2SAca6jHBCs1QxB
	 Jlg4jj8wy5EGQKKCM/jY2/yRXHGhSd8iMl8V30Y9TeMUgMXfmDA3CS7Mspzz9znotPM4w
	 odJIIK6ymlCu3wbDWwCCIzl0jun4uglD4QTqTSAk7Cgy2Z+q3s0XhVUanNixQleu+FtSf
	 odh5AsLsmX4lsE5MPtugObA6PvLBnj1CY2cMVz8tywEHJnBrjRtEbLmoUCsBIBoDJhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYeo6kLD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507A4606A31A;
	Wed, 28 Oct 2026 17:11:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PYeo6kLD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E2B1F01825;
	Wed, 28 Oct 2026 17:11:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207465;
	bh=aK5dZws8oiGpj32A0V6is0VBJ4XQWdiv2kIYP/PGbIw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYeo6kLDFk/7CsfGkdZmaqt9bBDknvLoiJbS4e5D6oVhrB/e2EgJspNrnUe1SXZSZ
	 bH8xHzAIJ9uD1AlusJ2BTl5fqsKmttsTiTBxiHhVsc0RCm2aWl7Ht38F7x+1Vkzr6s
	 IktEbKzcpba2JGCpz4K+8wn+9XetspZWpvwo30H0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dave Stevenson <dave.stevenson@raspberrypi.com>,
	Maxime Ripard <mripard@kernel.org>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/247] drm/vc4: hdmi: Move packet RAM enable to PM runtime
Date: Wed, 28 Oct 2026 17:57:09 +0100
Message-ID: <20261028165947.985672652@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165947.349197979@linuxfoundation.org>
References: <20261028165947.349197979@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dave Stevenson <dave.stevenson@raspberrypi.com>

[ Upstream commit 3f57b34485dc01e5a2db60a89a6ae5439a897e53 ]

Audio can be triggered by the HPD handler and start up before video has
been restored, calling vc4_hdmi_write_infoframe() for the audio infoframe.
vc4_hdmi_write_infoframe() needs Packet RAM to be on to store the
infoframe, however, if the video hasn't been enabled,
vc4_hdmi_encoder_post_crtc_enable() hasn't been called and therefore, the
Packet RAM can be disabled by the time vc4_hdmi_write_infoframe() executes,
causing the following splat:

[  201.570266] ------------[ cut here ]------------
[  201.570293] Packet RAM has to be on to store the packet.
[  201.570367] WARNING: drivers/gpu/drm/vc4/vc4_hdmi.c:683 at vc4_hdmi_write_infoframe+0x404/0x494 [vc4], CPU#0: wireplumber/1606
[...]
[  201.658650] Hardware name: Raspberry Pi 4 Model B Rev 1.5 (DT)
[...]
[  201.758499] Call trace:
[  201.760967]  vc4_hdmi_write_infoframe+0x404/0x494 [vc4] (P)
[  201.766607]  vc4_hdmi_write_audio_infoframe+0x1c/0x28 [vc4]
[  201.772247]  write_infoframe+0xbc/0x140 [drm_display_helper]
[  201.777975]  drm_atomic_helper_connector_hdmi_update_audio_infoframe+0x80/0xdc [drm_display_helper]
[  201.787140]  vc4_hdmi_audio_prepare+0x4ac/0x570 [vc4]
[  201.792252]  drm_connector_hdmi_audio_prepare+0x24/0x30 [drm_display_helper]
[  201.799390]  hdmi_codec_prepare+0x100/0x160 [snd_soc_hdmi_codec]
[  201.805471]  snd_soc_pcm_dai_prepare+0xd4/0x100 [snd_soc_core]
[  201.811375]  __soc_pcm_prepare+0x60/0x12c [snd_soc_core]
[  201.816752]  soc_pcm_prepare+0x34/0x58 [snd_soc_core]
[  201.821863]  snd_pcm_do_prepare+0x70/0x8c [snd_pcm]
[  201.826798]  snd_pcm_action_nonatomic+0xe4/0x174 [snd_pcm]
[  201.832350]  snd_pcm_prepare+0xc8/0xd8 [snd_pcm]
[  201.837021]  snd_pcm_common_ioctl+0x458/0x614 [snd_pcm]
[  201.842308]  snd_pcm_ioctl+0x30/0x48 [snd_pcm]
[  201.846802]  __arm64_sys_ioctl+0x88/0xd8
[  201.850769]  invoke_syscall+0x48/0xf4
[  201.854470]  el0_svc_common+0x80/0xd8
[  201.858171]  do_el0_svc+0x1c/0x28
[  201.861520]  el0_svc+0x3c/0xb0
[  201.864605]  el0t_64_sync_handler+0x68/0xdc
[  201.868834]  el0t_64_sync+0x198/0x19c
[  201.872536] ---[ end trace 0000000000000000 ]---

Considering that Packet RAM enable is essentially a power management
configuration, move its enabling/disabling to the Runtime PM hooks.

Note that post_crtc_disable() still stops all infoframes, but keeps Packet
RAM enabled, leaving it to be disabled by runtime suspend.

Link: https://github.com/raspberrypi/linux/issues/7069
Fixes: b47a72f30768 ("drm/vc4: hdmi: Switch to HDMI connector")
Signed-off-by: Dave Stevenson <dave.stevenson@raspberrypi.com>
Acked-by: Maxime Ripard <mripard@kernel.org>
Link: https://patch.msgid.link/20261002-vc4-hdmi-packet-ram-fix-v1-1-3d73148096c9@igalia.com
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 9655027f1c0ab..7ea1622377b58 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -857,7 +857,7 @@ static void vc4_hdmi_encoder_post_crtc_disable(struct drm_encoder *encoder,
 
 	spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
 
-	HDMI_WRITE(HDMI_RAM_PACKET_CONFIG, 0);
+	HDMI_WRITE(HDMI_RAM_PACKET_CONFIG, VC4_HDMI_RAM_PACKET_ENABLE);
 
 	HDMI_WRITE(HDMI_VID_CTL, HDMI_READ(HDMI_VID_CTL) | VC4_HD_VID_CTL_CLRRGB);
 
@@ -1616,9 +1616,6 @@ static void vc4_hdmi_encoder_post_crtc_enable(struct drm_encoder *encoder,
 		WARN_ONCE(ret, "Timeout waiting for "
 			  "VC4_HDMI_SCHEDULER_CONTROL_HDMI_ACTIVE\n");
 	} else {
-		HDMI_WRITE(HDMI_RAM_PACKET_CONFIG,
-			   HDMI_READ(HDMI_RAM_PACKET_CONFIG) &
-			   ~(VC4_HDMI_RAM_PACKET_ENABLE));
 		HDMI_WRITE(HDMI_SCHEDULER_CONTROL,
 			   HDMI_READ(HDMI_SCHEDULER_CONTROL) &
 			   ~VC4_HDMI_SCHEDULER_CONTROL_MODE_HDMI);
@@ -1637,9 +1634,6 @@ static void vc4_hdmi_encoder_post_crtc_enable(struct drm_encoder *encoder,
 		WARN_ON(!(HDMI_READ(HDMI_SCHEDULER_CONTROL) &
 			  VC4_HDMI_SCHEDULER_CONTROL_HDMI_ACTIVE));
 
-		HDMI_WRITE(HDMI_RAM_PACKET_CONFIG,
-			   VC4_HDMI_RAM_PACKET_ENABLE);
-
 		spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
 		vc4_hdmi->packet_ram_enabled = true;
 
@@ -3125,6 +3119,11 @@ static int vc5_hdmi_init_resources(struct drm_device *drm,
 static int vc4_hdmi_runtime_suspend(struct device *dev)
 {
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
+	unsigned long flags;
+
+	spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
+	HDMI_WRITE(HDMI_RAM_PACKET_CONFIG, 0);
+	spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
 
 	clk_disable_unprepare(vc4_hdmi->hsm_clock);
 
@@ -3134,9 +3133,8 @@ static int vc4_hdmi_runtime_suspend(struct device *dev)
 static int vc4_hdmi_runtime_resume(struct device *dev)
 {
 	struct vc4_hdmi *vc4_hdmi = dev_get_drvdata(dev);
-	unsigned long __maybe_unused flags;
+	unsigned long rate, flags;
 	u32 __maybe_unused value;
-	unsigned long rate;
 	int ret;
 
 	ret = clk_prepare_enable(vc4_hdmi->hsm_clock);
@@ -3178,6 +3176,10 @@ static int vc4_hdmi_runtime_resume(struct device *dev)
 	}
 #endif
 
+	spin_lock_irqsave(&vc4_hdmi->hw_lock, flags);
+	HDMI_WRITE(HDMI_RAM_PACKET_CONFIG, VC4_HDMI_RAM_PACKET_ENABLE);
+	spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
+
 	return 0;
 
 err_disable_clk:
-- 
2.53.0



