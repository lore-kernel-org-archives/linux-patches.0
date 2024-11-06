Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ECEC1E048F;
	Wed,  6 Nov 2024 12:56:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897800; cv=none; b=M8Q3XlyshY3cVuXug/8zKOGBmh2BxUWIz3Z2OnKc5QWipiRpDOOPwKgeqYf+eBUjCbYd8hIFrHpRY1RUjvYoummgilOYppapiCe2jE52s+yTANepsj0JlnXY6X3Ur0SeLrhohzWDn3Fg2QWFncPQhpU1yDclWzqn3Fjl+Srzd+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897800; c=relaxed/simple;
	bh=bT43pmgXCqtoUy/XhG8XvYQO1rtM3s3gFYvN0GCTwEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZ9oYpjhfE6LLOlrcNJsgzcTNd4iSk0gQF6GTRN4FYnHdpgVMHLjRJrwwQWOevfjFjf7vZm8AVJZ9sPe+c/5v6JkcwlhocRO53pctgIB/nG9E1bCaiL6DNGX/Te8coT55D2YmgMHBflXkXqUR8MRtHiqWz55eqOtTFjmF3EFWoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LO2/4+l4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LO2/4+l4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAE27C4CECD;
	Wed,  6 Nov 2024 12:56:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897800;
	bh=bT43pmgXCqtoUy/XhG8XvYQO1rtM3s3gFYvN0GCTwEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LO2/4+l4e9zObe5IEt3zg2URrXbmZd5uUqLP14SnVKchtOC15bOzly2SWA+EY1zih
	 5Neyk/kTpZceF0WbHd40lF1xf9qOjpBA/Ti8CJkXQZG9XfORPgaLMKGuKy/MgsJGGs
	 QJJo5UCJ2GM36H+QWgX8F+Fi6YQkjk6AkyjSYT1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liao Chen <liaochen4@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 023/462] spi: bcm63xx: Enable module autoloading
Date: Wed,  6 Nov 2024 12:58:36 +0100
Message-ID: <20241106120332.085995103@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Liao Chen <liaochen4@huawei.com>

[ Upstream commit 709df70a20e990d262c473ad9899314039e8ec82 ]

Add MODULE_DEVICE_TABLE(), so modules could be properly autoloaded based
on the alias from of_device_id table.

Signed-off-by: Liao Chen <liaochen4@huawei.com>
Link: https://patch.msgid.link/20240831094231.795024-1-liaochen4@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm63xx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/spi/spi-bcm63xx.c b/drivers/spi/spi-bcm63xx.c
index ff27596168732..104e3e6e056d7 100644
--- a/drivers/spi/spi-bcm63xx.c
+++ b/drivers/spi/spi-bcm63xx.c
@@ -481,6 +481,7 @@ static const struct of_device_id bcm63xx_spi_of_match[] = {
 	{ .compatible = "brcm,bcm6358-spi", .data = &bcm6358_spi_reg_offsets },
 	{ },
 };
+MODULE_DEVICE_TABLE(of, bcm63xx_spi_of_match);
 
 static int bcm63xx_spi_probe(struct platform_device *pdev)
 {
-- 
2.43.0



