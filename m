Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 619E94E1D8;
	Tue, 23 Jan 2024 00:33:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969999; cv=none; b=BHO8QN3/eqo9o88PVCmwIQvOGjBfsR1WQ0+fv6IL55YVl0rkbIXkynRlJmbNFOGkBgkpmPjVuRb3bTo5jxBMQyeSW3cnoCEubindo8/oUXhp2rNGFSiJnD8TZZFGZ5zM2YpAm+D7m+F8lUM7QzYD9RTJsbnDd+3y1tFy2APgqd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969999; c=relaxed/simple;
	bh=fLymaInPtAAwgoeZ5VsdNsz2ncoVA5YtzUPECDyXJiY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ManCQGqahdLWrpeiAnkVAxLPuz1FHWNdMQIz8z9MwWI99qfG3exwlQK4s2+FvQMJ20RDHmrpbkKL9EHBq1Nkq5wmAMczdPc14mQ9HmIO5AX69jKxT9pqR7/Z4Aar4ynrEyKn+k6kuhIinkr95mbJH0T+MoXsOySWRYqQJfI+hSU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h7q0//p0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h7q0//p0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25B9C433C7;
	Tue, 23 Jan 2024 00:33:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969999;
	bh=fLymaInPtAAwgoeZ5VsdNsz2ncoVA5YtzUPECDyXJiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h7q0//p0A+BPoI++MIWnq1VOE1DkL1P+SEAFIRUvr9QyHxTGSfIMyP10/6j1nBa8v
	 M3ieD9UU6TgkMIPYV21UTmQd2l1Tkv3CzxmOAGEy97O8Ao0EpIBOBrFPND449muzvV
	 mAXe6B/87ccghWotQSjPR2oaIIKSCEtNb1ZvAiyk=
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
Subject: [PATCH 6.7 534/641] perf genelf: Set ELF program header addresses properly
Date: Mon, 22 Jan 2024 15:57:18 -0800
Message-ID: <20240122235834.826824581@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



