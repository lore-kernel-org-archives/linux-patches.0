Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808351DE3D4;
	Tue,  8 Oct 2024 12:26:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390362; cv=none; b=Uad+1MO3gnQEiNZBYzhUPsAPVdivr73ciX6Yb5ctwIrE4HK+tSJpgQuorPegBFmi9vR44a19ffj9NaQGKkk02Or7wInobTZvV/WaFqdDvjIfAQscaiJtZNbvCNroRWiPP9C2idMDL9ndSDKkH8xWpW15R2DhsRXZcjRFsu/KLyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390362; c=relaxed/simple;
	bh=6i+uQWVe9N8/BtakXTi3Dz1tQS9bd59+azmExJo2sJ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHanQaLMyVt7pI9OuuITbEkG0WVsUM4dkgcsEu0mScmWQAEyTzj+EHwahA5z/Kar7UakNugoMh4og4Rmru466prWMt/aPhK6wWwGC1nTjrMsHBxbCGRDucrAQO0QI6oFztEtGZ/aC/iecdG9o7SOVNbTt434woq4v1/z3qn+IUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GY5S1sF3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GY5S1sF3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2498C4CEC7;
	Tue,  8 Oct 2024 12:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390362;
	bh=6i+uQWVe9N8/BtakXTi3Dz1tQS9bd59+azmExJo2sJ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GY5S1sF3VKbG7yl06oCOT7nFjnAB7G5IX2xX5hHGhudCGHPbtlzWVtdt0Qbsy9DHB
	 +UA5yXwxJH9i4IvShw+eTRzhnE9adICVw6ZKx+433pkqU5bu0PbEV4/YcChTxvm1o/
	 z4uKCnwrHY6b+JLZiXv1/JehKgGT53x5jslQsebQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 267/482] spi: rpc-if: Add missing MODULE_DEVICE_TABLE
Date: Tue,  8 Oct 2024 14:05:30 +0200
Message-ID: <20241008115658.790759083@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 0880f669436028c5499901e5acd8f4b4ea0e0c6a ]

Add missing MODULE_DEVICE_TABLE definition for automatic loading of the
driver when it is built as a module.

Fixes: eb8d6d464a27 ("spi: add Renesas RPC-IF driver")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20240731072955.224125-1-biju.das.jz@bp.renesas.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rpc-if.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi-rpc-if.c b/drivers/spi/spi-rpc-if.c
index e11146932828a..7cce2d2ab9ca6 100644
--- a/drivers/spi/spi-rpc-if.c
+++ b/drivers/spi/spi-rpc-if.c
@@ -198,9 +198,16 @@ static int __maybe_unused rpcif_spi_resume(struct device *dev)
 
 static SIMPLE_DEV_PM_OPS(rpcif_spi_pm_ops, rpcif_spi_suspend, rpcif_spi_resume);
 
+static const struct platform_device_id rpc_if_spi_id_table[] = {
+	{ .name = "rpc-if-spi" },
+	{ /* sentinel */ }
+};
+MODULE_DEVICE_TABLE(platform, rpc_if_spi_id_table);
+
 static struct platform_driver rpcif_spi_driver = {
 	.probe	= rpcif_spi_probe,
 	.remove_new = rpcif_spi_remove,
+	.id_table = rpc_if_spi_id_table,
 	.driver = {
 		.name	= "rpc-if-spi",
 #ifdef CONFIG_PM_SLEEP
-- 
2.43.0



