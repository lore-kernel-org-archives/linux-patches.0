Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB740253F31;
	Tue, 29 Apr 2025 17:22:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947375; cv=none; b=QLezRNbdJyHBmskLMGIPWgAe9wFO5c1df1CDTmXh1Wfckq/CjM5GxmfUagWIyYa1lf0d0vr4JV8gatdQ4pycZavHcqheqJJEBaInXJ+D6VPgNWUHDnHc89mH6SNgg3aRLIB/WxueuSCjaZM4OuKkXhYp/yvAN2/d3+Z+MLlcxKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947375; c=relaxed/simple;
	bh=0jLidGhWp4drxHMu7Kg5YGRBKsJL9VR5jIISR+/AUpo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=saGw1moQ5ZELbY20h1qiKapXzV93/KT2NtbnACJNBgoei+rT6h049ra5aQQLYDTmihfulUxuWU444VVbzYuTYYxYrw0CGyB0IkIuvrCdQ1C5J8lA6rP2PhPlClojo4NiBT/YRjI9oxrFAQOmZsV8WeWGHrW7051TOytdL3B9HRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Sx+ZH7q7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Sx+ZH7q7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 58A1DC4CEE3;
	Tue, 29 Apr 2025 17:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947374;
	bh=0jLidGhWp4drxHMu7Kg5YGRBKsJL9VR5jIISR+/AUpo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sx+ZH7q7xdiKWdtAlqT2lFu3/VcrWGA7kN4Mb3YQMoJx5MoZg6aOmIPlOnWLqZAzS
	 0RnLlWDGB58xdKGpOpEgZ1IHCrjClMEDdQR/T0s6MLCZN+Y1qnGVbHA1xwSSaG8f6+
	 9XKeSgEFryB2DydfKmyp2bhP9Bm4Wjc8zpNhl8Gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 230/286] dma/contiguous: avoid warning about unused size_bytes
Date: Tue, 29 Apr 2025 18:42:14 +0200
Message-ID: <20250429161117.398311921@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit d7b98ae5221007d3f202746903d4c21c7caf7ea9 ]

When building with W=1, this variable is unused for configs with
CONFIG_CMA_SIZE_SEL_PERCENTAGE=y:

kernel/dma/contiguous.c:67:26: error: 'size_bytes' defined but not used [-Werror=unused-const-variable=]

Change this to a macro to avoid the warning.

Fixes: c64be2bb1c6e ("drivers: add Contiguous Memory Allocator")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20250409151557.3890443-1-arnd@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/dma/contiguous.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/kernel/dma/contiguous.c b/kernel/dma/contiguous.c
index 16b95ff12e4df..3a4e094e4b1fb 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -69,8 +69,7 @@ struct cma *dma_contiguous_default_area;
  * Users, who want to set the size of global CMA area for their system
  * should use cma= kernel parameter.
  */
-static const phys_addr_t size_bytes __initconst =
-	(phys_addr_t)CMA_SIZE_MBYTES * SZ_1M;
+#define size_bytes ((phys_addr_t)CMA_SIZE_MBYTES * SZ_1M)
 static phys_addr_t  size_cmdline __initdata = -1;
 static phys_addr_t base_cmdline __initdata;
 static phys_addr_t limit_cmdline __initdata;
-- 
2.39.5



