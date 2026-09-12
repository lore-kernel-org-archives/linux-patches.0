Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99B2C35C6B2;
	Sat, 12 Sep 2026 09:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789206184; cv=none; b=k1TEJ6ldWW3CKqg6HkAlPZW1/z8HsIOr8yoqg7vfYCQpvngX9VE/ilS7ZJPb7MsxB5YtSHaPK5rokey20z9WfzC2VIhO0G4DaXy701H17/12JRQ2fXXANvRX+SA3UC7Tx0+zUdBCgjSoqbj84Jsycc+Q98hX/YNEzl2QvFGMhJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789206184; c=relaxed/simple;
	bh=wtOb25hAGrJ3wmpjUqXc5fe5BYBJsbVS0TtrU/R7xs0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VUSiLh2SL231fHmfG3EVf5v47OXc4xV86VxKSDZJUqCCDReHM4FHgHlVF6JeI5OhJcDGqAvPHM3TCq2jx1vuG7rUH7c7/+pgLX6swq/IRMqvwNH0eepuMfnATZ22StnVEpW0nBbT1FOiE7jLADMbGtz5zdQ6v4cvuapD9S1AnTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWCUg4FS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWCUg4FS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97C701F000FF;
	Sat, 12 Sep 2026 09:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789206183;
	bh=ioVhp6v8osXAj0tSnLc1L6JlNkEA++tuM+PLNPIh6uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WWCUg4FSyysYzUlp3sB8+goDRBSFOHJWNCGkSaHwZZD7Ng3rwala07MV6KlQfKPMF
	 DFGWMEi65VsFNy+aT3qSTuZ+k7N4coBeAwsq/uuIcmlWfzbFFBfAX3zHDbtT6bKSFv
	 68TFT5wW75p5XllO3snoKhD/gs2p+UVssLjDkXac=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0138/1518] clk: imx: scu: drop redundant init.ops variable assignment
Date: Sat, 12 Sep 2026 08:38:27 +0200
Message-ID: <20260912065626.616283528@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index c03f7821824d1..b2b0e5f05b238 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -465,7 +465,6 @@ struct clk_hw *__imx_clk_scu(struct device *dev, const char *name,
 	clk->clk_type = clk_type;
 
 	init.name = name;
-	init.ops = &clk_scu_ops;
 	if (rsrc_id == IMX_SC_R_A35 || rsrc_id == IMX_SC_R_A53 || rsrc_id == IMX_SC_R_A72)
 		init.ops = &clk_scu_cpu_ops;
 	else if (rsrc_id == IMX_SC_R_PI_0_PLL)
-- 
2.53.0



