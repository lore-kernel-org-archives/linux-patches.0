Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA277133435;
	Tue, 23 Jan 2024 01:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971878; cv=none; b=TluuxuNUKQ8QOm+dhtDYivlYnsrIbL1ZfnAEOXMaMxRYBZIjrVQ/wgxc2twkuAxpn2JSoEEij7lEDFlr5saajdMhrRRiOi8f+r5U4+v70Qf7R+RqNlCHsk1DAaYPhz7GOtN3nxCgSEkJ7rncWBI/R2zfTX/iRJ7oqQg80jxl8aE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971878; c=relaxed/simple;
	bh=nj0nT/YAqBBze8KYgv+Z8gKrZ+AhZCtnvXAPQnq+26M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FqcygKyC7yj8IqhiLIyBz+G9065geVy/KUCxwV4AOF3/NzbNYqwTMI642xEw8HGRuTpj7CAS+RGxj5UpqkYCm3n+CVeXgqyc2UvP4Zg50QL4oProZ60/HLrWOFhcsgqWmf3sV9AcsrOSeC/3Ux58t1PHDjkOIIDRDtq+bWMvrvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lkBBuW5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lkBBuW5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36950C433C7;
	Tue, 23 Jan 2024 01:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971878;
	bh=nj0nT/YAqBBze8KYgv+Z8gKrZ+AhZCtnvXAPQnq+26M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lkBBuW5u5ucu5uPLSg8/IigUJDpdfIsNutMitTyyid+yMu9KSzPTobwBtyB+orf0B
	 eUbunrZss7C+W4CFtg3JqY1EkMBSdl5Izj5UxlGsaZCZUAmhOF2RNIrYjuzTOg6wZa
	 grDzvfkVLiTPfwd0d3T2Ge4ozroSIFvv8zKRNYTc=
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
Subject: [PATCH 5.10 252/286] perf genelf: Set ELF program header addresses properly
Date: Mon, 22 Jan 2024 15:59:18 -0800
Message-ID: <20240122235741.754720179@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 02cd9f75e3d2..89a85601485d 100644
--- a/tools/perf/util/genelf.c
+++ b/tools/perf/util/genelf.c
@@ -291,9 +291,9 @@ jit_write_elf(int fd, uint64_t load_addr, const char *sym,
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



