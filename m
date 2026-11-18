Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039798;
	b=ZdsLPhpCh7hyDDi98TNqLnPo29KtMf8O+aB1exgdrr4fnMp/gcM5L/6guvO/Rg51TW/2
	 kYG61132eZzYI+3hpxZGW1uuML14BFSBFGoeNBUDTFWQVf0/7XWQEEZfHgpM3VbamCUMY
	 8UMLECrTE/oZW7BP7TLX8FhzvMfoFYEXwmCnYXZ/LkNG/Cm/86cPMKAw94SWaO6urSYun
	 xeBKy8Cts4GMS3LiAsQZ0/qISNpeofRMOkZdDDwQ/n9ICdk3+Ulv1j8A641hGSz35Nwx2
	 94zwX7PPr69S/1ephm8av+l1oECkw7CbAWCcb+uXafpTUJmjyH8FuXxvWlJ+702KFqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039798;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=9cwUAbSKPwu7+hShO/eLdycpeo9IUf8PSQs30160EaU=;
	b=bN8xh4nHCxV5zdnQ6aomYcxsyzlPdv3QHCPsgrHjOUDd4FqNO8uzkybWkqVon6V0MaKe
	 ewQcptOQBh5yz+LGJuVlbQp6jYp+seg57lJM5LTR2gZtrYB3sREsQl0BzeAaS2D/eTxRe
	 6UsJR+aLg7V1BJUyT0vFdA7A630UF7J1Uk09DKhN7OlVAsmXSerJm2b4/Vfs2cKeAx/RO
	 GXZ/Rmg1YNpx4Dn5fJFiLoIW8sQcpjTW+eWBGVf4hXPEzuy0T/txkZFQtSoowk+iB08L0
	 MbQCipyyK9bQOWK/0czCpV/tQkcwN9khBK7u9w7t48a2DavKr73M15vJoyOW7ZGhXiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mOHnobl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85FAB606A31C;
	Wed, 18 Nov 2026 22:09:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2mOHnobl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D636A1F000C4;
	Wed, 18 Nov 2026 22:09:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039798;
	bh=9cwUAbSKPwu7+hShO/eLdycpeo9IUf8PSQs30160EaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2mOHnoblIKqHNrvpbBfnuJruG67b3uSgJHvAgXA7z5wbiVqtjoVyei0gKX4DN2WE7
	 S+vJFF1fDRgHe6mAkPu9IeGbs79BQspTovFAMGOmAOHZXicpHjPI/rACSlCIIENkgy
	 ccG5rzKwA/CX1nwD06/zR5vr/kaSwDW75Jr0+Cjw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2188/3318] clk: mediatek: reset: Remove unused mtk_register_reset_controller()
Date: Wed, 18 Nov 2026 15:46:50 +0100
Message-ID: <20261118150427.597018201@linuxfoundation.org>
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

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit 4a9e56f25633989238fc7b233e100e295ee33739 ]

Now that all clock controllers have been migrated to the new
mtk_register_reset_controller_with_dev() function, the one taking
struct device node is now unused: remove it.

Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20240718082528.220750-1-angelogioacchino.delregno@collabora.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 8d5fa37307ac ("clk: mediatek: reset: Fix device registration kernel-doc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/reset.c | 59 ------------------------------------
 drivers/clk/mediatek/reset.h | 10 ------
 2 files changed, 69 deletions(-)

diff --git a/drivers/clk/mediatek/reset.c b/drivers/clk/mediatek/reset.c
index f8c0fd0315129..2e3303975096a 100644
--- a/drivers/clk/mediatek/reset.c
+++ b/drivers/clk/mediatek/reset.c
@@ -110,65 +110,6 @@ static int reset_xlate(struct reset_controller_dev *rcdev,
 	return data->desc->rst_idx_map[reset_spec->args[0]];
 }
 
-int mtk_register_reset_controller(struct device_node *np,
-				  const struct mtk_clk_rst_desc *desc)
-{
-	struct regmap *regmap;
-	const struct reset_control_ops *rcops = NULL;
-	struct mtk_clk_rst_data *data;
-	int ret;
-
-	if (!desc) {
-		pr_err("mtk clock reset desc is NULL\n");
-		return -EINVAL;
-	}
-
-	switch (desc->version) {
-	case MTK_RST_SIMPLE:
-		rcops = &mtk_reset_ops;
-		break;
-	case MTK_RST_SET_CLR:
-		rcops = &mtk_reset_ops_set_clr;
-		break;
-	default:
-		pr_err("Unknown reset version %d\n", desc->version);
-		return -EINVAL;
-	}
-
-	regmap = device_node_to_regmap(np);
-	if (IS_ERR(regmap)) {
-		pr_err("Cannot find regmap for %pOF: %pe\n", np, regmap);
-		return PTR_ERR(regmap);
-	}
-
-	data = kzalloc(sizeof(*data), GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	data->desc = desc;
-	data->regmap = regmap;
-	data->rcdev.owner = THIS_MODULE;
-	data->rcdev.ops = rcops;
-	data->rcdev.of_node = np;
-
-	if (data->desc->rst_idx_map_nr > 0) {
-		data->rcdev.of_reset_n_cells = 1;
-		data->rcdev.nr_resets = desc->rst_idx_map_nr;
-		data->rcdev.of_xlate = reset_xlate;
-	} else {
-		data->rcdev.nr_resets = desc->rst_bank_nr * RST_NR_PER_BANK;
-	}
-
-	ret = reset_controller_register(&data->rcdev);
-	if (ret) {
-		pr_err("could not register reset controller: %d\n", ret);
-		kfree(data);
-		return ret;
-	}
-
-	return 0;
-}
-
 int mtk_register_reset_controller_with_dev(struct device *dev,
 					   const struct mtk_clk_rst_desc *desc)
 {
diff --git a/drivers/clk/mediatek/reset.h b/drivers/clk/mediatek/reset.h
index 6a58a3d591654..562ffd290a224 100644
--- a/drivers/clk/mediatek/reset.h
+++ b/drivers/clk/mediatek/reset.h
@@ -59,16 +59,6 @@ struct mtk_clk_rst_data {
 	const struct mtk_clk_rst_desc *desc;
 };
 
-/**
- * mtk_register_reset_controller - Register MediaTek clock reset controller
- * @np: Pointer to device node.
- * @desc: Constant pointer to description of clock reset.
- *
- * Return: 0 on success and errorno otherwise.
- */
-int mtk_register_reset_controller(struct device_node *np,
-				  const struct mtk_clk_rst_desc *desc);
-
 /**
  * mtk_register_reset_controller - Register mediatek clock reset controller with device
  * @np: Pointer to device.
-- 
2.53.0



