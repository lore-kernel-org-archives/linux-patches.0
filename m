Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065348;
	b=EKapxTwcXmPxGwQORZSF/r1KgxDbyDgxoKrvJidive38TXCE6nEnDVVAL5ijYS/U+vX7
	 WzXQkf0fGZhVsUcuVP4pnnrXh5GHCow9rWXvW7r1R0LK5J/pCNNYYNoJiU+JYvRdDGsnx
	 7OJXnjQcEGHyIAhT8srGexRzsuhNJrAhF9yJqM5hLJac1hwZfsyVA1bfxhd7NQMIeMfwV
	 jsEHpq6PHnuDOkzZ49SNybtWK47bfzJpBpgrgvq+FTOK8jbfmYBvFsKdeaTodEJjkPYBE
	 HrREvxzL/hOHcZ2YY5B0GFRGo5+Jb1+YM/y3t3eJi85vBwCi/aNoNQne1cKi059muJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=66P8WI5AIOt7zZsK+Qz5E3B9ACY6k/BKMEOxw1uC7Fg=;
	b=SJm4I3mb7TtpdjYDA1fDHlZNCT4PPzYQIPAV3JY562WD9Pt2UR01VarGz0qupGeq5vcV
	 LjBm5Zcxab4/HsnZRsP7/NkPeZ2CNQ8FEQVV6u4Yj140E/805ALvQYjVQBdNfRuoID08s
	 pa/UjRSucAyfMohPC4/3XWRUC6QyELKge0/q520MCcANmQyWgtRucD6/qvnffpidshevW
	 vZ3iD/Tlar/ge9iGzQ5rl3BBCABHF4moZBm5aiNK3/INYEwcs2A+kUjgeYmq9YPMKhWW8
	 Inh1XXL7ayQUV7qdY6eHzawsruiVyzxa4TMBMwkNzjxan4IUVlByulz9e2lvJp1V1Sw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+Se0gq2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAF82606A326;
	Sat,  7 Nov 2026 15:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z+Se0gq2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985051F0089F;
	Sat,  7 Nov 2026 15:29:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065347;
	bh=66P8WI5AIOt7zZsK+Qz5E3B9ACY6k/BKMEOxw1uC7Fg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z+Se0gq2qomef/CHgWXCN+yM19Sr0UAaoCsBHkmw932vveeMCeJMsTGH+OGqy7zbJ
	 w/3zZR8F612x9uspS1pxuiWRaSuBUAacUHWgYksps1uP/SRyVQ6wCMs3xtZ0kYSljX
	 9cGSYgg96mwivXXPkRaTanYtUQ2oG5pf4ySUgvTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1035/1257] ASoC: tlv320aic32x4: Prevent division by zero in divider callbacks
Date: Sat,  7 Nov 2026 08:55:31 -0500
Message-ID: <20261107135007.906913177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Kazinsky <a.kazinsky@ideco.ru>

[ Upstream commit 8cf9607d2d855629260fc78e6b54ea7a98525708 ]

A zero rate requested through clk_set_rate() or clk_round_rate() reaches
clk_aic32x4_div_determine_rate() when the minimum rate is zero. Clamping
the requested rate to the allowed range leaves it unchanged, causing
division by zero when calculating the divisor.

A zero parent rate can also cause division by zero in determine_rate().
For example, if reading a parent divider's register fails,
clk_aic32x4_div_recalc_rate() returns zero, which the clock framework
caches as the parent's rate. A subsequent rate request for a child
divider receives this value in best_parent_rate. With a nonzero requested
rate, the calculated divisor is zero. It passes the existing upper-bound
check and causes division by zero in the resulting rate calculation.

The set_rate callback can receive a zero rate when an ancestor's rate
changes. clk_calc_subtree() calculates descendant rates through
recalc_rate() without calling their determine_rate callbacks. If reading
a descendant divider's register fails, clk_aic32x4_div_recalc_rate()
returns zero. This becomes the descendant's new_rate, which
clk_change_rate() passes to clk_aic32x4_div_set_rate(), causing division
by zero.

Reject zero rates in both callbacks and reject a zero divisor in
clk_aic32x4_div_determine_rate().

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: a51b50062091 ("ASoC: tlv320aic32x4: Model DAC/ADC dividers in CCF")
Cc: stable@vger.kernel.org
Signed-off-by: Alex Kazinsky <a.kazinsky@ideco.ru>
Link: https://patch.msgid.link/20261023130854.93639-1-a.kazinsky@ideco.ru
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320aic32x4-clk.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320aic32x4-clk.c b/sound/soc/codecs/tlv320aic32x4-clk.c
index deed61650e09d..8fa8e69f1f729 100644
--- a/sound/soc/codecs/tlv320aic32x4-clk.c
+++ b/sound/soc/codecs/tlv320aic32x4-clk.c
@@ -318,6 +318,9 @@ static int clk_aic32x4_div_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_aic32x4 *div = to_clk_aic32x4(hw);
 	u8 divisor;
 
+	if (!rate)
+		return -EINVAL;
+
 	divisor = DIV_ROUND_UP(parent_rate, rate);
 	if (divisor > AIC32X4_DIV_MAX)
 		return -EINVAL;
@@ -331,8 +334,11 @@ static int clk_aic32x4_div_determine_rate(struct clk_hw *hw,
 {
 	unsigned long divisor;
 
+	if (!req->rate)
+		return -EINVAL;
+
 	divisor = DIV_ROUND_UP(req->best_parent_rate, req->rate);
-	if (divisor > AIC32X4_DIV_MAX)
+	if (!divisor || divisor > AIC32X4_DIV_MAX)
 		return -EINVAL;
 
 	req->rate = DIV_ROUND_UP(req->best_parent_rate, divisor);
-- 
2.53.0



