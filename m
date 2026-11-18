Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047746;
	b=jCedrnSEDAocQBjwgRwS6JcUxl8AubEw14jeEVg4Wx5rRboVIoOlu2JI1i11Ht9r7q4I
	 O4YYqBi7Mz0KtJVKUIgjgKL3KBT80aGWcmBFnxpGj9/bP8YNIG0uTcb42SLAgQu8yS0zW
	 LvE9yA9sJGFIX6bIpjiJ5Bt9H+bEz9Mv03ArDfcx79Hhu36UGesuFNgiYrHqttWIOPe9O
	 dsTMRh55GPfSCDDsbYH2SXi2DEgaesYwhV2P3V5jE02l/PKUSb7HvpQqBjFOwPk5WuXWP
	 PN5jVN77TO1X4RtsnFpIeC2twDBaLTzfjx/pkRccecPk+yyAZPjNbr39DOvNvZM3T5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047746;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=npdRiXj3EVC+WCieTm3bgIeTQpU+DPH4Ozbny9Uwk80=;
	b=5IpdUAv0ULs3xik+8QIuEZV0PObcc27JCPse5y7Dx/LKWm64lb54FS0JvnPdVkHHwtNf
	 qx03rde0YDT+eZaC0Ie9P5ZQJONiikglbhI3puEWwmVyM6X/icj7lI5lpx0ogyvJLbg+U
	 Bi+c7rvZ3Riu9UdsJZJ5XPF+LgEX2jao32oi/IKJf7o1WDbl4zRWzuKrNSA1gA+CP1eAq
	 Yhvt7R7eZFAc6+suj0aKXwuNwBRZKD+B0fcJomtIjmpXfzlcH9R/rVKCmdyibvQjX04AR
	 MTyJNdzSluv70ZRR5RL2d63NFeMbtA+ISBxMTYdAs0cURzaH33iEVaxHTQN8hsV1z0Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="jji/pDaY";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB514606A325;
	Thu, 19 Nov 2026 00:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jji/pDaY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06F131F000C4;
	Thu, 19 Nov 2026 00:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047746;
	bh=npdRiXj3EVC+WCieTm3bgIeTQpU+DPH4Ozbny9Uwk80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jji/pDaYWh2fY7JJIDD7BQBBwOj1PcygneRRv8wwE34e4BXUVDMybAtmh263MemNO
	 yoMGIvu/p5s2Zl5L10BMH88qrzhas2oAw961I96m5P/LGHJGjtbCk/cmZ5GAM7vBhD
	 Nlg9TGA9mqfmZ/FeLO1uFnv0WPL31h8BHl1lkXOY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1749/2857] perf jitdump: Bounds-check debug entry byte-swap loop
Date: Wed, 18 Nov 2026 15:46:23 +0100
Message-ID: <20261118150304.273487261@linuxfoundation.org>
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
index 9a7cc81f371af..d7f58e22f40f0 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -316,14 +316,32 @@ jit_get_next_entry(struct jit_buf_desc *jd)
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



