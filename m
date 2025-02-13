Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597FD152532;
	Thu, 13 Feb 2025 15:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460457; cv=none; b=gOqID3i1YrX1W8meYo9Pl5EsQb4K8CXeeor+xx0/Io8i6jz9k64SUMaSL5vouMs8TFFiR7F2iYyzdy6JCxb9XGNuiD9gTzTGc6l1th4ImqKpWLHq8PiiHrvczXnuLOc982Ig1S2JsXe2UYm19aiKn8C88FwtRf1yrMrMd9vSWPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460457; c=relaxed/simple;
	bh=DlyYVSWhcqt8F5P3Ew3l9iXOh+bRETfB5WufF/EbSdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ceyoVJWrLo7ZrlxevzySfNyMi/RQbx8oW3JiAWMj07W7J0VsDh3a/DCcwrVpig9+LBCsjK2BcVPVoCBoZOG84rSVMdCZlrg9tc3+iPFunZ6Erwac3o+Lh/SrD8KzvqPRlYczYHvUmdV8hX1q+P8c5E8lk5Yc4qCmt8CvRc/hM7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vyBhctKy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vyBhctKy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62B0EC4CED1;
	Thu, 13 Feb 2025 15:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460456;
	bh=DlyYVSWhcqt8F5P3Ew3l9iXOh+bRETfB5WufF/EbSdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vyBhctKySJnKsFV8rA9I6B4R8uEEP6nsCYM6de8aGdmGneY4wEB250IOPGNC6A90y
	 9G1O72fMurLP0vGko250v+W4xYz6yxYj+oui7tTv3CUnn17ENl7Qm9c43TuoTBKpOz
	 W9Px71l0I9tKko9d2x1jDSIUFGSIlzSA1JvV89nQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 117/273] clk: mediatek: mt2701-img: add missing dummy clk
Date: Thu, 13 Feb 2025 15:28:09 +0100
Message-ID: <20250213142411.967182515@linuxfoundation.org>
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


