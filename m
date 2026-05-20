Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8CCD3A453B;
	Wed, 20 May 2026 16:53:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295991; cv=none; b=gXOiSFOF9v/Fqls1I7Axq/9FmE0n/LIPXKRoWhzm/7AFfj0HB8Y5A2VdAde8VGUxei4URRiGP+axwNHYy3lIUyEbwNuCS6n75lwG67hKV2UvYGwVHYO6Yvsqz+Na13FRJAArFDFldd/5y3FE6ZhRK/Ih1hh0hE1qo+RNVmquAJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295991; c=relaxed/simple;
	bh=TAN7DTCw8a318UwtAQMaf/QPaV31ONA3scYibYiOmTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sZ3h5/HZhNe8cPUJjtOIrAPFDC9UKNCENXRka/SUq2rHx0SLgwCr/BNABAvL7gwu9n0h9Diez7n6FLCZWuFEQcnDjsFywOg+7OiD5JD+yXUfgwZ0aCWowVLbGOQhJZQJnGq9AFvwx3MJDPEBDeDNQH4CYOqs+AMubXEl6JqZaWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wwmans38; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wwmans38"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6DF41F000E9;
	Wed, 20 May 2026 16:53:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295989;
	bh=XaCx8aywHFyHHl4zUzy0Islvcz57slmh47SRjjCXkeo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wwmans38uvYyV5o8jBdVDnmwR5doE1mUA18l/eOHhg19mpg4p1J+plZ8/oIp6vj2O
	 3wCwSBX7aEwlpIqSS2YVU8ZcyOHPlryjddZD4DBJ6zYSScbv4aCLffTJwYaCWUm8tN
	 Qw42I8of+QKFp15cj5Dztj69kTVH9cITum+J7Fis=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0629/1146] pinctrl: cy8c95x0: Unify messages with help of dev_err_probe()
Date: Wed, 20 May 2026 18:14:39 +0200
Message-ID: <20260520162202.421348028@linuxfoundation.org>
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



