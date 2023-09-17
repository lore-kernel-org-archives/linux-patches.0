Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3295E6FA7
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 19:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28998C433CC;
	Sun, 17 Sep 2023 19:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694979037;
	bh=FPayj7PCdiwfGTVRY0vbhECxo2m5YHs4nNDi2AhiXk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wEnCS0eRVc9GM+sQ34CDnuUVk9gn02G/gSlkMAbW6bjzTZOOVsrjsrzihD9zw3Yky
	 lBcyauwGzK8NDFzML3eYg+shkvcBRptbw9Q/WEuC2jqVlZh6t7h+vsKSQ8x9fGm2xH
	 BGkAjTiuO36rYRj2ahuX4UuDuxzTgstSBGDxKSG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Minjie Du <duminjie@vivo.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 171/406] drivers: clk: keystone: Fix parameter judgment in _of_pll_clk_init()
Date: Sun, 17 Sep 2023 21:10:25 +0200
Message-ID: <20230917191105.701077230@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



