Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDB6212F5A7;
	Tue, 23 Jan 2024 00:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969031; cv=none; b=DUB1tKr/go1fy6wny2RmxYHtagGVifOM7p2yzwvCOTjmb0jfRNzjqHnBZxrHdeb5W1/hl8DWL7287hQL2qz5UJ7mG0/RsZdyZCKWJM4VDZ9m4gGx1NI5O3X/5cNJOKM1A6BSTFFLJRoeHuX2SSIPWM06EFoJH6bJv4NmbJV5y8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969031; c=relaxed/simple;
	bh=uOsOF6zfyNWZOKuDLZ97N0hpt0NKT0EiXMNAk1qfY4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EkbhoyJ/WCaWDhpEP4HuwgOo7eK7eWlDx+qlaMnM6EXdFMDmvUtinU1F4EJHipFXFsP07kZYaYvC3tCyxYHb0RL5uQzTRQ4EHu+8AiqBpWh4ImJjbeDU6Gu7R/2u+DNCt/ZIn2RtL8ysp00Wdn1dfhybuTORTYK1FYpw91ks+4w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jdos+z03; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jdos+z03"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FF19C433F1;
	Tue, 23 Jan 2024 00:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969030;
	bh=uOsOF6zfyNWZOKuDLZ97N0hpt0NKT0EiXMNAk1qfY4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jdos+z03Gm8+MOTmN8Ya5I+3eMmnXMgplKo3+VrWyGnq5xdpILOdRaXxGvfiXVL/C
	 LS0wDuQYCS2hnG6aNW66GIsZ6/3QCo94zMS7CaE1nkhUWEvIEKIHP+mTAS5rNMLkEJ
	 6riK+ovXwDKs6hhqiOmQtiSDWPEv1hmOd3j2YQGU=
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
Subject: [PATCH 5.4 170/194] perf genelf: Set ELF program header addresses properly
Date: Mon, 22 Jan 2024 15:58:20 -0800
Message-ID: <20240122235726.489019534@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 69744fd5db39..04509144ff84 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -296,9 +296,9 @@ jit_write_elf(int fd, uint64_t load_addr, const char *sym,
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



