Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020508;
	b=UgbOFTXInm2eA6QZtEEAj4+GW47O6znsCAxPLF4uh0DrL8vl5yrOpt3AerF/kIxR4Cg8
	 R40lK1hBy5yiZMm6EjoP0DM9LlciT1JaLnRXl5H6PhTC7Azmg1PDojtyH3ExaxQr+jN/d
	 JaILg9X4xs77K48Ax/e1VkGUQnZLE2P4KMKvz5gnKnRqjCvD4bJyWkV/sjEqBSDrcJDxF
	 mpBmoneb+ZEGJ6+i2fkBBVUh56pdzkOmIenaPcM4s0GkFGxKubDODJaIENbp6SxroQzlT
	 efeE+vTnkQdIu7TPId3MZG0840d8nz/It/phkfq8rw6UiP4vhNbB2b3XgOHMd7ePBig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020508;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=11MXDIKRxhayHOxlrdzVFqpo5HlWYtQefcqpkxQsh/I=;
	b=5EcHuLwxsyBemNNcZ37P+XOshD4lpuU1y3pWrS8sA0Ggz46r8tQnxxS8CMDCNZG2+6Oz
	 H/7NMGTTY0veL3esVNNbQatvMRmCwHept5M5DPwUNwicI58jz3UF73hG4bMnwVQmBTR8m
	 0aAWOiGXCzoWzqdYkZwdklWB/DMmJarWzLIu+lxDJVA2/6/M16AZ1T6kXegf+Usud+rmm
	 2F+6uaXIK3LOgrJ68vuXGzrTUyN0UGY1HxHnhcFtA5LTYhWwjNbLiCe2YjmER9EFNF8ka
	 7c4N7H3AH+aa6Chv+GubwiJFR+9kj4QmrWU4ECrAls/P9A/lDzZVtj0Ehq68Y3wDdtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6hQKGMn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1761A606A32A;
	Wed, 18 Nov 2026 16:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=b6hQKGMn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67C031F000C6;
	Wed, 18 Nov 2026 16:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020507;
	bh=11MXDIKRxhayHOxlrdzVFqpo5HlWYtQefcqpkxQsh/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=b6hQKGMnl4G50QbxO1QLqa2LD8S53e9OEr4WOodqpi+rfxpmFzzz+yknZN9o4qZaU
	 8q00kI5oNBRfoTuO77N0GKd6/g7lDrUu1nzbwXAkIK4UuSLU+DM/XvsBclHje4ASlA
	 izYm743MnNyTHbRsH9kHABjGt4i26sW2+iVHuT38=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 7.3 1977/2651] kselftest/arm64: signal: copy each test binary only once
Date: Wed, 18 Nov 2026 15:53:37 +0100
Message-ID: <20261118150357.603716490@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

[ Upstream commit 7b3b147c4104f8211ad356a78cff9a2dcd966312 ]

The signal tests are built in testcases/ and then copied to the output
directory. The copy rule lists every generated program as a target and
copies all of them in each recipe:

  $(TEST_GEN_PROGS): $(PROGS)
          cp $(PROGS) $(OUTPUT)/

In a parallel build make runs that recipe once for each program, so
several cp processes write the same destination files at the same time.
cp then fails with "cannot create regular file ...: File exists", which
fails the arm64 build even though every test compiled. A cross build of
the arm64 signal tests at -j8 hit this in all of 8 runs.

Use a static pattern rule so that each output depends on, and copies,
only its own binary.

Fixes: f96bf4340316 ("kselftest: arm64: mangle_pstate_invalid_compat_toggle and common utils")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/arm64/signal/Makefile | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/arm64/signal/Makefile b/tools/testing/selftests/arm64/signal/Makefile
index 1381039fb36f9..c4df4be41636c 100644
--- a/tools/testing/selftests/arm64/signal/Makefile
+++ b/tools/testing/selftests/arm64/signal/Makefile
@@ -17,8 +17,8 @@ TEST_GEN_PROGS := $(notdir $(PROGS))
 # the toplevel makefile
 include ../../lib.mk
 
-$(TEST_GEN_PROGS): $(PROGS)
-	cp $(PROGS) $(OUTPUT)/
+$(TEST_GEN_PROGS): $(OUTPUT)/%: testcases/%
+	cp $< $@
 
 # Common test-unit targets to build common-layout test-cases executables
 # Needs secondary expansion to properly include the testcase c-file in pre-reqs
-- 
2.53.0



