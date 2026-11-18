Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015254;
	b=rzPvLs8F+TtrGzSV9qd1kQ0rHhTMSEMOVego2mj8LadH66ejGHRRRAz/C1FzfeMaFfu/
	 mlk+ie1Ttkqwg8J5vFbaWXIbk4zd9FZcS9SpQ6aH9pjz/RxtInSBlEuY3ydus7S+3v2Mc
	 wgn/OkKmpki5rPZkHzMINNjNz5JFrH47SE8bmfuf2q3mtM9/JvzT6GbzP4rc+GihqbWi9
	 66/1MqWg1QzYlCNlDmKvbeV81QziwuHEbaT4Bmj/h1OhQVYUToiMnWBdf1P2xOHn7pIdL
	 Mntq1+UbqncHxcrC7Wrqw+vQMV7b0Rh7wR+Uq91I7QhykBGVoUtWCDZxDBxdw/eb+iA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015254;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=9h6ZNAjO43IdTT34Mz0pDZGbJKZf3Q9WaJ0ebeKP38s=;
	b=fNDjgEzjTbfXiP20lm9R8UijqUPEkwYhX1nGx7D7cY7Ep6HtkVl585e1jHcRb1ToR9zG
	 4J7tIrdXU6+A7XtZhRxcz+gVimuGX19T+uoxk/9t9eJOFs5Odyuz/huA1kJXmQ3vcbrXZ
	 59tyY4i6erIAc2p12GwwrpzP/MQys8IZaeZb4BSvTymVAqu8C3bLOlojG2TeR0+bqpt6U
	 X1Q1E4I8swNeovwZvvtE41cHmR4jRz/+pZfwhm3NKR7SDFBArAoin4VQl64igTY3yfY7D
	 so0dKJ216443cPPDaA8czXke/b+7et1oJu5dL3pgj6oLy4C6pRKhtL0btjtsdqPCPZw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="QMjXS/LE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B1C606A31C;
	Wed, 18 Nov 2026 15:20:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QMjXS/LE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0D341F000C4;
	Wed, 18 Nov 2026 15:20:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015254;
	bh=9h6ZNAjO43IdTT34Mz0pDZGbJKZf3Q9WaJ0ebeKP38s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QMjXS/LENCZa98QJYZ7XTknX+GkmaxcZVQHeRlhalFrLsE6+37te2MEBfjvZE5AZP
	 wU885yQXhZBPAQjauLP6New8Co/TrZSSxR5w32PUlKCM8Q8RRIF4KIaoWKgMv5VSlV
	 cBXf4Da3yrCwpyATcVvFYJhx1JjSxi/CUe2Yc7js=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0107/2651] perf jitdump: Fix debug_data and unwinding_data leaks
Date: Wed, 18 Nov 2026 15:22:27 +0100
Message-ID: <20261118150251.735143708@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 4b7c7ba7cd95d..dcb26d9c6c8fc 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -117,6 +117,8 @@ jit_close(struct jit_buf_desc *jd)
 	funlockfile(jd->in);
 	fclose(jd->in);
 	jd->in = NULL;
+	zfree(&jd->debug_data);
+	zfree(&jd->unwinding_data);
 }
 
 static int
@@ -665,6 +667,7 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 
 	memcpy(data, &jr->info.entries, sz);
 
+	zfree(&jd->debug_data);
 	jd->debug_data       = data;
 
 	/*
-- 
2.53.0



