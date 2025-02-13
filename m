Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B5AE26B0B4;
	Thu, 13 Feb 2025 15:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460464; cv=none; b=FhKvWfUpbzG/BUvizdCpFEMZzwdchCtF4mDbPfR+IN/1ITpyxNmIiW5TgVTqpas6SI48oRkUz2TczsICAHsggVF6GAReVGyl3j54LkKdcLLgFCsqj5I6Pggd8622rNFbDXhbNbu/WgOEuCyW4WZyToSFlKG55qqtzIQBP3fGqvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460464; c=relaxed/simple;
	bh=hgXc89R46XSwP9IpAjqRcX9aJOV85NP5yC5bgJF+MCw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mG8o+xwOPj+GeuRWDxNM3ywlOQPT3ahZBvT5apiMGmxMMMBt9Ce4/MPMZ1SpdQDjg6xPDpw9lsTEceiyzj1FVBH3yehABspA/TNGnjbrNUTSFVx070UinrH6wBV6sIUBFjBrorBn2M0gKqAB/3Qpld6nDCzsroDxUJiQnHzKY1w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcHW2Li3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcHW2Li3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C893C4CED1;
	Thu, 13 Feb 2025 15:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460464;
	bh=hgXc89R46XSwP9IpAjqRcX9aJOV85NP5yC5bgJF+MCw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcHW2Li3raDp9UUGdrMoiI0aMedDvTQ5XlIirZekSUIgzUiiAMzmjmSiroyC5PJ3K
	 6g7go8No3W3ByhaL6PVTC/Tx6QNeqKx2pJX9IgSjF+ATPtxKIMOT30HTbOKGPThi33
	 CBgoSLOTBGV2jmWG7p/LfC7XNMFd3Qd/T5lejqn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 118/273] clk: mediatek: mt2701-mm: add missing dummy clk
Date: Thu, 13 Feb 2025 15:28:10 +0100
Message-ID: <20250213142412.007278793@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142407.354217048@linuxfoundation.org>
References: <20250213142407.354217048@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


