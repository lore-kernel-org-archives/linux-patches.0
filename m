Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FD9F349AF9;
	Tue, 16 Dec 2025 11:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885708; cv=none; b=rGIXL77Y+NssXGikufjhzFlUsBZvKH6Eq3H6hcf2wDD5hy24kuo/c5PAfvoGySrSPZejE4D2EAf1DgIUBoEk/EF2nOe2yqKKWep8JTzxhvSaUjuafzXwcVO70qdA9DjPH0Xv3kvF2Bl+NXdr4yy6PHkJjo0cIeyTKDOMS6s6A2g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885708; c=relaxed/simple;
	bh=MFur9xIgTa7q9USgHSAsjs6kLmAVOTE6oizcHhVYsfA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIvZDsBQBsAOqtSfSzPuKyat++Ln+p9JggQR/nb9vr4MpA7XEJ9CzmeNTeiNktrIFLUevD6uBUH4joEeMrkxR4CQr+15pd8vT9H7CtWDJjEGFCqWMok+M6GbgeyXtsBGfF7dgQFOUTqwYd/5PlOYsWRCcGvlTpcWFf5XmNV7g7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OhRFCuc+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OhRFCuc+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D80AC4CEF1;
	Tue, 16 Dec 2025 11:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885707;
	bh=MFur9xIgTa7q9USgHSAsjs6kLmAVOTE6oizcHhVYsfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OhRFCuc+Mg9Eh+w9PEDCbi/oAn/okQxsOh4wHD9z1aahlt+f71q561MUWHatRurfa
	 LkkHF3JGoP6AeaFtI5miMm7y9P59uBEFxD9smMcV7XtbXX0Y8tPKKLUYN3gCpRDSeM
	 kNlxTz1jlp1gLUBk4vmkYvbA81kqsGPcM29rehhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 221/507] clk: renesas: r9a09g077: Propagate rate changes to parent clocks
Date: Tue, 16 Dec 2025 12:11:02 +0100
Message-ID: <20251216111353.513265468@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index c920d6a9707f1..c8c28909ed9db 100644
--- a/drivers/clk/renesas/r9a09g077-cpg.c
+++ b/drivers/clk/renesas/r9a09g077-cpg.c
@@ -178,7 +178,7 @@ r9a09g077_cpg_div_clk_register(struct device *dev,
 
 	if (core->dtable)
 		clk_hw = clk_hw_register_divider_table(dev, core->name,
-						       parent_name, 0,
+						       parent_name, CLK_SET_RATE_PARENT,
 						       addr,
 						       GET_SHIFT(core->conf),
 						       GET_WIDTH(core->conf),
@@ -187,7 +187,7 @@ r9a09g077_cpg_div_clk_register(struct device *dev,
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



