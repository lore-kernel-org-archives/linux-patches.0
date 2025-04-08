Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421C7276048;
	Tue,  8 Apr 2025 12:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115973; cv=none; b=Nu4Ewk5IbYfDtlE5DOUy8Q7IpxuqIUT01X8eVlbXNbjpnkFvF25tkiQHuzQ2UYCUnqcwGxNVx66X7J4LdjHeyEY2oEbGIieakGVbh70Z9i2i4dtbUHSuOCxXphXlnpRP4zr1ybXYvYmwM1EuZwFL12N3LtO5D2H2rQ2qZAAbhxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115973; c=relaxed/simple;
	bh=RA+okFfYB2KxxGNWUTh+Y7BrBsIVwC5ZqQMTUN+jluU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HCr6oE2Ur7iePjeaX6CzSwVDt5VjR/dzZLFBHZVBgjW/cTwqJDv7mmoOl5UrmrYXtHbaNOPWJpcL02gNq8ujAvkDsLpowLJu1laEHC7rub0aP08fJiOWa40ZdaN9pzOx4gnJ4G33XIdHI+qi0HjQZfllx/kV/2eCdrXTzE5lykU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rjLYKRm3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rjLYKRm3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69FFC4CEE5;
	Tue,  8 Apr 2025 12:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115973;
	bh=RA+okFfYB2KxxGNWUTh+Y7BrBsIVwC5ZqQMTUN+jluU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjLYKRm3THlMgddVCkFkVTDoCf/3jstrOrT7294/OX4/w9gHZFHjCCnywDbD6yHLX
	 lL5b8CfUm+UitfBl3OxQBq/7lKnl47njhHWIslfsBx0LP/nsjqVuwsOc8ZMQKCmKZc
	 keBitnRrNY3hQOgQWmGKIkbQM9GSfjMKg3d4+ubo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.1 174/204] LoongArch: Increase ARCH_DMA_MINALIGN up to 16
Date: Tue,  8 Apr 2025 12:51:44 +0200
Message-ID: <20250408104825.422040058@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

From: Huacai Chen <chenhuacai@loongson.cn>

commit 4103cfe9dcb88010ae4911d3ff417457d1b6a720 upstream.

ARCH_DMA_MINALIGN is 1 by default, but some LoongArch-specific devices
(such as APBDMA) require 16 bytes alignment. When the data buffer length
is too small, the hardware may make an error writing cacheline. Thus, it
is dangerous to allocate a small memory buffer for DMA. It's always safe
to define ARCH_DMA_MINALIGN as L1_CACHE_BYTES but unnecessary (kmalloc()
need small memory objects). Therefore, just increase it to 16.

Cc: stable@vger.kernel.org
Tested-by: Binbin Zhou <zhoubinbin@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/loongarch/include/asm/cache.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/loongarch/include/asm/cache.h
+++ b/arch/loongarch/include/asm/cache.h
@@ -8,6 +8,8 @@
 #define L1_CACHE_SHIFT		CONFIG_L1_CACHE_SHIFT
 #define L1_CACHE_BYTES		(1 << L1_CACHE_SHIFT)
 
+#define ARCH_DMA_MINALIGN	(16)
+
 #define __read_mostly __section(".data..read_mostly")
 
 #endif /* _ASM_CACHE_H */


