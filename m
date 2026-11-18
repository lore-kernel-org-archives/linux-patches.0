Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039302;
	b=jNxb+YGoOTqXvcyis9AQ+ZSa3Qv8bp7hcol0it1f4MlCNoSjzlFdGzKlysI/grjaaLXH
	 Fz12MOqoDDZtTuqBot0jpLc64ShBbvnI448ywIMvX4KCrFGfSayrKbOwTAnbjr+aSK6B1
	 8akTNvPSyylxa9cYBWfBguuVA8aAm0+dJBvX8am5g/WRGFF28ne06g4asKYsUch5dvckd
	 nYB7mM7h3N71v9ym0WoJHCJd+JOYSoU8HQY1AKyABUqFRvFjzrejWBQGEkUXswUQ/s8np
	 o2cwyr/Hax+DpToBLd5oPt/pU0QaE7VlaN1Z6w1yI8KMoEGYwYbvU5uDC4RI4JBI6pQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039302;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=NpKJmvXTj4a5GGeJHsLaXmpZ3Ab5pQxQ/wb9vymztiY=;
	b=Etxm86lSDY3PUW1sKmwUC4wQkWoOn0Xt8zQ/8Cp0qX2Ix8QVdng0yOGHrhzsqIjw31TM
	 q0WihdhNzF65bqbGJJsdiGE2m4jD45ZFn0IphjjhgT9qdABj8ryPRXXmonF5VEgOKOuKk
	 Ecpwt1UxszZoAsQ85+tbdMx+S2EVBB+lR2OoSjAUC3s/e4FFFSYbz7oo8AH/lqm7d3+bB
	 0Rt57swcmThrhc2UAn8Fr6CfVP4ZKqhWYPBLdzYCU/uZ+i9tRP/FWWdR61i/ZnyM9uoHA
	 33lFkr6VfsBms58VkVpMJ4orBwPfsG6tcXIdzAtB4vRgCIl744/oCESJLXNftojqaRQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDkf+tCN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E54A606A31C;
	Wed, 18 Nov 2026 22:01:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sDkf+tCN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBF081F000C7;
	Wed, 18 Nov 2026 22:01:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039302;
	bh=NpKJmvXTj4a5GGeJHsLaXmpZ3Ab5pQxQ/wb9vymztiY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sDkf+tCNHZS8/prZpFBtf84T5l+KCmBwWKTFkMlL/98GjRHzR45ejbCwaodLNZ+xV
	 +TCo9ifIYxmPcThctsB2CjzFrS/Q3cuqXClJk7xB2a709zpBSkl11CncYLOo3PiKZ6
	 Z25wELcSMcc0Tud9EKZaZVuQy/sbSCYmQHf0nfdg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2011/3318] perf jitdump: Validate debug entries on native (non-swap) path
Date: Wed, 18 Nov 2026 15:43:53 +0100
Message-ID: <20261118150422.375860804@linuxfoundation.org>
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
index f6467cc7d27b9..2f8c4045c7ba5 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -675,8 +675,10 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 
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
@@ -696,10 +698,25 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



