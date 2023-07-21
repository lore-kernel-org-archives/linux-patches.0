Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C111F94B
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 18:59:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BBABC433C8;
	Fri, 21 Jul 2023 18:59:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689965995;
	bh=wYsvYhIFjM65snVvFsIH7HxgI7PwN/tO3zCks3y+w/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGFq5u4g1A1eUCKUkBAyYvgnpzoKRWqqsqPtKIZFJLTUzKyMCcumFcPxPPSX+SGxr
	 PlZ/PVUFJ0uzsf22oY+f7tX1qslCkaiZSU7ME9iBYBgtgJUWwCI80IdFuQ/rnCuhuo
	 DoSCJcgNRguG5tEUnO95kurAFeAwhFviEh722qzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Tony Lindgren <tony@atomide.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 187/532] clk: keystone: sci-clk: check return value of kasprintf()
Date: Fri, 21 Jul 2023 18:01:31 +0200
Message-ID: <20230721160624.539461519@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
References: <20230721160614.695323302@linuxfoundation.org>
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
index 7e1b136e71ae0..8af2a9faa805a 100644
--- a/drivers/clk/keystone/sci-clk.c
+++ b/drivers/clk/keystone/sci-clk.c
@@ -302,6 +302,8 @@ static int _sci_clk_build(struct sci_clk_provider *provider,
 
 	name = kasprintf(GFP_KERNEL, "clk:%d:%d", sci_clk->dev_id,
 			 sci_clk->clk_id);
+	if (!name)
+		return -ENOMEM;
 
 	init.name = name;
 
-- 
2.39.2



