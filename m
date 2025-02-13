Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94DB926B082;
	Thu, 13 Feb 2025 15:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459352; cv=none; b=Aye0omE7N/cT7O/OPSJM+tPjej4AgTdvYJEPowMttaXlrCPOCxoZlNRcfMHIt/kFDRuCMgXkJUHZ2KcBU+jJsect8fF1/p8T/CVvSGYCXkl13qqIxzfGasSYw8rguCYRn6CmF/w4O6qCFljhCDvdWfk232AtPW9GVh6oSaiLBMo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459352; c=relaxed/simple;
	bh=BdsBUIVsFtUMrQLFPNryysMfWzTuk1fgcDSqNEixSCI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mi/YT2WjaLCARthCXQbSHGTA4z6sIrKLQaJGqIdegacguuQFzdDFZgWZmz/qIjPR+oxSRHjz/z9hiFyMQgM97gNdmL2bzGI7Ln4/jSVz4n1ufSVf5WIpTyaIZ0NsJ1J1N0jQqZH18F7bR1uTM89GaWq9z6u/N38dhNDwwkFcSlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dpTHHMn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dpTHHMn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03455C4CED1;
	Thu, 13 Feb 2025 15:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459352;
	bh=BdsBUIVsFtUMrQLFPNryysMfWzTuk1fgcDSqNEixSCI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpTHHMn0ussDV1LNaPRkQlbKOErFM8ZCLyqZd8ahLB68DrWKtFFP2PYyBapsBoODD
	 WtY2C3A/ofA0zBmdh8XolUFp5U5dNfNiNl/EMFTtMWxSryINLJlKz4ueTMXR0K/gJ1
	 NPH1nkJp2etQiylKT0n9SrELPIXi9QhTHeQqQXTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.13 208/443] clk: mediatek: mt2701-mm: add missing dummy clk
Date: Thu, 13 Feb 2025 15:26:13 +0100
Message-ID: <20250213142448.645075357@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

commit 67aea188f23a5dde51c31a720ccf66aed0ce4187 upstream.

Add dummy clk which was missed during the conversion to
mtk_clk_pdev_probe() and is required for the existing DT bindings to
keep working.

Fixes: 65c10c50c9c7 ("clk: mediatek: Migrate to mtk_clk_pdev_probe() for multimedia clocks")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/9de23440fcba1ffef9e77d58c9f505105e57a250.1734300668.git.daniel@makrotopia.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mediatek/clk-mt2701-mm.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/mediatek/clk-mt2701-mm.c
+++ b/drivers/clk/mediatek/clk-mt2701-mm.c
@@ -31,6 +31,7 @@ static const struct mtk_gate_regs disp1_
 	GATE_MTK(_id, _name, _parent, &disp1_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
 
 static const struct mtk_gate mm_clks[] = {
+	GATE_DUMMY(CLK_DUMMY, "mm_dummy"),
 	GATE_DISP0(CLK_MM_SMI_COMMON, "mm_smi_comm", "mm_sel", 0),
 	GATE_DISP0(CLK_MM_SMI_LARB0, "mm_smi_larb0", "mm_sel", 1),
 	GATE_DISP0(CLK_MM_CMDQ, "mm_cmdq", "mm_sel", 2),


