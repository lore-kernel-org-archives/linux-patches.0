Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055482;
	b=NBY8aU87gi6s8gRHuP5moPpkRLWe3zt38mC5538B7sJRI3pXxODGvM7ksI7SODJmy1ay
	 rpN+/W1GXPYc7W6A2N1PCEprKnNoh/sDAAGLDj6FT0PB6EeidNeT/kU0rvxgDKuYZy5Xn
	 +vhfPAxwsmmPgJOmt76cm8/oBL3coB9HEwvOK0/4xT1NXmEiwDnll6VAShHJehx8l34MP
	 3uou6qucNLnFrWlk3DX+nztyz3qE6tVKeokdodz6lcwYVF/FYM/LO70Kx92dqgoY4ar0C
	 bXs7GCDQSdxZMyE6oXW6Rh6m7gT6tH+jcLaM6zPGRQhEFQikVoeCFdR9QUea2EfMsrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055482;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tJQNgRLn9nG49uRo3NuCWjKSUyr+7zVyg7aC3W2E4Gs=;
	b=m0sqrtu094HAvuKV9bl+rGFPI6ThVSxH4bms8cS6TqCfxKRfCVXQZ4U718K1+moVGVuI
	 qYJLsVuQprrwUjXgxlFXCa5nKB9JxzOtmPxsERBC0tnYMfpwa5EDscXhS4boMVbSc+5ya
	 fiC7hF5eplx5+hIsuuspDDbrzl0XDoOVjmmg8ILX1GsP3tclgS8jNMMOyoq/Yv63jBtUc
	 yuLmQkrFjpzVR5lU/CGcRrRBAiOkBvy4pQpq3RK0Z404+0scf9URkulGTYM3QzjSpgdK4
	 mFUk23FKcuLtU4RR9NRlwY/sYs9tsZZyITUPBqrp7n/daZp3XejSLdJp2xritu/4xRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9uHWBCh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8C3606A320;
	Thu, 19 Nov 2026 02:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=I9uHWBCh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECAA1F000C4;
	Thu, 19 Nov 2026 02:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055482;
	bh=tJQNgRLn9nG49uRo3NuCWjKSUyr+7zVyg7aC3W2E4Gs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9uHWBChnIjTRwIuwg8GcVq6AFVhFIeJF8t/DIAxSrcypNhZA1O537CeveH0bkYRz
	 lOUENLdKIVj4DcpxWdeVlpXkNvWSOYbC8wGWkW2PRaa9MXGUGXGgyGl/iDItnkGziP
	 1lVWmR6tAzjGewNQYw7gYqwwkqDsGmbvxzvVFmbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1648/2214] ASoC: mediatek: mt8192: switch to devm_clk_get_optional()
Date: Wed, 18 Nov 2026 15:55:24 +0100
Message-ID: <20261118150117.833108231@linuxfoundation.org>
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

[ Upstream commit 6f4edfdce0099dc0c346c78c85f58a23d4ee646e ]

Switch from devm_clk_get() to devm_clk_get_optional() when requesting
clocks, as optional clocks automatically return NULL when not present
instead of requiring manual check and NULL assignment.

Additionally, handle clock errors properly using dev_err_probe() to
propagate error codes (such as -EPROBE_DEFER) on failure instead of
just printing a warning and continuing with NULL pointers.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-6-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-clk.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
index 6983c63a678f0..c26f68ec6040f 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -676,13 +676,10 @@ int mt8192_init_clock(struct mtk_base_afe *afe)
 		return -ENOMEM;
 
 	for (i = 0; i < CLK_NUM; i++) {
-		afe_priv->clk[i] = devm_clk_get(afe->dev, aud_clks[i]);
-		if (IS_ERR(afe_priv->clk[i])) {
-			dev_warn(afe->dev, "%s devm_clk_get %s fail, ret %ld\n",
-				 __func__,
-				 aud_clks[i], PTR_ERR(afe_priv->clk[i]));
-			afe_priv->clk[i] = NULL;
-		}
+		afe_priv->clk[i] = devm_clk_get_optional(afe->dev, aud_clks[i]);
+		if (IS_ERR(afe_priv->clk[i]))
+			return dev_err_probe(afe->dev, PTR_ERR(afe_priv->clk[i]),
+					     "failed to get clock %s\n", aud_clks[i]);
 	}
 
 	afe_priv->apmixedsys = syscon_regmap_lookup_by_phandle(of_node,
-- 
2.53.0



