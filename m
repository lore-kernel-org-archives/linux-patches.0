Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795032119;
	b=vRKTojkfbcKXFF377uC8IRdQCJJs6Sm+gsssQXkQGCAa7gTSUYSPnirpsxDz2IJRkPdi
	 t8woa8YG6tlMruocPg68V0EJodwXM2UEmQ9KBjpyxOQprepXEMgE2N+5Xwts10uGEd6hc
	 XpoMjbR8kkuqj6aOXFFBP554NnVSWv8RMRwcxhBh9Z7vvM8B4FchXpiUscdc9Pq8DekAn
	 kqcg3WLHBvqQthXwlzT3mGB8I97+Ewjg56qdubPSzIHY0hN1A+tObWbBY75VpBMiuZty7
	 XSwq+IQT38oXJeIxmWLopYILIX3qV9L0AOCUAK9lYr917JnfGMGQbxHJX3Iyd+FGSnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795032119;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AzQcNbX8PqEvTP1v6HpxaEl8KOS6bqLzQfRQ3SsMYeM=;
	b=35bdD8HmvZ/9Hgf7xEgav/12Zr1jxY+rbg2YaiATwZp15/i5u1GHXT/YiRADaQvub51l
	 Yxmam6h30QmwGsOlIZAKCRGcv97v7/TtJY/+fYHfKTmxq1UyvB+Ny1hxbAZocOQE+ynKJ
	 s8VC4U7TbLGoxyK3Rs5zdarkd9X+J4o71Wnkp9aw9g50uHFn8AFIEworQM2eQRiC82iD2
	 oiYwwBwx7kvDzmvlCvaFkkbM++aK6PtixkK+BdgP7OaOdQHnFHfYT4P34jTupNIrphbQr
	 0ZdsIGId12KMyvlKD9WQyvEZZ0MfIdiUuEYRuvGCBJRTCdtqbFD+ZwF7TkaEpheHm1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cWjYWOyD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33288606A32A;
	Wed, 18 Nov 2026 20:01:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cWjYWOyD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899221F000C4;
	Wed, 18 Nov 2026 20:01:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795032119;
	bh=AzQcNbX8PqEvTP1v6HpxaEl8KOS6bqLzQfRQ3SsMYeM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWjYWOyDuGzeonYqsr8ef6M6x5Ok6weL2IalEaR0RMOeGmqenntHqsWTOlxrHu9T/
	 uUdTWyPY8tMB1nfOUgzO5hArc2oK0ifwIpVp9Mmlu2Ww5M0mLfiqagJ/r5PozF36Cm
	 QuRDpjGX+aXrwtnG6c6MdOLV33pLHIUb2qYZsDok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.12 1282/1756] kselftest/arm64: signal: copy each test binary only once
Date: Wed, 18 Nov 2026 15:56:49 +0100
Message-ID: <20261118150100.605393009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



