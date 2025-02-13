Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02C34139566;
	Thu, 13 Feb 2025 14:41:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457688; cv=none; b=hkL4eVIlrafISvOLLdL6MlMzstUpciYe1jBhV2QcbvP9hsR+Jrf+75jCchQkBnfXimtUKx4VKpd1JdF0kWTDlAHIU+JRF9AFFPbXANiyPNKhJWP/sb+GIvCfiCFv6W5y0pYXOqWjbS8eR5e5UDkU5giEBPlL6DSe4+z/wa1tB/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457688; c=relaxed/simple;
	bh=d50qQPii0i2H8hUcHAQX9QagLCDoV5M7ieZZITjD6A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pjCfwhOglr3WGZL/8NEFbtEUSZQ0lhIRr4Yi6JJKR2mpzgJ5rEZuA6HxusSm+h9O4tpygD2bbjyQBnu+JiuaZhYUvnN6KnBCfa+Sor42Qdkrzi4oXw65+ETjELPZsjJ2FhiUEIWA7b4VixZdymtsE8x3k2HqLEuF0B/Fp7nYvr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LUgPypKq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LUgPypKq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBE56C4CED1;
	Thu, 13 Feb 2025 14:41:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457687;
	bh=d50qQPii0i2H8hUcHAQX9QagLCDoV5M7ieZZITjD6A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LUgPypKqh6PoqObmYcR7jpcLSQkzqTH2RIUR3X3NDwmesiskBO10TCvCuF88aqGwk
	 W2WHpHH4rpeT3aYZ0hmBQbjMNSwXHpiUTeVFy0pZwB1HPk1+tN4IBJrY9XzKTKqGu6
	 FAhi+MnSPwQ92XOTFbqZaCbOGl205DeKzub9s3qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.12 184/422] clk: mediatek: mt2701-vdec: fix conversion to mtk_clk_simple_probe
Date: Thu, 13 Feb 2025 15:25:33 +0100
Message-ID: <20250213142443.648172364@linuxfoundation.org>
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


