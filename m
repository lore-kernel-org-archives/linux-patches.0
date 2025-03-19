Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0480220551C;
	Wed, 19 Mar 2025 14:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395214; cv=none; b=EUgHbmhcVxcTrUCDwMX5kRjASJatv2ePCoKYsLVtqJTvCBicajCG3wUvUiKIgfE9ao1oLOoK6zlNsnCv3fHX9wE1fAAIZGZV4MAAKBLew7F/6SbMXzaYVVqjnQhwtAtli65n/YYFYZ4g9IqOIUD8xHI9INO21gfcjKUBkI2eFRI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395214; c=relaxed/simple;
	bh=x6f7gfa1nTw1mART+/7qqnTTVreYcaK0wsf/hlkRlE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hu1Ib18r6KHySWxyrgKd+bDw5MplAB8IUnyZQpXlBOisooEMnThd6eOkiNRsl18bJcriuHPrm3wAgSuNkiNpGWm771OimhYNfgrQiVfgvKb6dTj6319Wv2vX9ErvLyrrjlQaIt21+kMxDCl6sra+8d18EzIH8j3gH5Y80oe0HqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXe/p6qp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXe/p6qp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB1A6C4CEE4;
	Wed, 19 Mar 2025 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395213;
	bh=x6f7gfa1nTw1mART+/7qqnTTVreYcaK0wsf/hlkRlE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bXe/p6qpgI2cG8NICXwKTV4aNusVq4ap1hDopoyHuDtHe/6dLff3A6t4b2jmnfMj4
	 Uy2SOiq+4mHOJ02aseRCdNuDFINBbR3zs2o2MHX3dSOBWe1tdxYGTseHQP4NimT5JH
	 Z3i6hO5T56yWGTDz100N2OGmB08hDjyWdnlx0bgQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neal Gompa <neal@gompa.dev>,
	Hector Martin <marcan@marcan.st>,
	James Calligeros <jcalligeros99@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 084/166] ASoC: tas2764: Fix power control mask
Date: Wed, 19 Mar 2025 07:30:55 -0700
Message-ID: <20250319143022.295525127@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

From: Hector Martin <marcan@marcan.st>

[ Upstream commit a3f172359e22b2c11b750d23560481a55bf86af1 ]

Reviewed-by: Neal Gompa <neal@gompa.dev>
Signed-off-by: Hector Martin <marcan@marcan.st>
Signed-off-by: James Calligeros <jcalligeros99@gmail.com>
Link: https://patch.msgid.link/20250218-apple-codec-changes-v2-1-932760fd7e07@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tas2764.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tas2764.h b/sound/soc/codecs/tas2764.h
index 168af772a898f..d13ecae9c9c2f 100644
--- a/sound/soc/codecs/tas2764.h
+++ b/sound/soc/codecs/tas2764.h
@@ -25,7 +25,7 @@
 
 /* Power Control */
 #define TAS2764_PWR_CTRL		TAS2764_REG(0X0, 0x02)
-#define TAS2764_PWR_CTRL_MASK		GENMASK(1, 0)
+#define TAS2764_PWR_CTRL_MASK		GENMASK(2, 0)
 #define TAS2764_PWR_CTRL_ACTIVE		0x0
 #define TAS2764_PWR_CTRL_MUTE		BIT(0)
 #define TAS2764_PWR_CTRL_SHUTDOWN	BIT(1)
-- 
2.39.5



