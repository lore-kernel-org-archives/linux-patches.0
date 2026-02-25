Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89CC13002D1;
	Wed, 25 Feb 2026 06:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002674; cv=none; b=jDT8q8qVkof26EYQk7phTRiHnEl/P5oIMc8vuRUGS2wklmJ9QEflvVSSXhZZN64PQoH+tddrgkAopDNhTt60n1UPOqMatzKKkHk3qA2x+vqZh3XepmU+YfxHCQ9Fu9pnh4s9JEptgL7uhKS0gwZ1z+Wgn7RUgF0mtHTJlxvynhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002674; c=relaxed/simple;
	bh=iXK3gSiOLco5rFTIsTLV+rZ/G7cKLpUj70bFLEijsrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D2NMrmHWebeW/9TyiYG6BJ3AIe7uoVKLQZ16EqIdoCJXwZvL4ZKt9oYuWdTPUekrgIU897XpAUWC751eN7622RtsTYhQs+LjjuP6TgTF7UlWT+QKj/lqwP3wYNzIpxAtSJ+1IumnhMTDdTUK4zmHWarVnHczcRWvTv4mOBs1wPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FpWpGSB/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FpWpGSB/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 637D7C116D0;
	Wed, 25 Feb 2026 06:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002674;
	bh=iXK3gSiOLco5rFTIsTLV+rZ/G7cKLpUj70bFLEijsrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FpWpGSB/LOAaVCt/u4BCEFAS4VmDgy9/E4Uzo3JNjdRFscIq5XMhk05HV5cRQLAme
	 kXiRcw6iNXfrYwRWgooc9o2lJWCFkqrH3wEmya7PLpHbb7nDY/RGO3WFnG3Tobd2K4
	 i8Z8LFEEJSZiXvHBoroEBkA7NXAycZ5SFj/yJUMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Brian Masney <bmasney@redhat.com>,
	Claudiu Beznea <claudiu.beznea@tuxon.dev>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 422/641] clk: microchip: core: remove duplicate determine_rate on pic32_sclk_ops
Date: Tue, 24 Feb 2026 17:22:28 -0800
Message-ID: <20260225012358.776190243@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit d93faac66dc04650d924f8f9584216d14f48fb14 ]

pic32_sclk_ops previously had a sclk_round_rate() member, and this was
recently converted over to sclk_determine_rate() with the help of a
Coccinelle semantic patch. pic32_sclk_ops now has two conflicting
determine_rate ops members.

Prior to the conversion, pic32_sclk_ops already had a determine_rate
member that points to __clk_mux_determine_rate(). When both the
round_rate() and determine_rate() ops are defined, the clk core only
uses the determine_rate() op. Let's go ahead and drop the recently
converted sclk_determine_rate() to match the previous functionality
prior to the conversion.

Fixes: e9f039c08cdc ("clk: microchip: core: convert from round_rate() to determine_rate()")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202511222115.uvHrP95A-lkp@intel.com/
Signed-off-by: Brian Masney <bmasney@redhat.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Link: https://lore.kernel.org/r/20251205-clk-microchip-fixes-v3-1-a02190705e47@redhat.com
Signed-off-by: Claudiu Beznea <claudiu.beznea@tuxon.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/microchip/clk-core.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/clk/microchip/clk-core.c b/drivers/clk/microchip/clk-core.c
index b34348d491f3e..a0163441dfe5c 100644
--- a/drivers/clk/microchip/clk-core.c
+++ b/drivers/clk/microchip/clk-core.c
@@ -780,15 +780,6 @@ static unsigned long sclk_get_rate(struct clk_hw *hw, unsigned long parent_rate)
 	return parent_rate / div;
 }
 
-static int sclk_determine_rate(struct clk_hw *hw,
-			       struct clk_rate_request *req)
-{
-	req->rate = calc_best_divided_rate(req->rate, req->best_parent_rate,
-					   SLEW_SYSDIV, 1);
-
-	return 0;
-}
-
 static int sclk_set_rate(struct clk_hw *hw,
 			 unsigned long rate, unsigned long parent_rate)
 {
@@ -912,7 +903,6 @@ static int sclk_init(struct clk_hw *hw)
 const struct clk_ops pic32_sclk_ops = {
 	.get_parent	= sclk_get_parent,
 	.set_parent	= sclk_set_parent,
-	.determine_rate = sclk_determine_rate,
 	.set_rate	= sclk_set_rate,
 	.recalc_rate	= sclk_get_rate,
 	.init		= sclk_init,
-- 
2.51.0



