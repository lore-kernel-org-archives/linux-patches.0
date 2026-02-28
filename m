Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA78336C9D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302312; cv=none; b=J5mpC7zT43vi4/OhkuY+6MOyocPR1z4EinVhGywFyw8O0hzXxKPUNv9jbSyX41Ic5yJ1L+Kduzz6AurBo0bTrxvF9+H0VUV64g5saa+Z5m64fmk9u4ut060w/ukbR/i4GYWFzp4RDeE6bb8YvtkhSdFXN/a1ZEbVUd2GwI6DaKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302312; c=relaxed/simple;
	bh=8j7UZPKnJdK0Cyluy4HF8WwRZSgTniqOdonPW4n2bk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNmep77604OD6U924xyb+njekc+MVMIbPYMqJL7Kw51s21Gg2SWo9etg/vw+AofHBMv1JFO153A6a0UTCvQJ4YlBtsYYlfGpny1jyLrz3RSVP+CFXbFnfnWYDWjV9vbKGRfKf6rZFH1j5B7/8mka2u0eu2u/o6MrRhQw3FotAVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WMG/SInz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WMG/SInz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23788C116D0;
	Sat, 28 Feb 2026 18:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302312;
	bh=8j7UZPKnJdK0Cyluy4HF8WwRZSgTniqOdonPW4n2bk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMG/SInzydt8MNMI4+E5CncbqdDv9U0lnhpqVU7L6gzw1jlccOkSQxqIr6/QpmJ8q
	 rJKdVCP7mF+CkstezkR5C3JpI6j0+EE6M8JqkvvNTGurz+jIGrCXqxGjXLmrGm/4c7
	 53Mxh0Ae2H5cCxvBCYiEZT351VY33XPw3apvre+4eoSeWJsIMydr8g5pY050oVvN9N
	 1CexphtjFpED2wIILUzRHDPxpTfXn3HMUsxc9vugNcTMcF/BotYD6Ao4UHVePC4ODM
	 Q2XJzPW5MwKGilJtPZvBS5VLR8gTTj8/ZTMdXrQy68KVSvh921r/QgqxZuGDSz0Aed
	 Xh4TUz8N9gWJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Puranjay Mohan <puranjay@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 029/232] selftests/bpf: veristat: fix printing order in output_stats()
Date: Sat, 28 Feb 2026 13:08:02 -0500
Message-ID: <20260228181127.1592657-29-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index b0d83a28e3486..726a968ae8aa0 100644
--- a/tools/testing/selftests/bpf/veristat.c
+++ b/tools/testing/selftests/bpf/veristat.c
@@ -812,7 +812,7 @@ static void output_stats(const struct verif_stats *s, enum resfmt fmt, bool last
 	if (last && fmt == RESFMT_TABLE) {
 		output_header_underlines();
 		printf("Done. Processed %d files, %d programs. Skipped %d files, %d programs.\n",
-		       env.files_processed, env.files_skipped, env.progs_processed, env.progs_skipped);
+		       env.files_processed, env.progs_processed, env.files_skipped, env.progs_skipped);
 	}
 }
 
-- 
2.51.0

