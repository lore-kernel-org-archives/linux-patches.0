Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D23A3F9280;
	Wed, 20 May 2026 18:39:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779302389; cv=none; b=RDdqeCENg96HViXi1x+j2uCY3djoBVgv/rFBDpVKX2OTvlQl4EV4ZA+o4IiVpy1qtJI5tdZAyBwQAUEwKhIzb4xfjaZZWWVJiuM9Bo7xnymu3XYlt2AO47k+BKUIFaV4jHH17sZVpWWWcbOVYJSW06kZkN/D6CXwcjgaoirdYn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779302389; c=relaxed/simple;
	bh=9UiEWQjUpqq+1CuJJJ1jFTUfj16JU3rwX7qOngI3waM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i9v0lqqFu5GyvZINI8OBXWea0GEND3AUU4tiDJgMSHHi0HdsI9QdTEs4zm3uPJwwO8t3dGM0n5fd6yM6VVYrAEYGWoeVzwm3wlbm5Tm3NmULm9cPZDKzMNg9P6xByApaVvZ9zUhELkg8xKu87gBcX+zl+MV3TA1g/ObN8ow0vW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T1yASaUL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T1yASaUL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3C6F1F00893;
	Wed, 20 May 2026 18:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779302388;
	bh=hrLETxwTmBWnB/1rTas//a3eMSmvgqYlaq1eFOWGGk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T1yASaUL259inL8ytnep0kkGZI1k52UZX7l6zkOM0oG0Q1ZxvSl7Q6WEev6S9cRHO
	 +iX6Fz09uQyr1KY4n4qvrOTUmxx5sabmIA4oygW6lZ7Z9tksmi0bcF81KcUkZJch44
	 X8Vwr3LT+Drc9lkQM+iIo7SUheHCpbubcdiCSKS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 247/508] pinctrl: cy8c95x0: Avoid returning positive values to user space
Date: Wed, 20 May 2026 18:21:10 +0200
Message-ID: <20260520162104.002802625@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
References: <20260520162058.573354582@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1432b6714dc69..727f3c5605ced 100644
--- a/drivers/pinctrl/pinctrl-cy8c95x0.c
+++ b/drivers/pinctrl/pinctrl-cy8c95x0.c
@@ -1263,7 +1263,7 @@ static int cy8c95x0_irq_setup(struct cy8c95x0_pinctrl *chip, int irq)
 	/* Read IRQ status register to clear all pending interrupts */
 	ret = cy8c95x0_irq_pending(chip, pending_irqs);
 	if (ret)
-		return dev_err_probe(dev, ret, "failed to clear irq status register\n");
+		return dev_err_probe(dev, -EBUSY, "failed to clear irq status register\n");
 
 	/* Mask all interrupts */
 	bitmap_fill(chip->irq_mask, MAX_LINE);
-- 
2.53.0



