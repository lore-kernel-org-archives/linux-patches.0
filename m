Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029016;
	b=W+fARyqnbwazxLbbi6aCx5slnHzntC9tseB1Zeg0hvNs422cdNV3ZLU1bFsWOf0FOiK5
	 yOXt7mKE1A5ldyFl/NTzW5nLRV4OniTqTKYjDtRVsj67xcrQ1IQaRg2efne5Y6jNLfqIG
	 2nuq7S0OXlsABkl/gVC5S/iRiR+yZlAUo3idX9Zhp0cKSQaC6Ct64qnWv5fA8WfZj+8Jd
	 BCdbBk6k1NYjBBwjvADy5S5bcK9vAGqN9VghC/oC+zcl7ksnf2TW3d10b9mFODd0R8qYG
	 Bb42xs0AIlKRVQ+CFZXnQpX2uamihbywW/2w7wWeoE1wWSInjJ/abe8DpQt6ZldZmeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029016;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jZcLsl62V5cVdhIPfveaNDqi0L9mJxtpqN54rLpYfkQ=;
	b=NyCdexU4ufD0MUXNpqt/LbhkCp5JxDBkL8/xhogJ4XIvxYpxne5gJNEiEKk8I6q/3dBk
	 u4XAXYgX8XOLlzMHi9pr2NfLv08Nhd47dgETSAj7So7RimlNqWKD+5vmpPDeyLMwxlGsn
	 BKghGbwpiTMIuAe7asgtiqzzjUuGlQxd8NxOzciFyNsa/ytdQucqwVdbXkau2vwld8Pw4
	 c0vQrDG108JYAzTtD12OXqWQv76gHnGFH2YElqAY0oNPwgyfpeGXiwVfRwNik5S9s5iML
	 cVTLSFhR/bf5UiHvgvVeR7Pp+HAImVnSAYR7Fslw2QYNan/huoRr2oVFcYRotXJ2+7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rsSwDdMj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A0F360A260C;
	Wed, 18 Nov 2026 19:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rsSwDdMj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2581F000C4;
	Wed, 18 Nov 2026 19:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029016;
	bh=jZcLsl62V5cVdhIPfveaNDqi0L9mJxtpqN54rLpYfkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rsSwDdMj67CDJIfA/Pp8J9aWAPJtZXSnJNGw8BIb1IKAwAobk6izDmutjLiriYKmf
	 XaJk2mKOnuL3f4dQOp+posxu341Dm5hmHzEg5jsl7acnIXz67YBZmFpYkKDwrc8kW3
	 1GhIVoA4TcuCrg+DaxdhC2DFwGD9QyUxIWVa6u2M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0163/1756] perf jitdump: Fix debug_data and unwinding_data leaks
Date: Wed, 18 Nov 2026 15:38:10 +0100
Message-ID: <20261118150014.697907226@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit 2bd967f3adcba1d3e54f10b0d8b25f950e4f03fd ]

jit_repipe_debug_info() overwrites jd->debug_data without freeing the
previous allocation.  If two consecutive JIT_CODE_DEBUG_INFO records
appear without an intervening LOAD record consuming the data, the first
allocation leaks.

The sibling jit_repipe_unwinding_info() already frees the old
jd->unwinding_data before reassignment — add the same pattern to
jit_repipe_debug_info() using zfree().

Also add cleanup of both buffers in jit_close() so they are freed when
the jitdump session ends, even if no LOAD record consumed them.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 0cb6705ab40d8..d6583cc32d635 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -116,6 +116,8 @@ jit_close(struct jit_buf_desc *jd)
 	funlockfile(jd->in);
 	fclose(jd->in);
 	jd->in = NULL;
+	zfree(&jd->debug_data);
+	zfree(&jd->unwinding_data);
 }
 
 static int
@@ -646,6 +648,7 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	memcpy(data, &jr->info.entries, sz);
 
+	zfree(&jd->debug_data);
 	jd->debug_data       = data;
 
 	/*
-- 
2.53.0



