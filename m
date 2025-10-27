Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59011322C98;
	Mon, 27 Oct 2025 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590877; cv=none; b=QdQEJ+AQaKzSxP1+3HYk5CYyN2T31kZfqvvwE+ncW8KoGO8d1o/TSzDllJImtI1qloW+Fa8RXjayRSbNT69+KNOvrnyhqWcDIped2RnBeBL0nNO+LRJjly20Se4YrTDoxK3q7Z9KBuqYnFgb7gzZUm+mHMqKCcI1rzVD34k0RU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590877; c=relaxed/simple;
	bh=F3sQzkcsf+YwUxRvsHNEJG9s0EMeO/naDwi12vnMnuU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RMEyn2OgNpz3UJm946kR6X276Z0CluzBrersr+7G3kEwGvWKYtvD6nQ3l7dGf+WXC0KF7WewRbfaqm+kT0wbz8o1+HrPd52UawA/b+9jRUvsROzggjxzyPaWd89dnHzk0oLI0SbuFJbv1xdo57uW1w1f/8hPr8ty5aXp3eaPHyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TPLh4u5U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TPLh4u5U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA872C4CEF1;
	Mon, 27 Oct 2025 18:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590877;
	bh=F3sQzkcsf+YwUxRvsHNEJG9s0EMeO/naDwi12vnMnuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TPLh4u5URY42QG9yiMZUqnf9CXKpC0tKDJhxB67L2dx8kbetS+Iz0usYtZUMnrciE
	 cHcc5a/dzT8R3Mm4V+XNOXveHAp9Ah+pfVd/Ua9yQlTf/HOUu+jUDxjYBumBKt8LMB
	 8rd6KmjHGsS6hocyOjXoTQuFt7zZ7N/J7fYlszn8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 209/224] memory: samsung: exynos-srom: Correct alignment
Date: Mon, 27 Oct 2025 19:35:55 +0100
Message-ID: <20251027183514.359009580@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Krzysztof Kozlowski <krzk@kernel.org>

[ Upstream commit 90de1c75d8acd83e9a699b93153307a1e411ef3a ]

Align indentation with open parenthesis (or fix existing alignment).

Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Stable-dep-of: 6744085079e7 ("memory: samsung: exynos-srom: Fix of_iomap leak in exynos_srom_probe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/memory/samsung/exynos-srom.c |   22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

--- a/drivers/memory/samsung/exynos-srom.c
+++ b/drivers/memory/samsung/exynos-srom.c
@@ -47,9 +47,9 @@ struct exynos_srom {
 	struct exynos_srom_reg_dump *reg_offset;
 };
 
-static struct exynos_srom_reg_dump *exynos_srom_alloc_reg_dump(
-		const unsigned long *rdump,
-		unsigned long nr_rdump)
+static struct exynos_srom_reg_dump *
+exynos_srom_alloc_reg_dump(const unsigned long *rdump,
+			   unsigned long nr_rdump)
 {
 	struct exynos_srom_reg_dump *rd;
 	unsigned int i;
@@ -116,7 +116,7 @@ static int exynos_srom_probe(struct plat
 	}
 
 	srom = devm_kzalloc(&pdev->dev,
-			sizeof(struct exynos_srom), GFP_KERNEL);
+			    sizeof(struct exynos_srom), GFP_KERNEL);
 	if (!srom)
 		return -ENOMEM;
 
@@ -130,7 +130,7 @@ static int exynos_srom_probe(struct plat
 	platform_set_drvdata(pdev, srom);
 
 	srom->reg_offset = exynos_srom_alloc_reg_dump(exynos_srom_offsets,
-			ARRAY_SIZE(exynos_srom_offsets));
+						      ARRAY_SIZE(exynos_srom_offsets));
 	if (!srom->reg_offset) {
 		iounmap(srom->reg_base);
 		return -ENOMEM;
@@ -157,16 +157,16 @@ static int exynos_srom_probe(struct plat
 
 #ifdef CONFIG_PM_SLEEP
 static void exynos_srom_save(void __iomem *base,
-				    struct exynos_srom_reg_dump *rd,
-				    unsigned int num_regs)
+			     struct exynos_srom_reg_dump *rd,
+			     unsigned int num_regs)
 {
 	for (; num_regs > 0; --num_regs, ++rd)
 		rd->value = readl(base + rd->offset);
 }
 
 static void exynos_srom_restore(void __iomem *base,
-				      const struct exynos_srom_reg_dump *rd,
-				      unsigned int num_regs)
+				const struct exynos_srom_reg_dump *rd,
+				unsigned int num_regs)
 {
 	for (; num_regs > 0; --num_regs, ++rd)
 		writel(rd->value, base + rd->offset);
@@ -177,7 +177,7 @@ static int exynos_srom_suspend(struct de
 	struct exynos_srom *srom = dev_get_drvdata(dev);
 
 	exynos_srom_save(srom->reg_base, srom->reg_offset,
-				ARRAY_SIZE(exynos_srom_offsets));
+			 ARRAY_SIZE(exynos_srom_offsets));
 	return 0;
 }
 
@@ -186,7 +186,7 @@ static int exynos_srom_resume(struct dev
 	struct exynos_srom *srom = dev_get_drvdata(dev);
 
 	exynos_srom_restore(srom->reg_base, srom->reg_offset,
-				ARRAY_SIZE(exynos_srom_offsets));
+			    ARRAY_SIZE(exynos_srom_offsets));
 	return 0;
 }
 #endif


