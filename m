Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E47223DFB;
	Wed, 23 Apr 2025 20:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745438636; cv=none; b=mj7BhUNSlaUKYjTYXQjKEIoAA/yMxQZax84TFxfoc3Tf0Lf1/95zFsnjSutSLgn5r+cNmuKUVUtDkesK+eUu1vyzR9P0GJRWUT168yAb173lLWBhS8tSKyjUBgxREUMrwh1Eo5hjRxDjleIgwNxDJWqiHeBjtvL1wjdA+/G+TM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745438636; c=relaxed/simple;
	bh=GOtTYoCHMPW5XORDGg1hgjwlC2VQy46M8btk4g+X5XQ=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=okQjl9I9x5YyLWxbvO2WhpFIfivsImngR+KxqCHGd+1FjjuEwNsuabVNN4P4psjsMc/1b1N59rEWWJbH2w4IHHxU2NFAbKERI6HLJL3ftglHKG5v/diH7Ao+qgUD8w8oAuzr7y8/BTxv4uAUKg9yxrDh4apb34+YccSBYFu8jPQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NAM/PTzV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NAM/PTzV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E34FAC4CEE2;
	Wed, 23 Apr 2025 20:03:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745438635;
	bh=GOtTYoCHMPW5XORDGg1hgjwlC2VQy46M8btk4g+X5XQ=;
	h=From:Date:Subject:To:Cc:From;
	b=NAM/PTzVcBO8Gc9lk0Vws5Z/JbifBKa7FL/qNcOrOg921aVCmFHKRnCe0ro2cwahX
	 J30fjxHQgkLnTU3mo0akUZH2ZjJEoeJGirJl31C0nJgTbRbvGgi+Ynn5JqbXj/pUVz
	 A2eHSLp0iQ2nOJqVoE4bdlK2qwUMiOjUo48RegyjNONMr2VoWIiK2BSzF6THa5Fj9g
	 ct8f1apgZVyIU3y4lxfXskV9mTLsLs7MaxAglHBpJUNcl8OIQGMaSXvjdeQPwxGP+l
	 aekS8PCCs/NNf2bVLYau13+CbowNV5dW9Ip/xrfieVw207bJat9NOLzJOWtzPbuUqZ
	 AU2oJsapWZstQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Wed, 23 Apr 2025 13:03:43 -0700
Subject: [PATCH v2] riscv: vdso.lds.S: Do not export __vdso_getrandom when
 building a 32-bit vDSO
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250423-riscv-fix-compat_vdso-lld-v2-1-b7bbbc244501@kernel.org>
X-B4-Tracking: v=1; b=H4sIAJ5HCWgC/42NUQ6CMBBEr0L22zVtAUW/vIchBtoVNgIlW9JoC
 He3cgI/32TmzQqBhCnANVtBKHJgPyUwhwxs30wdIbvEYJQpVWFyFA424pPfaP04N8sjuuBxGBy
 SbivV5qZwlzOk/SyUarv7XifuOSxePvtV1L/0H2vUqLEyylFpG3dS5e1FMtFw9NJBvW3bF0uY5
 NbDAAAA
X-Change-ID: 20250423-riscv-fix-compat_vdso-lld-e1b80b324d97
To: Palmer Dabbelt <palmer@rivosinc.com>, Alexandre Ghiti <alex@ghiti.fr>, 
 Xi Ruoyao <xry111@xry111.site>
Cc: linux-riscv@lists.infradead.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Linux Kernel Functional Testing <lkft@linaro.org>, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1890; i=nathan@kernel.org;
 h=from:subject:message-id; bh=GOtTYoCHMPW5XORDGg1hgjwlC2VQy46M8btk4g+X5XQ=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBmc7ivfPiksmrZxhdQyg10z4mvW+XfzROarzznrcXuhS
 0VopVNtRykLgxgXg6yYIkv1Y9XjhoZzzjLeODUJZg4rE8gQBi5OAZjImyyGfxoaZeztdS8dfwrs
 WelqlC4Vkbl6uezU/wlLrrdMnRkWe5nhn877Y6fWmHo83f4rhO1c/M5CFU2vQ4/umy5I2bJS62X
 cDyYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

ld.lld defaults to '--no-undefined-version', which causes the compat
vDSO for 64-bit builds and the regular vDSO for 32-bit builds to break
after wiring up the vDSO getrandom() call because __vdso_getrandom is
unconditionally exported, even though it is not always present.

  ld.lld: error: version script assignment of 'LINUX_4.15' to symbol '__vdso_getrandom' failed: symbol not defined

Move the export of __vdso_getrandom() under an ifdef to only include it
when CONFIG_VDSO_GETRANDOM is defined (to exclude 32-bit builds) and
COMPAT_VDSO is not defined (to exclude the 32-bit vDSO on 64-bit builds)
to resolve the error.

Fixes: 89079520cef6 ("RISC-V: vDSO: Wire up getrandom() vDSO implementation")
Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Closes: https://lore.kernel.org/CA+G9fYtN2ie+YtK3H9mrQ5QqrSCFGGjVbtJcfiYX0oHMVWMn9w@mail.gmail.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Changes in v2:
- Include a check for CONFIG_VDSO_GETRANDOM to fix breakage on
  rv32_defconfig. Include the tags for the report that helped highlight
  this issue.
- Link to v1: https://lore.kernel.org/r/20250423-riscv-fix-compat_vdso-lld-v1-1-820de5cad605@kernel.org
---
 arch/riscv/kernel/vdso/vdso.lds.S | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/arch/riscv/kernel/vdso/vdso.lds.S b/arch/riscv/kernel/vdso/vdso.lds.S
index abc69cda0445..7c15b0f4ee3b 100644
--- a/arch/riscv/kernel/vdso/vdso.lds.S
+++ b/arch/riscv/kernel/vdso/vdso.lds.S
@@ -80,7 +80,9 @@ VERSION
 #ifndef COMPAT_VDSO
 		__vdso_riscv_hwprobe;
 #endif
+#if defined(CONFIG_VDSO_GETRANDOM) && !defined(COMPAT_VDSO)
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

