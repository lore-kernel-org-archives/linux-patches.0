Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F0032B125;
	Sat, 12 Sep 2026 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242278; cv=none; b=nT3bc2fXkVYbu4POXcARPsx7unxhxCDMHgqVETuFtkRxALj5ZuFZtRmeYbbPSh/GiWR1RXzOkyAZqoIHYYvSFmGi20uH/mxplpZBf/z77yIdCK51STPWOqonJpuLRMI2fcmr5kQevmHLoYKBFgJutdTCF+1HrhkUtjVaSEXDsn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242278; c=relaxed/simple;
	bh=irZVRsidwe7p+Y1Ikry4A8xP2nH7wVzsDqKdltfBYgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FAhZwl/vjRX5Str6bMAh84DGQmgjUG/tZ3S8RO9Q6ap9qHheLrfel550FTAgUamEr0CPj/zkyGo8fHmUGfJFZmCpNlRti9ODUBiZH0illW93NRQTQwpFXLX0OrI3b5qJZtfsUbRTaopFoza3GIyYNfSZM1SMJIKnyt+5Y5thdPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZHgk7mN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZHgk7mN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83B401F000FF;
	Sat, 12 Sep 2026 19:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242277;
	bh=iSNNszaECjX1wbLPMvxux5NObbQbqF1mCe4u9MW9bUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kZHgk7mNDh5I01UTzJCi/kTuis0EyqSIA/Zo84GNAJz7bS175VCmdcIdHCgDpxo1p
	 iGmzA+NFRSfUeGxYXmUa2K7vxzmxjZkOqgsSZeavxmKyHlKfsCkD9jTP0KVjQta6+p
	 IHpOP3Duowlh3JBMVj9n9Rp/yONj8Otio/h5f48s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Anson Huang <Anson.Huang@nxp.com>,
	Dong Aisheng <aisheng.dong@nxp.com>,
	Abel Vesa <abel.vesa@nxp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 349/798] clk: imx: scu: Add A72 frequency scaling support
Date: Sat, 12 Sep 2026 08:59:37 +0200
Message-ID: <20260912065525.158703195@linuxfoundation.org>
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

From: Anson Huang <Anson.Huang@nxp.com>

[ Upstream commit a43f6e8ae429f5ca594ae4463cc31c2a8ad4339c ]

Add A72 clock to support cpufreq on A72 cluster.

Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
Signed-off-by: Dong Aisheng <aisheng.dong@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@nxp.com>
Signed-off-by: Abel Vesa <abel.vesa@nxp.com>
Stable-dep-of: 5f2db1ce2012 ("clk: imx: scu: drop redundant init.ops variable assignment")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-scu.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index a48abf788ec87..662af67e6870b 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -194,6 +194,8 @@ static int clk_scu_atf_set_cpu_rate(struct clk_hw *hw, unsigned long rate,
 
 	if (clk->rsrc_id == IMX_SC_R_A35 || clk->rsrc_id == IMX_SC_R_A53)
 		cluster_id = 0;
+	else if (clk->rsrc_id == IMX_SC_R_A72)
+		cluster_id = 1;
 	else
 		return -EINVAL;
 
@@ -361,7 +363,7 @@ struct clk_hw *__imx_clk_scu(const char *name, const char * const *parents,
 
 	init.name = name;
 	init.ops = &clk_scu_ops;
-	if (rsrc_id == IMX_SC_R_A35 || rsrc_id == IMX_SC_R_A53)
+	if (rsrc_id == IMX_SC_R_A35 || rsrc_id == IMX_SC_R_A53 || rsrc_id == IMX_SC_R_A72)
 		init.ops = &clk_scu_cpu_ops;
 	else
 		init.ops = &clk_scu_ops;
-- 
2.53.0



