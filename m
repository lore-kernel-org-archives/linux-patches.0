Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BDF435F61E;
	Sat, 12 Sep 2026 07:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789197271; cv=none; b=RNQX1614OBee5E4y8wbIp7ydMUGHJtL/g6MhlCvo3iP9KfwDxxMODd0i7IT10xSY6XWESPI8pG/pFXxxKzSMJ4h+5p75Ig7ul9KmyW16IevLWlpr/CRNRSVv4OhWAcgPG/J0eK+8BmtMnMElqGUZckiV21xFdE/2jb/UKrtCEeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789197271; c=relaxed/simple;
	bh=qCs6fKJJlhXAKnQJWbgINfGCdkzNBSR2h7cU8lUAsr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TGsSNvfaorpzqG7LqbLe5Bkk8MUegeDl1/IRbdZTbnYL8uDCRG6AdgH81ssC80xYk0ymVgqWSDjBdeupMeX8wFCB3qmRBuKSJDs9aMyKepbJ6lUaUh6NB2eWLJJkwCYgkKuS42xY8WMQXfiSKT4lIJrUSSZw+2MAZesTxsZaDsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rckkDrX8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rckkDrX8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A4411F000FF;
	Sat, 12 Sep 2026 07:14:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789197270;
	bh=/qNMjjTV03bB0VhH1edk6ULnd/0oyRkHhh/x3nhWd4k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rckkDrX86RvQpZOzImpDRjAjjeEZ2BW9N9Uls8J2QR2+7Lm2HownC5ylQdXff8rwN
	 E8hBgpgTTvDGKuHtAwtMxRjX2fPT1ySf1VlhhxC6JwH+PN6x8kUPGLgvX0ths5OKgz
	 mROpX6B5s32SRBeaUfDvpdQMMTVlcOY0+SoJYAQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Fan <peng.fan@nxp.com>,
	Brian Masney <bmasney@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0097/1815] clk: imx: scu: drop redundant init.ops variable assignment
Date: Sat, 12 Sep 2026 08:30:47 +0200
Message-ID: <20260912065651.287021299@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 9b33df9967ece..658b6d94de9b4 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -475,7 +475,6 @@ struct clk_hw *__imx_clk_scu(struct device *dev, const char *name,
 	clk->clk_type = clk_type;
 
 	init.name = name;
-	init.ops = &clk_scu_ops;
 	if (rsrc_id == IMX_SC_R_A35 || rsrc_id == IMX_SC_R_A53 || rsrc_id == IMX_SC_R_A72)
 		init.ops = &clk_scu_cpu_ops;
 	else if (rsrc_id == IMX_SC_R_PI_0_PLL)
-- 
2.53.0



