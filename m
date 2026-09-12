Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECB3531F9B4;
	Sat, 12 Sep 2026 18:39:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238361; cv=none; b=bi8zCMnxGNzpdzspiSuY/l+N4HRN7nUQGwu5UduzvmianaPVZY1kh/OC/D5XVLGiT1ra05injVzMxf6lJsKaQ4masdvqQsR8FdMhr0maz2Lg9r2n6cLY8bZA0GWeVNnqdA1pOWsrL6f2uf4V+P4Ztnytprac9G2DrpYO2OFh/o4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238361; c=relaxed/simple;
	bh=HZoowFJ/L6ods2ROv6VCyVOfqQZ9E2jTN9q19pDM/iw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oj5eILC4bEZA+1aVLGR3NxT3Uh7xE7WcELguFDRWtnMdcjM7i3MDnVgELK/16EjkEqY7C/tTKIoKBRFHV2v7A7ZVwpR8ukt2HjcxkuCkqbcN+zGYl8jxfutdc74c7n3V0b02GZKtT1tFAmzpF+/Mz+vdV5eVm3VHeCua+UKRCLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPMBDdhl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPMBDdhl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809511F000FF;
	Sat, 12 Sep 2026 18:39:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238359;
	bh=iydNdS12plUOq2njEehE4JLB8VGkaSVwfzb4kHmsbjc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPMBDdhlVItDEGcRnU66Tpb+v7VKLpbNYWzC4vVr6eFao5qrWYQbS1HZMiuazgOZ9
	 iCJUENgyf9rbBgyF5Fjh1gj/eZBQLbpfq+l7PzYWKriXs6CxQvqIn6ojX2Bb1aNPBq
	 4TNfcbnH0+23i8Mqk91yutYTxQg7CQfwbaqD4rXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 403/935] clk: moxart: remove unused variables, fix refcount leak
Date: Sat, 12 Sep 2026 08:57:13 +0200
Message-ID: <20260912065536.068155198@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 58428d0043fdc..68fa4a410a490 100644
--- a/drivers/clk/clk-moxart.c
+++ b/drivers/clk/clk-moxart.c
@@ -20,7 +20,6 @@ static void __init moxart_of_pll_clk_init(struct device_node *node)
 {
 	void __iomem *base;
 	struct clk_hw *hw;
-	struct clk *ref_clk;
 	unsigned int mul;
 	const char *name = node->name;
 	const char *parent_name;
@@ -37,12 +36,6 @@ static void __init moxart_of_pll_clk_init(struct device_node *node)
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
@@ -59,7 +52,6 @@ static void __init moxart_of_apb_clk_init(struct device_node *node)
 {
 	void __iomem *base;
 	struct clk_hw *hw;
-	struct clk *pll_clk;
 	unsigned int div, val;
 	unsigned int div_idx[] = { 2, 3, 4, 6, 8};
 	const char *name = node->name;
@@ -81,12 +73,6 @@ static void __init moxart_of_apb_clk_init(struct device_node *node)
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



