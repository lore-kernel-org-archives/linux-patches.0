Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A993AC1C;
	Tue,  8 Apr 2025 12:00:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113633; cv=none; b=lDXFx3ih26dDqlbRrDflsYO+fTcYQVZ6Egkqhg3piQpHAAPQrMiNKSlSV7HlRJ3Bau0WSrxI8gOs+lnAul38gOtf5BgPTrGvrpQaRWqm6n22KEBf9zUWfcTn6NuT2ZrTuXcNRwmTsH66J11aXohfatQQUE+bPQiBTTDiHnel4L0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113633; c=relaxed/simple;
	bh=xGKJg5PBjC9PqskNXrohoEjWiG60MyHBHmCF123Dxf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2LVQ+Iij/1VAOnGr5wonETbTQ3V1wmPaWzsgHuDJMDbuJjvw7m5NcIVjUYl0KmASYwhL61rOR7ooCssCGPxM81vcellak0GqnSei4wswdOPE/NtmEBRSRT4gzTMyoiw/0iq+Gr6nBOwdYSqsR5It8d6XciP/exZj9ADFwydP+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kcRBwjrN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kcRBwjrN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C4CC4CEE5;
	Tue,  8 Apr 2025 12:00:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113633;
	bh=xGKJg5PBjC9PqskNXrohoEjWiG60MyHBHmCF123Dxf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcRBwjrNhmdBggZ0u7Tht3agFUE3Xn+23xl1c6ycsNXOsSYwKDxU09f2zr4DLjsJ5
	 OBIeD9tBI+25rfmMoOqA61agfaHF7djFvC0R1YUHs+ZsvFs4ZQ3QKc3ZqxC99+cB0l
	 NAIKsozgbctk+7SET+j0YFjca1GvONo97kTOr22w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Binbin Zhou <zhoubinbin@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>
Subject: [PATCH 6.6 231/268] LoongArch: Increase ARCH_DMA_MINALIGN up to 16
Date: Tue,  8 Apr 2025 12:50:42 +0200
Message-ID: <20250408104834.817017018@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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


