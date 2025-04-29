Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2667227E95;
	Tue, 29 Apr 2025 18:11:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950282; cv=none; b=rgZNQ2Y00RGxxuzHZLhSWo3AD/gyem/eziIAjpJueyZEugHz2Piu+4IwzcTIX2ugKYrR9g6T30acTQhF6JyJRwBEOe/XbfI70zl4kWV1O0I/c0xTwnBuXpMBjjztl0GF5bH+UDJdEYQ+EvpVAB0XpnHBS5oOmfiZyPaMt8fhB4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950282; c=relaxed/simple;
	bh=U9Rbo7eN/yHcphgjYbwc/hRyfFwNuFoZN7S/AyKel24=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pcpjk+5yb9S6OaCFS3A73vCKMAyy+PWGIhDc3tIGb2yVCt42oRmbn2K/ur9BnRyJmtelFekR6bJOhvs6pHTRvTJpVQe85kN5fu5a/h2Q3OTV7zWXEk78KaCBrLsSqbV9niBI3PKvHYItqBuATqLPYPNdi6+r056YTD6Zo/7kG30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WC8IHUNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WC8IHUNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E036C4CEE3;
	Tue, 29 Apr 2025 18:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950281;
	bh=U9Rbo7eN/yHcphgjYbwc/hRyfFwNuFoZN7S/AyKel24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WC8IHUNvkspmC118XPzANLD/KwIvJ3SzxooW2b2k+WaDKhPi4shGG8+Re12q+agBb
	 FG27ZJ9wSNZHWS7Kks1d6iDxgvfop1wCwVRkYiu3xp033UMKXh0SwM9XB0v++FN1FM
	 tfpvoG7MWd3zVt0hI7wH3Xor73IM3Xh5qQ7ekxxI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 046/204] dma/contiguous: avoid warning about unused size_bytes
Date: Tue, 29 Apr 2025 18:42:14 +0200
Message-ID: <20250429161101.294803283@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f005c66f378c3..a600819799637 100644
--- a/kernel/dma/contiguous.c
+++ b/kernel/dma/contiguous.c
@@ -70,8 +70,7 @@ struct cma *dma_contiguous_default_area;
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



