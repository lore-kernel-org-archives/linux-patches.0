Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C70D91F76CA;
	Tue,  3 Dec 2024 15:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238797; cv=none; b=aXdVkkrunyPWM+bwo9WagnP5IRZHQc2q75duUPRwMoL1m+V7lo0qtF3vIwNv3GlGAoRtTrHN66Zmbl6DaIP5m89e+y7n+fWbiql/EOBeD/KFR7f4lizKgT+WVbmKPudRRtGs2TxrHq6L3zPt2cnngytVn/2QuKiwEpZ5B7/os/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238797; c=relaxed/simple;
	bh=lfya4jBpYsirXcLIjQahnOMHrglR72DGp2U2q4D0qtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=doPhY3mBkXPJhDjwx7LibSuBlSJfV87y7fB4nggvAAhNahIxtrQq7UAmXezTgHUf3sFpBeGmyZeBifBpsSOseZ92rSetL5oJLOAiLBec8ohYfstF/Mqts8Id4m7oomE3beTuPu05VcpmM7OPyKE+MXyZ6ilqDmmg7AzZlmWR07o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yslKHV3p; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yslKHV3p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FADFC4CECF;
	Tue,  3 Dec 2024 15:13:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238796;
	bh=lfya4jBpYsirXcLIjQahnOMHrglR72DGp2U2q4D0qtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yslKHV3pJJjVp9QODo4vBwbpH8V+1Tou+62M0XRfUFPhsGJyHyAHb+neDbWhdptk5
	 L5FeXnntRfMxNrisH6N1moauu/VlVa2n0J2BL1rmhnePEPBIluw+ZepEGGmEty9skE
	 34h9e3+mIyRQ6mRByWoPYnWve3t+6dkRKJ5jV3bU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 399/817] mtd: hyperbus: rpc-if: Add missing MODULE_DEVICE_TABLE
Date: Tue,  3 Dec 2024 15:39:31 +0100
Message-ID: <20241203144011.449705158@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 7d189579a287d5c568db623c5fc2344cce98a887 ]

The rpc-if-hyperflash driver can be compiled as a module, but lacks
MODULE_DEVICE_TABLE() and will therefore not be loaded automatically.
Fix this.

Fixes: 5de15b610f78 ("mtd: hyperbus: add Renesas RPC-IF driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Reviewed-by: Vignesh Raghavendra <vigneshr@ti.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240731080846.257139-1-biju.das.jz@bp.renesas.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/hyperbus/rpc-if.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/mtd/hyperbus/rpc-if.c b/drivers/mtd/hyperbus/rpc-if.c
index b22aa57119f23..e7a28f3316c3f 100644
--- a/drivers/mtd/hyperbus/rpc-if.c
+++ b/drivers/mtd/hyperbus/rpc-if.c
@@ -163,9 +163,16 @@ static void rpcif_hb_remove(struct platform_device *pdev)
 	pm_runtime_disable(hyperbus->rpc.dev);
 }
 
+static const struct platform_device_id rpc_if_hyperflash_id_table[] = {
+	{ .name = "rpc-if-hyperflash" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, rpc_if_hyperflash_id_table);
+
 static struct platform_driver rpcif_platform_driver = {
 	.probe	= rpcif_hb_probe,
 	.remove_new = rpcif_hb_remove,
+	.id_table = rpc_if_hyperflash_id_table,
 	.driver	= {
 		.name	= "rpc-if-hyperflash",
 	},
-- 
2.43.0



