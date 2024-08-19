Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F6EFD531;
	Mon, 19 Aug 2024 18:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724091380; cv=none; b=ssf5umVNXw3tyMbWRVO+HG67GWAmyThQQc0sx/xzSnjFwlPgVo4XXvYXU42xGXp63XfnOqsl0l2X1saLhHV3txDnrTXY+Ja6+eEIOJm/0k5Ws4dwCXi/D/n47wX1l7UHKzxzQ1UODBjEr9CP0+YmmMOz/7GvBJ3HTm2KxRpBy80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724091380; c=relaxed/simple;
	bh=fb00pKGHuPVAd6R+bBKI9YbKJHWC6vDu6M1kpq90BNI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=LdajDQ9DJ9VgdWEIgYiVHIMba8qiX86ADNhoCYGAOG42JunhUo7jvTDqlVyfh+RYAcXKHUChbN6iuNlZTxot3EeBSK+EFrAHuNoajhiAT56xlyCIvcV9G7GJwMn0n2HG7epvuGTKHMMmJmVuQi75aafXQcVaTCgm0nDjDIzMqo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a2bKTOay; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a2bKTOay"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48938C32782;
	Mon, 19 Aug 2024 18:16:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724091378;
	bh=fb00pKGHuPVAd6R+bBKI9YbKJHWC6vDu6M1kpq90BNI=;
	h=From:Date:Subject:To:Cc:From;
	b=a2bKTOayeGxT9txXl0p2QfIs+0+ooPeZ3R1BUzJurol/l/bWbm3SeCFs0BDdpavCI
	 L0G5tJZNBWkB3Go/tqdyqIsA+1qPQwgeFWWUl8/zDu+8JSgqYW06uOIcbw6UH6tisq
	 6ZL7DIQ7TF3rlLHVxdJOQ4+XtEPRBt3OPuD6LEEBheGpQQPeMG8fATHqmiXe0ZF6aT
	 p82IZGaRamGwk8D9k3z5pABbmbkMRGmYgAHkZCIsjGLCdf6BrC2oo2ucAq0gef341r
	 kySNb+yfU8AW/GfwDeZWqxseqJJfa6h3uOyThcm7eLctXNp6wTobKVXTZGZTF7mg/9
	 cxVsuisV9TadA==
From: Nathan Chancellor <nathan@kernel.org>
Date: Mon, 19 Aug 2024 11:16:10 -0700
Subject: [PATCH] hexagon: Disable constant extender optimization for LLVM
 prior to 19.1.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20240819-hexagon-disable-constant-expander-pass-v1-1-36a734e9527d@kernel.org>
X-B4-Tracking: v=1; b=H4sIAOmLw2YC/x3NwQrDIAyA4VcpOS9gZUjZq4wdoqZtYEQxZQil7
 17Z8bv8/wnGTdjgNZ3Q+CcmRQfmxwRpJ90YJQ+Dd/7pFudx505bUcxiFL+MqagdpAdyr6SZG1Y
 ywyWGGOYcA60JRqw2XqX/R+/Pdd0ysIyIeAAAAA==
To: Brian Cain <bcain@quicinc.com>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: linux-hexagon@vger.kernel.org, patches@lists.linux.dev, 
 llvm@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=2213; i=nathan@kernel.org;
 h=from:subject:message-id; bh=fb00pKGHuPVAd6R+bBKI9YbKJHWC6vDu6M1kpq90BNI=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGmHuz/G/v0qeqNNUfTjg4NWXpL9NRUbBAXiX8yMD37x9
 4jew49XO0pZGMS4GGTFFFmqH6seNzScc5bxxqlJMHNYmUCGMHBxCsBE1q9m+J+8+OlTJv6F164H
 fJh55Pv2rYFbNYoVkvZ1JdseeGB65P52hv9Zm+prlguIJp8SDy3ne2d14Yo216lOYYn5KqKcs9M
 C7/MCAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

The Hexagon-specific constant extender optimization in LLVM may crash on
Linux kernel code [1] (such as with a bcachefs change in -next):

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

Link: https://github.com/llvm/llvm-project/issues/99714 [1]
Link: https://github.com/llvm/llvm-project/commit/68df06a0b2998765cb0a41353fcf0919bbf57ddb [2]
Link: https://github.com/llvm/llvm-project/commit/2ab8d93061581edad3501561722ebd5632d73892 [3]
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 arch/hexagon/Makefile | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/arch/hexagon/Makefile b/arch/hexagon/Makefile
index 92d005958dfb..ff172cbe5881 100644
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
base-commit: 47ac09b91befbb6a235ab620c32af719f8208399
change-id: 20240802-hexagon-disable-constant-expander-pass-8b6b61db6afc

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

