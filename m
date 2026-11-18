Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033707;
	b=vlyok4iHOYonhS0CBXFeGEt0dUdZdhJkWLgvjjnynToV4jqGCEG2XIm/cLMT0RcxEopP
	 Uy/77Sf4mrqqR/68r73yqKpbL6kbwWH1iBlUIksao1FgeKq1fkRuSu9GXpu9F6yU1W5Og
	 1z2N8F4PGXNxpA3cQ3yk/ivkrn5MQ22XeRX82GxJnaLl9FZv7nyobTJeFKLYGDgfajw2k
	 X2l2d8zYgshwdX1TDa4S4O0pulZ+St60Ai0QBAYZe5612NoBCVmTt8czmm2gW7CxKR8yZ
	 YDfY7T7Ps4uNYXSNGdz5cjOSaqPDJFrxct+yNFnejlUicNlZ31swQK1CUsC3rM/HxjA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033707;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=JQb12e1WNkV+ZlvqokUx/sjvQ5rn2RpLzX8bfw01LPA=;
	b=Odsul0U0ZO9oTexBIipD9DRLZr/YfZRV4QekO/PR1UC2VStw3oLuahCuQMBmXxfpeieT
	 KXGvya04XAggsY+EhbFRNwpELQUbd1DNA5ldhabO9t4L0j7ZVSq7rC4++rhYM3ut19D32
	 o7fDS7TEuqbTllD3+H5hz6YFzlq8ILw2MHImD2QfPOcN57od+nZmLXIsf1Fn/Ql5audOG
	 7ReAKsk/07oFvYpkwwcMfmukLfF4nl68HtoLbSe9f84xdOkg7LBKsHnt6Rm8Qhxc6ALBz
	 aFrTfrQmNsTWPtK/WJ4CXGyS1fTb7Pos0Uw3V/EqvLPg29gDS+MQ0joODLtxjQ/eZYw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y17kjpW+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AABEB606A331;
	Wed, 18 Nov 2026 20:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y17kjpW+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07C171F000C4;
	Wed, 18 Nov 2026 20:28:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033707;
	bh=JQb12e1WNkV+ZlvqokUx/sjvQ5rn2RpLzX8bfw01LPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y17kjpW+I5yv2ZuOkrrRrmBEvOBfKw6ELGimhBH5PxfJJoOQNYwdAG+cQpWnK9I5Q
	 jfHNV7/Y+r60TZZzd3dlFnncxHGyg8UJ2/aP0kWE03dextdv+pA2BCDtne/QWF3ehk
	 awhCSoBG/QNqqiuTJHicF/+qkOBUcYVAStXGwTGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Chen-Yu Tsai <wens@kernel.org>,
	Jerome Brunet <jbrunet@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0073/3318] clk: sunxi-ng: fix ccu probe clock unregister on error
Date: Wed, 18 Nov 2026 15:11:35 +0100
Message-ID: <20261118150316.238492055@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Brunet <jbrunet@baylibre.com>

[ Upstream commit 81f4ddc9f7e0c11d3e9d24d0f30023845a02f7ee ]

When registering clocks with sunxi_ccu_probe(), the number of ccu_clocks
and the number of hw clocks might be different, eventhough they usually are
the same.

If they are different, it could lead to out-of-bound access or registered
clock left behind on error.

Use a different variable when iterating on hw clocks so every registered
clock, and only those, gets unregistered on error.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://lore.kernel.org/r/20260629131254.7E34C1F00A3A@smtp.kernel.org
Reviewed-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Jerome Brunet <jbrunet@baylibre.com>
Link: https://patch.msgid.link/20260706-a733-rtc-v4-3-f330728db3d3@baylibre.com
Signed-off-by: Chen-Yu Tsai <wens@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/sunxi-ng/ccu_common.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/clk/sunxi-ng/ccu_common.c b/drivers/clk/sunxi-ng/ccu_common.c
index be375ce0149c8..f797b50fef8b0 100644
--- a/drivers/clk/sunxi-ng/ccu_common.c
+++ b/drivers/clk/sunxi-ng/ccu_common.c
@@ -114,7 +114,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 			   const struct sunxi_ccu_desc *desc)
 {
 	struct ccu_reset *reset;
-	int i, ret;
+	int i, j, ret;
 
 	ccu->desc = desc;
 
@@ -130,8 +130,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		cclk->lock = &ccu->lock;
 	}
 
-	for (i = 0; i < desc->hw_clks->num ; i++) {
-		struct clk_hw *hw = desc->hw_clks->hws[i];
+	for (j = 0; j < desc->hw_clks->num ; j++) {
+		struct clk_hw *hw = desc->hw_clks->hws[j];
 		const char *name;
 
 		if (!hw)
@@ -143,7 +143,7 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 		else
 			ret = of_clk_hw_register(node, hw);
 		if (ret) {
-			pr_err("Couldn't register clock %d - %s\n", i, name);
+			pr_err("Couldn't register clock %d - %s\n", j, name);
 			goto err_clk_unreg;
 		}
 	}
@@ -186,8 +186,8 @@ static int sunxi_ccu_probe(struct sunxi_ccu *ccu, struct device *dev,
 err_del_provider:
 	of_clk_del_provider(node);
 err_clk_unreg:
-	while (--i >= 0) {
-		struct clk_hw *hw = desc->hw_clks->hws[i];
+	while (--j >= 0) {
+		struct clk_hw *hw = desc->hw_clks->hws[j];
 
 		if (!hw)
 			continue;
-- 
2.53.0



