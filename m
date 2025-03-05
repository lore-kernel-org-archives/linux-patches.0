Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F9D76ADD;
	Wed,  5 Mar 2025 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741197049; cv=none; b=RmFDC57vCh5bMuExVLT1JA5vHv5cWVJlWe8uVClyYdRTtG64UEYyr4AeQpMzlBsU0QFEqQTJ27W1lRZMOLDuOy/lvzcgRP2E87fBSvfxDlCT5GORMRqZ0Sltzmp74QqjE6sqMKlJRy4qpjWQ3Fp1Yh9QPleYG5q9rialzyHQtIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741197049; c=relaxed/simple;
	bh=UBO/uIvSnI4s4x3juuvHae8o/DFwp8jyQlTDyLSy2i0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rM/pQyPABHgmrF5gD0A3U4i0euIIW42xXkosIOSEtNvDR3yiJ2xkY0zrOGiTaSs5hFdk5bLIH1lDTUxcjc9rEdBJoYgxyHxg8TbKjwDdoa5iVbfBV6ALVJ65ddQFj3WuBSUrFQZbaROttLkxO+SOw1ZiwfM+8JgCuzhtze4iWEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEb3wGn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEb3wGn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFF1C4CED1;
	Wed,  5 Mar 2025 17:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741197048;
	bh=UBO/uIvSnI4s4x3juuvHae8o/DFwp8jyQlTDyLSy2i0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEb3wGn7qaFVTABTJWO1w2OproiLoWDGAZ6yo5dYHVuF0fAWClMZw8K4RWgxp8+UL
	 +u0RsfFwEDQSbdM35iPrAUsAENSPsYxfo8UdyOfgP8YpIRdWFImlP2xAk7DDHXib6r
	 wLa1AEtev3NmoXIbUc+S6daIcSpPliB8823Yzgv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 021/176] clk: mediatek: mt2701-img: add missing dummy clk
Date: Wed,  5 Mar 2025 18:46:30 +0100
Message-ID: <20250305174506.313496758@linuxfoundation.org>
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

[ Upstream commit 366640868ccb4a7991aebe8442b01340fab218e2 ]

Add dummy clk for index 0 which was missed during the conversion to
mtk_clk_simple_probe().

Fixes: 973d1607d936 ("clk: mediatek: mt2701: use mtk_clk_simple_probe to simplify driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/d677486a5c563fe5c47aa995841adc2aaa183b8a.1734300668.git.daniel@makrotopia.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt2701-img.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/mediatek/clk-mt2701-img.c b/drivers/clk/mediatek/clk-mt2701-img.c
index eb172473f0755..569b6d3607dd6 100644
--- a/drivers/clk/mediatek/clk-mt2701-img.c
+++ b/drivers/clk/mediatek/clk-mt2701-img.c
@@ -22,6 +22,7 @@ static const struct mtk_gate_regs img_cg_regs = {
 	GATE_MTK(_id, _name, _parent, &img_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
 
 static const struct mtk_gate img_clks[] = {
+	GATE_DUMMY(CLK_DUMMY, "img_dummy"),
 	GATE_IMG(CLK_IMG_SMI_COMM, "img_smi_comm", "mm_sel", 0),
 	GATE_IMG(CLK_IMG_RESZ, "img_resz", "mm_sel", 1),
 	GATE_IMG(CLK_IMG_JPGDEC_SMI, "img_jpgdec_smi", "mm_sel", 5),
-- 
2.39.5



