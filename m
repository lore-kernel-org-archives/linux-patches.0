Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A32133B27C9;
	Sat, 12 Sep 2026 18:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789238177; cv=none; b=vA8ngXsuuVTEAqjkQ+WYjK4EZtcahlke31Q/eW26qhAIGRLVmWE4hkIkudpapTZ1tE1p0ul357us4eUEsal+7OwNUiDMVtF24FV0icm1IBZYcA4jituhEz+JnAfw+M7d7TtxQWOjvOjiq+P9ek1tmsakbEu2pkNL4maKnuRx+DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789238177; c=relaxed/simple;
	bh=MyLwk+FlC4FeShGBU1S/lX5NBO/isriLd7+PHYaO10U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uBXzW/c7pjaHtNT7T16ki/srmdUsVhAlvzKGvZm1Bn18dT0BjKaginrlg4VpNYim2ImDSTERN52ZpgPXFi18/hP1Fns/bC+rpWo9Nh7luRN7L3PO4E8aXi5PWQJfNYZVayO1tHkWBwXaq3ySxUi0IIHIfYmFCtjdJqxYs5Dm9y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AzF/+MN3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AzF/+MN3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD0A01F000FF;
	Sat, 12 Sep 2026 18:36:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789238173;
	bh=OcdhL4JJuUnU4p2Nq+XNAvRzaDpTR5UOC/CMNQh5KAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AzF/+MN3Wbgj4jzjAltrbICoCEkRoLmfSOQqqO6Q5SzqGcreX35eIASFbStp+7dvB
	 t834/wVJTHResRJAK/OGJNdY9ByfJX7jIdvTW86AKsIIVOLbySHjoTj6hpHHiidhgg
	 3KqIW6ThL3nkQj0S8aJEjhUzB+2Hr7Rt8pu8jHYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 409/935] clk: imx: scu: drop redundant init.ops variable assignment
Date: Sat, 12 Sep 2026 08:57:19 +0200
Message-ID: <20260912065536.203977105@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 7e2b09f7bbc50..e39d7cc9a4bd6 100644
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



