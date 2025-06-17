Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF8B2DFF1B;
	Tue, 17 Jun 2025 16:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750178357; cv=none; b=Ide4cyiZ2+DSFR/n0ofMfGClUurRkLIYCGFygZ86ufTSO36e3MO7CrU/dbJqwfhIHYPqcT19HwSHdHAMjaXQBpEog/p3Qy04r/ZiJWpiXTX2Lg8gAt1szT+uBdsm5ujJwIJ46R9f1XZ/9KkoHqN109tnZfEV3OZz0J788uLFVX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750178357; c=relaxed/simple;
	bh=0SbCh4Pe+L2ffR4fuH4LSC2ohy/WkjDC8ViFt1jaGy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LuYYlEfBvt2ErXqhK6xszDe7NfBh8YDwdCgGjVQkYkr6EuGcEPsxl6cHl34NjSUBWeX9J7IKdBW1eXhvwLL9uQimDGhNb5MSfhBb+dh4qr08jxNcSHpE09+rYS+ShsAS8gDCbSJ8sUtogGCtH048owaqiMMnTSxqmTpgBVlI0AU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gADPIdTa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gADPIdTa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 962E5C4CEE3;
	Tue, 17 Jun 2025 16:39:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750178357;
	bh=0SbCh4Pe+L2ffR4fuH4LSC2ohy/WkjDC8ViFt1jaGy4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gADPIdTaSiB/+49ps6CxmXAgzjJw23p1SOY3hLlrfAhYEjvVWZgV/+GqurA1e6Mis
	 ombvSsI3tsBAhhLcI8C0NoM9D/GSGg2Z8DUFS4CQ2PXJDkpJjG23xp6e3Ws/reTltv
	 Jv6uF8DcukoogaL4uwl4iVWUXCB6VK5Rvc4CMS90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	James Clark <james.clark@linaro.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Alexander Shishkin <alexander.shishkin@linux.intel.com>,
	Ian Rogers <irogers@google.com>,
	Ingo Molnar <mingo@redhat.com>,
	Jiri Olsa <jolsa@kernel.org>,
	Mark Rutland <mark.rutland@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 448/780] perf tools: Fix arm64 source package build
Date: Tue, 17 Jun 2025 17:22:36 +0200
Message-ID: <20250617152509.699832398@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Clark <james.clark@linaro.org>

[ Upstream commit aea3496bbc7c20037ecc35411264de109d700fc7 ]

Syscall tables are generated from rules in the kernel tree. Add the
related files to the MANIFEST to fix the Perf source package build.

Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Fixes: bfb713ea53c746b0 ("perf tools: Fix arm64 build by generating unistd_64.h")
Signed-off-by: James Clark <james.clark@linaro.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ian Rogers <irogers@google.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250513-james-perf-src-pkg-fix-v1-1-bcfd0486dbd6@linaro.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/MANIFEST | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tools/perf/MANIFEST b/tools/perf/MANIFEST
index 364b55b00b484..34af57b8ec2a9 100644
--- a/tools/perf/MANIFEST
+++ b/tools/perf/MANIFEST
@@ -1,8 +1,10 @@
 COPYING
 LICENSES/preferred/GPL-2.0
 arch/arm64/tools/gen-sysreg.awk
+arch/arm64/tools/syscall_64.tbl
 arch/arm64/tools/sysreg
 arch/*/include/uapi/asm/bpf_perf_event.h
+include/uapi/asm-generic/Kbuild
 tools/perf
 tools/arch
 tools/scripts
@@ -25,6 +27,10 @@ tools/lib/str_error_r.c
 tools/lib/vsprintf.c
 tools/lib/zalloc.c
 scripts/bpf_doc.py
+scripts/Kbuild.include
+scripts/Makefile.asm-headers
+scripts/syscall.tbl
+scripts/syscallhdr.sh
 tools/bpf/bpftool
 kernel/bpf/disasm.c
 kernel/bpf/disasm.h
-- 
2.39.5



