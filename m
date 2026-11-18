Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020567;
	b=nC0YQGH9/eQvHSWf0l+ixSM5+i7sKsWVvr05c6BW3rqA9HQUqaWBqwo3NCAWWPeKhCuR
	 lSkUuHfFSntoRT3FT7itSJp41mfMkBex2z/V/f+rDdgY5rrv+81OCWgWj7y+/6sUqoLYV
	 WWVHq/VDJcbxFxM9SgLj5P0mvlCpiM8Iybt+qCDi3rG8p5fRcaxwYsVdCLwBF53nD57RA
	 JmgZMM/VXqQfsTyo23S+2poCMs9Iq4ivrzHoBOu4sBlnilp0MLVsJETBOVafue7yCuBS3
	 MYZYh9PiTnlnrtb5kcyIyGhh7CBQ9W8A8HVjFCohoYmCFzwaTPsb9ItBMi7eLwdGWMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020567;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vhJTYbLZvaJkr+56LLpByduqZJo7hutK3osYaN3GQrM=;
	b=Vac6+eRQB31nSKoHwwANx5Ir3VxB5xYTmtTpfpDTazkw9Q4KnO7lF7ncUSdOwRIitxdw
	 n1SzctDrjuz+4VEYuqOd/enEGGjEuQPITBRLvp/5Be5H+Key9H/4Z3sgryLKwTuNTxeBf
	 2IwAwAOovOa+3mCPHp2am8ANeXp/zCsxUiSCtzE1VWwcX96Rr6DFctdGt2gtFeZT6kiRW
	 wtC/nUf77BjEx5/yU62J23kaQ9VlpAEqFGmmQrGFs4ChdIr6ZxIsLIjgvDBqy77+5sS6U
	 DMJU1r8BrZxhJtGiVLHmEmWpPZekWEwQKRhyVEovEe/o5x6RA4Mtv7U6BQaJsH8hRuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FB44z8Oi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2936A60A2600;
	Wed, 18 Nov 2026 16:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FB44z8Oi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 46C691F000C9;
	Wed, 18 Nov 2026 16:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020566;
	bh=vhJTYbLZvaJkr+56LLpByduqZJo7hutK3osYaN3GQrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FB44z8OiJob8YgYipqCiRLJMy3wPzy54wscmnBbHkZTUF0J5GHC8/Sj2w6GDfvb7U
	 wiA6HBbZ+U6N8X5LZUjqNTREoChMA1H2Gk2lu3D9KFn8ZtQJiZj1+tOiKygetIf7LE
	 FvZ9oYeAszo93yu6w67JGAUBfwC/eXc8ifmG2hK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1996/2651] ASoC: mediatek: mt8195: Fix main clock error handling
Date: Wed, 18 Nov 2026 15:53:56 +0100
Message-ID: <20261118150358.195345689@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 9f1b48c658ac38be81c04fbc29ed1522f89fb0c9 ]

Check the return values of clock enable functions and propagate
errors to the caller.

Disable previously enabled clocks on failure to match the
main clock disable sequence.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 23 +++++++++++++++++++---
 1 file changed, 20 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index dad7dddd9f521..c6990a377af48 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -719,14 +719,31 @@ static int mt8195_afe_disable_timing_sys(struct mtk_base_afe *afe)
 
 int mt8195_afe_enable_main_clock(struct mtk_base_afe *afe)
 {
-	mt8195_afe_enable_timing_sys(afe);
+	int ret;
+
+	ret = mt8195_afe_enable_timing_sys(afe);
+	if (ret)
+		return ret;
 
 	mt8195_afe_enable_afe_on(afe);
 
-	mt8195_afe_enable_apll_tuner(afe, MT8195_AUD_PLL1);
-	mt8195_afe_enable_apll_tuner(afe, MT8195_AUD_PLL2);
+	ret = mt8195_afe_enable_apll_tuner(afe, MT8195_AUD_PLL1);
+	if (ret)
+		goto err_disable_afe_on;
+
+	ret = mt8195_afe_enable_apll_tuner(afe, MT8195_AUD_PLL2);
+	if (ret)
+		goto err_disable_apll1_tuner;
 
 	return 0;
+
+err_disable_apll1_tuner:
+	mt8195_afe_disable_apll_tuner(afe, MT8195_AUD_PLL1);
+err_disable_afe_on:
+	mt8195_afe_disable_afe_on(afe);
+	mt8195_afe_disable_timing_sys(afe);
+
+	return ret;
 }
 
 int mt8195_afe_disable_main_clock(struct mtk_base_afe *afe)
-- 
2.53.0



