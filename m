Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41283251783;
	Tue, 29 Apr 2025 17:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949424; cv=none; b=pfp3uyabvMJXDelGr4BwC/WA+hjCxZHdhd1ZE8wRXmDycOduZFwQnD6AZRm6XXKEyHCRdNO2oxuGod4XI0QsKjMVOe9ar7hGqBAipsvXQ0NqkQNqJyInvowJL2T2dVDZS7E1mYBkNXUbRkR/9iOTWbGAVgwaMrRYz98T1rAcdig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949424; c=relaxed/simple;
	bh=UKx5Va87/tCHcxfOusLB2r4rMqntv88ZLbvkCgMJpCs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iMcUBPStzCQWpPa5NHlmMCi8o3wGvRfhiC8m36nA4tch3drFDUpHlRge1BmBqGM776hOHQq1nUHqKaemB8BnPDUNfwAOFv6nMfYCXPuTRo5nk5whyKrrGIo5FTRlxXshtcFRZv01X+e0SWRSqkzArkKZjgJidWICNEDDzgskWYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyPx4Lev; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyPx4Lev"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B03EBC4CEE3;
	Tue, 29 Apr 2025 17:57:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949424;
	bh=UKx5Va87/tCHcxfOusLB2r4rMqntv88ZLbvkCgMJpCs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyPx4Lev1zwGkYyvkh77C0NDAguuIF0mOcEEfCOAYEXmgFI3InXYmIjpN+j0+g4/K
	 oba2tBLRoOM0WCvhqW0wEyX7V+htKmWvxapbxSRALF4wW+7LEeKV2F8qSnjcVBSAtZ
	 Rp6FnBsZHXeUD1XClaSFrLVEz2PG08AN0R/W9CrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 286/373] dma/contiguous: avoid warning about unused size_bytes
Date: Tue, 29 Apr 2025 18:42:43 +0200
Message-ID: <20250429161134.874594031@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 6ea80ae426228..24d96a2fe0628 100644
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



