Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435DB20E023;
	Tue, 12 Aug 2025 19:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026252; cv=none; b=l7iO5nWnEcW9NSapZdPYY+i3o87wzVIE79dn8DcI/Rn8vt4ASPh4MIuhx8z7++ozzgbJRGbLITjuV8GCxvzsWe9xWqe8XjSnLTG2BiDq29fNVynXWlpoUUJONM5R3P+qbn8Jk8WFzvqBKJwMX8oP4CFj/KQ4pV1PvFiY7jRTVrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026252; c=relaxed/simple;
	bh=d6lK9yatU+5GWof6PQyS37hUppvJ4SmWBY/kq6qRLv8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t0iekiDa4og+sOoRRqMW10oS5aW27/qp8fS0Ylk3wJfmBOzoRlMQEgwDqq4EoTSOcETOTIshy2Hsx78nPZUa0kGev7chW0j14sWVk850Hah37WASxBxzFb/Ba0Wzv4AhtdUghZGD4qLOMaG1oBd6lqi8rzPp9svlhhmsrut5Fi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JevXFP2w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JevXFP2w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC75C4CEF0;
	Tue, 12 Aug 2025 19:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026252;
	bh=d6lK9yatU+5GWof6PQyS37hUppvJ4SmWBY/kq6qRLv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JevXFP2wSNTEZ8azu74f6KQkwjBuy+BsC99flHWS8kRUC6lIBEpH6EwCAwB3L7IL/
	 3KHzD3CRMeAbHXb/sAwHqru3KRDdIyUzFT3gAAwrdd8qmpBCcir44z/rLFnxasKIPx
	 YdkZ22lxfsuAqi8ihcaA5AjSsBrSjfxP0GfCFGY0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Kocialkowski <paulk@sys-base.io>,
	Chen-Yu Tsai <wens@csie.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 282/480] clk: sunxi-ng: v3s: Fix de clock definition
Date: Tue, 12 Aug 2025 19:48:10 +0200
Message-ID: <20250812174409.061914492@linuxfoundation.org>
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
index 579a81bb46df..7744fc632ea6 100644
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



