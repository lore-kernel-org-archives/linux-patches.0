Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92F8E17109B;
	Mon, 28 Oct 2024 06:47:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098038; cv=none; b=gl+TPzIIQnrXks+M5JkGP4HyjsD6VxdVo7JmRImGdbQ3ZS+tCF6Ctea32kcF+cgBLH/JYTrmRZUa7/t8tgG43acoM6ZgZv4gULiLku72HElRuNFnt9zSbbiTO0MSFhbtB+RRIT2aF2s29Dsd683XALHBYPGfG+Bpemk5rKW1ivI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098038; c=relaxed/simple;
	bh=FVuP/Y7d9gJd8MttiFF+6cksBFWbPjh9UzbqC/kspPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHNDMtUEgdceFiAl5vDD/sdRnIgY7p/9nU5X9hngFTtfBiuuuGQwEbTRmUCVXnNYTPwNETfaoABkhTqEhwBdLUYwgUUcUffhoHY+m/AHcyyySN6gvPLQvzdtz6GohDBaLbM1MFgsVNBbdeANI3OoyPqQTlWKUmjHQfD4OKsuroE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xc52ne2e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xc52ne2e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31D38C4CEC3;
	Mon, 28 Oct 2024 06:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098038;
	bh=FVuP/Y7d9gJd8MttiFF+6cksBFWbPjh9UzbqC/kspPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xc52ne2eOEAw7p4R154Odpw/7+Tc1kimOTALCzYwN0FSFYpmehbabYTJyhX7XrYnz
	 Pc5xTIGNsohm9bSX33762qX1H4NxE0T1w+lyEUUu2H7l37RBb4ApTW/hxeNxk7pmnq
	 Ok0+ENdzsvs7ELStJYK++E++mol4qOMXO7CO3syo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cong Yang <yangcong5@huaqin.corp-partner.google.com>,
	Douglas Anderson <dianders@chromium.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 049/261] drm/panel: himax-hx83102: Adjust power and gamma to optimize brightness
Date: Mon, 28 Oct 2024 07:23:11 +0100
Message-ID: <20241028062313.243338428@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Yang <yangcong5@huaqin.corp-partner.google.com>

[ Upstream commit fcf38bc321fbc87dfcd829f42e64e541f17599f7 ]

The current panel brightness is only 360 nit. Adjust the power and gamma to
optimize the panel brightness. The brightness after adjustment is 390 nit.

Fixes: 3179338750d8 ("drm/panel: himax-hx83102: Support for IVO t109nw41 MIPI-DSI panel")
Signed-off-by: Cong Yang <yangcong5@huaqin.corp-partner.google.com>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Douglas Anderson <dianders@chromium.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241011020819.1254157-1-yangcong5@huaqin.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-himax-hx83102.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/panel/panel-himax-hx83102.c b/drivers/gpu/drm/panel/panel-himax-hx83102.c
index 6e4b7e4644ce0..8b48bba181316 100644
--- a/drivers/gpu/drm/panel/panel-himax-hx83102.c
+++ b/drivers/gpu/drm/panel/panel-himax-hx83102.c
@@ -298,7 +298,7 @@ static int ivo_t109nw41_init(struct hx83102 *ctx)
 	msleep(60);
 
 	hx83102_enable_extended_cmds(&dsi_ctx, true);
-	mipi_dsi_dcs_write_seq_multi(&dsi_ctx, HX83102_SETPOWER, 0x2c, 0xed, 0xed, 0x0f, 0xcf, 0x42,
+	mipi_dsi_dcs_write_seq_multi(&dsi_ctx, HX83102_SETPOWER, 0x2c, 0xed, 0xed, 0x27, 0xe7, 0x52,
 				     0xf5, 0x39, 0x36, 0x36, 0x36, 0x36, 0x32, 0x8b, 0x11, 0x65, 0x00, 0x88,
 				     0xfa, 0xff, 0xff, 0x8f, 0xff, 0x08, 0xd6, 0x33);
 	mipi_dsi_dcs_write_seq_multi(&dsi_ctx, HX83102_SETDISP, 0x00, 0x47, 0xb0, 0x80, 0x00, 0x12,
@@ -343,11 +343,11 @@ static int ivo_t109nw41_init(struct hx83102 *ctx)
 				     0xaa, 0xaa, 0xaa, 0xaa, 0xaa, 0xa0, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 				     0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
 				     0x00, 0x00, 0x00, 0x00, 0x00, 0x00);
-	mipi_dsi_dcs_write_seq_multi(&dsi_ctx, HX83102_SETGMA, 0x04, 0x04, 0x06, 0x0a, 0x0a, 0x05,
-				     0x12, 0x14, 0x17, 0x13, 0x2c, 0x33, 0x39, 0x4b, 0x4c, 0x56, 0x61, 0x78,
-				     0x7a, 0x41, 0x50, 0x68, 0x73, 0x04, 0x04, 0x06, 0x0a, 0x0a, 0x05, 0x12,
-				     0x14, 0x17, 0x13, 0x2c, 0x33, 0x39, 0x4b, 0x4c, 0x56, 0x61, 0x78, 0x7a,
-				     0x41, 0x50, 0x68, 0x73);
+	mipi_dsi_dcs_write_seq_multi(&dsi_ctx, HX83102_SETGMA, 0x00, 0x07, 0x10, 0x17, 0x1c, 0x33,
+				     0x48, 0x50, 0x57, 0x50, 0x68, 0x6e, 0x71, 0x7f, 0x81, 0x8a, 0x8e, 0x9b,
+				     0x9c, 0x4d, 0x56, 0x5d, 0x73, 0x00, 0x07, 0x10, 0x17, 0x1c, 0x33, 0x48,
+				     0x50, 0x57, 0x50, 0x68, 0x6e, 0x71, 0x7f, 0x81, 0x8a, 0x8e, 0x9b, 0x9c,
+				     0x4d, 0x56, 0x5d, 0x73);
 	mipi_dsi_dcs_write_seq_multi(&dsi_ctx, HX83102_SETTP1, 0x07, 0x10, 0x10, 0x1a, 0x26, 0x9e,
 				     0x00, 0x4f, 0xa0, 0x14, 0x14, 0x00, 0x00, 0x00, 0x00, 0x12, 0x0a, 0x02,
 				     0x02, 0x00, 0x33, 0x02, 0x04, 0x18, 0x01);
-- 
2.43.0



