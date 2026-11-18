Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055388;
	b=0EiCrdLHIAuJKAQV7sJtVpXynSZFE/NDQxWd9Whkdrogf9VzIRMAAq2nyFDcQpk9/2Tv
	 4/rQMc5964DtanFGgJ0rp50eljL517fv8ejWqmOuzTlNt6hoDQqJy62n7C3+T9AYFVOoe
	 nhz40t2rTTnJwTogz/AbwHS1Z0Z3GITQ9p95asQhHeFJeicOO3Knp/wpmnirPRTN04aak
	 lAVi3KSj8cGEZOzUH1rn9otRuHUnL4ss2/gZvercObytyfOCTkYFzGsVt+Rcsq8MObTlB
	 yE0inPmILxExKAU9lADGtOLEtaRnqfWD+RrF/Nrza+fi8dvGW8DGfl0zwL4o3Lxr5dg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055388;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Hjh5nEqxjlimGHs2eH4u/7ctXKyoVUhEU4XAm5LNiV8=;
	b=Plq9JYsV1OIL1hR7upHiJD1MVDPXvw2v+zLnqLJ3Ai+2q8VpkdJu0HbuG+wX4XTYr4yc
	 6iN1/9Tu9SeRAuxhQ0RD70klAiT+vjicWBeD5Y1SxKVrceo9ZloYyVf8cdDZf2ZJyWS/L
	 7vLKDnna8+A5vcg06NOGMQaPS0MW6Kz2TfF33Zx6xhqxY2g0a77snnqYub9L6VxF6gulU
	 aB+zD8LK/yIhFKAj64IE6rCgckib3YcM9uYtjq2oOdH9BOb4Uz0criWGKnepnjBCSDmig
	 QGOgWADxmTqXQQKcYjf5Rnw62dFmAnRofHqVi9LCwDJWyU8K0V7S1twJd7mftcCp1FA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ay2VCgAm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F15606A32C;
	Thu, 19 Nov 2026 02:29:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ay2VCgAm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43A7B1F000C5;
	Thu, 19 Nov 2026 02:29:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055387;
	bh=Hjh5nEqxjlimGHs2eH4u/7ctXKyoVUhEU4XAm5LNiV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ay2VCgAmKjtwiPdpYahhEFQb3DF/S8Q6CnBrD12uhETb/aQFGIACdSfhhGS8coh6i
	 US/h1cyP73kAXl7qhYUZqlrY71eR1SZ96xJYDw0lUU3r6n8JheOjsw91UHuFjE32Wp
	 RJRj277RMwC/bfI1EOUwxzErr8WfaiDdjYSWyxdw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1613/2214] ASoC: mediatek: mt8183: Fix wrong clock cleanup on clk_set_parent() failure
Date: Wed, 18 Nov 2026 15:54:49 +0100
Message-ID: <20261118150116.521559351@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit 7f05596bd4047e4623eeb1f3c6921d6f71481c3b ]

In mt8183_afe_enable_clock(), when clk_set_parent() fails, the current
error path incorrectly cleans up the previously enabled clock instead of
the clock used by clk_set_parent().

Fix the error path to clean up the correct clock when clk_set_parent()
fails.

Fixes: a94aec035a12 ("ASoC: mediatek: mt8183: add platform driver")
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260903045203.175337-2-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8183/mt8183-afe-clk.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/soc/mediatek/mt8183/mt8183-afe-clk.c b/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
index cc4f8f4d3dab9..6ab0734ad1365 100644
--- a/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
+++ b/sound/soc/mediatek/mt8183/mt8183-afe-clk.c
@@ -137,7 +137,7 @@ int mt8183_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIO],
 			aud_clks[CLK_CLK26M], ret);
-		goto CLK_MUX_AUDIO_ERR;
+		goto CLK_MUX_AUDIO_INTBUS_ERR;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_MUX_AUDIOINTBUS]);
@@ -153,7 +153,7 @@ int mt8183_afe_enable_clock(struct mtk_base_afe *afe)
 		dev_err(afe->dev, "%s(), clk_set_parent %s-%s fail %d\n",
 			__func__, aud_clks[CLK_MUX_AUDIOINTBUS],
 			aud_clks[CLK_TOP_SYSPLL_D2_D4], ret);
-		goto CLK_MUX_AUDIO_INTBUS_ERR;
+		goto CLK_AFE_ERR;
 	}
 
 	ret = clk_prepare_enable(afe_priv->clk[CLK_AFE]);
-- 
2.53.0



