Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056396;
	b=ESqNgajnJzvAN/G/dWWX3kqEKJw4/lZWs6jYGkTojQyJiUgfJcHYaaKMFzlD3DVRYDNc
	 tpKD6QDSYc4vWnlMYTBi14N1jnBVAmLJBcDq4jjQ+h/dBhS2bwHcWQfw9qlurBHlgtzFF
	 kyXbDhToVP+PI88M8TYa6E8a4fwnSBvRe33Wi37GpjSXe3xRhko5pT+9Eaz5BbJSIhA4Z
	 zWDTlvXP3S/p+PflPa5PoVK6yG9DftApY2BK56lLqMgDEu3jjKFMh22ItTxqkasW3KDdC
	 fUhHyLsAcqkNlBAPr/F0fM6DP6h4vJdNWHlIE57sLlVfAHo6rlmHzo6D9zAuaxqASag==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056396;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mjQbU6tOxbhaq0u7r379maecS1eChj+gwVPMxFkLRdI=;
	b=24Pg6sPSNoisHA7O6znvUvNbGXDKYdkGqg8E3YVT5+1YdR0jYCmJfUtFY3XEWsUcZakg
	 HgiwVQZR9n5zTjeAr5OOY/QqdLnOjg2yqaxSKWb5zkgVU5OgnU3AEEMiktoGEou6h8yAW
	 OqaOzIYiq2mnJot8IvGj489Du3TLj7Tw1qswaKmRLt3ddFq7jWJvyrskmwjiQP9H4L0ul
	 TGHBugNsfmg48Frplbu2PSzqCaAGNsNgrpx0rnmUVrfTMjjiPOlxWg4voBDfq9dSCtJjf
	 ZxXAkFohoyaRoITMewaCYtibBtLWzkz+1DrguJ38GdDamDWg1MpuL4ZB+e+JtNb85ZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l08YnMIu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7639606A31C;
	Thu, 19 Nov 2026 02:46:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=l08YnMIu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056A81F000C5;
	Thu, 19 Nov 2026 02:46:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056396;
	bh=mjQbU6tOxbhaq0u7r379maecS1eChj+gwVPMxFkLRdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l08YnMIusxFK7QEdLfbIA8n6aPOQMH9fIw1O/P6XRzdYe1/LNw50tKRCuFX9W4WPJ
	 ERRrP4zJcDCxdEA0FfwvbhjvWvcu6sm8LDyWwZdYTE+tNgH6+at4SwKVo+0wCqHdyt
	 jCgIiM7twD15A1VzqefMK3uLXWkWe2YBkyTZZx00=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.15 1973/2214] kselftest/arm64: signal: copy each test binary only once
Date: Wed, 18 Nov 2026 16:00:49 +0100
Message-ID: <20261118150129.835100624@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ac4ad0005715b..05e015bda58a2 100644
--- a/tools/testing/selftests/arm64/signal/Makefile
+++ b/tools/testing/selftests/arm64/signal/Makefile
@@ -18,8 +18,8 @@ KSFT_KHDR_INSTALL := 1
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



