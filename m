Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062532;
	b=fFi4cDM+MqXPdhommAS7C+i0TnFMQbu2Y9227ODViETxpMi8wMbFwUYeLOY1QuGzU4bF
	 Me7MS1r97RjzK85evzCDg7uoXagJ6Mt9043jLdp6WaBiAl/bVpufwix1OHtx51K9j4uJN
	 c18YOVvYZWru7wzhpaMc6VJbDHc7GGmNOAeQ0jMg4G/W3z63jriCSQPgdsrOc1fDnp4Qo
	 duKb6A9M9LqvHcQCuWJWdsANxu/dQ20hQzu6Jlwfg/A6bBEv/BnZ62sz1qlsGnfGLF+Ik
	 JsbzPc6smSJfclw5zddy7F3UJIyw9wLtbke+kGo8d+hrqoF9Y7psCMQSaGP2ekqGncg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062532;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QJDq+MRm+7cJiLQL3faA0fDo9GSKb4ee1DPsxFKR+ns=;
	b=HQ3oT7ib8a+BkBGePKAKThq/NSa81gIBbTBqZAocHE+NVE/8uSozTW6IVpurvxqLpL3T
	 wvxk3e/7co2SrR95FHnUWjYE8xMnJrPlXdH/eV40HRtXlf8BcB3qUC5lYFMpKSkiomPKJ
	 pAHrS9ES12uas08Mfl9Jo5G2RUNxOFiemyCFmmq/mXawcF3wEioFUPKq0SKHL+wX0LcB6
	 84jx/EAhnQyZyEtbNpX9Z/u9q3eQOpajXn1pu1R3U3lu6zlDVTirI5cbiKfMka6mFAqPs
	 381k+cm8ru+wdpbYNvT7oCU2f0CTrU0sHaTYXOcYJGLH9/aMqbpfl7jCb2NbXMjhd+g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKYtEZJm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD7AB606D80A;
	Sat,  7 Nov 2026 14:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hKYtEZJm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F7F1F008A1;
	Sat,  7 Nov 2026 14:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062531;
	bh=QJDq+MRm+7cJiLQL3faA0fDo9GSKb4ee1DPsxFKR+ns=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKYtEZJmXYpU8Ql2y2x0hSxJuHSTS9JSKGc9QnW45bDURk8F2HGOPPa7y6pyAyo24
	 28YYpg+FdDpo2Z1f6jnra7AL9BswLCo++2ezv4Tz94hxcmqfIbldClBbgMjqSj8mUp
	 XSrSTJf2ZOj3+pEJ+6J2RbBFr70+W0j9CC2/IpaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alex Kazinsky <a.kazinsky@ideco.ru>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1423/1536] ASoC: tlv320aic32x4: Prevent division by zero in divider callbacks
Date: Sat,  7 Nov 2026 08:57:19 -0500
Message-ID: <20261107135037.796345110@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 5c0a76a4a106b..1a815de909097 100644
--- a/sound/soc/codecs/tlv320aic32x4-clk.c
+++ b/sound/soc/codecs/tlv320aic32x4-clk.c
@@ -320,6 +320,9 @@ static int clk_aic32x4_div_set_rate(struct clk_hw *hw, unsigned long rate,
 	struct clk_aic32x4 *div = to_clk_aic32x4(hw);
 	u8 divisor;
 
+	if (!rate)
+		return -EINVAL;
+
 	divisor = DIV_ROUND_UP(parent_rate, rate);
 	if (divisor > AIC32X4_DIV_MAX)
 		return -EINVAL;
@@ -333,8 +336,11 @@ static int clk_aic32x4_div_determine_rate(struct clk_hw *hw,
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



