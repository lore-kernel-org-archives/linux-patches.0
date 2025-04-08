Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5150826F472;
	Tue,  8 Apr 2025 12:57:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117040; cv=none; b=hqgtUV0gjM1fUxcqjWV75Dqzn6cBNzOBCMkR6zacoHgwFcIh6kov5Fpndd3gSz1jASiHSgHbcO0Re/gPc1cEVsf5b9FIWK2nfme/NdA8W2mQ914Zy+qlSy2DjiS+h15BYh2LDzG6g0TCeZhMmQt6OcnPJiSkZw0jH17vQveerxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117040; c=relaxed/simple;
	bh=kDDmZLDCwn9YI++ns5kQJsSMLSaBPdtrPh/BsYP7W5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JecDNupzC2VZjZX2600N3AM91IRZO6lqWsrxqfLhVMalMgQkON8JHUJhDBLF0QuWraQtVtt3hu/+NrgbVrzpzD/NxMFTPcHVt0WlfPqPFT0r/LEfbJG7uGB8Uq8NzFiBO+m6BF63Lg5fSvVVr0rH0pe/ZIQX2Igr+iSNvROoEX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VtIobWoz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VtIobWoz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71D77C4CEE5;
	Tue,  8 Apr 2025 12:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117039;
	bh=kDDmZLDCwn9YI++ns5kQJsSMLSaBPdtrPh/BsYP7W5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VtIobWozu2Br8GfUMUWNa16GTFmNTCr217yaxnzskITg1sWStI7S42+vh2+ADeXPW
	 DT0v6qgRuf78oPBOnF4yu3tL3EgSEItdNy0IIVdX4QXnBDe52YyE0VzwE6E+g+kBjD
	 2NCUCBaFb62V/VIw6/hTqekT8jkSmrP9PvNd0ZA0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.12 363/423] LoongArch: Increase ARCH_DMA_MINALIGN up to 16
Date: Tue,  8 Apr 2025 12:51:29 +0200
Message-ID: <20250408104854.318988093@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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


