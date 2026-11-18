Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015417;
	b=QPj6jDCUs3lao9/+rQSvgZJDdeduFiU3v960tfZJ1XAD/E8Ex50b1Pko3fat6pd/7Fg2
	 O77QYEBX0LpQthdo+wmLg7Eg6iACZ6nS7seXpqcl4vl8jVFq3KOYu22lYZv9VjesmMjSu
	 OKcSiV65VuovhI9+JVvL0SrovdeJ4wXztSsBRq5fGGL/COLB8j10rqDuzOuYmj17S7JPi
	 cfAHMZ2J/cP6Os73s45hDejz+jKiOrAw3FU3qEo0cSW8FTmO6n4Ctwn+YVMFfy7CFMtDa
	 r4PNMfBq8gjgpN2rVKYshJB4rgz/19XlpIFqgGvDw1sXMhDE0GeXKQK52H7taag40pw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015417;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=22bl9eMSECejthkaJZW79YVK1vr1b/UGb3HhZRRahCU=;
	b=mof80eyOu8j/cmXwHh+MgNkxRT4hVLVJ/r6X3VbSdzLuMXbkPmgP3uDcCq9WceJNLJHJ
	 c3fOttUNJKetjCzf9A0t618eVuJ+bSZO8J5YUGDEJyajp/VcpLWxbujGbm++lneGwgrR3
	 amNR4CNomWKqgLkQmP3EUiWVOOMj+iKadKWFJXPB3q6pxFxkxIz7Y4wB2QUX1Xxk+lRrk
	 e9+v0EgpbImBn5gbDMnKACORktrUVDDztZNS73aazQ+Gufx0REseGnuk8saIExeTd5bFu
	 4rFoOD7sS/ONpYviZrNQ2S7O7pUurHEuukGkz3vWUqZOAyAZ/78sH/sOZ7R2AuIVNLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXMOUfNZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EC8F60A260C;
	Wed, 18 Nov 2026 15:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hXMOUfNZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA78D1F000C4;
	Wed, 18 Nov 2026 15:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015417;
	bh=22bl9eMSECejthkaJZW79YVK1vr1b/UGb3HhZRRahCU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hXMOUfNZPDU3fwzx7B5H45CsxwBbuRX5PV5OQLIvFvc8Oalmbs96fGTkjhXoSELGN
	 JUDn1JOL8joPPA+57p+SvGUdf1aj5YmMwkPQFxRW9TJQNW7XISolqL7ZnWUTKFhIZd
	 +kG7X12olID+ax3yrHHFDKiWtYJiXCHDaRqklXQ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0115/2651] perf jitdump: Validate debug entries on native (non-swap) path
Date: Wed, 18 Nov 2026 15:22:35 +0100
Message-ID: <20261118150252.019680293@linuxfoundation.org>
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
index d3de307532d55..5a3ea2681fb37 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -694,8 +694,10 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 
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
@@ -715,10 +717,25 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



