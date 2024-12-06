Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226F213AA5F;
	Fri,  6 Dec 2024 15:03:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497383; cv=none; b=SaKgard/pvLFuySufVyRacdI8wERyjk0642FqP7roQwdDRhThE8WMYYEnM5nvnKW7mwS/j3XnSrMsXieayhI1ojSq6cywczqB89qqm/7+UIyZzBr482+rbU2HAArEn++VcOpHsnvA++fV89G1KghRS1SDZVjO7dnvIMKpfpAgm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497383; c=relaxed/simple;
	bh=dB0Zqg98DpGNwrmq0eQdFLOlFI6xELiKRKyH2I5Sxw4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrwsP8i0VB5ePwkynNMM4Cj+2PvX2CKc3ynYPFd0KTh9GllfFVvPGhS6ye9OESdvHpFJ5HexsZzfkVNerbJu0WYk6nD1hdOikrMZrU83Cp1x8C1k9oJdJW7xQ1sjRDkckH7SsUcZuAp/Pec2AuCtHup59QMQNjqfNYIRGXcE1Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2hRZnA0G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2hRZnA0G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AC4DC4CED1;
	Fri,  6 Dec 2024 15:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497383;
	bh=dB0Zqg98DpGNwrmq0eQdFLOlFI6xELiKRKyH2I5Sxw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2hRZnA0GnMvKni2Yeq3opg8imEQFIDqEC82CuHjouTsOfc/qhKOldiJ/iAHVD/LmL
	 q+pFh+8ZnwBAa6E56IPlZrgybN14hvvW/KTNGka1dB5orWIXF8rFjiajyZi3PRz2sP
	 YMw5Ilk9dhlyWrPCNFh45VGdzEcVgVYpsZlbBjgM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 274/676] mtd: hyperbus: rpc-if: Add missing MODULE_DEVICE_TABLE
Date: Fri,  6 Dec 2024 15:31:33 +0100
Message-ID: <20241206143704.043433195@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



