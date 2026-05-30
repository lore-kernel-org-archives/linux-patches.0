Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B2533FE15;
	Sat, 30 May 2026 17:17:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161451; cv=none; b=X9wNNagL14U698eUsFUatZdtkbdHgbFucmSQPgfvTOzMqscN7IkM+vqvGuCgZxWJ9pegVYkjuRMHM7PD59bW+j1/+ab+PWRxOz9ge1jM5Bzy6s72RjvA0IBgVoj/A5iFAf/6/s5et4y20TJsvHRxA6xYNdFpndx6dgSfI6zHbYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161451; c=relaxed/simple;
	bh=yM4K3vxgoYGL6nNj2Qr2JRENDurWUZ7GJFMANDs54e4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cgf4iyfJhrlI7C3p+8VWBGJEf21pav+FVeIz4kpGUDWowHncQ7CIHgqr8mvGh4mbIKiNnaE8amO5sQrkaXa4HTk7fMNsPDcw6WeVg/tRgkxqLKQ9NcnQpyy/8MoSFzMRhEzsVgDJep90CrgcvUqCPqQ3YkR/ScqKMYgjkfHoDX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PxaG/oxn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PxaG/oxn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DE8D1F00893;
	Sat, 30 May 2026 17:17:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161450;
	bh=nwQ2lLaQwQj6N2eROMFqnVvflmHWXfuYS10gqu35eoA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PxaG/oxnvHlLYdWrYq4/K8IgcjM5OM40JRRxvRJEDmVj959rPXNsYsA6DPFfO3o5D
	 J2QPvn9oqNx0yXfKZ6LNKKPlh1bQ2woLjFk4/ExTsZQxsUSGnNJkYvpEX7YXJd/DL0
	 MP/xw1PxskZX/+9OJ8ra2wwuv2iIBZ1J+ZRveyZo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 627/969] pinctrl: cy8c95x0: Unify messages with help of dev_err_probe()
Date: Sat, 30 May 2026 18:02:31 +0200
Message-ID: <20260530160317.763766714@linuxfoundation.org>
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
index c60886d804ce0..01f3c74f3dfa4 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1215,10 +1215,8 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 
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



