Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8587CF08;
	Mon,  4 Mar 2024 21:31:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709587891; cv=none; b=b+vdpl2olOkvgSJovVD1UR7LhfcksAyGeN6HWtewzYAe1VM7t9sc/0olhcCPezxi7noz8OnOTZh0hKyqVGoCKFasFa45O3NZ2lisk6Py14vGh38fgoSwKJwdlSDC4k6Y9D/leXn91U5bX/3absUsJYXpbkZjB5yGT67oEODvjmc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709587891; c=relaxed/simple;
	bh=O97vF2buddLYIf2F+uF0aTHz/dvCeUEffRIzKRQqKhw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LeD6vhsVheZXU/ysA6gmx96tZ+F0q949/0nCFN+GICeGV2eVSOWHPOvIw8Y2LqFrMFvTwWfSaVTIyz8bublS0ikH00e6PUV0j/Iu9L1FksQ0ZrLhdfWXxelEip4iVL591fcUR5FPEx1Du0JHX8yBrKI4dGahko9mmoeK4/rzWUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eaOuh8b0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eaOuh8b0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A0F6C433C7;
	Mon,  4 Mar 2024 21:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709587891;
	bh=O97vF2buddLYIf2F+uF0aTHz/dvCeUEffRIzKRQqKhw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eaOuh8b0yuUYRMo7/gRSyQSZp3JOpKmptl8yQh/8ZdztUfqNl1rkg8thhbSxc/DZb
	 /pt9BffUyFxAslYq9m+BAbmDg7R5smlyGD4eRdz5z7NEX4FBxX3W+ek0GSm72qiud6
	 XZ6epax1jidCzOQxr4jgOAxJpB1Pk1zpvMD4tdKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@gmail.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.7 130/162] mfd: twl6030-irq: Revert to use of_match_device()
Date: Mon,  4 Mar 2024 21:23:15 +0000
Message-ID: <20240304211555.894507166@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211551.833500257@linuxfoundation.org>
References: <20240304211551.833500257@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@gmail.com>

commit 7a29fa05aeca2c16193f00a883c56ffc7c25b6c5 upstream.

The core twl chip is probed via i2c and the dev->driver->of_match_table is
NULL, causing the driver to fail to probe.

This partially reverts:

  commit 1e0c866887f4 ("mfd: Use device_get_match_data() in a bunch of drivers")

Fixes: 1e0c866887f4 ("mfd: Use device_get_match_data() in a bunch of drivers")
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@gmail.com>
Link: https://lore.kernel.org/r/20231029114843.15553-1-peter.ujfalusi@gmail.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mfd/twl6030-irq.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/drivers/mfd/twl6030-irq.c
+++ b/drivers/mfd/twl6030-irq.c
@@ -24,10 +24,10 @@
 #include <linux/kthread.h>
 #include <linux/mfd/twl.h>
 #include <linux/platform_device.h>
-#include <linux/property.h>
 #include <linux/suspend.h>
 #include <linux/of.h>
 #include <linux/irqdomain.h>
+#include <linux/of_device.h>
 
 #include "twl-core.h"
 
@@ -368,10 +368,10 @@ int twl6030_init_irq(struct device *dev,
 	int			nr_irqs;
 	int			status;
 	u8			mask[3];
-	const int		*irq_tbl;
+	const struct of_device_id *of_id;
 
-	irq_tbl = device_get_match_data(dev);
-	if (!irq_tbl) {
+	of_id = of_match_device(twl6030_of_match, dev);
+	if (!of_id || !of_id->data) {
 		dev_err(dev, "Unknown TWL device model\n");
 		return -EINVAL;
 	}
@@ -409,7 +409,7 @@ int twl6030_init_irq(struct device *dev,
 
 	twl6030_irq->pm_nb.notifier_call = twl6030_irq_pm_notifier;
 	atomic_set(&twl6030_irq->wakeirqs, 0);
-	twl6030_irq->irq_mapping_tbl = irq_tbl;
+	twl6030_irq->irq_mapping_tbl = of_id->data;
 
 	twl6030_irq->irq_domain =
 		irq_domain_add_linear(node, nr_irqs,


