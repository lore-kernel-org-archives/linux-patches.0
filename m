Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A3F1C68C;
	Sun,  1 Sep 2024 16:30:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208248; cv=none; b=Hs5IBEu2scrW09I7s6mTzwtGUUZBxCRNLw3zMWPmFK3LzdQo6C9qDlrPvYHh74SJWUHUe/yvNbAqSxktj47hL2qTKf5tMjuoDJGSGTPcPgTbfAm+vyDRJExhWc+t2HEnb7sC8Ui8l0EHkw9ljnwYXWH7TRaQYUfJ1whkax52k7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208248; c=relaxed/simple;
	bh=V4vFxRfyrABYDfuii31S1p6NlK7hX1ejoQ/JCpXvCyc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CizVKNRcih9YRnIC8xnI6gDn1zIJGf1eFp1ueVKf3GRBx8bVBlTUhdtszkgFWvifzJoocV7Dw2NTzlNeZlWNNUNlaeymyMs4aD2IcRr+Mm3kx4ZPgvsFCocK4ZI1k6jxNIAqq6+sRO78mrj1MVF7ptVxbFqCZtq158HxBgDxOvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwkvViHn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwkvViHn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A66C5C4CEC3;
	Sun,  1 Sep 2024 16:30:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208248;
	bh=V4vFxRfyrABYDfuii31S1p6NlK7hX1ejoQ/JCpXvCyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwkvViHnSd+3YKkidIak+1talp9c2DNf0n6W81Dbl/qy/tEfzxgR4J47RDZNadiMw
	 21s8dAfE1MF/F+TS2kCJTz+KJqC9M4pcDP9cxWhQAX+RXB2WPwzb+X7Z9schanEkyX
	 xy3Jw0Xsw5Vu/K1LCbNVR32XB+jrVvctnrT863mY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Wang <shankerwangmiao@gmail.com>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.10 006/149] LoongArch: Remove the unused dma-direct.h
Date: Sun,  1 Sep 2024 18:15:17 +0200
Message-ID: <20240901160817.705434519@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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


