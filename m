Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9CAE3D75D3;
	Wed, 20 May 2026 17:37:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298679; cv=none; b=TtV1/pgc6QVwBXkG2eGFb9gXyeGa5a3v2m3vfr5AxxTlkVSrN3WlsJnhL+cob20yewV0nurqR5lN7/5W9SxoU6qQyjTWMwfMp5bGz7ZfH0kn8EmmDOOPtm6hjnGdWnnt0mguPGfTNWB8HxbrQGchsLz80dJs9Dhw9BtNO8xpgsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298679; c=relaxed/simple;
	bh=uSGoEM+SC/0q/NRZG8Tmxg28HaJE0h8Cp/ehg6itXhc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g/b1h9TkuyPRAIyTzKw1PzeavSPNIlGIZc+40pfDnXtEp+gnUifrADmZTpWokIo5wS1RgU4OfGpppcmQCPQCy/zCtXmzJEzRuRtaBm74AB/Uk2EeTQ7m54W4EtTxM4DOf5FL0t5pDxFFh8Rou0XLNwKYJFyfkUSzsgiuZ2ZYLP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DZ+EWoED; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DZ+EWoED"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD651F000E9;
	Wed, 20 May 2026 17:37:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298677;
	bh=TniIX1mlTlIM9NKVTFEsj+1YfubFI/mVIxXyDyMNP40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DZ+EWoEDRRWP1C9W5xw+BcYc/zRkG9A3uJcM9v0zmMO569y+68Pidzp/UhoYGxXfE
	 jgCktBx58NgE01xNlK1DkFPLV+WAIKUiRevokUBkaOSHgNgxhtnVwyjB6sBdyFAWFH
	 hPLHgbsEo6Yv4xl/Vl+7FWRF1O4dVJub6Fyvykxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 502/957] pinctrl: cy8c95x0: Avoid returning positive values to user space
Date: Wed, 20 May 2026 18:16:25 +0200
Message-ID: <20260520162145.416139916@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



