Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF7B13D8A4;
	Thu, 13 Feb 2025 14:41:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457697; cv=none; b=R60Mt19yhYkov1ahttySDv/dS4umZI6Qay+Oev5GHSQ/GxtVyiazpc5HyhdnRxaLSorZse6sxq3MfThKHIqi1CwJrFAHyAyZiefPj2FYSmDQPd64aA830suu8P2933z1vdsVIGnZpcxtqV3dl0reINP3NHCdW+uMRD9AC4ql2zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457697; c=relaxed/simple;
	bh=DPXD39NSjjzAuj5/CmbTUB4eVkLSUrpzniiaaGOhxtA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T3pK9hcNQfh3tTu6eugUdZ/EDavWstepYTH6Yr2L60/glXoHzvbDp2tcV6V8MLmGTruVFCN1SlkL6AKGJAV2MyaxHdqS/iNIr9AZ0LYmTGdlA7iwNyyyRH6B5lJH9wjQm41vc9DeXMq6QIFVVcx1FKjRAhgC26q+Niy5hpxWZGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cmy9HNyl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cmy9HNyl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E9EC4CED1;
	Thu, 13 Feb 2025 14:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457697;
	bh=DPXD39NSjjzAuj5/CmbTUB4eVkLSUrpzniiaaGOhxtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cmy9HNylg3h2JtAggF32iVn7ODeXyc4O4Jh4rL0qYcc52br75WrsfT4bMdd3eM0NV
	 cnhrSBmjou19mHp75H+0QIZ57z3mUPKo6M1xU2Hy0k9gRsdxCojF3MNfW0llKoT6SM
	 Ta06TvVe+7ZAshQKrTja+sZz008xQHKL5+jqCc/E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 187/422] clk: mediatek: mt2701-img: add missing dummy clk
Date: Thu, 13 Feb 2025 15:25:36 +0100
Message-ID: <20250213142443.763280798@linuxfoundation.org>
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

commit 366640868ccb4a7991aebe8442b01340fab218e2 upstream.

Add dummy clk for index 0 which was missed during the conversion to
mtk_clk_simple_probe().

Fixes: 973d1607d936 ("clk: mediatek: mt2701: use mtk_clk_simple_probe to simplify driver")
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Link: https://lore.kernel.org/r/d677486a5c563fe5c47aa995841adc2aaa183b8a.1734300668.git.daniel@makrotopia.org
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mediatek/clk-mt2701-img.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/mediatek/clk-mt2701-img.c
+++ b/drivers/clk/mediatek/clk-mt2701-img.c
@@ -22,6 +22,7 @@ static const struct mtk_gate_regs img_cg
 	GATE_MTK(_id, _name, _parent, &img_cg_regs, _shift, &mtk_clk_gate_ops_setclr)
 
 static const struct mtk_gate img_clks[] = {
+	GATE_DUMMY(CLK_DUMMY, "img_dummy"),
 	GATE_IMG(CLK_IMG_SMI_COMM, "img_smi_comm", "mm_sel", 0),
 	GATE_IMG(CLK_IMG_RESZ, "img_resz", "mm_sel", 1),
 	GATE_IMG(CLK_IMG_JPGDEC_SMI, "img_jpgdec_smi", "mm_sel", 5),


