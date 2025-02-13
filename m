Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3834416BE17;
	Thu, 13 Feb 2025 15:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739459256; cv=none; b=PeifXJUz2r3vJHqrOdeRntKHOyvXxuMsm9ztKX6z3ZOFM7n2NX+W9pNnm1PGlEu58SRaJvjx56dojVEwh3Qe/yApWmBiE54+gk+pPLYEJoqqeQwRan/mZhwgFWJfiBa3+sVwl+w7L27FLTBIKssF+babTxUFDt/VEPYPMgeRV/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739459256; c=relaxed/simple;
	bh=dQ9xL16ToerwSm2K6mAahXYESX0VCnnRI0pYG7wFv1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7ZvnpMmchkIKUkFOpMJ/xi8P9wj0Opg+EUylgIvm5owFilVx+TDqhA5gJ9N5veU+hX5y8L6wZsFXvUYwk19bxqiDyryC5vOEROwZ9q2uh10k+dlFfolIO6jykVxV/RHjexc9vlDB/wc0MyRyo7y3bXPJfr0JJ5Avx14Wc7TxD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lHJDaoXd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lHJDaoXd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B2FCC4CED1;
	Thu, 13 Feb 2025 15:07:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739459255;
	bh=dQ9xL16ToerwSm2K6mAahXYESX0VCnnRI0pYG7wFv1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lHJDaoXdJ7mLfPOTH+CysisPEEIC4P4oZ+g+aFK3N/8Q2kA5hX0VDEjnVypu8Ttb3
	 kN22aT8pL9WnRuw3yOwBQvPPbI0w33qDCreRAe/a73YpmfPF+kkh/tgfqUqh0DBeo/
	 fFT4vms+FwYLaoBGVV5sMHCku/5yTa6G+JeiKp04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.13 204/443] clk: mediatek: mt2701-vdec: fix conversion to mtk_clk_simple_probe
Date: Thu, 13 Feb 2025 15:26:09 +0100
Message-ID: <20250213142448.484078972@linuxfoundation.org>
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

commit 7c8746126a4e256fcf1af9174ee7d92cc3f3bc31 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/mediatek/clk-mt2701-vdec.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/clk/mediatek/clk-mt2701-vdec.c
+++ b/drivers/clk/mediatek/clk-mt2701-vdec.c
@@ -31,6 +31,7 @@ static const struct mtk_gate_regs vdec1_
 	GATE_MTK(_id, _name, _parent, &vdec1_cg_regs, _shift, &mtk_clk_gate_ops_setclr_inv)
 
 static const struct mtk_gate vdec_clks[] = {
+	GATE_DUMMY(CLK_DUMMY, "vdec_dummy"),
 	GATE_VDEC0(CLK_VDEC_CKGEN, "vdec_cken", "vdec_sel", 0),
 	GATE_VDEC1(CLK_VDEC_LARB, "vdec_larb_cken", "mm_sel", 0),
 };


