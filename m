Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F01A1757EA;
	Sat, 12 Sep 2026 19:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242281; cv=none; b=Vt4ltiPefWTU/Y8Up58DFyxgvfH4437BOP2Y5vDErOLC56G9FTIopJFFlC0PX+C36Ig2/EtrmjfSdtep/df8T6Tj6Glks6KESSKX1WohtCuSpYVcsNCzZKxwCyUe/m5jULKqhIhY45vWwJr1/L8ASWyLapbmDX5OaqgvTpYV9Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242281; c=relaxed/simple;
	bh=yNRDOXklx8aKoZhTT2q+miMgIQcBkjfZ2+VSed7KBio=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nh6f+GK72Pmd9QMXdr4UPf6Csqa5+EqlDH3AWzA9oCKeC7oUlnvv2MWXSHGGnatqC+9R6RLY3P0qqDgsJVaDwBGoiG2DfbI1rFEbW+hJg7xWcFpvWcd/PeTSfdn93wd48+LlVxsChT5HiOaKEIVpqm538JWVI7Moil3PXmcrLog=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uvg37BfA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uvg37BfA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585D11F000FF;
	Sat, 12 Sep 2026 19:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242279;
	bh=8UgfFkLwuYDPTAhBSIdHcX7Cg1kF0hIqIg4j5lnL21g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uvg37BfAEyYwfOXrEG7OSuuuQrkGgHZzoO6IP4EhlaH0Nldtd8BMxMeUecchTz095
	 1Knkw42sY4JhGCGGBm/cSJ77m1wukocpbJNvRdZNzyVlDPLL2TiDp/ui9tzCg5s6XB
	 DqoIKHaLNTZ5yI1rDoGdhkBic9bfz0bynrGQwO1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 350/798] clk: imx: scu: drop redundant init.ops variable assignment
Date: Sat, 12 Sep 2026 08:59:38 +0200
Message-ID: <20260912065525.182482347@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Masney <bmasney@redhat.com>

[ Upstream commit 5f2db1ce201216e81333ecc2ab51494410b2fe0d ]

The init.ops is assigned a default value, however right below it is an
if, else if, and else where all of them also assign a value to init.ops.
Drop the redundant init.ops assignment at the top.

Fixes: 3b9ea606cda53 ("clk: imx: scu: add cpu frequency scaling support")
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Brian Masney <bmasney@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-scu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index 662af67e6870b..da5292d3050cf 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -362,7 +362,6 @@ struct clk_hw *__imx_clk_scu(const char *name, const char * const *parents,
 	clk->clk_type = clk_type;
 
 	init.name = name;
-	init.ops = &clk_scu_ops;
 	if (rsrc_id == IMX_SC_R_A35 || rsrc_id == IMX_SC_R_A53 || rsrc_id == IMX_SC_R_A72)
 		init.ops = &clk_scu_cpu_ops;
 	else
-- 
2.53.0



