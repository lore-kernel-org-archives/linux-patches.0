Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054787;
	b=u3liLsJAqmWyyNFyYzhvp7wy3QA9rCosfHkUbeM9uSLZ4BtO/4Ay2QJkXlu2aacEjjRN
	 3myuE3HdsNlhGjxtgzfBQQnTH8NvPzTLptGB9awqtLIn358brn2GenwodE7bT8kv5ahDw
	 CmyaL+BubE3380VKaMh6KxiMBN1kOS1K+P8lMXzVUgc2tSHEeB7hp+me9Ax7Z8+V28XMh
	 XjVzxMC2gGmbQMDeNc+aMcd3hcbN0HuCtvkqq7GPdjH5WZIav3cP5S/KkKhVSpHV22o0q
	 +FNS4FnIFEmHwZB3UHkVWDj99uKK78h6ytJGrQSP4K1ghqcdzKVm0X+4d/1Szp6kfWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054787;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WP2Fprj6fSZKRogIyjykRFKYMh7OKdX4FcS9ZEqvScI=;
	b=jiqmu59HocI5mwaSKZ1P8Cn+r5bbd74+DAvdXK7RP+sWI5Za/1v2rzGu3XIFYYNNUEKL
	 XhyaP3ej4X5KTYsd+8gFhEC274dDnRhTBaEuHdhOPJPzMiai72hv/6wLSzq9jvl+w3Na5
	 VpgrQMGvh711tUarcvFpF3Lpy7mPLUY9b5h04ajup7SJXQl5WQFbxcLiZel6t5Ll2XhxG
	 RWJtXN10z2B3pmWwUoxHgrSr3OhRSMVwjpY/SzlQmCDavSPOrMLTkn5g6P1u3SCAx1OPk
	 yZET7xDe5rCTNTaYpsq2q/CAo67tv+92wKvwVzeIZPsrHX+634Y+oXHFkQGkQ0k1WYA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjfJ7+Cz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619DD606A320;
	Thu, 19 Nov 2026 02:19:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OjfJ7+Cz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF7421F000C6;
	Thu, 19 Nov 2026 02:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054787;
	bh=WP2Fprj6fSZKRogIyjykRFKYMh7OKdX4FcS9ZEqvScI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OjfJ7+CzBpMj71hDPcnyZJb8AS2ZaXzkHbsQsUEM7/7qahjKyzf/rTgN4rQPN9KOX
	 hHKGFJ/QiLVvNvGKAG92npCHlOWTr5z/s3wrDxo4FDLmLbmwQsbNss3mBzeRYjPVTn
	 ag94YbFtg1Cng1cVsv4nNDR9cNcNO4ZSyHgvdq9M=
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
Subject: [PATCH 5.15 1399/2214] pwm: mtk-disp: Fix period readback
Date: Wed, 18 Nov 2026 15:51:15 +0100
Message-ID: <20261118150107.258193796@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a581d8adab59c..771838dc84d4a 100644
--- a/drivers/pwm/pwm-mtk-disp.c
+++ b/drivers/pwm/pwm-mtk-disp.c
@@ -212,9 +212,9 @@ static void mtk_disp_pwm_get_state(struct pwm_chip *chip,
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



