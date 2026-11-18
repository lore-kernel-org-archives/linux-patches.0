Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022879;
	b=kZ9BlhQhGXVP89fEIODxOBkGEMoA4Ei2tgcIeBswdwlHB4Z/VtjOwewJODKstf8SG2p+
	 cMXHG0oXQVy4UuXTMrkRY0WBhB2yKpyMmWSf9/ZPR0ecuN6kMw0bx/HATG7tHmKNCD9Df
	 3sKJguk39EuUAVXkDcRa/tlimk4N0kEWL8KxBBsPW/RXeeXq/jBNnfunxR8Z8QB/tQ5Qv
	 HtZ8yXZExn4yitPPaUnKL2+RW47FlJ9oUAQ3RwBAUval6j438DEL1uNC0bMBlkZKnz+Om
	 QlJGSfNXEC97Qx/mw3leM5LbzQLsEupQDnKt72BZWE+rO4KROYKf3rlyEXgt+CuN+zA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022879;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=qEzam23izLWHX6S8Ij0lMMigRE+FIcn2wleveJ8Rc74=;
	b=0O0tTZtBgv+8yX0y8mUFFsDk4M0jw239k6oT5xO9ekgbF713FVg9PUX/CyvOVfkRVzqD
	 /vZQsWdE0GX8axHabT4qWvYKWkJnemKeTiCFAdf7h6XGXlJof4UfUSNLANTeCDL0jU6nF
	 bLw7ooYjaw3RmAJ1AgPZBz0ioRJkiSAsYBt2B5MRSCKYxdZg9bHm3BEYYTPHNpIH/ufWD
	 55o/vsSxdc658XTkUy8blcc72fihGyYlUVVZon6mCWasvAGM4AL8Dve9GEqVWOguI8OqQ
	 jke6ueNjB475YVJdwYfiGLRzmAUDpmrlX//R6DAxtSC92KwFnFHNFqrXPTUacXajuWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9uAG93v;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00504606CA5C;
	Wed, 18 Nov 2026 17:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z9uAG93v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5266B1F000C6;
	Wed, 18 Nov 2026 17:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022878;
	bh=qEzam23izLWHX6S8Ij0lMMigRE+FIcn2wleveJ8Rc74=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z9uAG93vdgoDKIgJQb1l/HsBL2cCjKcDvLux6K1PQmhRRQAiibtrsuWtjcyHVhleG
	 YeJeWGcj+QsRiI6YjlcINxXW7V1Edv6VfIWkYLQNgmYsP1R7EPo9Wv+0+NLP/aYY4f
	 SUkBfusUVtsyWVg1w2OoaK6H2NeXBDu9FtsCdPTM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0169/2151] perf jitdump: Validate debug entries on native (non-swap) path
Date: Wed, 18 Nov 2026 15:31:44 +0100
Message-ID: <20261118150127.897934846@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b82a2875a7748..517deb8466493 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -692,8 +692,10 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 
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
@@ -713,10 +715,25 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



