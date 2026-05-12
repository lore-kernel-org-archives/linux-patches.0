Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88DC93EDE49;
	Tue, 12 May 2026 17:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608170; cv=none; b=SRtwZpqejcPhnPSYu3ruWADyZ5JbXtlVy0M9dFkA4Y46zKR8Jd0t9JtfKkc6q8XI1ndRQ8jUNQ9G/44BRB6D67G8QjWxRB75FmxbGGN9ENVYVSVkQRL0VM60KruC6IrUNgMVNjLlY+Ucr64UFvgPnETe8SGSUftfVQttmQzR1fM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608170; c=relaxed/simple;
	bh=VrT9Aj9I+rq4TBk30mzH21keLP7D1swrLroH4Jei730=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtPPQiDQanpsk6e8cS0QusOL9XJEfRz5M85QS3+p2fz2hfVokz08X745pduBDfel7TEnoZw/aQ8gYqAtFHa/4SHRi1LwFQIGPZEMcCz7f4tthkerJPMfz70Z1vpb03GdjFkTWyTKKk56UvgqD2oCItI+52UAiCG+AZjrZPDpty4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PrDeAck7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PrDeAck7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D0DAC2BCC7;
	Tue, 12 May 2026 17:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608170;
	bh=VrT9Aj9I+rq4TBk30mzH21keLP7D1swrLroH4Jei730=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PrDeAck7I8uNJdzGB6Jsrz74kgFQYC5FBraA2Vh6THRY3G8yWQt28fDSwl8xh5i/g
	 kG8TpTJZL5Ht45aIprFtI4yyhGhz7iCN3QSCwBAH+nxSagqyIxhx2B1dLf0W+4GqAY
	 ED6I90AHssYnngnap2rXqKIMl6tD/v0jLyK1bOVs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/206] dma-mapping: drop unneeded includes from dma-mapping.h
Date: Tue, 12 May 2026 19:40:33 +0200
Message-ID: <20260512173936.694186737@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit be164349e173a8e71cd76f17c7ed720813b8d69b ]

Back in the day a lot of logic was implemented inline in dma-mapping.h and
needed various includes.  Move of this has long been moved out of line,
so we can drop various includes to improve kernel rebuild times.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 3023c050af36 ("hwmon: (powerz) Avoid cacheline sharing for DMA buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/platforms/pseries/svm.c |    1 +
 include/linux/dma-mapping.h          |    4 ----
 2 files changed, 1 insertion(+), 4 deletions(-)

--- a/arch/powerpc/platforms/pseries/svm.c
+++ b/arch/powerpc/platforms/pseries/svm.c
@@ -8,6 +8,7 @@
 
 #include <linux/mm.h>
 #include <linux/memblock.h>
+#include <linux/mem_encrypt.h>
 #include <linux/cc_platform.h>
 #include <asm/machdep.h>
 #include <asm/svm.h>
--- a/include/linux/dma-mapping.h
+++ b/include/linux/dma-mapping.h
@@ -2,15 +2,11 @@
 #ifndef _LINUX_DMA_MAPPING_H
 #define _LINUX_DMA_MAPPING_H
 
-#include <linux/cache.h>
-#include <linux/sizes.h>
-#include <linux/string.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/dma-direction.h>
 #include <linux/scatterlist.h>
 #include <linux/bug.h>
-#include <linux/mem_encrypt.h>
 
 /**
  * List of possible attributes associated with a DMA mapping. The semantics


