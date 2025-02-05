Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5D6F510;
	Wed,  5 Feb 2025 14:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764436; cv=none; b=MTkZ1QQl0fKqmW7pOydL9yVrp/XbiuHFb0wKOEe2myCSLCw8hpBKUtsCTOJa6MqQiLYUYSHj3EXh8bjMidvlkI6JDmWNujPDC0gqSGLAaHeOLbxabTTFSmqbKwVOYXz+4amWD0VyHBO8wIa0FVsOrSNlx+i9krCEPzl+BTp4QK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764436; c=relaxed/simple;
	bh=tNsUcXFzmt0QykcNrFTI7jgyiqMB22Mb6lJ61fcPr+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oRtucJM69UzFgFTkZUHOQd5FzQUThGwJMdw0QXpKrPW1t/ZVB+Bfm6NmxqdpywCVNEOwBhHG7L8DHzGukeB+GhecEY+e0MeGGqDM6YNuBi8Eg9FZjksyAOJXoToC18U38gwBjFAMyB3mvGtXEWM40XqoZqcCj3TCj7gOAH9O51Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TnnfSaKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TnnfSaKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDE8C4CEDD;
	Wed,  5 Feb 2025 14:07:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764436;
	bh=tNsUcXFzmt0QykcNrFTI7jgyiqMB22Mb6lJ61fcPr+s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TnnfSaKM5iwtfLyqCs7M5Iytn/TZjYw/uzSrLdc008wNi4DJaCaNNHhfItlK+hoix
	 uinOqjyqUofaOd5Fpnap9KjQx+Mz/KPe6PDPO8WtODfdBR+PdQaSoPk6g6MMYlrHMX
	 gXkOE6wM2Tkg9R9UezU6yT06ZP6iytEzpUxaWUUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 078/623] drm/bridge: it6505: Change definition of AUX_FIFO_MAX_SIZE
Date: Wed,  5 Feb 2025 14:37:00 +0100
Message-ID: <20250205134459.209886696@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hermes Wu <hermes.wu@ite.com.tw>

[ Upstream commit c14870218c14532b0f0a7805b96a4d3c92d06fb2 ]

The hardware AUX FIFO is 16 bytes
Change definition of AUX_FIFO_MAX_SIZE to 16

Fixes: b5c84a9edcd4 ("drm/bridge: add it6505 driver")
Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Signed-off-by: Hermes Wu <hermes.wu@ite.com.tw>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20241230-v7-upstream-v7-1-e0fdd4844703@ite.corp-partner.google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ite-it6505.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ite-it6505.c b/drivers/gpu/drm/bridge/ite-it6505.c
index 008d86cc562af..cf891e7677c0e 100644
--- a/drivers/gpu/drm/bridge/ite-it6505.c
+++ b/drivers/gpu/drm/bridge/ite-it6505.c
@@ -300,7 +300,7 @@
 #define MAX_CR_LEVEL 0x03
 #define MAX_EQ_LEVEL 0x03
 #define AUX_WAIT_TIMEOUT_MS 15
-#define AUX_FIFO_MAX_SIZE 32
+#define AUX_FIFO_MAX_SIZE 16
 #define PIXEL_CLK_DELAY 1
 #define PIXEL_CLK_INVERSE 0
 #define ADJUST_PHASE_THRESHOLD 80000
-- 
2.39.5



