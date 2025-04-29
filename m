Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C7BE24E019;
	Tue, 29 Apr 2025 16:55:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945743; cv=none; b=gg5U8zIOAF+FQERZwc1Yw1pAfqpoa9xagEQuwNjWBcRRTDQ5QWohzrMIU3m9G9rtUOUC0zMQjZjPCQdpZRR25hg/fAFGJ5OQ+ezYW9wBtYWxDf5oAysD35oPSV5ncPEQp4jPQvrrEvojGzDeuUTl56nQimEYz09UAFIzOPtey5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945743; c=relaxed/simple;
	bh=5txDIzztJYIFzaBXw9aG3p53sJ9CKfGoeiM0AfJyABQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HR24arUocX80T+K9j9kTyEPrarAMsiIsfowDu4HhxBc+uixwM+g41l+3GYe+vnw3t2Ez+2GaE6Dz6LZ+8gq4ry1O8/JTwyAaCV2hr3n9WtQNDC+eJMq338UL4nRnCigHnofHF4lIcIFrYP8p/s80Kd4NhwB2vNW+mQfis2ZXOuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOF72uzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOF72uzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3A8BC4CEE3;
	Tue, 29 Apr 2025 16:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945743;
	bh=5txDIzztJYIFzaBXw9aG3p53sJ9CKfGoeiM0AfJyABQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOF72uzptQfWoFXeBEGyhiyjKK9uP7Q6n3EQ9d7DbfxcSCfSfoz13uyqYLQx37v+P
	 5SRZe6O6c0iAYg6WhI42jYLzavUf6LYptDkSIMit9aKNIQ/8+cdhCldEbxXMpaH85m
	 5hz/vG7oFmhyQQ+0E5n33+HJrH25X11k+zKuG+6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 035/311] dma/contiguous: avoid warning about unused size_bytes
Date: Tue, 29 Apr 2025 18:37:52 +0200
Message-ID: <20250429161122.469526042@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 055da410ac71d..8df0dfaaca18e 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -64,8 +64,7 @@ struct cma *dma_contiguous_default_area;
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



