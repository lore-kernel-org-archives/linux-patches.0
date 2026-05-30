Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CA8E3546F6;
	Sat, 30 May 2026 17:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161458; cv=none; b=jMn8m5gXA/oxZ84f++AZsTb5r1s1X36+5SeOjoEHo3LuU4CE0Tm0woJHi8Yze5bbbH+knbORVzHDTDNnoiUb8cy1DLTAQtMGWRlXJ8gPwgiZhgWSSQxCsrrbWjGw0uh+hPnIlQNJZPUUzsZnZIPswcg0+audY0oOtLUQPEC7x2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161458; c=relaxed/simple;
	bh=EUj0R/KVWSx1+G2OT3nNiVSkcJDOQTrr6S/ydQJTwww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rDtom3HJ500chIM0NLCfPJKubqthCsH3pRJFZ3jZzHxy+Ow2xISznUGaWeuNQX9Vtx1Sddee+DwJ2zZY/aV4N5sLO2PE1jylhLn6LNc3MDZOiyevmWx1OMm0ngmWHKs9WuCDIml5CzPlQrxW5DxQ8L+/myqEL8+aWqTwPhafO8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7JQnNxe; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7JQnNxe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48D581F00893;
	Sat, 30 May 2026 17:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161457;
	bh=hJ+KSwxFJrSKiAwmfUtpR4opjLulPjKgOEmIGwO0h/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o7JQnNxeolqZVtwsxBpJpo1lBTm4Jci1uA3ouvd0Lm1Y4nu607rkitVb/7m6yOK2K
	 KwrSksXpO9pjfOgsc5ANdjmFMlaYwRZvbYSEKzZ+I+OsJHCZoyp656waZWeZ8fS1se
	 NuotF0+ApLb69nYucWLz9O9ktWuwfYSQ3UsQpuAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 628/969] pinctrl: cy8c95x0: Avoid returning positive values to user space
Date: Sat, 30 May 2026 18:02:32 +0200
Message-ID: <20260530160317.790657913@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 5ad32c3607cf241a1a2680cabd64cbcd757227aa ]

When probe fails due to unclear interrupt status register, it returns
a positive number instead of the proper error code. Fix this accordingly.

Fixes: e6cbbe42944d ("pinctrl: Add Cypress cy8c95x0 support")
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202602271847.vVWkqLBD-lkp@intel.com/
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index 01f3c74f3dfa4..e4e8f744d27cb 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1216,7 +1216,7 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 	/* Read IRQ status register to clear all pending interrupts */
 	ret = cy8c95x0_irq_pending(chip, pending_irqs);
 	if (ret)
-		return dev_err_probe(dev, ret, "failed to clear irq status register\n");
+		return dev_err_probe(dev, -EBUSY, "failed to clear irq status register\n");
 
 	/* Mask all interrupts */
 	bitmap_fill(chip->irq_mask, MAX_LINE);
-- 
2.53.0



