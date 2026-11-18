Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049946;
	b=PKmi3TN/Gx7ahdY54TLxjagReK2kZPEUPg7rUHl2aqqkg1rzS7GPOvFJIJme41MGLx4R
	 kM9sv3YBJIkoFleKmPCu5r7zDYsEMoaAI6mxoy9DgxCtV0p/Hc5zXuod0tCGKVjraCT6Q
	 2BlZFnayN2dITXY9rPIleSCTqsuGOv1PndJFZwCXXQ2RWn41etrCcQZwavaI6hynoQibJ
	 KVWC4Nxu8K61qtWX3X/2FToMJ3Hb+VAIehzZkUpGPrVL5ipEBzJQG7VQLsOGpZZnZABrj
	 7ZRbtuDSlVRfMpf52TRlOq5+s/ZXGc1TWBiQb3zT1LHeFKD/4LNBBH+a7K/QrtPhGiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049946;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=DaW5FYYD/k+z0UA6Iy/IJ9/U+3x1hbN+k19uCFJWHCQ=;
	b=e7Sq0GzU0NNCgeAyLtkCFsElQLnUnwbAeNZnSeLLy8SKqR0w1lYsEKGe3IWDCWIGKX96
	 RMgIRaPbeyn9farF/25r6EFMu6qVFGbMvxa/++4lMPFyOd9hCFMW4nbaPjyil6lkSyXAg
	 rTQftfyo4QAMOaK9Vgb76pL1f9603+QR4nhaBfq1Diwv+BxBtQcKQqmEoqCKyFla2NXL5
	 wEvS9MEwMMlfQeJSYf6A+Gu/aPRV1+xk/r1d9BrP+E+5JNKqaFOOk5XXzTuhvUkUE1JtL
	 XtIdYUHAq3sZa876VfZridyTNny+KZpbJ1aHn/7XAxsBigQMnJ5yImA9Ws5y2v6XSTQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEpiKknK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8F18606A320;
	Thu, 19 Nov 2026 00:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mEpiKknK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34D9D1F000C4;
	Thu, 19 Nov 2026 00:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049946;
	bh=DaW5FYYD/k+z0UA6Iy/IJ9/U+3x1hbN+k19uCFJWHCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mEpiKknKD1LVlNyXfuiJRd1DBu7vFLy/sHlOWR5IS5/gqSO1RtM4jY++oL4Aj+hcP
	 No5ZGi/bFsb/xNAlH1ujNgiFdmqz6EZp6wMFlXaloPppd9KI7v8d9IWx6FLjnwvVmg
	 /ldMMRUV21j2keJkTicr/+eOdrgz1wSGM0Ii923s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 2531/2857] kselftest/arm64: signal: copy each test binary only once
Date: Wed, 18 Nov 2026 15:59:25 +0100
Message-ID: <20261118150332.667770544@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index edb3613513b8a..23f3428cd2662 100644
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



