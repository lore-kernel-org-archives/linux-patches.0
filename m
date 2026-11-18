Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024949;
	b=UInyUC9w/bBGU7+nbSQN+ZId1SHAzU1J/hVr2ymAaCGBSNzq235f4aLNcq5WnvgaxBDZ
	 KMCFtRnP1e06+szv2IBzIk8CLdNuHFOSB22zzwP0Y+cWYj6vnKUOC0rcSAJdVjn9+kzG3
	 d2a38oEUqipSddSKMiba1IBpYIGAPaPyIgY2/TxK/juXWyPV88iz39uovW8eHAcw2YhNc
	 6wkk4m/kXPhW470MGlETgJ2LBKxy+rlkAALfyrNua5OsoqK9TlstqVFmTiseq1n8dZ1o2
	 eKLwWpme0DOQn+dpHEhHWyDyT8OQslYQ/zANTRCMqQxE0VhWx+M8yYtOFuynrAaS+4w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024949;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GhbA3MGsG8qtgkPQduH2kXvzW11XtgR6RnSUqj9QJM0=;
	b=C1IXx5bAHsYk/qLQnZVwLCLL1xJQ7AGsS07O1TkSbbgNEHuTXMDjaxB3y+yNDqQ4UfGA
	 YnHDUH6vgOMiLApbCpukgOHBQQnoCXX2ywltvrw/NdcG0BCXPL6HQX0YnLyK8HJSQynWQ
	 521XeZx96PWeEvSz7lgm3r9wDB9+lpiYeK4sxDnqRYT4bP80FYF+UWTmRWV0HJ1ktMvqc
	 UpJqdi/rN7ygTAsiPeOWPski/LBvzk1sCs/i4xeCYMqGgg79pAuXZG66Yn8HDI5kMWWz+
	 gDYbsBP8gSA3WyGxduJRZDn433F3Emlq2g4K3IJHBlhC3xcNH6wKkRVNRJa2eEpTS3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVYvSAsF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB178606A31C;
	Wed, 18 Nov 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vVYvSAsF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226B31F000C4;
	Wed, 18 Nov 2026 18:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024949;
	bh=GhbA3MGsG8qtgkPQduH2kXvzW11XtgR6RnSUqj9QJM0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vVYvSAsFB/yhgNqaT5vyTWPabVQA7CMPblNQQOQq1/bq5ObKLRSZVAhny6mW3xyxq
	 YgLhr872Yj6uQpuQdsBd9dhH32Fr8QZxlANUl2tpXL/1f+PcLgIQQO1nTspVPRG39c
	 L34Ic64nLvtKQ5ukNgarZFu50lvOPybKGCzRc7Jw=
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
Subject: [PATCH 6.18 0905/2151] perf build: Build the Python extension before pylint consumers
Date: Wed, 18 Nov 2026 15:44:00 +0100
Message-ID: <20261118150155.295271469@linuxfoundation.org>
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
index b03cc59dabf81..5aab1832ee841 100644
--- a/tools/perf/Build
+++ b/tools/perf/Build
@@ -101,4 +101,6 @@ $(OUTPUT)%.pylint_log: %
 	$(call rule_mkdir)
 	$(Q)$(call echo-cmd,test)pylint "$<" > $@ || (cat $@ && rm $@ && false)
 
-perf-y += $(PYLINT_TEST_LOGS)
+.PHONY: pylint
+pylint: $(addprefix $(OUTPUT),$(PYLINT_TEST_LOGS))
+	@:
diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 84cfd7395d18c..841c00c847b0a 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -756,6 +756,7 @@ strip: $(PROGRAMS) $(OUTPUT)perf
 	$(STRIP) $(STRIP_OPTS) $(PROGRAMS) $(OUTPUT)perf
 
 PERF_IN := $(OUTPUT)perf-in.o
+
 export NO_JEVENTS
 
 build := -f $(srctree)/tools/build/Makefile.build dir=. obj
@@ -814,6 +815,20 @@ $(SCRIPTS) : % : %.sh
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
index af67f8ef74b49..bb8533db40e6e 100644
--- a/tools/perf/tests/Build
+++ b/tools/perf/tests/Build
@@ -116,4 +116,6 @@ $(OUTPUT)%.pylint_log: %
 	$(call rule_mkdir)
 	$(Q)$(call echo-cmd,test)pylint "$<" > $@ || (cat $@ && rm $@ && false)
 
-perf-test-y += $(PYLINT_TEST_LOGS)
+.PHONY: pylint
+pylint: $(addprefix $(OUTPUT)tests/,$(PYLINT_TEST_LOGS))
+	@:
-- 
2.53.0



