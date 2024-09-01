Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 630E414290C;
	Sun,  1 Sep 2024 16:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207925; cv=none; b=c0aoA4jk+VA21lOMchJWjvJU5dvEC39zWQAhkjXyxWop6X4ud256FAS6IJL3vT8oCGTdXl9qbZDik3vaAqbT+OhXzmmOiwTvfDIHr4jE3qmk2C+SuI7we7O3ppj7a8ilHjD/TNzDPYI5ppo7b5C+cmV/f5gXeOecRS+IZ/+m8vk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207925; c=relaxed/simple;
	bh=aVkLu3Iyt5O+sZXPQGfr1SIBxkRJPf9IoASa19cD2G8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mrj3MS4QHdTsUY8PeQa8kpSZOTfql3AbtZ7es0OCBClBjccNZg3TKrQsW+VHkm1xzlCB7yNyk9yfK8Iwrl1DNnXuGpYL+A9hXq4kgxIJO3CfrGKBGVHL3n1OQzsokwAznlZCuelqKKJ23/CshO350dJ1h+SbEee3C9BOsjn6VSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j0PXiRV6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j0PXiRV6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E3CC4CEC3;
	Sun,  1 Sep 2024 16:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207925;
	bh=aVkLu3Iyt5O+sZXPQGfr1SIBxkRJPf9IoASa19cD2G8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j0PXiRV6ffmPIR3nz7wu9TXMlMs6XEBoF8AeN+pbSPfP65Yt9/Ern/yn+GTG0G7ki
	 dhvVpbkaAqsdsv1Kp0AY0hGCrigvZg9up6NIi9E0cKjyOctKSPAjZajmwVQoqI8tk9
	 Upfn9BBFEsbOl5GhVOu2/ofaLrtnLWrhrl6B8g8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Wang <shankerwangmiao@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 02/93] LoongArch: Remove the unused dma-direct.h
Date: Sun,  1 Sep 2024 18:15:49 +0200
Message-ID: <20240901160807.442910025@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Miao Wang <shankerwangmiao@gmail.com>

commit 58aec91efb93338d1cc7acc0a93242613a2a4e5f upstream.

dma-direct.h is introduced in commit d4b6f1562a3c3284 ("LoongArch: Add
Non-Uniform Memory Access (NUMA) support"). In commit c78c43fe7d42524c
("LoongArch: Use acpi_arch_dma_setup() and remove ARCH_HAS_PHYS_TO_DMA"),
ARCH_HAS_PHYS_TO_DMA was deselected and the coresponding phys_to_dma()/
dma_to_phys() functions were removed. However, the unused dma-direct.h
was left behind, which is removed by this patch.

Cc: <stable@vger.kernel.org>
Fixes: c78c43fe7d42 ("LoongArch: Use acpi_arch_dma_setup() and remove ARCH_HAS_PHYS_TO_DMA")
Signed-off-by: Miao Wang <shankerwangmiao@gmail.com>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/dma-direct.h |   11 -----------
 1 file changed, 11 deletions(-)
 delete mode 100644 arch/loongarch/include/asm/dma-direct.h

--- a/arch/loongarch/include/asm/dma-direct.h
+++ /dev/null
@@ -1,11 +0,0 @@
-/* SPDX-License-Identifier: GPL-2.0 */
-/*
- * Copyright (C) 2020-2022 Loongson Technology Corporation Limited
- */
-#ifndef _LOONGARCH_DMA_DIRECT_H
-#define _LOONGARCH_DMA_DIRECT_H
-
-dma_addr_t phys_to_dma(struct device *dev, phys_addr_t paddr);
-phys_addr_t dma_to_phys(struct device *dev, dma_addr_t daddr);
-
-#endif /* _LOONGARCH_DMA_DIRECT_H */


