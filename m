Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015704;
	b=ihC0kwDmkcBru7Bg206EiY9t8GMMe7NB9yemqTT3vpNTsC0bgGl2w98rcxCuc8IlUU6x
	 CfCQ9+N75CqYFKpQKwO53GXwFx7JPs3wq3xZ6TaZ8o9Wl0ktzgDRCSFiBz3RYLoo/Y4DM
	 yPj6Srwth+bgMTVveX65iH4LTE7Ix6Am8/ZQVHVfAlFCwgze0/gCoA6AOALfuk1Fw+Jqu
	 zJBCaPuqkOs1HOKLIOFj3lqGTxV3cFx4uI2FYamCKyC7TwDaRLCuLywT0bFUdRtKH0uZN
	 9Yu23OdQNSj/q0s0CWFlW/xSfMuMnLsjlGmVeBFdI5eqjQRxvnKC9LbKGTyla9IzpDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015704;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=djsOvkYN/jmg1h+BcAIEoqyZFIhtsQyd5IPgax5We9k=;
	b=oen6jc6z6HVVuga2jGVzjz8wHT0fqRtDej+VxKUuFf5lamyV3Y1dOtrf2N4wiVEQfyJA
	 E+NtG2gZSwNq4CgAreamXIiVon8AQL3bcI0eDmUh4/a/LQvIlCaig5YehpP74KMYbNPjf
	 25MQTYzzmA12HRVTe3SAChTp/xYfI7IpBM7o2SJnxJ4De/t/BkU0ppMtTo2sOgVZattZu
	 hHKstUO2h8++wBc55R9nmidO17MAAayZuNPJ5puRV5uUI4JE8J2CoaydesELck0e5RWWO
	 gaRDbL6lV6SNrQhnHFb5Wg80qQimEtVcKlqxH4PAKXYTVW8hjPSkdQv3yo61LoYQN7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="EntQwe7/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A024606A33A;
	Wed, 18 Nov 2026 15:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EntQwe7/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFEC81F000C5;
	Wed, 18 Nov 2026 15:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015704;
	bh=djsOvkYN/jmg1h+BcAIEoqyZFIhtsQyd5IPgax5We9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EntQwe7/qpx5zKLPuQFQEtL+ZFc62a9OaFD+QO4nrDQ53ilX4rpYo9tAHE5GWgCfU
	 3Sz8cUPqtN/xMolDVZTut2DNyPBRzOugG0RgWXFPun7Vc+4Sfpq76IEiAolB9Tjmcu
	 wg4GUXk7EscZbjvNADe9UQS1AhicH0OQvdvhLmcY=
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
Subject: [PATCH 7.3 0268/2651] pwm: mtk-disp: Fix period readback
Date: Wed, 18 Nov 2026 15:25:08 +0100
Message-ID: <20261118150257.556581879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index b5409e15dac86..56d10cde5b460 100644
--- a/drivers/pwm/pwm-mtk-disp.c
+++ b/drivers/pwm/pwm-mtk-disp.c
@@ -210,9 +210,9 @@ static int mtk_disp_pwm_get_state(struct pwm_chip *chip,
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



