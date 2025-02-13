Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5FE26B0B4;
	Thu, 13 Feb 2025 15:27:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460441; cv=none; b=jcHzXwTfGUWDDpX3m4kGbGgCFDUMPyjn65PqA5aoZD8Am3XqXdMA5HQXvaR6fywwKkvMZgRK3ZszQaGWI8d9O9EbcRom2MXNboKgypJnlJUfWzgWjk2H8dIIiE0zUKS6TtDd2cdFsi9ve/F0bALiwJhZwUOkxoIVpQA/ZMorVCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460441; c=relaxed/simple;
	bh=CXG2Z6WQhkYcndUwLHfuNvNUu4+CxTNv8GSHSmXplZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m7C3HkpWzUZiAvVBg1/TQl6Vqn/JH3V2RtQeqn1UQNyNOpvAEgGu1KD0+MqkMTCyU8JS6TqLiG3nSikl+hYN2S4BR4k9DxiE9zvi8iJ6WqRipNgSr/t1qtxk0OixD3gtbdWuyjLNqFSzuySkWFzSEY3y/N473yjGxQ0meQQRndI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VW/r7qgm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VW/r7qgm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B33DC4CED1;
	Thu, 13 Feb 2025 15:27:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460441;
	bh=CXG2Z6WQhkYcndUwLHfuNvNUu4+CxTNv8GSHSmXplZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VW/r7qgmUrR2wk+7JESGqRcydSE6423Y3WxlRmNwL86KWtlVPl5UmUwtfznBOlfOQ
	 z0IYRQzDyv+2PWQaCFkO2DADGkMfAqSZy3zhUzgXMUiQUALljMibsKXU2zXKVHB7lH
	 ykiWdxgS0/gQ4s+IEb6f/GAM9SX1GJ/Bu/eDlTVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 6.6 114/273] clk: mediatek: mt2701-vdec: fix conversion to mtk_clk_simple_probe
Date: Thu, 13 Feb 2025 15:28:06 +0100
Message-ID: <20250213142411.849259198@linuxfoundation.org>
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


