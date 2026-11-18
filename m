Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060287;
	b=3Wdgys9oDIXrJm6kjfAFHAA0Vjyg8734BCF7qLunAGC5ocbD6tq2RuO8+BW29WXVILhz
	 utUbF9iqHVmw30i7fB+ElYGf/4MbAyytUI/WDa65lB+o91kjqwpjRCPyU2RWAyt9VGBFc
	 7rj64ORKM59IvyoKlvu4sbW6R84W2n/ROXL0pMjjkAVp790UW4Y5Th1WlrZX8byNbcb5W
	 YcGNuC9uCVcd3pnKyl+ZID6rbokglPri1/RadpAqPElc/H9a4ReUPC/LN9M2/kX9jPrEz
	 6vDPq33w9EXdqOd0gnxwZhRj2yZllrZMNqeCVnlZHU3KFsOuEPBy6BhgDeiwhM5ismg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f/gOGDeNxYLco55rIZq2wRczvzIob8DyyEsVeXkazQs=;
	b=hTyJ3JuZZM6yoU3/JVwSl/84HLB36amXQN3mK7ITqA2LyLewwws3xGyjev+jx+rTl0wj
	 7ofZO43tQ4wD6dG7lLb26Gb+MEf/6sSC2RyHQJfqWcJg/Ypo/i8EPt7k9bKyam41j7OdX
	 ShkcckMzAlzGN7t1C/5fmwaRBHj2ZpzG10ps22Xq6HH+5qO594kj/UgWLbGnrfKylgYzU
	 au6SxkrkiFLs7CiDlmfC3Gcn/BEkb04il+436R06oGV2Rqp3cj048+se03VtXA20kW2xw
	 N7gVU1vw5OsG+EoTDzjqRn9K8ckGiYJpUTPnYh0vINcQoWzFoXmPxGoB9MCCXOFHzLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LPsjSrvI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB267606A32A;
	Thu, 19 Nov 2026 03:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LPsjSrvI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 483301F000C5;
	Thu, 19 Nov 2026 03:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060287;
	bh=f/gOGDeNxYLco55rIZq2wRczvzIob8DyyEsVeXkazQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPsjSrvIEcqYQZ6UGrrTPlqep56/ieNFuzTUNKihwt7TMz0eu6XtfnuYFmcAayOOq
	 O8IXZZtaXPPiF/tZchlVvlOCILNabLBftxx5fDyjasFYI1Cfsd+vEjBG76vlxXEPnB
	 Pn6Y/pFlV34vhHu/3glIgeKRcmvcJujM5AyErURE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot <sashiko-bot@kernel.org>,
	Ian Rogers <irogers@google.com>,
	Stephane Eranian <eranian@google.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1144/1848] perf jitdump: Validate debug entries on native (non-swap) path
Date: Wed, 18 Nov 2026 15:53:02 +0100
Message-ID: <20261118150007.575270780@linuxfoundation.org>
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



