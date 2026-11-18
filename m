Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795017970;
	b=LDvK2RMNZgEaaTHEyVUZvCR6nGkQTa0RqN65IU64HKATU+STLTawOv3O7izb020ZVDau
	 bEUk7ka374WysNTc2S42AwICAsGnnOPDvjn02wZMHWEU+eraXkBKGaSg+auZ8OQb8eFv6
	 KrTKPXT/jk4jQjMrNyZNeGSp0N8EqCO6sws99oh2e5utwwliGpob9mUKg77kV0tvnKVkp
	 pVo7BRG0lnmlF3ReOkmaf+FwWGzMubZ5nlqjHMcSsIvsXiNWk8n/XrserEc0LX9mC2qns
	 HYvOULme8ueKlteTwnwtsiPATx+s8b2F9RNgMrSFIZFpQKQ9QAt5fFvUDCWtE6zL2sw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795017970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=acwqPFEFcMTkWmFVVbRnGQNBAdruk7EJ9x7w4Yg4ars=;
	b=Whr7DW3tGD0d4wBlVvd1GSFJgX875zr+aXF83hiof2H962cUV5aQuBsECtSAQO0Xp/zN
	 oE5hLfeYS/ZlxBd1ovQLrPlGmlIevHgVotgGqxJz1eRbP6TEia1vSCLDUUzEdoV1yEH8n
	 KiKjS/z4rHW/t41uyEAsT8htSNUQHHtNM2yvZYNy492/3P/asCk3axdogAqXss40qOYll
	 7er9lmxQpGWNhZuqdGfPy0+4FDXxt3R/W4JYtpXgQeDRMevDV/LqYYoO+sZ11DTy2EcTt
	 MhAvPDjVg5tLO/rsQnLIQNf0uMFiEfhWIQgM5D3Hx/5V1U02KhLNiRCc8CT8ggWMjhg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRxqlvjC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB659606A31C;
	Wed, 18 Nov 2026 16:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BRxqlvjC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1081F000C8;
	Wed, 18 Nov 2026 16:06:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795017970;
	bh=acwqPFEFcMTkWmFVVbRnGQNBAdruk7EJ9x7w4Yg4ars=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BRxqlvjCZCY1WwghVixNjMxmh1NGbyAx/jZa+bccfBKlDSX6boCfug9hjG0rmzwrY
	 Cyd65G9Vj8q1X+2bU15vORwS4gT1o0VoL138pqkB6H8YLdX1zNl17InLVZRzGSMYKL
	 3/D0n6zSvSVSrpMI4egJtCKcJ1k8a1o4dq19hUAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aishwarya TCV <aishwarya.tcv@arm.com>,
	Ian Rogers <irogers@google.com>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1073/2651] perf build: Build the Python extension before pylint consumers
Date: Wed, 18 Nov 2026 15:38:33 +0100
Message-ID: <20261118150326.615726245@linuxfoundation.org>
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

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 179c2413bb601c94e144c7a84cd34ae3bee3b586 ]

Pylint checks for tests and standalone Python scripts can run before the
perf Python extension is available. On a clean parallel build, an import
error can stop make before the extension is built.

Run the script and test pylint checks in separate sub-makes after the
language bindings are built. Keep their rules in the respective Build
files so the perf and perf-test C sub-makes can compile concurrently with
util and the Python extension. An isolated make perf does not need to
build the extension just for these checks.

Fixes: 8a54784e708b51c1 ("perf build: Add pylint build tests")
Reported-by: Aishwarya TCV <aishwarya.tcv@arm.com>
Reviewed-by: Ian Rogers <irogers@google.com>
Assisted-by: Codex:gpt-6
Signed-off-by: Leo Yan <leo.yan@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Build         |  4 +++-
 tools/perf/Makefile.perf | 15 +++++++++++++++
 tools/perf/tests/Build   |  4 +++-
 3 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/tools/perf/Build b/tools/perf/Build
index e18c80a5c1bca..bf9949fe813a7 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -103,4 +103,6 @@ $(OUTPUT)%.pylint_log: %
 	$(call rule_mkdir)
 	$(Q)$(call echo-cmd,test)pylint "$<" > $@ || (cat $@ && rm $@ && false)
 
-perf-y += $(PYLINT_TEST_LOGS)
+.PHONY: pylint
+pylint: $(addprefix $(OUTPUT),$(PYLINT_TEST_LOGS))
+	@:
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index f1ac45f1ddd5b..4841a7204a308 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -534,6 +534,7 @@ strip: $(PROGRAMS) $(OUTPUT)perf
 	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf
 
 PERF_IN := $(OUTPUT)perf-in.o
+
 export NO_JEVENTS
 
 build := -f $(srctree)/tools/build/Makefile.build dir=. obj
@@ -589,6 +590,20 @@ $(SCRIPTS) : $(OUTPUT)% : %.sh
 $(OUTPUT)PERF-VERSION-FILE: .FORCE-PERF-VERSION-FILE
 	$(Q)$(SHELL_PATH) util/PERF-VERSION-GEN $(OUTPUT)
 
+ifdef PYLINT
+# Run Python checks after the extension is ready, independently of C builds.
+all: pylint-perf pylint-tests
+.PHONY: pylint-perf pylint-tests
+
+pylint-perf pylint-tests: | $(LANG_BINDINGS)
+
+pylint-perf:
+	$(Q)$(MAKE) $(build)=perf pylint
+
+pylint-tests:
+	$(Q)$(MAKE) $(build)=perf-test dir=tests pylint
+endif
+
 # These can record PERF_VERSION
 perf.spec $(SCRIPTS) \
 	: $(OUTPUT)PERF-VERSION-FILE
diff --git a/tools/perf/tests/Build b/tools/perf/tests/Build
index 66944a4f49682..8c6a9c4d39b4c 100644
--- a/tools/perf/tests/Build
+++ b/tools/perf/tests/Build
@@ -118,4 +118,6 @@ $(OUTPUT)%.pylint_log: %
 	$(call rule_mkdir)
 	$(Q)$(call echo-cmd,test)pylint "$<" > $@ || (cat $@ && rm $@ && false)
 
-perf-test-y += $(PYLINT_TEST_LOGS)
+.PHONY: pylint
+pylint: $(addprefix $(OUTPUT)tests/,$(PYLINT_TEST_LOGS))
+	@:
-- 
2.53.0



