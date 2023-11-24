Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6EB2EAEA;
	Fri, 24 Nov 2023 18:52:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOjEbuZn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CEF5C433C8;
	Fri, 24 Nov 2023 18:52:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851969;
	bh=IIaPBeo0L/u1tbHxkRyMS5ljH8fXM9LoAnVlbLtwJiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOjEbuZnYBhSgLtbfEE7pJxIqSarYMAIFxuIjGojFt3HgK1ZmYzxJdPJfz6qxR0ts
	 xE5Sk0IhZRe7+NDA74AT47zt0TQudIvsbRdAhfeGe6Z6V9+su9TmRJk3nsYMYUX2wM
	 ocatK6ijyNoLjXT+v1qYcIO5oXu+SsC3L6KxhgOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Linus Walleij <linus.walleij@linaro.org>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 142/372] net: ethernet: cortina: Fix max RX frame define
Date: Fri, 24 Nov 2023 17:48:49 +0000
Message-ID: <20231124172015.215026541@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 510e35fb931ffc3b100e5d5ae4595cd3beca9f1a ]

Enumerator 3 is 1548 bytes according to the datasheet.
Not 1542.

Fixes: 4d5ae32f5e1e ("net: ethernet: Add a driver for Gemini gigabit ethernet")
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://lore.kernel.org/r/20231109-gemini-largeframe-fix-v4-1-6e611528db08@linaro.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cortina/gemini.c | 4 ++--
 drivers/net/ethernet/cortina/gemini.h | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/cortina/gemini.c b/drivers/net/ethernet/cortina/gemini.c
index fdf10318758b4..15a0a39cc33c1 100644
--- a/drivers/net/ethernet/cortina/gemini.c
+++ b/drivers/net/ethernet/cortina/gemini.c
@@ -432,8 +432,8 @@ static const struct gmac_max_framelen gmac_maxlens[] = {
 		.val = CONFIG0_MAXLEN_1536,
 	},
 	{
-		.max_l3_len = 1542,
-		.val = CONFIG0_MAXLEN_1542,
+		.max_l3_len = 1548,
+		.val = CONFIG0_MAXLEN_1548,
 	},
 	{
 		.max_l3_len = 9212,
diff --git a/drivers/net/ethernet/cortina/gemini.h b/drivers/net/ethernet/cortina/gemini.h
index 9fdf77d5eb374..99efb11557436 100644
--- a/drivers/net/ethernet/cortina/gemini.h
+++ b/drivers/net/ethernet/cortina/gemini.h
@@ -787,7 +787,7 @@ union gmac_config0 {
 #define  CONFIG0_MAXLEN_1536	0
 #define  CONFIG0_MAXLEN_1518	1
 #define  CONFIG0_MAXLEN_1522	2
-#define  CONFIG0_MAXLEN_1542	3
+#define  CONFIG0_MAXLEN_1548	3
 #define  CONFIG0_MAXLEN_9k	4	/* 9212 */
 #define  CONFIG0_MAXLEN_10k	5	/* 10236 */
 #define  CONFIG0_MAXLEN_1518__6	6
-- 
2.42.0



