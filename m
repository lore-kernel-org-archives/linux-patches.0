Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75F1F28B4F0;
	Tue,  2 Sep 2025 13:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819397; cv=none; b=T7p8e4Gr1tf+UpEeFG/EamIK5lsOul8w0I6p6Orp5sceGPjwiPB1VyPrS+58w1YMiwnZAp5xfTq/KPIfMLy3WBRKRfptt/FCxZ1xzXmQYXpVva24PKHd5IR7c1kkbSrbAoJWzM+i89dMaWY7C0oPOA43WB3fpeAkN4zHja5Z+6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819397; c=relaxed/simple;
	bh=JJIFdLDK9AcIAsZD8uHkByWgPeIFjdAj45+JflZtMAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uYyq+TinfkG82t2PUSJE4qyPi4PYkLAeK8c4VJ7O0vLNy71z7NkS0iHryOiucMzPBUvDsMh0FVcdEHa/z0eUY1Fpvm9KzfLyckkL/7j3c28EAfNqHoqZu2Z4HBh35Lb0SBL1pF1s66TkOSpEly1M543EyuzosO0W5HvRYBrIhlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aemevwNk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aemevwNk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78FB9C4CEED;
	Tue,  2 Sep 2025 13:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819395;
	bh=JJIFdLDK9AcIAsZD8uHkByWgPeIFjdAj45+JflZtMAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aemevwNkXPiK4m03K3loAwRyyXO1aWbw6FE+qUHYHRC+OhXr5a9LSWQJdddxxCHoh
	 oD0WfjFfCJAv4CaOBTmlUKHWEEH43GRM+VETDDejynahJhdL88HM0/p8p9CGG/GZ1x
	 rgM5rkmyBTZMj4+PI3G+1swg1kfXRj7m9Pr9yh5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 021/142] ASoC: rt721: fix FU33 Boost Volume control not working
Date: Tue,  2 Sep 2025 15:18:43 +0200
Message-ID: <20250902131948.958989934@linuxfoundation.org>
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

From: Shuming Fan <shumingf@realtek.com>

[ Upstream commit 633e391d45bda3fc848d26bee6bbe57ef2935713 ]

This patch fixed FU33 Boost Volume control not working.

Signed-off-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250808055706.1110766-1-shumingf@realtek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt721-sdca.c | 2 ++
 sound/soc/codecs/rt721-sdca.h | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/sound/soc/codecs/rt721-sdca.c b/sound/soc/codecs/rt721-sdca.c
index ba080957e9336..98d8ebc6607ff 100644
--- a/sound/soc/codecs/rt721-sdca.c
+++ b/sound/soc/codecs/rt721-sdca.c
@@ -278,6 +278,8 @@ static void rt721_sdca_jack_preset(struct rt721_sdca_priv *rt721)
 		RT721_ENT_FLOAT_CTL1, 0x4040);
 	rt_sdca_index_write(rt721->mbq_regmap, RT721_HDA_SDCA_FLOAT,
 		RT721_ENT_FLOAT_CTL4, 0x1201);
+	rt_sdca_index_write(rt721->mbq_regmap, RT721_BOOST_CTRL,
+		RT721_BST_4CH_TOP_GATING_CTRL1, 0x002a);
 	regmap_write(rt721->regmap, 0x2f58, 0x07);
 }
 
diff --git a/sound/soc/codecs/rt721-sdca.h b/sound/soc/codecs/rt721-sdca.h
index 0a82c107b19a2..71fac9cd87394 100644
--- a/sound/soc/codecs/rt721-sdca.h
+++ b/sound/soc/codecs/rt721-sdca.h
@@ -56,6 +56,7 @@ struct rt721_sdca_dmic_kctrl_priv {
 #define RT721_CBJ_CTRL				0x0a
 #define RT721_CAP_PORT_CTRL			0x0c
 #define RT721_CLASD_AMP_CTRL			0x0d
+#define RT721_BOOST_CTRL			0x0f
 #define RT721_VENDOR_REG			0x20
 #define RT721_RC_CALIB_CTRL			0x40
 #define RT721_VENDOR_EQ_L			0x53
@@ -93,6 +94,9 @@ struct rt721_sdca_dmic_kctrl_priv {
 /* Index (NID:0dh) */
 #define RT721_CLASD_AMP_2CH_CAL			0x14
 
+/* Index (NID:0fh) */
+#define RT721_BST_4CH_TOP_GATING_CTRL1		0x05
+
 /* Index (NID:20h) */
 #define RT721_JD_PRODUCT_NUM			0x00
 #define RT721_ANALOG_BIAS_CTL3			0x04
-- 
2.50.1



