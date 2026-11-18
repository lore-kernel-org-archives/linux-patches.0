Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055485;
	b=nfNYCG6PkdGDjgmTQB2aSDO7fsthZETi5U5bgh5oSEtoEYWA82UwJHwBgnwsSHDzcj5s
	 1mC5WIbb3rhtk9Ccxjp9VnR95eQzlLyKJkoo/40Pi7fVl4Gf+hOMr8isWjSa8RqT6pbfb
	 IeqjelCyiqwKlK9actzGr89PYUX/7xDL9mKrw03lCt6c5w6vAu2tyLg6H/ashiFm/ge7a
	 9v/wJtQuvxCrJ20GBtwxt3Wc1QHyV9ZyXcn8EiXBNHd30A1U9ZO67kAIef2lGkc6Jp/Bs
	 sybMIKzDtf8h60Rc6IFSBUHwDBKpIAs/dVZ9KpCv2st62bd1MUHf8HjR0u4no5UMrIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055485;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lMUQ8FWzjVULPquvnIjJA61P5HnMVxzI3jnVF8mJaGY=;
	b=eE9bDssaHJamc3XOOCFW4nt5IiiC4W9/Y5yyu2EhxgHZqIoAJYAbhRMKlsm6ufaXVFpj
	 mYOy3Wlwhlc5Qp7HYiL6PVxm3CG4JVwTWlAouL/OEkw2AaWHTssWbFp/xPqtxCEyHGIDc
	 +J7H7757CoOU4MgmmbmcNLrGsH1nsCISRES6flXr0/vsqVH2ubKkkmYiUjIqQGrh3K3Bn
	 7OMOFXcAvZzPe3gPrpyo1h96DqSi5mUTrTu1cRJ2US5taIHNxt+uOzJctHSTu/lmr2Ox/
	 LNzKa7zlNTz0WGNbJPvMCBVaQ5noO5XpkXshmVNkGOpoduHZlqafOwA1J4OddPM7kRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QXvUEyEq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A9C6606A320;
	Thu, 19 Nov 2026 02:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QXvUEyEq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82ABF1F000C4;
	Thu, 19 Nov 2026 02:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055485;
	bh=lMUQ8FWzjVULPquvnIjJA61P5HnMVxzI3jnVF8mJaGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QXvUEyEq3QWgbZzYKLjFspnrsWKUSB8BZlN/PirfiJAEfy92R15rvw2HlAzCXCx/e
	 JkNXd7eZzQ2UfX6/5stFxRZUjRc1CiUpgTTxag2Pxu1I6AuXKrbU4kpeGpLLMviWmu
	 zXvhdLdEdbjwh0UaJ7mHPW9U4AyWMVLlJ6DurvcU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1649/2214] ASoC: mediatek: mt8192: mt8192-afe-gpio: Use guard() for mutex locks
Date: Wed, 18 Nov 2026 15:55:25 +0100
Message-ID: <20261118150117.868821515@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 14edf39daefbf7aa689ea2bb8811a85c498e0ff6 ]

Convert the explicit mutex_lock()/mutex_unlock() pair to guard(mutex)
to simplify the locking logic and automatically release the mutex on
all exit paths.

This changes the mutex release point from immediately before dev_warn()
to automatic cleanup at scope exit. However, the affected path only emits
a warning and immediately returns -EINVAL, without any further processing.

Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260610102021.83273-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 411be3902fa8 ("ASoC: mediatek: mt8192: Propagate errors in mt8192_afe_gpio_request()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-gpio.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
index 165663a78e36a..88dca80cd69c7 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -209,7 +209,7 @@ static int mt8192_afe_gpio_adda_ch34_ul(struct device *dev, bool enable)
 int mt8192_afe_gpio_request(struct device *dev, bool enable,
 			    int dai, int uplink)
 {
-	mutex_lock(&gpio_request_mutex);
+	guard(mutex)(&gpio_request_mutex);
 	switch (dai) {
 	case MT8192_DAI_ADDA:
 		if (uplink)
@@ -297,11 +297,9 @@ int mt8192_afe_gpio_request(struct device *dev, bool enable,
 		}
 		break;
 	default:
-		mutex_unlock(&gpio_request_mutex);
 		dev_warn(dev, "%s(), invalid dai %d\n", __func__, dai);
 		return -EINVAL;
 	}
-	mutex_unlock(&gpio_request_mutex);
 
 	return 0;
 }
-- 
2.53.0



