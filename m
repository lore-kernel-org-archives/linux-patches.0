Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61D7A3D75C7;
	Wed, 20 May 2026 17:37:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779298673; cv=none; b=bafSxAkE0M+XsR0fGhRMCLBqNmPKv5po4ABpGYDwq2xxNtRdIjchn8Vi7kAeV8J0Gw5+elU2KV8sYckMpvoueXA14OlpHD21/caxVNeOwaB9amMOf/I+4NTUlZki/Pj9XABzhEsKOOFyvUhIsTDtzCFtDOA8OaJamXzm3itBAwI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779298673; c=relaxed/simple;
	bh=uTAI5lFnfuCP+cyR8I28+Z0lBj003QHNTYIK2fkmPFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wb0B1p1Io1qyNLkVjqLPWMZUSyFU2ublozPvWjVOx/sR+3ApgI0o2BwfTl1KoSkva35ZwqBiQhXPX1BZkiUVK37LexK+bxcBsVn155JV+IL3rcPxq+KOddum5pNxHJ+h3zQOq/dv9r6cUW9Jk8sQixn+JcB95hQUtJOWNrchQb8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tbpIkwAm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tbpIkwAm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B97E11F00898;
	Wed, 20 May 2026 17:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779298672;
	bh=dbn4A2wRMW82GHxtvptwcNqMZ3WaowtwfgOyUOilXHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbpIkwAmaGqHHnf/SrhHEZ5xOlMh3ednzeDBfBSOTE8Lh6zT0ely8L3ix9Uu+gTiI
	 W7ib1pIjVC/4pOodHRqVAAiCIMoQBYWRT9YaKiz+brHl3SkEQK2Q6W8/+VcsJszUdt
	 v5JscY8HRZsbJTMWMs6sGkWdn40Iofq2NwBgrqE4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 501/957] pinctrl: cy8c95x0: Unify messages with help of dev_err_probe()
Date: Wed, 20 May 2026 18:16:24 +0200
Message-ID: <20260520162145.394765174@linuxfoundation.org>
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

[ Upstream commit 014884732095b982412d13d3220c3fe8483b9b3e ]

Unify error messages that might appear during probe phase by
switching to use dev_err_probe().

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Stable-dep-of: 5ad32c3607cf ("pinctrl: cy8c95x0: Avoid returning positive values to user space")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-cy8c95x0.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/pinctrl/pinctrl-cy8c95x0.c b/drivers/pinctrl/pinctrl-cy8c95x0.c
index c0f1d964f8397..14d927035bc0f 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1319,10 +1319,8 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 
 	/* Read IRQ status register to clear all pending interrupts */
 	ret = cy8c95x0_irq_pending(chip, pending_irqs);
-	if (ret) {
-		dev_err(chip->dev, "failed to clear irq status register\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(dev, ret, "failed to clear irq status register\n");
 
 	/* Mask all interrupts */
 	bitmap_fill(chip->irq_mask, MAX_LINE);
-- 
2.53.0



