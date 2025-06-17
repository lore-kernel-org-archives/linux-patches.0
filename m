Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93A102FA655;
	Tue, 17 Jun 2025 16:42:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178528; cv=none; b=noAFlXreMqnPgYrAXnihZX4A8vlXmwRI5zDha9snjYkwULwl/f1XlSdNM0cWu5XXIVmW2ceb/PUI5SiTWgeLJ8ezjbPzdPnpbqDj7YI7yn9WVa392QQyTmYW/dIZvZFvw6uzWRukk6Rs7D2XqULE/e+AV4eZaQOSnowSFkDy7+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178528; c=relaxed/simple;
	bh=d0vs/E6wG2HA0LCACr91+W1xLTyBJdg1kXgbqfTHFdE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GF5CkxK8bBBmPN8gCKxTfCx9KcFuZS9Ozvfrzo4Z16sgZgAR+Evz1KehDArJQ9+t0/HD7M9/7wLiskF+FJUtra1ThMceSIz/49GhJhItenGKCIbppg9tA7IKyIokuuGHECvBLiCFCZRQFoummTSi5xxGldOFEzjYK/ZXJxqsbwQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UrT/zkOt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UrT/zkOt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 215F8C4CEE3;
	Tue, 17 Jun 2025 16:42:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178528;
	bh=d0vs/E6wG2HA0LCACr91+W1xLTyBJdg1kXgbqfTHFdE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UrT/zkOtLvN7MGju4TC/UvdxJDUc74YpdrnQEYDMrV6H354UYNzErc2tBGqy7Zyp1
	 MH4/HSuWii+XucxLccpy2aLqHKLEo/TIoy0KeA1nuA8fmh9xqU5pmrR2V8YkjgDHSc
	 X2SDFi/dHu/FpnssVr/DcfN4RmB/MdbFpw3k23yU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Hsin Cheng <richard120310@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.12 512/512] drm/meson: Use 1000ULL when operating with mode->clock
Date: Tue, 17 Jun 2025 17:27:58 +0200
Message-ID: <20250617152440.359064899@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


