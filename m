Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC993C1419;
	Sat, 12 Sep 2026 07:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197009; cv=none; b=aGz91wwwal+Pc8DQObYbDyyVhqPy3T0mrXOcu2eswgMTrf3q4fIyTI4s3L89UGd0Rcz6z0W8qgGeN0nW8UcUkYLmcTbQK/lMpYPOcaFosgaiQQSmVZErAykelb/mJnZhlLwuiMpNVgD4yP3ZlRPY8gNsW9fQmgqz15uIekfU6Uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197009; c=relaxed/simple;
	bh=GUjc7z/WOSmv6RonwkNSABZ7fMrWkrGnR2lBK5Dw1Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mP+jUz7Khngqe4arCYgQej8eAtP1ShnmebfMFC2RNEMurFmLmhwXO86Yyx4qBglwUZRAt4NpnkvNMj53FL8SR+D89ricvD22XkNIovHGZEFEibFHEgfHB7CMXkN2TwoOzgJ0CdzipDOU86tqPmFBoPx/iV8LemUl40Hyfe6BWgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xugTcWic; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xugTcWic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CC8F1F000FF;
	Sat, 12 Sep 2026 07:10:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197007;
	bh=YprcMgSxyKrBQ0Aluy9RBy/pHkgktxbY+FTgkvu+Thc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xugTcWic0hRpb597HtEivIV1GOLguFG/QKhLWpFhvUOSBsQXDzLf/QxGqTZDGuqpE
	 0m83jsnCRFzVYhHAtv/+1VknzB/krpY3XJ0W18FWooXkYZaeYG7gQsSMV6tZTskaL7
	 xbwE72owlDPPd1rRx0bNglNbXdqrFNq3Xfoa13gs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0081/1815] clk: moxart: remove unused variables, fix refcount leak
Date: Sat, 12 Sep 2026 08:30:31 +0200
Message-ID: <20260912065650.911196377@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



