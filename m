Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C59E145A03;
	Thu, 13 Feb 2025 15:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460127; cv=none; b=K6Zhv84XLWGgaQtVl7HevFXRW/jssJLuqpbzs3uKlfllfWiqdlGtg6qQEOmbeMBkpwHQ0ho88sy+d6sqLipRCdZJy3eeXkOyZwRRSaqB/c8GO3IfkVF3Uw1t+s09wRP7vSxnnUYGdSXJBSOr2yJB+gzxl9BH8SiIrINf+6WdHIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460127; c=relaxed/simple;
	bh=/Pgg7L9CGHk/+MYkX55y/TEs/xcSNk4WTkxohRo9ISw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pLW1V8jwA4KAT2CgsHAHiBzd/Ype3iiN9xqbzEyxHAkTWXzvyNAfjJ8Du8JTEnLNvCAIjkN7ksW9FBlbk0yjroxCB6dDUqApj9TWqO1TtscM6TuSp4kmztUYUsT59CvTHvaFFSIJqB7x3Y56fMaFyCLqZPo82glrLCZb7fZCqns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VET9ldzQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VET9ldzQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42FA2C4CED1;
	Thu, 13 Feb 2025 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460126;
	bh=/Pgg7L9CGHk/+MYkX55y/TEs/xcSNk4WTkxohRo9ISw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VET9ldzQawJMbeXHxufp0NBqzpsokDb9qxhkYq6rxfPuLXaZovnomjP5wTfcRtg0R
	 TEzdy19KAS2PfTvbqVwLSGkGYtFk9TD9jTxGpkerL8C2eE/1PnHkIeIjpWWbGTl4ts
	 bgptf47NL5pi5rszKvG3GYt+29V08JFQP+4i3s3I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 022/273] drm/bridge: it6505: Change definition MAX_HDCP_DOWN_STREAM_COUNT
Date: Thu, 13 Feb 2025 15:26:34 +0100
Message-ID: <20250213142408.238855269@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

From: Hermes Wu <hermes.wu@ite.com.tw>

[ Upstream commit 85597bc0d70c287ba41f17d14d3d857a38a3d727 ]

A HDCP source device shall support max downstream to 127 devices.
Change definition MAX_HDCP_DOWN_STREAM_COUNT to 127

KSVs shall save for DRM blocked devices check.
This results in struct it6505 growth by ~0.5 KiB.

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-4-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 24c5a926af8d1..bd4c8f5d55a64 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -295,7 +295,7 @@
 #define MAX_LANE_COUNT 4
 #define MAX_LINK_RATE HBR
 #define AUTO_TRAIN_RETRY 3
-#define MAX_HDCP_DOWN_STREAM_COUNT 10
+#define MAX_HDCP_DOWN_STREAM_COUNT 127
 #define MAX_CR_LEVEL 0x03
 #define MAX_EQ_LEVEL 0x03
 #define AUX_WAIT_TIMEOUT_MS 15
-- 
2.39.5



