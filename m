Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037513;
	b=OKePR9aY5v/Af5KGwTW6mI6FRuQV9mk2EgvLBiKj+eDyRdBiqXsypHcENgW5zjRSPPzN
	 aVCJeJ9LknjQ3hfopnSfuYJ45SvHQzSfRniD5K2qLUgT8FkWf3sBEMjoq032P5TlZ3OtF
	 W4iw254uw2Drrb752lXM2BmJPUGcNEgzIGgr/VA00b16uF7hKiTjllZjvEDxBX3ONHLd+
	 Ngck26w7V1GCSM24h06hJ1h3/3dEAgRblcZMHs3ZvCdQIjoFYggXUGJu0N4sjENZS6TMA
	 6SWFNln1ov2vehqtsT6wp1t3hdreU3rBKmyaGfvJX3hSAEr+fXYkyRmROpLwbzT8CEQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037513;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=IuJFJ5QxOakxqxanHDGfyYe/VEavfcq8wJqoOF1mWfs=;
	b=jSPsy/RpHvP1xiNtX3ncj3Ikl7vJypzuzMDY2qAhNsH0BsoF++N3/51sdL0EfVA3lbz6
	 t7PG8tf5d3UGvSc//coqy6Q1kMpQV0jKcLUSOgLviMVu7DCQWcnToebUP2f7Kmmg7irKK
	 1ObTgrTduQTs+kRgErTLDgeCWNcX7XofBvzEcHOOzo9z7to3e0/Ri7AHSpqWDzWTVXQJD
	 8N+Upa59aK3+90qotkz49ZMXQFXvB28ju8RJ6byj9yy9tcpNnCw/e7Eu55N01nMhtIiAx
	 nY4o3nP5ii4EbGsBVnXBD02uyEglLfVZdy2P4KWqaiAZi3lwyBLJEkMm+ffWIYs4LzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YmpFPgTz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58818606A320;
	Wed, 18 Nov 2026 21:31:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YmpFPgTz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719651F000C4;
	Wed, 18 Nov 2026 21:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037513;
	bh=IuJFJ5QxOakxqxanHDGfyYe/VEavfcq8wJqoOF1mWfs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YmpFPgTzWCk3kXxKm0+5m5XNh4axLL/ISO86F0RwgJAp6gxpJ+Xv+jOzQUDSB6HmO
	 jnIHB7imPzZpfj8etgs+vJGazuTH8gIrP6FeH16GuYscWIgZxA229FPIQdIIF6+w70
	 BzltHlSyjJfB7r9nLCywawo+N2VRh2K2nKXdWMjA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1421/3318] drm/vc4: hdmi: enable scrambling before the TMDS clock starts
Date: Wed, 18 Nov 2026 15:34:03 +0100
Message-ID: <20261118150403.339462872@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Tanure <lucas.tanure@neat.no>

[ Upstream commit 81383bd290a18f06ccf9b0bfb29e1a3ef73d9357 ]

HDMI 2.0 requires a source to suspend the TMDS clock, write the
TMDS_Bit_Clock_Ratio bit in the sink's SCDC registers, wait at least
1 ms and only then resume the clock. vc4 does the opposite: the PHY
starts at the new rate first, and the SCDC bits are written tens of
milliseconds later, at the very end of the enable sequence, together
with the source side scrambler. On disable the bits are cleared while
the clock is still running.

Some sinks sample the bit only when the clock appears. One HDMI 2.0
sink we tested then sets up its receiver for a 1/10 clock and never
recovers: a Raspberry Pi 5 at 3840x2160@60 shows no picture, while
1080p60 and 4K30 work and other sources work at 4K60 on the same sink.
Writing the bit by hand before enabling the output makes the same mode
lock every time.

Enable scrambling, on the sink and in the controller, before the PHY is
started, and disable it only after the PHY has been stopped. The SCDC
helper already waits the required time after writing the ratio bit.

Cc: stable@vger.kernel.org
Fixes: c85695a2016e ("drm/vc4: hdmi: Enable the scrambler")
Link: https://github.com/raspberrypi/linux/issues/7693
Assisted-by: LLM
Signed-off-by: Lucas Tanure <lucas.tanure@neat.no>
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://patch.msgid.link/20261026164028.78792-4-lucas.tanure@neat.no
Signed-off-by: Maíra Canal <mcanal@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 213b7e65cff5c..1abfbe11f575e 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -1121,8 +1121,6 @@ static void vc4_hdmi_encoder_post_crtc_disable(struct drm_encoder *encoder,
 		   HDMI_READ(HDMI_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
 	spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
 
-	vc4_hdmi_disable_scrambling(encoder);
-
 	drm_dev_exit(idx);
 
 out:
@@ -1151,6 +1149,8 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
 	if (vc4_hdmi->variant->phy_disable)
 		vc4_hdmi->variant->phy_disable(vc4_hdmi);
 
+	vc4_hdmi_disable_scrambling(encoder);
+
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
@@ -1769,6 +1769,8 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		goto err_disable_pixel_clock;
 	}
 
+	vc4_hdmi_enable_scrambling(encoder);
+
 	if (vc4_hdmi->variant->phy_init)
 		vc4_hdmi->variant->phy_init(vc4_hdmi, vc4_conn_state);
 
@@ -1905,7 +1907,6 @@ static void vc4_hdmi_encoder_post_crtc_enable(struct drm_encoder *encoder,
 	}
 
 	vc4_hdmi_recenter_fifo(vc4_hdmi);
-	vc4_hdmi_enable_scrambling(encoder);
 
 	drm_dev_exit(idx);
 
-- 
2.53.0



