Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CAF1223C5A;
	Thu, 12 Dec 2024 16:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019477; cv=none; b=B0ekXoRe48F/U4RMylhM0WsFT6ZXvgViuhUTteLdnGtJd4uUyppVneeSNeoLr1qrAwi0BZjrLhtX7+o6XbrCT7mC3apTHUdSCfXxzvr09BFw2Spd2YSteNmoKogwH+/O1BOLhPYJdvBP0JKej83MCTuRxA3cIaTPJV3iQGxFxos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019477; c=relaxed/simple;
	bh=5wdUM6JsprahTzBqP6Ka8uvlP/XRN3WJnpPVNHK38kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+wo9pRhlrCbDB/8emCKM/xDBlV3Ehyk5HsKD2boEkCWxt7/dd6VQhDUdbm0okkKZGJFcQ8MVZUJEVGoFv0wdHkoXPe80UvWrSpzEob9QDHSeZIDoHJ0AUhTHjToq8si69TvBu3MWy5aKu2Y5nZJ/l5yDnjYsXzugh/e4Hl+FRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BQS6gGJP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BQS6gGJP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C49BEC4CED3;
	Thu, 12 Dec 2024 16:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019477;
	bh=5wdUM6JsprahTzBqP6Ka8uvlP/XRN3WJnpPVNHK38kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BQS6gGJP+38tzTcRGYUsIXGJFVU81/CqEcBuEi8md4wbw9nd0QXpBcvD6JQtsXLJS
	 PaLMXTYdCzJ005gOJg5zRpR8HaZpuaEAY2tcUFBmhBzz6nmRUuA+GmiAHTuNDdH1GZ
	 JAdQWpgy2VQFSJUSkw47eA/mKGDdoLCnIg4Y4mMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Vignesh Raghavendra <vigneshr@ti.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 217/772] mtd: hyperbus: rpc-if: Add missing MODULE_DEVICE_TABLE
Date: Thu, 12 Dec 2024 15:52:42 +0100
Message-ID: <20241212144358.882414531@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



