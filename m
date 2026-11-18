Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040466;
	b=mLd3AoZMmfZKSL3FHqNxhrPs3Ahjf+a049tBArqW/9ES84o8igJH6sVEgFFPdopHlTGT
	 OVd10zAGsZZnZ5AX49D/D0dqktfgoF7E0O9dU0Yqp+gYHGQlCAHkvRLbEz3jFxuyC4ROY
	 s5MFk779HnPBWMIuY2j7cxqwWQCoey4xbdfzd1o48+uy8xKhNHcWcPD03iMREeE4U+Hz5
	 GDXvQZ9lVx1RZIVlIazLvfj2Ah3jf6bMECg4ttgbUEE55OmlKAEaiA0PKyLF1DTwqB3qA
	 pIu1XnWbHi2Je/7qrCnGymLktRQfWvKrJwbAGFoSu3MdXga+Baek+Ar9VWCxePJGNmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/mrGEYikq+EbCJGELLlIj7W+A9TukoOxWRuapUPVtVw=;
	b=BhvCfeSB17+AR6CH/zpJePKAdzob07H4PqkEh2ERRJ6Gh0E3nFI7ZLuOlCJKb43wJ8jm
	 7q4d/jQDLEBKl2aweba3m2PGxGOK53MQRsxF7eEL/iIO2/cND27qqRTyll11+aCBn+R86
	 o/XvoII2BaP9xc+Gtm6iUiZenrsMqvxb//PQrHxp3o3RaZuV1Co4lSXkAe1gEd4GnCbzN
	 60ZJcepwKLSv76JcVgZa3rxBYMasrlXwZDDCtPynZn4xaxWrJkgpD4KWks3jLi1+EeJQ5
	 YTklfyVe8GWAI3RwyAYpZCt25G+6REhviDJ27qkqHiSUedYJj3HdmPVrjbh9f3fnsLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUBZIWcx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66E6D606A31C;
	Wed, 18 Nov 2026 22:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HUBZIWcx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5BD1F000C4;
	Wed, 18 Nov 2026 22:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040466;
	bh=/mrGEYikq+EbCJGELLlIj7W+A9TukoOxWRuapUPVtVw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HUBZIWcxr3vzYRZwGGiQpd3cmQweXLH5VK3+vnuPn/uckQUYit7wOq4kS9yOZKIDl
	 ijE/yzGbV8qwzTGeOCovE+rKsPARnJWBypzm/067Zqj3ZQZrR4clGtuREmJeV33sPj
	 ETXAlkQ4HSjeYNrG6HgX6n+kTZj+RpAP9wHh9oIo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alireza Haghdoost <haghdoost@uber.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2467/3318] perf symbols: Dont let a modules last symbol overlap the next module
Date: Wed, 18 Nov 2026 15:51:29 +0100
Message-ID: <20261118150435.427695898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alireza Haghdoost <haghdoost@uber.com>

[ Upstream commit 45d15e89a783a0a279b7a54f9018c230127380d7 ]

symbols__fixup_end() extends a zero-size symbol that is the last one in
the kernel or in a module to the end of the next page. On x86 the next
module can start in that page, so the stretched symbol overlaps it, and
a lookup can return the wrong symbol. For example:

  ffffffffc0c4aa50 t dca_sysfs_exit    [dca]
  ffffffffc0c4b000 t __nft_trace_packet [nf_tables]
  ffffffffc0c4b0b0 t nft_do_chain      [nf_tables]

dca_sysfs_exit gets end 0xffffffffc0c4c000, and samples in nft_do_chain
are reported as dca_sysfs_exit.

This patch clamps the end to the next symbol's start. The ARM case this
code was added for, where the next module is far away, is unchanged.

Add a "Kallsyms symbol ends" test case to the Symbols suite that covers
the kernel/module boundary, adjacent modules and a distant module.

Fixes: 8799ebce84d672aa ("perf symbol: Update symbols__fixup_end()")
Fixes: bacefe0c7b77b752 ("perf tools: Fixup module symbol end address properly")
Signed-off-by: Alireza Haghdoost <haghdoost@uber.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/symbols.c | 96 +++++++++++++++++++++++++++++++++++++-
 tools/perf/util/symbol.c   |  4 ++
 2 files changed, 99 insertions(+), 1 deletion(-)

diff --git a/tools/perf/tests/symbols.c b/tools/perf/tests/symbols.c
index 16e1c5502b094..db58ae791a4cc 100644
--- a/tools/perf/tests/symbols.c
+++ b/tools/perf/tests/symbols.c
@@ -2,6 +2,7 @@
 #include <linux/compiler.h>
 #include <linux/string.h>
 #include <sys/mman.h>
+#include <inttypes.h>
 #include <limits.h>
 #include "debug.h"
 #include "dso.h"
@@ -149,4 +150,97 @@ static int test__symbols(struct test_suite *test __maybe_unused, int subtest __m
 	return ret;
 }
 
-DEFINE_SUITE("Symbols", symbols);
+struct kallsyms_sym {
+	u64 start;
+	const char *name;
+};
+
+/*
+ * kallsyms from an x86 host where nf_tables was loaded in the page right
+ * after the last symbol of dca, plus a kernel symbol followed closely by a
+ * module and a module far away from the others.
+ */
+static const struct kallsyms_sym kallsyms_syms[] = {
+	{ 0xffffffff81000000, "_stext" },
+	{ 0xffffffff81000ff0, "last_kernel_symbol" },
+	{ 0xffffffff81001000, "near_module_symbol\t[near]" },
+	{ 0xffffffffc0c4aa40, "dca_exit\t[dca]" },
+	{ 0xffffffffc0c4aa50, "dca_sysfs_exit\t[dca]" },
+	{ 0xffffffffc0c4b000, "__nft_trace_packet\t[nf_tables]" },
+	{ 0xffffffffc0c4b0b0, "nft_do_chain\t[nf_tables]" },
+	{ 0xffffffffc0c4b4e0, "nf_tables_core_module_exit\t[nf_tables]" },
+	{ 0xffffffffc2000000, "far_module_symbol\t[far]" },
+};
+
+static int check_symbol(struct dso *dso, u64 addr, const char *name, u64 end)
+{
+	struct symbol *sym = dso__find_symbol_nocache(dso, addr);
+
+	if (!sym || strcmp(sym->name, name)) {
+		pr_debug("%#" PRIx64 ": expected %s, got %s\n", addr, name,
+			 sym ? sym->name : "no symbol");
+		return TEST_FAIL;
+	}
+	if (sym->end != end) {
+		pr_debug("%s: expected end %#" PRIx64 ", got %#" PRIx64 "\n",
+			 name, end, sym->end);
+		return TEST_FAIL;
+	}
+	return TEST_OK;
+}
+
+static int test__kallsyms_fixup_end(struct test_suite *test __maybe_unused,
+				    int subtest __maybe_unused)
+{
+	struct dso *dso = dso__new("[kernel.kallsyms]");
+	int ret = TEST_FAIL;
+
+	if (!dso)
+		return TEST_FAIL;
+
+	for (unsigned int i = 0; i < ARRAY_SIZE(kallsyms_syms); i++) {
+		struct symbol *sym = symbol__new(kallsyms_syms[i].start, 0, 0, 0,
+						 kallsyms_syms[i].name);
+
+		if (!sym)
+			goto out;
+		symbols__insert(dso__symbols(dso), sym);
+	}
+
+	symbols__fixup_end(dso__symbols(dso), true);
+
+	ret = TEST_OK;
+	/* The next symbol is too close for the end of the page. */
+	if (check_symbol(dso, 0xffffffff81000ff8, "last_kernel_symbol",
+			 0xffffffff81001000))
+		ret = TEST_FAIL;
+	if (check_symbol(dso, 0xffffffffc0c4aa58, "dca_sysfs_exit\t[dca]",
+			 0xffffffffc0c4b000))
+		ret = TEST_FAIL;
+	if (check_symbol(dso, 0xffffffffc0c4b280, "nft_do_chain\t[nf_tables]",
+			 0xffffffffc0c4b4e0))
+		ret = TEST_FAIL;
+
+	/* Far from the next module, the end of the page is still used. */
+	if (check_symbol(dso, 0xffffffffc0c4b4f0,
+			 "nf_tables_core_module_exit\t[nf_tables]",
+			 0xffffffffc0c4d000))
+		ret = TEST_FAIL;
+	if (check_symbol(dso, 0xffffffff81001008, "near_module_symbol\t[near]",
+			 0xffffffff81002000))
+		ret = TEST_FAIL;
+out:
+	dso__put(dso);
+	return ret;
+}
+
+static struct test_case tests__symbols[] = {
+	TEST_CASE("Symbols", symbols),
+	TEST_CASE("Kallsyms symbol ends", kallsyms_fixup_end),
+	{ .name = NULL, }
+};
+
+struct test_suite suite__symbols = {
+	.desc = "Symbols",
+	.test_cases = tests__symbols,
+};
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 18556b7a76563..a99ff9d2bdf95 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -251,6 +251,10 @@ void symbols__fixup_end(struct rb_root_cached *symbols, bool is_kallsyms)
 			else
 				prev->end = curr->start;
 
+			/* The next module can start within that page */
+			if (prev->end > curr->start)
+				prev->end = curr->start;
+
 			pr_debug4("%s sym:%s end:%#" PRIx64 "\n",
 				  __func__, prev->name, prev->end);
 		}
-- 
2.53.0



