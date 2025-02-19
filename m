Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 805131C2432;
	Wed, 19 Feb 2025 09:06:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956003; cv=none; b=PGPBfqcBZqlbXGoJAmrs2DWmaCe3/9jzg/++2w4PmYh3vuOPMV8QnVZvT5UMvQvRe7lmqa/N9SC/7aGsZvjQdmImOswPg/vuwEA4tSsFrlfOsdFKkCPGMYNrazgyQV/+lyNPo0ZnFzuqVn7ojNmDWGDuG/YViIgYRtWHcbsjv/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956003; c=relaxed/simple;
	bh=hq4hsi25/vlY+wel0u40qDdSVa7b4l3VJsC32AilYyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iXraWX8PO0eBoGl2CfUfehLpI3yV883GxxVzw7TXL5xRz4fHjEL5bwENbkkVzIQh+CJKBkx15PSCVJ6LBngynpS/JDdPltTytb97FrHfhQRC80KKX3WSTW4wy10T9SECHVrzswT+fJlpHDayIfcUc3oHJJXLcvtCklx8KAUH4FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R6RUrPA4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R6RUrPA4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03478C4CED1;
	Wed, 19 Feb 2025 09:06:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956003;
	bh=hq4hsi25/vlY+wel0u40qDdSVa7b4l3VJsC32AilYyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R6RUrPA4pNStBkejfQa2If94Wrr9Lt1Bx192Li87wfoSaOJ6eQyDWcS8eCQZ/TVfO
	 egBEme7dYbo46eB1//cPZ4h2kWctg9TA6KAC7jPpHiaYgL9OVl7jUzWEHDVqf4h6d6
	 K9h0qfUUV47qJuWbGAjQ+td7QToEZwYVY4PIX520=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Hermes Wu <hermes.wu@ite.com.tw>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 032/578] drm/bridge: it6505: Change definition of AUX_FIFO_MAX_SIZE
Date: Wed, 19 Feb 2025 09:20:36 +0100
Message-ID: <20250219082654.161013009@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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
index 5a23277be4445..45596b211fb88 100644
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



