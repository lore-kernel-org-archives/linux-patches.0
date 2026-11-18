Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795053451;
	b=5SQKrCrr+tv8qSMkes+F3Rh5VOWpdBZoMODImTJ+OWMhjmE6mFlMNAEwIaWU3Zf8zcSi
	 lGkZ2/8Y0m9rub8tfsM3JukcNwD76o4rcPBMrJdDWWFTEsKYTmnWKb5a8Y4UDi0rqAERD
	 6mwpA6Eps+vrxW8wjsEO3Na682jwNQRGNNQuMHx4BZfITqFste3s7EAvFiJgpltDnKFd2
	 6tXzpskOn64b7ARx4xBkFvKPRFwtKA26nWTAEYdDHw63fbcDYCMBFiH/UBlFxG81N3oJD
	 u7AxWMbDIMW0s362UtyBFwdoBvgd4zaGGXl07JkibqVu5RfPqjX1/Bcj74sDa8kB8Jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795053451;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xcyVbHC/p3mI9/eXurKEXoITFx9io5uDhunTWWh2bLw=;
	b=bqY0GXkbufQU3AqTD++eutK3AML6sCalHuCE/wJ9KwyjYXETLg2zws80UengP5IlPOmH
	 1SJSytKVNQmRVJ++JNBgz2vb33XiYpQSM36KpW1KJ0dfXVXQQMtbd9x89pXIlWQpkhvYj
	 VBZUuK5oPblxzP4Jl3to5dhMM4LZ1N316DRgYJ9v2Nj4N6jEPEY1szYM2xDQTVESX8HO+
	 Tf3BRzXbrcZP41puqPFgSfmikZIsbyymfl7E5VbBHtvonk62IAmvjMop79GBslsaiYU6S
	 xWpNu6xT0gQb4i+nXhOD/EobWQVqPqJ/FnFCLRWSf3XZIwwZOQ0njCN54CkNCUxMDqQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTSKxrPg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7CE0606A31C;
	Thu, 19 Nov 2026 01:57:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zTSKxrPg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64BC1F000C5;
	Thu, 19 Nov 2026 01:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795053451;
	bh=xcyVbHC/p3mI9/eXurKEXoITFx9io5uDhunTWWh2bLw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zTSKxrPgJEo4u2apPtdgNVkPv3bQLPh2yB/MnQQ5PnuYkzeX1201nTOwvVUf51Nl8
	 pUtZW64CciPut0tUTaqGAN8zFJGkTEcyygdHeIeboPLEZvd17b7Vp+J0u47CL3FSIh
	 8i0Kejg0JhTdHfKDlS1GnzKYQ7Tv+yk4HGhdQ7sw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0923/2214] MIPS: mm: Fix the cache error vector jump for XKPHYS kernels
Date: Wed, 18 Nov 2026 15:43:19 +0100
Message-ID: <20261118150049.278192762@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Imre Kaloz <kaloz@kernel.org>

[ Upstream commit 30b76362f80d39d80f1197c88b284d9fa7952356 ]

except_vec2_generic jumps to cache_parity_error with a j, which cannot
leave the vector's 256MB region. An XKPHYS kernel such as IP30's, linked
at 512MB, is outside it, so the j targets an unbacked address and its
speculative fetch raises bus errors on unrelated fetches. Jump to the
handler's uncached XKPHYS address instead.

Fixes: 7505576d1c1a ("MIPS: add support for SGI Octane (IP30)")
Cc: stable@vger.kernel.org
Signed-off-by: Imre Kaloz <kaloz@kernel.org>
Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/mips/mm/cex-gen.S | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/arch/mips/mm/cex-gen.S b/arch/mips/mm/cex-gen.S
index 45dff5cd4b8e7..b4c027b0421dc 100644
--- a/arch/mips/mm/cex-gen.S
+++ b/arch/mips/mm/cex-gen.S
@@ -8,6 +8,7 @@
  *
  * Cache error handler
  */
+#include <asm/addrspace.h>
 #include <asm/asm.h>
 #include <asm/regdef.h>
 #include <asm/mipsregs.h>
@@ -37,6 +38,21 @@
 	nop
 	nop
 
+#if defined(CONFIG_64BIT) && VMLINUX_LOAD_ADDRESS >= XKPHYS && \
+    VMLINUX_LOAD_ADDRESS < XKSEG
+	/*
+	 * An XKPHYS kernel may lie outside the 256MB region a j from the
+	 * vector reaches, so jump to the handler's uncached XKPHYS address.
+	 */
+	PTR_LA	k0, cache_parity_error
+	PTR_LI	k1, TO_PHYS_MASK
+	and	k0, k0, k1
+	PTR_LI	k1, UNCAC_BASE
+	or	k0, k0, k1
+	jr	k0
+	nop
+#else
 	j	cache_parity_error
 	nop
+#endif
 	END(except_vec2_generic)
-- 
2.53.0



