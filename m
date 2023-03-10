Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43D3846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40117C433EF;
	Fri, 10 Mar 2023 14:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458908;
	bh=SN17yhwHimO7JkDWEsgkh/QkmuX9cZvgy1sK2bZejzE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gWYLvw6UcyXLmd444dl2SztuTMAizEsUULCiRda5EzO5/B0w6EHc2RInCJ3osi8Jj
	 isdqsdHIhkCwCuOVpmSruuYV0f56BLu3Pu6iuXsxlg+49+3moYcUXYyJcL8VQytTJG
	 jRhvgj2zkp3mdLTNKEgnY1FYFoGp6rRrSjPvMp3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 153/357] clk: renesas: cpg-mssr: Remove superfluous check in resume code
Date: Fri, 10 Mar 2023 14:37:22 +0100
Message-Id: <20230310133741.469445179@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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
index fd9ca86cc60f6..d0ccb52b02703 100644
--- a/drivers/clk/renesas/renesas-cpg-mssr.c
+++ b/drivers/clk/renesas/renesas-cpg-mssr.c
@@ -862,9 +862,8 @@ static int cpg_mssr_resume_noirq(struct device *dev)
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



