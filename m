Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE0FEEBA;
	Wed,  4 Jun 2025 00:54:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748998484; cv=none; b=P1PQy4irvTMLLWV3DTLJnF0oKJVFycVZWEGTGxa3tCS75BMeCgmXJ5mV66Tw9PeTPbdJWT0OchvKsj6T9Xxfp16P128YZP8/lQ9YNpNi+VoM5hedk5te1eqPIsgmAvYfq+p4X0QyGB3J1VD9TboF7fXYd+pkGQpuuLp77NLmavc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748998484; c=relaxed/simple;
	bh=SvYVwPRYLhVUtDmbQB1UXDMbcK9P1npWvQpDaAZIh20=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JkxS/dut1OAZizxiIIziEgApjzW84mxTXEV70jvNDMm5m8d1t90qR3h8vQjI9y9Bj5AqLNrvq6PgX5ceqRz9phXeZTiZPeuiYSNoJVOzJH7yDDiE6d9h5R1CSlAkGe74Gx5vFLcVsl/NZBJq+q1bmcFsfM2v7lnS/Dq3QJgRdLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YzqVcs7q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YzqVcs7q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44353C4CEED;
	Wed,  4 Jun 2025 00:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748998483;
	bh=SvYVwPRYLhVUtDmbQB1UXDMbcK9P1npWvQpDaAZIh20=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YzqVcs7qYxBwd5Bu+lN+AC6pR7pNFRzG4zWCfe30J8XiFytSU4ZphUSZv76zXXHFW
	 QP8F9SyLXPpQlNk/XUf7YpcflQRSacfTx5JfdixAuwA+y6enbKEAoaPhLOPaYzToaL
	 UBqszdfCcyFRZhtcNDXwGe0Bnkdh2hj0C0mlH5hSGVrN41cymQARauW7zq0knXo6Og
	 TYVv5O8vTtY5DYrw8XNdUIFYb3Ofl5FUihyZr0CDMTi3y6Y4fYp/SnHZMsMQqVDucj
	 +IQve6X8qq8mUypysyiQ7vRDuJ47vpXeVKAeSwdnoVgzvxcq2CBCEr57udh/cYiJ52
	 HOEHZyQIaDyIA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zijun Hu <quic_zijuhu@quicinc.com>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	edumazet@google.com,
	pabeni@redhat.com,
	willemb@google.com
Subject: [PATCH AUTOSEL 6.15 100/118] sock: Correct error checking condition for (assign|release)_proto_idx()
Date: Tue,  3 Jun 2025 20:50:31 -0400
Message-Id: <20250604005049.4147522-100-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250604005049.4147522-1-sashal@kernel.org>
References: <20250604005049.4147522-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Zijun Hu <quic_zijuhu@quicinc.com>

[ Upstream commit faeefc173be40512341b102cf1568aa0b6571acd ]

(assign|release)_proto_idx() wrongly check find_first_zero_bit() failure
by condition '(prot->inuse_idx == PROTO_INUSE_NR - 1)' obviously.

Fix by correcting the condition to '(prot->inuse_idx == PROTO_INUSE_NR)'

Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20250410-fix_net-v2-1-d69e7c5739a4@quicinc.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

Based on my analysis of the Linux kernel source code in the environment,
let me now provide a thorough evaluation: **YES** This commit should be
backported to stable kernel trees. Here's my detailed analysis: ##
Analysis of the Bug Fix ### The Core Issue The commit fixes a critical
off-by-one error in the error checking conditions within
`assign_proto_idx()` and `release_proto_idx()` functions in
`net/core/sock.c`. ### Current vs. Fixed Code Comparison **Before the
fix (incorrect):** ```c // In assign_proto_idx() if
(unlikely(prot->inuse_idx == PROTO_INUSE_NR - 1)) { // Wrong: checks for
63 pr_err("PROTO_INUSE_NR exhausted\n"); return -ENOSPC; } // In
release_proto_idx() if (prot->inuse_idx != PROTO_INUSE_NR - 1) // Wrong:
checks for 63 clear_bit(prot->inuse_idx, proto_inuse_idx); ``` **After
the fix (correct):** ```c // In assign_proto_idx() if
(unlikely(prot->inuse_idx == PROTO_INUSE_NR)) { // Correct: checks for
64 pr_err("PROTO_INUSE_NR exhausted\n"); return -ENOSPC; } // In
release_proto_idx() if (prot->inuse_idx != PROTO_INUSE_NR) // Correct:
checks for 64 clear_bit(prot->inuse_idx, proto_inuse_idx); ``` ###
Technical Analysis 1. **Understanding the Bug:** - `PROTO_INUSE_NR` is
defined as 64, creating a bitmap with valid indices 0-63 -
`find_first_zero_bit()` returns `PROTO_INUSE_NR` (64) when no free bits
are found - The original code incorrectly checked for `PROTO_INUSE_NR -
1` (63), which is actually a valid index - This meant the error
condition would never trigger, and the code would attempt to set bit 64,
causing undefined behavior 2. **Impact of the Bug:** - **Memory
corruption risk:** Setting bit 64 in a 64-bit bitmap accesses memory
beyond the allocated bitmap - **Resource exhaustion not detected:** The
system would not properly detect when all protocol slots are exhausted -
**Potential crashes:** Accessing invalid memory locations could cause
kernel panics 3. **Why This is Backport-Worthy:** - **Fixes a clear
bug:** The logic error is objectively wrong and could cause system
instability - **Minimal risk change:** The fix only changes two
comparison operators, with no architectural impact - **Important
subsystem:** Network protocol registration is core kernel functionality
- **Well-contained fix:** The change is localized to error checking
conditions without affecting normal operation paths ### Comparison with
Similar Commits Looking at the historical examples: - **Similar Commit
#2 (YES):** Fixed error checking in packet handling - similar pattern of
correcting error conditions - **Similar Commit #1 (NO):** More complex
memory leak fix with broader changes - **Similar Commit #3 (NO):**
Architectural change from BUG() to error returns - **Similar Commit #4
(NO):** API cleanup removing function pointers - **Similar Commit #5
(NO):** Validation fix in newer subsystem This commit most closely
resembles Similar Commit #2, which was marked for backporting due to its
focused bug fix nature. ### Stable Tree Criteria Met: - ✅ **Fixes
important bug:** Prevents potential memory corruption - ✅ **Small and
contained:** Only two line changes - ✅ **Low regression risk:** Pure bug
fix with no behavioral changes for normal cases - ✅ **Clear side
effects:** None beyond fixing the bug - ✅ **No architectural changes:**
Maintains existing API and behavior This is exactly the type of focused,
low-risk bug fix that stable trees are designed to include.

 net/core/sock.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock.c b/net/core/sock.c
index e54449c9ab0ba..121f640112889 100644
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -4004,7 +4004,7 @@ static int assign_proto_idx(struct proto *prot)
 {
 	prot->inuse_idx = find_first_zero_bit(proto_inuse_idx, PROTO_INUSE_NR);
 
-	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR - 1)) {
+	if (unlikely(prot->inuse_idx == PROTO_INUSE_NR)) {
 		pr_err("PROTO_INUSE_NR exhausted\n");
 		return -ENOSPC;
 	}
@@ -4015,7 +4015,7 @@ static int assign_proto_idx(struct proto *prot)
 
 static void release_proto_idx(struct proto *prot)
 {
-	if (prot->inuse_idx != PROTO_INUSE_NR - 1)
+	if (prot->inuse_idx != PROTO_INUSE_NR)
 		clear_bit(prot->inuse_idx, proto_inuse_idx);
 }
 #else
-- 
2.39.5

