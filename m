Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A8030DD31;
	Tue,  2 Sep 2025 13:29:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819775; cv=none; b=Jjddsapajwt7YZK7x1YP7PH18qxABuf30Fht+RFdUHETCSvRR4V/ouIXxMYL474dVqDInerScKwKA7y/IbrDOOXU6yKrx3a4SS4tW6Hg1ahqKvnKFr60XEZIJ+OCXM9Ndmo56I0fe1KemjkM6BR/uAfD/JROw6fP3oCI9zSM+Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819775; c=relaxed/simple;
	bh=DiKbeOjPAe7ndQR80UNRWrfUH83P/oEEH0iC84HgO0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UZ8U9UT1D0C+USIzrmz3c1pVqcCqETL8THBTG0WzMzlEzwAPYa9rYXqQpyuXEck2sZUPvXwxjmkGSD62J0DaFPITQeJJk3oQx4G/VtnJDJoGnAuybQkSo+SfZuqgVaTc43X7AL7lsDhuTU6sLQdTtzcqJ+IA2U51LmIHr1O77ck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kHg7NMM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kHg7NMM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BDD3C4CEED;
	Tue,  2 Sep 2025 13:29:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819774;
	bh=DiKbeOjPAe7ndQR80UNRWrfUH83P/oEEH0iC84HgO0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kHg7NMM3IPfDhptGweT+8eooSKEyn7fXZT60ug6iFq72ZxoKL1/28CC1X2TK1zT6b
	 8v3toa/Ni6MXoOnDFyTNGlBUBctICC2T4Z6/27ioyrwzi/RQuE2zWjCvw2YWY6OkqB
	 xv9sHolovAsTGOzuIWROzZn0gBm1y271J8ZkGMGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>,
	CK Hu <ck.hu@mediatek.com>,
	Chun-Kuang Hu <chunkuang.hu@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 103/142] drm/mediatek: mtk_hdmi: Fix inverted parameters in some regmap_update_bits calls
Date: Tue,  2 Sep 2025 15:20:05 +0200
Message-ID: <20250902131952.229380556@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>

[ Upstream commit c34414883f773412964404d77cd2fea04c6f7d60 ]

In mtk_hdmi driver, a recent change replaced custom register access
function calls by regmap ones, but two replacements by regmap_update_bits
were done incorrectly, because original offset and mask parameters were
inverted, so fix them.

Fixes: d6e25b3590a0 ("drm/mediatek: hdmi: Use regmap instead of iomem for main registers")
Signed-off-by: Louis-Alexis Eyraud <louisalexis.eyraud@collabora.com>
Reviewed-by: CK Hu <ck.hu@mediatek.com>
Link: https://patchwork.kernel.org/project/dri-devel/patch/20250818-mt8173-fix-hdmi-issue-v1-1-55aff9b0295d@collabora.com/
Signed-off-by: Chun-Kuang Hu <chunkuang.hu@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/mediatek/mtk_hdmi.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/mediatek/mtk_hdmi.c b/drivers/gpu/drm/mediatek/mtk_hdmi.c
index 8803cd4a8bc9b..4404e1b527b52 100644
--- a/drivers/gpu/drm/mediatek/mtk_hdmi.c
+++ b/drivers/gpu/drm/mediatek/mtk_hdmi.c
@@ -182,8 +182,8 @@ static inline struct mtk_hdmi *hdmi_ctx_from_bridge(struct drm_bridge *b)
 
 static void mtk_hdmi_hw_vid_black(struct mtk_hdmi *hdmi, bool black)
 {
-	regmap_update_bits(hdmi->regs, VIDEO_SOURCE_SEL,
-			   VIDEO_CFG_4, black ? GEN_RGB : NORMAL_PATH);
+	regmap_update_bits(hdmi->regs, VIDEO_CFG_4,
+			   VIDEO_SOURCE_SEL, black ? GEN_RGB : NORMAL_PATH);
 }
 
 static void mtk_hdmi_hw_make_reg_writable(struct mtk_hdmi *hdmi, bool enable)
@@ -310,8 +310,8 @@ static void mtk_hdmi_hw_send_info_frame(struct mtk_hdmi *hdmi, u8 *buffer,
 
 static void mtk_hdmi_hw_send_aud_packet(struct mtk_hdmi *hdmi, bool enable)
 {
-	regmap_update_bits(hdmi->regs, AUDIO_PACKET_OFF,
-			   GRL_SHIFT_R2, enable ? 0 : AUDIO_PACKET_OFF);
+	regmap_update_bits(hdmi->regs, GRL_SHIFT_R2,
+			   AUDIO_PACKET_OFF, enable ? 0 : AUDIO_PACKET_OFF);
 }
 
 static void mtk_hdmi_hw_config_sys(struct mtk_hdmi *hdmi)
-- 
2.50.1



