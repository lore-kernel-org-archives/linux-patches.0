Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054655;
	b=4vFTQPGjRcbzA7TaA0H8gbyazBr+VX9hjiRgaUMBoCBGSgODV2GoZXhGPRV9HUDPWPvv
	 YXDyEzQRY8SMI0s++Z+mq0imG3UgqAcuZ7NU5SNjFSXI+uGfkxoHO1JY0wGXZpkwnFemp
	 Xa5HWCgocTtafjJ2C5Qkfjaj7EB/IkSMSTwpDoxYkRIbnXcPK9TdNGWscPj23MUZIToLM
	 J4cklgBmSIPXmmo0Ut+1KSuILBosq8dImQLiTewbaiJ0gOJtknxvkY8K24by74OzgWwm4
	 1GR7OE+WV5iY0ifsPxEFCElkeDVF9adJekDm2tUYqglwuB43QDol1YLs1iF4HTMxubQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FGao6R/UMw9pAaqZc3qKCZ2dcXNS7PDfpYgONP1pBso=;
	b=vsVE995lycmQ/bPM9IxCGspTI6+2TqbcgtYV3VZb9RsNbdv42NQZdGrTWvZZSY8F/veL
	 acG1WkPV+uc+8kzB8j3DfXQdM0+L76fdNf+vRrj3yUKAjITC+kQ2zBn8Zs1XmJislRxU+
	 1mqaIq5ECGbvcQT2UCFsIslmaV3EA1hmpjqxRi01hjHOlzOR4OGkh/v6qDxSUeZKJmdVz
	 VxLGq9RZpxeW5AOop+uX85UoWU+2k5TBwuaxd4pLA7CSUFT0F03Nev26aC/9ejLpsdVMC
	 G7Boxx1fHtyWdayETyMHcWeTXdwLxv+vNecqEE+dcUuQuqpI/J+9Sq8VG4BP1DP7H1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K127qQGU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 060CE606A31C;
	Thu, 19 Nov 2026 02:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K127qQGU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBB21F000C4;
	Thu, 19 Nov 2026 02:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054654;
	bh=FGao6R/UMw9pAaqZc3qKCZ2dcXNS7PDfpYgONP1pBso=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K127qQGUgKSkNk+AA8U07ZqofT+ZOwkXHco3SL+72S+F9LWvhfa7cw8utWheTAQet
	 SHGvf9505TiYgD6ibXpPgyoyqSQ+uQ/M1CjLHFGfOY/vkAFAIlxgRAKM0uhRCXUoyG
	 T4z93YYTpYy602kBGMa0cVaoOufHXk3etovU8roo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1352/2214] perf jitdump: Validate debug entries on native (non-swap) path
Date: Wed, 18 Nov 2026 15:50:28 +0100
Message-ID: <20261118150105.524852858@linuxfoundation.org>
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
index 3577098b1fe6b..2a14161702449 100644
--- a/tools/perf/util/jitdump.c
+++ b/tools/perf/util/jitdump.c
@@ -683,8 +683,10 @@ static int jit_repipe_code_move(struct jit_buf_desc *jd, union jr_entry *jr)
 
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
@@ -704,10 +706,25 @@ static int jit_repipe_debug_info(struct jit_buf_desc *jd, union jr_entry *jr)
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



