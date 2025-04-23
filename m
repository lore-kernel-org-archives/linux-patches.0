Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F863265CC0;
	Wed, 23 Apr 2025 18:15:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745432116; cv=none; b=pnLh+kI0Td1T0ld7Bnt/KcGKb6Hun8nK4vZ9TNN3ZveA2I5ABptoBA+r9Q38e90LHD1x6bmS31xRSO5x2imObRqUAQNPuHpMCsTl4WsErXB3iFM1mam7P4DK0Pl5zX7sRJiSiKxg7RJ+z9raXhHjx9XO/GyeBANswuPNSVGLVJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745432116; c=relaxed/simple;
	bh=QKTt5bkmQB/d+gAbXWH4LWzz44kO06euZJ/bzPjxlQg=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=l6gZF111QGCQ58uOplkAvS4dCmXH8ccAwZeDyb5ddnlqIpw8DutreoGkjTNkCzIXXcRgYpXwRAosQGSJ8/OVHHS/n6DvAQrvaDUpL0EKG+qsPNYvwm4XzbQ6bkZYbtS8vb0vDsuZKGpWs38FJQicZ9eoPkFXRCc8oTRwF2aVhHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PyYSu7AX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PyYSu7AX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D562C4CEE2;
	Wed, 23 Apr 2025 18:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745432115;
	bh=QKTt5bkmQB/d+gAbXWH4LWzz44kO06euZJ/bzPjxlQg=;
	h=From:Date:Subject:To:Cc:From;
	b=PyYSu7AXHJSv6R7bBbKR6rJAqUrRpeM9szO3JKjnRwSzegtREIZI+k23pcPpGNRJC
	 6zuT5kS5KG0UcJ5u3e/U0RnnPQhKTW3ezMX9okd8+Qxu7Txe4otxi1r3z+pU55hcbg
	 RyYj6ST+5M8NjxbOO0ZAk0jwp1s8wdfUifP1VZlFLFy4OPRL5FNBj+OeJ+HqUliUn+
	 60VJef9Ae++9aEJq45/kY+IALhch/DiprHYPJT2fxADXFYwuxBaUznQVI4vyVbeVl2
	 EQDqVoAtKC1lCUmhur9pEZVsQOFG0t4+8RFNQpdhDAoIeHXiPdUOgp20LAOrjrUKRV
	 2RVkFKIG2OteA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 23 Apr 2025 11:15:02 -0700
Subject: [PATCH] riscv: vdso.lds.S: Do not export __vdso_getrandom in
 compat vDSO
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250423-riscv-fix-compat_vdso-lld-v1-1-820de5cad605@kernel.org>
X-B4-Tracking: v=1; b=H4sIACUuCWgC/x2M7QpAQBAAX0X729Y55ONVJHG32MLpVpeSd3f5O
 TUzDwh5JoE2ecBTYGF3RMjSBMw6Hgsh28iglS5VoXP0LCbgzDcat5/jNQQrDrfNImVTraZcF7a
 pIPanp6j9765/3w9375oqawAAAA==
X-Change-ID: 20250423-riscv-fix-compat_vdso-lld-e1b80b324d97
To: Palmer Dabbelt <palmer@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Xi Ruoyao <xry111@xry111.site>
Cc: linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1255; i=nathan@kernel.org;
 h=from:subject:message-id; bh=QKTt5bkmQB/d+gAbXWH4LWzz44kO06euZJ/bzPjxlQg=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmcekZ1Cza32mce0d+8bIq82nrlEj7N+ZvYmxxClpc+9
 ru3o3RJRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjIrpOMDP9mZigE9E9jZuqW
 ydTMWMieuMxEKb9xYeJCxWlrQuTibjH8056rk++ae7xaqjTdvkPF79/PxMWzuo89iY7VLP7PseM
 rIwA=
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

ld.lld defaults to '--no-undefined-version', which causes the compat
vDSO to break after wiring up the vDSO getrandom() call because the
linker script between the two vDSO implementations.

  ld.lld: error: version script assignment of 'LINUX_4.15' to symbol '__vdso_getrandom' failed: symbol not defined

Move the export of __vdso_getrandom() under the existing ifndef for the
compat vDSO so that it is only included for the 64-bit vDSO where it is
wired up.

Fixes: 89079520cef6 ("RISC-V: vDSO: Wire up getrandom() vDSO implementation")
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/riscv/kernel/vdso/vdso.lds.S | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index abc69cda0445..dd8f0d128e4d 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -79,8 +79,8 @@ VERSION
 		__vdso_flush_icache;
 #ifndef COMPAT_VDSO
 		__vdso_riscv_hwprobe;
-#endif
 		__vdso_getrandom;
+#endif
 	local: *;
 	};
 }

---
base-commit: bafa451a96d0f1404aa1a5a267f78767a55fac71
change-id: 20250423-riscv-fix-compat_vdso-lld-e1b80b324d97

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

