Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D7024111D;
	Tue, 29 Apr 2025 18:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949743; cv=none; b=gUProOeIZLe35vBbkfzu8D96V6WFqGy8WiM2GaGbEnyAl02DT/Fp24/7wVo0lh92+6QXk+OFiPaefIhkU2ZszxAPbiuEwW1FGl1DNqpOF+yVeB2HbLEhPOfVLmshILJpzp+83wB68+WKW1ZA+NjD6MwQjis2FHvuppxTelKYI1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949743; c=relaxed/simple;
	bh=qLDe9IbSstHhWqExIl9eP8x9vl/ZM2BCsIjvJ/3c9H8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZmjqcDYSXz9y+Y3c0v4PucBljAiQFy0iddzqnicUL1HuQVZKlQ7gW+u4ETtFy23XRBie33nsY58IHxn+xx5/Nv12vrcF0CItgcXCo8FFQBr/AfzKZxI+N6PqBxwvHL2Z7l7jAfKZRm6kAZaOLHBdbKCgSjPKh0YDjnhNroRJU0g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=004r5TTO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="004r5TTO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C79DFC4CEE3;
	Tue, 29 Apr 2025 18:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949743;
	bh=qLDe9IbSstHhWqExIl9eP8x9vl/ZM2BCsIjvJ/3c9H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=004r5TTOTJ0fcPQai3eJfS2sXMaJ9X8+PKQ71NzRwfmFaRSyTvrE32BmjVcPWULO7
	 96RLBcJCTjhMoAUaYAaXlKVkki3iNDBHWopXqo6TMeHoqJOB1hvwFCHrcsgS4YtL9+
	 dH/vwS63h1KdAUMyozGNJhr5OIK9UEWfHlcHVICY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 043/167] dma/contiguous: avoid warning about unused size_bytes
Date: Tue, 29 Apr 2025 18:42:31 +0200
Message-ID: <20250429161053.501189801@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



