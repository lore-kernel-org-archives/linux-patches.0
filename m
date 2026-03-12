Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 048173F1655;
	Thu, 12 Mar 2026 20:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773346437; cv=none; b=svc+RH1D3k/3Ho86IKcHB3XteFV7Gat3g2TjpAI9/CIGZvgasyCH/xLnf0BqGcYAEP9wgoZDpzEDkpcKYx6dr5ufzt9erX1+0fU+wrHrdeZa+keqff7JvFSkcvu0T8uNhpOzAXCZMs8E0h1MbmU7EVAFtgj0sreyyasptrHp1XI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773346437; c=relaxed/simple;
	bh=dg5Qoi3vprZdV+4fJ9o+QX7OlEWXU9g1qW7014JlWmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KzoGTnn5G20RKW2Oeho4aLEoCuQ/iLkNwHjS+0wgBkrttQaoF7G5GsQow5Le6h6mgs/eIsYgg676I6OGRiNpQI6iPLiXSQzV+hAt3Ueq0Q99uIchP5qCXzfw8djZOr/MMWHbS/1JR9bWqRUS02PeDRQEHdXnx5nh6Z/iE5eJSYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O6LE3Ytn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O6LE3Ytn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39EE1C4CEF7;
	Thu, 12 Mar 2026 20:13:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773346436;
	bh=dg5Qoi3vprZdV+4fJ9o+QX7OlEWXU9g1qW7014JlWmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O6LE3Ytnoe3I64FJHaFS5JWyBupVFOLVNpxUX6NO1ThSjaASfO36z7I4itFhs6V6I
	 tuiXMGGEOgxdl2VueGpUuf5BfEr3JIx/ECB/is04OUi1ZMBdKPUvKVJ4dDfwqZfMUm
	 LCsnblhAHz8a3wgUs1VXiFQpSC1ph6WfhGXp0ATI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 015/265] rseq: Clarify rseq registration rseq_size bound check comment
Date: Thu, 12 Mar 2026 21:06:42 +0100
Message-ID: <20260312201018.724862116@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 810005f927d7c..e6ee81dd1e457 100644
--- a/kernel/rseq.c
+++ b/kernel/rseq.c
@@ -432,8 +432,9 @@ SYSCALL_DEFINE4(rseq, struct rseq __user *, rseq, u32, rseq_len,
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



