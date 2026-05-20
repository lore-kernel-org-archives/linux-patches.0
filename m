Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6429834DB46;
	Wed, 20 May 2026 18:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300932; cv=none; b=NqX9pl47Cuia2t3wYfzhpOCDG06EsBjg0KVOOjq7sPmmIkTZRengftnyVD2xGe/Ez0elX2oXmJlgJQzjXXgD8MXfvYmGHypLJfRZfKpjnskgQJ/+rkM1vb6Fntt50OnELauJGPm80WC7fEp8m/sUBJuqKDygSvx6xUxOBLjpE5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300932; c=relaxed/simple;
	bh=W/nqfhZ7yuHqxmCPeKpukmK30X5ww0Zs2HsY5gDhfR8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P/zPAH6aBLsNkc98bbDRJUXWAXyk0E6iRhR2Nc2/G8Zq1jonVE47S+xgX4iRK0ZLovFdDvmzOEXcXfP0o/KyVvXc/WKrwuZV+2oyI7TkvlfxQ0nG2g9kZZLKxcoWGZxFvohnbyToVy4p9VYtj01LmrJ3/Q9+uMaVRMfdxsOgf1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/azKAZ1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/azKAZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F65A1F000E9;
	Wed, 20 May 2026 18:15:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300927;
	bh=ZX2yVuItrCMpbku8z86NPYxmUfnP31wmWkm5QB39lGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t/azKAZ1G8hlhHJrSMld1GgzejmCUTrdn0bpVhtAzLGaffpjIs19rDJitxLK31jCP
	 eldZcbEHcbfL4hH7L6nsI5iohBmr7qZ53Rwk1Ybwl/Ydi1LCpDZR6KUNlUfh0o7txE
	 PN3mY/pW3ldgfYq118ZE1GZhQjQ+3oI487QlGsO8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 361/666] pinctrl: cy8c95x0: Avoid returning positive values to user space
Date: Wed, 20 May 2026 18:19:32 +0200
Message-ID: <20260520162119.061749400@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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
index baf32847cea5a..c7948e2a08028 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1355,7 +1355,7 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 	/* Read IRQ status register to clear all pending interrupts */
 	ret = cy8c95x0_irq_pending(chip, pending_irqs);
 	if (ret)
-		return dev_err_probe(dev, ret, "failed to clear irq status register\n");
+		return dev_err_probe(dev, -EBUSY, "failed to clear irq status register\n");
 
 	/* Mask all interrupts */
 	bitmap_fill(chip->irq_mask, MAX_LINE);
-- 
2.53.0



