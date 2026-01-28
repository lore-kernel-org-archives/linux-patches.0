Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42875285C8D;
	Wed, 28 Jan 2026 16:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616073; cv=none; b=EVO0nKNmwhyahoSbEjVrs+z8fOpJX/QIJ5DvhrLRR5M1fmDvCRYqAycHYcgFpoMhAeeYpiYD3buQ01K3kbtQEdnGv6oXBaHR+3lHl4N/nCgy5He3oClGTIHG2VZYfaS3YOnzw+BKS+5qtNQW0KBqXFKQ3X116l0fR8hYezRUqf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616073; c=relaxed/simple;
	bh=KazoVGPvM4jY12gtOQUZSZV47BMsYUgJIsb4rr014KI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I8KF7q29ojkcwjx/fxqX4ar+pU7DiQxPhYnELySCtshYPRnZTg4P5qlHsIRlY5uNHj1vFQntDOTptrRwcwWc1zIq30KBav9iYP8wHEAg/ATVzskOvahPghVtrur+TmkmFXdUgqIRzomthwNi5ML4r1DbDpQAP591MDQ7kobGh0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=suyfHHiz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="suyfHHiz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7CFBC4CEF7;
	Wed, 28 Jan 2026 16:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616073;
	bh=KazoVGPvM4jY12gtOQUZSZV47BMsYUgJIsb4rr014KI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=suyfHHizC2fuIe3Q3rJmIMVsZyrUy5MHY3cshKDJgwOVyJxFJBpxun5E4U7g9psjy
	 zzqswUtUK9tnTE4ycnRHlVlHOSzQEU7KFJKfDeF6SXnVxO7xC5FNj8ZKjNtYBPlprS
	 RWnU1OX2czdIDUzLF2YJbbVNPRtPmWH563A7Be2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ming Qian <ming.qian@oss.nxp.com>,
	Benjamin Gaignard <benjamin.gaignard@collabora.com>,
	Peng Fan <peng.fan@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.18 197/227] pmdomain: imx8m-blk-ctrl: Remove separate rst and clk mask for 8mq vpu
Date: Wed, 28 Jan 2026 16:24:02 +0100
Message-ID: <20260128145351.532756232@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Ming Qian <ming.qian@oss.nxp.com>

commit 3de49966499634454fd59e0e6fecd50baab7febd upstream.

For i.MX8MQ platform, the ADB in the VPUMIX domain has no separate reset
and clock enable bits, but is ungated and reset together with the VPUs.
So we can't reset G1 or G2 separately, it may led to the system hang.
Remove rst_mask and clk_mask of imx8mq_vpu_blk_ctl_domain_data.
Let imx8mq_vpu_power_notifier() do really vpu reset.

Fixes: 608d7c325e85 ("soc: imx: imx8m-blk-ctrl: add i.MX8MQ VPU blk-ctrl")
Signed-off-by: Ming Qian <ming.qian@oss.nxp.com>
Reviewed-by: Benjamin Gaignard <benjamin.gaignard@collabora.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/pmdomain/imx/imx8m-blk-ctrl.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

--- a/drivers/pmdomain/imx/imx8m-blk-ctrl.c
+++ b/drivers/pmdomain/imx/imx8m-blk-ctrl.c
@@ -846,22 +846,25 @@ static int imx8mq_vpu_power_notifier(str
 	return NOTIFY_OK;
 }
 
+/*
+ * For i.MX8MQ, the ADB in the VPUMIX domain has no separate reset and clock
+ * enable bits, but is ungated and reset together with the VPUs.
+ * Resetting G1 or G2 separately may led to system hang.
+ * Remove the rst_mask and clk_mask from the domain data of G1 and G2,
+ * Let imx8mq_vpu_power_notifier() do really vpu reset.
+ */
 static const struct imx8m_blk_ctrl_domain_data imx8mq_vpu_blk_ctl_domain_data[] = {
 	[IMX8MQ_VPUBLK_PD_G1] = {
 		.name = "vpublk-g1",
 		.clk_names = (const char *[]){ "g1", },
 		.num_clks = 1,
 		.gpc_name = "g1",
-		.rst_mask = BIT(1),
-		.clk_mask = BIT(1),
 	},
 	[IMX8MQ_VPUBLK_PD_G2] = {
 		.name = "vpublk-g2",
 		.clk_names = (const char *[]){ "g2", },
 		.num_clks = 1,
 		.gpc_name = "g2",
-		.rst_mask = BIT(0),
-		.clk_mask = BIT(0),
 	},
 };
 


