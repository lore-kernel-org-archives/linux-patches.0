Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619801;
	b=Hve9nbPfeGI0XgCKROnFBKF8hJ5eX/6yQ5WfIr+fv/l0GXxIx9Feyu96c8o035z/z65r
	 TwK8lozQRduw/0b4hUYx45woUREukohHmcClRtkFegss3s/K5EPPPdADmBSz8wQHymIpy
	 32ub8WG34XXDe7BT8J5nFOfTV00koPCQu5JUSgkuQmiEfl7GmuPNAlVao1wZLNsB/PqBk
	 EDZ6Ug3ISxwBnIaZ38UyUBiTwJxzWSfFsM6W2DMJNzar4Df/HZuJNjPJKc5IjFMBvX8GU
	 qtHXUMp86ye7IFiSyam0AsH3d7ch7HBFKf32e9A5GnH/mVcMk5C5pFeLz28K51z98JQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KYU68j+3u6BA+GleF5BPBt+lHoTsCBEqGi1CRm+l0js=;
	b=nhmaP7z3I/1v7rCi/SSr8IMfo5RMg05CHuIe5A38NEEzyeyMZ5iO/+wVxWeYpx1DDBw8
	 H96sSQUCv8rd7ZeQldObAfRsISXfVH0qdYd/1zQ7ZxZEUQXYXqtvNujHr1VN8yv7Lx0mu
	 vRTSo1dXtlaT+fqHnD3rWkOuDAXyqmOCGypodES61EAwDyaMO3+ALIH1+7EtbrFitqUVq
	 d0TuZgxGZJI0H8CIaFj4bc2GnOy4tZ8aMV1FZkQ1VZ8GpW+jhib+4R3FQbQcoq5JxxcGK
	 wDC5kEFy2LafH9AaIIMwzoR7BvSkZQhViFqWtadYkPT1sWUB3wjJHxE1YplCMdvL5/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ToiT0vTl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25F6F606A321;
	Wed, 25 Nov 2026 15:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ToiT0vTl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7728C1F000D4;
	Wed, 25 Nov 2026 15:16:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619801;
	bh=KYU68j+3u6BA+GleF5BPBt+lHoTsCBEqGi1CRm+l0js=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ToiT0vTlU2eWfKi+5cKsmZ5c2jyRFaN4uaq6bFeBR3LBbr45eWOe/Fq0b8G4UVO2I
	 7VXZXxQOM83eVTQlg/4Mw19L9hf5YKeeIOQop3Z/yOKAdO/MJVeod+TXXpTrMBtUoo
	 vymcYVZ9vIvDpSIHz2X5FTOlGgGywKrU0mwR2o5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.3 0712/1005] arm64: suspend: Save GCS state over suspend
Date: Wed, 25 Nov 2026 15:34:10 +0100
Message-ID: <20261125143838.437526080@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Brown <broonie@kernel.org>

commit 7ca488055c69eed71219546deb805811854aca35 upstream.

GCSCRE0_EL1 and GCSPR_EL0 are live registers for EL0 on systems with GCS
but are not saved and restored by cpu_do_suspend()/cpu_do_resume(). This
means that the task that initiated suspend can return to userspace with
UNKNOWN or incorrect values for GCSPR_EL0 and GCSCRE0_EL1 (many fields
in GCSCRE0_EL1 reset to 0).  This will in turn lead to ongoing
corruption, including not restoring mode until a task with a different
GCS mode is run.  Fix this by saving and restoring the values over
suspend.

This increases the size of struct cpu_suspend_ctx by 16 bytes.

Fixes: 5d8b172e7005 ("arm64: Add Kconfig for Guarded Control Stack (GCS)")
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/suspend.h |    2 +-
 arch/arm64/mm/proc.S             |   12 ++++++++++++
 2 files changed, 13 insertions(+), 1 deletion(-)

--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 16
+#define NR_CTX_REGS 18
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -122,6 +122,12 @@ alternative_if ARM64_HAS_S1POE
 	mrs	x2, REG_POR_EL0
 	str	x2, [x0, #120]
 alternative_else_nop_endif
+alternative_if ARM64_HAS_GCS
+	mrs	x2, REG_GCSPR_EL0
+	str	x2, [x0, #128]
+	mrs	x2, REG_GCSCRE0_EL1
+	str	x2, [x0, #136]
+alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
 
@@ -168,6 +174,12 @@ alternative_if ARM64_HAS_S1POE
 	ldr	x2, [x0, #120]
 	msr	REG_POR_EL0, x2
 alternative_else_nop_endif
+alternative_if ARM64_HAS_GCS
+	ldr	x2, [x0, #128]
+	msr	REG_GCSPR_EL0, x2
+	ldr	x2, [x0, #136]
+	msr	REG_GCSCRE0_EL1, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13


