Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060633;
	b=g0V9q/xJAaJ3LpwNC2s4PgaSRfJ4kv18/JKM5Sv1fLiPncJbEyT53jHeA6J+65N//hCT
	 D200HelNUwd18+pcG/i8CJm2UdJvyo+r1m89KyOBGDOcLhOyA7E95MRShzswX1opWv2qT
	 QQIagMUcPL6Qd/JWokbCQDWkwL5HzHYaWb6paLCXApK4nxFdZi73EOWeAhox5cK5XURb6
	 qVPQftBYcfflFTgdUrv9Sl8xJTgdDJxk7nZGrmSEguY/xc2B23tb7qnMiDuu902i40O6u
	 9WXKBUksbLPvmTtb7XAhkzNAbdR4+1NHkBPEAMG8VQ4m/qQMkmWAbhqaNsDes9+OUnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060633;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HYbi810AK9zdqVsnotTDaUsOO5X2GTeFSmmQ8b704Fk=;
	b=p2tZUEkXTgN/QMdWRpDRv/q1rppcUkNl/vMmUrDAgOmIVV32ncB+Pl5Ai2xWDG3e/7Jf
	 mIhrbtaqMl6Hiy1dQF8MCZFCwSklB3VCU4SVjVId0Ov9TXRhZwWe3GlNiBbHDc0Vp9lVd
	 BU2iDqHOUW1Fkms0tgrd2uDAEtTN+AccYEYo3Q1kROSegULTth8KTjbsv4GUY4N8beZRQ
	 yvnqzofj1Lqk+RCC92UWu1ppqbkCq36W5tbxfFB2Kbo1BqlGMZwRq1/F8tGlcSoF5Uen4
	 UBO0wgTtCrU+KCdb8Dik+5LSP3aLkKj/MGDq4gDT1nSDkRUrSRJ/+FHyc7ShSDhVe5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e25yRins;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3EE1606A326;
	Sat,  7 Nov 2026 14:10:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=e25yRins
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A7BC1F0089F;
	Sat,  7 Nov 2026 14:10:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060632;
	bh=HYbi810AK9zdqVsnotTDaUsOO5X2GTeFSmmQ8b704Fk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e25yRinsOCUM6RnyaAiwE4rmyxtw0k4Wja3r51MLeSUcc3zH66dIEIdbncoVUMlHf
	 vKnIySl+yEiWdHbO/MVj3r+uJX3R3h9LdJLqIJXEI6GByCN64T2ND1raWrwryXE8TG
	 bAb7WnfAk9OME5uEBw/vK107cRjAAHPqF3cDzwtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mithil Bavishi <bavishimithil@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0040/1536] ARM: OMAP2+: Add CFI type for omap4_finish_suspend
Date: Sat,  7 Nov 2026 08:34:16 -0500
Message-ID: <20261107134958.787537860@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mithil Bavishi <bavishimithil@gmail.com>

[ Upstream commit 4a7b197ad28d71f9fac873f283b4408df3fdb287 ]

With CONFIG_CFI enabled, OMAP4 can trap in omap4_enter_lowpower()
because omap_pm_ops.finish_suspend points directly to the assembly
routine omap4_finish_suspend, which lacks the expected KCFI type
metadata.

Annotate omap4_finish_suspend with SYM_TYPED_FUNC_START so the assembly
routine carries the KCFI type metadata.

Signed-off-by: Mithil Bavishi <bavishimithil@gmail.com>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Andreas Kemnade <andreas@kemnade.info>
Link: https://patch.msgid.link/20260604054048.18980-1-bavishimithil@gmail.com
Signed-off-by: Kevin Hilman (TI) <khilman@baylibre.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-omap2/sleep44xx.S | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-omap2/sleep44xx.S b/arch/arm/mach-omap2/sleep44xx.S
index f09c9197808b1..8b515f30072b0 100644
--- a/arch/arm/mach-omap2/sleep44xx.S
+++ b/arch/arm/mach-omap2/sleep44xx.S
@@ -6,6 +6,7 @@
  * 	Santosh Shilimkar <santosh.shilimkar@ti.com>
  */
 
+#include <linux/cfi_types.h>
 #include <linux/linkage.h>
 #include <asm/assembler.h>
 #include <asm/smp_scu.h>
@@ -58,7 +59,7 @@
  * stack frame and it expects the caller to take care of it. Hence the entire
  * stack frame is saved to avoid possible stack corruption.
  */
-ENTRY(omap4_finish_suspend)
+SYM_TYPED_FUNC_START(omap4_finish_suspend)
 	stmfd	sp!, {r4-r12, lr}
 	cmp	r0, #0x0
 	beq	do_WFI				@ No lowpower state, jump to WFI
@@ -223,7 +224,7 @@ skip_scu_gp_clear:
 	isb
 	dsb
 	ldmfd	sp!, {r4-r12, pc}
-ENDPROC(omap4_finish_suspend)
+SYM_FUNC_END(omap4_finish_suspend)
 
 /*
  * ============================
-- 
2.53.0



