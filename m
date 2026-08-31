Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71F644E56EB;
	Mon, 31 Aug 2026 13:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183606; cv=none; b=NobJmgS47rvw0iSm8QiA2eFhonCjHpNKGxhD0GTGfm9tXGAiwhj5xRa2rpTwMIfxlujJSeSOnwzGQQm+wwFCDVi+UpiJfWpT64Zc+WhIbx0EnSLff8kfh5soLyKO++Ni8ukEyUYlnsmBC1yy6XnelUXX539LBvnpJjwLFVETk6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183606; c=relaxed/simple;
	bh=9W3rUd+OYpLcqalcIqTbM98pREBLJhZC2xB7hI7PiwE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=soScetJD34yReGrgE4Os8WAxnCGj06Ty1TQ6YUKVEdGGwXQaNgODJowk6GUsDtUrkULUaFpz4EQvA/SYVdEVSmK60mnp4mL4Stf56HcJvgQcGJsrHLybT6VFHKxmhRt/35drnJlK7bw/cYA7mWYr7kEtsE2HirJKr2SBrSD4mP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=V5DC9wMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="V5DC9wMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21FBA1F00A3D;
	Mon, 31 Aug 2026 13:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788183604;
	bh=7+4+Mj5xMw3iTFchj0PIGWYEqdIBf0ZuxxB5KKCLY+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V5DC9wMM8NLvVvVHeNTHVPi7HwuLd/UBuRBXZzwywSwcDfg27gpJatH/0ZjedaSzI
	 pUAn1fOTl3SrsTkWR85BmdqwaRt4Jdm+FkyT1uda0zv3sJoft//7M/6V/zbZgeVaiH
	 Q1N5ASxjwzNKJ2p0NNp/QBuo7vQTbaPiP3J4tSEoBAhEUplSMU9ZTAw2YJSCT7X8Kc
	 w78/xgTvqJOtwXHYDshia/sVxKZGRkeVQHbXmn2o6QkkvmMTG3mmi/W9NWKdrLAEUF
	 8hBs+qDI0rEuhByJndK9n954eZaDivAw3BaPwebnDD3YLqGhZnmoSNiZAzJQvnR7Tl
	 1Vapugt2VA+/g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Peng Fan <peng.fan@nxp.com>,
	Mathieu Poirier <mathieu.poirier@linaro.org>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>,
	Frank.Li@nxp.com,
	linux-kernel@vger.kernel.org,
	imx@lists.linux.dev,
	linux-arm-kernel@lists.infradead.org
Subject: [PATCH AUTOSEL 6.18-6.12] mailbox: imx: use devm_of_platform_populate()
Date: Mon, 31 Aug 2026 09:23:42 -0400
Message-ID: <20260831133314.4125787-194-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260831133314.4125787-1-sashal@kernel.org>
References: <20260831133314.4125787-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.48
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit dd1b321e8024fb01404fe163076c9010c5df8608 ]

The driver uses of_platform_populate() but does not remove the added
devices on removal. This can lead to "double devices" on module removal
followed by adding the module again.

Use devm_of_platform_populate() to remove the populated devices once the
parent device is removed.

Reviewed-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Mathieu Poirier <mathieu.poirier@linaro.org>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

The analysis is complete for **Linux 6.18.44**.

**Verdict: YES** — backport `mailbox: imx: use
devm_of_platform_populate()` (`dd1b321e8024f`).

The bug is present in this tree: `of_platform_populate()` was added in
v6.9 (`2a0ac450128bc`) for i.MX95 SCMI SRAM sub-nodes, but
`imx_mu_remove()` never depopulates them. On module reload or sysfs
unbind/rebind, child platform devices can be duplicated and break SCMI
setup.

The fix is a one-line change to `devm_of_platform_populate(dev)` at line
943 of `drivers/mailbox/imx-mailbox.c`. The mainline patch needs a minor
context adjustment to apply here, but no functional rework.

 drivers/mailbox/imx-mailbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/mailbox/imx-mailbox.c b/drivers/mailbox/imx-mailbox.c
index 3e52f70434c97..445cd50c1b667 100644
--- a/drivers/mailbox/imx-mailbox.c
+++ b/drivers/mailbox/imx-mailbox.c
@@ -986,7 +986,7 @@ static int imx_mu_probe(struct platform_device *pdev)
 	if (ret)
 		goto err_out;
 
-	of_platform_populate(dev->of_node, NULL, NULL, dev);
+	devm_of_platform_populate(dev);
 
 	return 0;
 
-- 
2.53.0

