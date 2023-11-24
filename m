Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837BD2C87B;
	Fri, 24 Nov 2023 18:57:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A0x3gYz0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10174C433C7;
	Fri, 24 Nov 2023 18:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700852266;
	bh=Czh9FNdNN8BqurtTGUUYoVnCMdGB4ihBSSNmjfFkpzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A0x3gYz0RQMzqAMI31Ka626N98rIaVCB7xGNTwKsZokJZ7kB7ZYgLu9trSIo6mkhP
	 xch4Vkiz5DYiXdEYRUdbYQN3EFIiEBHp7+VBUEK/pY9/5TFNfOQiBOrqJjRjBD/svv
	 IXJKzzx4LqbJZOHeIRrGJSaqKYaBhanTrDaY0mmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dario Binacchi <dario.binacchi@amarulasolutions.com>,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 287/372] clk: visconti: remove unused visconti_pll_provider::regmap
Date: Fri, 24 Nov 2023 17:51:14 +0000
Message-ID: <20231124172019.989239191@linuxfoundation.org>
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

From: Dario Binacchi <dario.binacchi@amarulasolutions.com>

[ Upstream commit 7e626a080bb2db47c27c29fea569ff18afec52ed ]

Field regmap of struct visconti_pll_provider is never used. Remove it.

Signed-off-by: Dario Binacchi <dario.binacchi@amarulasolutions.com>

Link: https://lore.kernel.org/r/20230302205028.2539197-1-dario.binacchi@amarulasolutions.com
Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: 5ad1e217a2b2 ("clk: visconti: Fix undefined behavior bug in struct visconti_pll_provider")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/visconti/pll.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/visconti/pll.h b/drivers/clk/visconti/pll.h
index 16dae35ab3701..01d07f1bf01b1 100644
--- a/drivers/clk/visconti/pll.h
+++ b/drivers/clk/visconti/pll.h
@@ -15,7 +15,6 @@
 
 struct visconti_pll_provider {
 	void __iomem *reg_base;
-	struct regmap *regmap;
 	struct clk_hw_onecell_data clk_data;
 	struct device_node *node;
 };
-- 
2.42.0



