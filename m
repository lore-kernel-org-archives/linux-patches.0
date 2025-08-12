Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E1592C15B5;
	Tue, 12 Aug 2025 17:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755020736; cv=none; b=tVOAjm1CyWOpHpVlXA+Sj4vYO71D6V+mlvNG4C0rooC+BROxMwjwrGMnhCzZ069Ty5pSWkseKADGwSVeBwezVxaWXUo2udBHWIh5i64UxsHxP/++H0q0lvKji/BNrBzgT4NDI8Hhm5NRysj3g4+YGEQHC8CJ9EFZD+hnbqJ3c8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755020736; c=relaxed/simple;
	bh=F3YXmUH83JMMlFOCFWsMZaNC5bpc9QEtR3j8hnrFRjU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1gg5Wjri1tYhErI6nrUFTduF9P6ZqphbabyU/guHBlQRK4KX0uJaUnBdrCcSHSCt/UCKH0pc/Zmfewbmy6judG22e9wz4I0/bxMDvQwcfC5nxijuQQzLEbqDYRyDtEtraUxmSXHOzQgSyTJfUu/mERt9uRYsNW2JahS8c5huTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yHaneRBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yHaneRBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2BFBC4CEF0;
	Tue, 12 Aug 2025 17:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755020736;
	bh=F3YXmUH83JMMlFOCFWsMZaNC5bpc9QEtR3j8hnrFRjU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yHaneRBHUiU48CX/vN5qMHsD/m5tgxv41d0Xhlf5zpYrmVZsv0dZW5fJXTC+pWHtt
	 ngPfz3sgwcZ/efhxZR8Ae1Q0ye4nqp8/F5Z4XdyslaBfgXbX5HnluTxjTL+brm2kfj
	 wjoVyBwiWWJMn0efI9/kfKXncg5KGuvZ4gcXG6vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 160/253] clk: sunxi-ng: v3s: Fix de clock definition
Date: Tue, 12 Aug 2025 19:29:08 +0200
Message-ID: <20250812172955.526564038@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172948.675299901@linuxfoundation.org>
References: <20250812172948.675299901@linuxfoundation.org>
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

From: Paul Kocialkowski <paulk@sys-base.io>

[ Upstream commit e8ab346f9907a1a3aa2f0e5decf849925c06ae2e ]

The de clock is marked with CLK_SET_RATE_PARENT, which is really not
necessary (as confirmed from experimentation) and significantly
restricts flexibility for other clocks using the same parent.

In addition the source selection (parent) field is marked as using
2 bits, when it the documentation reports that it uses 3.

Fix both issues in the de clock definition.

Fixes: d0f11d14b0bc ("clk: sunxi-ng: add support for V3s CCU")
Signed-off-by: Paul Kocialkowski <paulk@sys-base.io>
Link: https://patch.msgid.link/20250704154008.3463257-1-paulk@sys-base.io
Signed-off-by: Chen-Yu Tsai <wens@csie.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
index fbb3529f0d3e..8263beac203b 100644
--- a/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
+++ b/drivers/clk/sunxi-ng/ccu-sun8i-v3s.c
@@ -347,8 +347,7 @@ static SUNXI_CCU_GATE(dram_ohci_clk,	"dram-ohci",	"dram",
 
 static const char * const de_parents[] = { "pll-video", "pll-periph0" };
 static SUNXI_CCU_M_WITH_MUX_GATE(de_clk, "de", de_parents,
-				 0x104, 0, 4, 24, 2, BIT(31),
-				 CLK_SET_RATE_PARENT);
+				 0x104, 0, 4, 24, 3, BIT(31), 0);
 
 static const char * const tcon_parents[] = { "pll-video" };
 static SUNXI_CCU_M_WITH_MUX_GATE(tcon_clk, "tcon", tcon_parents,
-- 
2.39.5



