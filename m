Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F31034250D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301907; cv=none; b=OBFmH6MNv1c44eVWdzojQs3lFihVMZLbwK7mPjWh9KUhZorUL5XoykUwPCrpmN5Y2oHpimj0Ec1bcz/5Ad/ek/0tcCUT1MMKvsFBbkQqm0X/4HYVUcalT05CYFLJCcen1BMgWxQW2sd2OjteSiObqiac9cDjwQxXbN//2dzdCJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301907; c=relaxed/simple;
	bh=pQpY0IZ2yyM20fZsAY3RfVVV2qLQa9t7DpTeonpFKFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BxV5Ot1VzvIuvdMVKO4aVnWVSrBidWMGgYcXVE43I79klOUTpymWQe7NjnTba+QTxJ9j6EjWIOKpjEyTakgiMHnYEOguma/cwyKOrjQv0UNNwU4RvbzzYIu04ilDCuLbLjRDUKn3imf7eGVA1AsxnrqFeMHj92aGqKSGbKlFR9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mAB9wXng; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mAB9wXng"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC961C19423;
	Sat, 28 Feb 2026 18:05:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301907;
	bh=pQpY0IZ2yyM20fZsAY3RfVVV2qLQa9t7DpTeonpFKFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mAB9wXngFG/8C2Gj/eu3fXemGUiVO22VaiXP+ikFBUqPFUyAaOydQKFR4VKYa0oPN
	 S7y75WZ3Z9xZrJyP8ffPcll6APZsQUIH9kEZcnp3c9TsjTPIM5JP7B8fneJhY/AQu8
	 VOgv9vCaYKrOBhKNzI8PRNxag9rv5MKmYJwRbbfCp12zU3lcmStQW04TY7QS1sPfQQ
	 5nf1xjjFEp7eMuFe13sMxNIkto8Y5IpTaf+J0jSxGCQ075osb1Y/qMs1FGIgGu3mRv
	 PLrRdAsbjnkymgjEa+Yrrmf6fJ0toXvFJfJxxMdfhZsB3jdpPX6aM8PTNzykJS2LXX
	 bNq1x+HQmZrbA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ioana Ciornei <ioana.ciornei@nxp.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 338/385] mfd: simple-mfd-i2c: Add compatible strings for Layerscape QIXIS FPGA
Date: Sat, 28 Feb 2026 12:59:20 -0500
Message-ID: <20260228180011.1568201-338-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ioana Ciornei <ioana.ciornei@nxp.com>

[ Upstream commit 81a2c31257411296862487aaade98b7d9e25dc72 ]

The QIXIS FPGA found on Layerscape boards such as LX2160AQDS, LS1028AQDS
etc deals with power-on-reset timing, muxing etc. Use the simple-mfd-i2c
as its core driver by adding its compatible string (already found in
some dt files). By using the simple-mfd-i2c driver, any child device
will have access to the i2c regmap created by it.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20250707153120.1371719-1-ioana.ciornei@nxp.com
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 8f34c1a64c53 ("mfd: simple-mfd-i2c: Add Delta TN48M CPLD support")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/simple-mfd-i2c.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mfd/simple-mfd-i2c.c b/drivers/mfd/simple-mfd-i2c.c
index 22159913bea03..f7798bd922224 100644
--- a/drivers/mfd/simple-mfd-i2c.c
+++ b/drivers/mfd/simple-mfd-i2c.c
@@ -99,6 +99,8 @@ static const struct of_device_id simple_mfd_i2c_of_match[] = {
 	{ .compatible = "maxim,max5970", .data = &maxim_max5970},
 	{ .compatible = "maxim,max5978", .data = &maxim_max5970},
 	{ .compatible = "maxim,max77705-battery", .data = &maxim_mon_max77705},
+	{ .compatible = "fsl,lx2160aqds-fpga" },
+	{ .compatible = "fsl,ls1028aqds-fpga" },
 	{}
 };
 MODULE_DEVICE_TABLE(of, simple_mfd_i2c_of_match);
-- 
2.51.0

