Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026667;
	b=GJwR6t2QCWvVm+SxvS5xAxe15HsTp8rJfVlethNXaqxe/uPeCwQivplVgq5mnnQdLumd
	 vMhFvWgAjF4kLMCS5VG4h1ZAA83yweGgAuIJcqSe9dRF2Nu/6T2A2nilmVHe8AnTvq4SA
	 DNztFQXMlnnmFSqQxJ0GcBcT3RyNxdly7sGF3pFYVbcaxD5uFolu4ovuh3H8hoAYQwDKo
	 JtUS2Hpxrbg0DC0ztIIETTBD2IVzFnMifxIEqaEmA+M/cuIlwS34gJzXiKuWJFamzaduR
	 DsW3YeuH7TBPlguLHShmMidGhBBWZsWdztLIyb/My2m1ugdKZ2V2S+9Gj1u8sbOZ3qA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026667;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=j0lHqOpTuc3r9dj9enNAei3GHj89wXDGLjVxpfbp5y8=;
	b=1QC74NvJ0OLLTjlreMI1QVaQE0B8p6V9CO6ElozEkj4N7/oawHpY/XY6vGmPGM30jgXI
	 qCVRH+WlpobMYbeXokndObj3/xN/whBM6RH5NnRBHmnFrstuojN2d7Np7KC2q41b4zbT9
	 dFOhslZINMc5tNPjOf5UobVzCk/BN1QpG8hbQfj4/h7Ygb6D+ARd/Wv5U0ONbKDGGz+IT
	 NfAwlW98KtS3hXlZlgs23tAO+nXcvtB+/zPJc+QKXU1VxJh0DkJzvhqHPRrtnX/UHOECQ
	 zZQAREi32Q4YUZguLu9gayjn+KBYd3be93TWEiNkairGgaOq+lo3JbqKicnZ+CnEzuQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0UT580FV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A830C606A320;
	Wed, 18 Nov 2026 18:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0UT580FV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDC771F000C4;
	Wed, 18 Nov 2026 18:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026667;
	bh=j0lHqOpTuc3r9dj9enNAei3GHj89wXDGLjVxpfbp5y8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0UT580FVWiOJ3Qy2UaIP+pvRMAPZyr8vMKYGZDux8fSC3OcxUTmUJqQVRAYodVYFZ
	 Ehhz4zZbLyK1PGnD+uaY8UTg+sCiAn57XhWk9bGnXrk23RidfNpTXsSjWVLB+qEpJY
	 hb6qoNjgH43BZdPlkngZTiGQ51eMDaKK34y4YOnA=
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
Subject: [PATCH 6.18 1464/2151] perf symbol: Fix symbol loading from libbfd
Date: Wed, 18 Nov 2026 15:53:19 +0100
Message-ID: <20261118150215.230467254@linuxfoundation.org>
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
index 04e6e96f716d8..47d691e4af323 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -428,7 +428,7 @@ int dso__load_bfd_symbols(struct dso *dso, const char *debugfile)
 	symbols__fixup_duplicate(dso__symbols(dso));
 	dso__set_adjust_symbols(dso, true);
 
-	err = 0;
+	err = dso__has_symbols(dso);
 out_free:
 	free(symbols);
 out_close:
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index e64668cca6b29..756b318bf6290 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1811,8 +1811,8 @@ int dso__load(struct dso *dso, struct map *map)
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



