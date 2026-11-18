Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054046;
	b=3gkJV8jqEzDRdF7qc0FGXGXOfQE7QM3vNrKu4bqFH7uneDLFBgcWLJDN85RsV3g/udT+
	 Lpni4e8CzEXGJOoFLBDIWCfDzmFLOw6Zo8zHUmdNlalO21EdKu5B2M733kiRYHxnzv5Jh
	 Gmlqo1i8nRaW7GGVcEqRKOIHijO/WkbWWotOT6h1IXzUJOH6ju3ffl2dA/MoVWHjIW1q4
	 sW+g/BI4l4aXkOzmhaZ/6fCHxLr69ZJzcCy4NcIIqiCp5a6XUIxFvnVUNyTEaR5/UdUsY
	 xpFTUvc6T3sODULdqy7AgYLzKQGP8i8c/z+FTbkjfs+TOmBEqkRF6wijQiEuUqtFUfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054046;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aFlLlQRHMjJnVzsmQj6/TpXSU480Bd50XbwByAuoUKM=;
	b=gSTB5pc6st/D1SfEP8Xjhts3S/W2d0Ie0/DIbfMghHPTlCgHNqme1MXGWyhEj3L3eW4V
	 ut7PSrzabtzmp8ocegJs3vCQDRWk9WBNkhM7eMLYdoa80bCQ9SOX5ibg2IBzf4uCvCKUr
	 pjZCdgLsTeI5e/I4nxOK/tsyH/c27BwSxG1svQUSoHqwn+l9SoO9x8I8FdL7Dqp5JX3Ya
	 wxRZ6zKMOrWl7ggrImUhY484UzTpMDOJJi2dDVvNkESPsvIiFgOfzpXzXiq8hbeWVw6mK
	 e2OVR7mVs9aAUIv/ohuF2qCRceq1yH2oJYdtHfWPWGdLdy9K255+xAguckW4nFbARdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XYvR5cJz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8AD606A320;
	Thu, 19 Nov 2026 02:07:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XYvR5cJz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3936E1F000C4;
	Thu, 19 Nov 2026 02:07:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054046;
	bh=aFlLlQRHMjJnVzsmQj6/TpXSU480Bd50XbwByAuoUKM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XYvR5cJzQiPoeZHh+BEzW4twKBCYJe2T+eVPnhMkPdWGJaWYKCBTfeqt8YzOztkPw
	 qZVqT1RAIKxTwJcZgdccoMRnZPfSuq6ArB7Ab8uLQCy6mSapIxEr05mvLl1vWxmsLp
	 m1gr6MJjKpUZcxLDeNTbUEwZbKRCAJkxnTdJySr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1136/2214] ASoC: tlv320aic32x4: Prevent division by zero in divider callbacks
Date: Wed, 18 Nov 2026 15:46:52 +0100
Message-ID: <20261118150057.487030201@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 4ade06e5f5cd3..c8ba32b810af9 100644
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



