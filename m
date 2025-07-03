Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A3132E7F1A;
	Thu,  3 Jul 2025 14:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554756; cv=none; b=hJ5+zQu88c0ptJwvY1fOaDapDqc6eQz3cEtB/mAe6C/w/NYYsBQk0lW7if8IrhhJLnWMgxe5d+BS4B0SfjwUtRF2zc/lM+xukwYGXfy7yRjuUR0aOOWTzch0i/NKVYkPYOWTyEwxvG7PPZ9NZZIspihdYKho19++7+ImfPNSXxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554756; c=relaxed/simple;
	bh=yFIFzg/deEsTqTFrO6+2G3F3hQ2/ho+RjIBVCSr4TVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fCRkDWDSJ6Pd2a53jUB+Oe2gaJiYGUT9DFm6MJkYkEO+BZrUcr/3DhfoFLflops9bE3tPt315hkzr91TiWYreJVXHckeVXd3gcKIMawLikCua49s9NvIgji9g5FtN4C13MXBsZY9v/tO+rvW0Og2eM+faty9/3kCqaBakucD9OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFxxWDRg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFxxWDRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C55EC4CEE3;
	Thu,  3 Jul 2025 14:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554756;
	bh=yFIFzg/deEsTqTFrO6+2G3F3hQ2/ho+RjIBVCSr4TVA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFxxWDRg8Zj4TDi1XT472PFpp29xotj7qjlmUZ+uBauB0XX40oQmF3UtJKJ55bf6k
	 k6tP32Tn/FefeTkOXqTWpbEwQt1QyDOm+uir86yjppWo/iULGLKPvdJgw6lYBTOszi
	 861/D942QNvti721cvbtcQSgS7eP5/AhxOdQqUuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <cleger@rivosinc.com>,
	Charlie Jenkins <charlie@rivosinc.com>,
	Andrew Jones <ajones@ventanamicro.com>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 069/263] riscv: misaligned: declare misaligned_access_speed under CONFIG_RISCV_MISALIGNED
Date: Thu,  3 Jul 2025 16:39:49 +0200
Message-ID: <20250703144007.080669570@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Clément Léger <cleger@rivosinc.com>

[ Upstream commit 1317045a7d6f397904d105f6d40dc9787876a34b ]

While misaligned_access_speed was defined in a file compile with
CONFIG_RISCV_MISALIGNED, its definition was under
CONFIG_RISCV_SCALAR_MISALIGNED. This resulted in compilation problems
when using it in a file compiled with CONFIG_RISCV_MISALIGNED.

Move the declaration under CONFIG_RISCV_MISALIGNED so that it can be
used unconditionnally when compiled with that config and remove the check
for that variable in traps_misaligned.c.

Signed-off-by: Clément Léger <cleger@rivosinc.com>
Reviewed-by: Charlie Jenkins <charlie@rivosinc.com>
Tested-by: Charlie Jenkins <charlie@rivosinc.com>
Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
Link: https://lore.kernel.org/r/20250523101932.1594077-9-cleger@rivosinc.com
Signed-off-by: Palmer Dabbelt <palmer@dabbelt.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/include/asm/cpufeature.h  | 5 ++++-
 arch/riscv/kernel/traps_misaligned.c | 2 --
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/arch/riscv/include/asm/cpufeature.h b/arch/riscv/include/asm/cpufeature.h
index f56b409361fbe..7201da46694f7 100644
--- a/arch/riscv/include/asm/cpufeature.h
+++ b/arch/riscv/include/asm/cpufeature.h
@@ -71,7 +71,6 @@ bool __init check_unaligned_access_emulated_all_cpus(void);
 void check_unaligned_access_emulated(struct work_struct *work __always_unused);
 void unaligned_emulation_finish(void);
 bool unaligned_ctl_available(void);
-DECLARE_PER_CPU(long, misaligned_access_speed);
 #else
 static inline bool unaligned_ctl_available(void)
 {
@@ -79,6 +78,10 @@ static inline bool unaligned_ctl_available(void)
 }
 #endif
 
+#if defined(CONFIG_RISCV_MISALIGNED)
+DECLARE_PER_CPU(long, misaligned_access_speed);
+#endif
+
 bool __init check_vector_unaligned_access_emulated_all_cpus(void);
 #if defined(CONFIG_RISCV_VECTOR_MISALIGNED)
 void check_vector_unaligned_access_emulated(struct work_struct *work __always_unused);
diff --git a/arch/riscv/kernel/traps_misaligned.c b/arch/riscv/kernel/traps_misaligned.c
index 56f06a27d45fb..a6b6047693105 100644
--- a/arch/riscv/kernel/traps_misaligned.c
+++ b/arch/riscv/kernel/traps_misaligned.c
@@ -368,9 +368,7 @@ static int handle_scalar_misaligned_load(struct pt_regs *regs)
 
 	perf_sw_event(PERF_COUNT_SW_ALIGNMENT_FAULTS, 1, regs, addr);
 
-#ifdef CONFIG_RISCV_PROBE_UNALIGNED_ACCESS
 	*this_cpu_ptr(&misaligned_access_speed) = RISCV_HWPROBE_MISALIGNED_SCALAR_EMULATED;
-#endif
 
 	if (!unaligned_enabled)
 		return -1;
-- 
2.39.5



