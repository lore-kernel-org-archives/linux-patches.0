Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5CD2149C53;
	Wed,  5 Feb 2025 14:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738764613; cv=none; b=f72Qh3TZKdtSD+GGjdQrXhLTO1/x2ZAh7uFRcYQfAooo7Yb96DXrZ+uSwVV8WnaBy4Q8/S6WBDmkjMSXjUB3EqbAjlSAFLNthq1S5nrPcGbiI649KfykJVQ+KZl8ZlEQM1SejF4xLs4ojwepSaHnS7THGVVXstFRaWEEI9X4OxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738764613; c=relaxed/simple;
	bh=vkXsnzlrZlNaobZhFq57aZZFuZcNkzim3MXhWOF8BQQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Aakm7wc0r4m+ck5d5T5zHaQbyoibMw4kIpyT8Cdxig1pCpVdohI19ESEtW3Zf3RNKBW92scMqql1QoVPhJy4VlXN7TpRBj7pjv8Xoou7LH9IVzabRXRVmP2EQ9gXjkZCcDEOZ03Ohftdue02sero17/V/FOQO4dkbsPHILP3tuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r0BrOq4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r0BrOq4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DED61C4CED1;
	Wed,  5 Feb 2025 14:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738764613;
	bh=vkXsnzlrZlNaobZhFq57aZZFuZcNkzim3MXhWOF8BQQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r0BrOq4qo2yHH9R2qgeCwZcmxhPCkx91Whe8iQQerTwx+Bhabnt+NU9HA8RuYH0FP
	 IsqSbDSm4a3S50lRRAaYfeNSO9B8vSpiPOAHJdf62XGC4CXcDxWrmVzegEhS1gq3i8
	 mQZwMW8ZEKfNfxbbrIKf3OS+7XdvhAvu3Et7gtx4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	=?UTF-8?q?Duje=20Mihanovi=C4=87?= <duje.mihanovic@skole.hr>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 095/623] clk: mmp: pxa1908-apbc: Fix NULL vs IS_ERR() check
Date: Wed,  5 Feb 2025 14:37:17 +0100
Message-ID: <20250205134459.858725645@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134456.221272033@linuxfoundation.org>
References: <20250205134456.221272033@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit e5ca5d7b4d7c29246d957dc45d63610584ae3a54 ]

The devm_kzalloc() function returns NULL on error, not error pointers.
Fix the check.

Fixes: 51ce55919273 ("clk: mmp: Add Marvell PXA1908 APBC driver")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/d7078eb7-a7d6-4753-b453-8fce15245c34@stanley.mountain
Acked-by: Duje Mihanović <duje.mihanovic@skole.hr>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mmp/clk-pxa1908-apbc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/mmp/clk-pxa1908-apbc.c b/drivers/clk/mmp/clk-pxa1908-apbc.c
index b93d084661985..3fd7b5e644f3b 100644
--- a/drivers/clk/mmp/clk-pxa1908-apbc.c
+++ b/drivers/clk/mmp/clk-pxa1908-apbc.c
@@ -96,8 +96,8 @@ static int pxa1908_apbc_probe(struct platform_device *pdev)
 	struct pxa1908_clk_unit *pxa_unit;
 
 	pxa_unit = devm_kzalloc(&pdev->dev, sizeof(*pxa_unit), GFP_KERNEL);
-	if (IS_ERR(pxa_unit))
-		return PTR_ERR(pxa_unit);
+	if (!pxa_unit)
+		return -ENOMEM;
 
 	pxa_unit->base = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(pxa_unit->base))
-- 
2.39.5



