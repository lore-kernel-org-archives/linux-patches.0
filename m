Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039194;
	b=U1xo7zKbp85Oo5eLxOYQpxTpXqSISd5JHGbYL19+oVLuNfP680rxf7XCi369Vi5l1aI+
	 6PJ4yDcMIy4bwsDwu7SWOYB/B63Tz3bwvUNRUbgRzOT38RCMYrsvilvSbVwNWeGz17EXS
	 BvfRI4+cxhnJ4eMI1rQK2mJUka+ROyXwQLGQF8+tnv0g3nkDDpCEVV1ipmywZOJ2h8gSL
	 /u/DQ0hobudcilEEFk8WfvB3IR+MziFF4RPSSp7djwodQFRP+Yqd+AQ/J0htxURo2+1dS
	 vuKZVI3PS3AGbSxudtZokSyJXXdrD7XcDKT10cq+kY9LAtdsRfXfASFrbQ/BQ4wQUxg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039194;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=3xmaYNDCM6Df4YODjx1MSBis3q+a9SA0zmk7gTPW9W0=;
	b=cfeiwoX7xIu1Tgs03JCZCw+pERNYby4P869rdL0GTz2ruShwFU2fcw6FjHoUqTCsnhld
	 T1CmUAOFr2tFgcrKq6YJ32/U6d1h9wk3DRpsYfwv5BJj2R6fiaf+7Z7PMLXIjGSo0k2TM
	 5DtS7H8WzOx3UvMY0AgsO3tsvmbY9vqCPF7FEeUDW8NTOIU4XpIPj3P5hLhbmn4KcWg0Q
	 8kGy84nHGWVD8b2Ov9iDBigfng8DDhYbCexV4e54Z+ipKqLUqEWN6v1Ujr1Idj+ihpLn2
	 qa+gsHG+wT6Zz97ZLE+RXnmxB5x+1hJ6Sg4MX57+V4nYUyIdBrC+7gL1g3ArK1gmZGQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="j5lZp/sX";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A87FF606A330;
	Wed, 18 Nov 2026 21:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=j5lZp/sX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D0A41F000C4;
	Wed, 18 Nov 2026 21:59:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039194;
	bh=3xmaYNDCM6Df4YODjx1MSBis3q+a9SA0zmk7gTPW9W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j5lZp/sXbuv5NAFm4s6SpyuN2SCgRm/k6ADuIBwC03tqi1p2KiJ7C8APiwC4vFk8w
	 OHchPlio1P5Uf/mHRlIDc4qJbUUjSIhqr9YaaMb/mp1A4fpOT/dpD/AVNq7pOZtly1
	 IVUEUxcchjsVfT43ZCp4rPros9B7s6DsQKdAairo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2006/3318] perf jitdump: Bounds-check debug entry byte-swap loop
Date: Wed, 18 Nov 2026 15:43:48 +0100
Message-ID: <20261118150422.231712809@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit ede3cd8151675c2983cd49104b1e9b25a3712ed8 ]

The byte-swap loop for JIT_CODE_DEBUG_INFO uses array indexing
(jr->info.entries[n]) to iterate debug entries.  struct debug_entry has
a flexible array member name[], so each entry has a different size.
Array indexing computes offsets assuming fixed-size elements, landing
inside variable-length name strings after the first entry and
byte-swapping garbage.

Additionally, nr_entry is read from untrusted jitdump input without
validation against total_size, so a crafted value causes OOB reads.

Replace the array indexing with debug_entry_next() pointer arithmetic
(which correctly accounts for the variable-length name) and
bounds-check each entry against the record's total_size before
byte-swapping.

Fixes: 9b07e27f88b9 ("perf inject: Add jitdump mmap injection support")
Reported-by: sashiko-bot <sashiko-bot@kernel.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Cc: Stephane Eranian <eranian@google.com>
Assisted-by: LLM
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/jitdump.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/jitdump.c b/tools/perf/util/jitdump.c
index 3fe38e754d3a2..8264d03260706 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -318,14 +318,32 @@ jit_get_next_entry(struct jit_buf_desc *jd)
 	switch(id) {
 	case JIT_CODE_DEBUG_INFO:
 		if (jd->needs_bswap) {
+			void *end = (void *)jr + jr->prefix.total_size;
+			struct debug_entry *ent;
 			uint64_t n;
+
 			jr->info.code_addr = bswap_64(jr->info.code_addr);
 			jr->info.nr_entry  = bswap_64(jr->info.nr_entry);
-			for (n = 0 ; n < jr->info.nr_entry; n++) {
-				jr->info.entries[n].addr    = bswap_64(jr->info.entries[n].addr);
-				jr->info.entries[n].lineno  = bswap_32(jr->info.entries[n].lineno);
-				jr->info.entries[n].discrim = bswap_32(jr->info.entries[n].discrim);
+
+			/*
+			 * debug_entry has a variable-length name[], so array
+			 * indexing would compute wrong offsets — use
+			 * debug_entry_next() and bounds-check each entry.
+			 */
+			ent = &jr->info.entries[0];
+			for (n = 0; n < jr->info.nr_entry; n++) {
+				if ((void *)ent + sizeof(*ent) > end)
+					break;
+				/* name must be NUL-terminated within the record */
+				if (!memchr(ent->name, '\0', (char *)end - ent->name))
+					break;
+				ent->addr    = bswap_64(ent->addr);
+				ent->lineno  = bswap_32(ent->lineno);
+				ent->discrim = bswap_32(ent->discrim);
+				ent = debug_entry_next(ent);
 			}
+			/* clamp so downstream consumers don't overrun */
+			jr->info.nr_entry = n;
 		}
 		break;
 	case JIT_CODE_UNWINDING_INFO:
-- 
2.53.0



