Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E57F19DF66;
	Thu, 21 Nov 2024 18:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732213352; cv=none; b=Y191Co3VsHAtq11a41eceYrTpvVvHrwO+pbAmjmZ9L5quIT7C6oqI+SBrec7NlqWNjX2Am5NYfobpNebBt4T38dH6kxSLWBq1vxkXEhK/Wv6v81M81P09lK9iX1a+BZ3ycvNtjwbBH10bipgkW7YY+a/U8y2oUaFA028WyZ75I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732213352; c=relaxed/simple;
	bh=NlOGgKbYlSPT5mGVg0Vqrr2RjMPYarQpOk/xs/FSmYk=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=S8GlCDEdNcqVaZLdBVlID97tSY/uV+Gx/oZlUYzNiKOEqI0BQbxnElH53fpHa3222TNiWb9ydMFn98cKXFr8dMKfoM1o7QQeSm7muOQekJcTWWdqvjkAGg1qBRbux+7k/RVymT0Rdf6+6qPCoPRvn3bZGBt/Klyk5Te32m3iFeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atvUalK/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atvUalK/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B671C4CECC;
	Thu, 21 Nov 2024 18:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732213351;
	bh=NlOGgKbYlSPT5mGVg0Vqrr2RjMPYarQpOk/xs/FSmYk=;
	h=From:Date:Subject:To:Cc:From;
	b=atvUalK/cG6ylxLiD0a+I5dn9F7g0pAOH0QaU3bxPk0lUB0cdKxKoerXOF+bAlaYT
	 XA7F75fFoRHiYd1i7XPk06BpZWPBuBSWL8iq2kNJJLMpRrBu17+30fuSclDF7GT2nL
	 jyNOS14kQ39ciM+QmJSRv8jkIgYBt5vy/c9EUbc6xd+UZlPOkZq+aFwWObfxvtzxsX
	 hlU4pEkrKUkZxQzSi4ybrPNOJx+hPBhvOnxzC1dP0Ny9LIDGg5AemNI8NNn/aaWJkf
	 nJ4oopgOA5gRBo33SCnPHsWIVy5i6CkBH+mzrxs97GEOLuRXgyEma7zgd7XZW2i+YX
	 xQT9e6eX47lIA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Nov 2024 11:22:18 -0700
Subject: [PATCH v2] hexagon: Disable constant extender optimization for
 LLVM prior to 19.1.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20241121-hexagon-disable-constant-expander-pass-v2-1-1a92e9afb0f4@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFl6P2cC/43NQQ6CMBCF4auQrh1DCxZw5T0MiykdoJG0pEMIh
 nB3K/EALv+3eN8umKIjFvdsF5FWxy74FOqSiW5EPxA4m1qoXJV5nSsYacMheLCO0UwEXfC8oF+
 Athm9pQgzMkNttNHSGo19J9LZHKl32wk929Sj4yXE9+mu8rv+CNn8S6wSJBQaq6Kk5qYq+3hR9
 DRdQxxEexzHB6moz63dAAAA
X-Change-ID: 20240802-hexagon-disable-constant-expander-pass-8b6b61db6afc
To: Brian Cain <bcain@quicinc.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-hexagon@vger.kernel.org, patches@lists.linux.dev, 
 llvm@lists.linux.dev, stable@vger.kernel.org, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=2848; i=nathan@kernel.org;
 h=from:subject:message-id; bh=NlOGgKbYlSPT5mGVg0Vqrr2RjMPYarQpOk/xs/FSmYk=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDOn2Ven3w17GXkmtbC9WKHRauz/9Quh2o8WPX8dJlzif1
 d398OqjjlIWBjEuBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjARBzuG/yGLl5ltCfJbwbhN
 8Hjmp7bIyXs9zEQN52Y95nZnfF76roCRYVfnuSqFRb/1vJa0n3vFsFcqLnLDttzsrPKPWd/Ytoq
 /YQYA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

The Hexagon-specific constant extender optimization in LLVM may crash on
Linux kernel code [1], such as fs/bcache/btree_io.c after
commit 32ed4a620c54 ("bcachefs: Btree path tracepoints") in 6.12:

  clang: llvm/lib/Target/Hexagon/HexagonConstExtenders.cpp:745: bool (anonymous namespace)::HexagonConstExtenders::ExtRoot::operator<(const HCE::ExtRoot &) const: Assertion `ThisB->getParent() == OtherB->getParent()' failed.
  Stack dump:
  0.      Program arguments: clang --target=hexagon-linux-musl ... fs/bcachefs/btree_io.c
  1.      <eof> parser at end of file
  2.      Code generation
  3.      Running pass 'Function Pass Manager' on module 'fs/bcachefs/btree_io.c'.
  4.      Running pass 'Hexagon constant-extender optimization' on function '@__btree_node_lock_nopath'

Without assertions enabled, there is just a hang during compilation.

This has been resolved in LLVM main (20.0.0) [2] and backported to LLVM
19.1.0 but the kernel supports LLVM 13.0.1 and newer, so disable the
constant expander optimization using the '-mllvm' option when using a
toolchain that is not fixed.

Cc: stable@vger.kernel.org
Link: https://github.com/llvm/llvm-project/issues/99714 [1]
Link: https://github.com/llvm/llvm-project/commit/68df06a0b2998765cb0a41353fcf0919bbf57ddb [2]
Link: https://github.com/llvm/llvm-project/commit/2ab8d93061581edad3501561722ebd5632d73892 [3]
Reviewed-by: Brian Cain <bcain@quicinc.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Andrew, can you please take this for 6.13? Our CI continues to hit this.

Changes in v2:
- Rebase on 6.12 to make sure it is still applicable
- Name exact bcachefs commit that introduces crash now that it is
  merged
- Add 'Cc: stable' as this is now visible in a stable release
- Carry forward Brian's reviewed-by
- Link to v1: https://lore.kernel.org/r/20240819-hexagon-disable-constant-expander-pass-v1-1-36a734e9527d@kernel.org
---
 arch/hexagon/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
index 92d005958dfb232d48a4ca843b46262a84a08eb4..ff172cbe5881a074f9d9430c37071992a4c8beac 100644
--- a/arch/hexagon/Makefile
+++ b/arch/hexagon/Makefile
@@ -32,3 +32,9 @@ KBUILD_LDFLAGS += $(ldflags-y)
 TIR_NAME := r19
 KBUILD_CFLAGS += -ffixed-$(TIR_NAME) -DTHREADINFO_REG=$(TIR_NAME) -D__linux__
 KBUILD_AFLAGS += -DTHREADINFO_REG=$(TIR_NAME)
+
+# Disable HexagonConstExtenders pass for LLVM versions prior to 19.1.0
+# https://github.com/llvm/llvm-project/issues/99714
+ifneq ($(call clang-min-version, 190100),y)
+KBUILD_CFLAGS += -mllvm -hexagon-cext=false
+endif

---
base-commit: adc218676eef25575469234709c2d87185ca223a
change-id: 20240802-hexagon-disable-constant-expander-pass-8b6b61db6afc

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

