Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B3608F57
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:43:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1332C433C7;
	Sun, 16 Jul 2023 20:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689540195;
	bh=pm1L9YGMsJGm2ixjsVM96woEy1RUWaTCNgFMYFSc6qk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x89zLCXatJfoX0nLfPcCAmDnbxNvksPohc8pygS1z6YCvSoJAJ1dw98XOV8ObtDtJ
	 W/kz8AXyOlWPbkXQR6L7tt8fxGwO+V1mSRMQPB4LegW/EAbtmA4qU32z7Ri8wAKFPh
	 t5G6Rqx0Buy1Fyqy+sz8w4jgf1fZljz6sTNMdO10=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Tony Lindgren <tony@atomide.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 276/591] clk: keystone: sci-clk: check return value of kasprintf()
Date: Sun, 16 Jul 2023 21:46:55 +0200
Message-ID: <20230716194931.036896843@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit b73ed981da6d25c921aaefa7ca3df85bbd85b7fc ]

kasprintf() returns a pointer to dynamically allocated memory.
Pointer could be NULL in case allocation fails. Check pointer validity.
Identified with coccinelle (kmerr.cocci script).

Fixes: b745c0794e2f ("clk: keystone: Add sci-clk driver support")
Depends-on: 96488c09b0f4 ("clk: keystone: sci-clk: cut down the clock name length")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20230530093913.1656095-7-claudiu.beznea@microchip.com
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/keystone/sci-clk.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/clk/keystone/sci-clk.c b/drivers/clk/keystone/sci-clk.c
index d4b4e74e22da6..254f2cf24be21 100644
--- a/drivers/clk/keystone/sci-clk.c
+++ b/drivers/clk/keystone/sci-clk.c
@@ -294,6 +294,8 @@ static int _sci_clk_build(struct sci_clk_provider *provider,
 
 	name = kasprintf(GFP_KERNEL, "clk:%d:%d", sci_clk->dev_id,
 			 sci_clk->clk_id);
+	if (!name)
+		return -ENOMEM;
 
 	init.name = name;
 
-- 
2.39.2



