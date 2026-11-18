Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061772;
	b=NzrzlmriJ5RWdHvZRAZODfidjnK0c67PEL7M2AWLMj4i0NS0XULEfMHAD5Cx+kVmGd2T
	 kAoQB1Zj2liXbO6TqQk2oi420raMa3jYbeVPqlf3L+x+oESpPTq0IJre9wFfwF0SClwSn
	 9GIsctLL157HF4xUFgKr8jlQD6NWWhmpMeVvMnk5kDcgJ67OyJPGGQtsDedx5DNPyZWaH
	 oCrD/ycLE5xUC5UZg0JkPe+PPBjBRKvRxJ3lXYxdKS/emY40cV35UCwrGjQPu5baSjGn2
	 pINcWPlXNSEuNe6jAXqMU2IICTXDLDrTFzWv5Bq3z5N5rbRi2yQ81OeK7WzpfpRWP1Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061772;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jYUYRIf/eF2GFK1viexkol3F1wK38/xU7A0rORRndF0=;
	b=41IEV+nTMzzWvXxmsnNPZTksAfTycDaWUWAhWYcc98yDH20s/iRsddOXa2EeMZpUDo9j
	 azuu8KENMuZZYO4RYMecWy+LMJIcepq0r1mQB6xVH8hSeYeji7+WoCZl2n1064OtWCvhF
	 CQ7uq9w/1VLZcED+BxsALe45RxjigcyCfTmhcQKzMmIc5uq+8knLfqlaT9o8BaOc7oNy2
	 8731+mqZO3ikVcYFSmMN3hYpZFZMUzk60cDW928Y+xr3N5Wk98IPRsEX8Ki+CQY96HkhL
	 sq0sLcncqoRjkMfWfVK7wJiKjOMSJeRXUbRtcdno7TCMbmvoSQmi6AAJlO+6qrWE31w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxvfQiCH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21594606A32A;
	Thu, 19 Nov 2026 04:16:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DxvfQiCH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 76BE01F000C4;
	Thu, 19 Nov 2026 04:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061772;
	bh=jYUYRIf/eF2GFK1viexkol3F1wK38/xU7A0rORRndF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DxvfQiCH0erqRo8QKJiSsoeNeyFmQjjMe/kB3G3wdGFgy6Vb3yTXFxSVZOLz62NUU
	 +9GKP7yA+ISvLRY9piElAko0D3/stSvzNCRu2unaBNdSWjamNm7x0wAM0ORPFu/6Vn
	 p52/VvZCGbaFtVYOHYCkx83uEmKpxTkmEEDpkwVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 5.10 1671/1848] kselftest/arm64: signal: copy each test binary only once
Date: Wed, 18 Nov 2026 16:01:49 +0100
Message-ID: <20261118150029.781926073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



