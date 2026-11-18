Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039376;
	b=k4PR7RJl4C3kFWYRgvXUclEJoiILrlo8JzSmLhloD1P8abIa5pHDV4VdWuwVEu70Xe9q
	 unD/vF5hhQfKLjOeuQAZRSjC9n7tsWf3TvSV/MQQFSAizTu6DyvbbNPmxdqZCkYHDxCeY
	 kho1RTwtLTToaFhrZgiVGOzWynEOXudhRQrRjd+gx/UFoGEF/ywS4nPV2gyqHlDGhn9pA
	 pL6SxANa4a9lzXGsBZ5IzSb5vlgY4pYLghpl6aSmWBr4syUc1rReFNbyiAMMXNvfW1HId
	 6BBQ5Y+hcdlTVJezhKAfIG9wFdhYORuzpyZfSJBMPQ9HTjNPUmdz7h0ZDUOvNkHOWsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039376;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=d4NW8H+4KROJPf5bOlljcUhhfn/9vRF+3jhlAW1z22c=;
	b=RMW7+4+crrsVKgqwmtdwyD4UhZFXXfQZJIhwyyZZAA1cFiYX3gkNGHhZIabJ+KZg831B
	 PCPqRPVSzD7CGDakQhB7U+txoG3iokzONqPxk50BtlUzUbYouRD5/3LLzTchFD1yTj9Gd
	 KIZsQDb9fLM3UsNFbdC6mH4jN+mh7StyLTksxcHjImDY5lD3TkL6T/oHael1esgrfA+ZW
	 28QlS6IDg/vALxCR3evf+CIb1S/LOQX1QCGdt8R8UUAEuOBSOSNeipbmYAI3Ev94NmvPd
	 DN2KmtqvBcXi1rYL4tWlzptHiY8sJHeeyW6ExpJYAsO+o2KPISd1pLI8ggf71VChS3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pThi1yXk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 679B8606A335;
	Wed, 18 Nov 2026 22:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pThi1yXk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7071F000C5;
	Wed, 18 Nov 2026 22:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039376;
	bh=d4NW8H+4KROJPf5bOlljcUhhfn/9vRF+3jhlAW1z22c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pThi1yXk7IEpnwS/tTal7d5mWn1gbufxbq7QA+x/CTXvCw3AytrusS3mdKEYP8yoG
	 gavUJq2ii9lCWC/m3Svj+gwUNdg3NVFE7J36zZjosiRDjc4SVwB70MeESGRjUf43bS
	 c3gSEgFR5v2y5M5yoVnzU3plpMAxtOvUQRvbRIw0=
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
Subject: [PATCH 6.6 2078/3318] pwm: mtk-disp: Fix period readback
Date: Wed, 18 Nov 2026 15:45:00 +0100
Message-ID: <20261118150424.425282929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a83bd6e18b07f..5d7e45dd26f5c 100644
--- a/drivers/pwm/pwm-mtk-disp.c
+++ b/drivers/pwm/pwm-mtk-disp.c
@@ -211,9 +211,9 @@ static int mtk_disp_pwm_get_state(struct pwm_chip *chip,
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



