Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA962E2663;
	Sat, 12 Sep 2026 14:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222402; cv=none; b=kygRdoLzQCyVibm2O3FBOoIF4QRF6PEig0irn0JY8KrAJ/jli8cqqcSWiCpTK6MQVxfb58/d/a9ajbfoAO5BXdHm76TPjeNgu0yy67bHCG6zouofUqysYa6aezsg4cf36/Gz+mAX5QI9FHrxFfYB7ejXocJNwSjV26BflR7g2nE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222402; c=relaxed/simple;
	bh=ruTn0J1Zg1Cy2zHNe33dFjQJsjTyPLY0tFb/Bd/f/a0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TxnO6I2a6UV7WiyB8ikI5D04zqqNfcSsB78oWWof3012v0CAaxzcvztPTeeGRKUvAlaA+FwkfJ6gNVr1hcZww049O26hbHOVf3U2aqBtwBS/NiOTg/zy5aSDWYqxzli6YZcbfUE93urWz6+35lzrM8JsKrIl/mhYkU04LDdkGGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bXZiv30m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bXZiv30m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66AB91F000FF;
	Sat, 12 Sep 2026 14:13:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222401;
	bh=zu6Z4nar4dXXgSojiQ9B3LOPMBYq/+SQfVxpFec3Lek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bXZiv30murf0TWtlf2A0dl8fXhBo2xjwgBmnrzaXhNLrBuUesnnPHgbYkEqngkgxb
	 dFYgqFX1FPqmabYxXw0CdevE1Oq0qY2dtz8uZBm+iAzhHtP7mMDgBOIhFTmrQp6T6j
	 7o58sxRtvQJdKV8aXQ+HMetV6tsw1HltAAIjywC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0577/1424] clk: moxart: remove unused variables, fix refcount leak
Date: Sat, 12 Sep 2026 08:50:09 +0200
Message-ID: <20260912065620.219957663@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander A. Klimov <grandmaster@al2klimov.de>

[ Upstream commit 9f275f2ee9ca60ea4c092bdc0195987945ad8ad8 ]

Not only these error checks are redundand,
those of_clk_get() return values weren't cleaned up via clk_put().

Fixes: c7bb4fc16ead ("clk: add MOXA ART SoCs clock driver")
Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
Reviewed-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-moxart.c | 14 --------------
 1 file changed, 14 deletions(-)

diff --git a/drivers/clk/clk-moxart.c b/drivers/clk/clk-moxart.c
index 3786a0153ad17..40663ef3ef0ae 100644
--- a/drivers/clk/clk-moxart.c
+++ b/drivers/clk/clk-moxart.c
@@ -17,7 +17,6 @@ static void __init moxart_of_pll_clk_init(struct device_node *node)
 {
 	void __iomem *base;
 	struct clk_hw *hw;
-	struct clk *ref_clk;
 	unsigned int mul;
 	const char *name = node->name;
 	const char *parent_name;
@@ -34,12 +33,6 @@ static void __init moxart_of_pll_clk_init(struct device_node *node)
 	mul = readl(base + 0x30) >> 3 & 0x3f;
 	iounmap(base);
 
-	ref_clk = of_clk_get(node, 0);
-	if (IS_ERR(ref_clk)) {
-		pr_err("%pOF: of_clk_get failed\n", node);
-		return;
-	}
-
 	hw = clk_hw_register_fixed_factor(NULL, name, parent_name, 0, mul, 1);
 	if (IS_ERR(hw)) {
 		pr_err("%pOF: failed to register clock\n", node);
@@ -56,7 +49,6 @@ static void __init moxart_of_apb_clk_init(struct device_node *node)
 {
 	void __iomem *base;
 	struct clk_hw *hw;
-	struct clk *pll_clk;
 	unsigned int div, val;
 	unsigned int div_idx[] = { 2, 3, 4, 6, 8};
 	const char *name = node->name;
@@ -78,12 +70,6 @@ static void __init moxart_of_apb_clk_init(struct device_node *node)
 		val = 0;
 	div = div_idx[val] * 2;
 
-	pll_clk = of_clk_get(node, 0);
-	if (IS_ERR(pll_clk)) {
-		pr_err("%pOF: of_clk_get failed\n", node);
-		return;
-	}
-
 	hw = clk_hw_register_fixed_factor(NULL, name, parent_name, 0, 1, div);
 	if (IS_ERR(hw)) {
 		pr_err("%pOF: failed to register clock\n", node);
-- 
2.53.0



