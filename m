Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E67B11B87E9;
	Tue, 12 Aug 2025 19:16:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026174; cv=none; b=X8g5JZqWcQzpikieNNo5HTq6b+UMaFjflREkwwsD4enxi8FFgTVpIXdLIeTyG0Hj7/NJrDUBekDYme2/dZl51NKIfrs1Ce57lcVVI8UllvqI0ieH+VPSWtdzhqMFyjDfJL9+ihRF5rPwwM2rzAax1deo0UEwC+eu9Lit39IU0aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026174; c=relaxed/simple;
	bh=CJrAb4V2lpC7D4+Jj+Q2Ij1/FNrGf+dcmwDZkCxLWjI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XDNBmbXfpSECh6YTrsaA9MfwFXgP3ym7s4slO/vNOcUK14U/KqamesdJfd8PqKouSXIcZcOCUVKT7cxtxK4o3PIWsnL3p0JqPZs+ff591RaH4+/p0XElJYqN8O4e+wJKZTivohATY58YpDxVHkinPkwmQPiwsUSiwX9d23I+Tk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HZNQ2qFk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HZNQ2qFk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5708CC4CEF0;
	Tue, 12 Aug 2025 19:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026173;
	bh=CJrAb4V2lpC7D4+Jj+Q2Ij1/FNrGf+dcmwDZkCxLWjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HZNQ2qFkDB1ngv73zr4qNufaKmFS03vMI05Vwxu7tFhr8Xzr2OUzP1z65SIliWHTm
	 5LSgvzs6td4B3UwlvhFYzQbEiaHFqsguJq+9CoSgtCcZGL0Y549b2r43fFF8n5lCoL
	 UFdO+nrgteAKXhFYyt4DaJcRu8qWaMphyum5OAFk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 225/480] clk: renesas: rzv2h: Fix missing CLK_SET_RATE_PARENT flag for ddiv clocks
Date: Tue, 12 Aug 2025 19:47:13 +0200
Message-ID: <20250812174406.725682176@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 715676d8418062f54d746451294ccce9786c1734 ]

Commit bc4d25fdfadf ("clk: renesas: rzv2h: Add support for dynamic
switching divider clocks") missed setting the `CLK_SET_RATE_PARENT`
flag when registering ddiv clocks.

Without this flag, rate changes to the divider clock do not propagate
to its parent, potentially resulting in incorrect clock configurations.

Fix this by setting `CLK_SET_RATE_PARENT` in the clock init data.

Fixes: bc4d25fdfadfa ("clk: renesas: rzv2h: Add support for dynamic switching divider clocks")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250609140341.235919-1-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/rzv2h-cpg.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/renesas/rzv2h-cpg.c b/drivers/clk/renesas/rzv2h-cpg.c
index 2b9771ab2b3f..43d2e73f9601 100644
--- a/drivers/clk/renesas/rzv2h-cpg.c
+++ b/drivers/clk/renesas/rzv2h-cpg.c
@@ -323,6 +323,7 @@ rzv2h_cpg_ddiv_clk_register(const struct cpg_core_clk *core,
 	init.ops = &rzv2h_ddiv_clk_divider_ops;
 	init.parent_names = &parent_name;
 	init.num_parents = 1;
+	init.flags = CLK_SET_RATE_PARENT;
 
 	ddiv->priv = priv;
 	ddiv->mon = cfg_ddiv.monbit;
-- 
2.39.5



