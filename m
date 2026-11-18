Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033400;
	b=KEhCEa3VfYqJBrn0YqsZmfLXwBEnEnr93C5+iZdaP7y2bSIIVBCEOix6EyHD9c7xAshE
	 tOIoffw9otQnthpeWTTQjzUAHRq1zcgwjvDlwCaLXK7ScsKbQ9diDgjNHLTh4ZjQcVkXE
	 9IWQAx/xEDVUO9/P5QL7Loan7cFjSCl98rqrddMB6dlCVc6/2hKOUwUVjUIP80EeYGeNv
	 6CSLDZBrZqEsGa0gK2g/QeGBFBfSv8ZObIrim0Lq+7yH8t00sgB32VO7sAU3bW/aC7Qik
	 XhEMg9fbrKEjRXnxxThpgGKUJk0ljoTv1g4O7PIgxqMSax1spQwy5elZeHF4f1mYSKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=YUquKB7pgJfm7fVvDvX40gt9F9rmfo3inJSMcUlMBBg=;
	b=brGCl8G9CNXAJPATBsgc9+Rx7KrJhl9goTsNXxbRTo3sRf+MmGOQj/xuTXmOJsgD3uu3
	 jLl1ylliAkCz70GEjn4UNqPYr+6DX74z7obSw7wkNA7RMnfh5V/xqBgRzkxBT01PgOhi/
	 viFhnlx7VdJVEIIj4GADrpwTrEnKND5VSFpFSyR5D6JKCVXartrTREeI/sP6AHahsbeNi
	 DdlDqH/eUhWNISW+dzrTpGMWLJ7yI44j3PU2HJTMRojeTUpMQGLjPLPH2OqmkGrFF5S0F
	 EbNV8cGDHgVvKkH/LcCnyhz75ks3uZa3zJ07mrAZdnjbveN4vOMOwf/ZchcBr5b567Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SnkjkNU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FCD9606A31C;
	Wed, 18 Nov 2026 20:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1SnkjkNU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 025291F000C4;
	Wed, 18 Nov 2026 20:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033400;
	bh=YUquKB7pgJfm7fVvDvX40gt9F9rmfo3inJSMcUlMBBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1SnkjkNUvmbZniqIBYvMpZdHBBy/xd8sk2DfO9xcpCgMQkIT49F3a0GbXWFB3t/1l
	 nAabFlnm1/Ixcb1Ty1CXUbt585pU48UJymOHjV7DJWJfer9e8Vgyf5siX0T7qiuG99
	 WCmaf6fMASSE8AMDyQkBH4lGEz48UnnsFD16zglo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Yan <leo.yan@arm.com>,
	James Clark <james.clark@linaro.org>,
	Namhyung Kim <namhyung@kernel.org>
Subject: [PATCH 6.12 1738/1756] perf tools: Fix compilation error on arm64
Date: Wed, 18 Nov 2026 16:04:25 +0100
Message-ID: <20261118150118.743090406@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

commit d18c882f85745f3c622e74b93151514b745de2ca upstream.

Since the commit dc6d2bc2d893 ("perf sample: Make user_regs and
intr_regs optional"), the building for Arm64 reports error:

arch/arm64/util/unwind-libdw.c: In function ‘libdw__arch_set_initial_registers’:
arch/arm64/util/unwind-libdw.c:11:32: error: initialization of ‘struct regs_dump *’ from incompatible pointer type ‘struct regs_dump **’ [-Werror=incompatible-pointer-types]
   11 |  struct regs_dump *user_regs = &ui->sample->user_regs;
      |                                ^
cc1: all warnings being treated as errors
make[6]: *** [/home/niayan01/linux/tools/build/Makefile.build:85: arch/arm64/util/unwind-libdw.o] Error 1
make[5]: *** [/home/niayan01/linux/tools/build/Makefile.build:138: util] Error 2
arch/arm64/tests/dwarf-unwind.c: In function ‘test__arch_unwind_sample’:
arch/arm64/tests/dwarf-unwind.c:48:27: error: initialization of ‘struct regs_dump *’ from incompatible pointer type ‘struct regs_dump **’ [-Werror=incompatible-pointer-types]
   48 |  struct regs_dump *regs = &sample->user_regs;
      |                           ^

To fix the issue, use the helper perf_sample__user_regs() to retrieve
the user_regs.

Fixes: dc6d2bc2d893 ("perf sample: Make user_regs and intr_regs optional")
Signed-off-by: Leo Yan <leo.yan@arm.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Link: https://lore.kernel.org/r/20250214111025.14478-1-leo.yan@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/arch/arm64/tests/dwarf-unwind.c |    2 +-
 tools/perf/arch/arm64/util/unwind-libdw.c  |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/tools/perf/arch/arm64/tests/dwarf-unwind.c
+++ b/tools/perf/arch/arm64/tests/dwarf-unwind.c
@@ -46,7 +46,7 @@ static int sample_ustack(struct perf_sam
 int test__arch_unwind_sample(struct perf_sample *sample,
 		struct thread *thread)
 {
-	struct regs_dump *regs = &sample->user_regs;
+	struct regs_dump *regs = perf_sample__user_regs(sample);
 	u64 *buf;
 
 	buf = calloc(1, sizeof(u64) * PERF_REGS_MAX);
--- a/tools/perf/arch/arm64/util/unwind-libdw.c
+++ b/tools/perf/arch/arm64/util/unwind-libdw.c
@@ -8,7 +8,7 @@
 bool libdw__arch_set_initial_registers(Dwfl_Thread *thread, void *arg)
 {
 	struct unwind_info *ui = arg;
-	struct regs_dump *user_regs = &ui->sample->user_regs;
+	struct regs_dump *user_regs = perf_sample__user_regs(ui->sample);
 	Dwarf_Word dwarf_regs[PERF_REG_ARM64_MAX], dwarf_pc;
 
 #define REG(r) ({						\


