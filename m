Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06632384245;
	Tue, 10 Mar 2026 11:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773140794; cv=none; b=qeVni+HL0K2sKphQy5ETP2kRDcoN1gTm6GDKAuSutHBb4KiDtTdQ2LY4G7Dd7ksc4Q+rv7/deLAdKWBy6THzIPEGhz0Up9GAq2qXv/zNzcUs4ErA312YUz3azvnaRW3fpOBZeBm66Qrs6YRcZe50EETzC06MNZe4ve+w82DGCQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773140794; c=relaxed/simple;
	bh=7xl/NL26zB65QZOtw+G+IXmvi7TT4IynItrWuxyPUnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WirIfdMuprWtmmYsD98Jxg94Wk5xkEYHAk3arISZp/vca8lb+HNj4UbUeRrWNsOo0oIBRKfPYvJpQLKJVPyCcwkg1W9llyI8OII6etbA17zL5X4mVhoMEA9MeDu5gbteom2cgUU4MaC7P29fZkfZiD73FVOg6D0ksdV/uYRPtf8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LvhVzL/e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LvhVzL/e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55960C19423;
	Tue, 10 Mar 2026 11:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773140793;
	bh=7xl/NL26zB65QZOtw+G+IXmvi7TT4IynItrWuxyPUnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LvhVzL/eyMDPdf3rjymkr9b+BPy3pViWHwhlCbZLvBBU0Ix3X8HyKpiKW7OWqTi6c
	 VSiTgzmoK173IFP7VLZTWXldSxzZNfB4DkYhRnK1bwwxH6qwCm5mMbQSwwIXD/QWwL
	 Fe91Q1hWDTnQRi02wqaVKUL+cwGkKy4RIIimF8+5rtrqxMRK8WMMjIVPsJeb8zSQ3f
	 xjj4bc9wemz3gBaiRJAPTthunE2VyNd+tdB50/bjWAOTfQQa3P2inCnH1DfFjJPCNK
	 2ZF+EFkFXb/RfWEd6ojuYTdk2L8njSkm1xwue2O0oNOk9jOEkQgzZ459V4FjXJdKNW
	 sdQprZMf1hkqA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 030/311] rseq: Clarify rseq registration rseq_size bound check comment
Date: Tue, 10 Mar 2026 07:01:17 -0400
Message-ID: <868b22c2a4f89cc7f4081c2dadfe22e37e464a88.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>

[ Upstream commit 26d43a90be81fc90e26688a51d3ec83188602731 ]

The rseq registration validates that the rseq_size argument is greater
or equal to 32 (the original rseq size), but the comment associated with
this check does not clearly state this.

Clarify the comment to that effect.

Fixes: ee3e3ac05c26 ("rseq: Introduce extensible rseq ABI")
Signed-off-by: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260220200642.1317826-2-mathieu.desnoyers@efficios.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/rseq.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/rseq.c b/kernel/rseq.c
index 395d8b002350a..6cb5b7e51555d 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -428,8 +428,9 @@ SYSCALL_DEFINE4(rseq, struct rseq __user *, rseq, u32, rseq_len, int, flags, u32
 	 * auxiliary vector AT_RSEQ_ALIGN. If rseq_len is the original rseq
 	 * size, the required alignment is the original struct rseq alignment.
 	 *
-	 * In order to be valid, rseq_len is either the original rseq size, or
-	 * large enough to contain all supported fields, as communicated to
+	 * The rseq_len is required to be greater or equal to the original rseq
+	 * size. In order to be valid, rseq_len is either the original rseq size,
+	 * or large enough to contain all supported fields, as communicated to
 	 * user-space through the ELF auxiliary vector AT_RSEQ_FEATURE_SIZE.
 	 */
 	if (rseq_len < ORIG_RSEQ_SIZE ||
-- 
2.51.0

