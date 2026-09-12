Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97B3F38DC7F;
	Sat, 12 Sep 2026 16:02:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789228931; cv=none; b=F3lKqbwscMOiM6mU1QFs3H9hPyj+IaiSLK8apZYWvWRdGlngqUFiS8nUgX697G/dxYtDUtV97YZ8tNDOBfYOghgDUg9F2EvSOcJId01miI3XS/605XltyslddL/dhrExzwEJ08ly2v7tTlzW2kJuTDz6aX/T6rnHjijT2cQKUKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789228931; c=relaxed/simple;
	bh=3/lrrcCtArVOVh8R6tAJ3tqEkiGeQ9EQBoXAnXrYGtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TzbFeTx/OfgGegQN62f/ZaJNCoXYBC37xPxLarSys2qZ9Nn9ilblD+ajm0NfUEvl/Oe1wnBJz1tzxSGeOk2WgtH5/Sl8AyL0hMm0jpScooyYqBB8HMU2STV/r6L4jOPeFNi8TnhBkyUsGzmXwmxYJvyByEOVppLO/kWneWl9dMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9aIhE10; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9aIhE10"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D3F71F000FF;
	Sat, 12 Sep 2026 16:02:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789228930;
	bh=js7gytZJbSck7U15cCPXYAA7IQZqx38APojs4EUdeEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9aIhE10x9sV7yxRPFqNHMnuyUIEdqPkvyKKLkQ/w47oSlOcSsOmjnmR8jxPEq5cp
	 875jKBaUtSaC+4PxZpml5nVmuSXTI2R7gSRb8/vCcxwu1CiJzI3PVGkNnCJI9Nky/B
	 5IafFlJNjudDwef+8/xAQMbQD9x/I4NU+PrSj9TM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0486/1191] clk: imx: scu: drop redundant init.ops variable assignment
Date: Sat, 12 Sep 2026 08:53:34 +0200
Message-ID: <20260912065559.147353433@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index ec5afc7f2690b..1a63114ff8b84 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -464,7 +464,6 @@ struct clk_hw *__imx_clk_scu(struct device *dev, const char *name,
 	clk->clk_type = clk_type;
 
 	init.name = name;
-	init.ops = &clk_scu_ops;
 	if (rsrc_id == IMX_SC_R_A35 || rsrc_id == IMX_SC_R_A53 || rsrc_id == IMX_SC_R_A72)
 		init.ops = &clk_scu_cpu_ops;
 	else if (rsrc_id == IMX_SC_R_PI_0_PLL)
-- 
2.53.0



