Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033406;
	b=Fp3dEIjCblC+vtLRAPwMt/G/xjrWH0kDXba1NwR1WhFYAGeHW4Kuwz7UVO/uln8/qN48
	 3rTUgh1dNszbMU+cwEN/goqss30+awryl0sEC5z9eUOwNJznBZXbGDi3orU//UU+ME6ro
	 PlQWXKjTZZiOubfv1LAmiCfJsHQB/M64mAY0o5Uq4KSewn3YtDrcxwPv1oGHAjN8T5tTU
	 9gA9H//Uss228pZX3aa1o+24sazafDLixeAWotkQzpbLWdrQiyM2qHd+QwkOvdJZMdCVH
	 SffRf5JfOgzA/8kVD/6Y4e2zwi2uq51BahC3vsCeOOCCNpet+BlmopzqSye8cf/7d0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=SMrV9yFD2Ht/7ubbq/l/abTVPQyK/ArHITNhKv1oGyE=;
	b=Q4T6C9F9eEY8pzWHHTeKdSTHxPxPVS0455QXlz7fHG6vzBt0rdisVtOZY8w1xQ6aMiXY
	 isBZ1GcSuFr7OyXknWYCLAbUcAkbFLc0TXq/KvAX6ShPe/n1JxgSNX8jYxw0rl8NrkHsC
	 9J75goXPw/iKxGwfEnwerFJTbKoxc8gVeGJZ1t3u3fwGtCCp9j6ETovIwmfB2sMC9CQGH
	 R96dc9KHXUBWyFA4O7T/tQ8yva1IZftzbDrAL63FPCtONR5l1R8Q2t2I9kcxsVL1pHRC+
	 NJ90X13EFT71KLZ9apcrqZmsBIDrG4vEGjM59/TyWSgIe24TJLlIL+hIoKZrQ44rS6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbAgmvJ2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A9E606A32F;
	Wed, 18 Nov 2026 20:23:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbAgmvJ2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98AF01F000C4;
	Wed, 18 Nov 2026 20:23:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033406;
	bh=SMrV9yFD2Ht/7ubbq/l/abTVPQyK/ArHITNhKv1oGyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbAgmvJ2dDCNaalVGyNuhE/SagxwjBGB0OdvMJQMwDgFgx0fPtF4FKLPTsyZty9Zc
	 FuFBttz7rCfBI+1CGY195qTvtqYLEaFm6O8y8C8NBoAcKIaSCQ7+GxbaQZKnLBnfL0
	 8B8dK5pxNw2fP3RoeHvOgqIXGC0PedZvdIenEPfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stephen Rothwell <sfr@canb.auug.org.au>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.12 1739/1756] perf tools: Fix compile error on sample->user_regs
Date: Wed, 18 Nov 2026 16:04:26 +0100
Message-ID: <20261118150118.778533271@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

commit 20600b8aab734877740d5292c0cdd5ccb6c7beb7 upstream.

It's recently changed to allocate dynamically but misses to update some
arch-dependent codes to use perf_sample__user_regs().

Fixes: dc6d2bc2d893a878 ("perf sample: Make user_regs and intr_regs optional")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Reviewed-by: Ian Rogers <irogers@google.com>
Link: https://lore.kernel.org/r/20250214191641.756664-1-namhyung@kernel.org
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/arch/arm/tests/dwarf-unwind.c      |    2 +-
 tools/perf/arch/arm/util/unwind-libdw.c       |    2 +-
 tools/perf/arch/csky/util/unwind-libdw.c      |    2 +-
 tools/perf/arch/loongarch/util/unwind-libdw.c |    2 +-
 tools/perf/arch/powerpc/tests/dwarf-unwind.c  |    2 +-
 tools/perf/arch/powerpc/util/unwind-libdw.c   |    2 +-
 tools/perf/arch/riscv/util/unwind-libdw.c     |    2 +-
 tools/perf/arch/s390/util/unwind-libdw.c      |    2 +-
 8 files changed, 8 insertions(+), 8 deletions(-)

--- a/tools/perf/arch/arm/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm/tests/dwarf-unwind.c
@@ -46,7 +46,7 @@ static int sample_ustack(struct perf_sam
 int test__arch_unwind_sample(struct perf_sample *sample,
 			     struct thread *thread)
 {
-	struct regs_dump *regs = &sample->user_regs;
+	struct regs_dump *regs = perf_sample__user_regs(sample);
 	u64 *buf;
 
 	buf = calloc(1, sizeof(u64) * PERF_REGS_MAX);
--- a/tools/perf/arch/arm/util/unwind-libdw.c
+++ b/tools/perf/arch/arm/util/unwind-libdw.c
@@ -8,7 +8,7 @@
 bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
 {
 	struct unwind_info *ui = arg;
-	struct regs_dump *user_regs = &ui->sample->user_regs;
+	struct regs_dump *user_regs = perf_sample__user_regs(ui->sample);
 	Dwarf_Word dwarf_regs[PERF_REG_ARM_MAX];
 
 #define REG(r) ({						\
--- a/tools/perf/arch/csky/util/unwind-libdw.c
+++ b/tools/perf/arch/csky/util/unwind-libdw.c
@@ -10,7 +10,7 @@
 bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
 {
 	struct unwind_info *ui = arg;
-	struct regs_dump *user_regs = &ui->sample->user_regs;
+	struct regs_dump *user_regs = perf_sample__user_regs(ui->sample);
 	Dwarf_Word dwarf_regs[PERF_REG_CSKY_MAX];
 
 #define REG(r) ({						\
--- a/tools/perf/arch/loongarch/util/unwind-libdw.c
+++ b/tools/perf/arch/loongarch/util/unwind-libdw.c
@@ -10,7 +10,7 @@
 bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
 {
 	struct unwind_info *ui = arg;
-	struct regs_dump *user_regs = &ui->sample->user_regs;
+	struct regs_dump *user_regs = perf_sample__user_regs(ui->sample);
 	Dwarf_Word dwarf_regs[PERF_REG_LOONGARCH_MAX];
 
 #define REG(r) ({							\
--- a/tools/perf/arch/powerpc/tests/dwarf-unwind.c
+++ b/tools/perf/arch/powerpc/tests/dwarf-unwind.c
@@ -46,7 +46,7 @@ static int sample_ustack(struct perf_sam
 int test__arch_unwind_sample(struct perf_sample *sample,
 			     struct thread *thread)
 {
-	struct regs_dump *regs = &sample->user_regs;
+	struct regs_dump *regs = perf_sample__user_regs(sample);
 	u64 *buf;
 
 	buf = calloc(1, sizeof(u64) * PERF_REGS_MAX);
--- a/tools/perf/arch/powerpc/util/unwind-libdw.c
+++ b/tools/perf/arch/powerpc/util/unwind-libdw.c
@@ -16,7 +16,7 @@ static const int special_regs[3][2] = {
 bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
 {
 	struct unwind_info *ui = arg;
-	struct regs_dump *user_regs = &ui->sample->user_regs;
+	struct regs_dump *user_regs = perf_sample__user_regs(ui->sample);
 	Dwarf_Word dwarf_regs[32], dwarf_nip;
 	size_t i;
 
--- a/tools/perf/arch/riscv/util/unwind-libdw.c
+++ b/tools/perf/arch/riscv/util/unwind-libdw.c
@@ -10,7 +10,7 @@
 bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
 {
 	struct unwind_info *ui = arg;
-	struct regs_dump *user_regs = &ui->sample->user_regs;
+	struct regs_dump *user_regs = perf_sample__user_regs(ui->sample);
 	Dwarf_Word dwarf_regs[32];
 
 #define REG(r) ({						\
--- a/tools/perf/arch/s390/util/unwind-libdw.c
+++ b/tools/perf/arch/s390/util/unwind-libdw.c
@@ -11,7 +11,7 @@
 bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
 {
 	struct unwind_info *ui = arg;
-	struct regs_dump *user_regs = &ui->sample->user_regs;
+	struct regs_dump *user_regs = perf_sample__user_regs(ui->sample);
 	Dwarf_Word dwarf_regs[ARRAY_SIZE(s390_dwarf_regs)];
 
 #define REG(r) ({						\


