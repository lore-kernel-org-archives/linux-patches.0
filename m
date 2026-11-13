Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585433;
	b=boyIcUCTMpwE6vYM1BoQybCiUdwMRLqFsSMM10jaBRJKUBvFENvA4NedWCByG8M9ln+M
	 u4Hx6cdsjL+7H5ulom3f2iBvNb7AkS1OwFeoskhzVWqLtVcFNFLtE8WKZF+YyGEBPVdJx
	 ex0A8P0qknzkMeQWELnwaFKJFRT9nIDPM9vmLK3+GBW8Qz2obV01OO+kTrNxaG9zQqo/8
	 xbKThZ+E6rkZaMriQw7PH76vC8z5+FNM7ooXtHxzlbAZOq7RiCjbeSlfqRLPyMEsAvip4
	 v8mHZ7nLzb4pJ5E8t2kvz9BZE5qpm9NFjkxoCU1BeQyEjROwQiILumqFmuZ0iS/+CmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585433;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uHweTkfWHtmlJCnSyqaUR7x71Ttup78FsZ+czMUZYIk=;
	b=XfvQpk4YS+SjGUC64RmPBlspTJp8ftp/Qi0/3WP9BdoaVCfd/dYaxGTr7s/mz0MtW5O5
	 ZAoqyenupdLFJOaMQABEkPbnaoHRhGfiTQEutFU8BG11L3CA4q+/kFDtIAunk8shWTBIC
	 fDVREXuEAz8AZ4vXf32BJdQmugGQF39LR25ZHd9WJ0lBrFFti0S6urH2RK86idBEdQrcF
	 X+krrDbtr7bTLg2K3gxtIMmEXubCcQfBKMPXp5HlHkoMHjHE8o6IuRfa6oxLjSobqeN3N
	 0deuVz/31dgQZhicrXH2Iif1ND2VynBx453a3cQGtRAuckewXJYtCE4dqXIP0YfPvrg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EamBwC1G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3622360A3832;
	Fri, 13 Nov 2026 15:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EamBwC1G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C1C61F000C5;
	Fri, 13 Nov 2026 15:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585433;
	bh=uHweTkfWHtmlJCnSyqaUR7x71Ttup78FsZ+czMUZYIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EamBwC1GnBvksY4z95pRmM8WqUP14kZ9bgvF/exPA56Oj7qbos1/0J0XpE8POf1HT
	 wgSK3iSZnsUXhielOYMgOeDSaN0dPbJ1GgoVot0i+wZwg5t6st47pySudqBmvv1s2N
	 N1NNZb5gReJvNIaDUo2KiF+AIq0bhw7tLecRKzus=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lucas Tanure <lucas.tanure@neat.no>,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 093/507] drm/vc4: hdmi: enable scrambling before the TMDS clock starts
Date: Fri, 13 Nov 2026 10:46:37 -0500
Message-ID: <20261113153757.224997469@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f58f645ec3c50..f2043f907dc52 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -917,8 +917,6 @@ static void vc4_hdmi_encoder_post_crtc_disable(struct drm_encoder *encoder,
 		spin_unlock_irqrestore(&vc4_hdmi->hw_lock, flags);
 	}
 
-	vc4_hdmi_disable_scrambling(encoder);
-
 	drm_dev_exit(idx);
 
 out:
@@ -946,6 +944,8 @@ static void vc4_hdmi_encoder_post_crtc_powerdown(struct drm_encoder *encoder,
 	if (vc4_hdmi->variant->phy_disable)
 		vc4_hdmi->variant->phy_disable(vc4_hdmi);
 
+	vc4_hdmi_disable_scrambling(encoder);
+
 	clk_disable_unprepare(vc4_hdmi->pixel_bvb_clock);
 	clk_disable_unprepare(vc4_hdmi->pixel_clock);
 
@@ -1553,6 +1553,8 @@ static void vc4_hdmi_encoder_pre_crtc_configure(struct drm_encoder *encoder,
 		goto err_disable_pixel_clock;
 	}
 
+	vc4_hdmi_enable_scrambling(encoder);
+
 	if (vc4_hdmi->variant->phy_init)
 		vc4_hdmi->variant->phy_init(vc4_hdmi, conn_state);
 
@@ -1687,7 +1689,6 @@ static void vc4_hdmi_encoder_post_crtc_enable(struct drm_encoder *encoder,
 	}
 
 	vc4_hdmi_recenter_fifo(vc4_hdmi);
-	vc4_hdmi_enable_scrambling(encoder);
 
 	drm_dev_exit(idx);
 
-- 
2.53.0



