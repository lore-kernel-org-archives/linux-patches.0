Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016771;
	b=q/5ThPYrwTJ0NpRAIK2MdhToJ6kfXCcTTNby/bMI7vzYtARwvPnFv6YcLvbSVGs0BPks
	 /nghePFKSpY15qcVrpmdVKFIaN30LNAEe83XV9kB/01VOIheGu3QruqxgzULcjCVqADsR
	 LN22JrVs5AJn7cm7tUplyH0l6/1vO84+oyLIwRwrTvEGhzEjoVqLehk9JwDioysQZNSEY
	 2Y46/obKRTGjPzVAnV3N2vNU1/7F/bs5Wqe2Z0J/9keiUo6m52/8SbQw3SEq1v4RNW7w0
	 h3OpdQBHjLcTc6CJoynD0ffF+Epcj7FiOI0D+6Oe4RVpgECSHaJBe7lvqiawA5F9RWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016771;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+CJUOGM1tzuGITh7QKxXwQmOkCpn78xWtirxPoDHX3o=;
	b=H9bZ9dyJ+/mtTJGScMJOL+KpP/13vM3qLWQ9bQe9/D8alCJxhpRK9nBH8y7gqtUVArms
	 4C570bjKZL3SSuJ1NsPGrkdtiJw/08AR98WS8VoY0j5U2V7TSOE+YOisPPWqkm5oGkNBf
	 hPFe5Ukzg0JqJkyDcLQhtvuid2c1fcLujWKgw+VhRmgACJvgR3F7O2yKBBiEjz6jIntuE
	 1y44x2IbSw5WyGHp0YbRbsbB7ngsPdCNp1bHod9NgVFnSnA0hIV+sJYlx1SfeT22sGcgG
	 8S5tHg8HzGPQYMru10T2UxEEpVgls5wYGjoD96iNNkReRKYzv2QJYm6uayFAyily2Ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAqpP1kS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6917E606A325;
	Wed, 18 Nov 2026 15:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rAqpP1kS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C6F21F000C4;
	Wed, 18 Nov 2026 15:46:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016770;
	bh=+CJUOGM1tzuGITh7QKxXwQmOkCpn78xWtirxPoDHX3o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rAqpP1kS2q+hJyZpZFavn0Qln5eYuExClGFA57O/5f6uYcOZNMzSSrvwoJOZ0lTbM
	 cHYamWivfOmeV1EuYhyai5P8ai5oktVd4myHAJCIzIn1J92hO29mGVbGXBE1hKSNNH
	 KeWS3sOxOwMx+XK1Dpz/T66BZaXJrEQXh4i8I0Lk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0645/2651] perf build: Remove leftovers of removed build options
Date: Wed, 18 Nov 2026 15:31:25 +0100
Message-ID: <20261118150310.902124112@linuxfoundation.org>
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
index 29cfd44c427f3..3f757b086071f 100644
--- a/tools/perf/Makefile.perf
+++ b/tools/perf/Makefile.perf
@@ -64,9 +64,6 @@ include ../scripts/utilities.mak
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
index d2c2f526e1db0..c4c3cf4737fe1 100644
--- a/tools/perf/tests/make
+++ b/tools/perf/tests/make
@@ -155,7 +155,6 @@ run += make_no_demangle
 run += make_no_libelf
 run += make_no_libdw
 run += make_libunwind
-run += make_no_libdw_dwarf_unwind
 run += make_no_backtrace
 run += make_no_libcapstone
 run += make_libcapstone_dlopen
@@ -165,10 +164,8 @@ run += make_no_libbpf
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



