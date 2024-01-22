Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0821F77F1D;
	Tue, 23 Jan 2024 02:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975535; cv=none; b=nshdaF/ZexCk6qi/cnUTdxbQNXnSZKVelXUPnfxkwKVGxGBsWuiw+5QcwySbLxvE8tPIa4TOGiPjqLbZHKp8vK6Q+QZiuHonecMqY9v7578MkqBDvrw42PJwOGNY2GiR8pNStTNJMI8bMqrh3BLsHueU/ezbA/c+P1qUmaABb6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975535; c=relaxed/simple;
	bh=yM4Y2Nd+T5SrPE2U3fOgseA39tOpGALo2EwO8s7AQGA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQVhpebJqhLGidgGvvRnVaxmsJ+zb6KpOvHvaxhb1M7sbpuOAFXAZzIdu63uk2Ki7oVZ/nWwm4kyiRt9cew+GtREJlnR6zekQNR3wxJxCsscK/3v2NPzEmk+rCBnIrBl5JB5ne9rwyYcTMniLqo9TiX0f8SGmjmB6Ei0QPDcYMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fdAwPeXR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fdAwPeXR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9747C433C7;
	Tue, 23 Jan 2024 02:05:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975534;
	bh=yM4Y2Nd+T5SrPE2U3fOgseA39tOpGALo2EwO8s7AQGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fdAwPeXRL7YTKe2D0c46XovGPMTSoLsRdtFmfoQwZSyr5rF+phqrkKEctlmudslQ/
	 pFOqRooC5hyh+lPR41BtnbUGAW7kZjgsBFogdAvuFOsIlq9O2qoXUrhCLvD3A6r3/s
	 +5IjAq84IaC4frbm9x9qo5AQqzcm3WYAky+1gf9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Adrian Hunter <adrian.hunter@intel.com>,
	Fangrui Song <maskray@google.com>,
	Ingo Molnar <mingo@kernel.org>,
	Jiri Olsa <jolsa@kernel.org>,
	Lieven Hey <lieven.hey@kdab.com>,
	Milian Wolff <milian.wolff@kdab.com>,
	Pablo Galindo <pablogsal@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 485/583] perf genelf: Set ELF program header addresses properly
Date: Mon, 22 Jan 2024 15:58:56 -0800
Message-ID: <20240122235826.851082675@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit 1af478903fc48c1409a8dd6b698383b62387adf1 ]

The text section starts after the ELF headers so PHDR.p_vaddr and
others should have the correct addresses.

Fixes: babd04386b1df8c3 ("perf jit: Include program header in ELF files")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Fangrui Song <maskray@google.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Lieven Hey <lieven.hey@kdab.com>
Cc: Milian Wolff <milian.wolff@kdab.com>
Cc: Pablo Galindo <pablogsal@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://lore.kernel.org/r/20231212070547.612536-2-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/genelf.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/genelf.c b/tools/perf/util/genelf.c
index fefc72066c4e..ac17a3cb59dc 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -293,9 +293,9 @@ jit_write_elf(int fd, uint64_t load_addr, const char *sym,
 	 */
 	phdr = elf_newphdr(e, 1);
 	phdr[0].p_type = PT_LOAD;
-	phdr[0].p_offset = 0;
-	phdr[0].p_vaddr = 0;
-	phdr[0].p_paddr = 0;
+	phdr[0].p_offset = GEN_ELF_TEXT_OFFSET;
+	phdr[0].p_vaddr = GEN_ELF_TEXT_OFFSET;
+	phdr[0].p_paddr = GEN_ELF_TEXT_OFFSET;
 	phdr[0].p_filesz = csize;
 	phdr[0].p_memsz = csize;
 	phdr[0].p_flags = PF_X | PF_R;
-- 
2.43.0



