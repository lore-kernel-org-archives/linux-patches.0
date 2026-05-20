Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA385372691;
	Wed, 20 May 2026 16:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295995; cv=none; b=k0kjg9TtZXfq3UG6YgBMA51ifiqeTG/4oLkr9PRQlgU0ZcQvP+Qaylm34mZfI0y2lnOveq4aggRt1wKCQ0+5HqgA1tiIFiwWsNBU2ti2Yf90nk3HA8bftz4hIJU9NGhi0nB5UyDajTzufRSStNyzWLlhuEHbALpu29TR7RcgKl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295995; c=relaxed/simple;
	bh=xfXozIWhNxkGHj6No9mDDTHsjicfcTiiMLSyrZ4Q0c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BvQUnzfc1bSZH7FCB7h/Cq2Qx4njDpvZRjW5SygJcD1ZmLkKHUNG7aPLK0b3SFh23yYxCooJ1nH+fcl1ReGwIVc04LGB2pEWfd6eSm6OPJRIxAaA4wFEH2d4HMqyjgb4PvgbjR0QwFnGYPLVnCFB/OA0wnjmssi8OBY2mIERbQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bJn+Qv78; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bJn+Qv78"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D64A1F00893;
	Wed, 20 May 2026 16:53:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295991;
	bh=x5ebGrRrlDbkHjmJyvZQIH1lLXW1GeYN1OZqrG9e9AY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bJn+Qv78coQYBkwgs3fdfsSdr7Gn9LiwPl5rfUnFNS/XAOXF8ZEhdx/E6Qe2+nUe3
	 Uen2LvYe7zLZu8P0jAQ1xeNOUGyUlovztf+pAKXQ7uHH5MJAZZMe/Ss/9OtFyeMhSv
	 M/U8oRo3ftFKsPfAtaYzKRIAPbe1Ks2JGsqMylbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0630/1146] pinctrl: cy8c95x0: Avoid returning positive values to user space
Date: Wed, 20 May 2026 18:14:40 +0200
Message-ID: <20260520162202.444160759@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index 14d927035bc0f..54b117f32f0ea 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1320,7 +1320,7 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 	/* Read IRQ status register to clear all pending interrupts */
 	ret = cy8c95x0_irq_pending(chip, pending_irqs);
 	if (ret)
-		return dev_err_probe(dev, ret, "failed to clear irq status register\n");
+		return dev_err_probe(dev, -EBUSY, "failed to clear irq status register\n");
 
 	/* Mask all interrupts */
 	bitmap_fill(chip->irq_mask, MAX_LINE);
-- 
2.53.0



