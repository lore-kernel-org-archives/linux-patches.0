Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028939;
	b=vd+jnRRZavZtpXF8MBb0zdkotMfrr0hPyNRZi7NpV8XA7QKjqOrPOnjIt/qQ7FP3cEJa
	 lXrJG5d8xuXyZJH6VqQPh2mN6LfI7iIVzA/EH6tAYSXjQWw0phIicZzqiqvDv0Yv35jD0
	 4UdRHv5q32IDQXeqSPiBsuoJ7soNcPlMZlzkKdSEQtQToFryF2f6zkCtGK6RxJhEQCFyq
	 5whymnMyDysjNDsmPcQO4COndiVkV/2KndbgNz32TdM5mdZi7gGKoO5HLuO7/u0d+5LSE
	 /QSx7cdPbt4y50y7mjFAQ81AreibijccYCVdNuv/aYcMgpaZqN1C8m2L1i9fYkvUKDg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028939;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Nm8dC7qiDMuJbnVCkL712/u5oute4uSX18vdVw0GNsw=;
	b=Eu+K+qi4CbQF1y4t1EpSgXkg97MbuzDVA+eWHEmtGYwFiFJzUU8awZea9vuRf2cXcBll
	 648w/pty/LPo3VcMshctPS5DQDlHj0hKURZYEdcpSLdG04/4206iAkVeHW+nkbKvg2ylZ
	 aKqABuF3bTCbSJRBWvcBPuOvZ8i9FGrey1THTdcI52OXXFSfrtEW17Wx9U/rXn1BnJZjq
	 gobWvakMLhB0doWnnjvxZwd0ScEr3b2wHty8ZEKpcyNMEZGMb6zXqnSkWdoJzDpOEF5/F
	 VxSW0uhWw5W4x/9otJwqRsjLRoc/s5MUk5ijy3ER98SYnypCbxRL1OHzj8A6Bj4IqCA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQBxuYIv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C69D4606A31C;
	Wed, 18 Nov 2026 19:08:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BQBxuYIv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C54B1F000C4;
	Wed, 18 Nov 2026 19:08:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028939;
	bh=Nm8dC7qiDMuJbnVCkL712/u5oute4uSX18vdVw0GNsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BQBxuYIv66wUHfZSzJLpsuntQN6vS/zslLTcdUhJ9xOM0Ck8ZtgNBpIDAAFLimFvo
	 IYn+8q30rZQNO2kHG4QlXyJrYxX2z0kudMo62ch8be3OPwmzGvru+WKfsaohBepNJo
	 8h0TaVQGactV5w0dehO0G6CGoMWQcuurhdJYSnVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0174/1756] perf jitdump: Validate debug entries on native (non-swap) path
Date: Wed, 18 Nov 2026 15:38:21 +0100
Message-ID: <20261118150015.384308881@linuxfoundation.org>
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

[ Upstream commit 51e14e495f0cea061bbad33e7635f7fd857113ad ]

The bounds-checking and nr_entry clamping added for the byte-swap path
only runs when jd->needs_bswap is true.  On native-endian files, nr_entry
passes through unvalidated to jit_repipe_debug_info(), which stores it
as jd->nr_debug_entries.  Downstream, jit_process_debug_info() in
genelf_debug.c iterates nr_debug_entries times via debug_entry_next(),
which calls strlen() on each entry's name field — a crafted nr_entry
causes OOB reads and writes.

Add bounds-checked iteration in jit_repipe_debug_info() that validates
each debug_entry fits in the payload and its name is NUL-terminated
before calling debug_entry_next().  Clamp nr_debug_entries to the count
of valid entries.

Fixes: 598b7c6919c7bbcc ("perf jit: add source line info support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index d118a39fb2058..5c684db97fce2 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -678,8 +678,10 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 
 static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 {
-	void *data;
-	size_t sz;
+	struct debug_entry *ent;
+	void *data, *end;
+	size_t sz, valid;
+	uint64_t i;
 
 	if (!(jd && jr))
 		return -1;
@@ -699,10 +701,25 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
 	jd->debug_data       = data;
 
 	/*
-	 * we must use nr_entry instead of size here because
-	 * we cannot distinguish actual entry from padding otherwise
+	 * Clamp nr_debug_entries to entries that actually fit in the
+	 * payload.  The byte-swap path already does this for cross-endian
+	 * files; validate on the native path too, since downstream
+	 * jit_process_debug_info() iterates via debug_entry_next() which
+	 * calls strlen() on each entry's name field.
 	 */
-	jd->nr_debug_entries = jr->info.nr_entry;
+	end = data + sz;
+	ent = data;
+	valid = 0;
+	for (i = 0; i < jr->info.nr_entry; i++) {
+		if ((void *)ent + sizeof(*ent) > end)
+			break;
+		/* name must be NUL-terminated within the payload */
+		if (!memchr(ent->name, '\0', (char *)end - ent->name))
+			break;
+		ent = debug_entry_next(ent);
+		valid++;
+	}
+	jd->nr_debug_entries = valid;
 
 	return 0;
 }
-- 
2.53.0



