Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032133;
	b=XHYcLKbk0tj7ctETLaVB/l7CScu2YqUrIq5+csanQs56UxhYkDAjFKhDRVuCeFiHTkQD
	 YMPTewThL8FX2LBu/98CR4Ewni10t9AcEg+de457VkUaZ21iWwFgnRNwruTOkXUoc72PB
	 CIPrvADxkzL80h1kzSfNQ92NfdtyIUoUoV/JSd6jzIf+Glf0d5fA40DBMwMa1u1D3Pc8M
	 7gnaHtNjEc8DZM5/b9TGI6zIpZwby421gzTiY/F8Vw1Or57Kb0RdtoYQs15WDS+0ZqQTN
	 HUJG6hEXoqJb8fCjyplAoPYW0Wrt81AYq/FfEsUuWLcpYVeIej8vm6UuZWf2bVjmFHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032133;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xa3ptN7tf8ZTAoDSQ7xJCKSakncWiXxXqF9ntPtaPkk=;
	b=s+AWdYSL3SF0dU49MUTzXOTJrqqch1z6CAJnqpX3b47VSkeAt4OPyRqeLxEGJaV+GaTO
	 anSB79CXD0aWTMC5Hd24wOS6X/GYexFSa5+V28jzubv6cRi3hcehOl1kUsuDGXbEE2IAn
	 dTBbR4czTrWXSnl2lRMfxEu1GSkbPS1kb9h8Hp3yoCFoN+q5qcYaq42iIvpdfu7QTm9Yk
	 g7EqFWDYmdWx0B1KLQ22E20kFZJjWRQET7rVwdsI3cOTFwj+rxhGTPXWTTIdm2m/8l6QT
	 dnpWoGUqQeDWYoWN9oHdh0PwDyWCNzgTLtYHRShWUUdD3aX9AKo/KbWw3U9ujrO6maA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u59lWQfw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0F0606A320;
	Wed, 18 Nov 2026 20:02:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=u59lWQfw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 603D51F000C4;
	Wed, 18 Nov 2026 20:02:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032132;
	bh=xa3ptN7tf8ZTAoDSQ7xJCKSakncWiXxXqF9ntPtaPkk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=u59lWQfwWhfBnmE7tFKGmhBZO3oaQ7r8LNVEBjYIecDaGex5lcFJE4Keh+6j6RKIv
	 URU5M0UoV0PY6x99u8PQCfa2iZG12OVL7ibLz9puxZesgrx5Ilxtmy3vYpNhyZ9dKn
	 NyzmwA+JJUFfcTmto5wg8peWABnczvGLSKrLlGNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1304/1756] ASoC: mediatek: mt8195: Fix timing system clock error handling
Date: Wed, 18 Nov 2026 15:57:11 +0100
Message-ID: <20261118150101.412239456@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit f18c0a8e528eb8844ee362324220ab8df3664afe ]

Check the return value of mt8195_afe_enable_clk() when enabling the
timing system clocks.

If enabling a clock fails, disable the clocks that were already
enabled and propagate the error to the caller. In
mt8195_afe_enable_main_clock(), return the error instead of continuing
with AFE clock enable.

Fixes: 6746cc858259 ("ASoC: mediatek: mt8195: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20261014112752.683032-5-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8195/mt8195-afe-clk.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
index 9940e95b1dcd3..57c72f8407720 100644
--- a/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
+++ b/sound/soc/mediatek/mt8195/mt8195-afe-clk.c
@@ -671,7 +671,7 @@ static int mt8195_afe_disable_afe_on(struct mtk_base_afe *afe)
 static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 {
 	struct mt8195_afe_private *afe_priv = afe->platform_priv;
-	int i;
+	int i, ret;
 	static const unsigned int clk_array[] = {
 		MT8195_CLK_AUD_A1SYS,
 		MT8195_CLK_AUD_A2SYS,
@@ -682,13 +682,22 @@ static int mt8195_afe_enable_timing_sys(struct mtk_base_afe *afe)
 		MT8195_TOP_CG_26M_TIMING,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(clk_array); i++)
-		mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+	for (i = 0; i < ARRAY_SIZE(clk_array); i++) {
+		ret = mt8195_afe_enable_clk(afe, afe_priv->clk[clk_array[i]]);
+		if (ret)
+			goto err_disable_clk;
+	}
 
 	for (i = 0; i < ARRAY_SIZE(cg_array); i++)
 		mt8195_afe_enable_top_cg(afe, cg_array[i]);
 
 	return 0;
+
+err_disable_clk:
+	while (--i >= 0)
+		mt8195_afe_disable_clk(afe, afe_priv->clk[clk_array[i]]);
+
+	return ret;
 }
 
 static int mt8195_afe_disable_timing_sys(struct mtk_base_afe *afe)
-- 
2.53.0



