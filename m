Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6AB8F59
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:02:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2034AC433C7;
	Tue, 25 Jul 2023 11:02:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282946;
	bh=/bi/n13EhkQIvQMtuRSki9i9QSE/wiahr4R11XxqrSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q6ou0OR2CIT980cB0Uq40HDbrcXGie42rDvpTVLWXy2IXyU80mkShxdReyriPzqdH
	 VEo1tvThrZuHAqUnHqGjfaPBTHmzJu3T520o2T9lU7jm8Ai0ik+DJNzO4Q4uZkXJts
	 BUDU3tR1lRMzCum1FZ3bhMwgo4ffXYx248hiSRf0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan+linaro@kernel.org>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 083/183] ASoC: codecs: wcd938x: fix mbhc impedance loglevel
Date: Tue, 25 Jul 2023 12:45:11 +0200
Message-ID: <20230725104510.948513134@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit e5ce198bd5c6923b6a51e1493b1401f84c24b26d ]

Demote the MBHC impedance measurement printk, which is not an error
message, from error to debug level.

While at it, fix the capitalisation of "ohm" and add the missing space
before the opening parenthesis.

Fixes: bcee7ed09b8e ("ASoC: codecs: wcd938x: add Multi Button Headset Control support")
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20230630142717.5314-2-johan+linaro@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wcd938x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/codecs/wcd938x.c b/sound/soc/codecs/wcd938x.c
index df0b3ac7f1321..7715040383840 100644
--- a/sound/soc/codecs/wcd938x.c
+++ b/sound/soc/codecs/wcd938x.c
@@ -2165,8 +2165,8 @@ static inline void wcd938x_mbhc_get_result_params(struct wcd938x_priv *wcd938x,
 	else if (x1 < minCode_param[noff])
 		*zdet = WCD938X_ZDET_FLOATING_IMPEDANCE;
 
-	pr_err("%s: d1=%d, c1=%d, x1=0x%x, z_val=%d(milliOhm)\n",
-		__func__, d1, c1, x1, *zdet);
+	pr_debug("%s: d1=%d, c1=%d, x1=0x%x, z_val=%d (milliohm)\n",
+		 __func__, d1, c1, x1, *zdet);
 ramp_down:
 	i = 0;
 	while (x1) {
-- 
2.39.2



