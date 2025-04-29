Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9451F18BBBB;
	Tue, 29 Apr 2025 17:26:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947614; cv=none; b=TDKQ7nWpvZdDBcP3l1UhgbFaDwLJroEcttJ6NPV7GDAmYvIp2wE06NvKqflnegOsvrT3QRlcQ2CyWVhHJ45rI+zBWoxyRMllTu6nehKj+scVi/qaxkb3Csv+Nu3YIwoeN5EZ+sS2DoVgqRDv9ofTFAQY0SbaPbLTGwPfQSaWiOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947614; c=relaxed/simple;
	bh=TfdTvi5ahJS1yHfDlqpnKrjPxbrWrs5/IcO/k10XfPM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdSK+DPu2KMUf/aL9mYBIDuy2R77WbZ0YplaTQQ9lxVk45gzvSpNoIkI+BA5ayY9/yS0qmSwPRvpqWMzeAGG2NRqHr5Xj+WMAwMgp9MaoCSSy/V7W/oW5d8oC8cf1yWPPAtAzeahNUxHeSh5A2w8v79K6giShA4ioFJd9KIp3to=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i3zzwzV7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i3zzwzV7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14A48C4CEE3;
	Tue, 29 Apr 2025 17:26:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947614;
	bh=TfdTvi5ahJS1yHfDlqpnKrjPxbrWrs5/IcO/k10XfPM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i3zzwzV77FcCjxJ230rnwUGtBRI+eHBzf15CCpntx+aVfrEBIBsUsYmi+/ai0HcNX
	 5gpfq23sHc8swj8TvS+nq1RV1CK5H2dyNwkZFE0RaYoCtBujtxVAoOoGxvCVg3Roi3
	 KmoIN3yoWOXHiFDC7T52PnsNJZRwWnfAAeogCE2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 052/280] dma/contiguous: avoid warning about unused size_bytes
Date: Tue, 29 Apr 2025 18:39:53 +0200
Message-ID: <20250429161117.252985987@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



