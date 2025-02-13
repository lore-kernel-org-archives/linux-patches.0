Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B82AB26B08A;
	Thu, 13 Feb 2025 15:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459331; cv=none; b=C1ZhgaY4sGiiBTDJ2gq80crFoZV2vryH5HwlZg3/3kICgowhRXInDQo/ZNdVs51NMPtFva/DfA3Mr9pTeDcyr+7S3eqbe67pdY1j5+j13EXYGg5d+5AzLEFWX0D7WR+/s2boEk7KjhieaFlt3NEEemFDruNivbJ3Hr9MyruiqS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459331; c=relaxed/simple;
	bh=sgUNkdAn25OHdBpQWYKYagjl9JNdIxRHorm0NjFwBGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jZ60ezXPamuo+6Va80k4j6D6+JaElBuilh2ya3h6USa2nEJsoW7yED6dQJPcKgS4ZcZPogn3gVd3c6P1opJAZOtVG4l1Iuxi/PPcs6XXqlRc0su5mR/9O64vndIITMqdZMrzFHnVSZUpL9wY2ukRPmKLDLM3OO8vW/rbbZXKo8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OMCwoGLy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OMCwoGLy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD983C4CEE5;
	Thu, 13 Feb 2025 15:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459331;
	bh=sgUNkdAn25OHdBpQWYKYagjl9JNdIxRHorm0NjFwBGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMCwoGLyWp78lU31igO112khE8YVCnBUdZaAdMyHPoil1puFy75eJ4IWllsrIYXPo
	 7/V6Pi4WQPBRgTqLW3BmYGlSPJc/AyMcMo4T5rRCiQ2izq8d1A4WKVaNbQio8rX5mc
	 PrmlJGNTIkT4LkUjpoDbMo6akQYKWUUo6HnGgtU0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.13 206/443] clk: mediatek: mt2701-bdp: add missing dummy clk
Date: Thu, 13 Feb 2025 15:26:11 +0100
Message-ID: <20250213142448.568624940@linuxfoundation.org>
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


