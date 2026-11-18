Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020013;
	b=0J4eabLpNZ3x0WvQpL22m1YlhGwmJwLdi8F1AC38tfHVuAg4U7hV83ENR6vsKTZEWdXv
	 oMXxkv240gOUMmRVkVEI9WQ1vXjcXW1FedETtCQ9EFvFIF20naGTeapUCFoHXI2R2s4dE
	 KDjWOy+WutHNAMga5C+yjU+5rWe/PsiwP3s2Psp6VsA3RfCZrT5njUSOGK/qOlJw1Q/S/
	 EFiMR6ufnAsbdpjb4i7bBwTF3+BA8RTv+aP28gHy5io3tR402Zv8flD/08dmW2MPUrpFQ
	 DL355YlS99nGLGstiiSeq2mYRmh/DhySG36dAsiMJmBW78FPdrK4KaS1wamAv5nhOTA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020013;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=K2MpLtYxjJ3RwJqp1dNUwNPNfFvvGXleaFUK6ElvBr4=;
	b=FTDUIUyr7Mv4VSV3SbQPxVYi7DHLhu+OJufCQdY4ccTAg8AZdaKVS1n9uWFllCroCb7g
	 5BniukrgNkyJ7YX+TiCOnjf0q3EuKDnjAju26LRX1+RV9GKfiHXVqNhFVrn1RmcqKMLdx
	 q0lWvM4Oi4LLUl90D0+UVDn23HUeUaW69AJLR4A8NN7GYE8lHkowdTdh0Z7ODoqGuGsqC
	 zZ1DR/8Sr8hdHgrCNXL/FKK9xeS7GHQOZpGuQmDL9IFSAx/CtdtP44uARvBuLl+dj7zKp
	 PT5OtuKD8emMGFyxNbFT6GtlpUxBwzqKTSvwz2PY9sAiS3Ut4oSyie4hOFycZGOs08Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mv0fPzTs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED35F606A32C;
	Wed, 18 Nov 2026 16:40:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Mv0fPzTs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5167E1F000C4;
	Wed, 18 Nov 2026 16:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020012;
	bh=K2MpLtYxjJ3RwJqp1dNUwNPNfFvvGXleaFUK6ElvBr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mv0fPzTsdUsT/0pud68o2CsiA3UUaJnv3rZpEDlUVydMo11I8dHkF9e5aJRgSrjvC
	 GkQRep1I3rOyDhnVUZtUwvOIELGimrq1pMi70mXj2zhWAIjDuHTNSxxM2+pyKr4BND
	 oTO73ePwmDqdhJ8QAG+/je2Wjy4sn5L26eEx5X6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Remi Bernon <rbernon@codeweavers.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1801/2651] perf symbol: Fix symbol loading from libbfd
Date: Wed, 18 Nov 2026 15:50:41 +0100
Message-ID: <20261118150352.127339120@linuxfoundation.org>
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

From: Namhyung Kim <namhyung@kernel.org>

[ Upstream commit f814d9e6cdbef6413a72d6dd6d5e4e79e815cf44 ]

The dso__load() should return a positive number (number of symbols
loaded) when it succeded to load symbols.  But dso__load_bfd_symbols()
only returns 0 and it's hard to check if it actually loaded symbols or
not.  Let's return the value of dso__has_symbol() and check it in
dso__load() so that it can return 1 for success.

Closes: https://lore.kernel.org/r/sashiko-outbox-162540@kernel.org
Fixes: eac9a4342e5447ca ("perf symbols: Try reading the symbol table with libbfd")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Remi Bernon <rbernon@codeweavers.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/tests/pe-file-parsing.c | 2 +-
 tools/perf/util/libbfd.c           | 2 +-
 tools/perf/util/symbol.c           | 4 ++--
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/perf/tests/pe-file-parsing.c b/tools/perf/tests/pe-file-parsing.c
index 30c7da79e109b..3979f38bf127c 100644
--- a/tools/perf/tests/pe-file-parsing.c
+++ b/tools/perf/tests/pe-file-parsing.c
@@ -59,7 +59,7 @@ static int run_dir(const char *d)
 	TEST_ASSERT_VAL("Failed to get dso", dso);
 
 	ret = dso__load_bfd_symbols(dso, debugfile);
-	TEST_ASSERT_VAL("Failed to load symbols", ret == 0);
+	TEST_ASSERT_VAL("Failed to load symbols", ret > 0);
 
 	dso__sort_by_name(dso);
 	sym = dso__find_symbol_by_name(dso, "main", &idx);
diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index 59f4ab252bb16..3636da74f9784 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -451,7 +451,7 @@ int dso__load_bfd_symbols(struct dso *dso, const char *debugfile)
 	symbols__fixup_duplicate(dso__symbols(dso));
 	dso__set_adjust_symbols(dso, true);
 
-	err = 0;
+	err = dso__has_symbols(dso);
 out_free:
 	free(symbols);
 out_close:
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index a9ff973e6bb2b..06a3b88d7c747 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1929,8 +1929,8 @@ int dso__load(struct dso *dso, struct map *map)
 		if (nsexit)
 			nsinfo__mountns_enter(dso__nsinfo(dso), &nsc);
 
-		if (bfdrc == 0) {
-			ret = 0;
+		if (bfdrc > 0) {
+			ret = 1;
 			break;
 		}
 
-- 
2.53.0



