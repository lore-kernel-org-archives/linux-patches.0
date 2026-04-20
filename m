Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39695330B14;
	Mon, 20 Apr 2026 16:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701144; cv=none; b=dvwMsEo8oVa4fE2prpH2Cew/U0ug2/AiB3Tw0kPgmbFyEJM4NvH2a9qMTzumEEVw5tf2CIRoEDpqpQ61Fy8tAUSWqw2nMLOxrO6/5HkkJVtYdNWP/x7a9ktNY3WXEkpeqnbHctVzL8GHSes6Dr5og0YT9+2SinhcuuOD0LuKGx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701144; c=relaxed/simple;
	bh=FXOJPDU0g5+tMs52Y8u+OgU7PoL92FliyQlBwXwH0XM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cY/1+h2uUeBGsatKbgl8SuSebc+j3mG+gDoJrnQRXHF1tBxNf7ReHHzACbmtpL2Y7pAIEF2dF1k9cs53YHFR1wNUhBlBvonWw3SACr2Wk1XvhZhgdeyEM+I4FafG1UrZqfkQ9SYfMxw66zDOeIBCNCGxHD7tyUC8Tnr2HEnjkYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i4e/NnFn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i4e/NnFn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C58F1C19425;
	Mon, 20 Apr 2026 16:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701144;
	bh=FXOJPDU0g5+tMs52Y8u+OgU7PoL92FliyQlBwXwH0XM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i4e/NnFnWmLsR5wxjRvC4pJEA/hdgdWE7uioOoR0eOWKkbMkoTdYkinWDuZSYj+w4
	 abLQvvxHZY0uc2BoG4RV9hT8HiuT68pQdlckaLaLFpEmz1/sFlfBZOuB1eIhM7YESt
	 ukH5oWWQZsqN+21fRxLW2FpyTy5aNcHxLRNdv/iw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>
Subject: [PATCH 6.18 198/198] dma-mapping: handle DMA_ATTR_CPU_CACHE_CLEAN in trace output
Date: Mon, 20 Apr 2026 17:42:57 +0200
Message-ID: <20260420153942.744563698@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


