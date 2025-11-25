Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E144727B34F;
	Tue, 25 Nov 2025 22:14:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764108872; cv=none; b=Q+G2VEHLVjNB+4Rjc2I8ZEREn4JVA7WGY91v44/9VPrOJvqC06ZJcYTfxsMNIIGPaibcrhoTyEfK1dHSZWf22kloFZmx4AsKQ+SG2xWbgYEgKpGp8Ja6Bb/C54v4WiJLeh4+DskBgaqCdQqtgfQOgIDqBapAzU5ga85dzjAIjhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764108872; c=relaxed/simple;
	bh=7VbNqwAxa2N0OP450xn7XUR+uM75sQSKDCch+WQswe4=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=RTHSMvw0gRUewX+lffBrNOx+ScG+rXNFNL8yKNIZuZ0N8IiPU+hopOBIfFRA0jmiMDiTHUWdkwpWfPz70Z/TgvuzJu/k2gZvVu+6f1n8bvxS035xWSzEhKHaX6Gq50pGwB743/DnQYzCp+682KBm6ZvcK0m4SWo0cVtsydkGK+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Df1krrSE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Df1krrSE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4934C4CEF1;
	Tue, 25 Nov 2025 22:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764108871;
	bh=7VbNqwAxa2N0OP450xn7XUR+uM75sQSKDCch+WQswe4=;
	h=From:Date:Subject:To:Cc:From;
	b=Df1krrSEl3wdi2zNkUX7BEUpByp1N0DkH67EmheG0nQTPU1K6QVPOjYURtZmQEVf2
	 Om6EaatlGCObsv+mtwolZCm/oWWd5+YaF+fJcQlGWvPOG53eW00U1qnx+pqdhlPFZ2
	 T0OkyH1dsaP//A5UIuy/Nfh7FuBFgAvCBGsakOFtjRbAyUzbS00tpQZstQmndUeQi1
	 rks0VOxbNjPVQO7wt0IODVHXzU2CgssjlaqosZE1YAuLNKsolaL/2eooC17cf2Zdf3
	 NOazRzGudmlC1s+nrylXWcIwSeahH3vPHjkFmpSCAUIfLzzUJOtoGfYY7Z8lC3Tgvy
	 NefcgkB6u6xmg==
From: Nathan Chancellor <nathan@kernel.org>
Date: Tue, 25 Nov 2025 15:14:23 -0700
Subject: [PATCH] drm/mediatek: mtk_hdmi_v2: Fix return type of
 mtk_hdmi_v2_tmds_char_rate_valid()
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251125-drm-mediatek-hdmi-v2-wifpts-v1-1-a6c7582cf69a@kernel.org>
X-B4-Tracking: v=1; b=H4sIAD4qJmkC/yXMwQqDMAwA0F+RnA3YQpTtV4YHNVGzUSdN5wbiv
 6+bx3d5O5hEFYNrsUOUTU2fS4YrCxjmbpkElbPBV56c84QcAwZh7ZI8cOaguHl867gmQ66bnsg
 1VFcXyMMaZdTPf7+1p+3V32VIvxKO4wujpQxhfwAAAA==
X-Change-ID: 20251125-drm-mediatek-hdmi-v2-wifpts-d67b55175609
To: Chun-Kuang Hu <chunkuang.hu@kernel.org>, 
 Philipp Zabel <p.zabel@pengutronix.de>
Cc: David Airlie <airlied@gmail.com>, 
 Matthias Brugger <matthias.bgg@gmail.com>, 
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>, 
 Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>, 
 CK Hu <ck.hu@mediatek.com>, dri-devel@lists.freedesktop.org, 
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2369; i=nathan@kernel.org;
 h=from:subject:message-id; bh=7VbNqwAxa2N0OP450xn7XUR+uM75sQSKDCch+WQswe4=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDJlqWi4sKa6RlUEHX+YYpj68/Dzl/capfHcDFkntCmZWv
 JVgzXqzo5SFQYyLQVZMkaX6sepxQ8M5ZxlvnJoEM4eVCWQIAxenAEwkfwfDP532ctkJ97YxMU4T
 kFlRncgS/Ehp3yTJ0K0FEYFnMuZdNmP4K/ND99HBGU/M7q1OOuUzLXXTnU0xWcfPr1eexiCzuPv
 yGR4A
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building with -Wincompatible-function-pointer-types-strict, a
warning designed to catch kernel control flow integrity (kCFI) issues at
build time, there is an instance in the new HDMI v2 drm/mediatek code:

  drivers/gpu/drm/mediatek/mtk_hdmi_v2.c:1331:31: error: incompatible function pointer types initializing 'enum drm_mode_status (*)(const struct drm_bridge *, const struct drm_display_mode *, unsigned long long)' with an expression of type 'int (const struct drm_bridge *, const struct drm_display_mode *, unsigned long long)' [-Werror,-Wincompatible-function-pointer-types-strict]
   1331 |         .hdmi_tmds_char_rate_valid = mtk_hdmi_v2_hdmi_tmds_char_rate_valid,
        |                                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

While 'int' and 'enum drm_mode_status' are ABI compatible, hence no
regular warning from -Wincompatible-function-pointer-types, the mismatch
will trigger a kCFI violation when mtk_hdmi_v2_tmds_char_rate_valid() is
called indirectly.

Update the return type of mtk_hdmi_v2_tmds_char_rate_valid() to be 'enum
drm_mode_status' to clear up the warning and kCFI violation.

Fixes: 8d0f79886273 ("drm/mediatek: Introduce HDMI/DDC v2 for MT8195/MT8188")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi_v2.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c b/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
index c272e1e74b7d..454b8b93b834 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi_v2.c
@@ -1120,9 +1120,10 @@ static void mtk_hdmi_v2_hpd_disable(struct drm_bridge *bridge)
 	mtk_hdmi_v2_disable(hdmi);
 }
 
-static int mtk_hdmi_v2_hdmi_tmds_char_rate_valid(const struct drm_bridge *bridge,
-						 const struct drm_display_mode *mode,
-						 unsigned long long tmds_rate)
+static enum drm_mode_status
+mtk_hdmi_v2_hdmi_tmds_char_rate_valid(const struct drm_bridge *bridge,
+				      const struct drm_display_mode *mode,
+				      unsigned long long tmds_rate)
 {
 	if (mode->clock < MTK_HDMI_V2_CLOCK_MIN)
 		return MODE_CLOCK_LOW;

---
base-commit: a846505a193d7492ad3531e33cacfca31e4bcdd1
change-id: 20251125-drm-mediatek-hdmi-v2-wifpts-d67b55175609

Best regards,
--  
Nathan Chancellor <nathan@kernel.org>

