Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054530;
	b=fueDWDqO2DXZjSaWBjESlfdE9m68/laOx7A8DCAvK3cLr9xb8JUGQ+4RxD1iAAvAXO5x
	 5ifpO9jP1K1v2sltvCfVLSOiBerYHEfD2WR2QDFoOo0ONk9lREFrEbwbVTOEkuSsUWAMg
	 xKR7BneNwaW3vGhXAe3ts+7qdoGVRT4csh/+WD9t2CKRvL7F2Xa+H11KCKUaejfl8bl3R
	 9P9PsZ6liJUvguITKksLx3E6NCmabQuDfqqjDnQVMIf69/3V60sqN+NOmv7l09Y5xKwWQ
	 iXDTIrONqeK9c1AeV8W7oZ3LfdltpCEMo7Z2L3KsZbejfW8dz7OTLSyoi4TjrYtIyeg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054530;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=T8GxcVGN/Ev7SBufUDyFvQtizghr6KMAVO0QlOHsnXI=;
	b=WvQBp4KXZwO+faICLxked0qMkrdJZAggqtGmAkbDzGHVv4kAdcDcBojuvuISiOrYeItK
	 945Udak5tbSJSYU7fyLL2B5Hbl+IHci5Zrqvn6yZYeRs6ZUdW0jLSm8AMWBpSwfPsxphK
	 mRPr17B2DbrY2Zn9CflJ0/5pJMqGRk9ZjZzLyCw7D7FJyzZtSg+Jieziuv07Plw/geT8e
	 lF37/jhR7KJKTGUOdwbUrPl9hm9QG+NlUkKYLuAyy8m1pwfyO/mRuq7uv9glHB7X8s2D4
	 hzJiYrmqisyxdb9ittr+RBmO1RDuaPS3LpiYfm1vPol4s7CaPEP8OsDiPz6dNVKUdjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PJFE1tbh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 925A4606A31C;
	Thu, 19 Nov 2026 02:15:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PJFE1tbh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E51EF1F000C5;
	Thu, 19 Nov 2026 02:15:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054530;
	bh=T8GxcVGN/Ev7SBufUDyFvQtizghr6KMAVO0QlOHsnXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PJFE1tbhihVhEvu/gT1kbYOSYxb0ELGhRMRbQFGNjxRN9VJWI8uQfARR35EUc53Jp
	 tS1amOVC08PDwVM4XHNu5RZYfSlt64o6KERsDc/ma03DYbUqev6/AnfPQmWVh7hJDR
	 KlT30njpoK+kGvHfiuqG/NNJwRhIgx3DAzSeRJbM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1307/2214] drm/vc4: hdmi: enable scrambling before the TMDS clock starts
Date: Wed, 18 Nov 2026 15:49:43 +0100
Message-ID: <20261118150103.781540977@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: adjusted context around the scrambling calls for missing upstream locking, device guards, and newer hardware checks ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 9b540728b8fae..81b12b7c7a7d4 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -622,7 +622,6 @@ static void vc4_hdmi_encoder_post_crtc_disable(struct drm_encoder *encoder,
 
 	HDMI_WRITE(HDMI_VID_CTL,
 		   HDMI_READ(HDMI_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
-	vc4_hdmi_disable_scrambling(encoder);
 }
 
 static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
@@ -637,6 +636,8 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
 	if (vc4_hdmi->variant->phy_disable)
 		vc4_hdmi->variant->phy_disable(vc4_hdmi);
 
+	vc4_hdmi_disable_scrambling(encoder);
+
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
@@ -976,6 +977,8 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		goto err_disable_pixel_clock;
 	}
 
+	vc4_hdmi_enable_scrambling(encoder);
+
 	if (vc4_hdmi->variant->phy_init)
 		vc4_hdmi->variant->phy_init(vc4_hdmi, vc4_conn_state);
 
@@ -1078,7 +1081,6 @@ static void vc4_hdmi_encoder_post_crtc_enable(struct drm_encoder *encoder,
 	}
 
 	vc4_hdmi_recenter_fifo(vc4_hdmi);
-	vc4_hdmi_enable_scrambling(encoder);
 }
 
 static void vc4_hdmi_encoder_enable(struct drm_encoder *encoder)
-- 
2.53.0



