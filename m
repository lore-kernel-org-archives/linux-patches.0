Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 340E536A366;
	Wed, 20 May 2026 16:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779295986; cv=none; b=eNDG4kYL1EusYVDlmGjV0UcjG79t6kw2BiXNMoSY0AR9Ce4q/NJthWOUBdy+LIPRumcymixaMv2mSxmXYM7AZGBqWBQf5sSvfkaS5+uQS7a/OqQ+bKt4r2PWHGkXIAwVICnWWnDLiHmFFXSHWx+Eglcifm57IDln0oHVdvXyhyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779295986; c=relaxed/simple;
	bh=s1eUhWfBrLe9QnDDniIi6CfQiQEL+5vKcCgGyygKAl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kMtUibOWI3FB7jnG2WpEMRpcNm3jhWN0Q0dTddWjoausTq3BBw8LMKI9px1Cgyk+zmbzsM2uO7AVpl/TbPuBs4zQpw/Y732T426lWlVaKJ6PYaznXC1tw93oVMvhipZUM3YXfBqOLnzOUPbUcXoJRXEmsfhZmcGlUeVPsgVwppQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Dd25S3oQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Dd25S3oQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8111F00893;
	Wed, 20 May 2026 16:53:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779295984;
	bh=fPWbC0SYXp8Rrr69vLYBUqXl4ad8oEwD28X4am2le1I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dd25S3oQzFQBDy98Xj5kj5PCh3mepNZD66YGrohlTbvXKCCb8shUXCyEYdD0Z9FAI
	 69Vom2uQ6PjYI3VzYW628/HRGQsoYyD/mmTb6L/yjnAFjsO2mgCG1LUaKqS/aL+/fU
	 j2XY1neEXK/t9r07hVk7To+/UEJqz5bzdIczsIik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0627/1146] perf test type profiling: Remote typedef on struct
Date: Wed, 20 May 2026 18:14:37 +0200
Message-ID: <20260520162202.374680652@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ian Rogers <irogers@google.com>

[ Upstream commit 6910944bf0b92fea63d5a7aeed69e4b9c14fd01b ]

The typedef creates an issue where the struct or the typedef may
appear in the output and cause the "perf data type profiling tests" to
fail. Let's remove the typedef to keep the test passing.

Fixes: 335047109d7d ("perf tests: Test annotate with data type profiling and C")
Signed-off-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/shell/data_type_profiling.sh | 2 +-
 tools/perf/tests/workloads/datasym.c          | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/shell/data_type_profiling.sh b/tools/perf/tests/shell/data_type_profiling.sh
index 2a7f8f7c42d09..fb47b7213b335 100755
--- a/tools/perf/tests/shell/data_type_profiling.sh
+++ b/tools/perf/tests/shell/data_type_profiling.sh
@@ -8,7 +8,7 @@ set -e
 # data type profiling manifestation
 
 # Values in testtypes and testprogs should match
-testtypes=("# data-type: struct Buf" "# data-type: struct _buf")
+testtypes=("# data-type: struct Buf" "# data-type: struct buf")
 testprogs=("perf test -w code_with_type" "perf test -w datasym")
 
 err=0
diff --git a/tools/perf/tests/workloads/datasym.c b/tools/perf/tests/workloads/datasym.c
index 1d0b7d64e1ba1..19242c7255c0c 100644
--- a/tools/perf/tests/workloads/datasym.c
+++ b/tools/perf/tests/workloads/datasym.c
@@ -4,14 +4,14 @@
 #include <linux/compiler.h>
 #include "../tests.h"
 
-typedef struct _buf {
+struct buf {
 	char data1;
 	char reserved[55];
 	char data2;
-} buf __attribute__((aligned(64)));
+} __attribute__((aligned(64)));
 
 /* volatile to try to avoid the compiler seeing reserved as unused. */
-static volatile buf workload_datasym_buf1 = {
+static volatile struct buf workload_datasym_buf1 = {
 	/* to have this in the data section */
 	.reserved[0] = 1,
 };
-- 
2.53.0



