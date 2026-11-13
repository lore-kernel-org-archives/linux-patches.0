Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590463;
	b=lvRukc8M3kThu9uJk2r/H26asvSvLbe3TfH6q1ZRgumwuP8fg6xhVm7n18grxHWWfBBU
	 u7z2YC6HlX5xXAjHxUAJg3TNEciMFlTWVMeJyXJ2ACA3lC7wnIQa29CKcLvD6/iBjeyHz
	 UqKZGTTAnkG0Cgv6ZAIQ8DQ6OkoVXVSfE4G+1LiNTrz18hUhoCNBChTwkvBHYojhRvb0B
	 bncLbCQa/S6WfmQZRApGAfy75KOJUHmTU1UibgoqfPIRkmb144hnEHl0g+Ehjqu7APjS+
	 vPctz3mwo6jJIJudfsgsUliRoIrmR+V+M1aXSQ5J6gTo/7Jw6G1brwrXUorB3QYx+zQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590463;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sAJIeBUQ6isnB+FNdMHQGqbbQLes8vbyPla7l/KbwRE=;
	b=h1qhiWIprITsKOOv/vj2YxOqlXb+MPjfUt9AHNJZlOWMj8+qi0ZSb7LWjp029TsS6WTA
	 vZ37TAtoHZl5R58cXDJHdevJS5D5Sv+w+weIFKFORo5w4PSnxBQ4vSXFuL53Xa9xjKB1V
	 e1MO7U6CgSmjaCgR4pWjKP88yE53suHPRjmQwC0VWa2xDHkWOqyaOORdjvwqfa/MhkdHD
	 BqLUWrr/xlQvcidLHEqZfugW37oF9XPJNWUyF/gH2KVHhfxwipo7U31ybyT4bzQT7lOtV
	 RmyBAcTz2OOJzV3FRU9gyWEk+oTU5XPgen5IrSboOyEiLdeORaE/lJvylwZ4LQzoAuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aABD5i9p;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E2C2606B34F;
	Fri, 13 Nov 2026 17:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aABD5i9p
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4651F000C7;
	Fri, 13 Nov 2026 17:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590462;
	bh=sAJIeBUQ6isnB+FNdMHQGqbbQLes8vbyPla7l/KbwRE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aABD5i9p/2luK+9dTWn69UuCXt8Rp7auZftCELxwSG3MsXjubFu3y1b6zfBZV3XgM
	 vM5ON1hZHsTzVi5pEtdLJJ2/b3a1wn7wMiLIAP5Un7DPfO9Q5TeCCm6PltAK2GjiDY
	 phmfUAbHtcwfoZxKA247vrLlTZ7ual5ELIDCI7hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Will Deacon <will@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Wei Wang <wvw@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 419/686] arm64: suspend: Save and restore TPIDR2_EL0 across CPU suspend
Date: Fri, 13 Nov 2026 10:49:12 -0500
Message-ID: <20261113153835.156100429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: Wei Wang <wvw@google.com>

[ Upstream commit beeec04046227eba42b7cc5ab32498aa43da9632 ]

TPIDR2_EL0 is a live EL0 register on systems with SME, but
cpu_do_suspend()/cpu_do_resume() don't preserve it. Its value is
UNKNOWN after a warm reset, so the task that initiates suspend can
return to userspace with a corrupted TPIDR2_EL0.

Save and restore it alongside TPIDR_EL0 and TPIDRRO_EL0. The new slot
fits in existing padding, so sizeof(struct cpu_suspend_ctx) is
unchanged.

Fixes: a9d691585950 ("arm64/sme: Implement support for TPIDR2")
Cc: stable@vger.kernel.org
Acked-by: Will Deacon <will@kernel.org>
Reviewed-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Wei Wang <wvw@google.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/suspend.h | 2 +-
 arch/arm64/mm/proc.S             | 8 ++++++++
 2 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/suspend.h b/arch/arm64/include/asm/suspend.h
index eb60c97355530..2cc5fb405769c 100644
--- a/arch/arm64/include/asm/suspend.h
+++ b/arch/arm64/include/asm/suspend.h
@@ -2,7 +2,7 @@
 #ifndef __ASM_SUSPEND_H
 #define __ASM_SUSPEND_H
 
-#define NR_CTX_REGS 14
+#define NR_CTX_REGS 15
 #define NR_CALLEE_SAVED_REGS 12
 
 /*
diff --git a/arch/arm64/mm/proc.S b/arch/arm64/mm/proc.S
index 17df19647556f..5e7bc1a8d9ca7 100644
--- a/arch/arm64/mm/proc.S
+++ b/arch/arm64/mm/proc.S
@@ -103,6 +103,10 @@ SYM_FUNC_START(cpu_do_suspend)
 alternative_if ARM64_HAS_TCR2
 	mrs	x2, REG_TCR2_EL1
 	str	x2, [x0, #104]
+alternative_else_nop_endif
+alternative_if ARM64_SME
+	mrs_s	x2, SYS_TPIDR2_EL0
+	str	x2, [x0, #112]
 alternative_else_nop_endif
 	ret
 SYM_FUNC_END(cpu_do_suspend)
@@ -142,6 +146,10 @@ alternative_if ARM64_HAS_TCR2
 	ldr	x2, [x0, #104]
 	msr	REG_TCR2_EL1, x2
 alternative_else_nop_endif
+alternative_if ARM64_SME
+	ldr	x2, [x0, #112]
+	msr_s	SYS_TPIDR2_EL0, x2
+alternative_else_nop_endif
 
 	msr	sctlr_el1, x12
 	set_this_cpu_offset x13
-- 
2.53.0



