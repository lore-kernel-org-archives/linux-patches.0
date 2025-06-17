Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC4822FF2B;
	Tue, 17 Jun 2025 16:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750177189; cv=none; b=hyRuZZTSENTmKqh16fV8BCsrT77VHwe3S6qODx028LdewkZhmZjp/H10FGGFix/cgKteAutdyVMMi4Fo8Ti70ZfYsa4l4x8mZusIfv+7HlKErsPFMKXsEm8H2GjegnlA3Toy8Nh09a/80WictcEDzLNWhHHLATz83ZqCKIc90FI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750177189; c=relaxed/simple;
	bh=b1HNtT1/bcYLZ/Kaqb8X1Zy9rnMH2ecWhuAPszfn590=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o0yRBxxbXGz0zr+uu2o9y59/PsBIY+k/y9JccUWsH8JHlGI5xYOwtI34n2c9QA+6fng4emhBjsr5lHKe67fnikNBOnzwUTU5hSIdOalqxpAz0rUjCUQbPpTwmxTE+dnblqSijd7m7WQmwJkihRuy4RCIYwA7id1ITBAPBQUCsGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dyZYBCkR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dyZYBCkR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2CEC4CEE3;
	Tue, 17 Jun 2025 16:19:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750177188;
	bh=b1HNtT1/bcYLZ/Kaqb8X1Zy9rnMH2ecWhuAPszfn590=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dyZYBCkRZsnUb8ihnaYq/QBsm4mZV/zMXV2Mf/J8YtSG4gcupJV7NzgBKnc4w1ACX
	 sWAkT1wOPJxHPbz1UzuDMzZGnPZBA6CxSs+Fj7rNRZiUU3uV/qdpD6+3xcJmL3dSpl
	 is81BkXgtRtfvAzOtEJ7iPLuLGYJhlyxSS5ytgL0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Hsin Cheng <richard120310@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.6 356/356] drm/meson: Use 1000ULL when operating with mode->clock
Date: Tue, 17 Jun 2025 17:27:51 +0200
Message-ID: <20250617152352.468424093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
References: <20250617152338.212798615@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: I Hsin Cheng <richard120310@gmail.com>

commit eb0851e14432f3b87c77b704c835ac376deda03a upstream.

Coverity scan reported the usage of "mode->clock * 1000" may lead to
integer overflow. Use "1000ULL" instead of "1000"
when utilizing it to avoid potential integer overflow issue.

Link: https://scan5.scan.coverity.com/#/project-view/10074/10063?selectedIssue=1646759
Signed-off-by: I Hsin Cheng <richard120310@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Fixes: 1017560164b6 ("drm/meson: use unsigned long long / Hz for frequency types")
Link: https://lore.kernel.org/r/20250505184338.678540-1-richard120310@gmail.com
Signed-off-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/meson/meson_encoder_hdmi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -75,7 +75,7 @@ static void meson_encoder_hdmi_set_vclk(
 	unsigned long long venc_freq;
 	unsigned long long hdmi_freq;
 
-	vclk_freq = mode->clock * 1000;
+	vclk_freq = mode->clock * 1000ULL;
 
 	/* For 420, pixel clock is half unlike venc clock */
 	if (encoder_hdmi->output_bus_fmt == MEDIA_BUS_FMT_UYYVYY8_0_5X24)
@@ -123,7 +123,7 @@ static enum drm_mode_status meson_encode
 	struct meson_encoder_hdmi *encoder_hdmi = bridge_to_meson_encoder_hdmi(bridge);
 	struct meson_drm *priv = encoder_hdmi->priv;
 	bool is_hdmi2_sink = display_info->hdmi.scdc.supported;
-	unsigned long long clock = mode->clock * 1000;
+	unsigned long long clock = mode->clock * 1000ULL;
 	unsigned long long phy_freq;
 	unsigned long long vclk_freq;
 	unsigned long long venc_freq;


