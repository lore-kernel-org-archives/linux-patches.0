Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48E478825
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:55:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81321C4339E;
	Fri, 10 Mar 2023 14:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460154;
	bh=GeG80GaLQQKMI609QvES8HS/eAOmNBKVwU+1dFgXW5I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YD0PmrBT2kN++BCnFc03RTxW9Ch9eHiHYzc7dxuiJr7r2OKDpEKVNtd5cHoH46cS
	 E6otv5ghlR7znoRmjdtx+PtGwpkKkPcRVRJg0Rdm+fufcbIZLANRvmDtpA1skt9oM5
	 1h+5mhEaiUMtmVNRHNyQTcFdjCHOaCP/YtxywBdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 240/529] clk: renesas: cpg-mssr: Remove superfluous check in resume code
Date: Fri, 10 Mar 2023 14:36:23 +0100
Message-Id: <20230310133816.103801636@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit 1c052043c79af5f70e80e2acd4dd70904ae08666 ]

When the code flow arrives at printing the error message in
cpg_mssr_resume_noirq(), we know for sure that we are not running on an
RZ/A Soc, as the code checked for that before.

Fixes: ace342097768e35f ("clk: renesas: cpg-mssr: Fix STBCR suspend/resume handling")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/r/144a3e66d748c0c17f3524ac8fa6ece5bf5b6f1e.1673425314.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/renesas-cpg-mssr.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/renesas/renesas-cpg-mssr.c b/drivers/clk/renesas/renesas-cpg-mssr.c
index 12e5a78819773..a5a68e1e75490 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -914,9 +914,8 @@ static int cpg_mssr_resume_noirq(struct device *dev)
 		}
 
 		if (!i)
-			dev_warn(dev, "Failed to enable %s%u[0x%x]\n",
-				 priv->reg_layout == CLK_REG_LAYOUT_RZ_A ?
-				 "STB" : "SMSTP", reg, oldval & mask);
+			dev_warn(dev, "Failed to enable SMSTP%u[0x%x]\n", reg,
+				 oldval & mask);
 	}
 
 	return 0;
-- 
2.39.2



