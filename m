Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 102C042DFFA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301159; cv=none; b=BOOqYDGZqNZ/DblI/T/phawCkpfHTKuzLheALbLOpj/UioF6QnGbkPV5i1sf5XpjeMkYPlL1L+ITT7hndyicaA5VYFqWgD5kRBzVsrZc6jquly2m4r5PYgSLOaJqfxQ575wit0NgGSU1byp8ZDss3eupVxJQhrCzqkKybwfkt1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301159; c=relaxed/simple;
	bh=dUjo4k5J/KvXhmTqVg7UMWfUV5hSPL6zhpvc9ge/hx8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a2XBI0ZrUdSAbDOw9m6g9v956MnoNdRN3mHLq+g785Q/pL0kiKlNv8ThyYaAVrexuA8yowHQkTIP0q+QXHMm6RfkrPx6jJUypyqRNf5JWPL9Y7Nc5FcVGfDSVQruh2RcE4tFWj4R6fFkIuQ2+WKEzRSb0gqD1BZsvy6Gk5PE6lE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=l3en98of; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="l3en98of"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B8B0C19424;
	Sat, 28 Feb 2026 17:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301158;
	bh=dUjo4k5J/KvXhmTqVg7UMWfUV5hSPL6zhpvc9ge/hx8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l3en98of0Hv6aPH7dR5ZvK1g/QsloZVa8ukFas9LkwJbSVABqXYx5I5UVroIehnIi
	 tGca7vfJy3zFnb8CbbtBNwAN0X2SsBZvnhBz+M0vLXWVa7JMUFHz6HFP17FLMJdlvQ
	 g/WmSEls0OHvA/s1nocsMuG8MroBITWBPAJ2LS8go0hEFlwTaKvRFgnRvTzLvruHM4
	 h9vK1SQvEqfR80GXfxWYD5tth3oDbeiLvowl+wrHTVEr2oqndBVYxAQQqYDpny69zb
	 mi9uYWzEokXmufEqA68EHnW3zpQJfku6iIXpqbdJfmO3kYzKyBfQOt3g23I/ZTcBHi
	 f0F+u+R4YbqlA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Amelie Delaunay <amelie.delaunay@foss.st.com>,
	Eugen Hristev <eugen.hristev@linaro.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 323/752] dmaengine: stm32-dma3: use module_platform_driver
Date: Sat, 28 Feb 2026 12:40:34 -0500
Message-ID: <20260228174750.1542406-323-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Amelie Delaunay <amelie.delaunay@foss.st.com>

[ Upstream commit 0d41ed4ea496fabbb4dc21171e32d9a924c2a661 ]

Without module_platform_driver(), stm32-dma3 doesn't have a
module_exit procedure. Once stm32-dma3 module is inserted, it
can't be removed, marked busy.
Use module_platform_driver() instead of subsys_initcall() to register
(insmod) and unregister (rmmod) stm32-dma3 driver.

Reviewed-by: Eugen Hristev <eugen.hristev@linaro.org>
Signed-off-by: Amelie Delaunay <amelie.delaunay@foss.st.com>
Link: https://patch.msgid.link/20251121-dma3_improv-v2-1-76a207b13ea6@foss.st.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/stm32/stm32-dma3.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/dma/stm32/stm32-dma3.c b/drivers/dma/stm32/stm32-dma3.c
index 50e7106c5cb73..9500164c8f688 100644
--- a/drivers/dma/stm32/stm32-dma3.c
+++ b/drivers/dma/stm32/stm32-dma3.c
@@ -1914,12 +1914,7 @@ static struct platform_driver stm32_dma3_driver = {
 	},
 };
 
-static int __init stm32_dma3_init(void)
-{
-	return platform_driver_register(&stm32_dma3_driver);
-}
-
-subsys_initcall(stm32_dma3_init);
+module_platform_driver(stm32_dma3_driver);
 
 MODULE_DESCRIPTION("STM32 DMA3 controller driver");
 MODULE_AUTHOR("Amelie Delaunay <amelie.delaunay@foss.st.com>");
-- 
2.51.0

