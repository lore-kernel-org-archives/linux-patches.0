Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8050F33B975;
	Mon, 20 Apr 2026 15:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700558; cv=none; b=eWTBbYgT0TL8WDWMtxbnSOIf0a0ues13209p2CnS8jUef8ggUrG32YsIQoJ5SkrBbeQ4TArqTwqhLJKO1gCTHpM12qeioF1DqLtWs47Rwuv8kf4DlFwN+Tz+fD9ZU8UO7TNbHai5W5EnLFbf95ldElSTvC053sv8ZMLUWyJTetU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700558; c=relaxed/simple;
	bh=VE9ZQgCYvce1i3wqLprB/l8W816ys9kZ4BJDYk581+E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pF/AUqNL7gbJWVVcIEHgGpc6Czw4kSWM4RmPiCMeYXaONcWY4CPHlMmoOvMOCfndMV0p1Ke9PcYAJCTUo60gqu0ULC0D+gJsnk7Xz4M6r6h2EnKT1bOh2dPNv1rLOVzrN/G80aqYg6ijFGCHTpNYEzs1mT71q015wVI/BuF25tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K3xor23m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K3xor23m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC32FC19425;
	Mon, 20 Apr 2026 15:55:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700558;
	bh=VE9ZQgCYvce1i3wqLprB/l8W816ys9kZ4BJDYk581+E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K3xor23mKyv7iyzPOP/74jguD+SIOF97YP/3f39bWLfXbESXsjCrl2vQO7v56DcZz
	 WnCVUR8AuQ9gOdVkB4PPkntwbo3kAO9lUiX/A1H7m1LymtC5eviASw94toKyFvtg+X
	 +5POW645EWpajT2z+m+CFjrAOIiBmbsnkm6DrwBc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.19 220/220] dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
Date: Mon, 20 Apr 2026 17:42:41 +0200
Message-ID: <20260420153941.947487194@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

commit 6f45b1604cf43945ef472ae4ef30354025307c19 upstream.

Tracing prints decoded DMA attribute flags, but it does not yet
include the recently added DMA_ATTR_CPU_CACHE_CLEAN. Add support
for decoding and displaying this attribute in the trace output.

Fixes: 61868dc55a11 ("dma-mapping: add DMA_ATTR_CPU_CACHE_CLEAN")
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Marek Szyprowski <m.szyprowski@samsung.com>
Link: https://lore.kernel.org/r/20260316-dma-debug-overlap-v3-2-1dde90a7f08b@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/trace/events/dma.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/trace/events/dma.h
+++ b/include/trace/events/dma.h
@@ -32,7 +32,8 @@ TRACE_DEFINE_ENUM(DMA_NONE);
 		{ DMA_ATTR_ALLOC_SINGLE_PAGES, "ALLOC_SINGLE_PAGES" }, \
 		{ DMA_ATTR_NO_WARN, "NO_WARN" }, \
 		{ DMA_ATTR_PRIVILEGED, "PRIVILEGED" }, \
-		{ DMA_ATTR_MMIO, "MMIO" })
+		{ DMA_ATTR_MMIO, "MMIO" }, \
+		{ DMA_ATTR_CPU_CACHE_CLEAN, "CACHE_CLEAN" })
 
 DECLARE_EVENT_CLASS(dma_map,
 	TP_PROTO(struct device *dev, phys_addr_t phys_addr, dma_addr_t dma_addr,


