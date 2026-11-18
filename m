Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060269;
	b=nC+n+dTnFbCR6R2FJDljhsSrgSEEsqJW5K/Il94eSRAl/FilxwZ2i/Eq5SyuG8DCxqNT
	 6DcqMQQ61rAT1PWDkpdN1gwGvTlwrzheCTskaBGIOxOqY+1TxDh/oHupO4P8MI1GwMS4t
	 x+GV0JAK4QHFwAvkXiIr1n7G6+pnJlKHj1+qnKHZD/CQUrEqNfOjOAyk/2Khj3lvZmPzs
	 /GuF/ee+XV9sWRCtJvUNnh18W3usOK4VkzEOEVcBeqhKiPBXFoA0EShg5AbJoXZFnpW89
	 oMBOkW8+jWfKDyjbB1HWat+6L4gR6zrn9APpZmkW4/3+azKKdqx7c0FCEsNFHWFZZBQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060269;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HuwzML0SV7hV2k0cnSIktVwJgpalsiHTIIicpqIIOYI=;
	b=aK1kwgiDn9iJzuV1M1Gq1/4MZMFVLW/qmYl+2Wb9qDck+krbyp1D0dnhD+FTxNMHQG3v
	 jdz4xRPS4DmpqQ5clwv9Iv0QDGAfELMA5blLQmuBX50KqXNXkRu4APOQQVZlNZuEzJ6/U
	 qSRxAFyJAjIWGg+qSfLxSvX+Vz9ueJJ5XMAEFI+XPkl+QEq/0ZsoEybS6cpiARgu09Bze
	 lDFLM8VYxl6KZdsbL/HIKqC10tM+jCHk7bietR/fhjvCjupTAOTrVn8ay0p1vIOUiHnuh
	 CqP33U/ahxCBwGYWYthph+YgPnZWdsEBqk92rANuDfWJSZ4LAhi8G5nY57Zp6QMLWSg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qgsd3f8q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D2AF606A320;
	Thu, 19 Nov 2026 03:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Qgsd3f8q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CAE1F000C4;
	Thu, 19 Nov 2026 03:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060269;
	bh=HuwzML0SV7hV2k0cnSIktVwJgpalsiHTIIicpqIIOYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qgsd3f8qBmlaHtR1/qHFp+SyPFsF2ELUsRay2zZjywEkG2A0R9SyumPvOyeRWSHrm
	 GQswoQUSoo5on8WZ82oEurjaJCFiHv+dLuNN2oITR8P/E6avGJ20+SBoozjH4WItay
	 9zdIzAlJ0N+5dRd8glb3ayT+aj1xJJC+B5RcM9Co=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1137/1848] perf jitdump: Bounds-check debug entry byte-swap loop
Date: Wed, 18 Nov 2026 15:52:55 +0100
Message-ID: <20261118150007.142500702@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index f3d284a6a1473..c928f5a22a201 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -310,14 +310,32 @@ jit_get_next_entry(struct jit_buf_desc *jd)
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



