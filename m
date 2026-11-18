Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024761;
	b=tIkyjIKHSqUo+b/Z1hQpia5093HR6yDvce0wFZM7dOvP2KKAY3Dc49ipbA2GtafMBu9c
	 WaBXptyDXNtat0fzkF1qE4wPFWBMnNSVK7qOWMp3nC5dyhbQgUz5wC7PSzz16kDCWx5+n
	 TBICBx+7IvxQl1+hhBwHATgsaNyAf/6vFhY/TSzdZHsU2m+sSf5eVnoQ2reEfA9sXLkKA
	 3VkKmo3K7+jAcT/SBW7tWRIUAc+8xqZOSYgRyuOPdnVijbjofLbCjzu+ZtjY1Ifet7F7P
	 mBI/jcjSc9OgQJFaqbHcdvEDCFuelaTNYGnRbwm6HR4Iiumdd/qHmoXPGo0EPPMRuHA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024761;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZIPsHAcVwGZvAxVb7R/yVQbrvqGWwTg3fxStRWpay48=;
	b=EPgLy1hQY5zNHx1bX0Tw24U2m3lO9uNos2Z51F6dJcMya2nTQOQBZVPRDRWhtqlXl5K3
	 OiAbMYYq4XvEU/VDKN64vnjYpHQDHa66yu9s6fiQBbDGYFP+yvNcmsiP7ynnTcMNBKPBm
	 ulTxQiIwPwykS29S+ylmBesxHOk21fNYFlp2a3cq+xJrrIn180BrVy3ohADPxShpAYt7U
	 KIG35DVaur4PIc0qHMw10dmN9LSXYW+82Wsq/KSwGe29wABesLiF9+7Q8UVkSLw2AD1cu
	 AwA7uNgsf9SKe3USRHTg9NbBSYzXo0Y+cuDQ0CfM2f7gwBXSOGAwwbJpsY/ncLF3gKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1bTVPEXu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41A6F60A2604;
	Wed, 18 Nov 2026 17:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1bTVPEXu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987C91F000C4;
	Wed, 18 Nov 2026 17:59:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024761;
	bh=ZIPsHAcVwGZvAxVb7R/yVQbrvqGWwTg3fxStRWpay48=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1bTVPEXu5pcQDbnSsJR/PrbMbrL8mPdvRJG6DKGgC46z3FIDGH+j+HT3VFkPuuToc
	 PbYdbuHfrfJcMd8rt0hVwXHIscrhrf+lDr8v/8OzkN+TfoVt/jQwfGEnAP1aDoG3uq
	 Hi9luY6JEzuKaBGKW5BY5d7BYif6rHhWQxCV9J78=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0823/2151] ASoC: mediatek: mt8192: switch to devm_clk_get_optional()
Date: Wed, 18 Nov 2026 15:42:38 +0100
Message-ID: <20261118150152.113384479@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



