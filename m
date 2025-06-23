Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3D621EFFA6;
	Mon, 23 Jun 2025 21:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714113; cv=none; b=UJERSozE+CoLeOoueCwksEZaY3CKkIrhFu1W6nMMuAvv6OOSrZhH8ybeUSpQQn+3UkNbNOSt944SRDMy2sOwedT5LhzxauRv1JSB4w3W9w29zNN/E8M7QG8HDljRhC+V+yXCtJMEvQ0IjoySFXq/RmMwxHRRrfEPKsESVyVtGdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714113; c=relaxed/simple;
	bh=a06sAdX6PMIXSE+HzOraqgewOJH+fSxop2wwR/9vDM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raRQlC5dhnWqrfht/Ou3dg0o/wnuZd7Fxl+h90c9qj80FixSzipZnmHI+E+dAxbwi1MhPVm5nBeZyKxepCeoAUnxybTr1vgdPbvjQBukD4mhL38uoyK5s+qNiXkFKQfBuTAhsYdySLBt7e5F+geu6Cpy8i8465Uezd3agr1F85Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1yNEDgpP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1yNEDgpP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB44C4CEEA;
	Mon, 23 Jun 2025 21:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714113;
	bh=a06sAdX6PMIXSE+HzOraqgewOJH+fSxop2wwR/9vDM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1yNEDgpPRu/DIKlki5dPaEosD10hlo1y/CAlxg1W4VB7/MTI5FWDSnYRQZyf1fUk0
	 77U351u8AtZHXZfJGC9jwdOYww67WYQ20JZIC+88wTYFZTv7TbVSJGDBy81GK9Qrxe
	 0LYNFRnvGEAx7PSDL8fihSF9NBBJFN/RFIaI4BKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Hsin Cheng <richard120310@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 5.15 188/411] drm/meson: Use 1000ULL when operating with mode->clock
Date: Mon, 23 Jun 2025 15:05:32 +0200
Message-ID: <20250623130638.412661364@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -73,7 +73,7 @@ static void meson_encoder_hdmi_set_vclk(
 	unsigned long long venc_freq;
 	unsigned long long hdmi_freq;
 
-	vclk_freq = mode->clock * 1000;
+	vclk_freq = mode->clock * 1000ULL;
 
 	/* For 420, pixel clock is half unlike venc clock */
 	if (encoder_hdmi->output_bus_fmt == MEDIA_BUS_FMT_UYYVYY8_0_5X24)
@@ -121,7 +121,7 @@ static enum drm_mode_status meson_encode
 	struct meson_encoder_hdmi *encoder_hdmi = bridge_to_meson_encoder_hdmi(bridge);
 	struct meson_drm *priv = encoder_hdmi->priv;
 	bool is_hdmi2_sink = display_info->hdmi.scdc.supported;
-	unsigned long long clock = mode->clock * 1000;
+	unsigned long long clock = mode->clock * 1000ULL;
 	unsigned long long phy_freq;
 	unsigned long long vclk_freq;
 	unsigned long long venc_freq;


