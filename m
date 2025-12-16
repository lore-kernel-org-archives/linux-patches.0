Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8BE6343D90;
	Tue, 16 Dec 2025 12:18:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887539; cv=none; b=XkcmDsCwW60cnUcQYprtep3SnND65hYG83/QJjdrcPLMSv3Zuxgz/Hg9/wkZkgEUmudWU4a3cHTrVUefokD4BxHJzPo3gn7sH6YyuqNXFNP0WFMBHfIIvPkx895ssujQF6lvVCXXzSXFqCdEVYJG1CC97RCgfGBCRkN6OJJPMdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887539; c=relaxed/simple;
	bh=cltNZymdElDOFhhjQ/w2QZuQt1R+iIoajoAcMxIBPFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Du9W4TnuynzSu/xmhAtxgFD/ChEQNOPXUXJKDddRtRbS0gn8raJEj6dYAYcObj9c0t4FsSUGbdfDNwb9Xqnh5NO/cuTxLy9lc9nv1aJtmK2/L/iHIWos17hrfsR8qqDY20fnNV2V3Zi+jfgBrtHeLGDxEmR/8uKX8kHx+JXlTvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RmC1ah7Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RmC1ah7Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473EEC4CEF1;
	Tue, 16 Dec 2025 12:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887539;
	bh=cltNZymdElDOFhhjQ/w2QZuQt1R+iIoajoAcMxIBPFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RmC1ah7Qv0eoDAbOY6M2rkEpyArspbBPrt4QTk39L6tG0Cqu3SvWeA7XdBDqzpTH/
	 bdTA8BSIm+rSUfhqDO7+oYPbsxoHmR4YDzMiCrrmEtMnWaj4spdq2GLhXrmURchZ34
	 PCI1VzojNY/CP48ham3HhcSQH2y8dYeRv2A0JvZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 261/614] clk: renesas: r9a09g077: Propagate rate changes to parent clocks
Date: Tue, 16 Dec 2025 12:10:28 +0100
Message-ID: <20251216111410.829014431@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>

[ Upstream commit 145dfd70b9c70e5bc03494a7ce8fa3748ac01af3 ]

Add the CLK_SET_RATE_PARENT flag to divider clock registration so that rate
changes can propagate to parent clocks when needed. This allows the CPG
divider clocks to request rate adjustments from their parent, ensuring
correct frequency scaling and improved flexibility in clock rate selection.

Fixes: 065fe720eec6e ("clk: renesas: Add support for R9A09G077 SoC")
Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251028165127.991351-2-prabhakar.mahadev-lad.rj@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/renesas/r9a09g077-cpg.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/renesas/r9a09g077-cpg.c b/drivers/clk/renesas/r9a09g077-cpg.c
index af3ef6d58c87c..d12975418a568 100644
--- a/drivers/clk/renesas/r9a09g077-cpg.c
+++ b/drivers/clk/renesas/r9a09g077-cpg.c
@@ -217,7 +217,7 @@ r9a09g077_cpg_div_clk_register(struct device *dev,
 
 	if (core->dtable)
 		clk_hw = clk_hw_register_divider_table(dev, core->name,
-						       parent_name, 0,
+						       parent_name, CLK_SET_RATE_PARENT,
 						       addr,
 						       GET_SHIFT(core->conf),
 						       GET_WIDTH(core->conf),
@@ -226,7 +226,7 @@ r9a09g077_cpg_div_clk_register(struct device *dev,
 						       &pub->rmw_lock);
 	else
 		clk_hw = clk_hw_register_divider(dev, core->name,
-						 parent_name, 0,
+						 parent_name, CLK_SET_RATE_PARENT,
 						 addr,
 						 GET_SHIFT(core->conf),
 						 GET_WIDTH(core->conf),
-- 
2.51.0



