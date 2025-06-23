Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2661F1AD3FA;
	Mon, 23 Jun 2025 21:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715861; cv=none; b=jbM5IPCWJd662/VSgzu4A1Fw3jgCZB8qsFDSA8Ym7AsXZDDXyLZ5xv4PD1bE36Ps+7H+f3piEkHZDM+chIXtuaDY2U0oeslqa9ZihPNfNZXNexZKsk7OVGmI9UGhG63XWTNcunaKFw+dIMGYsYwvi2/Fdn3OWo8PkJMWisflkds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715861; c=relaxed/simple;
	bh=xwp1KuGz6HG3hyissKTcCEki84nVJjuM0A6XFqleOUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xt7EYuFV6WqUeM002b/DmC05hmBS+xfE5uHKANvOZdORTD5PYwoFGNs9YkFxF2uiC5Pncd6ZUVREav5xRs0Vjg5iKleUmr20/rSt3GLrfyff/nOtgYEarnMbQ2HdKa4Td0vMJI5O1gbxH/y9CVHk4S8sByCzJOiZuxeEyS4xRUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yrCWdQ+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yrCWdQ+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF479C4CEEA;
	Mon, 23 Jun 2025 21:57:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715861;
	bh=xwp1KuGz6HG3hyissKTcCEki84nVJjuM0A6XFqleOUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yrCWdQ+uUAOQHvn9DdjoroJgtBH4bdf1yMHXuZ2//Qm0cJBkXa6i7goWLg/6l6r/Y
	 sPpZ9UB/IlZGpLbKZZUKoMnE0PmJ8qHbQ6Owm4iUsoKjmbuAc9wHCNANYeGSbPubEp
	 PlWE6aqypj7UQWOn+ZuXWZaWaik7Jp/vr7Rwv8pE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	I Hsin Cheng <richard120310@gmail.com>,
	Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
	Neil Armstrong <neil.armstrong@linaro.org>
Subject: [PATCH 6.1 286/508] drm/meson: Use 1000ULL when operating with mode->clock
Date: Mon, 23 Jun 2025 15:05:31 +0200
Message-ID: <20250623130652.306228557@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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


