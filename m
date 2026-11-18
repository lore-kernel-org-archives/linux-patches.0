Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029696;
	b=Mq3YT7O5PHot3TB5PD4vKq/9+Y9P+/fHK5L+wqSXa7OQ8SEVyuVLxyDgK8RL2BT1YgIl
	 oRth3k6D9jzvMqxx2k4FvaNRF77mq39BB4hpQqlqQDDX2qFs88JBysFSgTTz8Wygmjrfd
	 X5VTueweiJGAfJcbdsHLCn1aUxvOqfwPAdM+/MID39Jkd8lDVawr3Vb+Qbmdmk0StFqzT
	 KfLmvhxm1bMZ0rJHrwFlMb2X0FxSZeM2RBQrep0b3TLL5l1pja2lMuBTQ+Zki3Ibzp7/R
	 qSRAiO6uIijw0R34unZkDHgDsas2L05cA5ZBdmknK+v2S8OfGhko+UJ31OMfWcb9WlA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029696;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xTZ1zYpD4WJ0qQ9stTJJACmKLzpx4E0GSDSXkKi/AGc=;
	b=OJlW6gtIOeTwzanJV2f3se5c6lkCjn52Y3exBmZKDmdVdVM14WR8SW/+QX6UZ0J96zEY
	 Zpe4c0fjzJrcrepnzbMogwmOTL+c1BaFh9qI4vwBDVpElVcm1H2lFa/FBALqr65bwyPXE
	 vtoJn+vwwE+wB8tvSAAar2c3Z37850XLezDy3QCooBVZo55lScKg/eTzabup398CyluGq
	 MICAmTDTLeNj9elXtlUtS58N1JnH/agURP4D8OM5leFiLrO1ZiYAnD25mU60VsERpoE2/
	 jKzABCot8ns+KHCgJ9l447NYVTBOCL7IUdXUjMc1Zm76sparvNa8gsn4WXEcQRBcbkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJQ1vj19;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC13606A31C;
	Wed, 18 Nov 2026 19:21:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hJQ1vj19
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 511581F000C4;
	Wed, 18 Nov 2026 19:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029695;
	bh=xTZ1zYpD4WJ0qQ9stTJJACmKLzpx4E0GSDSXkKi/AGc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hJQ1vj194AkqKzpgUjJT0Zb4LlChXOOJXp+rWkhDAiZvR5ljAYyYUUWNSVoQzbVxe
	 Geiiz9UOjBhTokhWvlE0W8g3Ds39wxyHhaliBt/HDeyq+kEj4+EkI5inD/aLZc4heT
	 sxWU6yzfEFvvDcsCGY3xTifOVmBQmlJyX1/hrmPo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <hppiscas@163.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0441/1756] clk: milbeaut: Return divider update timeouts
Date: Wed, 18 Nov 2026 15:42:48 +0100
Message-ID: <20261118150026.294981513@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <hppiscas@163.com>

[ Upstream commit 92d0998090d1716ee6b47174c10eb9415a12fca8 ]

m10v_clk_divider_set_rate() logs when the hardware does not clear its
write-valid request, but still returns success to the clock framework. It
also uses the sleeping poll helper while holding the divider spinlock.

Use the atomic poll helper under the lock and return its timeout so the
rate change is not reported as successful before the hardware accepts it.

The issue was found by our static-analysis tool and manually reviewed.

Fixes: 6a6ba5b55a72 ("clock: milbeaut: Add Milbeaut M10V clock controller")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <hppiscas@163.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-milbeaut.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/clk-milbeaut.c b/drivers/clk/clk-milbeaut.c
index 18c20aff45f76..ef4d8f862f5cb 100644
--- a/drivers/clk/clk-milbeaut.c
+++ b/drivers/clk/clk-milbeaut.c
@@ -411,8 +411,8 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 				unsigned long parent_rate)
 {
 	struct m10v_clk_divider *divider = to_m10v_div(hw);
-	int value;
 	unsigned long flags = 0;
+	int value, ret = 0;
 	u32 val;
 	u32 write_en = BIT(divider->width - 1);
 
@@ -434,8 +434,10 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (divider->write_valid_reg) {
 		writel(M10V_DCHREQ, divider->write_valid_reg);
-		if (readl_poll_timeout(divider->write_valid_reg, val,
-			!val, M10V_UPOLL_RATE, M10V_UTIMEOUT))
+		ret = readl_poll_timeout_atomic(divider->write_valid_reg, val,
+						!val, M10V_UPOLL_RATE,
+						M10V_UTIMEOUT);
+		if (ret)
 			pr_err("%s:%s couldn't stabilize\n",
 				__func__, clk_hw_get_name(hw));
 	}
@@ -445,7 +447,7 @@ static int m10v_clk_divider_set_rate(struct clk_hw *hw, unsigned long rate,
 	else
 		__release(divider->lock);
 
-	return 0;
+	return ret;
 }
 
 static const struct clk_ops m10v_clk_divider_ops = {
-- 
2.53.0



