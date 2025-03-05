Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633801946C7;
	Wed,  5 Mar 2025 17:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197040; cv=none; b=mWw9BPkDBBMOkLLFqEjEO6ENUrHHASaRgpprzI9CUjADroPm7PzA2fDMB9HHAA5KiGc8P6kNG6vg0ppzx8/LCx+2ae/KInHjjvpbXkZ8jYOvPAxjvgpma+h5DDe0ct+xphvk3JrBjpfobxTjCt0X2MqJeLQPeZPP59Me9MtCAjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197040; c=relaxed/simple;
	bh=ozDabK7Wyv3tDayb8FduyN7MJpkgr6TdgPsLrbD2vXQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1xid11aFbkDBBROTtanoNpB/3Z1XLfRc2oWEP2moPnjOFYbmH2c5j+rjDgzw9CAC7fm37nMoBJnhbXuJREgkbHk6Ayb3TyRSv2EpTj5InvbFWrNXP3bfbzI2OPCpL5T+jo4KgGdiu4KO7QXANwUHWlhq181z4cxov42lD8OZSY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm8LmfF8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm8LmfF8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7ED5BC4CEE2;
	Wed,  5 Mar 2025 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197040;
	bh=ozDabK7Wyv3tDayb8FduyN7MJpkgr6TdgPsLrbD2vXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lm8LmfF8T3UsFjWJVIK0BcX3O1GasEg/GR+ySyiyey8oWs7AbDYqPgSynDUutM5zL
	 KiePnQMhxhfuQAovYOtDHR4szH8Ra+wPwP0IbPOMQs8hO74BF7rTpQ0/x/5QF5WBj8
	 Kf1YkOok/jOsDoHyoIc1v9qhyALr4Ma9aIg4De7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/176] clk: mediatek: mt2701-vdec: fix conversion to mtk_clk_simple_probe
Date: Wed,  5 Mar 2025 18:46:28 +0100
Message-ID: <20250305174506.235528474@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.437358097@linuxfoundation.org>
References: <20250305174505.437358097@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit 7c8746126a4e256fcf1af9174ee7d92cc3f3bc31 ]

Commit 973d1607d936 ("clk: mediatek: mt2701: use mtk_clk_simple_probe to
simplify driver") broke DT bindings as the highest index was reduced by
1 because the id count starts from 1 and not from 0.

Fix this, like for other drivers which had the same issue, by adding a
dummy clk at index 0.

Fixes: 973d1607d936 ("clk: mediatek: mt2701: use mtk_clk_simple_probe to simplify driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/b126a5577f3667ef19b1b5feea5e70174084fb03.1734300668.git.daniel@makrotopia.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt2701-vdec.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mediatek/clk-mt2701-vdec.c b/drivers/clk/mediatek/clk-mt2701-vdec.c
index 0f07c5d731df6..fdd2645c167f4 100644
--- a/drivers/clk/mediatek/clk-mt2701-vdec.c
+++ b/drivers/clk/mediatek/clk-mt2701-vdec.c
@@ -31,6 +31,7 @@ static const struct mtk_gate_regs vdec1_cg_regs = {
 	GATE_MTK(_id, _name, _parent, &vdec1_cg_regs, _shift, &mtk_clk_gate_ops_setclr_inv)
 
 static const struct mtk_gate vdec_clks[] = {
+	GATE_DUMMY(CLK_DUMMY, "vdec_dummy"),
 	GATE_VDEC0(CLK_VDEC_CKGEN, "vdec_cken", "vdec_sel", 0),
 	GATE_VDEC1(CLK_VDEC_LARB, "vdec_larb_cken", "mm_sel", 0),
 };
-- 
2.39.5



