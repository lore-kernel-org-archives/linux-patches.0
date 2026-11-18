Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041758;
	b=gZKB/cJAowquNpgC3C3MW9OY0J1dgCgr0C9xW1NObdCDdnNJy6JAoPqE6P6sGx+AVC9Y
	 stes1O9dOjf75Dn+n+cFZ1Lsoe4zc3/44EdwetvK0cAlYxUEGbFrff88vwSRs/QO/av0i
	 U+VLqDCaliuUft09XgNpngGjxpa/1Hzsrf5fwAZ7E0NliHuWrh7y+B63zZ2K11lW7nSeI
	 vlEwUjiBBT3hrjwu6HjEjBuKwLXZEKs1nvQHmEOYA+zVOyNdwC0vkq4ptPY5TdD0o9boM
	 7i8DPzVd/nabT96LdEf5t2P8tjLVbvSR5odyG0DYt4YdFhpvI4gdaX255o9ZuKvp0Wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041758;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nsWipsRhtetXq/kEa68/ntIS4weC60Oql/qTzaYZyLE=;
	b=MPtj2V9POO7SFhGlGLvKZCn7ezNClH8pMM7seXOY62qZ0qmwxSSkLg5J9APa/3JJW9Sx
	 vDe3RpJGcQBiiT+SKgwWYsKs/3txPAx5NLjSpuzGV1kloKF13LD8NtnYcBpouIlIaMOPT
	 cPLZdIEdKO8i+JQs8BqXr4+Cw5wuRrDstxo+ojHT/UvrbqEHIi3ZHJO+0b8koYMEsrh/d
	 zls+x1S4WtRHo9sot5Pn6EcX0t2op3gqMMtzf9ZTZskyLJePyM2Y/2Wsau5VWR/KP1JyS
	 o0CLocTskXYUbpCQ+m+oV+tgC9iAX/nW7YSeo9/VUri3ETtDXqX8m9Scsv3kzb8cRLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oiKTTLyN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71872606A31C;
	Wed, 18 Nov 2026 22:42:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oiKTTLyN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FBEF1F000C4;
	Wed, 18 Nov 2026 22:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041758;
	bh=nsWipsRhtetXq/kEa68/ntIS4weC60Oql/qTzaYZyLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oiKTTLyNnoWPTaGkGIxpebuViCXD3oQan3P1wT6eRKPPs2zOTdeHHmZJh7021XXoY
	 eA6OXD5jS85HdBgEIM7F5bK7U5hB0UO+W4QILHbFvTFuIZyGgSG2JJu8uttePDoF/v
	 B/ggpGApIjwrD88tJchAWprjFnUW/ELb3WJO1SdY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.6 2927/3318] kselftest/arm64: signal: copy each test binary only once
Date: Wed, 18 Nov 2026 15:59:09 +0100
Message-ID: <20261118150448.205801820@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



