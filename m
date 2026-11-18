Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029057;
	b=iRbhxZLgH1c3732sTN6dL5R3hgC9JtSgPG+SeI+AQQYU49eJk7VuZ23AQfCurzz1CqTn
	 ECzx5ogUWuJz+LRPC62Vme+LTr8tSfAhGfpPNoIwUgymICV1zWgDoGfVHxs+sgez2Ff6U
	 RczwqolUvBDUr2E0YQAV6+/6zqHT8eYbLvfsIdCHv1AUwKtZnOV0+JfmjQPwrOzYy01qW
	 ASaWK7/u48C0p+QsZW9LpVCUUb4nA5xj2pISnE+bxcLxXLIEOujMdJnQAaNmRJzupWLn7
	 WSgcFYT+SazDIEaZCEhrGVgpJM/83rbr2IU5o9TsdwRK5BwFtQHg6inA8OvrHFSJY5A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029057;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iKH4YgAQfgX6E8K2yU+8O+S9EjpeHPYYqjYe2lHVZLU=;
	b=SGO39+ML7qZRwUX5iw8HrN949y95Zv4gduDqmq0cJON3dMNBk1CUUcHGZcUXwwZOv/IV
	 cdhf35q+kGxorr9GbY3e7oxfYgWDBwl5X/n8NthK+o7ws0M/9R3FLC7bVZoAtveE8eSiP
	 sy7u22Q8MyVdxms+Cbk3QK7zW5unXBCbtN7KurbBFxsrCO6Mf1/zPEHgu1nUREJeJ01x/
	 ealXiBt8HrDtPuKwJCTK1xjSHRqp5AkOAtUa8UQx3kZWs9NcXYjTPAsWiAzmolA+oM1Up
	 pJn4gOylVb403A5QheqD/0Ux//P3OAXBy25/XTUIwFagxkYgM3UjVfP8x7Q/iQSJIXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WIN1fHcb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2230606A325;
	Wed, 18 Nov 2026 19:10:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WIN1fHcb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BD2D1F000C4;
	Wed, 18 Nov 2026 19:10:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029057;
	bh=iKH4YgAQfgX6E8K2yU+8O+S9EjpeHPYYqjYe2lHVZLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WIN1fHcb2f8fwWm4ACY5zTb2PfVFyCh57gpeqQV4AoeXUdEirjiezjeaFDMyIhZnl
	 4IFeKFoYWDycnComUWKTvwrguJXRUPV00bOd+ffIDDfA/Q6N1l3ya/USe5xYD15iTg
	 MjnMzEbolaylIQZIVjU8j1ikYrnkGjZePgPW8fRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Stefano Sanfilippo <ssanfilippo@chromium.org>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0165/1756] perf jitdump: Prevent integer underflow in debug info size calculation
Date: Wed, 18 Nov 2026 15:38:12 +0100
Message-ID: <20261118150014.834678498@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit dfe8fe96efca3c32979dc0859f88e15b677d25f1 ]

jit_repipe_debug_info() and jit_repipe_unwinding_info() compute payload
sizes by subtracting the fixed header size from total_size:

  sz = jr->prefix.total_size - sizeof(jr->info);

When total_size is smaller than the header struct (from a truncated or
corrupted jitdump record), the subtraction underflows to a massive
value, causing an oversized allocation followed by an OOB memcpy.

Validate that total_size covers at least the fixed header before the
subtraction in both functions.

Fixes: 598b7c6919c7 ("perf jit: add source line info support")
Fixes: 0284fecd13b6 ("perf jit: Add unwinding support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Stefano Sanfilippo <ssanfilippo@chromium.org>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index de7dd4db33db8..96e728b49af5a 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -652,6 +652,10 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->info))
+		return -1;
+
 	sz  = jr->prefix.total_size - sizeof(jr->info);
 	data = malloc(sz);
 	if (!data)
@@ -680,6 +684,10 @@ jit_repipe_unwinding_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	if (!(jd && jr))
 		return -1;
 
+	/* total_size must cover at least the fixed header */
+	if (jr->prefix.total_size < sizeof(jr->unwinding))
+		return -1;
+
 	unwinding_data_size  = jr->prefix.total_size - sizeof(jr->unwinding);
 	unwinding_data = malloc(unwinding_data_size);
 	if (!unwinding_data)
-- 
2.53.0



