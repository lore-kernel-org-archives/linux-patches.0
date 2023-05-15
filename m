Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8331772F
	for <patches@lists.linux.dev>; Mon, 15 May 2023 18:01:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E384C433D2;
	Mon, 15 May 2023 18:01:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684173695;
	bh=QehvCbMjagv55QDAycAmh7zqbozsS+XskjwsVCL8j4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Dt2yORCVp8waDEHP/chBdszvVijJ4bXpqmnsrotHF2kgQGR8ortHMa0Xz8p3oHhD1
	 /jF5iwta1BpVcLKB299U/oUghO4ed2DHYZ8o+eTilQBXSu8+klXMtf6vsTqvb4K9vX
	 qPAfBdy606qx+Y4BfNQaj2uVkHI/H2fQftNUpiAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Daniel Lezcano <daniel.lezcano@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 178/282] clocksource: davinci: axe a pointless __GFP_NOFAIL
Date: Mon, 15 May 2023 18:29:16 +0200
Message-Id: <20230515161727.614144942@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161722.146344674@linuxfoundation.org>
References: <20230515161722.146344674@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 4855f2bd91b6e3461af7d795bfe9a40420122131 ]

There is no need to specify __GFP_NOFAIL when allocating memory here, so
axe it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
Link: https://lore.kernel.org/r/20200409101226.15432-1-christophe.jaillet@wanadoo.fr
Stable-dep-of: fb73556386e0 ("clocksource/drivers/davinci: Fix memory leak in davinci_timer_register when init fails")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clocksource/timer-davinci.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clocksource/timer-davinci.c b/drivers/clocksource/timer-davinci.c
index aae9383682303..bb4eee31ae082 100644
--- a/drivers/clocksource/timer-davinci.c
+++ b/drivers/clocksource/timer-davinci.c
@@ -270,7 +270,7 @@ int __init davinci_timer_register(struct clk *clk,
 	davinci_timer_init(base);
 	tick_rate = clk_get_rate(clk);
 
-	clockevent = kzalloc(sizeof(*clockevent), GFP_KERNEL | __GFP_NOFAIL);
+	clockevent = kzalloc(sizeof(*clockevent), GFP_KERNEL);
 	if (!clockevent)
 		return -ENOMEM;
 
-- 
2.39.2



