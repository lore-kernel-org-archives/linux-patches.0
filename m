Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441708F74
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73C9BC433C7;
	Sun, 16 Jul 2023 20:12:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689538355;
	bh=lac43nt4VhypJ8QK9647SIZVjuHH+iwwq1YKYujFV7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAniNtbMFk0ziy4Dze9DkASRWDerSYLEZDnEM7x8i+Ldst6YPubwSmndpTOWzCo+4
	 2LzFVFYRuCCyVX1oUaQCBji0WXk6inkJWMEgd2hwVlauYlMVohBy7lA+VwY6BUx+Aq
	 t1FGLfS92iqczupxXNlFxmnsxnDtmI69Z79gpfVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claudiu Beznea <claudiu.beznea@microchip.com>,
	Tony Lindgren <tony@atomide.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 421/800] clk: keystone: sci-clk: check return value of kasprintf()
Date: Sun, 16 Jul 2023 21:44:34 +0200
Message-ID: <20230716194958.868616323@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
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
index 910ecd58c4ca2..6c1df4f11536d 100644
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



