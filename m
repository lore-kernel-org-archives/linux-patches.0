Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B00E43AC05
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:31:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBAB0C433C7;
	Wed, 20 Sep 2023 12:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695213078;
	bh=JwWuinwS7oTEdT2lxTSWLqTHG1xnsghUZalKY4FstPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n8devEes+hfb2paZONJvu0bDpPOfB/dm4JsyYzTZVm/kp03KugwS/7yCrmEOLqc63
	 pu0XKmLCI+kitgYtiOaOXuI36eJfOEApQ4eiFh12gwlm9+JS9DZQTz/ekiwU6NmzUw
	 kCl51RLXL9e3DKGOb1MtFDiN2pVzHkvjokZtKxz8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjie Du <duminjie@vivo.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 127/367] drivers: clk: keystone: Fix parameter judgment in _of_pll_clk_init()
Date: Wed, 20 Sep 2023 13:28:24 +0200
Message-ID: <20230920112901.961886326@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112858.471730572@linuxfoundation.org>
References: <20230920112858.471730572@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Minjie Du <duminjie@vivo.com>

[ Upstream commit a995c50db887ef97f3160775aef7d772635a6f6e ]

The function clk_register_pll() may return NULL or an ERR_PTR. Don't
treat an ERR_PTR as valid.

Signed-off-by: Minjie Du <duminjie@vivo.com>
Link: https://lore.kernel.org/r/20230712102246.10348-1-duminjie@vivo.com
Fixes: b9e0d40c0d83 ("clk: keystone: add Keystone PLL clock driver")
[sboyd@kernel.org: Reword commit text]
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/keystone/pll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/keystone/pll.c b/drivers/clk/keystone/pll.c
index d59a7621bb204..ee5c72369334f 100644
--- a/drivers/clk/keystone/pll.c
+++ b/drivers/clk/keystone/pll.c
@@ -209,7 +209,7 @@ static void __init _of_pll_clk_init(struct device_node *node, bool pllctrl)
 	}
 
 	clk = clk_register_pll(NULL, node->name, parent_name, pll_data);
-	if (clk) {
+	if (!IS_ERR_OR_NULL(clk)) {
 		of_clk_add_provider(node, of_clk_src_simple_get, clk);
 		return;
 	}
-- 
2.40.1



