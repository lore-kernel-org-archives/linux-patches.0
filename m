Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023179;
	b=iLCNFDyPHYKXnuwVDVl5n0VE9GX/F9nTXRZjpBvuuoRQgcr+9jkEGmtvb3mbRGeyMBfD
	 PfzLxU5MJX7E/64xfI41aTUgzGscw/ogatd6vX7M+cjCGybFiVIQRH6yqKglj8WckKYil
	 knhggWQMb/RxsdYWixQwqzChTO0jfS3BqdyliJXq7VEMea9yVQ3YKGDzIJgld/pNoNi77
	 VcypjZ90VmCUthWo6O6jXELITNI2inrvlgkb/93ul3W8qneX+A7truR52UkA99LpI8XFy
	 8Tqv6Od2HoCuvb7jdWNiJ0bhtKN4aBrf5rW9V6QoJS7qkXi/euJcHBafDoHexsfMXiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=y9UmYnHifg4EJOBiN5hlqeRG24AOwSHk/iJlLoPsz4k=;
	b=kvoocyIkCM3nMpNrQ/RyEReW1BAQ9oVgkB+BEAwazuEMlHsV4uELiPpbZ6cWj4TJBSGD
	 AdsjcBBSKGraCPtpElmkIQce4AhHbwuuIOYEkh5u6Rav+42F/RBw1/MBKAfcSMcCHBGcc
	 FJeOSjbAEf291aHAFwWBw0q8B40M3I2NqcYuu499fFER6POtfI45zCylGSMnlYGD8vzQd
	 EMjqN7pmw6D5TwW7hqXcMGL23T0fR2WXCK7TS+FCVVo9y88lUdCib/p+j1rNWu9x1vvQV
	 7CTeLOMnKcPSptwIsSRLyFRgDz3G8TmFDDn4z1DzYSvbQ0Zo+G6pQ0p9rCv9OxvcEHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObsDSwJH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 091B4606A31C;
	Wed, 18 Nov 2026 17:32:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ObsDSwJH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7251F000C4;
	Wed, 18 Nov 2026 17:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023178;
	bh=y9UmYnHifg4EJOBiN5hlqeRG24AOwSHk/iJlLoPsz4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ObsDSwJH1ISskG3VEfODHcWnsXTOjWGQdr3YPsOMgqPibKs4bryBbUXlRWzFEDAwb
	 KasO/p5nnaUFv+lqx4W1iIAoaHxpJSRjAMSBovPGQs6/F54sQZPNbyCf5jTfa7yTwn
	 tJEWamytq2AOLWpM3ywi+tc9OOhe6rwm1ORnLrIM=
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
Subject: [PATCH 6.18 0276/2151] pwm: mtk-disp: Fix period readback
Date: Wed, 18 Nov 2026 15:33:31 +0100
Message-ID: <20261118150131.913449876@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index bafd6b6195f66..3906342ff45eb 100644
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



