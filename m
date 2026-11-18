Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026938;
	b=sMndTSBnfc5Uc2YzXQnujDJzzx8MGZPAzYjzYyoKJ6TcDnD4vPRW3vmziCm5QZIEgVD1
	 h4apIr3veA3IWoTNu5i4kVE9+RqjBbgO7NAo6DZjAt0fU1sx6dtBJ2dwOoqLUmRbYirfc
	 tPgPaL+mlc1H/xj46r7O8cr935QC5YkaXIkLgKESGG1bJbEqZExPUF4b5sEJsN3jO9gCX
	 NLtxkzfk2NkIjOgMNBrwfSBRWxisUz9zqbKXhrvM7e6fdI2734KwcUN8QRvpqGyGTXNdU
	 JW1C6+zR6f2uGHxRJNs0p65cSCpgHqkpFLKVCRDhzyc9Bih7tb43snsmXrA+WAW+fnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026938;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DhOJgFQeOcqKcPyzphXJE764PtJ288UT0ug5sxTEH38=;
	b=Zjbvf4Bb8MeKR2wL3P+z6WC2kLfe/vH8Z8qG178TkUJ0y4dDTABjXzJO3/cnKXmnmXyy
	 quU8nNvvGKFn7l1hIH7FUZeUKFufMUfiS7BKDqxJcFrhP3xgA/JlZWFyw+hd8EQdyaE9m
	 CtLAw15b/SyJvgBKrlPXX7X6fFNtEGIZF3E48mePPrEy7qSABBWNT5B6aWKISkl5P9UU7
	 kM62nHqiGOWB1ubUE+IawRLvZu0Fm1P8lbR83BSyEu7j1ZTMEdoJXoUwgsokid1/yCfuM
	 btBbR34k2Xc/pipEgOx2S6HcRGvfjHom22usNu1tsth5HGkffPT445QVvMo7SQSFhlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKnEbV0v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557C8606A332;
	Wed, 18 Nov 2026 18:35:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bKnEbV0v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 714001F000C5;
	Wed, 18 Nov 2026 18:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026938;
	bh=DhOJgFQeOcqKcPyzphXJE764PtJ288UT0ug5sxTEH38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bKnEbV0v7ZuVXypw/Pf7WNcsHGgam4i78E5YbbS8FvPb//jHGRSsMxPCpQJQpw5cB
	 3XHEa3B8fReoCBr0m/nJ61CYtEdgvnWEhpHC6hTfyU2yXvMWeOZJ+4mleNIRQfcC4t
	 LULLt/f3fIZh38vB4wai05dxjF4ghHsX5od9b6PM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.18 1613/2151] kselftest/arm64: signal: copy each test binary only once
Date: Wed, 18 Nov 2026 15:55:48 +0100
Message-ID: <20261118150220.633616459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



