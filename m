Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A81A42E06E4;
	Tue, 13 Oct 2026 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895535; cv=none; b=gNywRlgQOL4nySJl6CEYO/cEy6TfjKA1EspqU+XmDEJ8dpvVINaHMsCL9EgCLjVmvanzRxujLJoiTfADDiTMd+1PFQM14eOVe3QlbWpvE/ts64n9rijEK0UGqgvzEODvgXOe9R2Ze9AwkggQZHMd8ZKc6/bb2a/c1k5MBk7tBLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895535; c=relaxed/simple;
	bh=1SNgF9t/Jw8gqo/a5lBG9OyOYUswdBkq3pn8tSCuf3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EK0G7RfbqWnskgXfiAQVzjlpXO/M/hge2KbKzqy/eXHhZwTOkhe8QZlstExwC+CRJGRXSgQnqXdMeT9ml9yUXtwy3r9b4sccM52ThIQ17dxPu1N5YML29bRUjQchHkSDDouW9mJzlaYza08E62TlFXvvX2zi1e7m91n4AONM9KI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CSRR3WJF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CSRR3WJF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 073E51F000FF;
	Tue, 13 Oct 2026 12:45:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895534;
	bh=HY9zNjx+UwTBxr0zGkEmsYBxEpZVfLwcJYftBCN0iBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CSRR3WJFSbPSbw5+L6JgUy/kAhMtwOKFI9l+7Nu229foWT9ve+HSlolZkfLjFZobE
	 Bj48wrnAiOHfbABte4WR8Zb6BaL0pD9clLaWRSw/nV1NdMB1BYJBn5tFpZszK6F+8z
	 4AFbdNV8WDmL5tjE2+hAAfj0YRMn/HhQ+Qp0Rcg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manikanta Guntupalli <manikanta.guntupalli@amd.com>,
	Michal Simek <michal.simek@amd.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 306/497] i2c: xiic: Relocate xiic_i2c_runtime_suspend and xiic_i2c_runtime_resume to facilitate atomic mode
Date: Tue, 13 Oct 2026 13:37:53 +0200
Message-ID: <20261013112915.158872346@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manikanta Guntupalli <manikanta.guntupalli@amd.com>

[ Upstream commit 2ee409c6a12d74cd1b16ca3690baa7d5ffffeb7d ]

Relocate xiic_i2c_runtime_suspend and xiic_i2c_runtime_resume functions
to avoid prototype statements in atomic mode changes.

Signed-off-by: Manikanta Guntupalli <manikanta.guntupalli@amd.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/r/20241210095242.1982770-2-manikanta.guntupalli@amd.com
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: b7e6df2f52ed ("i2c: xiic: preserve PEC byte length in SMBus block read setup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-xiic.c | 46 +++++++++++++++++------------------
 1 file changed, 23 insertions(+), 23 deletions(-)

diff --git a/drivers/i2c/busses/i2c-xiic.c b/drivers/i2c/busses/i2c-xiic.c
index 44c2afd5ef07b..1cef404a33971 100644
--- a/drivers/i2c/busses/i2c-xiic.c
+++ b/drivers/i2c/busses/i2c-xiic.c
@@ -238,6 +238,29 @@ static const struct timing_regs timing_reg_values[] = {
 static int xiic_start_xfer(struct xiic_i2c *i2c, struct i2c_msg *msgs, int num);
 static void __xiic_start_xfer(struct xiic_i2c *i2c);
 
+static int __maybe_unused xiic_i2c_runtime_suspend(struct device *dev)
+{
+	struct xiic_i2c *i2c = dev_get_drvdata(dev);
+
+	clk_disable(i2c->clk);
+
+	return 0;
+}
+
+static int __maybe_unused xiic_i2c_runtime_resume(struct device *dev)
+{
+	struct xiic_i2c *i2c = dev_get_drvdata(dev);
+	int ret;
+
+	ret = clk_enable(i2c->clk);
+	if (ret) {
+		dev_err(dev, "Cannot enable clock.\n");
+		return ret;
+	}
+
+	return 0;
+}
+
 /*
  * For the register read and write functions, a little-endian and big-endian
  * version are necessary. Endianness is detected during the probe function.
@@ -1368,29 +1391,6 @@ static void xiic_i2c_remove(struct platform_device *pdev)
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 }
 
-static int __maybe_unused xiic_i2c_runtime_suspend(struct device *dev)
-{
-	struct xiic_i2c *i2c = dev_get_drvdata(dev);
-
-	clk_disable(i2c->clk);
-
-	return 0;
-}
-
-static int __maybe_unused xiic_i2c_runtime_resume(struct device *dev)
-{
-	struct xiic_i2c *i2c = dev_get_drvdata(dev);
-	int ret;
-
-	ret = clk_enable(i2c->clk);
-	if (ret) {
-		dev_err(dev, "Cannot enable clock.\n");
-		return ret;
-	}
-
-	return 0;
-}
-
 static const struct dev_pm_ops xiic_dev_pm_ops = {
 	SET_RUNTIME_PM_OPS(xiic_i2c_runtime_suspend,
 			   xiic_i2c_runtime_resume, NULL)
-- 
2.53.0



