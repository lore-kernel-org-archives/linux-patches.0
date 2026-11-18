Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795024043;
	b=O/nVgNvmIfpndsmmlixbzBdY1K2Rc6j65JQNwG2XyAOYMBoEZ+lZey1AA6vIY98wojPt
	 vtDQNh2eAUAaJdmchAeiFHYZMze0QArj8WQ+TGzfzLw1Sv3vBr10dcQkhKXaDSluPyqlD
	 /q1eXbzMnHbueIgvPROCEQhsv/lQBaozvSOWgOlqRnM8So5MVV6ml2MsC7KWof7vyx0/q
	 fzQjY/DdhNdfO40IOHcTz5RVY61d6P673RW2NTkzJzf0fBqAntj5Y2pXGCgRLnpy0OlzA
	 pzalUW9IkZZVUE4CSVMV8fcImYsKRC46eQas26D+G0f1cDdmAfenYkOXgtzIkSvOygw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795024043;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=STBmVfyqPO6RLXLiLFkr6APyvrHZcEgr8x/a4FrArjY=;
	b=43hj4RkqDS538uv2rxmnIxVm91u09N7YQerlPwAG86sWxTzUm+JdC/vGmZ+BkM5k0Ojz
	 chqRBTEgXdszayVLMBX/opVVGknxp15R4Af5j3PP7X9KBlTqTOhz3ZBz2O5e+KF+xhn2H
	 stvrOFenh1bF0fjs5/h2WHMyhNtW72NOm9Y9lmQBAu7hkRN1iFy+RRKvS+kplUn9ceZ+0
	 sNtOV4/xd+AxGgNgp6QsaoMLUQ/hOzKRTAPiqp4cypsQr1j94edJYSPzPZzTZ9BG+Ym0r
	 vQ0GVpT99yIMnvA6PX8XKrSCVGcyAjR5aXvitsdjVUqxlaEsW5bsTstIvJ/pYPr6Y9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1qog8tv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F782606A320;
	Wed, 18 Nov 2026 17:47:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=D1qog8tv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 020EC1F000C5;
	Wed, 18 Nov 2026 17:47:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795024043;
	bh=STBmVfyqPO6RLXLiLFkr6APyvrHZcEgr8x/a4FrArjY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D1qog8tv2lRADcvyCnjvfh2LyxVjhqmnIYgpEcRdbpxEKT7h6yFmmmQkVVLvq7P+p
	 i6ljyN2Bxmj4VNhyKzHgWHowOb507efaviNBqy7lBdr4KRHn9pnnOKt+lbLj/hVwa/
	 jsjTaNrXG4NxvtAG+/oGpIS/eDBwOUvrvyhI0BMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0585/2151] perf build: Remove leftovers of removed build options
Date: Wed, 18 Nov 2026 15:38:40 +0100
Message-ID: <20261118150143.263555712@linuxfoundation.org>
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

From: Ian Rogers <irogers@google.com>

[ Upstream commit a5cac2df8b4af0410dd6339e6491cb1e4fbc6986 ]

NO_LIBDW_DWARF_UNWIND, NO_SYSCALL_TABLE and the embedded clang/LLVM
support were all removed, but each removal left the matching entry in
the build test suite behind:

  run += make_no_libdw_dwarf_unwind
  run += make_no_syscall_tbl
  run += make_with_clangllvm

None of these have a make_* variable defining what to build, so $($@)
expands to nothing and each one silently repeats the plain "make_pure"
build. The suite therefore spends six builds, as every test is also run
with O=, appearing to cover options that no longer exist.

Remove them, along with the NO_LIBDW_DWARF_UNWIND comment that is still
in Makefile.perf.

Fixes: 2e9191573a69ff96 ("perf build: Remove NO_LIBDW_DWARF_UNWIND option")
Fixes: 3cc550f5bbcf54ab ("perf tools: Remove dependency on libaudit")
Fixes: 56b11a2126bf2f42 ("perf bpf: Remove support for embedding clang for compiling BPF events (-e foo.c)")
Signed-off-by: Ian Rogers <irogers@google.com>
Assisted-by: Antigravity:gemini-3.1-pro
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/Makefile.perf | 3 ---
 tools/perf/tests/make    | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/tools/perf/Makefile.perf b/tools/perf/Makefile.perf
index 4b184859cbd24..3e3e266c5bc1d 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -61,9 +61,6 @@ include ../scripts/utilities.mak
 #
 # Define NO_LIBBIONIC if you do not want bionic support
 #
-# Define NO_LIBDW_DWARF_UNWIND if you do not want libdw support
-# for dwarf backtrace post unwind.
-#
 # Define NO_LIBTRACEEVENT=1 if you don't want libtraceevent to be linked,
 # this will remove multiple features and tools, such as 'perf trace',
 # that need it to read tracefs event format files, etc.
diff --git a/tools/perf/tests/make b/tools/perf/tests/make
index 1fe1ef45e5c10..e91f46970d8f7 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -152,7 +152,6 @@ run += make_no_demangle
 run += make_no_libelf
 run += make_no_libdw
 run += make_libunwind
-run += make_no_libdw_dwarf_unwind
 run += make_no_backtrace
 run += make_no_libcapstone
 run += make_no_libnuma
@@ -161,10 +160,8 @@ run += make_no_libbpf
 run += make_no_libbpf_DEBUG
 run += make_no_libllvm
 run += make_no_sdt
-run += make_no_syscall_tbl
 run += make_no_babeltrace2
 run += make_with_coresight
-run += make_with_clangllvm
 run += make_no_libpfm4
 run += make_refcnt_check
 run += make_help
-- 
2.53.0



