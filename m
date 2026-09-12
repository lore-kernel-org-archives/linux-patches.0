Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C05442D9792;
	Sat, 12 Sep 2026 19:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242266; cv=none; b=HE/hWBXAmteNmqSbWNghLsuYYb3kvXStwp0iQLlm8ey1QcrQwznVFw8/KogahKL0QWn632lhR2AH3HShXbim5XVZ1aPu+Etp+VJPc6h5rtGTRtIwKMGY3mXAiTigCNsw9So4qgT/SkHY8bJPu4/JGGbqWeAh+K/70WILyczHFm0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242266; c=relaxed/simple;
	bh=Mqp4roJMbXUKaaONp5ggAVjXaNpubGWykTboyi6nVE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mPUOAi2mPtqeBRzWlSET0wD/d7dBSJnkwi+IsJ3epFT3NqYgn6A6tXfmW0WQt0HeN85kkk2Fi/newOOYGASDsDDny6OudhcsrQCdDkqWvtfrQBJgjCc7f5NpVhE6AJmiEo8XCew+ThOCMgFKzegC8eIKOZ2jyaPr0aYr81DwjWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2/BIpQo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2/BIpQo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 295CE1F000FF;
	Sat, 12 Sep 2026 19:44:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242265;
	bh=InJ2H4RMsGpnbBFi8M+v2PXiStYxly2AvGc4nQI9cT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2/BIpQofPc/fMVTuafmL+Ud7kRRbnhWR2Pi3/EBiZnrBqRt54S2r/68lmHHHKsHc
	 W/+Gzx7e9E8HJgzMXvb7zYVbMRdAGsfZyW+jKhKJz4usadBsf0oxIEWDb+4xBGHk1B
	 kBx8t8WBDWYsbLhvsFOKhPPwb3ouqEYjulKuGagA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexander A. Klimov" <grandmaster@al2klimov.de>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 345/798] clk: moxart: remove unused variables, fix refcount leak
Date: Sat, 12 Sep 2026 08:59:33 +0200
Message-ID: <20260912065525.069064578@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



