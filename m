Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059185;
	b=qODc88S54DfhhZdxrqEQtxlMvE3pcGql8JZ5UER/4wiH/I/9mpKXhgmf1HWSI6CSRulv
	 acFvdr0jMi+wa/VtTsyXZxPFkohSk1ACcEziJYQvir06Zq6IZIUgm8HwQel0hYOnVxIsD
	 O+zjqwW2B5yQuvL0qFB+jBQ/Ya+jmfg/jLUQCKeBv7/b1DkmQjloMzyYEB+49ABSXfPdf
	 16HL6Q57Ydw2LVWlQdXjzRG1q/cpYNQ2X988qUjGPZdyQ67cj+IrU9wqSYVidPwe7Qaku
	 0jTxT/0XnlBUQYzA/2BQQKuoO972Bj2XBjo/JWgRPZW3ZYvyovf49Larhpb1MTl1nYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059185;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qUiXDEAzdGZYFfBRgavj02VySDj1nN98bQmz0TeHjiU=;
	b=0GXBtDCRdiPAcgmf4wxA6++n3aMWS3ZCR6Xkd3KusDogg/epln7RGflsnSfaSPZGL4F8
	 iQA+NJ7l9HGQJdWWAYrUTW84K7oL9P3q86MhBWuUTC7jgce7PWzbXcHOarEOtBqxxJYBU
	 gEo5yaCxw3hAom4wdoboq8EgWbPs/Nd0z+Tb0oCskS+Ia0cck4Fc6EP+pYjniZdtQ9N28
	 Uk7tEPPXtgMmtFjEHSX2iYYVX1BYB2wIp6hSiIsQgTIamAjGg3VNWa/7PMjkfB4hz3mZ+
	 zJ25ch8Z+8q+F8AI/8QPmlDOfReIcrUamhLSvjhi4P2FFu8W+o3GR60GHEgSeIZ92/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pa84EUHB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D19DA606A31C;
	Thu, 19 Nov 2026 03:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pa84EUHB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A8FF1F000C4;
	Thu, 19 Nov 2026 03:33:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059185;
	bh=qUiXDEAzdGZYFfBRgavj02VySDj1nN98bQmz0TeHjiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pa84EUHBHDeRWLdUJ06+UstUTTjoSB0cKGSSWahIGx66mQyphcgavXpgvATq0u/yd
	 VZC6etwbceWMIwUc1AVv9GU+wsV155eAZJQ4cuffLs9zrhBGcoYfD1CZNzeuZVB89P
	 HGA7B2HkON1WEpDtf3CpmoT05x4IZqM5OY9czW08=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Imre Kaloz <kaloz@kernel.org>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0750/1848] MIPS: mm: Fix the cache error vector jump for XKPHYS kernels
Date: Wed, 18 Nov 2026 15:46:28 +0100
Message-ID: <20261118145947.924160363@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



