Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047766;
	b=BzeoMfaa+IA59ndQWUettjY5cq+TkvPiQGn1zVF4rsQFg/7HkTpOasQyAmAxaWtyXDKl
	 DT9oHvHEPaFhutXWE/lz708iJqbF3rjWi6K/XIKvfZXuXgfT34Uz5asbRlJCAlb9rP6Gq
	 sxdh+7tDfzfV9Q28CcQG4ziGeXHg8nNDPNnuGGdNmA9ImsiFyoKYjyvmzYmy7wr5OE+Ho
	 SCsH4Gp8tvWbMmT0Oh8XvejO9ndstWkzn2bn/VUKPMAwJEw2FopToApAcpoKOIHH1v23l
	 ixUJYvD79m54XF379K7TIF08lKctI2ZhfZjOqgLzv7DUEAvTjkkv0kIu2ZAVoyWfrlw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047766;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=PFrZAcEZb7MhqJaAgxezfMXVm3sky6Y0ol6+Uu5qoEU=;
	b=ung1Uk1kspUaECin1eJRi+pFAcwcdUhTxjaalh1qhI8h5MyPu50pyAnscXJ7FA3knBNp
	 hcwyNJZNQKkASXamqu+kqTitpGgtVZ5uo9UO78sOUXx2M3UinAEFLvVx3MyVqezW8jCQr
	 uRNzOXHOHF80lgEwmA3V0DGH86Vq1+97Lmq0n1jdVw6bli8JNf8ZXTtgdYd2ImOD3AwTI
	 VSoupUwfYmyjszB3JFmfsZ6zuAkeRAFoCgnF9op8rLLfJro7WGFIVrDnzWaU8B0NmJVsE
	 l1/CPgq7QFaRXhqUO+8sc7BCAIrEVwhN2wxShXGgOlJ2dPCevd7vQsD7CMEDbBYXXvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ffHPRB8U;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F31606A320;
	Thu, 19 Nov 2026 00:22:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ffHPRB8U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D2F31F000C4;
	Thu, 19 Nov 2026 00:22:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047765;
	bh=PFrZAcEZb7MhqJaAgxezfMXVm3sky6Y0ol6+Uu5qoEU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ffHPRB8UZAoUWL5vlxhyaZkD3zaH1t6hPH8YygtzHlOSAhaKD10YRHn+CozVlSJfy
	 /7Y91KITBzW3WUXkzpKAsAC9dIllmohUnJ5pEwxcBEVzMQr37rsZ0VOdXCxjZhqiLs
	 yptDbf2f5rwtq2IhBWZnfmfj6/d9XDU9FK8beNDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1755/2857] perf jitdump: Validate debug entries on native (non-swap) path
Date: Wed, 18 Nov 2026 15:46:29 +0100
Message-ID: <20261118150304.485790161@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e6d8b1aedcb0c..584932d1065e8 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -676,8 +676,10 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 
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
@@ -697,10 +699,25 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



