Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829305;
	b=27+ZPcY+bclhN2Z9qoTVBN8KxsUkKotix7fN3qp4r4hXmISARB0j4seZgDPdMVi2mzaL
	 s7CA0COk+8doWqeSe/paCcCthdC9hhQoQQzFMW8bYEfvGWF/iGMlZ8YJEBJU4FVL7uBzU
	 E6KoZQ0PJRUjD0ibsX0XMGeu5FrSyMwYdSgJVTO0owqcv+3sunyOT6ZZLl7jrHWELgyhU
	 g0qkhN8dbCcQDMJp5G4xiFaMslLrqEAjusgnMdpBkFydNK9Fev20EmrJst5Ohe4uw22D0
	 TNUaFBG6VgY1mXWY53yUfzXftyaU6/Qo85Ew6agPIAb8rVW+aOgLh97je1MfZcCt/XA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829305;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o6mtLmDhKbUN2QaSpDkE+zdjK60IbaAyp1jdtZRYG9w=;
	b=3VZRJwNhgaOTUKT3aCcGw0b9rbXIV+2Lxml202FHMVhFj480TkCL3u81dYROP+Bd22gE
	 L42Kxb452FWiAv8nd2gJeiH6t5JyEOOv32eEAGmbo7lC6QHlh6nfJrZ9MN7eFseK8OPA3
	 p33vQoOWjEjChZVBmLFhtOp7E1olghHll6pskLODGVFQLI2FDXMYV/MKEgNDGykU+tC+g
	 7fQrMl1tUkZGSM1VBzPcZ7Ts1w2c2sIVYQgGwifn1UljxqTSZmwW8Tmu657ol6z6MBNRt
	 LjOzTnfKR3q15SnMDkGZWZG3cZgD16phKvj8Gtkq6OxGTEUiatfR7K0X/xRfXyorb2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+4FHtAj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D8560A3824;
	Wed,  4 Nov 2026 21:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=J+4FHtAj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357311F0093A;
	Wed,  4 Nov 2026 21:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829305;
	bh=o6mtLmDhKbUN2QaSpDkE+zdjK60IbaAyp1jdtZRYG9w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J+4FHtAjN+/Pi78XtoxsCL7X+SLn20ywWl7Kjp6g9nDXIz8RTqJS6YP1BzGNEj3LW
	 z7/HrAymeSr1EvxNuHABwdPgaUHJzysQGpVPU1EVhHtX9TTmYv3yYqgh5pV+QLoU+K
	 RGtvWB5IQjRH10x9ERYIcdDpINiuYk8vWxCnC4Wk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mithil Bavishi <bavishimithil@gmail.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Andreas Kemnade <andreas@kemnade.info>,
	"Kevin Hilman (TI)" <khilman@baylibre.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0041/1005] ARM: OMAP2+: Add CFI type for omap4_finish_suspend
Date: Wed,  4 Nov 2026 15:56:14 -0500
Message-ID: <20261104211044.727792455@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



