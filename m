Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021693;
	b=t+r3fHGspqdrmvqJWPq49gExu/5Vm62v9Vp6t5KeCmgjQoHWq7a8zxwcyHWckS+/4Qni
	 XCVos+alyxwAfsmzt4DJIb2OX0MwCPskr/lLCagQ0qwzKgWPbswqKJY+z4EAO+rcI997p
	 57S2AXj4CTJYkLE1jhrtALtOYyngm1ZUdWRBFIjBW9ZsECcfY/pSuNjIzY6BXWMWByP/N
	 R9n9KhT7faF7SNirbnc7DJHGdX1CIfYkK6yCxQjIpax7AgZIcpxWKT7gIMj3agGSNN6KZ
	 f3Ifmo8bl4EcCwcZvnLd9HSRoY6bJWuYSMeI7L32gBl4PkJ6p2gdncVofWejnfK5iUg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021693;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=19f0qG+Ttgwlz3Ebp8i/BAQKpWUQkMGCKGaMUc8Jto8=;
	b=iYI39jQbTxvBDid/BTClplt1WyOByeq/bxXwAN8cXWosLtBbWRbw9CRkG0I3XuUbwZnd
	 93F5dlaH4bniqYY/zvAC6bwgQqYOGb7HFH26oXxilQhMPddsOMYnAGnTfn5w9TZsGZmVK
	 xKE8+4v6GODJNfbMofLzYL/oIN0GZiZy00Xy3slkV3/feZavwu1YbvZMLUDBCjMc5XHFK
	 INKR5OztIyYGuslJePI3dj+BqS/BcAZNmpVQbeTtwpOW6k/ZJlrnX6AYkB+PIEEZiRTYX
	 jfSQoevYA4QXwvHaFA9vNCMEYzS+CdgtnvtLo90oEdjhgMxEo4Wt4nPh6ckXrbBUi5w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0JB48gx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E91606A33D;
	Wed, 18 Nov 2026 17:08:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F0JB48gx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A601F000C4;
	Wed, 18 Nov 2026 17:08:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021693;
	bh=19f0qG+Ttgwlz3Ebp8i/BAQKpWUQkMGCKGaMUc8Jto8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F0JB48gxSsJ5aKcqBzBjP9OTvZ3Hzg6zqxcR/4YKaQu7pp+LbATIQkZjf1WDIbzJl
	 42kodqnPfNSRZrgnzUfqxAvqy7x3bo21C/iUOniIQqrqSnjpWNWiXWDcu68+3Jn0Kq
	 /OozpA2l5Yd6/DM++KgjPWViHUUI9kQ7FxxtdvX8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ting-Han Hou <ue081723@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@siemens.com>,
	Kieran Bingham <kbingham@kernel.org>,
	Kuan-Ying Lee <kuan-ying.lee@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2397/2651] scripts/gdb: fix stack depot out-of-bounds diagnostic
Date: Wed, 18 Nov 2026 16:00:37 +0100
Message-ID: <20261118150411.663084283@linuxfoundation.org>
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

From: Ting-Han Hou <ue081723@gmail.com>

[ Upstream commit b6232ca8d194c60ee603586e42b5ea584d4b7be9 ]

The pool_index field was renamed to pool_index_plus_1, but the
out-of-bounds diagnostic in stack_depot_fetch() still accesses the old
field.  Looking up a handle whose pool index is outside stack_pools
therefore raises "There is no member named pool_index" instead of printing
the diagnostic and returning an empty result.

Use the already decoded pool_index variable in the diagnostic.

Link: https://lore.kernel.org/20261011023044.1722-3-ue081723@gmail.com
Fixes: 9d938f40b228 ("scripts/gdb: rename pool_index to pool_index_plus_1")
Signed-off-by: Ting-Han Hou <ue081723@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Assisted-by: LLM
Cc: Jan Kiszka <jan.kiszka@siemens.com>
Cc: Kieran Bingham <kbingham@kernel.org>
Cc: Kuan-Ying Lee <kuan-ying.lee@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/gdb/linux/stackdepot.py | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/scripts/gdb/linux/stackdepot.py b/scripts/gdb/linux/stackdepot.py
index 37313a5a51a0d..aaa18af25cd12 100644
--- a/scripts/gdb/linux/stackdepot.py
+++ b/scripts/gdb/linux/stackdepot.py
@@ -39,7 +39,7 @@ def stack_depot_fetch(handle):
 
     pool_index = parts['pool_index_plus_1'] - 1
     if pool_index >= pools_num:
-        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (parts['pool_index'], pools_num, handle))
+        gdb.write("pool index %d out of bounds (%d) for stack id 0x%08x\n" % (pool_index, pools_num, handle))
         return gdb.Value(0), 0
 
     stack_pools = gdb.parse_and_eval('stack_pools')
-- 
2.53.0



