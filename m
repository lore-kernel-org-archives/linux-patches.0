Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591035;
	b=pYsMWwAhND/OsVNbqrUJvV5Fkz3AafzaaNGBtUbNeBE+ZYhCP4nNfcjXGg0cGjChsyAC
	 qARo2qvr7t5arbZWH03+077KQVldY4clOjHAvZGmWgPse0yFnTAwf5Dxhl71Mg2tBPrvL
	 sJ9A8aMoMOf15/b4+g/U+3/Nba8Ml683RVJAzx2Xg7bq78v/nUp59c8rX6qYrJqtN7h2k
	 ndRWh2OsuyUE+VJsmaWU5H94xz5EaRJ0TfrCUFMngqPAJor9gSAn6fftcNLNB68xfTMd6
	 Y2vhPXKlp6k6sSxWn7W2RAyR8nXafhDS1YH3hfi/X17W/tlBgIxd8QzU1jI1yrvxPFw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591035;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=mJ4i36FbyXA40qwhK6GM/IGwxhnFDGG1zxVZoZpvjWE=;
	b=UyYC5BZAyyGeh/ZXqX2/Lj5B21FE0FSZ5l+XCHu5bGsl3YAVmqa9GqW7yguXkY24I6Mv
	 Y4ADkohl/UR+3/CbwaRdIB/RwJ77wkMapOejlyMGijHLI8NGVgcR+0xuYOM/X5qMIubUb
	 Lg2RdA7JJA960Imeb74zgnUur0yASbJWRDwj1TLog0SlvZL3AuykLTXSJ2V2dDbupHWEd
	 tOe97B4w7EUCZJEHrRE2fQ/xmGBEQUOs8U9XLtR8pr0JcRDXDFtjNPAM8TRTgsXwd+JBG
	 O+vUIFzdO4Qva2TbP40/UmV9JkPHd8SQOvshxYB+hXjZlOmDeqDGDWDSd8hWYFmyhuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="LcOA/ved";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D441C606B809;
	Fri, 13 Nov 2026 17:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LcOA/ved
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 801EB1F000C6;
	Fri, 13 Nov 2026 17:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591035;
	bh=mJ4i36FbyXA40qwhK6GM/IGwxhnFDGG1zxVZoZpvjWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LcOA/vedAF30m1S62f7p3IRp83OOvvzsiq4DCLfHhAa+U5gFXYt9hope3U+taf0iM
	 69QjU94NwXSaeSBIx10hO3Jwcr2m5ouY9y3Q1QR95xPyFkI4+qaDJEzuld7624TFNc
	 r3/m0iaWKPaWvmVfCa/oIOKVNGwC8btH3hMOfRQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/670] drm/vc4: hdmi: enable scrambling before the TMDS clock starts
Date: Fri, 13 Nov 2026 10:46:06 -0500
Message-ID: <20261113153818.810233318@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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
index 419ea3bcddfc8..2fa0e0f4bcd21 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -869,8 +869,6 @@ static void vc4_hdmi_encoder_post_crtc_disable(struct drm_encoder *encoder,
 		   HDMI_READ(HDMI_VID_CTL) & ~VC4_HD_VID_CTL_ENABLE);
 	spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
 
-	vc4_hdmi_disable_scrambling(encoder);
-
 	drm_dev_exit(idx);
 
 out:
@@ -899,6 +897,8 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
 	if (vc4_hdmi->variant->phy_disable)
 		vc4_hdmi->variant->phy_disable(vc4_hdmi);
 
+	vc4_hdmi_disable_scrambling(encoder);
+
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
@@ -1509,6 +1509,8 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		goto err_disable_pixel_clock;
 	}
 
+	vc4_hdmi_enable_scrambling(encoder);
+
 	if (vc4_hdmi->variant->phy_init)
 		vc4_hdmi->variant->phy_init(vc4_hdmi, conn_state);
 
@@ -1640,7 +1642,6 @@ static void vc4_hdmi_encoder_post_crtc_enable(struct drm_encoder *encoder,
 	}
 
 	vc4_hdmi_recenter_fifo(vc4_hdmi);
-	vc4_hdmi_enable_scrambling(encoder);
 
 	drm_dev_exit(idx);
 
-- 
2.53.0



