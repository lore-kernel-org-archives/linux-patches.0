Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5BA281349;
	Thu, 13 Feb 2025 14:41:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457694; cv=none; b=FJX+9+7DGxreI85ntpZtY4BPIAHAeAseWL4L7RhKHIpCpw+MvkMtFNGuC+bfKdpkiG1ifseM3/cMeTi9GQjjN57UrQQUQYe/jYQX8A1PFnWPqFExQKH7kIfpwOZhrNx2+IGmIkMwabZJi6DMSby0Dq2l1Z9XshuajiiqasnDGdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457694; c=relaxed/simple;
	bh=hl5Uyfa6yEXy4SeCx+vCC8u8dOO1mQ7wvptbhNorvAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aiKO2v4QGWVOxvlR455Gu5LY7Cauw/iJ8597djRTebWCmB5xbPnwbFgSGbcS40iOHIXl1qmBxW/Z2KrSxG+NbACJ7FuncpE4aAy1P1DW0+DcCAf7ZuRFVxT2oZ3kVSlqbn+vtc5TebRGTHUyVBvs4IJXBgslYPP+bMgsECa92TE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wsp13Oy8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wsp13Oy8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57999C4CED1;
	Thu, 13 Feb 2025 14:41:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457693;
	bh=hl5Uyfa6yEXy4SeCx+vCC8u8dOO1mQ7wvptbhNorvAs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wsp13Oy8n86GXP5hpdxeTBWuNsFquB5daLcIgcAClv/kqo5D4UgUngpU14Z9UPJ+C
	 wUQfTIVg7uLeNZDZSN5T5Cvgt8LyOTqe3/ydt+hDwqRt+kODawrwq3IGyV0C3hz7dx
	 kvpBU/iv/DL7ndT1zpZ2DEpFnaGWRxJvrDW0+ooE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 186/422] clk: mediatek: mt2701-bdp: add missing dummy clk
Date: Thu, 13 Feb 2025 15:25:35 +0100
Message-ID: <20250213142443.724410273@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

commit fd291adc5e9a4ee6cd91e57f148f3b427f80647b upstream.

Add dummy clk for index 0 which was missed during the conversion to
mtk_clk_simple_probe().

Fixes: 973d1607d936 ("clk: mediatek: mt2701: use mtk_clk_simple_probe to simplify driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/b8526c882a50f2b158df0eccb4a165956fd8fa13.1734300668.git.daniel@makrotopia.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mediatek/clk-mt2701-bdp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/mediatek/clk-mt2701-bdp.c
+++ b/drivers/clk/mediatek/clk-mt2701-bdp.c
@@ -31,6 +31,7 @@ static const struct mtk_gate_regs bdp1_c
 	GATE_MTK(_id, _name, _parent, &bdp1_cg_regs, _shift, &mtk_clk_gate_ops_setclr_inv)
 
 static const struct mtk_gate bdp_clks[] = {
+	GATE_DUMMY(CLK_DUMMY, "bdp_dummy"),
 	GATE_BDP0(CLK_BDP_BRG_BA, "brg_baclk", "mm_sel", 0),
 	GATE_BDP0(CLK_BDP_BRG_DRAM, "brg_dram", "mm_sel", 1),
 	GATE_BDP0(CLK_BDP_LARB_DRAM, "larb_dram", "mm_sel", 2),


