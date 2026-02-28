Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B002383C69
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302061; cv=none; b=KERxRC3TmmsOPK+JAy+4D0zdXq62dWNmwZdmtjFBUGKIz2SU4ZyWcjPBNipgP/3c0Lq4dwaFohNnkKwi/opfi2ndL2B/zlFfLblZomos6Fc3NMZEs+CZwHhMNMIAYOzRCG4OlwRzv2HBcLDP1l14A7c1JJHDDxrJwqsGQVnrI2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302061; c=relaxed/simple;
	bh=XSBdlFPsPq9MTJBdb9bDxKF/vaIxtqRUfkVgM8aocYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CtSInYPWcl1V2XMhjboD3mVaY1WKoa/s+XWbwVLjpcxA04gm2AdouF7ghA+CZT7Lf6ZijVYKcbJ+kpxY7dbdHOLm0aaw6u/3KPHZYRJxErsnhPndgg2zaFm5WD4QXDq0DFHQXJRrCj5lDRxbTqciragauCBKue4DQs61QHR7TnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cmkoq5aW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cmkoq5aW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC344C19424;
	Sat, 28 Feb 2026 18:07:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302061;
	bh=XSBdlFPsPq9MTJBdb9bDxKF/vaIxtqRUfkVgM8aocYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Cmkoq5aWelrMgccqGRd7hfUkAV/Ms2/36CsPmQSmF/L9OLf1kVdr1G0DZOxR2X1TS
	 SvzjnIPCTNGj1mAegoCc1Xjhs2agx2+qfXs0eCGJQmdyoOrzT7r8CdY81LdBuQLVHA
	 kux1AyXpGLggvqJVHJx6Qt69EgasTo+sE+Zfd35+XD1pg6zzeLn9+s62P3n2/TBv4K
	 9dFXpQ0Z/pHS2A8izSA3uftgOB7805RWetWbLaizhMnSo+xs6ZbCJnte2ZKIXzFA9H
	 M3WPjSWz32ayraTzu+7pnJnUX/CaIlmB1vO8VH4XijpEMIxswQEdNt1mHXSYwAZzPK
	 w6ftqCnlM1yyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 038/283] selftests/bpf: veristat: fix printing order in output_stats()
Date: Sat, 28 Feb 2026 13:03:00 -0500
Message-ID: <20260228180709.1583486-38-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 611b5a0a6f7e3..fab89a84119f8 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -1372,7 +1372,7 @@ static void output_stats(const struct verif_stats *s, enum resfmt fmt, bool last
 	if (last && fmt == RESFMT_TABLE) {
 		output_header_underlines();
 		printf("Done. Processed %d files, %d programs. Skipped %d files, %d programs.\n",
-		       env.files_processed, env.files_skipped, env.progs_processed, env.progs_skipped);
+		       env.files_processed, env.progs_processed, env.files_skipped, env.progs_skipped);
 	}
 }
 
-- 
2.51.0

