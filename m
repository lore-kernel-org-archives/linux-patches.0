Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95D0E30D3F6;
	Sat, 12 Sep 2026 14:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222655; cv=none; b=fF7XWTeR59d1lUG+EA55SlKCnJ1D14ZwDvFEVQh3l/3eezEehZ68DIp6I/EmTfwnO5z1r886QqBAKfNDqFFoa0j+EfqfYvIiTESHNdd+nhei6Qi2MDx3N1Oiqd6OY4Ft74mjQeJg+5lotk66PEwuTJRRoeNwlglv1mDLDzFRowk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222655; c=relaxed/simple;
	bh=wbrp/GN60YwfPibPHRdhCvr9mcOSPyTAHJX4a4/SJJo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GRZVCGGt3B7UjB2JknegfybQc1VD49klg1474/CyyOwKM0IL0Ec8Plz3bDsh7walTeYuZYv5zbCtebftNoEVWHB+c0etm8vtBWgWnDjIqxGa/td3Eor65dkKf5EKpjKsyQN1n2JIKuTOLuof66gmQimyuRVnAO3wSV9epcCOfRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bi1eCN0Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bi1eCN0Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 641121F000FF;
	Sat, 12 Sep 2026 14:17:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222652;
	bh=UvgPCCYCiL0X4PvuVkbG1YjT/yWPQKDBXY5oBUmeN/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bi1eCN0YZN+Io5cpIDtJG6dqv8cnlcEHXmvupiDIRjrXyWuo0ha44F8UAoGBpNf+l
	 D+H9FMTJTfMaWB3bkcwlSSQTvl5walorE4XR+4cVEWGoWVh5o4gX0EzPXXNZnL/ZVQ
	 qtkKCDmYalGkTjHXiZ5qs6+P3H59daz91dmFrt6E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0587/1424] clk: imx: scu: drop redundant init.ops variable assignment
Date: Sat, 12 Sep 2026 08:50:19 +0200
Message-ID: <20260912065620.437593726@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 3a68576cdae76..0156cd38b6fbd 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -481,7 +481,6 @@ struct clk_hw *__imx_clk_scu(struct device *dev, const char *name,
 	clk->clk_type = clk_type;
 
 	init.name = name;
-	init.ops = &clk_scu_ops;
 	if (rsrc_id == IMX_SC_R_A35 || rsrc_id == IMX_SC_R_A53 || rsrc_id == IMX_SC_R_A72)
 		init.ops = &clk_scu_cpu_ops;
 	else if (rsrc_id == IMX_SC_R_PI_0_PLL)
-- 
2.53.0



