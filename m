Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10DE3382D6
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301653; cv=none; b=DiIB9pXkkW/nlBzCX/ya3jqswAvchnk5pZEBq49m/oykLXkS18eAheiUO75OOlL2YHCIW53P7bnD7pH7Jy62tcKrtr9ArGYX8vqH35mZCxBAM2rBqhq1dq0a65f30f5kYps+6RA5s9+RdRrtM4Xu8ApmwNOZAnBAurB+7l+zosI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301653; c=relaxed/simple;
	bh=xrvtJj+wIFBpd+MzSWCrOCLPbhOiZVtg0NUPH/O+O8o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuYUGvMiBz5tdLvusRL8HRMmUFhcgYvPLN7nbc3HDIPC6cNC5xkQcinNNTWPgj1u5++H65dEg6PZwLbw4YoBDf+QvkjeuG5AS6e0mfSS9XFGLm/Y+5VQ0oxYjH7V+13gQxEbPzctQCG9BwDAaHr+/ifRZY5crkO52q7j9rzXse8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J5TKzHA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J5TKzHA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17692C19423;
	Sat, 28 Feb 2026 18:00:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301653;
	bh=xrvtJj+wIFBpd+MzSWCrOCLPbhOiZVtg0NUPH/O+O8o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J5TKzHA5vrtLANHETpwHn4PMoGyy9COdRBIAl38GXSM1n6kmMa76si3J+FYwRTr1F
	 WXVumXa6zyE0yKiKV7KbJy/vlvGE6858MsOrzzGZkkzmJBE84DAwYshoxhyvlk9kuG
	 1vbRARoP1QXC0OGh5Fw1DvlBJlZSUMOvisQf69kKUz8nvsAbzCdQ8BFFQJcYOdFvw7
	 jvIzNqLtrEI9p4caAo/etAeFp9RNuTJo9DHKdGJaGs4vZGIcakqT/Y/uK9Rhbgfhw+
	 R6mreZM5/6+67zIQ3Fj8UGGaRiHvJxfGAyb+TnM9xXLxRuVDuT7ecBQI33psSMvSkY
	 hxsB6puVu6YKA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/385] selftests/bpf: veristat: fix printing order in output_stats()
Date: Sat, 28 Feb 2026 12:54:32 -0500
Message-ID: <20260228180011.1568201-50-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Puranjay Mohan <puranjay@kernel.org>

[ Upstream commit c286e7e9d1f1f3d90ad11c37e896f582b02d19c4 ]

The order of the variables in the printf() doesn't match the text and
therefore veristat prints something like this:

Done. Processed 24 files, 0 programs. Skipped 62 files, 0 programs.

When it should print:

Done. Processed 24 files, 62 programs. Skipped 0 files, 0 programs.

Fix the order of variables in the printf() call.

Fixes: 518fee8bfaf2 ("selftests/bpf: make veristat skip non-BPF and failing-to-open BPF objects")
Tested-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20251231221052.759396-1-puranjay@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/veristat.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/bpf/veristat.c b/tools/testing/selftests/bpf/veristat.c
index 7b6b9c4cadb57..e9d7acff6bbbc 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -1424,7 +1424,7 @@ static void output_stats(const struct verif_stats *s, enum resfmt fmt, bool last
 	if (last && fmt == RESFMT_TABLE) {
 		output_header_underlines();
 		printf("Done. Processed %d files, %d programs. Skipped %d files, %d programs.\n",
-		       env.files_processed, env.files_skipped, env.progs_processed, env.progs_skipped);
+		       env.files_processed, env.progs_processed, env.files_skipped, env.progs_skipped);
 	}
 }
 
-- 
2.51.0

