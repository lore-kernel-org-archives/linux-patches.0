Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047931;
	b=PiWSSAFDRv2ueL84jCAy5zz7LLSzQ6GEJ13vNSrd+9kPsJZfHQnkuXMyKRxBsrC8vxxK
	 m3hoIOI31+KjLeENNx4b+nJG8h9eYYr7tkRY11iLeBjd5xqQG5Y6hEbkqRuarMw+v7QFE
	 apwnwNHolUOeK+WDCDUGNZiy+2FBJZPMdBA/kjoEjK3K3MQ6M4p0hLkhitiLCb1bG7jmk
	 wJuSA9fu7hYZ+9v2oHl7ppsCJLi8urMLjg5P2E4Bx3V38gfK9zJxpAR1pRRNgT/97E+qb
	 SroL7IOWNwOWy6IW6dIwonUxH8FDm5jKiqmzUeY7qzZ7zh8LzUc/CaF6697xJYTV7bw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047931;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=ArUN4GCZ6TbuYGQI667HhFS/TQqa3KAdxjOVUdmsnaI=;
	b=OxX/6Ydf4Zkzw1plbHJqQtGOpfcFvUTQ9WOhvCvj3M6YpvjcIBKnRQd9wM/SRYUtTP/a
	 B6qrjIxmIfnzbSpQK/DKMpo1qWg6whCJeLm4hsivRgjR+V8L+Vith5Fy/Pk8dygfAWOWR
	 5pfPZJUnnJAg/PfBraA9/8r2P28hEkNR+NGaKZbxO5G8Cuph7WZLl+wFm+XR53y7t547L
	 yFM+ma7P5QDGJnfPMvFXIgYgKSKofjfWMDr3yW6PgDCVTZY4A37g3Or3BuJChGn8GoxlR
	 d5Xy77iaU+Vg/kfef0AopTXQ7/eaLY6QndTg27hocKMv6/pKr+xJ6Tw+7zhN1fchHlA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roZiUdOd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C09F606A320;
	Thu, 19 Nov 2026 00:25:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=roZiUdOd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC9C41F000CC;
	Thu, 19 Nov 2026 00:25:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047931;
	bh=ArUN4GCZ6TbuYGQI667HhFS/TQqa3KAdxjOVUdmsnaI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=roZiUdOdCQgI1zxy+Z5VnhZYueHF5ClglsgKm8v8LYNuFfscEefIzJbh99R1yzZd8
	 JbzUW6ZpKN6KZPKfJmRxlyn6r+s6jggXDm/zrwuTevQ8+Oaa1Ebt/bWGhuEo1U/f1h
	 w6O0kJtkjQoF3xyYLuqHBGM3bhsEVHoQy8V2es5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jitao Shi <jitao.shi@mediatek.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Fei Shao <fshao@chromium.org>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <ukleinek@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1812/2857] pwm: mtk-disp: Fix period readback
Date: Wed, 18 Nov 2026 15:47:26 +0100
Message-ID: <20261118150306.488766549@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen-Yu Tsai <wenst@chromium.org>

[ Upstream commit c5b29baad42b2b02389cc6a716697a8a63209930 ]

The period value stored in the register is the number of clock cycles - 1.

Account for the offset when calculating the period in nanoseconds. This
fixes the discrepancy reported by the pwm core when CONFIG_PWM_DEBUG=1:

    mediatek-disp-pwm 1100e000.pwm: .apply is not idempotent
    	(ena=1 pol=0 281500/499875) -> (ena=1 pol=0 281500/499750)

Calculation discrepancy in the driver was found by AI run by a colleague
while debugging another PWM related issue. Check against SoC datasheet
and fix done by the author.

Fixes: 3f2b16734914 ("pwm: mtk-disp: Implement atomic API .get_state()")
Cc: Jitao Shi <jitao.shi@mediatek.com>
Signed-off-by: Chen-Yu Tsai <wenst@chromium.org>
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Reviewed-by: Fei Shao <fshao@chromium.org>
Link: https://patch.msgid.link/20260827105738.8570-1-wenst@chromium.org
[ukleinek: Adapt comment accordingly]
Signed-off-by: Uwe Kleine-König <ukleinek@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pwm/pwm-mtk-disp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/pwm/pwm-mtk-disp.c b/drivers/pwm/pwm-mtk-disp.c
index db286284f3ee0..2d7e5424493f3 100644
--- a/drivers/pwm/pwm-mtk-disp.c
+++ b/drivers/pwm/pwm-mtk-disp.c
@@ -212,9 +212,9 @@ static int mtk_disp_pwm_get_state(struct pwm_chip *chip,
 	period = FIELD_GET(PWM_PERIOD_MASK, con1);
 	/*
 	 * period has 12 bits, clk_div 11 and NSEC_PER_SEC has 30,
-	 * so period * (clk_div + 1) * NSEC_PER_SEC doesn't overflow.
+	 * so (period + 1) * (clk_div + 1) * NSEC_PER_SEC doesn't overflow.
 	 */
-	state->period = DIV64_U64_ROUND_UP(period * (clk_div + 1) * NSEC_PER_SEC, rate);
+	state->period = DIV64_U64_ROUND_UP((period + 1) * (clk_div + 1) * NSEC_PER_SEC, rate);
 	high_width = FIELD_GET(PWM_HIGH_WIDTH_MASK, con1);
 	state->duty_cycle = DIV64_U64_ROUND_UP(high_width * (clk_div + 1) * NSEC_PER_SEC,
 					       rate);
-- 
2.53.0



