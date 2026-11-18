Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029179;
	b=TfkUxtoihbwCzMzJkUsTbx9ksmDhjOEfKuQknezZBAJgvGpWFCE5UuziMy+lWT8vuWZ8
	 AFDzJANAPPuy8w8cc5l5hMzyV3DmIhpLqYc6P/4qqrpOKbd5jHcl0xm964SDjEajxbCuL
	 iffyZcdiNYpaRea1mhQqzVqbKYUZFMQoKuJPAzPfsJPHzYGucOdtxX6xr3vyyts/4Wm6i
	 id5w5OvIDnXU9duZTy0oBec47WKMXfPijNE97GCV41hGSMIhQy0VibRrZrjgIxcihpLwe
	 Jde9+bIfM18812PdwZtccTEvvbAn7DVkaYQdWr+cdnfN9g3j4IDI4rewk/ppYsVD6UQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hv3cg33ZrNkXYmIBWxSOMck0824CKO6nP1FzjqwKNd8=;
	b=pulbYRLwkYsYO4N1TdX9izRPKh7BQ0iiNPVGiMRX96Pm4j6F+mDiDZM02kYhWKr9q64D
	 rYCW8VurDbE7Z8MdF4Lmgb8/ePOO8QXyrVRO54rXCW0Lpp/PdTATjUVcMYBbcGm8nqdGK
	 lrCq1YC70BJ+0JgwIKdsBnmVwtWuVQEeP/fo1JgTTOKv5JeHbkxIxH9hXeOwJQFDX3QTR
	 D4f+YREgVMBliD88nP9JxQs9Fmixuqn3hEfSy4PgLNe3oAu3ri5GyM/75Y5/7w6Y41kdC
	 IQ9cQ6bpyNrAVq2UtATIs/fXgZ8TcxIkoaQppuv0SEp0avuu0O1/pXH5aK3363BOURQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C85TRt18;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F11C606A33B;
	Wed, 18 Nov 2026 19:12:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=C85TRt18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FEE91F000C4;
	Wed, 18 Nov 2026 19:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029179;
	bh=hv3cg33ZrNkXYmIBWxSOMck0824CKO6nP1FzjqwKNd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C85TRt18M1WMcSr4Gwg1V/EyoLMbBeXmoFbZtK87O8qyPsnRg9venL8LY60uQCAQ8
	 JXG3rocASciUvUlTYk69afE13K7e7X/FW6PY+jZuTITyCRV3FNqSaoQYczHnd/3Zpa
	 b9SrbLC47+igQmMRNIefVpEJZ3Ra3LyznSEkH/7A=
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
Subject: [PATCH 6.12 0256/1756] pwm: mtk-disp: Fix period readback
Date: Wed, 18 Nov 2026 15:39:43 +0100
Message-ID: <20261118150018.563065505@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



