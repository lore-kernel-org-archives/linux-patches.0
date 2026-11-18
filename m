Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054636;
	b=j+ou2a6ZXdieTGQQtuj6n2EeTkGB+Y8kQgg+uKgAYrlqFbByujVF8mIwgxsKEO6APfhK
	 JUQnOffdnmDN+sSzc96mxcAxMeCHXVJ+fJ4ZPZGXvVDH+aEReZ2b3DN+d7/43B795xKD8
	 yt0QwWIh4X0wNxrCveQt8xVmSXuDqIpPxVBqIHu/2/uioauVuHzc/YxqSsETJGGh2QtE/
	 GDDGI9buvbbsnz5xzirrYDE+PhUk0auDMy/W8JS/Zhbnm7qbO7Q/kbHpirKeWdGia7SbN
	 xrgn9g8SLl06o1pEJFMPD0KNqdxLlOKwTF1M8A5WlYx09a6VTgoEnjg9USqFQARVu+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054636;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=d1ndkO6nxV/CJyOO5u7Ejf80C3k/QY2yIsZZ3UdUxiU=;
	b=4UX2MpmlAEuCUYw8gJszDvTdfaB5+wl76Ab8NI8B8YHS29kfn50d5chrj/jBGwrf1SLB
	 bRNDd1fKoeQ42x9G0uqeJz8Kw9YN17OllDRPtGTYSUCspgTrerZBENSrPVIq//6UskKs7
	 1lb9s7lu62JCMW173t8j8BtcXUR1lC8Cl2cuatoYWrFRoZzAPd3HK0nEInEJKEcDzc6bs
	 mjnal1XrjZlu0e5qEgBMdUOQpRy3uurKQ0YgHtNeglTeOlAI9iwadI9QDYPF2qIIfO2lA
	 aMzS7TJ252TE6CfvLmwJI6edsyNT5rxjFtbBhZfAl3XU27VX4gYC56CW5eG3/GeM1tg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Is9qHvEv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DB05606A31C;
	Thu, 19 Nov 2026 02:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Is9qHvEv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5210F1F000C4;
	Thu, 19 Nov 2026 02:17:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054635;
	bh=d1ndkO6nxV/CJyOO5u7Ejf80C3k/QY2yIsZZ3UdUxiU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Is9qHvEvhKqOqGH64Xj+nmU5AqCWqINq3eT+MgLXaN/eIbuFZgCX6k1hWeYODiAyr
	 zGfxOcMqTJtR2x9tbCm7nLA5YXujPmupYRwPlakLE6dVtsTgKFvdriG5Cp7BnYbm73
	 W7VDPQfTn+u09sm45FAOqDo+bhlvVnnjoo1Ndgyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1346/2214] perf jitdump: Bounds-check debug entry byte-swap loop
Date: Wed, 18 Nov 2026 15:50:22 +0100
Message-ID: <20261118150105.300953862@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index e15cf845fa86d..12337ff564ece 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -323,14 +323,32 @@ jit_get_next_entry(struct jit_buf_desc *jd)
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



