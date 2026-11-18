Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024794;
	b=EOpjfWASVFlE1pWdlMclzWkxufLlXjE3mluXBxeciREAYJjSq0JWnAK4YaiCHiahphRZ
	 4iAMOCBWelZ0AZvWqFCwJdKG75k3U//TCdVbNsPA5+6Ed5zZIHF0P6/qYtCWG1OJ7dR3I
	 O0elUX+Umjk0kRRUqhX3BXt9C5oEwrm1upBA4R8KQg1b08jrjoDyMlgBdk82ObyDzTAEl
	 xqviqXSLIrd13xmpo9mXVSm81iemel6PTBkssQuJD/glaZpuKkcpi1WcGMKDalriGFHZ0
	 d8BIyQKr2jFjB5uGzAUCGmlcaIP/t79MO1WwIKbfspWHa40w/Hbeaqlxc8i300XFWxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024794;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9TRfd9XPyas9Sl0Xu3X1u/xa65eO1IqcK+R23DpGrSU=;
	b=GVtgwcbx4R1Fc5yo3uFOyty3o5PbQW4owdAT/k4ynHU98IrRTSHFKG99FvyrnNQkvDGO
	 /rYHrOa8J8qdTlOZD08uJTdX2lZu2XUb9IK9ZumT5mZit6kWBx9g6LBGfSz0CCoOsbotZ
	 wZ0BxmUlS/WGfReUdjcHzRHMJi3znR7zzQxcQpYMBNEFVstFXgMJrzSZJKGRYabo41HW6
	 4dcX++8gBRYi4KCwSdEcAAt5TmywiFgrZ9a4bcyfh/xDVho7mfWaeJZ3vOzJ/ZgQw/var
	 Mr5MAn7xMlAKijBHYd7grjnnLggQnfTYShPUiN8TZB5e/F31Big4xwch/kwn7RBfL9w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d036iEkf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2737F606A31C;
	Wed, 18 Nov 2026 17:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d036iEkf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CD341F000C4;
	Wed, 18 Nov 2026 17:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024794;
	bh=9TRfd9XPyas9Sl0Xu3X1u/xa65eO1IqcK+R23DpGrSU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d036iEkfH9xa11Rxf4jwLXUfsYdYedlw+dgZxDHh8M9s8n/fFK6DDSWZfCNOobiZm
	 fWwcAoa20O0lRRCcYC1s8E/F4JkxCdS7itmd5KHrrX1PwPKEnRcKQvDD6hxBJwPtiX
	 RkzC+oW/vmmVaL9II3wtFbkgwNymdL/eZ/S8MLb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0824/2151] ASoC: mediatek: mt8192: mt8192-afe-gpio: Use guard() for mutex locks
Date: Wed, 18 Nov 2026 15:42:39 +0100
Message-ID: <20261118150152.146292497@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index de5e1deaa167d..b993ca2dbd7c8 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-gpio.c
@@ -208,7 +208,7 @@ static int mt8192_afe_gpio_adda_ch34_ul(struct device *dev, bool enable)
 int mt8192_afe_gpio_request(struct device *dev, bool enable,
 			    int dai, int uplink)
 {
-	mutex_lock(&gpio_request_mutex);
+	guard(mutex)(&gpio_request_mutex);
 	switch (dai) {
 	case MT8192_DAI_ADDA:
 		if (uplink)
@@ -296,11 +296,9 @@ int mt8192_afe_gpio_request(struct device *dev, bool enable,
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



