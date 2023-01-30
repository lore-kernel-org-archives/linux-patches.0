Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F7328EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 13:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADBB0C4339E;
	Mon, 30 Jan 2023 13:54:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675086866;
	bh=QLX6WgW1wIuVM837j38lDg2WUtVYMLuCnvNM1srsRJk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mMreGxq4fbpfAqf+z5fkDPQcK7NmGxUwFUY5qEOVCsgVbVr04Lxq2H/OYtLA2PcUc
	 JwIhC16Snb7Nd/NKp55+KtVmcTlG/2c+Q70Jrcdfuk+1mhEW0RJBohH7ox9S8+JkvV
	 kvqNbYr1JSkk78ec5qe/GTdXPnOq43+QQGJovPXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 023/313] soc: imx8m: Fix incorrect check for of_clk_get_by_name()
Date: Mon, 30 Jan 2023 14:47:38 +0100
Message-Id: <20230130134337.742351272@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 490748874ebf1875420fc29b335bba2075dd1b5e ]

of_clk_get_by_name() returns error pointers instead of NULL.
Use IS_ERR() checks the return value to catch errors.

Fixes: 836fb30949d9 ("soc: imx8m: Enable OCOTP clock before reading the register")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/soc-imx8m.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/imx/soc-imx8m.c b/drivers/soc/imx/soc-imx8m.c
index 28144c699b0c..32ed9dc88e45 100644
--- a/drivers/soc/imx/soc-imx8m.c
+++ b/drivers/soc/imx/soc-imx8m.c
@@ -66,8 +66,8 @@ static u32 __init imx8mq_soc_revision(void)
 	ocotp_base = of_iomap(np, 0);
 	WARN_ON(!ocotp_base);
 	clk = of_clk_get_by_name(np, NULL);
-	if (!clk) {
-		WARN_ON(!clk);
+	if (IS_ERR(clk)) {
+		WARN_ON(IS_ERR(clk));
 		return 0;
 	}
 
-- 
2.39.0



