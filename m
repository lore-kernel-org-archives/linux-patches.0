Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C09B813AA2F;
	Tue, 12 Aug 2025 18:43:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755024193; cv=none; b=hBVqTmYPi0qkoEMSxVys8/PuFSqQHnxbH7Xcg6pWVyQx49lRqYzvDRVy7YI7m6EU8SvuASRlwZaZwumD7w5SssF1mYtW8YqLyV9KYi/UMxhlENQGGleQff4uZ27siPck6rYPN0dv63dNnk864KWrsJ3oWm5zjQwt69XnH4QEUtE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755024193; c=relaxed/simple;
	bh=aesKUrmUx4m7fOcQPNduq3Vkum/lpgM9+hcCWX4Plzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sGobzAgVFldbcRWSiAUlEa8+kI5VmcydoAZzica1jGX8940UWNEU8UEHOOCx/RRVaWPf2NfNEvOz/QicFlEnXCvFIBv6veYMQHITh3JErlMk1OW9mG0wa3SiTAXu1i92WDl+VSMnS9usWDSlx3s6FY+p5Hz+VDMD2n/9eSXNLbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fpJcj2fh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpJcj2fh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C55C4CEF0;
	Tue, 12 Aug 2025 18:43:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755024193;
	bh=aesKUrmUx4m7fOcQPNduq3Vkum/lpgM9+hcCWX4Plzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fpJcj2fhCy6C3TJDJpmXMjXFh6U82mNH1ZQoktUxjBt2G1uz/Annk2RE/6vvrKZF7
	 Sg2Fyz5UfO2xYBn969lWItY+s8NbuvtWkhufxgMlhppHui749Jttm/o+SpK8u3zrvb
	 Lv4OcubfOCpPA5TUx1/YVI2Z0Cu11gOCX07A4V88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 301/627] clk: renesas: rzv2h: Fix missing CLK_SET_RATE_PARENT flag for ddiv clocks
Date: Tue, 12 Aug 2025 19:29:56 +0200
Message-ID: <20250812173430.753507344@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index bcc496e8cbcd..fb39e6446b26 100644
--- a/drivers/clk/renesas/rzv2h-cpg.c
+++ b/drivers/clk/renesas/rzv2h-cpg.c
@@ -381,6 +381,7 @@ rzv2h_cpg_ddiv_clk_register(const struct cpg_core_clk *core,
 		init.ops = &rzv2h_ddiv_clk_divider_ops;
 	init.parent_names = &parent_name;
 	init.num_parents = 1;
+	init.flags = CLK_SET_RATE_PARENT;
 
 	ddiv->priv = priv;
 	ddiv->mon = cfg_ddiv.monbit;
-- 
2.39.5



