Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795029060;
	b=frvhhCfbo2vn3GQvI+Y4q3RL07LArJh6c/YwW33Q/X5DiO5UOVYL7MOnjwCrs44Qap1s
	 govpOOg2CG4v1KQZk2c7pbmjHmF3j74Z52jXPXnD+CrMeDsaDKflY2pnU6wWuPIKzPIg0
	 t13TRjk58bYH1Ko2vsN3bKVeRkXXHTnI8fE8N3Cv/oliaycC5A2V3IT26nrpjKED5nCDs
	 HqBaVdmYG3fpJUsVcVPRu+p4nwlXXRJbpF9rQiz8/V8jwPaGixCM32NwmTI9QkzYkDRt6
	 LiyZiLRFdVZY2nhsw609/Ad6jyiTOoRe8Z/rPtIXi3hvskjb3gLcyR9tYHsRp06Ex5g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795029060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=gDzHztrNR5Rg3khvPoMDbxrnH5yjtRG1w+bFRGWUI9g=;
	b=Sykd1XmJtF74cSy4PxHRrFUzHqFcBNulcRJfhJyEfSUYQtzRmF2cvA5gzGMgaqf9rv4X
	 NDG83ChygO2MNuNfUQSVg0RV1CcW0xLLdOLxFl2SKxiTgZVH8vvwyws4AM75sdhaslu4B
	 QzEubC6Kyx3RFLDLtxM2SQk8xS1Ouc7Kte+SUFFni44KjCNc4EIJJvXGDAVVFLFlFn5aC
	 v4MHcnO7QRlXWqrOL/A+XY6/YWXBw6LbsmM+0J+9Do1+clSPJVhZgTdAHJBPilGwb616t
	 utz8yJH3oGL8L1qRzxJNlXNw1Cwjh3FTgLpD99tBDuxqVq9bdOECHUlS5N95hQO2b/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTDlFngx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95687606A331;
	Wed, 18 Nov 2026 19:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gTDlFngx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E43671F000C4;
	Wed, 18 Nov 2026 19:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795029060;
	bh=gDzHztrNR5Rg3khvPoMDbxrnH5yjtRG1w+bFRGWUI9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gTDlFngxnJNpvIYED5loWpLM4Xf/v8WCNm1viaRFumob1aWvD4Rdz4G5WhhTxeMvy
	 0fvXriGNsANfdQ7V25Kx+4tzHfZ3j6DXqKhxOwMjMNlM3mxZgslja8Fgd4Pe3RfzPy
	 KcYS/VjFr2dHIfAc73A75DY7pSsSXEmZ8CMG3rxE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0166/1756] perf jitdump: Bounds-check debug entry byte-swap loop
Date: Wed, 18 Nov 2026 15:38:13 +0100
Message-ID: <20261118150014.903566854@linuxfoundation.org>
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
index 96e728b49af5a..800a888081e60 100644
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



