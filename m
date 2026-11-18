Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040346;
	b=Ra7EUbVQCf0EmyR1eqHGyqngKjYF7J0KrK2ykP7i4QrIH/1jY4r1la/eGaUSZcJAYyEo
	 xGTLDU/JSHMjRhxM9H1q5Mz/Q5dIHnQpgNjthf8tqSfrzMs4w83r+mvUaYqtD/4U5jK+l
	 wppM2v3muz4VaO8lKAo7hqr1dNP3vfUfePY/fRfQMXGdToWYDHFBc1Y7Gkr1ViWaPNY4L
	 +Hu4U65rwJNRAt+t8lHezm48S7R+MEygQLcYedvovx5vgV2590QRPmn6VGihZnf7gWiuI
	 5hdyXTRHTtO+nDN9Ck7bckDpBfk5lYHo427ij6rNh1FJvuxgeMvNVLcIIDp5HUP6Qhg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040346;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aUZY0VfsMMQKME1YQ4ZcgK4+8KrdLtSwMlEghBlESUA=;
	b=OTgIsKPnoEjMKGDr1ICIO3+mbOmUnquSswmWy5Pev76IOxSPZhtbpnE9+MjdHKLivb/D
	 sgHWnJcZogUIa9qObEUw1qHSiiylIlmooukSUzJlb2eOm2V9Gmg0qhfHrk69we0IFyoYi
	 IPcHSEA1YfT8xcIPTN/NE3PRPyJpDNluUY7FSobMmU4+JuljfOTd3nP1/fKNe7prh9CmO
	 q/IcDiIta9EWju1MQFMoleWdOk7mU8Nql7GqbG4Cbliq1nwOljxd49ZS+Quun6IBk2ORh
	 RcfY56y3iSmF6J5JRCyac9+RwYh29QIjQuAqmiRDd6GZQkq4bM30deKirgeORzOJUfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="SKV6/N/d";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DAE7606A31C;
	Wed, 18 Nov 2026 22:19:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SKV6/N/d
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953A61F000C6;
	Wed, 18 Nov 2026 22:19:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040346;
	bh=aUZY0VfsMMQKME1YQ4ZcgK4+8KrdLtSwMlEghBlESUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKV6/N/dOgJa5uFtYe3j0d2xu9W0KD5cstf3q3hE6j5OMSbTyy/nvI0fFq9WTq1oW
	 lOB10sJUkjCDoxSUgRGsgIX1SZpuB9/rGa9IT4ZkQlb1I3pZL+xiSOg4Uq5dyRm2lJ
	 30XS6fRcEFhfQwSMwysZxj+tPzJrQ8ae85Ww39+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2424/3318] ASoC: mediatek: mt8192: switch to devm_clk_get_optional()
Date: Wed, 18 Nov 2026 15:50:46 +0100
Message-ID: <20261118150434.187798655@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 77f596cab92da..9b9a3465ddb52 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-clk.c
@@ -672,13 +672,10 @@ int mt8192_init_clock(struct mtk_base_afe *afe)
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



