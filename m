Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EFD3590A9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300900; cv=none; b=u8YuBNg+DxWqshrBwlNL7Q3XIs6kNJlQRIXPsP8XP8geZZwp8JRYsoq3bbrgkgQ7X7fudwCLk59Zc85npVhbjWvfdddkAO1ApxXPPBLn4k9Z5shXGoFTZO0qM9gmAPxeoZvrUm6dmStaXO8DH4xhPEAIShCwv1UMu4hxdWc2MXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300900; c=relaxed/simple;
	bh=ju/cObCjni0YRQv4DzRxOcJm3xs1KipcvlF4yKEEMNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pstEAPtwBVWhoJWlk294nMaSGo7AKh9a10HJXEFr7Ki4JsorpskTS3VSeQDYg11t9ObTmEpiBQLlIhB3d9O7KJuFcX0oDv93GdMv2nAzdfRrE3Qs2c0N7H4k0qbLCOFgcbKEjBpJGhodmNIi8S1v8ac2xMH9yfXwUqcsNLJTq0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LoovFS/3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LoovFS/3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE911C19424;
	Sat, 28 Feb 2026 17:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300900;
	bh=ju/cObCjni0YRQv4DzRxOcJm3xs1KipcvlF4yKEEMNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LoovFS/3+CrftCNahLThTzcf3e1CXpTEEJLMWFHIup76TkhHESuylTFWSDqZm0C3O
	 vW8mIG14SaXvOyPz4BlrI/9csYl5vcMGt+U0r5uedkjx4MdoT1buM9AGFCJZvsqOzJ
	 F9EisNQoGi6NcrUTPwqBidmcXY/A1ytNN3ufTTRuwU6GYB+ibCUdrOXZ9ndb8Q9Uh7
	 YcwUmKx0dnaKF5BdmcPZcy4O+P4uUMurSCGTiXfLUiyQhz/lqNz5v0oCjdcE4NguXI
	 BcTGcn3PYDBwH52qSGjzb3l0SrqhrJlRG+PQC7hJ+LYGMqfRJf7KqrRiE7xFcEFZPl
	 lZNiCozWG1cgQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>,
	Ian Rogers <irogers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/752] perf annotate: Fix BUILD_NONDISTRO=1 missing args->ms conversions to pointer
Date: Sat, 28 Feb 2026 12:35:27 -0500
Message-ID: <20260228174750.1542406-16-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit dda5f926a1006c735b00ed5c27291fce64236656 ]

Fix a few missing conversions to pointer in the usage of 'struct
annotate_args' 'ms' member in symbol__disassemble_bpf_libbfd().

Fixes: 00419892bac28bf1 ("perf annotate: Fix args leak of map_symbol")
Reviewed-by: Ian Rogers <irogers@google.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/libbfd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/tools/perf/util/libbfd.c b/tools/perf/util/libbfd.c
index 6434c2dccd4a4..2324f6846d510 100644
--- a/tools/perf/util/libbfd.c
+++ b/tools/perf/util/libbfd.c
@@ -494,7 +494,7 @@ int symbol__disassemble_bpf_libbfd(struct symbol *sym __maybe_unused,
 	struct bpf_prog_info_node *info_node;
 	int len = sym->end - sym->start;
 	disassembler_ftype disassemble;
-	struct map *map = args->ms.map;
+	struct map *map = args->ms->map;
 	struct perf_bpil *info_linear;
 	struct disassemble_info info;
 	struct dso *dso = map__dso(map);
@@ -605,7 +605,7 @@ int symbol__disassemble_bpf_libbfd(struct symbol *sym __maybe_unused,
 			args->line = strdup(srcline);
 			args->line_nr = 0;
 			args->fileloc = NULL;
-			args->ms.sym  = sym;
+			args->ms->sym = sym;
 			dl = disasm_line__new(args);
 			if (dl) {
 				annotation_line__add(&dl->al,
@@ -617,7 +617,7 @@ int symbol__disassemble_bpf_libbfd(struct symbol *sym __maybe_unused,
 		args->line = buf + prev_buf_size;
 		args->line_nr = 0;
 		args->fileloc = NULL;
-		args->ms.sym  = sym;
+		args->ms->sym = sym;
 		dl = disasm_line__new(args);
 		if (dl)
 			annotation_line__add(&dl->al, &notes->src->source);
-- 
2.51.0

